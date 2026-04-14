package ml_inference

import (
	"testing"
)

// ========== Decision Variable Tests ==========

// TestDecisionVariable_IsValid checks variable bounds validation.
func TestDecisionVariable_IsValid(t *testing.T) {
	dv := &DecisionVariable{
		MinValue:     0.0,
		MaxValue:     90.0,
	}

	tests := []struct {
		name      string
		value     float64
		wantValid bool
	}{
		{"below_min", -1.0, false},
		{"at_min", 0.0, true},
		{"mid_range", 45.0, true},
		{"at_max", 90.0, true},
		{"above_max", 91.0, false},
		{"nan", math.NaN(), false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := dv.IsValid(tt.value)
			if got != tt.wantValid {
				t.Errorf("IsValid(%f) = %v, want %v", tt.value, got, tt.wantValid)
			}
		})
	}
}

// TestDecisionVariable_Clamp tests value clamping.
func TestDecisionVariable_Clamp(t *testing.T) {
	dv := &DecisionVariable{
		MinValue: 0.0,
		MaxValue: 100.0,
	}

	tests := []struct {
		name    string
		value   float64
		wantVal float64
	}{
		{"below_min", -50.0, 0.0},
		{"at_min", 0.0, 0.0},
		{"in_range", 50.0, 50.0},
		{"at_max", 100.0, 100.0},
		{"above_max", 150.0, 100.0},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := dv.Clamp(tt.value)
			if got != tt.wantVal {
				t.Errorf("Clamp(%f) = %f, want %f", tt.value, got, tt.wantVal)
			}
		})
	}
}

// TestDecisionSpace_Creation tests default decision space creation.
func TestDecisionSpace_Creation(t *testing.T) {
	ds := NewDecisionSpace()

	if ds.TiltAngle == nil || ds.TiltAngle.MinValue != 0.0 || ds.TiltAngle.MaxValue != 90.0 {
		t.Errorf("Tilt angle not initialized correctly")
	}
	if ds.AzimuthAngle == nil || ds.AzimuthAngle.MaxValue != 360.0 {
		t.Errorf("Azimuth angle not initialized correctly")
	}
	if ds.SpacingFactor == nil || ds.SpacingFactor.MinValue != 0.85 || ds.SpacingFactor.MaxValue != 1.15 {
		t.Errorf("Spacing factor not initialized correctly")
	}
	if ds.StringFormationMode != "heuristic_balanced" {
		t.Errorf("String formation mode incorrect, got %s", ds.StringFormationMode)
	}
	if ds.CableRoutingMode != "follow_roads" {
		t.Errorf("Cable routing mode incorrect, got %s", ds.CableRoutingMode)
	}
}

// ========== Hard Constraint Tests ==========

// TestHardConstraintSet_Creation tests initialization.
func TestHardConstraintSet_Creation(t *testing.T) {
	cs := NewHardConstraintSet()

	if cs.BoundaryContainment == nil {
		t.Errorf("Boundary containment constraint not initialized")
	}
	if cs.VoltageConstraint == nil {
		t.Errorf("Voltage constraint not initialized")
	}
	if len(cs.AllConstraints) != 12 {
		t.Errorf("Expected 12 constraints, got %d", len(cs.AllConstraints))
	}
}

// TestC3_VoltageConstraint tests hard constraint C3.
func TestC3_VoltageConstraint(t *testing.T) {
	cs := NewHardConstraintSet()

	tests := []struct {
		name      string
		graph     *CandidateArtifactGraph
		wantError bool
	}{
		{
			name: "valid_voltage",
			graph: &CandidateArtifactGraph{
				PanelStrings: []*PanelString{
					{StringID: "s1", StringVoltageVdc: 600.0},
				},
			},
			wantError: false,
		},
		{
			name: "voltage_too_low",
			graph: &CandidateArtifactGraph{
				PanelStrings: []*PanelString{
					{StringID: "s1", StringVoltageVdc: 100.0},
				},
			},
			wantError: true,
		},
		{
			name: "voltage_too_high",
			graph: &CandidateArtifactGraph{
				PanelStrings: []*PanelString{
					{StringID: "s1", StringVoltageVdc: 1000.0},
				},
			},
			wantError: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := cs.VoltageConstraint.Validator(tt.graph)
			if (err != nil) != tt.wantError {
				t.Errorf("Got error = %v, wantError = %v", err, tt.wantError)
			}
		})
	}
}

// TestC5_DcAcRatioBounds tests hard constraint C5.
func TestC5_DcAcRatioBounds(t *testing.T) {
	cs := NewHardConstraintSet()

	tests := []struct {
		name      string
		dcAcRatio float64
		wantError bool
	}{
		{"ratio_1.0", 1.0, true},
		{"ratio_1.1", 1.1, false},
		{"ratio_1.3", 1.3, false},
		{"ratio_1.5", 1.5, false},
		{"ratio_1.6", 1.6, true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			graph := &CandidateArtifactGraph{
				InverterGroups: []*InverterGroup{
					{InverterGroupID: "i1", DcAcRatio: tt.dcAcRatio},
				},
			}
			err := cs.DcAcRatioBounds.Validator(graph)
			if (err != nil) != tt.wantError {
				t.Errorf("DcAcRatio %.2f: got error = %v, wantError = %v", tt.dcAcRatio, err, tt.wantError)
			}
		})
	}
}

// TestC6_TransformerCapacity tests hard constraint C6.
func TestC6_TransformerCapacity(t *testing.T) {
	cs := NewHardConstraintSet()

	tests := []struct {
		name      string
		loadKva   float64
		kvaBating float64
		wantError bool
	}{
		{"load_50pct", 125.0, 250.0, false},
		{"load_100pct", 250.0, 250.0, false},
		{"load_110pct", 275.0, 250.0, true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			graph := &CandidateArtifactGraph{
				TransformerNodes: []*TransformerNode{
					{TransformerID: "tx1", LoadKva: tt.loadKva, KvaRating: tt.kvaBating},
				},
			}
			err := cs.TransformerCapacity.Validator(graph)
			if (err != nil) != tt.wantError {
				t.Errorf("Got error = %v, wantError = %v", err, tt.wantError)
			}
		})
	}
}

// TestC9_VoltageDropLimit tests hard constraint C9.
func TestC9_VoltageDropLimit(t *testing.T) {
	cs := NewHardConstraintSet()

	tests := []struct {
		name      string
		dropV     float64
		wantError bool
	}{
		{"drop_1pct", 6.0, false},   // 1% of 600V
		{"drop_3pct", 18.0, false},  // 3% of 600V (max allowed)
		{"drop_4pct", 24.0, true},   // 4% of 600V (exceeds)
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			graph := &CandidateArtifactGraph{
				CableCorridors: []*CableCorridorSegment{
					{CorridorID: "c1", CableType: "UG_DC", VoltageDropV: tt.dropV},
				},
			}
			err := cs.VoltageDropLimit.Validator(graph)
			if (err != nil) != tt.wantError {
				t.Errorf("Got error = %v, wantError = %v", err, tt.wantError)
			}
		})
	}
}

// TestC11_NoOrphanPanels tests hard constraint C11.
func TestC11_NoOrphanPanels(t *testing.T) {
	cs := NewHardConstraintSet()

	tests := []struct {
		name      string
		panels    []*SolarPanel
		strings   []*PanelString
		wantError bool
	}{
		{
			name: "all_panels_assigned",
			panels: []*SolarPanel{
				{PanelID: "p1"},
				{PanelID: "p2"},
			},
			strings: []*PanelString{
				{StringID: "s1", PanelIDs: []string{"p1", "p2"}},
			},
			wantError: false,
		},
		{
			name: "orphan_panel",
			panels: []*SolarPanel{
				{PanelID: "p1"},
				{PanelID: "p2"},
				{PanelID: "p3"}, // Orphan
			},
			strings: []*PanelString{
				{StringID: "s1", PanelIDs: []string{"p1", "p2"}},
			},
			wantError: true,
		},
		{
			name: "panel_in_multiple_strings",
			panels: []*SolarPanel{
				{PanelID: "p1"},
			},
			strings: []*PanelString{
				{StringID: "s1", PanelIDs: []string{"p1"}},
				{StringID: "s2", PanelIDs: []string{"p1"}}, // Also in s2!
			},
			wantError: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			graph := &CandidateArtifactGraph{
				SolarPanels: tt.panels,
				PanelStrings: tt.strings,
			}
			err := cs.NoOrphanPanels.Validator(graph)
			if (err != nil) != tt.wantError {
				t.Errorf("Got error = %v, wantError = %v", err, tt.wantError)
			}
		})
	}
}

// TestC12_TopologyConnectivity tests hard constraint C12.
func TestC12_TopologyConnectivity(t *testing.T) {
	cs := NewHardConstraintSet()

	tests := []struct {
		name        string
		inverters   []*InverterGroup
		transformers []*TransformerNode
		wantError   bool
	}{
		{
			name: "all_connected",
			inverters: []*InverterGroup{
				{InverterGroupID: "i1"},
			},
			transformers: []*TransformerNode{
				{TransformerID: "tx1", ConnectedInverterGroupIDs: []string{"i1"}},
			},
			wantError: false,
		},
		{
			name: "disconnected_inverter",
			inverters: []*InverterGroup{
				{InverterGroupID: "i1"},
				{InverterGroupID: "i2"}, // Not referenced by transformer
			},
			transformers: []*TransformerNode{
				{TransformerID: "tx1", ConnectedInverterGroupIDs: []string{"i1"}},
			},
			wantError: true,
		},
		{
			name:        "no_inverters",
			inverters:   []*InverterGroup{},
			transformers: []*TransformerNode{{TransformerID: "tx1"}},
			wantError:   true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			graph := &CandidateArtifactGraph{
				InverterGroups: tt.inverters,
				TransformerNodes: tt.transformers,
			}
			err := cs.TopologyConnectivity.Validator(graph)
			if (err != nil) != tt.wantError {
				t.Errorf("Got error = %v, wantError = %v", err, tt.wantError)
			}
		})
	}
}

// TestValidateAll tests running all hard constraints together.
func TestValidateAll(t *testing.T) {
	cs := NewHardConstraintSet()

	goodGraph := &CandidateArtifactGraph{
		SolarPanels: []*SolarPanel{
			{PanelID: "p1", TiltDegrees: 30.0, MppCapacityKw: 0.4},
		},
		PanelStrings: []*PanelString{
			{StringID: "s1", PanelIDs: []string{"p1"}, StringVoltageVdc: 600.0},
		},
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "i1", StringIDs: []string{"s1"}, DcAcRatio: 1.3},
		},
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx1", LoadKva: 100.0, KvaRating: 250.0, ConnectedInverterGroupIDs: []string{"i1"}},
		},
	}

	err := cs.Validate(goodGraph)
	if err != nil {
		t.Errorf("Valid graph should pass validation, got: %v", err)
	}

	badGraph := &CandidateArtifactGraph{
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "i1", DcAcRatio: 0.5}, // Violates C5
		},
	}

	err = cs.Validate(badGraph)
	if err == nil {
		t.Errorf("Invalid graph should fail validation")
	}
}

// ========== Soft Constraint Tests ==========

// TestSoftConstraintSet_Creation tests initialization.
func TestSoftConstraintSet_Creation(t *testing.T) {
	baselineGraph := &CandidateArtifactGraph{}
	ss := NewSoftConstraintSet(baselineGraph)

	if ss.MinimizeCableLength == nil || ss.MinimizeCableLength.Weight != 0.15 {
		t.Errorf("MinimizeCableLength constraint not initialized correctly")
	}
	if len(ss.AllConstraints) != 5 {
		t.Errorf("Expected 5 soft constraints, got %d", len(ss.AllConstraints))
	}
}

// TestSoftConstraint_Penalty tests penalty computation.
func TestSoftConstraint_Penalty(t *testing.T) {
	sc := &SoftConstraint{
		Weight:        0.15,
		BaselineValue: 2000.0,
		Metric: func(g *CandidateArtifactGraph) float64 {
			return 1000.0 // Half of baseline
		},
	}

	graph := &CandidateArtifactGraph{}
	penalty := sc.ComputePenalty(graph)

	// 1000 / 2000 = 0.5
	expectedPenalty := 0.5
	if penalty != expectedPenalty {
		t.Errorf("ComputePenalty() = %.2f, want %.2f", penalty, expectedPenalty)
	}
}

// ========== Objectives Tests ==========

// TestObjectiveSet_Creation tests initialization.
func TestObjectiveSet_Creation(t *testing.T) {
	os := NewObjectiveSet(100.0) // 100 MW target

	if os.MaximizeFeasibility == nil || os.MaximizeFeasibility.Weight != 0.30 {
		t.Errorf("MaximizeFeasibility not initialized correctly")
	}
	if os.MaximizeMwFit.TargetValue != 100.0 {
		t.Errorf("MW target not set correctly")
	}
	if len(os.AllObjectives) != 4 {
		t.Errorf("Expected 4 objectives, got %d", len(os.AllObjectives))
	}
	if os.AggregationMethod != "LEXICOGRAPHIC" {
		t.Errorf("Aggregation method should be LEXICOGRAPHIC")
	}
}

// ========== Helper Metric Tests ==========

// TestComputeTotalCapacity tests capacity computation.
func TestComputeTotalCapacity(t *testing.T) {
	graph := &CandidateArtifactGraph{
		SolarPanels: []*SolarPanel{
			{PanelID: "p1", MppCapacityKw: 0.4},
			{PanelID: "p2", MppCapacityKw: 0.4},
			{PanelID: "p3", MppCapacityKw: 0.4},
		},
	}

	capacity := ComputeTotalCapacity(graph)
	expectedCapacity := 1.2 / 1000.0 // 0.0012 MW

	if capacity != expectedCapacity {
		t.Errorf("ComputeTotalCapacity() = %.4f, want %.4f", capacity, expectedCapacity)
	}
}

// TestComputeCostProxy tests cost estimation.
func TestComputeCostProxy(t *testing.T) {
	graph := &CandidateArtifactGraph{
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "i1"},
			{InverterGroupID: "i2"},
		},
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx1"},
		},
		CableCorridors: []*CableCorridorSegment{
			{CorridorID: "c1", LengthM: 1000.0},
		},
	}

	cost := ComputeCostProxy(graph)
	// Cost = (2 * 1000) + (1 * 2000) + (1000 * 0.5) = 2000 + 2000 + 500 = 4500
	// Normalized: 4500 / 1000000 = 0.0045
	expectedCost := 4500.0 / 1000000.0

	if cost != expectedCost {
		t.Errorf("ComputeCostProxy() = %.6f, want %.6f", cost, expectedCost)
	}
}

// TestComputeLandUtilization tests GCR computation.
func TestComputeLandUtilization(t *testing.T) {
	graph := &CandidateArtifactGraph{
		SolarPanels: []*SolarPanel{
			{PanelID: "p1"},
			{PanelID: "p2"},
		},
	}

	// Assume 2 m²/panel, 100 m² site
	utilization := ComputeLandUtilization(graph, 100.0)
	// GCR = (2 * 2.0) / 100 = 4 / 100 = 0.04
	expectedUtilization := 0.04

	if utilization != expectedUtilization {
		t.Errorf("ComputeLandUtilization() = %.2f, want %.2f", utilization, expectedUtilization)
	}
}

// ========== Import Fix ==========
import "math"
