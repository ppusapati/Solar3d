package service

import (
	"math"
	"testing"

	"solar3d/transmission-routing-service/internal/domain"
)

func TestRefineRouteWaypointsReducesStaircaseNoise(t *testing.T) {
	constraints := defaultConstraints()
	constraints.MaxDeflectionDeg = 60

	waypoints := []domain.Waypoint{
		{Lon: 0.0000, Lat: 0.0000, Elevation: 0},
		{Lon: 0.0005, Lat: 0.0000, Elevation: 0},
		{Lon: 0.0010, Lat: 0.0000, Elevation: 0},
		{Lon: 0.0015, Lat: 0.0000, Elevation: 0},
		{Lon: 0.0020, Lat: 0.0003, Elevation: 0},
		{Lon: 0.0025, Lat: 0.0000, Elevation: 0},
		{Lon: 0.0030, Lat: 0.0000, Elevation: 0},
	}

	refined := refineRouteWaypoints(waypoints, constraints)
	if len(refined) >= len(waypoints) {
		t.Fatalf("expected refinement to reduce waypoint count, before=%d after=%d", len(waypoints), len(refined))
	}
	if refined[0] != waypoints[0] || refined[len(refined)-1] != waypoints[len(waypoints)-1] {
		t.Fatalf("expected refinement to preserve endpoints")
	}
}

func TestPlaceTowersRespectsMaxSpan(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	constraints.MinSpanM = 120
	constraints.MaxSpanM = 250

	waypoints := make([]domain.Waypoint, 0, 12)
	for i := 0; i < 12; i++ {
		waypoints = append(waypoints, domain.Waypoint{Lon: 0.001 + float64(i)*0.0009, Lat: 0.005, Elevation: 0})
	}

	towers := placeTowers(waypoints, constraints, domain.VoltageClass132kV, raster, nil)
	if len(towers) < 2 {
		t.Fatalf("expected multiple towers")
	}
	for i := 0; i < len(towers)-1; i++ {
		if towers[i].SpanToNextM > constraints.MaxSpanM+1 {
			t.Fatalf("span exceeds max: got %.2f max %.2f", towers[i].SpanToNextM, constraints.MaxSpanM)
		}
	}
}

func TestSagClearanceInsertsAdditionalTowers(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	constraints.MinSpanM = 700
	constraints.MaxSpanM = 900

	// Create a broad terrain hump near midpoint that fails long span clearance.
	for r := 0; r < raster.Height; r++ {
		for c := 0; c < raster.Width; c++ {
			raster.Elevations[r*raster.Width+c] = 0
		}
	}
	for r := 4; r <= 6; r++ {
		for c := 4; c <= 6; c++ {
			raster.Elevations[r*raster.Width+c] = 3.5
		}
	}

	waypoints := make([]domain.Waypoint, 0, 11)
	for i := 0; i <= 10; i++ {
		waypoints = append(waypoints, domain.Waypoint{Lon: 0.0005 + float64(i)*0.0009, Lat: 0.005, Elevation: 0})
	}

	// Direct one-span candidate should fail clearance.
	fullSpan := calculatePathDistance([]domain.Waypoint{waypoints[0], waypoints[len(waypoints)-1]})
	if spanHasClearance(waypoints[0], waypoints[len(waypoints)-1], fullSpan, domain.VoltageClass132kV, raster) {
		t.Fatalf("expected long span clearance failure for constructed hump")
	}

	towers := placeTowers(waypoints, constraints, domain.VoltageClass132kV, raster, nil)
	if len(towers) <= 2 {
		t.Fatalf("expected additional towers inserted due to sag/clearance checks, got %d", len(towers))
	}

	for i := 0; i < len(towers)-1; i++ {
		start := domain.Waypoint{Lon: towers[i].Lon, Lat: towers[i].Lat, Elevation: towers[i].Elevation}
		end := domain.Waypoint{Lon: towers[i+1].Lon, Lat: towers[i+1].Lat, Elevation: towers[i+1].Elevation}
		span := towers[i].SpanToNextM
		if span <= 0 || math.IsNaN(span) {
			t.Fatalf("invalid tower span at %d: %.2f", i, span)
		}
		if !spanHasClearance(start, end, span, domain.VoltageClass132kV, raster) {
			t.Fatalf("tower span %d does not satisfy sag clearance", i)
		}
	}
}

func TestPlaceTowersKeepsSparsePathWithinMaxSpan(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	constraints.MinSpanM = 100
	constraints.MaxSpanM = 220

	waypoints := []domain.Waypoint{
		{Lon: 0.0010, Lat: 0.0050, Elevation: 0},
		{Lon: 0.0045, Lat: 0.0050, Elevation: 0},
		{Lon: 0.0080, Lat: 0.0050, Elevation: 0},
	}

	towers := placeTowers(waypoints, constraints, domain.VoltageClass132kV, raster, nil)
	if len(towers) < 4 {
		t.Fatalf("expected sparse path to be densified into additional tower positions, got %d", len(towers))
	}
	for i := 0; i < len(towers)-1; i++ {
		if towers[i].SpanToNextM > constraints.MaxSpanM+1 {
			t.Fatalf("tower span %.2f exceeds max %.2f", towers[i].SpanToNextM, constraints.MaxSpanM)
		}
	}
}

func TestBridgeResponseToRouteRecomputesSegmentsAfterRefinement(t *testing.T) {
	raster := testRaster()
	constraints := defaultConstraints()
	grid := make([][]float64, raster.Height)
	for row := range grid {
		grid[row] = make([]float64, raster.Width)
		for col := range grid[row] {
			grid[row][col] = 1.0
		}
	}

	resp := transmissionBridgeResponse{
		Waypoints: []bridgeWaypoint{
			{X: 0.0010, Y: 0.0050, Elevation: 0},
			{X: 0.0020, Y: 0.0050, Elevation: 0},
			{X: 0.0030, Y: 0.0050, Elevation: 0},
		},
		SegmentExplanations: []bridgeSegmentExplanation{
			{FromIndex: 0, LandType: "overhead", DecisionReason: "bridge a"},
			{FromIndex: 1, LandType: "overhead", DecisionReason: "bridge b"},
		},
		RouteSummary: "bridge route",
	}

	route := bridgeResponseToRoute(resp, domain.VoltageClass132kV, constraints, raster, grid, nil)
	if len(route.SegmentExplanations) != 1 {
		t.Fatalf("expected segment explanations to be recalculated against refined path, got %d", len(route.SegmentExplanations))
	}
	if route.SegmentExplanations[0].FromIndex != 0 {
		t.Fatalf("expected recomputed segment index 0, got %d", route.SegmentExplanations[0].FromIndex)
	}
}

