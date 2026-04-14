package ml_inference

import "testing"

func TestCandidateSearchExecutor_Execute_IncludesFallbackAndRanking(t *testing.T) {
	baseInput := &SynthesisInput{
		ProjectID: "project-search-1",
		LayoutID:  "layout-search-1",
		Seed:      100,
		Boundary: Geometry{
			Vertices: []Point3D{
				{Longitude: -120.5, Latitude: 38.3, ElevationM: 1000},
				{Longitude: -120.4, Latitude: 38.3, ElevationM: 1000},
				{Longitude: -120.4, Latitude: 38.4, ElevationM: 1000},
				{Longitude: -120.5, Latitude: 38.4, ElevationM: 1000},
			},
		},
		DecisionSpace: NewDecisionSpace(),
	}

	executor, err := NewCandidateSearchExecutor(&CandidateSearchConfig{
		BaseInput:                    baseInput,
		HardConstraints:              NewHardConstraintSet(),
		ScoringEngine:                NewScoringEngine(5.0, 100000.0, NewHardConstraintSet(), NewSoftConstraintSet(nil)),
		VariantCount:                 4,
		IncludeDeterministicFallback: true,
		MaxParetoCandidates:          3,
	})
	if err != nil {
		t.Fatalf("executor init failed: %v", err)
	}

	result, err := executor.Execute()
	if err != nil {
		t.Fatalf("execute failed: %v", err)
	}

	if result.DeterministicFallback == nil {
		t.Fatalf("deterministic fallback should be present")
	}
	if len(result.RankedCandidates) == 0 {
		t.Fatalf("ranked candidates should not be empty")
	}
	if result.Metadata == nil {
		t.Fatalf("metadata should be present")
	}
	if result.Metadata.FallbackCandidateID == "" {
		t.Fatalf("fallback candidate id should be populated")
	}
	if len(result.ParetoFrontCandidates) == 0 {
		t.Fatalf("pareto front should not be empty")
	}
	if result.RankedCandidates[0].Rank != 1 {
		t.Fatalf("top ranked candidate should have rank 1")
	}
}

func TestCandidateSearchExecutor_Execute_IsDeterministic(t *testing.T) {
	config := &CandidateSearchConfig{
		BaseInput: &SynthesisInput{
			ProjectID: "project-search-2",
			LayoutID:  "layout-search-2",
			Seed:      101,
			Boundary: Geometry{
				Vertices: []Point3D{
					{Longitude: -121.0, Latitude: 37.0, ElevationM: 500},
					{Longitude: -120.8, Latitude: 37.0, ElevationM: 500},
					{Longitude: -120.8, Latitude: 37.2, ElevationM: 500},
					{Longitude: -121.0, Latitude: 37.2, ElevationM: 500},
				},
			},
			DecisionSpace: NewDecisionSpace(),
		},
		HardConstraints:              NewHardConstraintSet(),
		ScoringEngine:                NewScoringEngine(5.0, 100000.0, NewHardConstraintSet(), NewSoftConstraintSet(nil)),
		VariantCount:                 3,
		IncludeDeterministicFallback: true,
		MaxParetoCandidates:          3,
	}

	executorA, err := NewCandidateSearchExecutor(config)
	if err != nil {
		t.Fatalf("executorA init failed: %v", err)
	}
	resultA, err := executorA.Execute()
	if err != nil {
		t.Fatalf("execute A failed: %v", err)
	}

	executorB, err := NewCandidateSearchExecutor(config)
	if err != nil {
		t.Fatalf("executorB init failed: %v", err)
	}
	resultB, err := executorB.Execute()
	if err != nil {
		t.Fatalf("execute B failed: %v", err)
	}

	if len(resultA.RankedCandidates) != len(resultB.RankedCandidates) {
		t.Fatalf("ranked candidate counts differ")
	}
	for i := range resultA.RankedCandidates {
		if resultA.RankedCandidates[i].CandidateID != resultB.RankedCandidates[i].CandidateID {
			t.Fatalf("candidate order mismatch at %d", i)
		}
	}
	if resultA.Metadata.FallbackCandidateID != resultB.Metadata.FallbackCandidateID {
		t.Fatalf("fallback ids differ")
	}
}

func TestSelectParetoFront_FiltersDominatedCandidates(t *testing.T) {
	candidates := []*MLCandidate{
		{CandidateID: "a", ObjectiveScores: map[string]float64{"feasibility": 1.0, "mw_fit": 0.9, "cost": 0.8, "land_use": 0.6}},
		{CandidateID: "b", ObjectiveScores: map[string]float64{"feasibility": 0.9, "mw_fit": 0.7, "cost": 0.7, "land_use": 0.5}},
		{CandidateID: "c", ObjectiveScores: map[string]float64{"feasibility": 1.0, "mw_fit": 0.8, "cost": 0.95, "land_use": 0.7}},
	}

	front := SelectParetoFront(candidates)
	if len(front) != 2 {
		t.Fatalf("expected 2 non-dominated candidates, got %d", len(front))
	}

	seen := map[string]bool{}
	for _, candidate := range front {
		seen[candidate.CandidateID] = true
	}
	if seen["b"] {
		t.Fatalf("dominated candidate should not appear in pareto front")
	}
}

func TestNewCandidateSearchExecutor_RequiresConfig(t *testing.T) {
	if _, err := NewCandidateSearchExecutor(nil); err == nil {
		t.Fatalf("expected error for nil config")
	}
}
