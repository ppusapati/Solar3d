package service

import (
	"math"
	"testing"

	"solar3d/transmission-routing-service/internal/domain"
)

func TestIsRoadLikeForBuffer(t *testing.T) {
	positives := []string{
		"road", "Road", "ROAD",
		"highway", "national_highway", "state_highway",
		"access_road", "service_road",
		"preferred_corridor", "corridor",
		"road_centerline", "road-centerline",
		"roadway",
	}
	for _, ft := range positives {
		if !isRoadLikeForBuffer(ft) {
			t.Errorf("expected isRoadLikeForBuffer(%q) = true", ft)
		}
	}

	negatives := []string{
		"building", "lake", "forest", "urban", "water",
		"protected_area", "wetland",
	}
	for _, ft := range negatives {
		if isRoadLikeForBuffer(ft) {
			t.Errorf("expected isRoadLikeForBuffer(%q) = false", ft)
		}
	}
}

func TestOffRoadPenaltyAppliedToNonRoadCells(t *testing.T) {
	raster := testRaster() // 10×10 grid, cellSize=100m

	constraints := defaultConstraints()
	constraints.OffRoadPenalty = 5.0
	constraints.RoadBufferM = 120 // enough to mark ~1 cell beside road
	constraints.RoadParallelDiscount = 0.3

	// Road running horizontally through the middle of the grid: row ~5
	// GeoJSON LineString with coordinates [lon, lat]
	roadFeature := domain.VectorFeature{
		FeatureType: "road",
		GeometryGeoJSON: `{
			"type": "LineString",
			"coordinates": [
				[0.0000, 0.0045],
				[0.0090, 0.0045]
			]
		}`,
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{roadFeature}, constraints)

	// For an east-going road, right-hand side = south = lower rows.
	// Scan all cells to find any that received the discount.
	foundDiscounted := false
	for row := 0; row < raster.Height; row++ {
		for col := 0; col < raster.Width; col++ {
			if grid[row][col] > 0 && grid[row][col] < 1.0 {
				foundDiscounted = true
				break
			}
		}
		if foundDiscounted {
			break
		}
	}
	if !foundDiscounted {
		t.Fatalf("expected at least some cells near road to have a discount (< 1.0)")
	}

	// Cells far from the road (and not discounted) should have off-road penalty (cost > 1.0).
	// Row 9 is at lat ~0.0085, north of the road (left-hand side, outside buffer).
	farRow := raster.Height - 1
	if grid[farRow][5] <= 1.0 {
		t.Fatalf("expected off-road penalty at [%d][5], got %v", farRow, grid[farRow][5])
	}
	// Off-road penalty multiplier should be 5.0× on baseline 1.0
	if math.Abs(grid[farRow][5]-5.0) > 0.01 {
		t.Fatalf("expected off-road cell cost ~5.0, got %v", grid[farRow][5])
	}
}

func TestNoOffRoadPenaltyWhenPenaltyIsOneOrLess(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	constraints.OffRoadPenalty = 1.0 // disabled
	constraints.RoadBufferM = 50
	constraints.RoadParallelDiscount = 0.3

	grid := buildCostGrid(raster, nil, nil, constraints)

	// All cells should remain at baseline 1.0 — no penalty, no roads
	for row := 0; row < raster.Height; row++ {
		for col := 0; col < raster.Width; col++ {
			if grid[row][col] != 1.0 {
				t.Fatalf("expected all cells at 1.0 when off-road penalty disabled, got %v at [%d][%d]", grid[row][col], row, col)
			}
		}
	}
}

func TestRoadCorridorOneSidedBuffering(t *testing.T) {
	// Larger raster for better resolution
	width := 20
	height := 20
	raster := domain.ElevationRaster{
		Width:      width,
		Height:     height,
		CellSizeM:  50,
		OriginLon:  0,
		OriginLat:  0,
		Elevations: make([]float64, width*height),
	}

	constraints := defaultConstraints()
	constraints.OffRoadPenalty = 1.0 // disable off-road penalty for this test
	constraints.RoadBufferM = 100
	constraints.RoadParallelDiscount = 0.5

	// Vertical road from south to north (lat increases, lon constant)
	roadFeature := domain.VectorFeature{
		FeatureType: "road",
		GeometryGeoJSON: `{
			"type": "LineString",
			"coordinates": [
				[0.0045, 0.0010],
				[0.0045, 0.0080]
			]
		}`,
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{roadFeature}, constraints)

	// Count discounted cells on each side of the road
	roadCol, _ := latLonToGrid(raster, 0.0045, 0.0045)
	_ = roadCol // the row for a vertical road at lon=0.0045

	// For a south-to-north road, direction is (0, +1) in lat.
	// Right-hand normal: perpendicular to travel = east direction.
	// So the buffer should be predominantly on the RIGHT (east) side.
	discountedLeft := 0
	discountedRight := 0
	_, roadColIdx := latLonToGrid(raster, 0.0045, 0.0045)

	for row := 2; row < height-2; row++ {
		for col := 0; col < width; col++ {
			if grid[row][col] < 1.0 {
				if col < roadColIdx {
					discountedLeft++
				} else if col > roadColIdx {
					discountedRight++
				}
			}
		}
	}

	// Right side should have significantly more discounted cells than left side.
	// Left side may have a few due to the ±3m centerline tolerance.
	if discountedRight == 0 {
		t.Fatalf("expected some discounted cells on the right side of the road")
	}
	if discountedLeft > discountedRight {
		t.Fatalf("expected right side to have more discounted cells than left side: left=%d right=%d", discountedLeft, discountedRight)
	}
}

func TestParseLineSegmentsForBufferLineString(t *testing.T) {
	geojson := `{
		"type": "LineString",
		"coordinates": [
			[10.0, 20.0],
			[11.0, 21.0],
			[12.0, 22.0]
		]
	}`
	segments := parseLineSegmentsForBuffer(geojson)
	if len(segments) != 2 {
		t.Fatalf("expected 2 segments, got %d", len(segments))
	}
	if segments[0].A[0] != 10.0 || segments[0].A[1] != 20.0 {
		t.Fatalf("unexpected segment A: %v", segments[0].A)
	}
	if segments[0].B[0] != 11.0 || segments[0].B[1] != 21.0 {
		t.Fatalf("unexpected segment B: %v", segments[0].B)
	}
	if segments[1].A[0] != 11.0 || segments[1].B[0] != 12.0 {
		t.Fatalf("unexpected second segment: %v -> %v", segments[1].A, segments[1].B)
	}
}

func TestParseLineSegmentsForBufferMultiLineString(t *testing.T) {
	geojson := `{
		"type": "MultiLineString",
		"coordinates": [
			[[1.0, 2.0], [3.0, 4.0]],
			[[5.0, 6.0], [7.0, 8.0], [9.0, 10.0]]
		]
	}`
	segments := parseLineSegmentsForBuffer(geojson)
	if len(segments) != 3 {
		t.Fatalf("expected 3 segments from MultiLineString, got %d", len(segments))
	}
}

func TestParseLineSegmentsForBufferRejectsPolygon(t *testing.T) {
	geojson := `{
		"type": "Polygon",
		"coordinates": [[[0,0],[1,0],[1,1],[0,1],[0,0]]]
	}`
	segments := parseLineSegmentsForBuffer(geojson)
	if len(segments) != 0 {
		t.Fatalf("expected 0 segments for Polygon, got %d", len(segments))
	}
}

func TestRoadCorridorFallsBackForPolygonGeometry(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	constraints.OffRoadPenalty = 1.0
	constraints.RoadBufferM = 50
	constraints.RoadParallelDiscount = 0.5

	// A "road" feature with Polygon geometry should fall back to standard cost application
	roadPolygon := domain.VectorFeature{
		FeatureType: "road",
		GeometryGeoJSON: `{
			"type": "Polygon",
			"coordinates": [[
				[0.0030, 0.0030],
				[0.0060, 0.0030],
				[0.0060, 0.0060],
				[0.0030, 0.0060],
				[0.0030, 0.0030]
			]]
		}`,
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{roadPolygon}, constraints)

	// The polygon area should get the road parallel discount (standard feature cost path)
	foundDiscounted := false
	for row := 0; row < raster.Height; row++ {
		for col := 0; col < raster.Width; col++ {
			if grid[row][col] < 1.0 {
				foundDiscounted = true
				break
			}
		}
		if foundDiscounted {
			break
		}
	}
	if !foundDiscounted {
		t.Fatalf("expected road polygon to apply discount via fallback path")
	}
}

func TestOffRoadPenaltyPreservesHardBlockedCells(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	constraints.OffRoadPenalty = 5.0
	constraints.RoadBufferM = 30
	constraints.RoadParallelDiscount = 0.5

	// Add both a building (hard-blocked) and a road (to enable off-road penalty).
	building := domain.VectorFeature{
		FeatureType: "building",
		GeometryGeoJSON: `{
			"type": "Polygon",
			"coordinates": [[
				[0.0030, 0.0030],
				[0.0060, 0.0030],
				[0.0060, 0.0060],
				[0.0030, 0.0060],
				[0.0030, 0.0030]
			]]
		}`,
	}

	road := domain.VectorFeature{
		FeatureType: "road",
		GeometryGeoJSON: `{
			"type": "LineString",
			"coordinates": [
				[0.0000, 0.0080],
				[0.0090, 0.0080]
			]
		}`,
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{building, road}, constraints)

	// Hard-blocked cells must remain Inf, NOT be multiplied by off-road penalty.
	if !math.IsInf(grid[4][4], 1) {
		t.Fatalf("expected hard-blocked cell to stay Inf, got %v", grid[4][4])
	}

	// Non-blocked, non-road cells should have off-road penalty
	if grid[1][1] <= 1.0 {
		t.Fatalf("expected off-road penalty at non-road cell [1][1], got %v", grid[1][1])
	}
}

func TestOffRoadPenaltySkippedWhenNoRoadFeatures(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	constraints.OffRoadPenalty = 5.0
	constraints.RoadBufferM = 30
	constraints.RoadParallelDiscount = 0.5

	// Only a building, no road features — off-road penalty should NOT apply.
	building := domain.VectorFeature{
		FeatureType: "building",
		GeometryGeoJSON: `{
			"type": "Polygon",
			"coordinates": [[
				[0.0030, 0.0030],
				[0.0060, 0.0030],
				[0.0060, 0.0060],
				[0.0030, 0.0060],
				[0.0030, 0.0030]
			]]
		}`,
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{building}, constraints)

	// Hard-blocked cells must stay Inf.
	if !math.IsInf(grid[4][4], 1) {
		t.Fatalf("expected hard-blocked cell to stay Inf, got %v", grid[4][4])
	}

	// Without road features, off-road penalty should not be applied.
	if grid[1][1] != 1.0 {
		t.Fatalf("expected non-road non-blocked cell to stay at 1.0 (no road features), got %v", grid[1][1])
	}
}
