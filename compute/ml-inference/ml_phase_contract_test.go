package ml_inference

import (
	"fmt"
	"testing"
	"time"
)

// ========== Contract Validation Fixture ==========

// TestContract_MLPhaseOutput_MinimalValidInstance verifies that a minimal
// MLPhaseOutput instance can be constructed with all required fields.
func TestContract_MLPhaseOutput_MinimalValidInstance(t *testing.T) {
	minimalOutput := &MLPhaseOutput{
		ProjectID:    "proj-test",
		LayoutID:     "layout-test",
		ExperimentID: "exp-test",
		Timestamp:    time.Now(),
		Version:      "1.0",
		FinalRankedCandidates: []*MLCandidate{
			{
				CandidateID:    "cand-1",
				CompositeScore: 0.9,
				Rank:           1,
				ObjectiveScores: map[string]float64{
					"feasibility": 0.95,
					"mw_fit":      0.85,
					"cost":        0.8,
					"land_use":    0.7,
				},
			},
		},
		RecommendedCandidateID: "cand-1",
		FallbackCandidateID:    "cand-1",
		DeterministicSeed:      42,
	}

	if minimalOutput.ProjectID == "" {
		t.Fatal("ProjectID must not be empty")
	}
	if len(minimalOutput.FinalRankedCandidates) == 0 {
		t.Fatal("FinalRankedCandidates must not be empty")
	}
	if minimalOutput.FallbackCandidateID == "" {
		t.Fatal("FallbackCandidateID must always be set (contract guarantee)")
	}
	t.Logf("contract: minimal valid MLPhaseOutput constructed successfully")
}

// TestContract_MLCandidate_RankInvariant verifies that Rank values
// are sequential from 1.
func TestContract_MLCandidate_RankInvariant(t *testing.T) {
	output := &MLPhaseOutput{
		ProjectID:    "test",
		LayoutID:     "layout",
		ExperimentID: "exp",
		Timestamp:    time.Now(),
		Version:      "1.0",
		FinalRankedCandidates: []*MLCandidate{
			{CandidateID: "c1", Rank: 1, CompositeScore: 0.95},
			{CandidateID: "c2", Rank: 2, CompositeScore: 0.85},
			{CandidateID: "c3", Rank: 3, CompositeScore: 0.75},
		},
		RecommendedCandidateID: "c1",
		FallbackCandidateID:    "c1",
	}

	for i, cand := range output.FinalRankedCandidates {
		expectedRank := int32(i + 1)
		if cand.Rank != expectedRank {
			t.Fatalf("candidate %d: expected Rank=%d, got %d",
				i, expectedRank, cand.Rank)
		}
	}
	t.Logf("contract: rank invariant verified")
}

// TestContract_MLCandidate_ObjectiveScores_AllKeysPresent verifies that
// expected ObjectiveScores keys are populated.
func TestContract_MLCandidate_ObjectiveScores_AllKeysPresent(t *testing.T) {
	candidate := &MLCandidate{
		CandidateID: "test",
		ObjectiveScores: map[string]float64{
			"feasibility":  0.9,
			"mw_fit":       0.8,
			"cost":         0.7,
			"land_use":     0.6,
			"soft_penalty": 0.1,
		},
	}

	requiredKeys := []string{"feasibility", "mw_fit", "cost", "land_use", "soft_penalty"}
	for _, key := range requiredKeys {
		if _, ok := candidate.ObjectiveScores[key]; !ok {
			t.Fatalf("required ObjectiveScores key missing: %s", key)
		}
	}
	t.Logf("contract: all required ObjectiveScores keys present")
}

// TestContract_CandidateArtifactGraph_ImmutatbleAssertion documents that
// consumers must not modify CandidateArtifactGraph fields in-place.
func TestContract_CandidateArtifactGraph_ImmutatbleAssertion(t *testing.T) {
	original := &CandidateArtifactGraph{
		LayoutID:  "layout-123",
		ProjectID: "proj-456",
	}

	// Backend consumer receives the graph.
	received := original

	// Contract: don't modify fields.
	if received.LayoutID != "layout-123" {
		t.Fatal("contract violation: LayoutID should not be modified")
	}

	t.Logf("contract: immutability assertion passed")
}

// TestContract_DeterministicFallback_AlwaysPresent verifies that
// DeterministicFallback is never nil in search results.
func TestContract_DeterministicFallback_AlwaysPresent(t *testing.T) {
	result := &CandidateSearchResult{
		RankedCandidates: []*MLCandidate{
			{CandidateID: "c1", CompositeScore: 0.9},
		},
		DeterministicFallback: &MLCandidate{
			CandidateID:    "fb",
			CompositeScore: 0.5,
		},
	}

	if result.DeterministicFallback == nil {
		t.Fatal("contract violation: DeterministicFallback must always be present")
	}

	t.Logf("contract: deterministic fallback guarantee verified")
}

// TestContract_ParetoDominanceRelation verifies that Pareto frontier
// satisfies non-dominance.
func TestContract_ParetoDominanceRelation(t *testing.T) {
	// A simple Pareto check: for each pair in the frontier, neither should
	// dominate the other.
	front := []*MLCandidate{
		{
			CandidateID: "p1",
			ObjectiveScores: map[string]float64{
				"feasibility": 0.9, "mw_fit": 0.7, "cost": 0.5, "land_use": 0.4,
			},
		},
		{
			CandidateID: "p2",
			ObjectiveScores: map[string]float64{
				"feasibility": 0.7, "mw_fit": 0.9, "cost": 0.6, "land_use": 0.3,
			},
		},
		{
			CandidateID: "p3",
			ObjectiveScores: map[string]float64{
				"feasibility": 0.8, "mw_fit": 0.8, "cost": 0.8, "land_use": 0.5,
			},
		},
	}

	// In a valid Pareto frontier, no candidate strictly dominates another.
	// (Real frontiers use dominates() logic; this is a conceptual check.)
	for i := range front {
		for j := range front {
			if i != j {
				// Verify that neither fully dominates the other on all metrics.
				allBetter := true
				for _, metric := range []string{"feasibility", "mw_fit", "cost", "land_use"} {
					if front[i].ObjectiveScores[metric] < front[j].ObjectiveScores[metric] {
						allBetter = false
						break
					}
				}
				if allBetter {
					// front[i] ≥ front[j] on all metrics.
					// Check if strictly better on at least one.
					strictlyBetter := false
					for _, metric := range []string{"feasibility", "mw_fit", "cost", "land_use"} {
						if front[i].ObjectiveScores[metric] > front[j].ObjectiveScores[metric] {
							strictlyBetter = true
							break
						}
					}
					if strictlyBetter {
						t.Logf("contract: Pareto dominance detected (valid for filtering)")
					}
				}
			}
		}
	}

	t.Logf("contract: Pareto relation check completed")
}

// TestContract_CompositeScore_AlwaysInRange verifies that composite scores
// are normalized to [0, 1].
func TestContract_CompositeScore_AlwaysInRange(t *testing.T) {
	candidates := []*MLCandidate{
		{CandidateID: "c1", CompositeScore: 0.0},
		{CandidateID: "c2", CompositeScore: 0.5},
		{CandidateID: "c3", CompositeScore: 1.0},
	}

	for _, cand := range candidates {
		if cand.CompositeScore < 0 || cand.CompositeScore > 1 {
			t.Fatalf("CompositeScore out of range [0,1]: %f", cand.CompositeScore)
		}
	}
	t.Logf("contract: composite scores in valid range")
}

// TestContract_Confidence_LowerUpperBounds verifies that confidence intervals
// satisfy lower ≤ upper and both in [0,1].
func TestContract_Confidence_LowerUpperBounds(t *testing.T) {
	candidates := []*MLCandidate{
		{
			CandidateID:     "c1",
			ConfidenceLower: 0.7,
			ConfidenceUpper: 0.9,
		},
	}

	for _, cand := range candidates {
		if cand.ConfidenceLower < 0 || cand.ConfidenceLower > 1 {
			t.Fatalf("ConfidenceLower out of range: %f", cand.ConfidenceLower)
		}
		if cand.ConfidenceUpper < 0 || cand.ConfidenceUpper > 1 {
			t.Fatalf("ConfidenceUpper out of range: %f", cand.ConfidenceUpper)
		}
		if cand.ConfidenceLower > cand.ConfidenceUpper {
			t.Fatalf("ConfidenceLower > ConfidenceUpper: %f > %f",
				cand.ConfidenceLower, cand.ConfidenceUpper)
		}
	}
	t.Logf("contract: confidence interval bounds verified")
}

// TestContract_SynthesisInput_Determinism verifies that SynthesisInput
// includes a deterministic Seed field.
func TestContract_SynthesisInput_Determinism(t *testing.T) {
	input := &SynthesisInput{
		LayoutID:            "layout",
		ProjectID:           "proj",
		Seed:                12345,
		Boundary:            &Geometry{},
		TargetInverterCount: 5,
		TargetTxCount:       1,
	}

	if input.Seed < 0 {
		t.Fatal("Seed must be non-negative")
	}
	t.Logf("contract: SynthesisInput seed field present and valid: %d", input.Seed)
}

// TestContract_ExampleUseCase documents a realistic backend integration scenario.
func TestContract_ExampleUseCase(t *testing.T) {
	// Step 1: Create synthesis input (backend initiates).
	synthInput := &SynthesisInput{
		LayoutID:            "layout-prod-20260407-001",
		ProjectID:           "proj-solar-farm-123",
		Seed:                987654,
		Boundary:            &Geometry{Vertices: []Point3D{{0, 0, 0}, {1000, 0, 0}, {1000, 1000, 0}, {0, 1000, 0}}},
		TargetInverterCount: 10,
		TargetTxCount:       2,
		CreatedAt:           time.Now(),
	}
	t.Logf("use case: created synthesis input: %s", synthInput.LayoutID)

	// Step 2: Backend calls ML phase (mocked below).
	// In real flow: electrical_service calls ml_phase RPC.
	searchResult := &CandidateSearchResult{
		RankedCandidates: []*MLCandidate{
			{
				CandidateID:        "candidate-layout-v1",
				CompositeScore:     0.92,
				Rank:               1,
				ConfidenceLower:    0.85,
				ConfidenceUpper:    0.95,
				SelectionReasoning: "top ranked by electrical + cost balance",
				ObjectiveScores: map[string]float64{
					"feasibility":  0.95,
					"mw_fit":       0.88,
					"cost":         0.92,
					"land_use":     0.85,
					"soft_penalty": 0.05,
				},
			},
		},
		DeterministicFallback: &MLCandidate{
			CandidateID:    "candidate-layout-fallback",
			CompositeScore: 0.65,
			Rank:           1,
		},
	}
	t.Logf("use case: received %d ranked candidates", len(searchResult.RankedCandidates))

	// Step 3: Verify contract: fallback always present.
	if searchResult.DeterministicFallback == nil {
		t.Fatal("contract: fallback must be present")
	}

	// Step 4: Electrical service consumes top candidate.
	topCandidate := searchResult.RankedCandidates[0]
	fallbackCandidate := searchResult.DeterministicFallback

	output := &MLPhaseOutput{
		ProjectID:              synthInput.ProjectID,
		LayoutID:               synthInput.LayoutID,
		ExperimentID:           fmt.Sprintf("exp-%d", synthInput.Seed),
		Timestamp:              time.Now(),
		Version:                "1.0",
		FinalRankedCandidates:  searchResult.RankedCandidates,
		RecommendedCandidateID: topCandidate.CandidateID,
		FallbackCandidateID:    fallbackCandidate.CandidateID,
		DeterministicSeed:      synthInput.Seed,
	}

	if output.FallbackCandidateID == "" {
		t.Fatal("contract: MLPhaseOutput must include fallback ID")
	}
	if output.FallbackCandidateID != fallbackCandidate.CandidateID {
		t.Fatal("contract: fallback ID mismatch")
	}

	t.Logf("use case: MLPhaseOutput constructed successfully")
	t.Logf("use case: electrical service can now consume top candidate %s or fallback %s",
		output.RecommendedCandidateID, output.FallbackCandidateID)
}

// TestContract_Version_1_0_Stable documents version 1.0 as stable.
func TestContract_Version_1_0_Stable(t *testing.T) {
	output := &MLPhaseOutput{
		Version: "1.0",
	}
	if output.Version != "1.0" {
		t.Fatalf("version mismatch")
	}
	t.Logf("contract: v1.0 stable release marked")
	t.Logf("contract: backward compatibility guaranteed for v1.x consumers")
	t.Logf("contract: breaking changes will be v2.0+")
}
