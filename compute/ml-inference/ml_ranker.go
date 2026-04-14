// Package ml_inference — Task 10: ML ranking layer on top of candidate set.
//
// This file implements the MLRanker, which applies a feature-based ML proxy
// score on top of the candidate set produced by the Candidate Search + Scoring
// layers (Tasks 7-9).
//
// Two operating modes are supported:
//
//	ML enabled  – features are extracted per candidate, a weighted dot product
//	              is used as a proxy for model inference, and candidates are
//	              re-ranked by this ML proxy score with updated confidence
//	              intervals.  This is a stub that can be replaced by a real
//	              model call without changing the API contract.
//
//	ML disabled – Rank() is a deterministic pass-through: the optimizer ranking
//	              from CandidateSearchResult is returned unchanged.  The
//	              deterministic fallback candidate ID is always present in the
//	              result so downstream consumers always have a safe pick.
//
// Plan requirement (§Step 10): "If ML disabled, system still returns
// deterministic + optimization result without failure."
package ml_inference

import (
	"fmt"
	"sort"
)

// ========== Config ==========

// MLRankingConfig configures the ML ranking layer.
// Set Enabled = false to bypass ML re-ranking; the system will always return
// the deterministic search result unchanged.
type MLRankingConfig struct {
	// Enabled gates ML re-ranking.  When false, Rank() is a pass-through.
	Enabled bool

	// ModelVersion is embedded in every MLRankResult for audit traceability.
	ModelVersion string

	// FeatureWeights controls the importance of each scoring dimension.
	FeatureWeights MLFeatureWeights

	// ConfidenceAlpha is the half-width of the confidence interval applied to
	// the ML proxy score.  Default 0.05.
	ConfidenceAlpha float64
}

// MLFeatureWeights is the weight vector applied to each scoring dimension.
// At runtime the weights are normalised so they sum to 1.
type MLFeatureWeights struct {
	Feasibility       float64 // O1 feasibility
	MwFit             float64 // O2 capacity fit
	CostEfficiency    float64 // O3 cost score
	LandUseEfficiency float64 // O4 land-use score
	SoftPenalty       float64 // inverted soft-penalty (1 − S)
	ElectricalScore   float64 // 1 − electrical_penalty (from Task 9, if present)
	CompositeScore    float64 // base composite from scoring engine
}

// DefaultMLRankingConfig returns sensible defaults with ML enabled.
func DefaultMLRankingConfig() *MLRankingConfig {
	return &MLRankingConfig{
		Enabled:      true,
		ModelVersion: "stub-v1",
		FeatureWeights: MLFeatureWeights{
			Feasibility:       0.30,
			MwFit:             0.25,
			CostEfficiency:    0.20,
			LandUseEfficiency: 0.10,
			SoftPenalty:       0.05,
			ElectricalScore:   0.05,
			CompositeScore:    0.05,
		},
		ConfidenceAlpha: 0.05,
	}
}

// ========== Feature vector ==========

// MLFeatureVector is the per-candidate feature set consumed by the ranking proxy.
type MLFeatureVector struct {
	CandidateID           string
	Feasibility           float64
	MwFit                 float64
	CostEfficiency        float64
	LandUseEfficiency     float64
	SoftPenaltyInverted   float64 // 1 - soft_penalty
	ElectricalFeasibility float64 // 1 - electrical_penalty; 1.0 when layer absent
	CompositeScore        float64
	MLProxyScore          float64 // weighted dot product — set by Rank()
}

// ========== Result ==========

// MLRankResult is the output of the ML ranking layer.
type MLRankResult struct {
	// FinalRankedCandidates is the ML-re-ranked (or pass-through) candidate list.
	// The deterministic fallback is always reachable via FallbackCandidateID.
	FinalRankedCandidates []*MLCandidate

	// RecommendedCandidateID is the top-ranked candidate's ID.
	RecommendedCandidateID string

	// FallbackCandidateID is always set to the deterministic fallback ID so
	// downstream consumers always have a safe pick when ML confidence is low.
	FallbackCandidateID string

	// MLEnabled reflects whether ML re-ranking was performed.
	MLEnabled bool

	// ModelVersion is the embedded model version string from config.
	ModelVersion string

	// FeatureExtractedCount is the number of candidates for which features
	// were extracted (0 when ML is disabled).
	FeatureExtractedCount int

	// RankingReasoning is a human-readable description of the strategy used.
	RankingReasoning string
}

// ========== Ranker ==========

// MLRanker is the Task 10 ML ranking layer.
// It wraps a CandidateSearchResult and re-ranks candidates using a
// feature-based ML proxy score.  When Enabled=false it is a deterministic
// pass-through that preserves the optimizer ranking.
type MLRanker struct {
	config *MLRankingConfig
}

// NewMLRanker creates an MLRanker.  If config is nil, DefaultMLRankingConfig is used.
func NewMLRanker(config *MLRankingConfig) *MLRanker {
	if config == nil {
		config = DefaultMLRankingConfig()
	}
	if config.ConfidenceAlpha <= 0 {
		config.ConfidenceAlpha = 0.05
	}
	if config.ModelVersion == "" {
		config.ModelVersion = "stub-v1"
	}
	return &MLRanker{config: config}
}

// Rank applies ML re-ranking (or pass-through) to a CandidateSearchResult.
//
// Contract: always succeeds when result is non-nil, even when ML is disabled
// or when the candidate list is empty.
func (r *MLRanker) Rank(result *CandidateSearchResult) (*MLRankResult, error) {
	if result == nil {
		return nil, fmt.Errorf("candidate search result is required")
	}

	fallbackID := ""
	if result.DeterministicFallback != nil {
		fallbackID = result.DeterministicFallback.CandidateID
	}

	// ── ML disabled: pass through optimizer ranking unchanged ──────────────
	if !r.config.Enabled {
		topID := fallbackID
		if len(result.RankedCandidates) > 0 {
			topID = result.RankedCandidates[0].CandidateID
		}
		return &MLRankResult{
			FinalRankedCandidates:  result.RankedCandidates,
			RecommendedCandidateID: topID,
			FallbackCandidateID:    fallbackID,
			MLEnabled:              false,
			ModelVersion:           r.config.ModelVersion,
			RankingReasoning:       "ml_disabled: optimizer lexicographic ranking preserved",
		}, nil
	}

	// ── ML enabled: empty candidate list ───────────────────────────────────
	// Return the deterministic fallback alone without failure (plan §Step 10).
	if len(result.RankedCandidates) == 0 {
		var ranked []*MLCandidate
		if result.DeterministicFallback != nil {
			fb := *result.DeterministicFallback
			fb.Rank = 1
			fb.SelectionReasoning = "ml_ranking: no optimizer candidates; deterministic fallback selected"
			ranked = []*MLCandidate{&fb}
		}
		return &MLRankResult{
			FinalRankedCandidates:  ranked,
			RecommendedCandidateID: fallbackID,
			FallbackCandidateID:    fallbackID,
			MLEnabled:              true,
			ModelVersion:           r.config.ModelVersion,
			RankingReasoning:       "ml_ranking: empty input; deterministic fallback returned",
		}, nil
	}

	// ── ML enabled: feature extraction + proxy scoring ──────────────────────
	w := normaliseWeights(r.config.FeatureWeights)

	type annotated struct {
		candidate *MLCandidate
		fv        *MLFeatureVector
	}
	items := make([]*annotated, 0, len(result.RankedCandidates))
	for _, c := range result.RankedCandidates {
		fv := r.extractFeatures(c)
		fv.MLProxyScore = dotProduct(fv, w)
		items = append(items, &annotated{candidate: c, fv: fv})
	}

	// Stable sort: ML proxy score desc; CandidateID asc as deterministic tie-break.
	sort.SliceStable(items, func(i, j int) bool {
		si := items[i].fv.MLProxyScore
		sj := items[j].fv.MLProxyScore
		if si != sj {
			return si > sj
		}
		return items[i].candidate.CandidateID < items[j].candidate.CandidateID
	})

	alpha := r.config.ConfidenceAlpha
	ranked := make([]*MLCandidate, 0, len(items))
	for rank, item := range items {
		fv := item.fv
		c := item.candidate
		ranked = append(ranked, &MLCandidate{
			CandidateID:     c.CandidateID,
			ArtifactGraph:   c.ArtifactGraph,
			ObjectiveScores: c.ObjectiveScores,
			CompositeScore:  fv.MLProxyScore,
			Rank:            int32(rank + 1),
			ConfidenceLower: clamp01(fv.MLProxyScore - alpha),
			ConfidenceUpper: clamp01(fv.MLProxyScore + alpha),
			SelectionReasoning: fmt.Sprintf(
				"ml_proxy_score=%.4f feasibility=%.2f mw_fit=%.2f elec_feasibility=%.2f",
				fv.MLProxyScore, fv.Feasibility, fv.MwFit, fv.ElectricalFeasibility,
			),
			ParentCandidateIDs:    c.ParentCandidateIDs,
			OptimizationAlgorithm: r.config.ModelVersion,
			CreatedAt:             c.CreatedAt,
		})
	}

	return &MLRankResult{
		FinalRankedCandidates:  ranked,
		RecommendedCandidateID: ranked[0].CandidateID,
		FallbackCandidateID:    fallbackID,
		MLEnabled:              true,
		ModelVersion:           r.config.ModelVersion,
		FeatureExtractedCount:  len(items),
		RankingReasoning: fmt.Sprintf(
			"ml_proxy_v1: %d candidates re-ranked by weighted feature score",
			len(ranked),
		),
	}, nil
}

// extractFeatures builds an MLFeatureVector from a scored MLCandidate.
func (r *MLRanker) extractFeatures(c *MLCandidate) *MLFeatureVector {
	get := func(k string) float64 {
		if v, ok := c.ObjectiveScores[k]; ok {
			return v
		}
		return 0
	}

	softPenalty := get("soft_penalty")
	elecPenalty, hasElec := c.ObjectiveScores["electrical_penalty"]
	elecFeasibility := 1.0
	if hasElec {
		elecFeasibility = clamp01(1.0 - elecPenalty)
	}

	return &MLFeatureVector{
		CandidateID:           c.CandidateID,
		Feasibility:           get("feasibility"),
		MwFit:                 get("mw_fit"),
		CostEfficiency:        get("cost"),
		LandUseEfficiency:     get("land_use"),
		SoftPenaltyInverted:   clamp01(1.0 - softPenalty),
		ElectricalFeasibility: elecFeasibility,
		CompositeScore:        c.CompositeScore,
	}
}

// ========== Helpers ==========

// normaliseWeights normalises an MLFeatureWeights struct so components sum to 1.
// Returns the original weights unchanged when the sum is zero (degenerate).
func normaliseWeights(w MLFeatureWeights) MLFeatureWeights {
	total := w.Feasibility + w.MwFit + w.CostEfficiency + w.LandUseEfficiency +
		w.SoftPenalty + w.ElectricalScore + w.CompositeScore
	if total <= 0 {
		return w
	}
	return MLFeatureWeights{
		Feasibility:       w.Feasibility / total,
		MwFit:             w.MwFit / total,
		CostEfficiency:    w.CostEfficiency / total,
		LandUseEfficiency: w.LandUseEfficiency / total,
		SoftPenalty:       w.SoftPenalty / total,
		ElectricalScore:   w.ElectricalScore / total,
		CompositeScore:    w.CompositeScore / total,
	}
}

// dotProduct computes the weighted feature score for a candidate.
func dotProduct(fv *MLFeatureVector, w MLFeatureWeights) float64 {
	return clamp01(
		w.Feasibility*fv.Feasibility +
			w.MwFit*fv.MwFit +
			w.CostEfficiency*fv.CostEfficiency +
			w.LandUseEfficiency*fv.LandUseEfficiency +
			w.SoftPenalty*fv.SoftPenaltyInverted +
			w.ElectricalScore*fv.ElectricalFeasibility +
			w.CompositeScore*fv.CompositeScore,
	)
}
