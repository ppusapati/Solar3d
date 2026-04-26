package service

import (
	"math"
	"testing"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
)

func sampleWaypoints() []domain.Waypoint {
	return []domain.Waypoint{
		{Lon: 0.001, Lat: 0.001, Elevation: 0},
		{Lon: 0.002, Lat: 0.001, Elevation: 0},
		{Lon: 0.003, Lat: 0.001, Elevation: 0},
		{Lon: 0.004, Lat: 0.001, Elevation: 0},
	}
}

func TestPhase3CostUndergroundIncreasesConductorAndCrossing(t *testing.T) {
	wps := sampleWaypoints()
	towers := []domain.TowerPosition{
		{Lon: wps[0].Lon, Lat: wps[0].Lat, Elevation: 0, HeightM: 16, SpanToNextM: 110},
		{Lon: wps[2].Lon, Lat: wps[2].Lat, Elevation: 0, HeightM: 16, SpanToNextM: 110},
		{Lon: wps[3].Lon, Lat: wps[3].Lat, Elevation: 0, HeightM: 16, SpanToNextM: 0},
	}

	overheadSegments := []domain.SegmentExplanation{
		{FromIndex: 0, LandType: "overhead"},
		{FromIndex: 1, LandType: "overhead"},
		{FromIndex: 2, LandType: "overhead"},
	}
	undergroundSegments := []domain.SegmentExplanation{
		{FromIndex: 0, LandType: "underground_cable"},
		{FromIndex: 1, LandType: "underground_cable"},
		{FromIndex: 2, LandType: "overhead"},
	}

	overhead, overUnc := computeCostBreakdown(domain.VoltageClass132kV, wps, towers, 25, 0, overheadSegments)
	underground, underUnc := computeCostBreakdown(domain.VoltageClass132kV, wps, towers, 25, 0, undergroundSegments)

	if underground.ConductorCost <= overhead.ConductorCost {
		t.Fatalf("expected underground conductor/cable cost to be higher: overhead=%f underground=%f", overhead.ConductorCost, underground.ConductorCost)
	}
	if underground.CrossingPremium <= overhead.CrossingPremium {
		t.Fatalf("expected underground crossing/risk premium to be higher: overhead=%f underground=%f", overhead.CrossingPremium, underground.CrossingPremium)
	}
	if underUnc <= overUnc {
		t.Fatalf("expected higher uncertainty for underground-heavy route: overhead=%f underground=%f", overUnc, underUnc)
	}
}

func TestPhase3CostFoundationSensitivityToTowerHeights(t *testing.T) {
	wps := sampleWaypoints()
	segments := []domain.SegmentExplanation{
		{FromIndex: 0, LandType: "overhead"},
		{FromIndex: 1, LandType: "overhead"},
		{FromIndex: 2, LandType: "overhead"},
	}

	normalTowers := []domain.TowerPosition{
		{Lon: wps[0].Lon, Lat: wps[0].Lat, Elevation: 0, HeightM: 16, SpanToNextM: 120},
		{Lon: wps[2].Lon, Lat: wps[2].Lat, Elevation: 0, HeightM: 17, SpanToNextM: 120},
		{Lon: wps[3].Lon, Lat: wps[3].Lat, Elevation: 0, HeightM: 17, SpanToNextM: 0},
	}
	highTowers := []domain.TowerPosition{
		{Lon: wps[0].Lon, Lat: wps[0].Lat, Elevation: 0, HeightM: 38, SpanToNextM: 120},
		{Lon: wps[2].Lon, Lat: wps[2].Lat, Elevation: 0, HeightM: 36, SpanToNextM: 120},
		{Lon: wps[3].Lon, Lat: wps[3].Lat, Elevation: 0, HeightM: 34, SpanToNextM: 0},
	}

	normal, _ := computeCostBreakdown(domain.VoltageClass220kV, wps, normalTowers, 35, 0, segments)
	high, _ := computeCostBreakdown(domain.VoltageClass220kV, wps, highTowers, 35, 0, segments)

	if high.TowerCost <= normal.TowerCost {
		t.Fatalf("expected high tower heights to increase foundation/tower cost: normal=%f high=%f", normal.TowerCost, high.TowerCost)
	}
}

func TestPhase3CostEnvironmentalAndAccessPremiums(t *testing.T) {
	wps := sampleWaypoints()
	towers := []domain.TowerPosition{
		{Lon: wps[0].Lon, Lat: wps[0].Lat, Elevation: 0, HeightM: 16, SpanToNextM: 120},
		{Lon: wps[2].Lon, Lat: wps[2].Lat, Elevation: 0, HeightM: 16, SpanToNextM: 120},
		{Lon: wps[3].Lon, Lat: wps[3].Lat, Elevation: 0, HeightM: 16, SpanToNextM: 0},
	}

	cleanSegments := []domain.SegmentExplanation{
		{FromIndex: 0, LandType: "overhead"},
		{FromIndex: 1, LandType: "overhead"},
		{FromIndex: 2, LandType: "overhead"},
	}
	riskSegments := []domain.SegmentExplanation{
		{FromIndex: 0, LandType: "sensitive_land_overhead"},
		{FromIndex: 1, LandType: "water_crossing_overhead"},
		{FromIndex: 2, LandType: "overhead"},
	}

	clean, _ := computeCostBreakdown(domain.VoltageClass132kV, wps, towers, 27, 0, cleanSegments)
	risky, _ := computeCostBreakdown(domain.VoltageClass132kV, wps, towers, 27, 0, riskSegments)

	if risky.RowAcquisitionCost <= clean.RowAcquisitionCost {
		t.Fatalf("expected sensitive/water segments to increase row/environment/access costs: clean=%f risky=%f", clean.RowAcquisitionCost, risky.RowAcquisitionCost)
	}
	if risky.TotalCost <= clean.TotalCost {
		t.Fatalf("expected risky corridor to increase total cost: clean=%f risky=%f", clean.TotalCost, risky.TotalCost)
	}
}

func TestPhase3CostReturnsReasonableUncertaintyBounds(t *testing.T) {
	wps := sampleWaypoints()
	towers := []domain.TowerPosition{
		{Lon: wps[0].Lon, Lat: wps[0].Lat, Elevation: 0, HeightM: 22, SpanToNextM: 120},
		{Lon: wps[2].Lon, Lat: wps[2].Lat, Elevation: 0, HeightM: 26, SpanToNextM: 120},
		{Lon: wps[3].Lon, Lat: wps[3].Lat, Elevation: 0, HeightM: 24, SpanToNextM: 0},
	}
	segments := []domain.SegmentExplanation{
		{FromIndex: 0, LandType: "underground_cable"},
		{FromIndex: 1, LandType: "water_crossing_overhead"},
		{FromIndex: 2, LandType: "sensitive_land_overhead"},
	}

	_, uncertainty := computeCostBreakdown(domain.VoltageClass220kV, wps, towers, 35, 1000, segments)
	if uncertainty < 0.06 || uncertainty > 0.35 || math.IsNaN(uncertainty) {
		t.Fatalf("unexpected uncertainty value: %f", uncertainty)
	}
}

func TestResolveConstraintsEnforcesVoltageSpanBands(t *testing.T) {
	testCases := []struct {
		name    string
		class   domain.VoltageClass
		input   domain.TransmissionConstraints
		wantMin float64
		wantMax float64
	}{
		{name: "11kv defaults", class: domain.VoltageClass11kV, input: domain.TransmissionConstraints{}, wantMin: 50, wantMax: 80},
		{name: "33kv defaults", class: domain.VoltageClass33kV, input: domain.TransmissionConstraints{}, wantMin: 80, wantMax: 120},
		{name: "66kv defaults", class: domain.VoltageClass66kV, input: domain.TransmissionConstraints{}, wantMin: 150, wantMax: 200},
		{name: "132kv defaults", class: domain.VoltageClass132kV, input: domain.TransmissionConstraints{}, wantMin: 250, wantMax: 300},
		{name: "220kv defaults", class: domain.VoltageClass220kV, input: domain.TransmissionConstraints{}, wantMin: 300, wantMax: 400},
		{name: "400kv defaults", class: domain.VoltageClass400kV, input: domain.TransmissionConstraints{}, wantMin: 300, wantMax: 400},
		{name: "clamps custom out-of-band", class: domain.VoltageClass132kV, input: domain.TransmissionConstraints{MinSpanM: 100, MaxSpanM: 500}, wantMin: 250, wantMax: 300},
		{name: "fixes inverted custom span", class: domain.VoltageClass66kV, input: domain.TransmissionConstraints{MinSpanM: 210, MaxSpanM: 100}, wantMin: 200, wantMax: 200},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			got := resolveConstraints(tc.class, tc.input)
			if got.MinSpanM != tc.wantMin || got.MaxSpanM != tc.wantMax {
				t.Fatalf("resolveConstraints(%s) => min/max %.0f/%.0f, want %.0f/%.0f", tc.class, got.MinSpanM, got.MaxSpanM, tc.wantMin, tc.wantMax)
			}
		})
	}
}

