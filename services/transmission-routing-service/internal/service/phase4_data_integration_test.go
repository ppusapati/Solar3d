package service

import (
	"context"
	"encoding/json"
	"math"
	"testing"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
)

// ─────────────────────────────────────────────────────────────────────────────
// Test helpers
// ─────────────────────────────────────────────────────────────────────────────

// flatRaster creates a flat (all-zero) raster matching the shape expected by tests.
func flatRaster() domain.ElevationRaster {
	const width, height = 20, 20
	return domain.ElevationRaster{
		Width:      width,
		Height:     height,
		CellSizeM:  100,
		OriginLon:  0,
		OriginLat:  0,
		Elevations: make([]float64, width*height),
	}
}

// nonFlatRaster returns a raster with at least one non-zero elevation.
func nonFlatRaster() domain.ElevationRaster {
	r := flatRaster()
	r.Elevations[10] = 15.0
	return r
}

// bboxPolygonGeoJSON produces a GeoJSON Polygon from a bounding box.
func bboxPolygonGeoJSON(minLon, minLat, maxLon, maxLat float64) string {
	coords := [][][]float64{{
		{minLon, minLat},
		{maxLon, minLat},
		{maxLon, maxLat},
		{minLon, maxLat},
		{minLon, minLat},
	}}
	raw, _ := json.Marshal(map[string]interface{}{"type": "Polygon", "coordinates": coords})
	return string(raw)
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 1 – isRasterFlat detects synthesised vs real raster
// ─────────────────────────────────────────────────────────────────────────────

func TestIsRasterFlatReturnsTrueForAllZeros(t *testing.T) {
	if !isRasterFlat(flatRaster()) {
		t.Fatal("all-zero raster should be detected as flat")
	}
	if isRasterFlat(nonFlatRaster()) {
		t.Fatal("raster with elevation data should not be flat")
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 2 – FlatDEMSource returns a valid raster matching the requested extent
// ─────────────────────────────────────────────────────────────────────────────

func TestFlatDEMSourceReturnsDimensionedRaster(t *testing.T) {
	src := &FlatDEMSource{}
	raster, sourceID, err := src.FetchRaster(context.Background(), nil, 78.0, 17.0, 78.2, 17.2, 500.0)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if sourceID != src.SourceID() {
		t.Fatalf("expected source ID %s, got %s", src.SourceID(), sourceID)
	}
	if raster.Width <= 1 || raster.Height <= 1 {
		t.Fatalf("expected width>1 and height>1, got %dx%d", raster.Width, raster.Height)
	}
	if len(raster.Elevations) != raster.Width*raster.Height {
		t.Fatalf("elevation slice length %d does not match %dx%d", len(raster.Elevations), raster.Width, raster.Height)
	}
	for _, e := range raster.Elevations {
		if e != 0 {
			t.Fatalf("expected all-zero elevations from FlatDEMSource, got %v", e)
		}
	}
	if !isRasterFlat(raster) {
		t.Fatal("FlatDEMSource output should be detected as flat")
	}
	if src.SourceID() != "flat_terrain_fallback" {
		t.Fatalf("unexpected source ID: %s", src.SourceID())
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 3 – preferred_corridor reduces cost grid values vs baseline
// ─────────────────────────────────────────────────────────────────────────────

func TestPreferredCorridorReducesCostGrid(t *testing.T) {
	raster := flatRaster()
	constraints := defaultConstraints()

	cellDegLon := raster.CellSizeM / (111320.0 * math.Cos(0)) // ~0.000898 deg/cell at lat=0
	cellDegLat := raster.CellSizeM / 111320.0                 // ~0.000898 deg/cell

	// Corridor covering columns 8–12, all rows.
	corridorFeature := domain.VectorFeature{
		FeatureType:     "preferred_corridor",
		GeometryGeoJSON: bboxPolygonGeoJSON(8*cellDegLon, 0, 12*cellDegLon, 20*cellDegLat),
		CostMultiplier:  0, // 0 signals "use canonical type multiplier"
	}

	baseGrid := buildCostGrid(raster, nil, nil, constraints)
	corridorGrid := buildCostGrid(raster, nil, []domain.VectorFeature{corridorFeature}, constraints)

	// Cell at col=9 should be inside the corridor band.
	corridorCellCost := corridorGrid[5][9]
	baseCost := baseGrid[5][9]

	if corridorCellCost >= baseCost {
		t.Fatalf("expected corridor cell cost (%.3f) < baseline (%.3f)", corridorCellCost, baseCost)
	}
	// Specifically must be at the preferred_corridor multiplier (0.35).
	if math.Abs(corridorCellCost-0.35) > 0.01 {
		t.Fatalf("expected corridor multiplier ~0.35, got %.3f", corridorCellCost)
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 4 – no_go zone hard-blocks cells (infinite cost)
// ─────────────────────────────────────────────────────────────────────────────

func TestNoGoZoneHardBlocksCells(t *testing.T) {
	raster := flatRaster()
	constraints := defaultConstraints()

	cellDegLon := raster.CellSizeM / (111320.0 * math.Cos(0))
	cellDegLat := raster.CellSizeM / 111320.0

	noGoFeature := domain.VectorFeature{
		FeatureType:     "no_go",
		GeometryGeoJSON: bboxPolygonGeoJSON(5*cellDegLon, 5*cellDegLat, 9*cellDegLon, 9*cellDegLat),
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{noGoFeature}, constraints)

	// Interior of no-go polygon must be hard-blocked.
	if !math.IsInf(grid[6][6], 1) {
		t.Fatalf("cell inside no-go zone must be +Inf, got %v", grid[6][6])
	}
	if grid[1][1] != 1.0 {
		t.Fatalf("cell outside no-go zone expected 1.0, got %v", grid[1][1])
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 5 – protected_area applies 4x cost multiplier (not hard-blocked)
// ─────────────────────────────────────────────────────────────────────────────

func TestProtectedAreaAppliesCostMultiplier(t *testing.T) {
	raster := flatRaster()
	constraints := defaultConstraints()

	lonScale := 111320.0 * math.Cos(0)
	cellDegLon := raster.CellSizeM / lonScale
	cellDegLat := raster.CellSizeM / 111320.0

	protectedFeature := domain.VectorFeature{
		FeatureType:     "protected_area",
		GeometryGeoJSON: bboxPolygonGeoJSON(2*cellDegLon, 2*cellDegLat, 7*cellDegLon, 7*cellDegLat),
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{protectedFeature}, constraints)

	if math.IsInf(grid[4][4], 1) {
		t.Fatal("protected_area must not hard-block cells")
	}
	if grid[4][4] <= 1.0 {
		t.Fatalf("protected_area cell must cost more than baseline 1.0, got %.3f", grid[4][4])
	}
	if math.Abs(grid[4][4]-4.0) > 0.01 {
		t.Fatalf("expected protected_area multiplier 4.0, got %.3f", grid[4][4])
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 6 – buildDataSourceSnapshot captures correct counts and metadata
// ─────────────────────────────────────────────────────────────────────────────

func TestBuildDataSourceSnapshotCapturesCorrectCounts(t *testing.T) {
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:    uuid.New(),
		VoltageClass: domain.VoltageClass132kV,
		ElevationRaster: domain.ElevationRaster{
			Width: 10, Height: 10, CellSizeM: 100,
			Elevations: make([]float64, 100),
		},
		VectorFeatures: []domain.VectorFeature{
			{FeatureType: "no_go"},              // no-go zone
			{FeatureType: "no_go"},              // no-go zone
			{FeatureType: "preferred_corridor"}, // preferred corridor
			{FeatureType: "building"},           // generic obstacle (not counted separately)
			{FeatureType: "protected_area"},     // protected area
		},
	}

	snap := buildDataSourceSnapshot(req, true, "open_elevation_api:https://test.example.com")

	if snap.SnapshotID == "" {
		t.Fatal("SnapshotID must not be empty")
	}
	if snap.NoGoZoneCount != 2 {
		t.Fatalf("expected 2 no-go zones, got %d", snap.NoGoZoneCount)
	}
	if snap.PreferredCorridorCount != 1 {
		t.Fatalf("expected 1 preferred corridor, got %d", snap.PreferredCorridorCount)
	}
	if snap.ProtectedAreaCount != 1 {
		t.Fatalf("expected 1 protected area, got %d", snap.ProtectedAreaCount)
	}
	if snap.VectorFeatureCount != 5 {
		t.Fatalf("expected 5 total features, got %d", snap.VectorFeatureCount)
	}
	if !snap.DEMAutoFetched {
		t.Fatal("DEMAutoFetched must be true")
	}
	if snap.DEMSource == "" {
		t.Fatal("DEMSource must not be empty")
	}
	if snap.SnapshotAt.IsZero() {
		t.Fatal("SnapshotAt must not be zero")
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 7 – DEM auto-fetch is skipped when raster already has real elevation data
// ─────────────────────────────────────────────────────────────────────────────

func TestDEMAutoFetchSkippedForNonFlatRaster(t *testing.T) {
	if isRasterFlat(nonFlatRaster()) {
		t.Fatal("raster with non-zero elevation must not trigger DEM auto-fetch")
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Test 8 – rasterMaxLon / rasterMaxLat return values beyond origin
// ─────────────────────────────────────────────────────────────────────────────

func TestRasterBoundsHelpersReturnValidExtent(t *testing.T) {
	raster := domain.ElevationRaster{
		Width: 20, Height: 15, CellSizeM: 500,
		OriginLon: 78.0, OriginLat: 17.0,
	}
	maxLon := rasterMaxLon(raster)
	maxLat := rasterMaxLat(raster)

	if maxLon <= raster.OriginLon {
		t.Fatalf("maxLon %.6f must be east of origin %.6f", maxLon, raster.OriginLon)
	}
	if maxLat <= raster.OriginLat {
		t.Fatalf("maxLat %.6f must be north of origin %.6f", maxLat, raster.OriginLat)
	}
	lonSpanM := (maxLon - raster.OriginLon) * 111320.0 * math.Cos(raster.OriginLat*math.Pi/180.0)
	latSpanM := (maxLat - raster.OriginLat) * 111320.0
	if math.Abs(lonSpanM-10000.0) > 500.0 {
		t.Fatalf("expected lon span ~10 km, got %.1f m", lonSpanM)
	}
	if math.Abs(latSpanM-7500.0) > 500.0 {
		t.Fatalf("expected lat span ~7.5 km, got %.1f m", latSpanM)
	}
}

