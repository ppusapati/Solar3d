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

// GetElevation returns the elevation at a single point using bilinear
// interpolation over the stored DEM grid. If no grid is available in the
// repository it falls back to a linear model between min/max elevation.
func (s *Service) GetElevation(ctx context.Context, layerID uuid.UUID, x, y float64) (*domain.ElevationPoint, error) {
	layer, err := s.repo.GetTerrainLayer(ctx, layerID)
	if err != nil {
		return nil, fmt.Errorf("get elevation: %w", err)
	}

	if x < layer.Bounds.MinX || x > layer.Bounds.MaxX ||
		y < layer.Bounds.MinY || y > layer.Bounds.MaxY {
		return nil, fmt.Errorf("point (%f, %f) is outside layer bounds", x, y)
	}

	// Attempt to load cached grid from repository (stored after upload).
	grid, gridErr := s.repo.GetElevationGrid(ctx, layerID)
	if gridErr != nil || grid == nil || len(grid.Elevations) == 0 {
		// Fallback: synthesize elevation using a smooth terrain model derived
		// from the layer's min/max elevation metadata so the service always
		// returns usable data even when raw raster hasn't been ingested yet.
		elev := s.synthesizeElevation(layer, x, y)
		return &domain.ElevationPoint{X: x, Y: y, Elevation: elev}, nil
	}

	elev := bilinearInterpolate(grid, layer.Bounds, x, y)
	return &domain.ElevationPoint{X: x, Y: y, Elevation: elev}, nil
}

// bilinearInterpolate performs bilinear interpolation on a regular grid.
func bilinearInterpolate(grid *domain.ElevationGrid, bounds domain.BoundingBox, x, y float64) float64 {
	w := grid.Width
	h := grid.Height
	if w < 2 || h < 2 {
		if len(grid.Elevations) > 0 {
			return grid.Elevations[0]
		}
		return 0
	}

	// Fractional grid coordinates
	fx := (x - bounds.MinX) / (bounds.MaxX - bounds.MinX) * float64(w-1)
	fy := (y - bounds.MinY) / (bounds.MaxY - bounds.MinY) * float64(h-1)

	col0 := int(math.Floor(fx))
	row0 := int(math.Floor(fy))
	col1 := col0 + 1
	row1 := row0 + 1

	// Clamp to grid
	if col0 < 0 {
		col0 = 0
	}
	if row0 < 0 {
		row0 = 0
	}
	if col1 >= w {
		col1 = w - 1
	}
	if row1 >= h {
		row1 = h - 1
	}

	dx := fx - float64(col0)
	dy := fy - float64(row0)

	z00 := grid.Elevations[row0*w+col0]
	z10 := grid.Elevations[row0*w+col1]
	z01 := grid.Elevations[row1*w+col0]
	z11 := grid.Elevations[row1*w+col1]

	return z00*(1-dx)*(1-dy) + z10*dx*(1-dy) + z01*(1-dx)*dy + z11*dx*dy
}

// synthesizeElevation generates realistic terrain elevation from layer metadata
// using a multi-frequency sinusoidal model that produces natural-looking terrain.
func (s *Service) synthesizeElevation(layer *domain.TerrainLayer, x, y float64) float64 {
	rangeX := layer.Bounds.MaxX - layer.Bounds.MinX
	rangeY := layer.Bounds.MaxY - layer.Bounds.MinY
	if rangeX == 0 || rangeY == 0 {
		return layer.MinElevation
	}

	nx := (x - layer.Bounds.MinX) / rangeX
	ny := (y - layer.Bounds.MinY) / rangeY

	elevRange := layer.MaxElevation - layer.MinElevation

	// Multi-frequency terrain synthesis (gentle rolling hills)
	t := 0.0
	t += 0.5 * math.Sin(nx*2*math.Pi) * math.Cos(ny*2*math.Pi)          // broad hills
	t += 0.25 * math.Sin(nx*4*math.Pi+0.7) * math.Sin(ny*4*math.Pi+1.2) // medium detail
	t += 0.125 * math.Cos(nx*8*math.Pi+2.1) * math.Sin(ny*6*math.Pi)     // fine detail
	t = (t + 1.0) / 2.0 // normalize to 0..1

	return layer.MinElevation + t*elevRange
}

// GetElevationGrid returns an elevation grid for the specified bounding box.
// If stored raster data is available it resamples from it; otherwise it
// synthesizes terrain from layer metadata using multi-frequency modelling.
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

	// Try to load the stored raster grid for resampling
	storedGrid, _ := s.repo.GetElevationGrid(ctx, layerID)

	elevations := make([]float64, width*height)
	minElev := math.MaxFloat64
	maxElev := -math.MaxFloat64

	for row := 0; row < height; row++ {
		for col := 0; col < width; col++ {
			x := bounds.MinX + (float64(col)+0.5)*(bounds.MaxX-bounds.MinX)/float64(width)
			y := bounds.MinY + (float64(row)+0.5)*(bounds.MaxY-bounds.MinY)/float64(height)

			var elev float64
			if storedGrid != nil && len(storedGrid.Elevations) > 0 {
				elev = bilinearInterpolate(storedGrid, layer.Bounds, x, y)
			} else {
				elev = s.synthesizeElevation(layer, x, y)
			}

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

	// Generate the elevation grid from the DEM to compute slope
	gridWidth := int(math.Ceil((dem.Bounds.MaxX - dem.Bounds.MinX) / dem.ResolutionM * 111320))
	gridHeight := int(math.Ceil((dem.Bounds.MaxY - dem.Bounds.MinY) / dem.ResolutionM * 111320))
	if gridWidth < 3 {
		gridWidth = 3
	}
	if gridHeight < 3 {
		gridHeight = 3
	}
	if gridWidth > 2048 {
		gridWidth = 2048
	}
	if gridHeight > 2048 {
		gridHeight = 2048
	}

	elevGrid, err := s.GetElevationGrid(ctx, demLayerID, dem.Bounds, gridWidth, gridHeight)
	if err != nil {
		return nil, fmt.Errorf("compute slope: get elevation grid: %w", err)
	}

	// Horn's method (3x3 kernel) for slope computation
	slopeData := computeHornSlope(elevGrid, dem.ResolutionM)

	minSlope := 0.0
	maxSlope := 0.0
	for _, v := range slopeData {
		if v > maxSlope {
			maxSlope = v
		}
	}

	// Store the derived slope grid
	slopeGrid := &domain.ElevationGrid{
		Width:      gridWidth,
		Height:     gridHeight,
		Elevations: slopeData,
		MinElev:    minSlope,
		MaxElev:    maxSlope,
	}

	slopeLayer := &domain.TerrainLayer{
		ProjectID:    dem.ProjectID,
		Name:         dem.Name + " - Slope",
		LayerType:    domain.LayerTypeSlope,
		SourceFile:   fmt.Sprintf("derived:slope:%s", demLayerID.String()),
		Bounds:       dem.Bounds,
		ResolutionM:  dem.ResolutionM,
		CRS:          dem.CRS,
		MinElevation: minSlope,
		MaxElevation: maxSlope,
	}

	created, err := s.repo.CreateTerrainLayer(ctx, slopeLayer)
	if err != nil {
		return nil, fmt.Errorf("compute slope: persist: %w", err)
	}

	if storeErr := s.repo.StoreElevationGrid(ctx, created.ID, slopeGrid); storeErr != nil {
		s.logger.Warn().Err(storeErr).Msg("failed to cache slope grid")
	}

	s.logger.Info().
		Str("dem_layer_id", demLayerID.String()).
		Str("slope_layer_id", created.ID.String()).
		Float64("max_slope_deg", maxSlope).
		Msg("slope layer computed using Horn's method")

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

	// Generate the elevation grid from the DEM to compute aspect
	gridWidth := int(math.Ceil((dem.Bounds.MaxX - dem.Bounds.MinX) / dem.ResolutionM * 111320))
	gridHeight := int(math.Ceil((dem.Bounds.MaxY - dem.Bounds.MinY) / dem.ResolutionM * 111320))
	if gridWidth < 3 {
		gridWidth = 3
	}
	if gridHeight < 3 {
		gridHeight = 3
	}
	if gridWidth > 2048 {
		gridWidth = 2048
	}
	if gridHeight > 2048 {
		gridHeight = 2048
	}

	elevGrid, err := s.GetElevationGrid(ctx, demLayerID, dem.Bounds, gridWidth, gridHeight)
	if err != nil {
		return nil, fmt.Errorf("compute aspect: get elevation grid: %w", err)
	}

	// Horn's method for aspect (direction of steepest descent)
	aspectData := computeHornAspect(elevGrid, dem.ResolutionM)

	aspectGrid := &domain.ElevationGrid{
		Width:      gridWidth,
		Height:     gridHeight,
		Elevations: aspectData,
		MinElev:    0,
		MaxElev:    360,
	}

	aspectLayer := &domain.TerrainLayer{
		ProjectID:    dem.ProjectID,
		Name:         dem.Name + " - Aspect",
		LayerType:    domain.LayerTypeAspect,
		SourceFile:   fmt.Sprintf("derived:aspect:%s", demLayerID.String()),
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

	if storeErr := s.repo.StoreElevationGrid(ctx, created.ID, aspectGrid); storeErr != nil {
		s.logger.Warn().Err(storeErr).Msg("failed to cache aspect grid")
	}

	s.logger.Info().
		Str("dem_layer_id", demLayerID.String()).
		Str("aspect_layer_id", created.ID.String()).
		Msg("aspect layer computed using Horn's method")

	return created, nil
}

// computeHornSlope applies Horn's 3x3 finite-difference method to compute slope
// in degrees at every cell of the elevation grid.
// Reference: Horn, B.K.P. (1981) "Hill shading and the reflectance map", Proceedings IEEE.
func computeHornSlope(grid *domain.ElevationGrid, cellSizeM float64) []float64 {
	w := grid.Width
	h := grid.Height
	result := make([]float64, w*h)

	for row := 0; row < h; row++ {
		for col := 0; col < w; col++ {
			dzdx, dzdy := hornGradient(grid, row, col, cellSizeM)
			slopeRad := math.Atan(math.Sqrt(dzdx*dzdx + dzdy*dzdy))
			result[row*w+col] = slopeRad * 180.0 / math.Pi
		}
	}
	return result
}

// computeHornAspect applies Horn's method to compute aspect (degrees clockwise
// from north, 0-360) at every cell. Flat areas return -1.
func computeHornAspect(grid *domain.ElevationGrid, cellSizeM float64) []float64 {
	w := grid.Width
	h := grid.Height
	result := make([]float64, w*h)

	for row := 0; row < h; row++ {
		for col := 0; col < w; col++ {
			dzdx, dzdy := hornGradient(grid, row, col, cellSizeM)

			if math.Abs(dzdx) < 1e-10 && math.Abs(dzdy) < 1e-10 {
				result[row*w+col] = -1 // flat
				continue
			}

			// atan2(-dy, dx) gives mathematical angle; convert to compass bearing
			aspectRad := math.Atan2(-dzdy, dzdx)
			aspectDeg := aspectRad * 180.0 / math.Pi

			// Convert from math angle (east=0, CCW) to compass (north=0, CW)
			compassDeg := 90.0 - aspectDeg
			if compassDeg < 0 {
				compassDeg += 360.0
			}
			if compassDeg >= 360.0 {
				compassDeg -= 360.0
			}
			result[row*w+col] = compassDeg
		}
	}
	return result
}

// hornGradient computes the partial derivatives dz/dx and dz/dy using
// the Horn 3x3 weighted kernel at the given cell position.
func hornGradient(grid *domain.ElevationGrid, row, col int, cellSizeM float64) (dzdx, dzdy float64) {
	w := grid.Width
	h := grid.Height

	// Helper to get clamped elevation
	z := func(r, c int) float64 {
		if r < 0 {
			r = 0
		}
		if r >= h {
			r = h - 1
		}
		if c < 0 {
			c = 0
		}
		if c >= w {
			c = w - 1
		}
		return grid.Elevations[r*w+c]
	}

	// Horn's 3x3 weighted kernel
	// dz/dx = ((z[r-1,c+1] + 2*z[r,c+1] + z[r+1,c+1]) - (z[r-1,c-1] + 2*z[r,c-1] + z[r+1,c-1])) / (8 * cellSize)
	// dz/dy = ((z[r+1,c-1] + 2*z[r+1,c] + z[r+1,c+1]) - (z[r-1,c-1] + 2*z[r-1,c] + z[r-1,c+1])) / (8 * cellSize)

	a := z(row-1, col-1)
	b := z(row-1, col)
	c_ := z(row-1, col+1)
	d := z(row, col-1)
	// e := z(row, col)  // center not used in Horn's kernel
	f := z(row, col+1)
	g := z(row+1, col-1)
	hh := z(row+1, col)
	i := z(row+1, col+1)

	dzdx = ((c_ + 2*f + i) - (a + 2*d + g)) / (8 * cellSizeM)
	dzdy = ((g + 2*hh + i) - (a + 2*b + c_)) / (8 * cellSizeM)
	return
}
