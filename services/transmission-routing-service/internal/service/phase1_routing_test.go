package service

import (
	"math"
	"testing"

	"github.com/google/uuid"

	"solar3d/transmission-routing-service/internal/domain"
)

func testRaster() domain.ElevationRaster {
	width := 10
	height := 10
	elev := make([]float64, width*height)
	return domain.ElevationRaster{
		Width:      width,
		Height:     height,
		CellSizeM:  100,
		OriginLon:  0,
		OriginLat:  0,
		Elevations: elev,
	}
}

func defaultConstraints() domain.TransmissionConstraints {
	return domain.TransmissionConstraints{
		MinSpanM:              100,
		MaxSpanM:              300,
		RowWidthM:             20,
		MaxSlopeDeg:           30,
		MaxDeflectionDeg:      60,
		SlopePenaltyFactor:    2,
		TurnPenaltyFactor:     1.5,
		WaterCrossingCostMult: 4,
		RoadParallelDiscount:  0.8,
	}
}

func TestHardBlockedPolygonSetsInfiniteCost(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()

	feature := domain.VectorFeature{
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

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{feature}, constraints)

	// Cell near center of polygon should be blocked.
	if !math.IsInf(grid[4][4], 1) {
		t.Fatalf("expected blocked cell at [4][4], got %v", grid[4][4])
	}

	// A cell outside polygon should stay baseline.
	if grid[1][1] != 1.0 {
		t.Fatalf("expected unblocked cell at [1][1], got %v", grid[1][1])
	}
}

func TestControlledUndergroundFallbackWhenOverheadBlocked(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()

	// Create a full blocked vertical barrier splitting the map.
	blocked := domain.VectorFeature{
		FeatureType: "building",
		GeometryGeoJSON: `{
			"type": "Polygon",
			"coordinates": [[
				[0.0045, 0.0000],
				[0.0055, 0.0000],
				[0.0055, 0.0100],
				[0.0045, 0.0100],
				[0.0045, 0.0000]
			]]
		}`,
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{blocked}, constraints)
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:          uuid.New(),
		Name:               "test",
		VoltageClass:       domain.VoltageClass132kV,
		FarmOutputPoint:    domain.Waypoint{Lon: 0.001, Lat: 0.005},
		GridInjectionPoint: domain.Waypoint{Lon: 0.009, Lat: 0.005},
		Constraints:        constraints,
		ElevationRaster:    raster,
	}

	if _, _, err := calculateFallbackPath(req, constraints, grid, false); err == nil {
		t.Fatalf("expected overhead-only routing to fail across blocked barrier")
	}

	waypoints, _, err := calculateFallbackPath(req, constraints, grid, true)
	if err != nil {
		t.Fatalf("expected underground-enabled routing to succeed, got error: %v", err)
	}
	if len(waypoints) < 2 {
		t.Fatalf("expected valid path with waypoints")
	}
}

func TestSegmentClassificationIncludesUndergroundAndWaterOverhead(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()

	waypoints := []domain.Waypoint{
		{Lon: 0.001, Lat: 0.001, Elevation: 0},
		{Lon: 0.002, Lat: 0.001, Elevation: 0},
		{Lon: 0.003, Lat: 0.001, Elevation: 0},
	}

	grid := make([][]float64, raster.Height)
	for r := 0; r < raster.Height; r++ {
		grid[r] = make([]float64, raster.Width)
		for c := 0; c < raster.Width; c++ {
			grid[r][c] = 1.0
		}
	}

	// Force second segment into underground, first into water crossing overhead.
	row1, col1 := waypointToGrid(raster, waypoints[1]).Row, waypointToGrid(raster, waypoints[1]).Col
	row2, col2 := waypointToGrid(raster, waypoints[2]).Row, waypointToGrid(raster, waypoints[2]).Col
	grid[row1][col1] = constraints.WaterCrossingCostMult + 1
	grid[row2][col2] = math.Inf(1)

	segments, _ := explainSegments(waypoints, grid, raster, constraints)
	if len(segments) != 2 {
		t.Fatalf("expected 2 segments, got %d", len(segments))
	}
	if segments[0].LandType != "water_crossing_overhead" {
		t.Fatalf("expected water_crossing_overhead, got %s", segments[0].LandType)
	}
	if segments[1].LandType != "underground_cable" {
		t.Fatalf("expected underground_cable, got %s", segments[1].LandType)
	}
	if segments[1].InstallationMode != domain.InstallationModeUnderground {
		t.Fatalf("expected underground installation mode, got %s", segments[1].InstallationMode)
	}
}

func TestUndergroundOnlyZoneRequiresUndergroundTraversal(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()

	feature := domain.VectorFeature{
		FeatureType: "underground_only",
		GeometryGeoJSON: `{
			"type": "Polygon",
			"coordinates": [[
				[0.0045, 0.0000],
				[0.0055, 0.0000],
				[0.0055, 0.0100],
				[0.0045, 0.0100],
				[0.0045, 0.0000]
			]]
		}`,
	}

	grid := buildCostGrid(raster, nil, []domain.VectorFeature{feature}, constraints)
	req := domain.CalculateTransmissionRouteRequest{
		ProjectID:          uuid.New(),
		Name:               "underground-only",
		VoltageClass:       domain.VoltageClass132kV,
		FarmOutputPoint:    domain.Waypoint{Lon: 0.001, Lat: 0.005},
		GridInjectionPoint: domain.Waypoint{Lon: 0.009, Lat: 0.005},
		Constraints:        constraints,
		ElevationRaster:    raster,
	}

	if _, _, err := calculateFallbackPath(req, constraints, grid, false); err == nil {
		t.Fatal("expected overhead-only routing to reject underground-only corridor")
	}

	waypoints, _, err := calculateFallbackPath(req, constraints, grid, true)
	if err != nil {
		t.Fatalf("expected underground-enabled routing to traverse underground-only corridor: %v", err)
	}
	segments, _ := explainSegments(waypoints, grid, raster, constraints)
	foundUndergroundRequired := false
	for _, segment := range segments {
		if segment.InstallationMode == domain.InstallationModeUnderground {
			foundUndergroundRequired = true
			if segment.LandType != "underground_required_cable" {
				t.Fatalf("expected underground_required_cable, got %s", segment.LandType)
			}
		}
	}
	if !foundUndergroundRequired {
		t.Fatal("expected at least one underground-required segment")
	}
}

