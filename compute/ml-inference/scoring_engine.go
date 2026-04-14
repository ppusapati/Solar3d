package ml_inference

import (
	"fmt"
	"sort"
)

// ScoreBreakdown captures per-objective normalized scores and weighted result.
type ScoreBreakdown struct {
	FeasibilityScore float64
	MwFitScore       float64
	CostScore        float64
	LandUseScore     float64
	SoftPenalty      float64
	CompositeScore   float64
}

// ScoringEngine computes multi-objective scores for candidate graphs.
type ScoringEngine struct {
	Objectives       *ObjectiveSet
	HardConstraints  *HardConstraintSet
	SoftConstraints  *SoftConstraintSet
	CapacityTargetMw float64
	SiteAreaM2       float64
}

// NewScoringEngine creates a scoring engine for Task 7 objective evaluation.
func NewScoringEngine(
	capacityTargetMw float64,
	siteAreaM2 float64,
	hard *HardConstraintSet,
	soft *SoftConstraintSet,
) *ScoringEngine {
	if hard == nil {
		hard = NewHardConstraintSet()
	}
	if soft == nil {
		soft = NewSoftConstraintSet(nil)
	}
	return &ScoringEngine{
		Objectives:       NewObjectiveSet(capacityTargetMw),
		HardConstraints:  hard,
		SoftConstraints:  soft,
		CapacityTargetMw: capacityTargetMw,
		SiteAreaM2:       siteAreaM2,
	}
}

// ScoreCandidate computes normalized objective scores and a composite score in [0,1].
func (se *ScoringEngine) ScoreCandidate(g *CandidateArtifactGraph) (*ScoreBreakdown, error) {
	if g == nil {
		return nil, fmt.Errorf("candidate graph is required")
	}

	feasibility := clamp01(ComputeFeasibilityScore(g, se.HardConstraints))

	mwInstalled := ComputeTotalCapacity(g)
	mwFit := 0.0
	if se.CapacityTargetMw > 0 {
		mwFit = clamp01(mwInstalled / se.CapacityTargetMw)
	}

	// Convert cost proxy to a score by inverse normalization.
	costProxy := ComputeCostProxy(g)
	costScore := 1.0 / (1.0 + costProxy)
	costScore = clamp01(costScore)

	landUse := ComputeLandUtilization(g, se.SiteAreaM2)
	landUseScore := clamp01(landUse / 0.35)

	softPenalty := 0.0
	for _, sc := range se.SoftConstraints.AllConstraints {
		softPenalty += sc.Weight * sc.ComputePenalty(g)
	}
	softPenalty = clamp01(softPenalty)

	weighted :=
		se.Objectives.MaximizeFeasibility.Weight*feasibility +
			se.Objectives.MaximizeMwFit.Weight*mwFit +
			se.Objectives.MinimizeCost.Weight*costScore +
			se.Objectives.MaximizeLandUtilization.Weight*landUseScore

	composite := weighted * (1.0 - 0.25*softPenalty)
	composite = clamp01(composite)

	return &ScoreBreakdown{
		FeasibilityScore: feasibility,
		MwFitScore:       mwFit,
		CostScore:        costScore,
		LandUseScore:     landUseScore,
		SoftPenalty:      softPenalty,
		CompositeScore:   composite,
	}, nil
}

// RankCandidates scores and deterministically ranks candidates by lexicographic policy.
func (se *ScoringEngine) RankCandidates(candidates []*CandidateArtifactGraph) ([]*MLCandidate, error) {
	if len(candidates) == 0 {
		return nil, fmt.Errorf("at least one candidate is required")
	}

	type scoredCandidate struct {
		graph     *CandidateArtifactGraph
		breakdown *ScoreBreakdown
	}

	scored := make([]*scoredCandidate, 0, len(candidates))
	for _, g := range candidates {
		bd, err := se.ScoreCandidate(g)
		if err != nil {
			return nil, err
		}
		scored = append(scored, &scoredCandidate{graph: g, breakdown: bd})
	}

	// Deterministic ordering with stable tie-break on LayoutID.
	sort.SliceStable(scored, func(i, j int) bool {
		li := scored[i]
		lj := scored[j]

		if li.breakdown.FeasibilityScore != lj.breakdown.FeasibilityScore {
			return li.breakdown.FeasibilityScore > lj.breakdown.FeasibilityScore
		}
		if li.breakdown.MwFitScore != lj.breakdown.MwFitScore {
			return li.breakdown.MwFitScore > lj.breakdown.MwFitScore
		}
		if li.breakdown.CostScore != lj.breakdown.CostScore {
			return li.breakdown.CostScore > lj.breakdown.CostScore
		}
		if li.breakdown.LandUseScore != lj.breakdown.LandUseScore {
			return li.breakdown.LandUseScore > lj.breakdown.LandUseScore
		}
		if li.breakdown.CompositeScore != lj.breakdown.CompositeScore {
			return li.breakdown.CompositeScore > lj.breakdown.CompositeScore
		}
		return li.graph.LayoutID < lj.graph.LayoutID
	})

	results := make([]*MLCandidate, 0, len(scored))
	for i, item := range scored {
		scoreMap := map[string]float64{
			"feasibility":  item.breakdown.FeasibilityScore,
			"mw_fit":       item.breakdown.MwFitScore,
			"cost":         item.breakdown.CostScore,
			"land_use":     item.breakdown.LandUseScore,
			"soft_penalty": item.breakdown.SoftPenalty,
		}
		results = append(results, &MLCandidate{
			CandidateID:           fmt.Sprintf("candidate-%s", item.graph.LayoutID),
			ArtifactGraph:         item.graph,
			ObjectiveScores:       scoreMap,
			CompositeScore:        item.breakdown.CompositeScore,
			Rank:                  int32(i + 1),
			SelectionReasoning:    "ranked by lexicographic objectives (feasibility > mw_fit > cost > land_use)",
			OptimizationAlgorithm: "multi_objective_scoring_v1",
		})
	}

	return results, nil
}

func clamp01(v float64) float64 {
	if v < 0 {
		return 0
	}
	if v > 1 {
		return 1
	}
	return v
}
