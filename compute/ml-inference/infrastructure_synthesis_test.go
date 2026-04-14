package ml_inference

import "testing"

func TestSynthesizeInfrastructure_Deterministic(t *testing.T) {
	input := &SynthesisInput{
		ProjectID: "project-1",
		LayoutID:  "layout-1",
		Seed:      42,
		Boundary: Geometry{
			Vertices: []Point3D{
				{Longitude: -120.50, Latitude: 38.30, ElevationM: 1000},
				{Longitude: -120.40, Latitude: 38.30, ElevationM: 1000},
				{Longitude: -120.40, Latitude: 38.40, ElevationM: 1000},
				{Longitude: -120.50, Latitude: 38.40, ElevationM: 1000},
			},
		},
		DEM: &DEMGrid{
			Rows:      3,
			Cols:      3,
			CellSizeM: 30,
			ValuesM: [][]float64{
				{1000, 1001, 1002},
				{1001, 1002, 1003},
				{1002, 1003, 1004},
			},
		},
		DecisionSpace:       NewDecisionSpace(),
		TargetInverterCount: 2,
		TargetTxCount:       1,
	}

	constraints := NewHardConstraintSet()
	a, err := SynthesizeInfrastructure(input, constraints)
	if err != nil {
		t.Fatalf("first synthesis failed: %v", err)
	}
	b, err := SynthesizeInfrastructure(input, constraints)
	if err != nil {
		t.Fatalf("second synthesis failed: %v", err)
	}

	if a.Lineage == nil || b.Lineage == nil {
		t.Fatalf("lineage is required")
	}
	if a.Lineage.Checksum != b.Lineage.Checksum {
		t.Fatalf("expected deterministic checksum, got %s and %s", a.Lineage.Checksum, b.Lineage.Checksum)
	}

	if len(a.Infrastructure.RoadSegments) != len(b.Infrastructure.RoadSegments) {
		t.Fatalf("road segment count mismatch")
	}
	if a.Infrastructure.RoadSegments[0].RoadID != b.Infrastructure.RoadSegments[0].RoadID {
		t.Fatalf("road IDs differ for identical inputs")
	}
}

func TestSynthesizeInfrastructure_ProducesRequiredArtifacts(t *testing.T) {
	input := &SynthesisInput{
		ProjectID: "project-2",
		LayoutID:  "layout-2",
		Seed:      99,
		Boundary: Geometry{
			Vertices: []Point3D{
				{Longitude: -122.00, Latitude: 37.00, ElevationM: 10},
				{Longitude: -121.90, Latitude: 37.00, ElevationM: 10},
				{Longitude: -121.90, Latitude: 37.10, ElevationM: 10},
				{Longitude: -122.00, Latitude: 37.10, ElevationM: 10},
			},
		},
		DecisionSpace:       NewDecisionSpace(),
		TargetInverterCount: 3,
		TargetTxCount:       1,
	}

	graph, err := SynthesizeInfrastructure(input, NewHardConstraintSet())
	if err != nil {
		t.Fatalf("synthesis failed: %v", err)
	}

	if graph.Infrastructure == nil {
		t.Fatalf("infrastructure should be populated")
	}
	if len(graph.Infrastructure.RoadSegments) == 0 {
		t.Fatalf("road segments should be generated")
	}
	if len(graph.Infrastructure.InverterZones) != 3 {
		t.Fatalf("expected 3 inverter zones, got %d", len(graph.Infrastructure.InverterZones))
	}
	if len(graph.Infrastructure.TransformerZones) != 1 {
		t.Fatalf("expected 1 transformer zone, got %d", len(graph.Infrastructure.TransformerZones))
	}
	if len(graph.Infrastructure.ACEquipmentZones) != 3 || len(graph.Infrastructure.DCEquipmentZones) != 3 {
		t.Fatalf("expected AC/DC equipment zones per inverter")
	}
	if len(graph.Infrastructure.CableAnchors) == 0 {
		t.Fatalf("cable anchors should be generated")
	}
	if len(graph.Infrastructure.FaultMarkerAnchors) == 0 {
		t.Fatalf("fault marker anchors should be generated")
	}
	if len(graph.InverterGroups) != 3 {
		t.Fatalf("expected 3 inverter groups, got %d", len(graph.InverterGroups))
	}
	if len(graph.TransformerNodes) != 1 {
		t.Fatalf("expected 1 transformer node, got %d", len(graph.TransformerNodes))
	}
	if len(graph.CableCorridors) != 3 {
		t.Fatalf("expected one corridor per inverter, got %d", len(graph.CableCorridors))
	}
	if len(graph.FaultIdentifiers) != 3 {
		t.Fatalf("expected one fault marker per inverter, got %d", len(graph.FaultIdentifiers))
	}
}

func TestSynthesizeInfrastructure_FailsOnInvalidBoundary(t *testing.T) {
	input := &SynthesisInput{
		ProjectID: "project-3",
		LayoutID:  "layout-3",
		Seed:      7,
		Boundary: Geometry{
			Vertices: []Point3D{
				{Longitude: -1, Latitude: -1, ElevationM: 0},
				{Longitude: 1, Latitude: 1, ElevationM: 0},
				{Longitude: 2, Latitude: 2, ElevationM: 0},
			},
		},
	}

	if _, err := SynthesizeInfrastructure(input, NewHardConstraintSet()); err == nil {
		t.Fatalf("expected error for invalid boundary")
	}
}
