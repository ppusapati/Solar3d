package ml_inference

import "testing"

// ── helpers ───────────────────────────────────────────────────────────────────

func makeSearchResult(candidates []*MLCandidate, fallback *MLCandidate) *CandidateSearchResult {
	return &CandidateSearchResult{
		RankedCandidates:      candidates,
		ParetoFrontCandidates: candidates,
		DeterministicFallback: fallback,
		Metadata: &CandidateSearchMetadata{
			FallbackCandidateID: func() string {
				if fallback != nil {
					return fallback.CandidateID
				}
				return ""
			}(),
		},
	}
}

func makeMLCandidate(id string, feasibility, mwFit, cost, landUse, softPenalty, composite float64) *MLCandidate {
	return &MLCandidate{
		CandidateID:    id,
		ArtifactGraph:  &CandidateArtifactGraph{LayoutID: id},
		CompositeScore: composite,
		ObjectiveScores: map[string]float64{
			"feasibility":  feasibility,
			"mw_fit":       mwFit,
			"cost":         cost,
			"land_use":     landUse,
			"soft_penalty": softPenalty,
		},
		Rank: 1,
	}
}

// ── ML disabled: pass-through tests ──────────────────────────────────────────

func TestMLRanker_Disabled_PassThrough(t *testing.T) {
	cfg := &MLRankingConfig{Enabled: false, ModelVersion: "stub-v1", ConfidenceAlpha: 0.05}
	ranker := NewMLRanker(cfg)

	c1 := makeMLCandidate("c1", 0.9, 0.8, 0.7, 0.6, 0.1, 0.8)
	c2 := makeMLCandidate("c2", 0.7, 0.6, 0.5, 0.4, 0.2, 0.6)
	fb := makeMLCandidate("fb", 0.5, 0.5, 0.5, 0.5, 0.0, 0.5)

	result, err := ranker.Rank(makeSearchResult([]*MLCandidate{c1, c2}, fb))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if result.MLEnabled {
		t.Fatal("expected MLEnabled=false for disabled config")
	}
	if len(result.FinalRankedCandidates) != 2 {
		t.Fatalf("expected 2 pass-through candidates, got %d", len(result.FinalRankedCandidates))
	}
	// Pass-through preserves original order.
	if result.FinalRankedCandidates[0].CandidateID != "c1" {
		t.Fatalf("expected c1 first in pass-through, got %s", result.FinalRankedCandidates[0].CandidateID)
	}
	if result.FallbackCandidateID != "fb" {
		t.Fatalf("expected fallback ID 'fb', got %s", result.FallbackCandidateID)
	}
	if result.RecommendedCandidateID != "c1" {
		t.Fatalf("expected recommended=c1, got %s", result.RecommendedCandidateID)
	}
}

func TestMLRanker_Disabled_EmptyCandidates_FallbackRecommended(t *testing.T) {
	cfg := &MLRankingConfig{Enabled: false, ModelVersion: "stub-v1", ConfidenceAlpha: 0.05}
	ranker := NewMLRanker(cfg)

	fb := makeMLCandidate("fb-only", 0.8, 0.7, 0.6, 0.5, 0.0, 0.7)
	result, err := ranker.Rank(makeSearchResult([]*MLCandidate{}, fb))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if result.RecommendedCandidateID != "fb-only" {
		t.Fatalf("expected fallback ID as recommended, got %s", result.RecommendedCandidateID)
	}
}

// ── ML enabled: re-ranking tests ─────────────────────────────────────────────

func TestMLRanker_Enabled_ReranksHigherFeasibilityFirst(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())

	// c1 is deliberately placed second (lower scores) but c2 has higher scores;
	// after ML ranking c2 should be recommended.
	c1 := makeMLCandidate("c1", 0.3, 0.3, 0.3, 0.3, 0.5, 0.3) // poor
	c2 := makeMLCandidate("c2", 0.9, 0.9, 0.9, 0.9, 0.0, 0.9) // excellent
	fb := makeMLCandidate("fb", 0.5, 0.5, 0.5, 0.5, 0.0, 0.5)

	// Feed c1 first (worse) to confirm ML re-ranks.
	result, err := ranker.Rank(makeSearchResult([]*MLCandidate{c1, c2}, fb))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !result.MLEnabled {
		t.Fatal("expected MLEnabled=true")
	}
	if result.RecommendedCandidateID != "c2" {
		t.Fatalf("expected c2 recommended (higher scores), got %s", result.RecommendedCandidateID)
	}
	if result.FinalRankedCandidates[0].CandidateID != "c2" {
		t.Fatalf("expected c2 at rank 1, got %s", result.FinalRankedCandidates[0].CandidateID)
	}
}

func TestMLRanker_Enabled_FallbackIDAlwaysPresent(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())

	c1 := makeMLCandidate("c1", 0.8, 0.7, 0.6, 0.5, 0.1, 0.7)
	fb := makeMLCandidate("fb-deterministic", 0.6, 0.6, 0.6, 0.6, 0.0, 0.6)

	result, err := ranker.Rank(makeSearchResult([]*MLCandidate{c1}, fb))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if result.FallbackCandidateID != "fb-deterministic" {
		t.Fatalf("fallback ID must always be present; got %s", result.FallbackCandidateID)
	}
}

func TestMLRanker_Enabled_EmptyCandidates_ReturnsFallbackWithoutFailure(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())

	fb := makeMLCandidate("fb-safe", 0.7, 0.7, 0.7, 0.7, 0.0, 0.7)
	result, err := ranker.Rank(makeSearchResult([]*MLCandidate{}, fb))
	if err != nil {
		t.Fatalf("should not fail with empty candidates: %v", err)
	}
	if len(result.FinalRankedCandidates) != 1 {
		t.Fatalf("expected 1 candidate (fallback), got %d", len(result.FinalRankedCandidates))
	}
	if result.FinalRankedCandidates[0].CandidateID != "fb-safe" {
		t.Fatalf("expected fallback candidate in result, got %s", result.FinalRankedCandidates[0].CandidateID)
	}
	if result.RecommendedCandidateID != "fb-safe" {
		t.Fatalf("expected fallback as recommended, got %s", result.RecommendedCandidateID)
	}
}

func TestMLRanker_Enabled_NilResult_ReturnsError(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())
	_, err := ranker.Rank(nil)
	if err == nil {
		t.Fatal("expected error for nil result")
	}
}

// ── Confidence interval tests ─────────────────────────────────────────────────

func TestMLRanker_ConfidenceIntervals_WithinBounds(t *testing.T) {
	cfg := DefaultMLRankingConfig()
	cfg.ConfidenceAlpha = 0.10
	ranker := NewMLRanker(cfg)

	c1 := makeMLCandidate("c1", 0.8, 0.7, 0.6, 0.5, 0.1, 0.7)
	fb := makeMLCandidate("fb", 0.5, 0.5, 0.5, 0.5, 0.0, 0.5)

	result, err := ranker.Rank(makeSearchResult([]*MLCandidate{c1}, fb))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	for _, c := range result.FinalRankedCandidates {
		if c.ConfidenceLower < 0 || c.ConfidenceLower > 1 {
			t.Fatalf("ConfidenceLower out of [0,1]: %f", c.ConfidenceLower)
		}
		if c.ConfidenceUpper < 0 || c.ConfidenceUpper > 1 {
			t.Fatalf("ConfidenceUpper out of [0,1]: %f", c.ConfidenceUpper)
		}
		if c.ConfidenceLower > c.ConfidenceUpper {
			t.Fatalf("ConfidenceLower > ConfidenceUpper: %f > %f", c.ConfidenceLower, c.ConfidenceUpper)
		}
	}
}

// ── Determinism test ──────────────────────────────────────────────────────────

func TestMLRanker_Deterministic_SameInputSameRanking(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())

	c1 := makeMLCandidate("c-alpha", 0.7, 0.6, 0.8, 0.5, 0.1, 0.65)
	c2 := makeMLCandidate("c-beta", 0.6, 0.8, 0.7, 0.6, 0.2, 0.70)
	c3 := makeMLCandidate("c-gamma", 0.9, 0.5, 0.6, 0.7, 0.0, 0.60)
	fb := makeMLCandidate("fb", 0.5, 0.5, 0.5, 0.5, 0.0, 0.5)

	r1, _ := ranker.Rank(makeSearchResult([]*MLCandidate{c1, c2, c3}, fb))
	r2, _ := ranker.Rank(makeSearchResult([]*MLCandidate{c1, c2, c3}, fb))

	if len(r1.FinalRankedCandidates) != len(r2.FinalRankedCandidates) {
		t.Fatal("ranked counts differ across runs")
	}
	for i := range r1.FinalRankedCandidates {
		if r1.FinalRankedCandidates[i].CandidateID != r2.FinalRankedCandidates[i].CandidateID {
			t.Fatalf("non-deterministic ranking at position %d", i)
		}
	}
}

// ── Feature extraction tests ──────────────────────────────────────────────────

func TestMLRanker_FeatureExtraction_ElectricalAbsent_DefaultsToOne(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())

	// No "electrical_penalty" key in ObjectiveScores.
	c := makeMLCandidate("c1", 0.8, 0.7, 0.6, 0.5, 0.1, 0.7)
	fv := ranker.extractFeatures(c)

	if fv.ElectricalFeasibility != 1.0 {
		t.Fatalf("expected ElectricalFeasibility=1.0 when no electrical layer, got %f", fv.ElectricalFeasibility)
	}
}

func TestMLRanker_FeatureExtraction_ElectricalPenaltyPresent(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())

	c := makeMLCandidate("c1", 0.8, 0.7, 0.6, 0.5, 0.1, 0.7)
	c.ObjectiveScores["electrical_penalty"] = 0.4

	fv := ranker.extractFeatures(c)
	expected := 0.6
	if fv.ElectricalFeasibility < expected-0.001 || fv.ElectricalFeasibility > expected+0.001 {
		t.Fatalf("expected ElectricalFeasibility≈0.6, got %f", fv.ElectricalFeasibility)
	}
}

// ── Weight normalisation test ─────────────────────────────────────────────────

func TestNormaliseWeights_SumsToOne(t *testing.T) {
	w := MLFeatureWeights{
		Feasibility:       3,
		MwFit:             2.5,
		CostEfficiency:    2,
		LandUseEfficiency: 1,
		SoftPenalty:       0.5,
		ElectricalScore:   0.5,
		CompositeScore:    0.5,
	}
	nw := normaliseWeights(w)
	total := nw.Feasibility + nw.MwFit + nw.CostEfficiency + nw.LandUseEfficiency +
		nw.SoftPenalty + nw.ElectricalScore + nw.CompositeScore
	if total < 0.999 || total > 1.001 {
		t.Fatalf("normalised weights do not sum to 1: got %f", total)
	}
}

func TestNormaliseWeights_ZeroInput_Unchanged(t *testing.T) {
	w := MLFeatureWeights{}
	nw := normaliseWeights(w)
	if nw.Feasibility != 0 {
		t.Fatal("zero weights should be returned unchanged")
	}
}

// ── Rank assignment test ──────────────────────────────────────────────────────

func TestMLRanker_RankAssignment_SequentialFromOne(t *testing.T) {
	ranker := NewMLRanker(DefaultMLRankingConfig())

	c1 := makeMLCandidate("c1", 0.9, 0.8, 0.7, 0.6, 0.0, 0.8)
	c2 := makeMLCandidate("c2", 0.5, 0.5, 0.5, 0.5, 0.3, 0.4)
	c3 := makeMLCandidate("c3", 0.7, 0.6, 0.6, 0.5, 0.1, 0.6)
	fb := makeMLCandidate("fb", 0.4, 0.4, 0.4, 0.4, 0.0, 0.4)

	result, err := ranker.Rank(makeSearchResult([]*MLCandidate{c1, c2, c3}, fb))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	for i, c := range result.FinalRankedCandidates {
		if int(c.Rank) != i+1 {
			t.Fatalf("expected rank %d at position %d, got %d", i+1, i, c.Rank)
		}
	}
}
