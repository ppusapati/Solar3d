package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"strings"
	"time"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "p9e.in/samavaya/solar3d/gen/common/v1"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"
	"google.golang.org/protobuf/proto"

	sharedcad "p9e.in/samavaya/packages/cad"
)

var (
	ErrInvalidInput = errors.New("invalid input")
	ErrNotFound     = errors.New("not found")
	ErrConflict     = errors.New("conflict")
)

const (
	ConflictCodeStaleRevision = "stale_revision"
)

type ConflictError struct {
	Code           string
	OutcomeCode    string
	Message        string
	AttemptID      string
	BaseRevisionID string
	HeadRevisionID string
	HeadVersion    uint32
	RetryAfterMs   int
}

func (e *ConflictError) Error() string {
	if e == nil {
		return ErrConflict.Error()
	}
	if strings.TrimSpace(e.Message) != "" {
		return fmt.Sprintf("%s: %s", ErrConflict.Error(), e.Message)
	}
	return ErrConflict.Error()
}

func (e *ConflictError) Unwrap() error {
	return ErrConflict
}

type Service struct {
	revisions      drawingv1connect.DrawingRevisionServiceClient
	cad            drawingv1connect.CadCoreServiceClient
	logger         zerolog.Logger
	requestTimeout time.Duration
}

type annotationMetadata struct {
	Annotation struct {
		Kind         string                           `json:"kind"`
		Associations []*drawingv1.AnnotationReference `json:"associations,omitempty"`
	} `json:"annotation"`
}

func New(revisions drawingv1connect.DrawingRevisionServiceClient, cadClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, requestTimeout time.Duration) *Service {
	return &Service{
		revisions:      revisions,
		cad:            cadClient,
		logger:         logger.With().Str("component", "service").Logger(),
		requestTimeout: requestTimeout,
	}
}

func (s *Service) CreateAnnotation(ctx context.Context, req *drawingv1.CreateAnnotationRequest) (*drawingv1.CreateAnnotationResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	if _, err := sharedcad.ParseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if err := sharedcad.ValidateJSON(req.GetMetadataJson(), "metadata_json"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}

	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetBaseRevisionId())
	if err != nil {
		return nil, err
	}
	if err := sharedcad.RequireLayerWritable(sharedcad.LayerDefinitions(state.GetRevision().GetEntities()), req.GetLayerId()); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrConflict, err)
	}

	entity, err := buildAnnotationEntity(req)
	if err != nil {
		return nil, err
	}
	response, err := s.commit(ctx, req.GetDrawingId(), req.GetBaseRevisionId(), req.GetAuthor(), defaultSummary(req.GetSummary(), entity), req.GetContract(), []*drawingv1.DrawingMutation{sharedcad.CreateMutation(entity)})
	if err != nil {
		return nil, err
	}
	return &drawingv1.CreateAnnotationResponse{Drawing: response.GetDrawing(), Revision: response.GetRevision(), AnnotationEntity: entity}, nil
}

func (s *Service) RegenerateAssociativeAnnotations(ctx context.Context, req *drawingv1.RegenerateAssociativeAnnotationsRequest) (*drawingv1.RegenerateAssociativeAnnotationsResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("%w: request is required", ErrInvalidInput)
	}
	if _, err := sharedcad.ParseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}

	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetBaseRevisionId())
	if err != nil {
		return nil, err
	}
	entitiesByID := sharedcad.EntityIndex(state.GetRevision().GetEntities())
	mutations := make([]*drawingv1.DrawingMutation, 0)
	updated := make([]*drawingv1.DrawingEntity, 0)
	violations := make([]string, 0)

	for _, entity := range state.GetRevision().GetEntities() {
		if entity == nil || entity.GetHeader() == nil || strings.TrimSpace(entity.GetHeader().GetEntityId()) == "" {
			continue
		}
		metadata, ok, parseErr := parseAnnotationMetadata(entity.GetHeader().GetMetadataJson())
		if parseErr != nil {
			violations = append(violations, fmt.Sprintf("entity %s metadata parse failed", entity.GetHeader().GetEntityId()))
			continue
		}
		if !ok || len(metadata.Annotation.Associations) == 0 {
			continue
		}
		nextEntity, changed, regenViolations := regenerateEntity(entity, metadata, entitiesByID)
		if len(regenViolations) > 0 {
			violations = append(violations, regenViolations...)
		}
		if !changed {
			continue
		}
		mutations = append(mutations, sharedcad.UpdateMutation(entity, nextEntity))
		updated = append(updated, nextEntity)
	}

	if len(mutations) == 0 {
		return &drawingv1.RegenerateAssociativeAnnotationsResponse{
			Drawing:            state.GetDrawing(),
			Revision:           state.GetRevision(),
			UpdatedAnnotations: updated,
			Violations:         violations,
		}, nil
	}

	commitResponse, err := s.commit(ctx, req.GetDrawingId(), req.GetBaseRevisionId(), req.GetAuthor(), defaultRegenSummary(req.GetSummary()), req.GetContract(), mutations)
	if err != nil {
		return nil, err
	}
	return &drawingv1.RegenerateAssociativeAnnotationsResponse{
		Drawing:            commitResponse.GetDrawing(),
		Revision:           commitResponse.GetRevision(),
		UpdatedAnnotations: updated,
		Violations:         violations,
	}, nil
}

func (s *Service) loadState(ctx context.Context, drawingID string, revisionID string) (*drawingv1.GetDrawingStateResponse, error) {
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.revisions.GetDrawingState(callCtx, connect.NewRequest(&drawingv1.GetDrawingStateRequest{DrawingId: drawingID, RevisionId: revisionID}))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func (s *Service) commit(ctx context.Context, drawingID string, baseRevisionID string, author string, summary string, contract *commonv1.ContractMetadata, mutations []*drawingv1.DrawingMutation) (*drawingv1.CommitDrawingCommandResponse, error) {
	callCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	response, err := s.cad.CommitDrawingCommand(callCtx, connect.NewRequest(&drawingv1.CommitDrawingCommandRequest{
		BaseRevisionId: baseRevisionID,
		Summary:        summary,
		Command: &drawingv1.DrawingCommand{
			CommandId: uuid.NewString(),
			DrawingId: drawingID,
			Actor:     author,
			Mutations: mutations,
			Contract:  sharedcad.DefaultContract(contract, "cad-annotation-service"),
		},
	}))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func buildAnnotationEntity(req *drawingv1.CreateAnnotationRequest) (*drawingv1.DrawingEntity, error) {
	annotation := req.GetAnnotation()
	if annotation == nil || annotation.Kind == nil {
		return nil, fmt.Errorf("%w: annotation payload is required", ErrInvalidInput)
	}
	entityID := uuid.NewString()
	contract := sharedcad.DefaultContract(req.GetContract(), "cad-annotation-service")
	metadataJSON, err := annotationMetadataJSON(req.GetMetadataJson(), annotation)
	if err != nil {
		return nil, fmt.Errorf("%w: metadata_json merge failed: %v", ErrInvalidInput, err)
	}

	entity := &drawingv1.DrawingEntity{Header: sharedcad.NewHeader(req.GetDrawingId(), entityID, drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_UNSPECIFIED, req.GetLayerId(), req.GetLayerName(), req.GetStyleId(), req.GetStyleName(), metadataJSON, contract)}
	switch kind := annotation.Kind.(type) {
	case *drawingv1.AnnotationSpec_Text:
		if strings.TrimSpace(kind.Text.GetText()) == "" || kind.Text.GetHeight() <= 0 {
			return nil, fmt.Errorf("%w: text annotation requires text and positive height", ErrInvalidInput)
		}
		entity.Header.EntityType = drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_TEXT
		entity.Geometry = &drawingv1.DrawingEntity_Text{Text: &drawingv1.TextEntity{
			Anchor:      proto.Clone(kind.Text.GetAnchor()).(*commonv1.Point2D),
			Text:        kind.Text.GetText(),
			RotationDeg: kind.Text.GetRotationDeg(),
			Height:      kind.Text.GetHeight(),
			FontFamily:  kind.Text.GetFontFamily(),
		}}
	case *drawingv1.AnnotationSpec_Dimension:
		entity.Header.EntityType = drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_DIMENSION
		entity.Geometry = &drawingv1.DrawingEntity_Dimension{Dimension: &drawingv1.DimensionEntity{
			Start:      proto.Clone(kind.Dimension.GetStart()).(*commonv1.Point2D),
			End:        proto.Clone(kind.Dimension.GetEnd()).(*commonv1.Point2D),
			TextAnchor: proto.Clone(kind.Dimension.GetTextAnchor()).(*commonv1.Point2D),
			Unit:       kind.Dimension.GetUnit(),
			Precision:  kind.Dimension.GetPrecision(),
		}}
	case *drawingv1.AnnotationSpec_Leader:
		if len(kind.Leader.GetVertices()) < 2 {
			return nil, fmt.Errorf("%w: leader requires at least two vertices", ErrInvalidInput)
		}
		entity.Header.EntityType = drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_LEADER
		entity.Geometry = &drawingv1.DrawingEntity_Leader{Leader: proto.Clone(&drawingv1.LeaderEntity{
			Vertices:   kind.Leader.GetVertices(),
			Text:       kind.Leader.GetText(),
			TextHeight: kind.Leader.GetTextHeight(),
			ArrowHead:  kind.Leader.GetArrowHead(),
		}).(*drawingv1.LeaderEntity)}
	default:
		return nil, fmt.Errorf("%w: unsupported annotation type", ErrInvalidInput)
	}
	return entity, nil
}

func annotationMetadataJSON(base string, annotation *drawingv1.AnnotationSpec) (string, error) {
	meta := map[string]any{"annotation": map[string]any{}}
	annotationMap := meta["annotation"].(map[string]any)
	switch kind := annotation.Kind.(type) {
	case *drawingv1.AnnotationSpec_Text:
		annotationMap["kind"] = "text"
	case *drawingv1.AnnotationSpec_Dimension:
		annotationMap["kind"] = "dimension"
		annotationMap["associations"] = associationsToMetadata(kind.Dimension.GetAssociations())
	case *drawingv1.AnnotationSpec_Leader:
		annotationMap["kind"] = "leader"
		annotationMap["associations"] = associationsToMetadata(kind.Leader.GetAssociations())
	}
	return sharedcad.MergeMetadata(base, meta)
}

func associationsToMetadata(associations []*drawingv1.AnnotationReference) []map[string]any {
	encoded := make([]map[string]any, 0, len(associations))
	for _, association := range associations {
		if association == nil {
			continue
		}
		encoded = append(encoded, map[string]any{
			"entity_id":   association.GetEntityId(),
			"entity_type": association.GetEntityType().String(),
		})
	}
	return encoded
}

func parseAnnotationMetadata(raw string) (*annotationMetadata, bool, error) {
	if strings.TrimSpace(raw) == "" || strings.TrimSpace(raw) == "{}" {
		return nil, false, nil
	}
	var meta annotationMetadata
	if err := json.Unmarshal([]byte(raw), &meta); err != nil {
		return nil, false, err
	}
	if meta.Annotation.Kind == "" {
		return nil, false, nil
	}
	return &meta, true, nil
}

func regenerateEntity(entity *drawingv1.DrawingEntity, metadata *annotationMetadata, entitiesByID map[string]*drawingv1.DrawingEntity) (*drawingv1.DrawingEntity, bool, []string) {
	points, violations := resolveAssociations(metadata.Annotation.Associations, entitiesByID)
	if len(points) == 0 {
		return nil, false, violations
	}
	next := sharedcad.CloneEntity(entity)
	switch geometry := next.Geometry.(type) {
	case *drawingv1.DrawingEntity_Text:
		geometry.Text.Anchor = proto.Clone(points[0]).(*commonv1.Point2D)
	case *drawingv1.DrawingEntity_Dimension:
		if len(points) < 2 {
			return nil, false, append(violations, fmt.Sprintf("entity %s requires at least two reference points", entity.GetHeader().GetEntityId()))
		}
		geometry.Dimension.Start = proto.Clone(points[0]).(*commonv1.Point2D)
		geometry.Dimension.End = proto.Clone(points[1]).(*commonv1.Point2D)
		geometry.Dimension.TextAnchor = &commonv1.Point2D{X: (points[0].GetX() + points[1].GetX()) / 2, Y: (points[0].GetY()+points[1].GetY())/2 + 0.75}
	case *drawingv1.DrawingEntity_Leader:
		if len(points) == 1 {
			geometry.Leader.Vertices[0] = proto.Clone(points[0]).(*commonv1.Point2D)
		} else {
			geometry.Leader.Vertices[0] = proto.Clone(points[0]).(*commonv1.Point2D)
			geometry.Leader.Vertices[len(geometry.Leader.GetVertices())-1] = proto.Clone(points[len(points)-1]).(*commonv1.Point2D)
		}
	default:
		return nil, false, violations
	}
	if proto.Equal(entity, next) {
		return nil, false, violations
	}
	return next, true, violations
}

func resolveAssociations(associations []*drawingv1.AnnotationReference, entitiesByID map[string]*drawingv1.DrawingEntity) ([]*commonv1.Point2D, []string) {
	points := make([]*commonv1.Point2D, 0, len(associations))
	violations := make([]string, 0)
	for _, association := range associations {
		if association == nil || strings.TrimSpace(association.GetEntityId()) == "" {
			continue
		}
		entity, ok := entitiesByID[association.GetEntityId()]
		if !ok {
			violations = append(violations, fmt.Sprintf("association %s not found", association.GetEntityId()))
			continue
		}
		referencePoints, ok := sharedcad.EntityReferencePoints(entity)
		if !ok || len(referencePoints) == 0 {
			violations = append(violations, fmt.Sprintf("association %s has no reference geometry", association.GetEntityId()))
			continue
		}
		points = append(points, referencePoints[0])
		if len(referencePoints) > 1 {
			points = append(points, referencePoints[1])
		}
	}
	return points, violations
}

func defaultSummary(summary string, entity *drawingv1.DrawingEntity) string {
	trimmed := strings.TrimSpace(summary)
	if trimmed != "" {
		return trimmed
	}
	if entity == nil || entity.GetHeader() == nil {
		return "Create annotation"
	}
	return fmt.Sprintf("Create %s annotation %s", strings.ToLower(strings.TrimPrefix(entity.GetHeader().GetEntityType().String(), "DRAWING_ENTITY_TYPE_")), entity.GetHeader().GetEntityId())
}

func defaultRegenSummary(summary string) string {
	trimmed := strings.TrimSpace(summary)
	if trimmed != "" {
		return trimmed
	}
	return "Regenerate associative annotations"
}

func translateConnectError(err error) error {
	var connectErr *connect.Error
	if !errors.As(err, &connectErr) {
		return err
	}
	switch connectErr.Code() {
	case connect.CodeInvalidArgument:
		return fmt.Errorf("%w: %v", ErrInvalidInput, connectErr.Message())
	case connect.CodeNotFound:
		return fmt.Errorf("%w: %v", ErrNotFound, connectErr.Message())
	case connect.CodeAlreadyExists, connect.CodeAborted, connect.CodeFailedPrecondition:
		if conflictErr := conflictFromConnectError(connectErr); conflictErr != nil {
			return conflictErr
		}
		return fmt.Errorf("%w: %v", ErrConflict, connectErr.Message())
	default:
		return err
	}
}

func conflictFromConnectError(connectErr *connect.Error) *ConflictError {
	if connectErr == nil {
		return nil
	}
	code := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-error-code"))
	outcomeCode := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-outcome-code"))
	attemptID := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-attempt-id"))
	baseRevisionID := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-base-revision-id"))
	headRevisionID := strings.TrimSpace(connectErr.Meta().Get("x-solar3d-head-revision-id"))
	headVersion := parseHeaderUint32(connectErr.Meta().Get("x-solar3d-head-version"))
	retryAfterMs := parseRetryAfterMs(connectErr.Meta().Get("retry-after"))

	if code == "" && strings.Contains(strings.ToLower(connectErr.Message()), "stale") {
		code = ConflictCodeStaleRevision
	}
	if code == "" && outcomeCode == "" && attemptID == "" && baseRevisionID == "" && headRevisionID == "" && headVersion == 0 && retryAfterMs == 0 {
		return nil
	}

	return &ConflictError{
		Code:           code,
		OutcomeCode:    outcomeCode,
		Message:        connectErr.Message(),
		AttemptID:      attemptID,
		BaseRevisionID: baseRevisionID,
		HeadRevisionID: headRevisionID,
		HeadVersion:    headVersion,
		RetryAfterMs:   retryAfterMs,
	}
}

func parseRetryAfterMs(value string) int {
	seconds, err := strconv.ParseFloat(strings.TrimSpace(value), 64)
	if err != nil || seconds <= 0 {
		return 0
	}
	return int(seconds * 1000)
}

func parseHeaderUint32(value string) uint32 {
	parsed, err := strconv.ParseUint(strings.TrimSpace(value), 10, 32)
	if err != nil {
		return 0
	}
	return uint32(parsed)
}

