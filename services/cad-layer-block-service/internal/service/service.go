package service

import (
	"context"
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

func New(revisions drawingv1connect.DrawingRevisionServiceClient, cadClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, requestTimeout time.Duration) *Service {
	return &Service{revisions: revisions, cad: cadClient, logger: logger.With().Str("component", "service").Logger(), requestTimeout: requestTimeout}
}

func (s *Service) UpsertLayer(ctx context.Context, req *drawingv1.UpsertLayerRequest) (*drawingv1.UpsertLayerResponse, error) {
	if req == nil || req.GetLayer() == nil {
		return nil, fmt.Errorf("%w: layer payload is required", ErrInvalidInput)
	}
	if _, err := sharedcad.ParseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if strings.TrimSpace(req.GetLayer().GetLayerId()) == "" || strings.TrimSpace(req.GetLayer().GetName()) == "" {
		return nil, fmt.Errorf("%w: layer_id and name are required", ErrInvalidInput)
	}
	if req.GetLayer().GetLineWeightMm() < 0 {
		return nil, fmt.Errorf("%w: line_weight_mm must be non-negative", ErrInvalidInput)
	}
	if err := sharedcad.ValidateJSON(req.GetMetadataJson(), "metadata_json"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}

	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetBaseRevisionId())
	if err != nil {
		return nil, err
	}
	entityID := "layer:" + req.GetLayer().GetLayerId()
	metadata, err := sharedcad.MergeMetadata(req.GetMetadataJson(), map[string]any{"layer": map[string]any{"managed": true}})
	if err != nil {
		return nil, fmt.Errorf("%w: metadata_json merge failed: %v", ErrInvalidInput, err)
	}
	entity := &drawingv1.DrawingEntity{
		Header: sharedcad.NewHeader(req.GetDrawingId(), entityID, drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_LAYER_DEFINITION, req.GetLayer().GetLayerId(), req.GetLayer().GetName(), "", "", metadata, sharedcad.DefaultContract(req.GetContract(), "cad-layer-block-service")),
		Geometry: &drawingv1.DrawingEntity_LayerDefinition{LayerDefinition: &drawingv1.LayerDefinitionEntity{
			LayerId:      req.GetLayer().GetLayerId(),
			Name:         req.GetLayer().GetName(),
			ColorHex:     sharedcad.NormalizeColorHex(req.GetLayer().GetColorHex()),
			LineType:     strings.TrimSpace(req.GetLayer().GetLineType()),
			LineWeightMm: req.GetLayer().GetLineWeightMm(),
			Visible:      req.GetLayer().GetVisible(),
			Locked:       req.GetLayer().GetLocked(),
			Plottable:    req.GetLayer().GetPlottable(),
		}},
	}
	mutations := []*drawingv1.DrawingMutation{sharedcad.CreateMutation(entity)}
	if existing, ok := sharedcad.EntityIndex(state.GetRevision().GetEntities())[entityID]; ok {
		mutations[0] = sharedcad.UpdateMutation(existing, entity)
	}
	response, err := s.commit(ctx, req.GetDrawingId(), req.GetBaseRevisionId(), req.GetAuthor(), defaultSummary(req.GetSummary(), "layer", req.GetLayer().GetLayerId()), req.GetContract(), mutations)
	if err != nil {
		return nil, err
	}
	return &drawingv1.UpsertLayerResponse{Drawing: response.GetDrawing(), Revision: response.GetRevision(), LayerEntity: entity}, nil
}

func (s *Service) CreateBlockDefinition(ctx context.Context, req *drawingv1.CreateBlockDefinitionRequest) (*drawingv1.CreateBlockDefinitionResponse, error) {
	if req == nil || req.GetBlock() == nil {
		return nil, fmt.Errorf("%w: block payload is required", ErrInvalidInput)
	}
	if _, err := sharedcad.ParseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if strings.TrimSpace(req.GetBlock().GetBlockDefinitionId()) == "" || strings.TrimSpace(req.GetBlock().GetName()) == "" {
		return nil, fmt.Errorf("%w: block_definition_id and name are required", ErrInvalidInput)
	}
	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetBaseRevisionId())
	if err != nil {
		return nil, err
	}
	if err := sharedcad.RequireLayerWritable(sharedcad.LayerDefinitions(state.GetRevision().GetEntities()), req.GetLayerId()); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrConflict, err)
	}
	for _, child := range req.GetBlock().GetEntities() {
		if child == nil || child.GetHeader() == nil {
			return nil, fmt.Errorf("%w: block child entities require headers", ErrInvalidInput)
		}
		if child.GetHeader().GetEntityType() == drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_BLOCK_DEFINITION || child.GetHeader().GetEntityType() == drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_SHEET {
			return nil, fmt.Errorf("%w: nested block definitions and sheets are not allowed in block contents", ErrInvalidInput)
		}
	}
	metadata, err := sharedcad.MergeMetadata(req.GetMetadataJson(), map[string]any{"block": map[string]any{"managed": true}})
	if err != nil {
		return nil, fmt.Errorf("%w: metadata_json merge failed: %v", ErrInvalidInput, err)
	}
	entity := &drawingv1.DrawingEntity{
		Header:   sharedcad.NewHeader(req.GetDrawingId(), "blockdef:"+req.GetBlock().GetBlockDefinitionId(), drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_BLOCK_DEFINITION, req.GetLayerId(), req.GetLayerName(), req.GetStyleId(), req.GetStyleName(), metadata, sharedcad.DefaultContract(req.GetContract(), "cad-layer-block-service")),
		Geometry: &drawingv1.DrawingEntity_BlockDefinition{BlockDefinition: req.GetBlock()},
	}
	response, err := s.commit(ctx, req.GetDrawingId(), req.GetBaseRevisionId(), req.GetAuthor(), defaultSummary(req.GetSummary(), "block definition", req.GetBlock().GetBlockDefinitionId()), req.GetContract(), []*drawingv1.DrawingMutation{sharedcad.CreateMutation(entity)})
	if err != nil {
		return nil, err
	}
	return &drawingv1.CreateBlockDefinitionResponse{Drawing: response.GetDrawing(), Revision: response.GetRevision(), BlockEntity: entity}, nil
}

func (s *Service) InsertBlockReference(ctx context.Context, req *drawingv1.InsertBlockReferenceRequest) (*drawingv1.InsertBlockReferenceResponse, error) {
	if req == nil || req.GetBlockReference() == nil {
		return nil, fmt.Errorf("%w: block_reference payload is required", ErrInvalidInput)
	}
	if _, err := sharedcad.ParseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, err)
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if strings.TrimSpace(req.GetBlockReference().GetBlockDefinitionId()) == "" {
		return nil, fmt.Errorf("%w: block_definition_id is required", ErrInvalidInput)
	}
	if req.GetBlockReference().GetScaleX() <= 0 || req.GetBlockReference().GetScaleY() <= 0 {
		return nil, fmt.Errorf("%w: scale_x and scale_y must be positive", ErrInvalidInput)
	}
	state, err := s.loadState(ctx, req.GetDrawingId(), req.GetBaseRevisionId())
	if err != nil {
		return nil, err
	}
	definitions := sharedcad.BlockDefinitions(state.GetRevision().GetEntities())
	if _, ok := definitions[req.GetBlockReference().GetBlockDefinitionId()]; !ok {
		return nil, fmt.Errorf("%w: block definition %s not found", ErrNotFound, req.GetBlockReference().GetBlockDefinitionId())
	}
	if err := sharedcad.RequireLayerWritable(sharedcad.LayerDefinitions(state.GetRevision().GetEntities()), req.GetLayerId()); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrConflict, err)
	}
	metadata, err := sharedcad.MergeMetadata(req.GetMetadataJson(), map[string]any{"block_reference": map[string]any{"definition_id": req.GetBlockReference().GetBlockDefinitionId()}})
	if err != nil {
		return nil, fmt.Errorf("%w: metadata_json merge failed: %v", ErrInvalidInput, err)
	}
	entity := &drawingv1.DrawingEntity{
		Header:   sharedcad.NewHeader(req.GetDrawingId(), uuid.NewString(), drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_BLOCK_REFERENCE, req.GetLayerId(), req.GetLayerName(), req.GetStyleId(), req.GetStyleName(), metadata, sharedcad.DefaultContract(req.GetContract(), "cad-layer-block-service")),
		Geometry: &drawingv1.DrawingEntity_BlockReference{BlockReference: req.GetBlockReference()},
	}
	response, err := s.commit(ctx, req.GetDrawingId(), req.GetBaseRevisionId(), req.GetAuthor(), defaultSummary(req.GetSummary(), "block reference", entity.GetHeader().GetEntityId()), req.GetContract(), []*drawingv1.DrawingMutation{sharedcad.CreateMutation(entity)})
	if err != nil {
		return nil, err
	}
	return &drawingv1.InsertBlockReferenceResponse{Drawing: response.GetDrawing(), Revision: response.GetRevision(), BlockReferenceEntity: entity}, nil
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
	response, err := s.cad.CommitDrawingCommand(callCtx, connect.NewRequest(&drawingv1.CommitDrawingCommandRequest{BaseRevisionId: baseRevisionID, Summary: summary, Command: &drawingv1.DrawingCommand{CommandId: uuid.NewString(), DrawingId: drawingID, Actor: author, Mutations: mutations, Contract: sharedcad.DefaultContract(contract, "cad-layer-block-service")}}))
	if err != nil {
		return nil, translateConnectError(err)
	}
	return response.Msg, nil
}

func defaultSummary(summary string, kind string, identifier string) string {
	trimmed := strings.TrimSpace(summary)
	if trimmed != "" {
		return trimmed
	}
	return fmt.Sprintf("Upsert %s %s", kind, identifier)
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

