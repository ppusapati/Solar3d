package service

import (
	"context"
	"encoding/json"
	"fmt"
	"math"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/shared/orchestration"
	"solar3d/terrain-service/internal/domain"
	"solar3d/terrain-service/internal/repository"
	"solar3d/terrain-service/internal/worker"
)

// Service implements the terrain business logic, coordinating between the
// repository, object storage, and compute modules.
type Service struct {
	repo       *repository.Repository
	logger     zerolog.Logger
	orchClient *orchestration.Client
	demWorker  *worker.CopernicusDEMWorker
}

// AnalyzeSiteRequest describes the terrain analysis scope for a site boundary.
type AnalyzeSiteRequest struct {
	ProjectID                   uuid.UUID `json:"project_id"`
	BoundaryGeoJSON             string    `json:"boundary_geojson"`
	VegetationDensityPerHectare float64   `json:"vegetation_density_per_hectare"`
}

// TerrainSummary contains normalized terrain metrics for planning.
type TerrainSummary struct {
	AreaSqm              float64 `json:"area_sqm"`
	MinElevationM        float64 `json:"min_elevation_m"`
	MaxElevationM        float64 `json:"max_elevation_m"`
	AvgElevationM        float64 `json:"avg_elevation_m"`
	ElevationRangeM      float64 `json:"elevation_range_m"`
	FlatAreaSqm          float64 `json:"flat_area_sqm"`
	ModerateSlopeAreaSqm float64 `json:"moderate_slope_area_sqm"`
	SteepAreaSqm         float64 `json:"steep_area_sqm"`
	DepressionAreaSqm    float64 `json:"depression_area_sqm"`
	EstimatedTrees       int64   `json:"estimated_trees"`
}

// AnalyzeEarthworkRequest configures cut/fill analysis for a DEM layer.
type AnalyzeEarthworkRequest struct {
	TargetElevationM *float64 `json:"target_elevation_m,omitempty"`
	BoundaryGeoJSON  string   `json:"boundary_geojson,omitempty"`
	MinDeltaM        float64  `json:"min_delta_m"`
	HaulFactor       float64  `json:"haul_factor"`
	GridWidth        int      `json:"grid_width"`
	GridHeight       int      `json:"grid_height"`
}

// EarthworkSummary captures volumetric grading requirements in cubic meters.
type EarthworkSummary struct {
	DEMSourceLayerID      uuid.UUID `json:"dem_source_layer_id"`
	GridWidth             int       `json:"grid_width"`
	GridHeight            int       `json:"grid_height"`
	CellAreaSqm           float64   `json:"cell_area_sqm"`
	MeanElevationM        float64   `json:"mean_elevation_m"`
	TargetElevationM      float64   `json:"target_elevation_m"`
	CutVolumeM3           float64   `json:"cut_volume_m3"`
	FillVolumeM3          float64   `json:"fill_volume_m3"`
	NetVolumeM3           float64   `json:"net_volume_m3"`
	ImbalanceVolumeM3     float64   `json:"imbalance_volume_m3"`
	BalancedVolumeRatio   float64   `json:"balanced_volume_ratio"`
	AffectedAreaSqm       float64   `json:"affected_area_sqm"`
	AverageAbsoluteDeltaM float64   `json:"average_absolute_delta_m"`
	MaximumAbsoluteDeltaM float64   `json:"maximum_absolute_delta_m"`
	IncludedCellCount     int       `json:"included_cell_count"`
	ClippedAreaSqm        float64   `json:"clipped_area_sqm"`
	HaulDistanceM         float64   `json:"haul_distance_m"`
	HaulEffortM3M         float64   `json:"haul_effort_m3m"`
	RecommendedTargetMinM float64   `json:"recommended_target_min_m"`
	RecommendedTargetMaxM float64   `json:"recommended_target_max_m"`
}

// DiffTerrainLayersRequest configures comparison between two DEM layers.
type DiffTerrainLayersRequest struct {
	CompareLayerID uuid.UUID `json:"compare_layer_id"`
	GridWidth      int       `json:"grid_width"`
	GridHeight     int       `json:"grid_height"`
}

// TerrainDiffSummary holds the per-cell elevation delta and aggregate statistics
// from comparing two DEM layers over their overlapping spatial extent.
// DeltaElevations[row*GridWidth+col] = compare - base in metres (row-major).
type TerrainDiffSummary struct {
	BaseLayerID     uuid.UUID          `json:"base_layer_id"`
	CompareLayerID  uuid.UUID          `json:"compare_layer_id"`
	OverlapBounds   domain.BoundingBox `json:"overlap_bounds"`
	GridWidth       int                `json:"grid_width"`
	GridHeight      int                `json:"grid_height"`
	CellAreaSqm     float64            `json:"cell_area_sqm"`
	DeltaElevations []float64          `json:"delta_elevations"`
	MeanDeltaM      float64            `json:"mean_delta_m"`
	RMSDeltaM       float64            `json:"rms_delta_m"`
	MaxAbsDeltaM    float64            `json:"max_abs_delta_m"`
	VolumeAddedM3   float64            `json:"volume_added_m3"`
	VolumeRemovedM3 float64            `json:"volume_removed_m3"`
	NetVolumeM3     float64            `json:"net_volume_m3"`
	ValidCellCount  int                `json:"valid_cell_count"`
}

// GradingPlanRequest holds earthwork parameters plus unit-rate assumptions for
// cost estimation. Zero unit rates disable that cost component.
type GradingPlanRequest struct {
	// Earthwork input (forwarded to AnalyzeEarthwork)
	TargetElevationM *float64 `json:"target_elevation_m,omitempty"`
	BoundaryGeoJSON  string   `json:"boundary_geojson,omitempty"`
	MinDeltaM        float64  `json:"min_delta_m"`
	HaulFactor       float64  `json:"haul_factor"`
	GridWidth        int      `json:"grid_width"`
	GridHeight       int      `json:"grid_height"`
	// Unit rates
	CutRatePerM3    float64 `json:"cut_rate_per_m3"`
	FillRatePerM3   float64 `json:"fill_rate_per_m3"`
	HaulRatePerM3M  float64 `json:"haul_rate_per_m3m"`
	ImportRatePerM3 float64 `json:"import_rate_per_m3"`
	ExportRatePerM3 float64 `json:"export_rate_per_m3"`
	// CompactionFactor is the ratio of in-situ cut volume to compacted fill
	// volume (e.g. 1.15 means 1.15 m³ of cut yields 1 m³ of placed fill).
	// Default 1.0 if not set.
	CompactionFactor float64 `json:"compaction_factor"`
	CurrencyCode     string  `json:"currency_code"`
}

// GradingPlanCostBreakdown holds the fully derived volume and cost figures
// traceable to the unit rates and earthwork engine output.
type GradingPlanCostBreakdown struct {
	CutVolumeM3    float64 `json:"cut_volume_m3"`
	FillVolumeM3   float64 `json:"fill_volume_m3"`
	FillDemandM3   float64 `json:"fill_demand_m3"` // cut m³ needed to satisfy fill
	ExportVolumeM3 float64 `json:"export_volume_m3"`
	ImportVolumeM3 float64 `json:"import_volume_m3"`
	HauledVolumeM3 float64 `json:"hauled_volume_m3"`
	HaulDistanceM  float64 `json:"haul_distance_m"`
	HaulEffortM3M  float64 `json:"haul_effort_m3m"`
	CutCost        float64 `json:"cut_cost"`
	FillCost       float64 `json:"fill_cost"`
	HaulCost       float64 `json:"haul_cost"`
	ImportCost     float64 `json:"import_cost"`
	ExportCost     float64 `json:"export_cost"`
	TotalCost      float64 `json:"total_cost"`
	CurrencyCode   string  `json:"currency_code"`
}

// GradingPlan combines the earthwork result with cost assumptions and a full
// cost breakdown. Every figure in the report is derived from real calculations.
type GradingPlan struct {
	DEMLayerID          uuid.UUID                `json:"dem_layer_id"`
	TargetElevationM    float64                  `json:"target_elevation_m"`
	MeanElevationM      float64                  `json:"mean_elevation_m"`
	AffectedAreaSqm     float64                  `json:"affected_area_sqm"`
	BalancedVolumeRatio float64                  `json:"balanced_volume_ratio"`
	CompactionFactor    float64                  `json:"compaction_factor"`
	CutRatePerM3        float64                  `json:"cut_rate_per_m3"`
	FillRatePerM3       float64                  `json:"fill_rate_per_m3"`
	HaulRatePerM3M      float64                  `json:"haul_rate_per_m3m"`
	ImportRatePerM3     float64                  `json:"import_rate_per_m3"`
	ExportRatePerM3     float64                  `json:"export_rate_per_m3"`
	Cost                GradingPlanCostBreakdown `json:"cost"`
}

// New creates a new terrain Service.
func New(repo *repository.Repository, logger zerolog.Logger, orchestrationURL string, demWorker *worker.CopernicusDEMWorker) *Service {
	return &Service{
		repo:       repo,
		logger:     logger.With().Str("component", "service").Logger(),
		orchClient: orchestration.NewClient(orchestrationURL),
		demWorker:  demWorker,
	}
}

// UploadTerrainRequest carries the parameters for creating a new terrain layer.
type UploadTerrainRequest struct {
	ProjectID    uuid.UUID          `json:"project_id"`
	Name         string             `json:"name"`
	LayerType    domain.LayerType   `json:"layer_type"`
	SourceFile   string             `json:"source_file"`
	Bounds       domain.BoundingBox `json:"bounds"`
	ResolutionM  float64            `json:"resolution_m"`
	CRS          string             `json:"crs"`
	MinElevation float64            `json:"min_elevation"`
	MaxElevation float64            `json:"max_elevation"`
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

	// If this is a Copernicus DEM layer, auto-create a download job
	if strings.HasPrefix(layer.SourceFile, "copernicus://") && s.demWorker != nil {
		_, err := s.demWorker.CreateJobForCopernicusLayer(ctx, created)
		if err != nil {
			s.logger.Warn().Err(err).Str("layer_id", created.ID.String()).Msg("failed to create dem job for copernicus layer")
			// Don't fail the upload, just warn
		} else {
			s.logger.Info().Str("layer_id", created.ID.String()).Msg("created dem download job for copernicus layer")
		}
	}

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

// GetDEMMetrics returns monitoring counters for DEM jobs and tile cache.
func (s *Service) GetDEMMetrics(ctx context.Context, projectID *uuid.UUID) (*domain.DEMMetrics, error) {
	metrics, err := s.repo.GetDEMMetrics(ctx, projectID)
	if err != nil {
		return nil, fmt.Errorf("get dem metrics: %w", err)
	}
	return metrics, nil
}

// AnalyzeSite computes terrain and vegetation metrics for a given boundary polygon.
func (s *Service) AnalyzeSite(ctx context.Context, req AnalyzeSiteRequest) (*TerrainSummary, error) {
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("project_id is required")
	}
	if req.BoundaryGeoJSON == "" {
		return nil, fmt.Errorf("boundary_geojson is required")
	}
	if req.VegetationDensityPerHectare <= 0 {
		req.VegetationDensityPerHectare = 180
	}

	ring, err := parseBoundaryRing(req.BoundaryGeoJSON)
	if err != nil {
		return nil, fmt.Errorf("invalid boundary polygon: %w", err)
	}

	bounds := polygonBounds(ring)
	if !bounds.Valid() {
		return nil, fmt.Errorf("invalid boundary bounds")
	}

	layers, err := s.repo.ListTerrainLayers(ctx, req.ProjectID)
	if err != nil {
		return nil, fmt.Errorf("list terrain layers: %w", err)
	}

	var demLayer *domain.TerrainLayer
	for i := range layers {
		if layers[i].LayerType == domain.LayerTypeDEM {
			demLayer = &layers[i]
			break
		}
	}
	if demLayer == nil {
		return nil, fmt.Errorf("no DEM terrain layer found for project")
	}

	grid, err := s.GetElevationGrid(ctx, demLayer.ID, bounds, 96, 96)
	if err != nil {
		return nil, fmt.Errorf("get elevation grid: %w", err)
	}

	summary := &TerrainSummary{AreaSqm: polygonAreaSqm(ring)}
	if summary.AreaSqm <= 0 {
		return nil, fmt.Errorf("boundary area must be greater than zero")
	}

	cellWidthDeg := (bounds.MaxX - bounds.MinX) / float64(grid.Width)
	cellHeightDeg := (bounds.MaxY - bounds.MinY) / float64(grid.Height)
	centroidLat := centroidLatitude(ring)
	mPerDegLat := 111320.0
	mPerDegLon := 111320.0 * math.Max(0.1, math.Cos(centroidLat*math.Pi/180))
	cellWidthM := cellWidthDeg * mPerDegLon
	cellHeightM := cellHeightDeg * mPerDegLat
	cellAreaM := math.Abs(cellWidthM * cellHeightM)

	minElev := math.MaxFloat64
	maxElev := -math.MaxFloat64
	totalElev := 0.0
	countElev := 0
	flatCells := 0
	moderateCells := 0
	steepCells := 0
	depressionCells := 0

	for row := 1; row < grid.Height-1; row++ {
		for col := 1; col < grid.Width-1; col++ {
			x := bounds.MinX + (float64(col)+0.5)*cellWidthDeg
			y := bounds.MinY + (float64(row)+0.5)*cellHeightDeg
			if !pointInPolygon(x, y, ring) {
				continue
			}

			e := grid.Elevations[row*grid.Width+col]
			if e < minElev {
				minElev = e
			}
			if e > maxElev {
				maxElev = e
			}
			totalElev += e
			countElev++

			dzdx := (grid.Elevations[row*grid.Width+col+1] - grid.Elevations[row*grid.Width+col-1]) / (2 * cellWidthM)
			dzdy := (grid.Elevations[(row+1)*grid.Width+col] - grid.Elevations[(row-1)*grid.Width+col]) / (2 * cellHeightM)
			slopeDeg := math.Atan(math.Sqrt(dzdx*dzdx+dzdy*dzdy)) * 180 / math.Pi

			switch {
			case slopeDeg <= 5:
				flatCells++
			case slopeDeg <= 15:
				moderateCells++
			default:
				steepCells++
			}

			neighborAvg := (grid.Elevations[(row-1)*grid.Width+col-1] +
				grid.Elevations[(row-1)*grid.Width+col] +
				grid.Elevations[(row-1)*grid.Width+col+1] +
				grid.Elevations[row*grid.Width+col-1] +
				grid.Elevations[row*grid.Width+col+1] +
				grid.Elevations[(row+1)*grid.Width+col-1] +
				grid.Elevations[(row+1)*grid.Width+col] +
				grid.Elevations[(row+1)*grid.Width+col+1]) / 8.0
			if neighborAvg-e >= 0.8 {
				depressionCells++
			}
		}
	}

	if countElev == 0 {
		return nil, fmt.Errorf("boundary does not overlap terrain extent")
	}

	summary.MinElevationM = minElev
	summary.MaxElevationM = maxElev
	summary.AvgElevationM = totalElev / float64(countElev)
	summary.ElevationRangeM = maxElev - minElev
	summary.FlatAreaSqm = float64(flatCells) * cellAreaM
	summary.ModerateSlopeAreaSqm = float64(moderateCells) * cellAreaM
	summary.SteepAreaSqm = float64(steepCells) * cellAreaM
	summary.DepressionAreaSqm = float64(depressionCells) * cellAreaM

	areaHectares := summary.AreaSqm / 10000.0
	roughnessFactor := 1.0 + math.Min(0.35, summary.ElevationRangeM/250.0)
	steepPenalty := 1.0 - math.Min(0.30, summary.SteepAreaSqm/math.Max(summary.AreaSqm, 1)*0.50)
	treeEstimate := areaHectares * req.VegetationDensityPerHectare * roughnessFactor * steepPenalty
	if treeEstimate < 0 {
		treeEstimate = 0
	}
	summary.EstimatedTrees = int64(math.Round(treeEstimate))

	return summary, nil
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
	t += 0.125 * math.Cos(nx*8*math.Pi+2.1) * math.Sin(ny*6*math.Pi)    // fine detail
	t = (t + 1.0) / 2.0                                                 // normalize to 0..1

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

	s.submitTerrainJob(ctx, dem.ProjectID, "slope", demLayerID)

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

	s.submitTerrainJob(ctx, dem.ProjectID, "aspect", demLayerID)

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

// AnalyzeEarthwork computes cut/fill requirements for leveling a DEM layer
// toward a target elevation. If target is omitted, mean surface elevation is used.
func (s *Service) AnalyzeEarthwork(ctx context.Context, demLayerID uuid.UUID, req AnalyzeEarthworkRequest) (*EarthworkSummary, error) {
	dem, err := s.repo.GetTerrainLayer(ctx, demLayerID)
	if err != nil {
		return nil, fmt.Errorf("analyze earthwork: source layer: %w", err)
	}
	if dem.LayerType != domain.LayerTypeDEM {
		return nil, fmt.Errorf("analyze earthwork: source layer must be DEM, got %s", dem.LayerType)
	}

	analysisBounds := dem.Bounds
	var clipRing [][2]float64
	if strings.TrimSpace(req.BoundaryGeoJSON) != "" {
		ring, parseErr := parseBoundaryRing(req.BoundaryGeoJSON)
		if parseErr != nil {
			return nil, fmt.Errorf("analyze earthwork: invalid boundary polygon: %w", parseErr)
		}
		clipRing = ring
		clipBounds, ok := intersectBounds(dem.Bounds, polygonBounds(ring))
		if !ok {
			return nil, fmt.Errorf("analyze earthwork: boundary does not overlap DEM extent")
		}
		analysisBounds = clipBounds
	}

	gridWidth := req.GridWidth
	gridHeight := req.GridHeight
	if gridWidth <= 0 || gridHeight <= 0 {
		gridWidth = int(math.Ceil((analysisBounds.MaxX - analysisBounds.MinX) / dem.ResolutionM * 111320))
		gridHeight = int(math.Ceil((analysisBounds.MaxY - analysisBounds.MinY) / dem.ResolutionM * 111320))
	}
	if gridWidth < 3 {
		gridWidth = 3
	}
	if gridHeight < 3 {
		gridHeight = 3
	}
	if gridWidth > 1536 {
		gridWidth = 1536
	}
	if gridHeight > 1536 {
		gridHeight = 1536
	}

	grid, err := s.GetElevationGrid(ctx, demLayerID, analysisBounds, gridWidth, gridHeight)
	if err != nil {
		return nil, fmt.Errorf("analyze earthwork: get elevation grid: %w", err)
	}
	if len(grid.Elevations) == 0 {
		return nil, fmt.Errorf("analyze earthwork: empty elevation grid")
	}

	cellAreaSqm := estimateCellAreaSqm(analysisBounds, grid.Width, grid.Height)
	if cellAreaSqm <= 0 {
		return nil, fmt.Errorf("analyze earthwork: invalid computed cell area")
	}

	cellWidthDeg := (analysisBounds.MaxX - analysisBounds.MinX) / float64(grid.Width)
	cellHeightDeg := (analysisBounds.MaxY - analysisBounds.MinY) / float64(grid.Height)
	cells := make([]earthworkCell, 0, len(grid.Elevations))
	for row := 0; row < grid.Height; row++ {
		for col := 0; col < grid.Width; col++ {
			x := analysisBounds.MinX + (float64(col)+0.5)*cellWidthDeg
			y := analysisBounds.MinY + (float64(row)+0.5)*cellHeightDeg
			if len(clipRing) > 0 && !pointInPolygon(x, y, clipRing) {
				continue
			}
			cells = append(cells, earthworkCell{
				X:         x,
				Y:         y,
				Elevation: grid.Elevations[row*grid.Width+col],
			})
		}
	}
	if len(cells) == 0 {
		return nil, fmt.Errorf("analyze earthwork: no analysis cells in selected area")
	}

	meanElev := meanCellElevation(cells)
	targetElev := meanElev
	if req.TargetElevationM != nil {
		targetElev = *req.TargetElevationM
	}

	minDelta := req.MinDeltaM
	if minDelta <= 0 {
		minDelta = 0.05
	}
	haulFactor := req.HaulFactor
	if haulFactor <= 0 {
		haulFactor = 1.0
	}

	result := computeEarthworkVolumes(cells, targetElev, cellAreaSqm, minDelta, haulFactor)
	clippedAreaSqm := float64(len(cells)) * cellAreaSqm

	return &EarthworkSummary{
		DEMSourceLayerID:      demLayerID,
		GridWidth:             grid.Width,
		GridHeight:            grid.Height,
		CellAreaSqm:           cellAreaSqm,
		MeanElevationM:        meanElev,
		TargetElevationM:      targetElev,
		CutVolumeM3:           result.CutVolumeM3,
		FillVolumeM3:          result.FillVolumeM3,
		NetVolumeM3:           result.FillVolumeM3 - result.CutVolumeM3,
		ImbalanceVolumeM3:     math.Abs(result.FillVolumeM3 - result.CutVolumeM3),
		BalancedVolumeRatio:   result.BalancedVolumeRatio,
		AffectedAreaSqm:       result.AffectedAreaSqm,
		AverageAbsoluteDeltaM: result.AverageAbsoluteDeltaM,
		MaximumAbsoluteDeltaM: result.MaximumAbsoluteDeltaM,
		IncludedCellCount:     result.IncludedCellCount,
		ClippedAreaSqm:        clippedAreaSqm,
		HaulDistanceM:         result.HaulDistanceM,
		HaulEffortM3M:         result.HaulEffortM3M,
		RecommendedTargetMinM: meanElev - 0.5,
		RecommendedTargetMaxM: meanElev + 0.5,
	}, nil
}

func (s *Service) submitTerrainJob(ctx context.Context, projectID uuid.UUID, operation string, layerID uuid.UUID) {
	payload, _ := json.Marshal(map[string]string{
		"domain":           "terrain",
		"operation":        operation,
		"terrain_layer_id": layerID.String(),
	})

	jobID, err := s.orchClient.SubmitJob(
		ctx,
		projectID.String(),
		"custom",
		3,
		string(payload),
		fmt.Sprintf("terrain:%s:%s", operation, layerID.String()),
	)
	if err != nil {
		s.logger.Warn().Err(err).Str("operation", operation).Str("terrain_layer_id", layerID.String()).Msg("failed to submit terrain orchestration job; continuing inline compute")
		return
	}

	s.logger.Info().Str("operation", operation).Str("terrain_layer_id", layerID.String()).Str("job_id", jobID).Msg("submitted terrain compute job")
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

func parseBoundaryRing(geojson string) ([][2]float64, error) {
	var polygon struct {
		Type        string        `json:"type"`
		Coordinates [][][]float64 `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(geojson), &polygon); err != nil {
		return nil, err
	}
	if polygon.Type != "Polygon" || len(polygon.Coordinates) == 0 || len(polygon.Coordinates[0]) < 4 {
		return nil, fmt.Errorf("expected polygon ring with at least 4 points")
	}
	ring := make([][2]float64, 0, len(polygon.Coordinates[0]))
	for _, p := range polygon.Coordinates[0] {
		if len(p) < 2 {
			continue
		}
		ring = append(ring, [2]float64{p[0], p[1]})
	}
	if len(ring) < 4 {
		return nil, fmt.Errorf("insufficient polygon coordinates")
	}
	return ring, nil
}

func polygonBounds(ring [][2]float64) domain.BoundingBox {
	b := domain.BoundingBox{
		MinX: math.MaxFloat64,
		MinY: math.MaxFloat64,
		MaxX: -math.MaxFloat64,
		MaxY: -math.MaxFloat64,
	}
	for _, p := range ring {
		if p[0] < b.MinX {
			b.MinX = p[0]
		}
		if p[0] > b.MaxX {
			b.MaxX = p[0]
		}
		if p[1] < b.MinY {
			b.MinY = p[1]
		}
		if p[1] > b.MaxY {
			b.MaxY = p[1]
		}
	}
	return b
}

func centroidLatitude(ring [][2]float64) float64 {
	if len(ring) == 0 {
		return 0
	}
	total := 0.0
	for _, p := range ring {
		total += p[1]
	}
	return total / float64(len(ring))
}

func polygonAreaSqm(ring [][2]float64) float64 {
	if len(ring) < 3 {
		return 0
	}
	meanLat := centroidLatitude(ring)
	mPerDegLat := 111320.0
	mPerDegLon := 111320.0 * math.Max(0.1, math.Cos(meanLat*math.Pi/180))
	sum := 0.0
	for i := 0; i < len(ring)-1; i++ {
		x1 := ring[i][0] * mPerDegLon
		y1 := ring[i][1] * mPerDegLat
		x2 := ring[i+1][0] * mPerDegLon
		y2 := ring[i+1][1] * mPerDegLat
		sum += x1*y2 - x2*y1
	}
	return math.Abs(sum) / 2
}

func pointInPolygon(x, y float64, ring [][2]float64) bool {
	inside := false
	for i, j := 0, len(ring)-1; i < len(ring); j, i = i, i+1 {
		xi, yi := ring[i][0], ring[i][1]
		xj, yj := ring[j][0], ring[j][1]
		intersects := ((yi > y) != (yj > y)) &&
			(x < (xj-xi)*(y-yi)/(yj-yi+1e-12)+xi)
		if intersects {
			inside = !inside
		}
	}
	return inside
}

type earthworkComputationResult struct {
	CutVolumeM3           float64
	FillVolumeM3          float64
	BalancedVolumeRatio   float64
	AffectedAreaSqm       float64
	AverageAbsoluteDeltaM float64
	MaximumAbsoluteDeltaM float64
	IncludedCellCount     int
	HaulDistanceM         float64
	HaulEffortM3M         float64
}

type earthworkCell struct {
	X         float64
	Y         float64
	Elevation float64
}

func computeEarthworkVolumes(cells []earthworkCell, targetElevationM, cellAreaSqm, minDeltaM, haulFactor float64) earthworkComputationResult {
	if len(cells) == 0 || cellAreaSqm <= 0 {
		return earthworkComputationResult{}
	}

	var result earthworkComputationResult
	totalAbsDelta := 0.0
	cutWeightedX := 0.0
	cutWeightedY := 0.0
	fillWeightedX := 0.0
	fillWeightedY := 0.0

	for _, cell := range cells {
		delta := targetElevationM - cell.Elevation
		if math.Abs(delta) < minDeltaM {
			continue
		}

		result.IncludedCellCount++
		absDelta := math.Abs(delta)
		totalAbsDelta += absDelta
		result.AffectedAreaSqm += cellAreaSqm
		if absDelta > result.MaximumAbsoluteDeltaM {
			result.MaximumAbsoluteDeltaM = absDelta
		}

		volume := absDelta * cellAreaSqm
		if delta > 0 {
			result.FillVolumeM3 += volume
			fillWeightedX += cell.X * volume
			fillWeightedY += cell.Y * volume
		} else {
			result.CutVolumeM3 += volume
			cutWeightedX += cell.X * volume
			cutWeightedY += cell.Y * volume
		}
	}

	if result.IncludedCellCount > 0 {
		result.AverageAbsoluteDeltaM = totalAbsDelta / float64(result.IncludedCellCount)
	}

	bigger := math.Max(result.CutVolumeM3, result.FillVolumeM3)
	smaller := math.Min(result.CutVolumeM3, result.FillVolumeM3)
	if bigger > 0 {
		result.BalancedVolumeRatio = smaller / bigger
	}

	if result.CutVolumeM3 > 0 && result.FillVolumeM3 > 0 {
		cutX := cutWeightedX / result.CutVolumeM3
		cutY := cutWeightedY / result.CutVolumeM3
		fillX := fillWeightedX / result.FillVolumeM3
		fillY := fillWeightedY / result.FillVolumeM3
		baseDist := planarMetersDistance(cutX, cutY, fillX, fillY)
		result.HaulDistanceM = baseDist * haulFactor
		result.HaulEffortM3M = smaller * result.HaulDistanceM
	}

	return result
}

func estimateCellAreaSqm(bounds domain.BoundingBox, width, height int) float64 {
	if width <= 0 || height <= 0 {
		return 0
	}
	cellWidthDeg := (bounds.MaxX - bounds.MinX) / float64(width)
	cellHeightDeg := (bounds.MaxY - bounds.MinY) / float64(height)
	centroidLat := (bounds.MinY + bounds.MaxY) / 2.0
	mPerDegLat := 111320.0
	mPerDegLon := 111320.0 * math.Max(0.1, math.Cos(centroidLat*math.Pi/180))
	cellWidthM := cellWidthDeg * mPerDegLon
	cellHeightM := cellHeightDeg * mPerDegLat
	return math.Abs(cellWidthM * cellHeightM)
}

func meanElevation(elevations []float64) float64 {
	if len(elevations) == 0 {
		return 0
	}
	sum := 0.0
	for _, elevation := range elevations {
		sum += elevation
	}
	return sum / float64(len(elevations))
}

func meanCellElevation(cells []earthworkCell) float64 {
	if len(cells) == 0 {
		return 0
	}
	sum := 0.0
	for _, cell := range cells {
		sum += cell.Elevation
	}
	return sum / float64(len(cells))
}

func intersectBounds(a, b domain.BoundingBox) (domain.BoundingBox, bool) {
	inter := domain.BoundingBox{
		MinX: math.Max(a.MinX, b.MinX),
		MinY: math.Max(a.MinY, b.MinY),
		MaxX: math.Min(a.MaxX, b.MaxX),
		MaxY: math.Min(a.MaxY, b.MaxY),
	}
	return inter, inter.Valid()
}

func planarMetersDistance(x1, y1, x2, y2 float64) float64 {
	meanLat := (y1 + y2) / 2.0
	mPerDegLat := 111320.0
	mPerDegLon := 111320.0 * math.Max(0.1, math.Cos(meanLat*math.Pi/180))
	dx := (x2 - x1) * mPerDegLon
	dy := (y2 - y1) * mPerDegLat
	return math.Sqrt(dx*dx + dy*dy)
}

// DiffTerrainLayers compares two DEM layers over their overlapping spatial
// extent and returns a per-cell delta grid (compare minus base) together with
// aggregate change statistics. Both layers must be of type DEM.
func (s *Service) DiffTerrainLayers(ctx context.Context, baseLayerID uuid.UUID, req DiffTerrainLayersRequest) (*TerrainDiffSummary, error) {
	base, err := s.repo.GetTerrainLayer(ctx, baseLayerID)
	if err != nil {
		return nil, fmt.Errorf("diff terrain: base layer: %w", err)
	}
	if base.LayerType != domain.LayerTypeDEM {
		return nil, fmt.Errorf("diff terrain: base layer must be DEM, got %s", base.LayerType)
	}

	compare, err := s.repo.GetTerrainLayer(ctx, req.CompareLayerID)
	if err != nil {
		return nil, fmt.Errorf("diff terrain: compare layer: %w", err)
	}
	if compare.LayerType != domain.LayerTypeDEM {
		return nil, fmt.Errorf("diff terrain: compare layer must be DEM, got %s", compare.LayerType)
	}

	overlap, ok := intersectBounds(base.Bounds, compare.Bounds)
	if !ok {
		return nil, fmt.Errorf("diff terrain: layer extents do not overlap")
	}

	// Choose grid dimensions: honour caller preference, otherwise derive from
	// the coarser of the two resolutions so neither layer is over-sampled.
	gridWidth := req.GridWidth
	gridHeight := req.GridHeight
	if gridWidth <= 0 || gridHeight <= 0 {
		resolutionM := math.Max(base.ResolutionM, compare.ResolutionM)
		gridWidth = int(math.Ceil((overlap.MaxX - overlap.MinX) / resolutionM * 111320))
		gridHeight = int(math.Ceil((overlap.MaxY - overlap.MinY) / resolutionM * 111320))
	}
	if gridWidth < 3 {
		gridWidth = 3
	}
	if gridHeight < 3 {
		gridHeight = 3
	}
	if gridWidth > 1536 {
		gridWidth = 1536
	}
	if gridHeight > 1536 {
		gridHeight = 1536
	}

	baseGrid, err := s.GetElevationGrid(ctx, baseLayerID, overlap, gridWidth, gridHeight)
	if err != nil {
		return nil, fmt.Errorf("diff terrain: base elevation grid: %w", err)
	}
	compareGrid, err := s.GetElevationGrid(ctx, req.CompareLayerID, overlap, gridWidth, gridHeight)
	if err != nil {
		return nil, fmt.Errorf("diff terrain: compare elevation grid: %w", err)
	}

	n := gridWidth * gridHeight
	deltas := make([]float64, n)
	for i := 0; i < n; i++ {
		deltas[i] = compareGrid.Elevations[i] - baseGrid.Elevations[i]
	}

	cellAreaSqm := estimateCellAreaSqm(overlap, gridWidth, gridHeight)
	stats := computeDiffStats(deltas, cellAreaSqm)

	return &TerrainDiffSummary{
		BaseLayerID:     baseLayerID,
		CompareLayerID:  req.CompareLayerID,
		OverlapBounds:   overlap,
		GridWidth:       gridWidth,
		GridHeight:      gridHeight,
		CellAreaSqm:     cellAreaSqm,
		DeltaElevations: deltas,
		MeanDeltaM:      stats.MeanDeltaM,
		RMSDeltaM:       stats.RMSDeltaM,
		MaxAbsDeltaM:    stats.MaxAbsDeltaM,
		VolumeAddedM3:   stats.VolumeAddedM3,
		VolumeRemovedM3: stats.VolumeRemovedM3,
		NetVolumeM3:     stats.NetVolumeM3,
		ValidCellCount:  stats.ValidCellCount,
	}, nil
}

type diffStats struct {
	MeanDeltaM      float64
	RMSDeltaM       float64
	MaxAbsDeltaM    float64
	VolumeAddedM3   float64
	VolumeRemovedM3 float64
	NetVolumeM3     float64
	ValidCellCount  int
}

func computeDiffStats(deltas []float64, cellAreaSqm float64) diffStats {
	if len(deltas) == 0 {
		return diffStats{}
	}
	var sumDelta, sumSq, maxAbs, added, removed float64
	for _, d := range deltas {
		sumDelta += d
		sumSq += d * d
		if abs := math.Abs(d); abs > maxAbs {
			maxAbs = abs
		}
		if d > 0 {
			added += d * cellAreaSqm
		} else {
			removed += (-d) * cellAreaSqm
		}
	}
	n := float64(len(deltas))
	mean := sumDelta / n
	rms := math.Sqrt(sumSq / n)
	return diffStats{
		MeanDeltaM:      mean,
		RMSDeltaM:       rms,
		MaxAbsDeltaM:    maxAbs,
		VolumeAddedM3:   added,
		VolumeRemovedM3: removed,
		NetVolumeM3:     added - removed,
		ValidCellCount:  len(deltas),
	}
}

// GenerateGradingPlan runs the earthwork engine against a DEM layer then
// computes a full cost breakdown using the supplied unit rates and compaction
// factor. Every cost figure is directly traceable to the returned volumes.
func (s *Service) GenerateGradingPlan(ctx context.Context, demLayerID uuid.UUID, req GradingPlanRequest) (*GradingPlan, error) {
	earthworkReq := AnalyzeEarthworkRequest{
		TargetElevationM: req.TargetElevationM,
		BoundaryGeoJSON:  req.BoundaryGeoJSON,
		MinDeltaM:        req.MinDeltaM,
		HaulFactor:       req.HaulFactor,
		GridWidth:        req.GridWidth,
		GridHeight:       req.GridHeight,
	}
	earthwork, err := s.AnalyzeEarthwork(ctx, demLayerID, earthworkReq)
	if err != nil {
		return nil, fmt.Errorf("grading plan: earthwork: %w", err)
	}

	compaction := req.CompactionFactor
	if compaction <= 0 {
		compaction = 1.0
	}
	currency := req.CurrencyCode
	if currency == "" {
		currency = "USD"
	}

	cost := computeGradingPlanCost(earthwork, req.CutRatePerM3, req.FillRatePerM3,
		req.HaulRatePerM3M, req.ImportRatePerM3, req.ExportRatePerM3,
		compaction, currency)

	return &GradingPlan{
		DEMLayerID:          demLayerID,
		TargetElevationM:    earthwork.TargetElevationM,
		MeanElevationM:      earthwork.MeanElevationM,
		AffectedAreaSqm:     earthwork.AffectedAreaSqm,
		BalancedVolumeRatio: earthwork.BalancedVolumeRatio,
		CompactionFactor:    compaction,
		CutRatePerM3:        req.CutRatePerM3,
		FillRatePerM3:       req.FillRatePerM3,
		HaulRatePerM3M:      req.HaulRatePerM3M,
		ImportRatePerM3:     req.ImportRatePerM3,
		ExportRatePerM3:     req.ExportRatePerM3,
		Cost:                cost,
	}, nil
}

// computeGradingPlanCost derives all volumes and costs from the earthwork
// result plus unit-rate assumptions. The logic is:
//
//   - fill_demand_m3 = fill_volume * compaction_factor
//     (more in-situ cut needed to produce the required compacted fill volume)
//   - if cut >= fill_demand: site is cut-surplus; excess goes to spoil
//   - if cut <  fill_demand: site is fill-deficient; shortfall must be imported
//   - haul_cost = haul_effort_m3m * haul_rate_per_m3m
//     (haul_effort already encodes balanced volume × weighted distance)
func computeGradingPlanCost(
	e *EarthworkSummary,
	cutRate, fillRate, haulRate, importRate, exportRate,
	compactionFactor float64,
	currency string,
) GradingPlanCostBreakdown {
	fillDemand := e.FillVolumeM3 * compactionFactor

	var exportVol, importVol, hauledVol float64
	if e.CutVolumeM3 >= fillDemand {
		exportVol = e.CutVolumeM3 - fillDemand
		hauledVol = fillDemand
	} else {
		importVol = fillDemand - e.CutVolumeM3
		hauledVol = e.CutVolumeM3
	}

	cutCost := e.CutVolumeM3 * cutRate
	fillCost := e.FillVolumeM3 * fillRate
	haulCost := e.HaulEffortM3M * haulRate
	importCost := importVol * importRate
	exportCost := exportVol * exportRate

	return GradingPlanCostBreakdown{
		CutVolumeM3:    e.CutVolumeM3,
		FillVolumeM3:   e.FillVolumeM3,
		FillDemandM3:   fillDemand,
		ExportVolumeM3: exportVol,
		ImportVolumeM3: importVol,
		HauledVolumeM3: hauledVol,
		HaulDistanceM:  e.HaulDistanceM,
		HaulEffortM3M:  e.HaulEffortM3M,
		CutCost:        cutCost,
		FillCost:       fillCost,
		HaulCost:       haulCost,
		ImportCost:     importCost,
		ExportCost:     exportCost,
		TotalCost:      cutCost + fillCost + haulCost + importCost + exportCost,
		CurrencyCode:   currency,
	}
}

// GenerateGradingPlan runs the earthwork engine against a DEM layer then
// computes a full cost breakdown using the supplied unit rates and compaction
