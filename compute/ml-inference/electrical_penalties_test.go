package ml_inference

import "testing"

// ── E1 tests ─────────────────────────────────────────────────────────────────

func TestE1_InfeasibleStringing_NoViolations(t *testing.T) {
	ps := NewElectricalPenaltySet(1250, 0.90, 1500)
	g := &CandidateArtifactGraph{
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "inv-1", DcInputKw: 1200, DcAcRatio: 1.2},
		},
		PanelStrings: []*PanelString{
			{StringID: "s1", StringVoltageVdc: 600},
		},
	}
	penalty := ps.InfeasibleStringing.Metric(g)
	if penalty != 0 {
		t.Fatalf("expected 0 penalty, got %f", penalty)
	}
}

func TestE1_InfeasibleStringing_ExceedsMaxDcInput(t *testing.T) {
	ps := NewElectricalPenaltySet(1250, 0.90, 1500)
	g := &CandidateArtifactGraph{
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "inv-1", DcInputKw: 1400, DcAcRatio: 1.2}, // exceeds 1250 kW cap
		},
		PanelStrings: []*PanelString{
			{StringID: "s1", StringVoltageVdc: 600},
		},
	}
	penalty := ps.InfeasibleStringing.Metric(g)
	if penalty <= 0 {
		t.Fatalf("expected positive penalty for DC overload, got %f", penalty)
	}
}

func TestE1_InfeasibleStringing_StringVoltageOutOfRange(t *testing.T) {
	ps := NewElectricalPenaltySet(1250, 0.90, 1500)
	g := &CandidateArtifactGraph{
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "inv-1", DcInputKw: 1000, DcAcRatio: 1.2},
		},
		PanelStrings: []*PanelString{
			{StringID: "s1", StringVoltageVdc: 1100}, // exceeds MPPT max 900 V
		},
	}
	penalty := ps.InfeasibleStringing.Metric(g)
	if penalty <= 0 {
		t.Fatalf("expected positive penalty for voltage violation, got %f", penalty)
	}
}

// ── E2 tests ─────────────────────────────────────────────────────────────────

func TestE2_TransformerOverloadRisk_BelowThreshold(t *testing.T) {
	ps := NewElectricalPenaltySet(0, 0.90, 0)
	g := &CandidateArtifactGraph{
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 2000}, // 80% – below 90% threshold
		},
	}
	penalty := ps.TransformerOverloadRisk.Metric(g)
	if penalty != 0 {
		t.Fatalf("expected 0 penalty below threshold, got %f", penalty)
	}
}

func TestE2_TransformerOverloadRisk_InRiskBand(t *testing.T) {
	ps := NewElectricalPenaltySet(0, 0.90, 0)
	g := &CandidateArtifactGraph{
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 2375}, // 95% – in [0.90, 1.0] ramp
		},
	}
	penalty := ps.TransformerOverloadRisk.Metric(g)
	if penalty <= 0 || penalty >= 1 {
		t.Fatalf("expected ramp penalty in (0,1), got %f", penalty)
	}
}

func TestE2_TransformerOverloadRisk_AtFullLoad(t *testing.T) {
	ps := NewElectricalPenaltySet(0, 0.90, 0)
	g := &CandidateArtifactGraph{
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 2500}, // 100%
		},
	}
	penalty := ps.TransformerOverloadRisk.Metric(g)
	if penalty != 1.0 {
		t.Fatalf("expected max penalty at 100%% load, got %f", penalty)
	}
}

func TestE2_TransformerOverloadRisk_Overloaded(t *testing.T) {
	ps := NewElectricalPenaltySet(0, 0.90, 0)
	g := &CandidateArtifactGraph{
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 3000}, // 120%
		},
	}
	penalty := ps.TransformerOverloadRisk.Metric(g)
	if penalty != 1.0 {
		t.Fatalf("expected max penalty when overloaded, got %f", penalty)
	}
}

// ── E3 tests ─────────────────────────────────────────────────────────────────

func TestE3_ExcessiveCableProxy_WithinLimit(t *testing.T) {
	ps := NewElectricalPenaltySet(0, 0, 1500)
	g := &CandidateArtifactGraph{
		CableCorridors: []*CableCorridorSegment{
			{CorridorID: "c1", LengthM: 1200},
			{CorridorID: "c2", LengthM: 1400},
		},
	}
	penalty := ps.ExcessiveCableProxy.Metric(g)
	if penalty != 0 {
		t.Fatalf("expected 0 penalty within limit, got %f", penalty)
	}
}

func TestE3_ExcessiveCableProxy_Exceeds(t *testing.T) {
	ps := NewElectricalPenaltySet(0, 0, 1500)
	g := &CandidateArtifactGraph{
		CableCorridors: []*CableCorridorSegment{
			{CorridorID: "c1", LengthM: 3000}, // excess = (3000-1500)/1500 = 1.0
			{CorridorID: "c2", LengthM: 1500}, // excess = 0
		},
	}
	penalty := ps.ExcessiveCableProxy.Metric(g)
	if penalty <= 0 {
		t.Fatalf("expected positive cable penalty, got %f", penalty)
	}
}

func TestE3_ExcessiveCableProxy_EmptyGraph(t *testing.T) {
	ps := NewElectricalPenaltySet(0, 0, 1500)
	g := &CandidateArtifactGraph{}
	penalty := ps.ExcessiveCableProxy.Metric(g)
	if penalty != 0 {
		t.Fatalf("expected 0 for empty graph, got %f", penalty)
	}
}

// ── Aggregate and alignment tests ────────────────────────────────────────────

func TestElectricalPenaltySet_AggregatePenalty_PerfectGraph(t *testing.T) {
	ps := NewElectricalPenaltySet(1250, 0.90, 1500)
	g := &CandidateArtifactGraph{
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "inv-1", DcInputKw: 1000, DcAcRatio: 1.2},
		},
		PanelStrings: []*PanelString{
			{StringID: "s1", StringVoltageVdc: 600},
		},
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 1000},
		},
		CableCorridors: []*CableCorridorSegment{
			{CorridorID: "c1", LengthM: 800},
		},
	}
	agg := ps.ComputeAggregatePenalty(g)
	if agg != 0 {
		t.Fatalf("expected 0 aggregate penalty for clean graph, got %f", agg)
	}
	fs := ps.ElectricalFeasibilityScore(g)
	if fs != 1.0 {
		t.Fatalf("expected 1.0 electrical feasibility, got %f", fs)
	}
}

func TestElectricalPenaltySet_AlignsWithBackendThresholds(t *testing.T) {
	// Verify that a graph that would fail backend electrical validation
	// (DC/AC out of range, transformer at 95%, cable 3x limit) scores < 0.5 feasibility.
	ps := NewElectricalPenaltySet(1250, 0.90, 1500)
	g := &CandidateArtifactGraph{
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "inv-1", DcInputKw: 1400, DcAcRatio: 1.8}, // both violations
		},
		PanelStrings: []*PanelString{
			{StringID: "s1", StringVoltageVdc: 1100}, // over-voltage
		},
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 2375}, // 95%, in risk band
		},
		CableCorridors: []*CableCorridorSegment{
			{CorridorID: "c1", LengthM: 4500}, // 3× limit
		},
	}
	fs := ps.ElectricalFeasibilityScore(g)
	if fs >= 0.5 {
		t.Fatalf("expected electrically infeasible candidate to score < 0.5, got %f", fs)
	}
}

// ── ScoringEngineWithElectrical tests ────────────────────────────────────────

func TestScoringEngineWithElectrical_AdjustedScoreLowerThanBase(t *testing.T) {
	base := NewScoringEngine(2.0, 50000.0, NewHardConstraintSet(), NewSoftConstraintSet(nil))
	ps := NewElectricalPenaltySet(1250, 0.90, 1500)
	elecEngine := base.WithElectricalPenalties(ps)

	// Graph with electrical violations so elec penalty > 0.
	g := &CandidateArtifactGraph{
		LayoutID: "layout-elec-test",
		InverterGroups: []*InverterGroup{
			{InverterGroupID: "inv-1", DcInputKw: 1400, DcAcRatio: 1.2},
		},
		TransformerNodes: []*TransformerNode{
			{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 2375,
				ConnectedInverterGroupIDs: []string{"inv-1"}},
		},
		PanelStrings: []*PanelString{
			{StringID: "s1", StringVoltageVdc: 600, PanelIDs: []string{"p1"}},
		},
		SolarPanels: []*SolarPanel{
			{PanelID: "p1", MppCapacityKw: 400},
		},
		CableCorridors: []*CableCorridorSegment{
			{CorridorID: "c1", LengthM: 3000, CurrentRatingAdc: 400},
		},
	}

	baseBreakdown, _ := base.ScoreCandidate(g)
	elecBreakdown, err := elecEngine.ScoreCandidate(g)
	if err != nil {
		t.Fatalf("score failed: %v", err)
	}

	if elecBreakdown.AdjustedCompositeScore > baseBreakdown.CompositeScore {
		t.Fatalf("adjusted score %.4f should be <= base score %.4f",
			elecBreakdown.AdjustedCompositeScore, baseBreakdown.CompositeScore)
	}
	if elecBreakdown.ElectricalPenalty <= 0 {
		t.Fatalf("expected positive electrical penalty for violation graph")
	}
}

func TestScoringEngineWithElectrical_RankCandidates_Deterministic(t *testing.T) {
	base := NewScoringEngine(2.0, 50000.0, NewHardConstraintSet(), NewSoftConstraintSet(nil))
	elecEngine := base.WithElectricalPenalties(NewElectricalPenaltySet(0, 0, 0))

	c1 := &CandidateArtifactGraph{
		LayoutID:         "layout-z",
		InverterGroups:   []*InverterGroup{{InverterGroupID: "inv-1", DcInputKw: 1000, DcAcRatio: 1.2}},
		TransformerNodes: []*TransformerNode{{TransformerID: "tx-1", KvaRating: 2500, LoadKva: 800, ConnectedInverterGroupIDs: []string{"inv-1"}}},
		PanelStrings:     []*PanelString{{StringID: "s1", StringVoltageVdc: 600, PanelIDs: []string{"p1"}}},
		SolarPanels:      []*SolarPanel{{PanelID: "p1", MppCapacityKw: 400}},
	}
	c2 := &CandidateArtifactGraph{
		LayoutID:         "layout-a",
		InverterGroups:   []*InverterGroup{{InverterGroupID: "inv-2", DcInputKw: 1000, DcAcRatio: 1.2}},
		TransformerNodes: []*TransformerNode{{TransformerID: "tx-2", KvaRating: 2500, LoadKva: 800, ConnectedInverterGroupIDs: []string{"inv-2"}}},
		PanelStrings:     []*PanelString{{StringID: "s2", StringVoltageVdc: 600, PanelIDs: []string{"p2"}}},
		SolarPanels:      []*SolarPanel{{PanelID: "p2", MppCapacityKw: 400}},
	}

	ranked1, err := elecEngine.RankCandidates([]*CandidateArtifactGraph{c1, c2})
	if err != nil {
		t.Fatalf("first rank failed: %v", err)
	}
	ranked2, err := elecEngine.RankCandidates([]*CandidateArtifactGraph{c1, c2})
	if err != nil {
		t.Fatalf("second rank failed: %v", err)
	}

	if len(ranked1) != len(ranked2) {
		t.Fatalf("ranked counts differ")
	}
	for i := range ranked1 {
		if ranked1[i].CandidateID != ranked2[i].CandidateID {
			t.Fatalf("non-deterministic ranking at position %d", i)
		}
	}
}
