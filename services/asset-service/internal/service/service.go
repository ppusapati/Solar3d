package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"p9e.in/samavaya/solar3d/asset-service/internal/domain"
	"p9e.in/samavaya/solar3d/asset-service/internal/repository"
	"p9e.in/samavaya/packages/audit"
)

type AssetService struct {
	repo *repository.AssetRepository
}

func NewAssetService(repo *repository.AssetRepository) *AssetService {
	return &AssetService{repo: repo}
}

func (s *AssetService) Create(ctx context.Context, req domain.CreateAssetRequest) (*domain.Asset, error) {
	asset := &domain.Asset{
		ID:               uuid.New(),
		Name:             req.Name,
		Manufacturer:     req.Manufacturer,
		Model:            req.Model,
		Category:         req.Category,
		Dimensions:       req.Dimensions,
		ElectricalParams: req.ElectricalParams,
		Model3DPath:      req.Model3DPath,
		DatasheetPath:    req.DatasheetPath,
		Metadata:         req.Metadata,
	}

	if err := s.repo.Create(ctx, asset); err != nil {
		return nil, fmt.Errorf("creating asset: %w", err)
	}

	log.Info().
		Str("asset_id", asset.ID.String()).
		Str("name", asset.Name).
		Str("category", string(asset.Category)).
		Msg("asset created")

	event := audit.NewAuditEvent(audit.EventCreated, "asset", asset.ID.String(), actorIDFromContext(ctx, "asset-service"))
	event.RecordMetadata("category", string(asset.Category))
	event.RecordMetadata("name", asset.Name)
	audit.LogToContext(ctx, event)

	return asset, nil
}

func (s *AssetService) GetByID(ctx context.Context, id uuid.UUID) (*domain.Asset, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *AssetService) List(ctx context.Context) ([]domain.Asset, error) {
	return s.repo.List(ctx)
}

func (s *AssetService) ListByCategory(ctx context.Context, category domain.AssetCategory) ([]domain.Asset, error) {
	return s.repo.ListByCategory(ctx, category)
}

func (s *AssetService) Search(ctx context.Context, filter domain.AssetFilter) ([]domain.Asset, error) {
	return s.repo.Search(ctx, filter)
}

func (s *AssetService) Update(ctx context.Context, id uuid.UUID, req domain.UpdateAssetRequest) (*domain.Asset, error) {
	asset, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if req.Name != nil {
		asset.Name = *req.Name
	}
	if req.Manufacturer != nil {
		asset.Manufacturer = *req.Manufacturer
	}
	if req.Model != nil {
		asset.Model = *req.Model
	}
	if req.Category != nil {
		asset.Category = *req.Category
	}
	if req.Dimensions != nil {
		asset.Dimensions = *req.Dimensions
	}
	if req.ElectricalParams != nil {
		asset.ElectricalParams = *req.ElectricalParams
	}
	if req.Model3DPath != nil {
		asset.Model3DPath = req.Model3DPath
	}
	if req.DatasheetPath != nil {
		asset.DatasheetPath = req.DatasheetPath
	}
	if req.Metadata != nil {
		asset.Metadata = req.Metadata
	}

	if err := s.repo.Update(ctx, asset); err != nil {
		return nil, fmt.Errorf("updating asset: %w", err)
	}

	log.Info().
		Str("asset_id", asset.ID.String()).
		Str("name", asset.Name).
		Msg("asset updated")

	event := audit.NewAuditEvent(audit.EventUpdated, "asset", asset.ID.String(), actorIDFromContext(ctx, "asset-service"))
	event.RecordMetadata("name", asset.Name)
	audit.LogToContext(ctx, event)

	return asset, nil
}

func (s *AssetService) Delete(ctx context.Context, id uuid.UUID) error {
	if err := s.repo.Delete(ctx, id); err != nil {
		return err
	}

	log.Info().
		Str("asset_id", id.String()).
		Msg("asset deleted")

	event := audit.NewAuditEvent(audit.EventDeleted, "asset", id.String(), actorIDFromContext(ctx, "asset-service"))
	audit.LogToContext(ctx, event)

	return nil
}

func actorIDFromContext(ctx context.Context, fallback string) string {
	if v, ok := ctx.Value("actor_id").(string); ok && v != "" {
		return v
	}
	return fallback
}

