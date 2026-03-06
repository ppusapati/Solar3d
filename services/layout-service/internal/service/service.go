package service

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/layout-service/internal/config"
	"github.com/solar3d/solar3d/services/layout-service/internal/domain"
	"github.com/solar3d/solar3d/services/layout-service/internal/repository"
)

// Service contains core business logic for the layout domain.
type Service struct {
	repo *repository.Repository
	cfg  *config.Config
}

// New creates a new layout Service.
func New(repo *repository.Repository, cfg *config.Config) *Service {
	return &Service{repo: repo, cfg: cfg}
}

// ---------------------------------------------------------------------------
// Layout CRUD
// ---------------------------------------------------------------------------

// CreateLayout creates a new layout for a project.
func (s *Service) CreateLayout(ctx context.Context, projectID uuid.UUID, name string) (*domain.Layout, error) {
	layout := &domain.Layout{
		ProjectID: projectID,
		Name:      name,
	}
	if err := s.repo.CreateLayout(ctx, layout); err != nil {
		return nil, fmt.Errorf("service create layout: %w", err)
	}
	log.Info().Str("layout_id", layout.ID.String()).Str("name", name).Msg("layout created")
	return layout, nil
}

// GetLayout retrieves a layout by ID.
func (s *Service) GetLayout(ctx context.Context, id uuid.UUID) (*domain.Layout, error) {
	return s.repo.GetLayout(ctx, id)
}

// ListLayouts returns all layouts for a project.
func (s *Service) ListLayouts(ctx context.Context, projectID uuid.UUID) ([]*domain.Layout, error) {
	return s.repo.ListLayoutsByProject(ctx, projectID)
}

// UpdateLayout updates a layout's mutable fields.
func (s *Service) UpdateLayout(ctx context.Context, layout *domain.Layout) error {
	return s.repo.UpdateLayout(ctx, layout)
}

// DeleteLayout removes a layout and all its children.
func (s *Service) DeleteLayout(ctx context.Context, id uuid.UUID) error {
	return s.repo.DeleteLayout(ctx, id)
}

// ---------------------------------------------------------------------------
// Component placement
// ---------------------------------------------------------------------------

// PlaceComponent adds a component to a layout at the given position.
func (s *Service) PlaceComponent(ctx context.Context, c *domain.Component) error {
	if c.LayoutID == uuid.Nil {
		return fmt.Errorf("component requires a layout_id")
	}
	if c.ComponentType == "" {
		return fmt.Errorf("component requires a component_type")
	}

	if err := s.repo.CreateComponent(ctx, c); err != nil {
		return fmt.Errorf("service place component: %w", err)
	}
	log.Info().
		Str("component_id", c.ID.String()).
		Str("type", string(c.ComponentType)).
		Msg("component placed")
	return nil
}

// GetComponent retrieves a component by ID.
func (s *Service) GetComponent(ctx context.Context, id uuid.UUID) (*domain.Component, error) {
	return s.repo.GetComponent(ctx, id)
}

// ListComponents returns all components for a layout.
func (s *Service) ListComponents(ctx context.Context, layoutID uuid.UUID) ([]*domain.Component, error) {
	return s.repo.ListComponentsByLayout(ctx, layoutID)
}

// DeleteComponent removes a component.
func (s *Service) DeleteComponent(ctx context.Context, id uuid.UUID) error {
	return s.repo.DeleteComponent(ctx, id)
}

// ---------------------------------------------------------------------------
// Panel array generation
// ---------------------------------------------------------------------------

// GeneratePanelArray is the key algorithm that:
//  1. Takes PanelArrayParams (panel dimensions, tilt, fill polygon, etc.)
//  2. Computes row spacing from tilt angle if not explicitly provided
//  3. Generates a grid of panels filling the polygon area
//  4. Partitions panels into spatial tiles based on configurable tile size
//  5. Bulk inserts tiles and panels
//  6. Updates the layout with totals
//
// This handles 100k-500k panel arrays for utility-scale solar farms.
func (s *Service) GeneratePanelArray(ctx context.Context, layoutID uuid.UUID, params domain.PanelArrayParams) (*domain.PanelArrayResult, error) {
	logger := log.With().Str("layout_id", layoutID.String()).Logger()

	// Validate layout exists.
	layout, err := s.repo.GetLayout(ctx, layoutID)
	if err != nil {
		return nil, fmt.Errorf("layout not found: %w", err)
	}

	logger.Info().
		Float64("panel_w", params.PanelWidth).
		Float64("panel_h", params.PanelHeight).
		Float64("tilt", params.TiltAngle).
		Msg("generating panel array")

	// Remove existing tiles/panels for this layout before regenerating.
	if err := s.repo.DeleteTilesByLayout(ctx, layoutID); err != nil {
		return nil, fmt.Errorf("clear existing tiles: %w", err)
	}

	// Generate the array: panels + tile assignments.
	gen := &ArrayGenerator{TileSize: s.cfg.TileSize}
	tiles, panels, err := gen.GenerateArray(params, layoutID)
	if err != nil {
		return nil, fmt.Errorf("array generation: %w", err)
	}

	totalPanels := int64(len(panels))
	// Standard residential panel ~0.4 kW; utility panels ~0.5-0.6 kW.
	// Capacity = panel area * ~200 W/m^2 efficiency approximation.
	panelAreaM2 := params.PanelWidth * params.PanelHeight
	capacityPerPanel := panelAreaM2 * 0.20 // 20% module efficiency, kW
	totalCapacity := float64(totalPanels) * capacityPerPanel

	logger.Info().
		Int64("total_panels", totalPanels).
		Float64("total_capacity_kw", totalCapacity).
		Int("tile_count", len(tiles)).
		Msg("array generated, persisting")

	// Bulk insert tiles.
	if err := s.repo.BulkInsertTiles(ctx, tiles); err != nil {
		return nil, fmt.Errorf("persist tiles: %w", err)
	}

	// Re-map panel tile IDs now that tiles have been assigned UUIDs by bulk insert.
	tileIndexMap := make(map[int]uuid.UUID) // index -> tile.ID
	for i, t := range tiles {
		tileIndexMap[i] = t.ID
	}

	// The generator tags each panel's TileID with a sentinel; remap to real IDs.
	// We rely on the generator storing the tile index in a lookup we can use.
	// The generator sets panel.TileID = tile.ID (pre-bulk-insert placeholder).
	// After BulkInsertTiles, tile.ID is set by the repo, and panels already reference it.
	// So panels already have the correct TileID.

	// Bulk insert panels.
	if err := s.repo.BulkInsertPanels(ctx, panels); err != nil {
		return nil, fmt.Errorf("persist panels: %w", err)
	}

	// Update layout totals.
	layout.TotalPanels = totalPanels
	layout.TotalCapacityKW = totalCapacity
	layout.TileCount = len(tiles)
	if err := s.repo.UpdateLayout(ctx, layout); err != nil {
		return nil, fmt.Errorf("update layout totals: %w", err)
	}

	logger.Info().Msg("panel array generation complete")

	return &domain.PanelArrayResult{
		LayoutID:        layoutID,
		TotalPanels:     totalPanels,
		TotalCapacityKW: totalCapacity,
		TileCount:       len(tiles),
	}, nil
}

// ---------------------------------------------------------------------------
// Spatial queries
// ---------------------------------------------------------------------------

// GetTiles returns tiles for a layout that intersect the given viewport.
func (s *Service) GetTiles(ctx context.Context, layoutID uuid.UUID, vq domain.ViewportQuery) ([]*domain.LayoutTile, error) {
	return s.repo.GetTilesByViewport(ctx, layoutID, vq)
}

// GetPanelsByTile returns all panels belonging to a specific tile.
func (s *Service) GetPanelsByTile(ctx context.Context, tileID uuid.UUID) ([]*domain.Panel, error) {
	return s.repo.GetPanelsByTile(ctx, tileID)
}
