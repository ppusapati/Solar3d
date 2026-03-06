package service

import (
	"context"
	"fmt"
	"math"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"github.com/solar3d/solar3d/services/terrain-service/internal/domain"
	"github.com/solar3d/solar3d/services/terrain-service/internal/repository"
)

// Service implements the terrain business logic, coordinating between the
// repository, object storage, and compute modules.
type Service struct {
	repo   *repository.Repository
	logger zerolog.Logger
}

// New creates a new terrain Service.
func New(repo *repository.Repository, logger zerolog.Logger) *Service {
	return &Service{
		repo:   repo,
		logger: logger.With().Str("component", "service").Logger(),
	}
}

// UploadTerrainRequest carries the parameters for creating a new terrain layer.
type UploadTerrainRequest struct {
	ProjectID    uuid.UUID         `json:"project_id"`
	Name         string            `json:"name"`
	LayerType    domain.LayerType  `json:"layer_type"`
	SourceFile   string            `json:"source_file"`
	Bounds       domain.BoundingBox `json:"bounds"`
	ResolutionM  float64           `json:"resolution_m"`
	CRS          string            `json:"crs"`
	MinElevation float64           `json:"min_elevation"`
	MaxElevation float64           `json:"max_elevation"`
}

// UploadTerrain validates the input and stores terrain layer metadata.
func (s *Service) UploadTerrain(ctx context.Context, req UploadTerrainRequest) (*domain.TerrainLayer, error) {
	if req.Name == "" {
		return nil, fmt.Errorf("name is required")
	}
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("project_id is required")
	}
	if !domain.ValidLayerTypes[req.LayerType] {
		return nil, fmt.Errorf("invalid layer type %q", req.LayerType)
	}
	if !req.Bounds.Valid() {
		return nil, fmt.Errorf("invalid bounding box: min must be less than max")
	}
	if req.ResolutionM <= 0 {
		return nil, fmt.Errorf("resolution_m must be positive")
	}
	if req.CRS == "" {
		return nil, fmt.Errorf("crs is required")
	}
	if req.MinElevation > req.MaxElevation {
		return nil, fmt.Errorf("min_elevation must not exceed max_elevation")
	}

	layer := &domain.TerrainLayer{
		ProjectID:    req.ProjectID,
		Name:         req.Name,
		LayerType:    req.LayerType,
		SourceFile:   req.SourceFile,
		Bounds:       req.Bounds,
		ResolutionM:  req.ResolutionM,
		CRS:          req.CRS,
		MinElevation: req.MinElevation,
		MaxElevation: req.MaxElevation,
	}

	created, err := s.repo.CreateTerrainLayer(ctx, layer)
	if err != nil {
		return nil, fmt.Errorf("create terrain layer: %w", err)
	}

	s.logger.Info().
		Str("layer_id", created.ID.String()).
		Str("name", created.Name).
		Msg("terrain uploaded")

	return created, nil
}

// GetLayer retrieves a terrain layer by ID.
func (s *Service) GetLayer(ctx context.Context, id uuid.UUID) (*domain.TerrainLayer, error) {
	layer, err := s.repo.GetTerrainLayer(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("get layer: %w", err)
	}
	return layer, nil
}

// ListLayers returns all terrain layers for a project.
func (s *Service) ListLayers(ctx context.Context, projectID uuid.UUID) ([]domain.TerrainLayer, error) {
	layers, err := s.repo.ListTerrainLayers(ctx, projectID)
	if err != nil {
		return nil, fmt.Errorf("list layers: %w", err)
	}
	return layers, nil
}

// DeleteLayer removes a terrain layer.
func (s *Service) DeleteLayer(ctx context.Context, id uuid.UUID) error {
	if err := s.repo.DeleteTerrainLayer(ctx, id); err != nil {
		return fmt.Errorf("delete layer: %w", err)
	}
	return nil
}

// GetElevation returns the elevation at a single point. In a full
// implementation this would query the raster data; here it validates the
// request and returns a placeholder demonstrating the interface.
func (s *Service) GetElevation(ctx context.Context, layerID uuid.UUID, x, y float64) (*domain.ElevationPoint, error) {
	layer, err := s.repo.GetTerrainLayer(ctx, layerID)
	if err != nil {
		return nil, fmt.Errorf("get elevation: %w", err)
	}

	if x < layer.Bounds.MinX || x > layer.Bounds.MaxX ||
		y < layer.Bounds.MinY || y > layer.Bounds.MaxY {
		return nil, fmt.Errorf("point (%f, %f) is outside layer bounds", x, y)
	}

	// TODO: Query actual raster data from S3/PostGIS raster.
	// Placeholder: interpolate between min and max elevation.
	t := ((x - layer.Bounds.MinX) / (layer.Bounds.MaxX - layer.Bounds.MinX) +
		(y - layer.Bounds.MinY) / (layer.Bounds.MaxY - layer.Bounds.MinY)) / 2.0
	elev := layer.MinElevation + t*(layer.MaxElevation-layer.MinElevation)

	return &domain.ElevationPoint{X: x, Y: y, Elevation: elev}, nil
}

// GetElevationGrid returns an elevation grid for the specified bounding box.
func (s *Service) GetElevationGrid(ctx context.Context, layerID uuid.UUID, bounds domain.BoundingBox, width, height int) (*domain.ElevationGrid, error) {
	if width <= 0 || height <= 0 {
		return nil, fmt.Errorf("width and height must be positive")
	}
	if !bounds.Valid() {
		return nil, fmt.Errorf("invalid bounding box")
	}

	layer, err := s.repo.GetTerrainLayer(ctx, layerID)
	if err != nil {
		return nil, fmt.Errorf("get elevation grid: %w", err)
	}

	// TODO: Query actual raster data. Placeholder grid generation.
	elevations := make([]float64, width*height)
	minElev := math.MaxFloat64
	maxElev := -math.MaxFloat64

	dx := (bounds.MaxX - bounds.MinX) / float64(width)
	dy := (bounds.MaxY - bounds.MinY) / float64(height)

	for row := 0; row < height; row++ {
		for col := 0; col < width; col++ {
			tx := float64(col) * dx / (layer.Bounds.MaxX - layer.Bounds.MinX)
			ty := float64(row) * dy / (layer.Bounds.MaxY - layer.Bounds.MinY)
			elev := layer.MinElevation + (tx+ty)/2.0*(layer.MaxElevation-layer.MinElevation)

			elevations[row*width+col] = elev
			if elev < minElev {
				minElev = elev
			}
			if elev > maxElev {
				maxElev = elev
			}
		}
	}

	return &domain.ElevationGrid{
		Width:      width,
		Height:     height,
		Elevations: elevations,
		MinElev:    minElev,
		MaxElev:    maxElev,
	}, nil
}

// ComputeSlope generates a slope layer from a DEM layer. The slope is computed
// in degrees using the Horn algorithm. Returns the derived terrain layer
// metadata once persisted.
func (s *Service) ComputeSlope(ctx context.Context, demLayerID uuid.UUID) (*domain.TerrainLayer, error) {
	dem, err := s.repo.GetTerrainLayer(ctx, demLayerID)
	if err != nil {
		return nil, fmt.Errorf("compute slope: source layer: %w", err)
	}
	if dem.LayerType != domain.LayerTypeDEM {
		return nil, fmt.Errorf("compute slope: source layer must be DEM, got %s", dem.LayerType)
	}

	// TODO: Implement Horn's method slope computation on raster data.
	slopeLayer := &domain.TerrainLayer{
		ProjectID:    dem.ProjectID,
		Name:         dem.Name + " - Slope",
		LayerType:    domain.LayerTypeSlope,
		SourceFile:   "", // Will be set after raster generation.
		Bounds:       dem.Bounds,
		ResolutionM:  dem.ResolutionM,
		CRS:          dem.CRS,
		MinElevation: 0,
		MaxElevation: 90, // Slope in degrees.
	}

	created, err := s.repo.CreateTerrainLayer(ctx, slopeLayer)
	if err != nil {
		return nil, fmt.Errorf("compute slope: persist: %w", err)
	}

	s.logger.Info().
		Str("dem_layer_id", demLayerID.String()).
		Str("slope_layer_id", created.ID.String()).
		Msg("slope layer computed")

	return created, nil
}

// ComputeAspect generates an aspect layer from a DEM layer. Aspect is
// expressed in degrees clockwise from north (0-360).
func (s *Service) ComputeAspect(ctx context.Context, demLayerID uuid.UUID) (*domain.TerrainLayer, error) {
	dem, err := s.repo.GetTerrainLayer(ctx, demLayerID)
	if err != nil {
		return nil, fmt.Errorf("compute aspect: source layer: %w", err)
	}
	if dem.LayerType != domain.LayerTypeDEM {
		return nil, fmt.Errorf("compute aspect: source layer must be DEM, got %s", dem.LayerType)
	}

	// TODO: Implement aspect computation on raster data.
	aspectLayer := &domain.TerrainLayer{
		ProjectID:    dem.ProjectID,
		Name:         dem.Name + " - Aspect",
		LayerType:    domain.LayerTypeAspect,
		SourceFile:   "",
		Bounds:       dem.Bounds,
		ResolutionM:  dem.ResolutionM,
		CRS:          dem.CRS,
		MinElevation: 0,
		MaxElevation: 360,
	}

	created, err := s.repo.CreateTerrainLayer(ctx, aspectLayer)
	if err != nil {
		return nil, fmt.Errorf("compute aspect: persist: %w", err)
	}

	s.logger.Info().
		Str("dem_layer_id", demLayerID.String()).
		Str("aspect_layer_id", created.ID.String()).
		Msg("aspect layer computed")

	return created, nil
}
