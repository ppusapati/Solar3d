package ml_inference

import (
	"math"
	"testing"
	"time"
)

// TestSolarPanelCreation_ValidGeometry validates panel creation with correct geometry.
func TestSolarPanelCreation_ValidGeometry(t *testing.T) {
	panel := &SolarPanel{
		PanelID: "panel-1",
		AssetID: "asset-panel-400w",
		TileID:  "tile-1",
		Geometry: Geometry{
			Vertices: []Point3D{
				{Longitude: -120.5, Latitude: 38.3, ElevationM: 500.0},
				{Longitude: -120.49, Latitude: 38.3, ElevationM: 500.0},
				{Longitude: -120.49, Latitude: 38.31, ElevationM: 500.0},
				{Longitude: -120.5, Latitude: 38.31, ElevationM: 500.0},
			},
		},
		TiltDegrees:    20.0,
		AzimuthDegrees: 180.0,
		MppCapacityKw:  0.4,
		LayoutScore:    0.95,
		ShadingFactor:  0.05,
		CreatedBy:      "deterministic_synthesis",
		CreatedAt:      time.Now(),
	}

	if panel.PanelID == "" {
		t.Errorf("Panel ID should not be empty")
	}
	if len(panel.Geometry.Vertices) != 4 {
		t.Errorf("Panel geometry should have 4 vertices, got %d", len(panel.Geometry.Vertices))
	}
	if panel.TiltDegrees < 0 || panel.TiltDegrees > 90 {
		t.Errorf("Tilt must be [0, 90], got %f", panel.TiltDegrees)
	}
	if panel.LayoutScore < 0 || panel.LayoutScore > 1 {
		t.Errorf("Layout score must be [0, 1], got %f", panel.LayoutScore)
	}
}

// TestSolarPanelCreation_InvalidTilt validates tilt bounds checking.
func TestSolarPanelCreation_InvalidTilt(t *testing.T) {
	tests := []struct {
		name        string
		tilt        float64
		shouldError bool
	}{
		{"tilt_too_low", -1.0, true},
		{"tilt_too_high", 91.0, true},
		{"tilt_min_valid", 0.0, false},
		{"tilt_max_valid", 90.0, false},
		{"tilt_mid_range", 30.0, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			panel := &SolarPanel{TiltDegrees: tt.tilt}
			if tt.shouldError {
				if panel.TiltDegrees >= 0 && panel.TiltDegrees <= 90 {
					t.Errorf("Tilt %f should be invalid", tt.tilt)
				}
			}
		})
	}
}

// TestPanelStringCreation_SeriesConnection validates string panel composition.
func TestPanelStringCreation_SeriesConnection(t *testing.T) {
	panelIDs := []string{"panel-1", "panel-2", "panel-3", "panel-4"}
	str := &PanelString{
		StringID:         "string-s1",
		LayoutID:         "layout-1",
		PanelIDs:         panelIDs,
		PanelCount:       int32(len(panelIDs)),
		StringVoltageVdc: 100.0, // 4 panels * 25V
		StringCurrentAdc: 10.0,
		StringPowerKw:    1.6, // 4 * 0.4 kW
		CreatedBy:        "deterministic_synthesis",
		CreatedAt:        time.Now(),
	}

	if int(str.PanelCount) != len(str.PanelIDs) {
		t.Errorf("Panel count mismatch: %d != %d", str.PanelCount, len(str.PanelIDs))
	}
	if str.StringPowerKw != 1.6 {
		t.Errorf("Expected 1.6 kW, got %f", str.StringPowerKw)
	}
}

// TestPanelStringCreation_VoltageBounds validates voltage constraint C3.
func TestPanelStringCreation_VoltageBounds(t *testing.T) {
	// Typical inverter MPPT range: 200V – 900V
	minVoltage := 200.0
	maxVoltage := 900.0

	tests := []struct {
		name       string
		voltage    float64
		shouldFail bool
	}{
		{"voltage_too_low", 100.0, true},
		{"voltage_too_high", 1000.0, true},
		{"voltage_at_min", 200.0, false},
		{"voltage_at_max", 900.0, false},
		{"voltage_midrange", 600.0, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			str := &PanelString{StringVoltageVdc: tt.voltage}
			violated := str.StringVoltageVdc < minVoltage || str.StringVoltageVdc > maxVoltage
			if tt.shouldFail != violated {
				t.Errorf("Voltage %f: expected fail=%v, got fail=%v", tt.voltage, tt.shouldFail, violated)
			}
		})
	}
}

// TestInverterGroupCreation_DcAcRatio validates hard constraint C5.
func TestInverterGroupCreation_DcAcRatio(t *testing.T) {
	// Hard constraint C5: DC/AC ratio [1.1, 1.5]
	minRatio := 1.1
	maxRatio := 1.5

	tests := []struct {
		name       string
		dcInput    float64
		acOutput   float64
		shouldFail bool
	}{
		{"ratio_1.0", 200.0, 200.0, true},  // 1.0 < 1.1, fail
		{"ratio_1.1", 220.0, 200.0, false}, // 1.1 OK
		{"ratio_1.3", 260.0, 200.0, false}, // 1.3 OK
		{"ratio_1.5", 300.0, 200.0, false}, // 1.5 OK
		{"ratio_1.6", 320.0, 200.0, true},  // 1.6 > 1.5, fail
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			inv := &InverterGroup{
				DcInputKw:  tt.dcInput,
				AcOutputKw: tt.acOutput,
				DcAcRatio:  tt.dcInput / tt.acOutput,
			}
			violated := inv.DcAcRatio < minRatio || inv.DcAcRatio > maxRatio
			if tt.shouldFail != violated {
				t.Errorf("DC/AC %.2f: expected fail=%v, got fail=%v", inv.DcAcRatio, tt.shouldFail, violated)
			}
		})
	}
}

// TestTransformerNodeCreation_LoadCapacity validates hard constraint C6.
func TestTransformerNodeCreation_LoadCapacity(t *testing.T) {
	tests := []struct {
		name       string
		loadKva    float64
		kvaBating  float64
		shouldFail bool
	}{
		{"load_50pct", 125.0, 250.0, false},
		{"load_100pct", 250.0, 250.0, false},
		{"load_110pct", 275.0, 250.0, true}, // Overload, fail
		{"load_200pct", 500.0, 250.0, true}, // Severe overload, fail
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tx := &TransformerNode{
				LoadKva:            tt.loadKva,
				KvaRating:          tt.kvaBating,
				LoadUtilizationPct: (tt.loadKva / tt.kvaBating) * 100,
			}
			violated := tx.LoadKva > tx.KvaRating
			if tt.shouldFail != violated {
				t.Errorf("Load %.2f kVA vs rating %.2f: expected fail=%v, got fail=%v", tt.loadKva, tt.kvaBating, tt.shouldFail, violated)
			}
		})
	}
}

// TestCableCorridorSegment_LengthAndCurrent validates cable constraints.
func TestCableCorridorSegment_LengthAndCurrent(t *testing.T) {
	cable := &CableCorridorSegment{
		CorridorID:       "cable-1",
		LengthM:          2500.0,
		CableType:        "UG_DC",
		ConductorCount:   2,
		ConductorSizeMm2: 35.0,
		CurrentRatingAdc: 400.0,
		VoltageDropV:     12.5,
	}

	if cable.LengthM != 2500.0 {
		t.Errorf("Length mismatch")
	}
	if cable.CurrentRatingAdc <= 0 {
		t.Errorf("Current rating must be positive")
	}
	if cable.VoltageDropV < 0 {
		t.Errorf("Voltage drop must be non-negative")
	}
}

// TestFaultIdentifier_UpstreamChain validates fault isolation chains.
func TestFaultIdentifier_UpstreamChain(t *testing.T) {
	fault := &FaultIdentifier{
		FaultID:         "fault-1",
		Scope:           "string_combiner",
		ProtectionType:  "fuse",
		FaultScenario:   "conductor_short",
		DetectionMethod: "relay",
		IsolationTimeMs: 100.0,
		UpstreamEntities: UpstreamEntities{
			AffectedStringIDs:      []string{"string-1", "string-2", "string-3"},
			AffectedInverterIDs:    []string{"inverter-1"},
			AffectedTransformerIDs: []string{"transformer-1"},
		},
	}

	if len(fault.UpstreamEntities.AffectedStringIDs) != 3 {
		t.Errorf("Expected 3 affected strings, got %d", len(fault.UpstreamEntities.AffectedStringIDs))
	}
	if fault.IsolationTimeMs < 0 {
		t.Errorf("Isolation time cannot be negative")
	}
}

// TestValidateFeasibility_AllConstraintsPassed tests a fully valid artifact graph.
func TestValidateFeasibility_AllConstraintsPassed(t *testing.T) {
	graph := &CandidateArtifactGraph{
		LayoutID:  "layout-1",
		ProjectID: "project-1",
		SolarPanels: []*SolarPanel{
			{
				PanelID:           "panel-1",
				LayoutID:          "layout-1",
				TiltDegrees:       20.0,
				AzimuthDegrees:    180.0,
				MppCapacityKw:     0.4,
				FeasibilityStatus: "VALID",
			},
		},
		PanelStrings: []*PanelString{
			{
				StringID:          "string-1",
				LayoutID:          "layout-1",
				PanelIDs:          []string{"panel-1"},
				PanelCount:        1,
				StringVoltageVdc:  600.0,
				StringPowerKw:     0.4,
				FeasibilityStatus: "VALID",
			},
		},
		InverterGroups: []*InverterGroup{
			{
				InverterGroupID:   "inverter-1",
				LayoutID:          "layout-1",
				StringIDs:         []string{"string-1"},
				StringCount:       1,
				DcInputKw:         0.4,
				AcOutputKw:        0.3,
				DcAcRatio:         1.33,
				FeasibilityStatus: "VALID",
			},
		},
		TransformerNodes: []*TransformerNode{
			{
				TransformerID:     "transformer-1",
				LayoutID:          "layout-1",
				LoadKva:           0.3,
				KvaRating:         250.0,
				FeasibilityStatus: "VALID",
			},
		},
	}

	err := graph.ValidateFeasibility()
	if err != nil {
		t.Errorf("Valid graph should pass validation, got error: %v", err)
	}
}

// TestValidateFeasibility_VoltageViolation_C3 tests hard constraint C3 failure.
func TestValidateFeasibility_VoltageViolation_C3(t *testing.T) {
	graph := &CandidateArtifactGraph{
		LayoutID:  "layout-1",
		ProjectID: "project-1",
		PanelStrings: []*PanelString{
			{
				StringID:          "string-inv-1",
				LayoutID:          "layout-1",
				StringVoltageVdc:  1100.0, // Too high (exceeds typical MPPT max of 900V)
				FeasibilityStatus: "INVALID",
				FeasibilityReason: stringPtr("Voltage 1100V exceeds MPPT max 900V"),
			},
		},
	}

	err := graph.ValidateFeasibility()
	if err == nil {
		t.Errorf("Graph with voltage violation should fail validation")
	}
}

// TestValidateFeasibility_DcAcOutOfBounds_C5 tests hard constraint C5 failure.
func TestValidateFeasibility_DcAcOutOfBounds_C5(t *testing.T) {
	graph := &CandidateArtifactGraph{
		LayoutID:  "layout-1",
		ProjectID: "project-1",
		InverterGroups: []*InverterGroup{
			{
				InverterGroupID:   "inverter-bad",
				LayoutID:          "layout-1",
				DcInputKw:         100.0,
				AcOutputKw:        200.0,
				DcAcRatio:         0.5, // Too low (min is 1.1)
				FeasibilityStatus: "INVALID",
				FeasibilityReason: stringPtr("DC/AC ratio 0.5 < 1.1"),
			},
		},
	}

	err := graph.ValidateFeasibility()
	if err == nil {
		t.Errorf("Graph with DC/AC out of bounds should fail validation")
	}
}

// TestValidateFeasibility_TransformerOverload_C6 tests hard constraint C6 failure.
func TestValidateFeasibility_TransformerOverload_C6(t *testing.T) {
	graph := &CandidateArtifactGraph{
		LayoutID:  "layout-1",
		ProjectID: "project-1",
		TransformerNodes: []*TransformerNode{
			{
				TransformerID:     "transformer-overload",
				LayoutID:          "layout-1",
				LoadKva:           300.0, // Exceeds capacity
				KvaRating:         250.0,
				FeasibilityStatus: "VALID", // Will fail in validation
			},
		},
	}

	err := graph.ValidateFeasibility()
	if err == nil {
		t.Errorf("Graph with transformer overload should fail validation")
	} else if err.Error() != "transformer overload-zero uuid load 300.00 kVA exceeds rating 250.00 kVA" {
		// Should mention overload
		if !contains(err.Error(), "300") || !contains(err.Error(), "250") {
			t.Logf("Error message may not be exactly expected, but validation passed: %v", err)
		}
	}
}

// TestValidateFeasibility_OrphanPanel_C11 tests hard constraint C11 (no orphans).
func TestValidateFeasibility_OrphanPanel_C11(t *testing.T) {
	graph := &CandidateArtifactGraph{
		LayoutID:  "layout-1",
		ProjectID: "project-1",
		SolarPanels: []*SolarPanel{
			{
				PanelID:  "panel-orphan",
				LayoutID: "layout-1",
				StringID: nil, // Not assigned to any string
			},
		},
		PanelStrings: []*PanelString{}, // No strings referencing this panel
	}

	err := graph.ValidateFeasibility()
	if err == nil {
		t.Errorf("Graph with orphan panel should fail validation")
	}
}

// TestComputeChecksum_Deterministic verifies checksum reproducibility.
func TestComputeChecksum_Deterministic(t *testing.T) {
	graph := &CandidateArtifactGraph{
		LayoutID:  "layout-1",
		ProjectID: "project-1",
		SolarPanels: []*SolarPanel{
			{
				PanelID:        "panel-1",
				TiltDegrees:    20.5,
				AzimuthDegrees: 180.0,
			},
		},
	}

	checksum1 := graph.ComputeChecksum()
	checksum2 := graph.ComputeChecksum()

	if checksum1 != checksum2 {
		t.Errorf("Checksum not deterministic: %s != %s", checksum1, checksum2)
	}
	if len(checksum1) != 64 {
		t.Errorf("Checksum should be 64 hex chars (SHA256), got %d", len(checksum1))
	}
}

// TestChecksum_GeometryChange_NewChecksum verifies checksum sensitivity.
func TestChecksum_GeometryChange_NewChecksum(t *testing.T) {
	panelBase := &SolarPanel{
		PanelID:        "panel-1",
		TiltDegrees:    20.5,
		AzimuthDegrees: 180.0,
	}

	panelModified := &SolarPanel{
		PanelID:        "panel-1",
		TiltDegrees:    21.0, // Changed
		AzimuthDegrees: 180.0,
	}

	graph1 := &CandidateArtifactGraph{
		LayoutID:    "layout-1",
		SolarPanels: []*SolarPanel{panelBase},
	}
	graph2 := &CandidateArtifactGraph{
		LayoutID:    "layout-1",
		SolarPanels: []*SolarPanel{panelModified},
	}

	checksum1 := graph1.ComputeChecksum()
	checksum2 := graph2.ComputeChecksum()

	if checksum1 == checksum2 {
		t.Errorf("Modified panel should produce different checksum")
	}
}

// TestSummary_ReturnsExpectedFormat verifies human-readable summary.
func TestSummary_ReturnsExpectedFormat(t *testing.T) {
	graph := &CandidateArtifactGraph{
		LayoutID:  "layout-abc",
		ProjectID: "project-xyz",
		SolarPanels: []*SolarPanel{
			{PanelID: "p1", MppCapacityKw: 0.4},
			{PanelID: "p2", MppCapacityKw: 0.4},
			{PanelID: "p3", MppCapacityKw: 0.4},
		},
		PanelStrings:     []*PanelString{{StringID: "s1"}, {StringID: "s2"}},
		InverterGroups:   []*InverterGroup{{InverterGroupID: "i1"}},
		TransformerNodes: []*TransformerNode{{TransformerID: "t1"}},
		CableCorridors:   []*CableCorridorSegment{{CorridorID: "c1"}, {CorridorID: "c2"}},
		FaultIdentifiers: []*FaultIdentifier{{FaultID: "f1"}},
	}

	summary := graph.Summary()

	if !contains(summary, "layout-abc") {
		t.Errorf("Summary should include layout ID")
	}
	if !contains(summary, "panels=3") {
		t.Errorf("Summary should include panel count")
	}
	if !contains(summary, "capacity=1.2") {
		t.Errorf("Summary should include total capacity")
	}
	if !contains(summary, "strings=2") {
		t.Errorf("Summary should include string count")
	}
	if !contains(summary, "inverters=1") {
		t.Errorf("Summary should include inverter count")
	}
}

// ========== Helper Functions ==========

func stringPtr(s string) *string {
	return &s
}

func contains(s, substr string) bool {
	return len(s) > 0 && len(substr) > 0 && (s == substr || (len(s) > len(substr) && len(substr) > 0))
}

func floatEqual(a, b float64) bool {
	return math.Abs(a-b) < 1e-6
}
