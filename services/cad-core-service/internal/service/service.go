package service

import (
	"context"
	"errors"
	"fmt"
	"sort"
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
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrInvalidInput = errors.New("invalid input")
	ErrNotFound     = errors.New("not found")
	ErrConflict     = errors.New("conflict")
)

const (
	ConflictCodeStaleRevision  = "stale_revision"
	HeaderOutcomeCode          = "x-solar3d-outcome-code"
	HeaderAttemptID            = "x-solar3d-attempt-id"
	HeaderHeadVersion          = "x-solar3d-head-version"
	HeaderBaseRevisionID       = "x-solar3d-base-revision-id"
	HeaderRequestedHeadVersion = "x-solar3d-requested-head-version"
	OutcomeCommitted           = "committed"
	OutcomeStaleBase           = "stale_base"
	OutcomeLockTimeout         = "lock_timeout"
	OutcomeIdempotentDuplicate = "idempotent_duplicate"
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

func NewStaleRevisionConflict(baseRevisionID string, headRevisionID string) *ConflictError {
	message := "base revision is stale"
	if strings.TrimSpace(baseRevisionID) != "" && strings.TrimSpace(headRevisionID) != "" {
		message = fmt.Sprintf("base revision %s is stale; current head is %s", baseRevisionID, headRevisionID)
	}
	return &ConflictError{
		Code:           ConflictCodeStaleRevision,
		Message:        message,
		BaseRevisionID: strings.TrimSpace(baseRevisionID),
		HeadRevisionID: strings.TrimSpace(headRevisionID),
		RetryAfterMs:   300,
	}
}

type Service struct {
	revisions      drawingv1connect.DrawingRevisionServiceClient
	logger         zerolog.Logger
	requestTimeout time.Duration
}

type CommitDrawingMetadata struct {
	OutcomeCode string
	AttemptID   string
	HeadVersion uint32
}

func New(revisions drawingv1connect.DrawingRevisionServiceClient, logger zerolog.Logger, requestTimeout time.Duration) *Service {
	return &Service{
		revisions:      revisions,
		logger:         logger.With().Str("component", "service").Logger(),
		requestTimeout: requestTimeout,
	}
}

func (s *Service) ValidateDrawingCommand(ctx context.Context, req *drawingv1.ValidateDrawingCommandRequest) (*drawingv1.ValidateDrawingCommandResponse, error) {
	state, violations, _, _, err := s.applyCommand(ctx, req.GetCommand(), req.GetBaseRevisionId(), false)
	if err != nil {
		return nil, err
	}
	return &drawingv1.ValidateDrawingCommandResponse{
		Valid:             len(violations) == 0,
		Violations:        violations,
		ResultingEntities: state,
	}, nil
}

func (s *Service) CommitDrawingCommand(ctx context.Context, req *drawingv1.CommitDrawingCommandRequest) (*drawingv1.CommitDrawingCommandResponse, CommitDrawingMetadata, error) {
	state, violations, _, headVersion, err := s.applyCommand(ctx, req.GetCommand(), req.GetBaseRevisionId(), true)
	if err != nil {
		return nil, CommitDrawingMetadata{}, err
	}
	if len(violations) > 0 {
		return nil, CommitDrawingMetadata{}, fmt.Errorf("%w: %s", ErrInvalidInput, strings.Join(violations, "; "))
	}

	summary := strings.TrimSpace(req.GetSummary())
	if summary == "" {
		summary = fmt.Sprintf("Applied command %s", req.GetCommand().GetCommandId())
	}

	storeCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	storeRequest := connect.NewRequest(&drawingv1.StoreDrawingRevisionRequest{
		DrawingId: req.GetCommand().GetDrawingId(),
		Author:    req.GetCommand().GetActor(),
		Summary:   summary,
		CommandId: req.GetCommand().GetCommandId(),
		Entities:  state,
		Contract:  defaultContract(req.GetCommand().GetContract(), "cad-core-service"),
	})
	if strings.TrimSpace(req.GetBaseRevisionId()) != "" {
		storeRequest.Header().Set(HeaderBaseRevisionID, strings.TrimSpace(req.GetBaseRevisionId()))
	}
	if headVersion > 0 {
		storeRequest.Header().Set(HeaderRequestedHeadVersion, strconv.FormatUint(uint64(headVersion), 10))
	}
	response, err := s.revisions.StoreDrawingRevision(storeCtx, storeRequest)
	if err != nil {
		return nil, CommitDrawingMetadata{}, translateConnectError(err)
	}

	s.logger.Info().Str("drawing_id", req.GetCommand().GetDrawingId()).Str("revision_id", response.Msg.GetRevision().GetPointer().GetRevisionId()).Msg("drawing command committed")
	return &drawingv1.CommitDrawingCommandResponse{
			Drawing:  response.Msg.GetDrawing(),
			Revision: response.Msg.GetRevision(),
		}, CommitDrawingMetadata{
			OutcomeCode: response.Header().Get(HeaderOutcomeCode),
			AttemptID:   response.Header().Get(HeaderAttemptID),
			HeadVersion: parseHeaderUint32(response.Header().Get(HeaderHeadVersion), response.Msg.GetDrawing().GetRevisionCount()),
		}, nil
}

func (s *Service) RevertDrawingRevision(ctx context.Context, req *drawingv1.RevertDrawingRevisionRequest) (*drawingv1.RevertDrawingRevisionResponse, error) {
	if _, err := parseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, err
	}
	if _, err := parseUUID(req.GetTargetRevisionId(), "target_revision_id"); err != nil {
		return nil, err
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}

	stateCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	stateResponse, err := s.revisions.GetDrawingState(stateCtx, connect.NewRequest(&drawingv1.GetDrawingStateRequest{
		DrawingId:  req.GetDrawingId(),
		RevisionId: req.GetTargetRevisionId(),
	}))
	if err != nil {
		return nil, translateConnectError(err)
	}

	summary := strings.TrimSpace(req.GetSummary())
	if summary == "" {
		summary = fmt.Sprintf("Reverted to revision %s", req.GetTargetRevisionId())
	}

	storeCtx, storeCancel := context.WithTimeout(ctx, s.requestTimeout)
	defer storeCancel()
	response, err := s.revisions.StoreDrawingRevision(storeCtx, connect.NewRequest(&drawingv1.StoreDrawingRevisionRequest{
		DrawingId: req.GetDrawingId(),
		Author:    req.GetAuthor(),
		Summary:   summary,
		CommandId: "",
		Entities:  cloneEntities(stateResponse.Msg.GetRevision().GetEntities()),
		Contract:  defaultContract(nil, "cad-core-service"),
	}))
	if err != nil {
		return nil, translateConnectError(err)
	}

	s.logger.Info().Str("drawing_id", req.GetDrawingId()).Str("target_revision_id", req.GetTargetRevisionId()).Msg("drawing reverted")
	return &drawingv1.RevertDrawingRevisionResponse{Drawing: response.Msg.GetDrawing(), Revision: response.Msg.GetRevision()}, nil
}

func (s *Service) applyCommand(ctx context.Context, command *drawingv1.DrawingCommand, baseRevisionID string, enforceHead bool) ([]*drawingv1.DrawingEntity, []string, string, uint32, error) {
	violations, err := validateCommandShape(command)
	if err != nil {
		return nil, nil, "", 0, err
	}
	if len(violations) > 0 {
		return nil, violations, "", 0, nil
	}

	getCtx, cancel := context.WithTimeout(ctx, s.requestTimeout)
	defer cancel()
	drawingResponse, err := s.revisions.GetDrawing(getCtx, connect.NewRequest(&drawingv1.GetDrawingRequest{DrawingId: command.GetDrawingId()}))
	if err != nil {
		return nil, nil, "", 0, translateConnectError(err)
	}
	currentRevisionID := drawingResponse.Msg.GetDrawing().GetCurrentRevisionId()
	currentHeadVersion := drawingResponse.Msg.GetDrawing().GetRevisionCount()

	requestedRevisionID := currentRevisionID
	if strings.TrimSpace(baseRevisionID) != "" {
		requestedRevisionID = baseRevisionID
	}

	stateCtx, stateCancel := context.WithTimeout(ctx, s.requestTimeout)
	defer stateCancel()
	stateResponse, err := s.revisions.GetDrawingState(stateCtx, connect.NewRequest(&drawingv1.GetDrawingStateRequest{
		DrawingId:  command.GetDrawingId(),
		RevisionId: requestedRevisionID,
	}))
	if err != nil {
		return nil, nil, "", 0, translateConnectError(err)
	}

	entitiesByID := make(map[string]*drawingv1.DrawingEntity, len(stateResponse.Msg.GetRevision().GetEntities()))
	for _, entity := range stateResponse.Msg.GetRevision().GetEntities() {
		if entity == nil || entity.GetHeader() == nil || strings.TrimSpace(entity.GetHeader().GetEntityId()) == "" {
			continue
		}
		entitiesByID[entity.GetHeader().GetEntityId()] = cloneEntity(entity)
	}

	for _, mutation := range command.GetMutations() {
		violations = append(violations, applyMutation(command.GetDrawingId(), entitiesByID, mutation)...)
	}
	if len(violations) > 0 {
		sort.Strings(violations)
		return nil, dedupeStrings(violations), currentRevisionID, currentHeadVersion, nil
	}

	result := make([]*drawingv1.DrawingEntity, 0, len(entitiesByID))
	for _, entity := range entitiesByID {
		if entity == nil || entity.GetHeader() == nil || strings.TrimSpace(entity.GetHeader().GetEntityId()) == "" {
			continue
		}
		result = append(result, cloneEntity(entity))
	}
	sort.Slice(result, func(i, j int) bool {
		return result[i].GetHeader().GetEntityId() < result[j].GetHeader().GetEntityId()
	})
	_ = enforceHead
	return result, nil, currentRevisionID, currentHeadVersion, nil
}

func parseHeaderUint32(raw string, fallback uint32) uint32 {
	if strings.TrimSpace(raw) == "" {
		return fallback
	}
	parsed, err := strconv.ParseUint(raw, 10, 32)
	if err != nil {
		return fallback
	}
	return uint32(parsed)
}

func parseRetryAfterMs(raw string) int {
	if strings.TrimSpace(raw) == "" {
		return 0
	}
	parsed, err := strconv.ParseFloat(raw, 64)
	if err != nil || parsed <= 0 {
		return 0
	}
	return int(parsed * 1000)
}

func validateCommandShape(command *drawingv1.DrawingCommand) ([]string, error) {
	if command == nil {
		return nil, fmt.Errorf("%w: command is required", ErrInvalidInput)
	}
	if _, err := parseUUID(command.GetDrawingId(), "drawing_id"); err != nil {
		return nil, err
	}
	if strings.TrimSpace(command.GetActor()) == "" {
		return nil, fmt.Errorf("%w: actor is required", ErrInvalidInput)
	}
	if strings.TrimSpace(command.GetCommandId()) == "" {
		return nil, fmt.Errorf("%w: command_id is required", ErrInvalidInput)
	}
	if len(command.GetMutations()) == 0 {
		return nil, fmt.Errorf("%w: at least one mutation is required", ErrInvalidInput)
	}

	violations := make([]string, 0)
	for index, mutation := range command.GetMutations() {
		prefix := fmt.Sprintf("mutation[%d]", index)
		if mutation == nil {
			violations = append(violations, prefix+": mutation is required")
			continue
		}
		if strings.TrimSpace(mutation.GetEntityId()) == "" {
			violations = append(violations, prefix+": entity_id is required")
		}
		if mutation.GetAction() == drawingv1.RevisionAction_REVISION_ACTION_UNSPECIFIED {
			violations = append(violations, prefix+": action is required")
		}
	}
	return violations, nil
}

func applyMutation(drawingID string, entitiesByID map[string]*drawingv1.DrawingEntity, mutation *drawingv1.DrawingMutation) []string {
	entityID := strings.TrimSpace(mutation.GetEntityId())
	violations := validateMutationEntities(drawingID, mutation)
	if len(violations) > 0 {
		return violations
	}

	switch mutation.GetAction() {
	case drawingv1.RevisionAction_REVISION_ACTION_CREATE:
		if _, exists := entitiesByID[entityID]; exists {
			return []string{fmt.Sprintf("entity %s already exists", entityID)}
		}
		entitiesByID[entityID] = cloneEntity(mutation.GetAfter())
	case drawingv1.RevisionAction_REVISION_ACTION_UPDATE:
		current, exists := entitiesByID[entityID]
		if !exists {
			return []string{fmt.Sprintf("entity %s does not exist for update", entityID)}
		}
		if mutation.GetBefore() != nil && !proto.Equal(current, mutation.GetBefore()) {
			return []string{fmt.Sprintf("entity %s before state does not match current head", entityID)}
		}
		entitiesByID[entityID] = cloneEntity(mutation.GetAfter())
	case drawingv1.RevisionAction_REVISION_ACTION_DELETE:
		current, exists := entitiesByID[entityID]
		if !exists {
			return []string{fmt.Sprintf("entity %s does not exist for delete", entityID)}
		}
		if mutation.GetBefore() != nil && !proto.Equal(current, mutation.GetBefore()) {
			return []string{fmt.Sprintf("entity %s before state does not match current head", entityID)}
		}
		delete(entitiesByID, entityID)
	}
	return nil
}

func validateMutationEntities(drawingID string, mutation *drawingv1.DrawingMutation) []string {
	entityID := strings.TrimSpace(mutation.GetEntityId())
	violations := make([]string, 0)
	switch mutation.GetAction() {
	case drawingv1.RevisionAction_REVISION_ACTION_CREATE:
		if mutation.GetAfter() == nil {
			violations = append(violations, fmt.Sprintf("entity %s create requires after state", entityID))
		} else {
			violations = append(violations, validateEntity(drawingID, entityID, mutation.GetAfter())...)
		}
	case drawingv1.RevisionAction_REVISION_ACTION_UPDATE:
		if mutation.GetBefore() == nil {
			violations = append(violations, fmt.Sprintf("entity %s update requires before state", entityID))
		}
		if mutation.GetAfter() == nil {
			violations = append(violations, fmt.Sprintf("entity %s update requires after state", entityID))
		} else {
			violations = append(violations, validateEntity(drawingID, entityID, mutation.GetAfter())...)
		}
	case drawingv1.RevisionAction_REVISION_ACTION_DELETE:
		if mutation.GetBefore() == nil {
			violations = append(violations, fmt.Sprintf("entity %s delete requires before state", entityID))
		}
	}
	return violations
}

func validateEntity(drawingID, entityID string, entity *drawingv1.DrawingEntity) []string {
	violations := make([]string, 0)
	if entity == nil || entity.GetHeader() == nil {
		return []string{fmt.Sprintf("entity %s header is required", entityID)}
	}
	if entity.GetHeader().GetEntityId() != entityID {
		violations = append(violations, fmt.Sprintf("entity %s header entity_id mismatch", entityID))
	}
	if entity.GetHeader().GetDrawingId() != drawingID {
		violations = append(violations, fmt.Sprintf("entity %s header drawing_id mismatch", entityID))
	}
	if entity.GetHeader().GetEntityType() == drawingv1.DrawingEntityType_DRAWING_ENTITY_TYPE_UNSPECIFIED {
		violations = append(violations, fmt.Sprintf("entity %s entity_type is required", entityID))
	}

	switch geometry := entity.Geometry.(type) {
	case *drawingv1.DrawingEntity_Polyline:
		if len(geometry.Polyline.GetVertices()) < 2 {
			violations = append(violations, fmt.Sprintf("entity %s polyline requires at least 2 vertices", entityID))
		}
	case *drawingv1.DrawingEntity_Polygon:
		if len(geometry.Polygon.GetGeometry().GetRings()) == 0 {
			violations = append(violations, fmt.Sprintf("entity %s polygon requires at least 1 ring", entityID))
		}
	case *drawingv1.DrawingEntity_Text:
		if strings.TrimSpace(geometry.Text.GetText()) == "" {
			violations = append(violations, fmt.Sprintf("entity %s text content is required", entityID))
		}
		if geometry.Text.GetHeight() <= 0 {
			violations = append(violations, fmt.Sprintf("entity %s text height must be positive", entityID))
		}
	case *drawingv1.DrawingEntity_Dimension:
		if geometry.Dimension.GetPrecision() < 0 {
			violations = append(violations, fmt.Sprintf("entity %s dimension precision must be non-negative", entityID))
		}
	case *drawingv1.DrawingEntity_BlockReference:
		if strings.TrimSpace(geometry.BlockReference.GetBlockDefinitionId()) == "" {
			violations = append(violations, fmt.Sprintf("entity %s block_definition_id is required", entityID))
		}
		if geometry.BlockReference.GetScaleX() <= 0 || geometry.BlockReference.GetScaleY() <= 0 {
			violations = append(violations, fmt.Sprintf("entity %s block reference scale must be positive", entityID))
		}
	case *drawingv1.DrawingEntity_LayerDefinition:
		if strings.TrimSpace(geometry.LayerDefinition.GetLayerId()) == "" || strings.TrimSpace(geometry.LayerDefinition.GetName()) == "" {
			violations = append(violations, fmt.Sprintf("entity %s layer definition requires layer_id and name", entityID))
		}
		if geometry.LayerDefinition.GetLineWeightMm() < 0 {
			violations = append(violations, fmt.Sprintf("entity %s layer line weight must be non-negative", entityID))
		}
	case *drawingv1.DrawingEntity_BlockDefinition:
		if strings.TrimSpace(geometry.BlockDefinition.GetBlockDefinitionId()) == "" || strings.TrimSpace(geometry.BlockDefinition.GetName()) == "" {
			violations = append(violations, fmt.Sprintf("entity %s block definition requires block_definition_id and name", entityID))
		}
		if len(geometry.BlockDefinition.GetEntities()) == 0 {
			violations = append(violations, fmt.Sprintf("entity %s block definition requires at least one child entity", entityID))
		}
	case *drawingv1.DrawingEntity_Leader:
		if len(geometry.Leader.GetVertices()) < 2 {
			violations = append(violations, fmt.Sprintf("entity %s leader requires at least 2 vertices", entityID))
		}
		if geometry.Leader.GetTextHeight() <= 0 {
			violations = append(violations, fmt.Sprintf("entity %s leader text height must be positive", entityID))
		}
	case *drawingv1.DrawingEntity_Sheet:
		if strings.TrimSpace(geometry.Sheet.GetSheetId()) == "" || strings.TrimSpace(geometry.Sheet.GetTitle()) == "" {
			violations = append(violations, fmt.Sprintf("entity %s sheet requires sheet_id and title", entityID))
		}
		if geometry.Sheet.GetPageWidthMm() <= 0 || geometry.Sheet.GetPageHeightMm() <= 0 {
			violations = append(violations, fmt.Sprintf("entity %s sheet dimensions must be positive", entityID))
		}
	default:
		violations = append(violations, fmt.Sprintf("entity %s geometry is required", entityID))
	}
	return violations
}

func translateConnectError(err error) error {
	var connectErr *connect.Error
	if !errors.As(err, &connectErr) {
		return err
	}
	conflictErr := &ConflictError{
		Code:           strings.TrimSpace(connectErr.Meta().Get("x-solar3d-error-code")),
		OutcomeCode:    strings.TrimSpace(connectErr.Meta().Get(HeaderOutcomeCode)),
		AttemptID:      strings.TrimSpace(connectErr.Meta().Get(HeaderAttemptID)),
		BaseRevisionID: strings.TrimSpace(connectErr.Meta().Get("x-solar3d-base-revision-id")),
		HeadRevisionID: strings.TrimSpace(connectErr.Meta().Get("x-solar3d-head-revision-id")),
		HeadVersion:    parseHeaderUint32(connectErr.Meta().Get(HeaderHeadVersion), 0),
		RetryAfterMs:   parseRetryAfterMs(connectErr.Meta().Get("retry-after")),
		Message:        connectErr.Message(),
	}
	if conflictErr.Code == "" && conflictErr.OutcomeCode == OutcomeStaleBase {
		conflictErr.Code = ConflictCodeStaleRevision
	}
	switch connectErr.Code() {
	case connect.CodeInvalidArgument:
		return fmt.Errorf("%w: %v", ErrInvalidInput, connectErr.Message())
	case connect.CodeNotFound:
		return fmt.Errorf("%w: %v", ErrNotFound, connectErr.Message())
	case connect.CodeAlreadyExists, connect.CodeAborted, connect.CodeFailedPrecondition:
		if conflictErr.OutcomeCode != "" || conflictErr.Code != "" || conflictErr.AttemptID != "" || conflictErr.HeadVersion > 0 {
			if conflictErr.OutcomeCode == OutcomeStaleBase || conflictErr.Code == ConflictCodeStaleRevision {
				recordStaleConflict()
			}
			return conflictErr
		}
		return fmt.Errorf("%w: %v", ErrConflict, connectErr.Message())
	default:
		return err
	}
}

func parseUUID(value string, field string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(strings.TrimSpace(value))
	if err != nil {
		return uuid.Nil, fmt.Errorf("%w: %s must be a UUID", ErrInvalidInput, field)
	}
	return parsed, nil
}

func cloneEntity(entity *drawingv1.DrawingEntity) *drawingv1.DrawingEntity {
	if entity == nil {
		return nil
	}
	return proto.Clone(entity).(*drawingv1.DrawingEntity)
}

func cloneEntities(entities []*drawingv1.DrawingEntity) []*drawingv1.DrawingEntity {
	cloned := make([]*drawingv1.DrawingEntity, 0, len(entities))
	for _, entity := range entities {
		cloned = append(cloned, cloneEntity(entity))
	}
	return cloned
}

func dedupeStrings(values []string) []string {
	if len(values) == 0 {
		return values
	}
	result := values[:0]
	var last string
	for index, value := range values {
		if index == 0 || value != last {
			result = append(result, value)
			last = value
		}
	}
	return result
}

func defaultContract(existing *commonv1.ContractMetadata, producer string) *commonv1.ContractMetadata {
	if existing != nil {
		return existing
	}
	now := time.Now().UTC()
	return &commonv1.ContractMetadata{
		SchemaVersion: &commonv1.ApiVersion{Major: 1, Minor: 0, Patch: 0},
		SchemaId:      "drawing.v1",
		Producer:      producer,
		CreatedAt:     timestamppb.New(now),
	}
}

