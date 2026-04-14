package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
	commonv1 "github.com/solar3d/solar3d/gen/common/v1"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/drawing-revision-service/internal/repository"
)

var (
	ErrNotFound     = errors.New("not found")
	ErrInvalidInput = errors.New("invalid input")
	ErrConflict     = errors.New("conflict")
)

type Service struct {
	repo   repository.Repository
	logger zerolog.Logger
}

func New(repo repository.Repository, logger zerolog.Logger) *Service {
	return &Service{
		repo:   repo,
		logger: logger.With().Str("component", "service").Logger(),
	}
}

func (s *Service) CreateDrawing(ctx context.Context, req *drawingv1.CreateDrawingRequest) (*drawingv1.CreateDrawingResponse, error) {
	if _, err := parseUUID(req.GetProjectId(), "project_id"); err != nil {
		return nil, err
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if strings.TrimSpace(req.GetName()) == "" {
		return nil, fmt.Errorf("%w: name is required", ErrInvalidInput)
	}
	if err := validateJSON(req.GetMetadataJson(), "metadata_json"); err != nil {
		return nil, err
	}

	now := time.Now().UTC()
	drawing := &drawingv1.Drawing{
		DrawingId:     uuid.NewString(),
		ProjectId:     req.GetProjectId(),
		Name:          strings.TrimSpace(req.GetName()),
		Description:   strings.TrimSpace(req.GetDescription()),
		MetadataJson:  normalizeJSON(req.GetMetadataJson()),
		Status:        drawingv1.DrawingStatus_DRAWING_STATUS_ACTIVE,
		RevisionCount: 1,
		EntityCount:   0,
		CreatedAt:     timestamppb.New(now),
		UpdatedAt:     timestamppb.New(now),
		Contract:      defaultContract(req.GetContract(), "drawing-revision-service"),
	}

	revision, err := s.repo.CreateDrawing(ctx, drawing, strings.TrimSpace(req.GetAuthor()))
	if err != nil {
		return nil, translateError(err)
	}
	drawing.CurrentRevisionId = revision.GetPointer().GetRevisionId()

	s.logger.Info().Str("drawing_id", drawing.GetDrawingId()).Str("project_id", drawing.GetProjectId()).Msg("drawing created")
	return &drawingv1.CreateDrawingResponse{Drawing: drawing, Revision: revision}, nil
}

func (s *Service) GetDrawing(ctx context.Context, drawingID string) (*drawingv1.Drawing, error) {
	if _, err := parseUUID(drawingID, "drawing_id"); err != nil {
		return nil, err
	}
	drawing, err := s.repo.GetDrawing(ctx, drawingID)
	if err != nil {
		return nil, translateError(err)
	}
	return drawing, nil
}

func (s *Service) ListDrawings(ctx context.Context, req *drawingv1.ListDrawingsRequest) (*drawingv1.ListDrawingsResponse, error) {
	if _, err := parseUUID(req.GetProjectId(), "project_id"); err != nil {
		return nil, err
	}
	limit := int(req.GetPageSize())
	if limit <= 0 {
		limit = 20
	}
	offset, err := parseOffset(req.GetPageToken())
	if err != nil {
		return nil, err
	}

	drawings, total, err := s.repo.ListDrawings(ctx, req.GetProjectId(), limit, offset, req.GetIncludeArchived())
	if err != nil {
		return nil, translateError(err)
	}

	nextPageToken := ""
	if offset+len(drawings) < total {
		nextPageToken = strconv.Itoa(offset + len(drawings))
	}

	return &drawingv1.ListDrawingsResponse{
		Drawings:      drawings,
		NextPageToken: nextPageToken,
		TotalCount:    uint32(total),
	}, nil
}

func (s *Service) UpdateDrawing(ctx context.Context, req *drawingv1.UpdateDrawingRequest) (*drawingv1.UpdateDrawingResponse, error) {
	drawing, err := s.GetDrawing(ctx, req.GetDrawingId())
	if err != nil {
		return nil, err
	}

	if name := strings.TrimSpace(req.GetName()); name != "" {
		drawing.Name = name
	}
	if req.GetDescription() != "" {
		drawing.Description = strings.TrimSpace(req.GetDescription())
	}
	if req.GetMetadataJson() != "" {
		if err := validateJSON(req.GetMetadataJson(), "metadata_json"); err != nil {
			return nil, err
		}
		drawing.MetadataJson = normalizeJSON(req.GetMetadataJson())
	}
	if req.GetStatus() != drawingv1.DrawingStatus_DRAWING_STATUS_UNSPECIFIED {
		drawing.Status = req.GetStatus()
	}
	drawing.UpdatedAt = timestamppb.New(time.Now().UTC())
	drawing.Contract = defaultContract(drawing.GetContract(), "drawing-revision-service")

	if err := s.repo.UpdateDrawing(ctx, drawing); err != nil {
		return nil, translateError(err)
	}

	s.logger.Info().Str("drawing_id", drawing.GetDrawingId()).Msg("drawing updated")
	return &drawingv1.UpdateDrawingResponse{Drawing: drawing}, nil
}

func (s *Service) GetDrawingState(ctx context.Context, drawingID, revisionID string) (*drawingv1.GetDrawingStateResponse, error) {
	if _, err := parseUUID(drawingID, "drawing_id"); err != nil {
		return nil, err
	}
	if strings.TrimSpace(revisionID) != "" {
		if _, err := parseUUID(revisionID, "revision_id"); err != nil {
			return nil, err
		}
	}
	drawing, revision, err := s.repo.GetDrawingState(ctx, drawingID, revisionID)
	if err != nil {
		return nil, translateError(err)
	}
	return &drawingv1.GetDrawingStateResponse{Drawing: drawing, Revision: revision}, nil
}

func (s *Service) ListDrawingRevisions(ctx context.Context, req *drawingv1.ListDrawingRevisionsRequest) (*drawingv1.ListDrawingRevisionsResponse, error) {
	if _, err := parseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, err
	}
	limit := int(req.GetPageSize())
	if limit <= 0 {
		limit = 20
	}
	offset, err := parseOffset(req.GetPageToken())
	if err != nil {
		return nil, err
	}

	revisions, total, err := s.repo.ListDrawingRevisions(ctx, req.GetDrawingId(), limit, offset)
	if err != nil {
		return nil, translateError(err)
	}

	nextPageToken := ""
	if offset+len(revisions) < total {
		nextPageToken = strconv.Itoa(offset + len(revisions))
	}

	return &drawingv1.ListDrawingRevisionsResponse{
		Revisions:     revisions,
		NextPageToken: nextPageToken,
		TotalCount:    uint32(total),
	}, nil
}

func (s *Service) GetDrawingRevision(ctx context.Context, drawingID, revisionID string) (*drawingv1.GetDrawingRevisionResponse, error) {
	response, err := s.GetDrawingState(ctx, drawingID, revisionID)
	if err != nil {
		return nil, err
	}
	return &drawingv1.GetDrawingRevisionResponse{Drawing: response.GetDrawing(), Revision: response.GetRevision()}, nil
}

func (s *Service) StoreDrawingRevision(ctx context.Context, req *drawingv1.StoreDrawingRevisionRequest, baseRevisionID string, requestedHeadVersion uint32) (*drawingv1.StoreDrawingRevisionResponse, StoreRevisionMetadata, error) {
	if _, err := parseUUID(req.GetDrawingId(), "drawing_id"); err != nil {
		return nil, StoreRevisionMetadata{}, err
	}
	if strings.TrimSpace(req.GetAuthor()) == "" {
		return nil, StoreRevisionMetadata{}, fmt.Errorf("%w: author is required", ErrInvalidInput)
	}
	if strings.TrimSpace(req.GetSummary()) == "" {
		return nil, StoreRevisionMetadata{}, fmt.Errorf("%w: summary is required", ErrInvalidInput)
	}
	if err := validateSnapshot(req.GetDrawingId(), req.GetEntities()); err != nil {
		return nil, StoreRevisionMetadata{}, err
	}

	drawing, revision, outcome, err := s.repo.StoreDrawingRevision(ctx, repository.StoreRevisionInput{
		DrawingID:            req.GetDrawingId(),
		Author:               strings.TrimSpace(req.GetAuthor()),
		Summary:              strings.TrimSpace(req.GetSummary()),
		CommandID:            strings.TrimSpace(req.GetCommandId()),
		BaseRevisionID:       strings.TrimSpace(baseRevisionID),
		RequestedHeadVersion: requestedHeadVersion,
		Entities:             req.GetEntities(),
		Contract:             defaultContract(req.GetContract(), "drawing-revision-service"),
		At:                   time.Now().UTC(),
	})
	if err != nil {
		return nil, StoreRevisionMetadata{}, translateError(err)
	}

	s.logger.Info().Str("drawing_id", req.GetDrawingId()).Str("revision_id", revision.GetPointer().GetRevisionId()).Msg("drawing revision stored")
	return &drawingv1.StoreDrawingRevisionResponse{Drawing: drawing, Revision: revision}, StoreRevisionMetadata{
		OutcomeCode: outcome.Code,
		AttemptID:   outcome.AttemptID,
		HeadVersion: outcome.HeadVersion,
	}, nil
}

func translateError(err error) error {
	switch {
	case errors.Is(err, repository.ErrNotFound):
		return ErrNotFound
	case errors.Is(err, repository.ErrConflict):
		var repoConflict *repository.ConflictError
		if errors.As(err, &repoConflict) {
			return &ConflictError{
				OutcomeCode:    repoConflict.OutcomeCode,
				AttemptID:      repoConflict.AttemptID,
				BaseRevisionID: repoConflict.BaseRevisionID,
				HeadRevisionID: repoConflict.HeadRevisionID,
				HeadVersion:    repoConflict.HeadVersion,
				Message:        repoConflict.Message,
			}
		}
		return ErrConflict
	case errors.Is(err, ErrInvalidInput), errors.Is(err, ErrNotFound), errors.Is(err, ErrConflict):
		return err
	default:
		return err
	}
}

func validateSnapshot(drawingID string, entities []*drawingv1.DrawingEntity) error {
	seen := make(map[string]struct{}, len(entities))
	for _, entity := range entities {
		if entity == nil || entity.GetHeader() == nil {
			return fmt.Errorf("%w: entity header is required", ErrInvalidInput)
		}
		entityID := strings.TrimSpace(entity.GetHeader().GetEntityId())
		if entityID == "" {
			return fmt.Errorf("%w: entity_id is required", ErrInvalidInput)
		}
		if entity.GetHeader().GetDrawingId() != drawingID {
			return fmt.Errorf("%w: entity %s drawing_id mismatch", ErrInvalidInput, entityID)
		}
		if _, exists := seen[entityID]; exists {
			return fmt.Errorf("%w: duplicate entity_id %s", ErrInvalidInput, entityID)
		}
		seen[entityID] = struct{}{}
	}
	return nil
}

func parseUUID(value string, field string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(strings.TrimSpace(value))
	if err != nil {
		return uuid.Nil, fmt.Errorf("%w: %s must be a UUID", ErrInvalidInput, field)
	}
	return parsed, nil
}

func validateJSON(value string, field string) error {
	if strings.TrimSpace(value) == "" {
		return nil
	}
	var payload any
	if err := json.Unmarshal([]byte(value), &payload); err != nil {
		return fmt.Errorf("%w: %s must be valid JSON", ErrInvalidInput, field)
	}
	return nil
}

func normalizeJSON(value string) string {
	if strings.TrimSpace(value) == "" {
		return "{}"
	}
	return value
}

func parseOffset(token string) (int, error) {
	if strings.TrimSpace(token) == "" {
		return 0, nil
	}
	offset, err := strconv.Atoi(token)
	if err != nil || offset < 0 {
		return 0, fmt.Errorf("%w: page_token must be a non-negative integer", ErrInvalidInput)
	}
	return offset, nil
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

