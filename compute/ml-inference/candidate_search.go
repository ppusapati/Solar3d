package ml_inference

import "fmt"

// CandidateSearchConfig defines deterministic search parameters for candidate generation.
type CandidateSearchConfig struct {
	BaseInput                    *SynthesisInput
	HardConstraints              *HardConstraintSet
	ScoringEngine                *ScoringEngine
	VariantCount                 int
	IncludeDeterministicFallback bool
	MaxParetoCandidates          int
}

// CandidateSearchMetadata captures reproducibility and execution context.
type CandidateSearchMetadata struct {
	SearchSeed               int64
	VariantCount             int
	FeasibleCandidateCount   int
	InfeasibleCandidateCount int
	ParetoCandidateCount     int
	FallbackCandidateID      string
}

// CandidateSearchResult contains ranked candidates, Pareto front, and deterministic fallback candidate.
type CandidateSearchResult struct {
	RankedCandidates      []*MLCandidate
	ParetoFrontCandidates []*MLCandidate
	DeterministicFallback *MLCandidate
	Metadata              *CandidateSearchMetadata
}

// CandidateSearchExecutor performs deterministic candidate synthesis, scoring, and Pareto filtering.
type CandidateSearchExecutor struct {
	config *CandidateSearchConfig
}

// NewCandidateSearchExecutor creates a search executor for Task 8.
func NewCandidateSearchExecutor(config *CandidateSearchConfig) (*CandidateSearchExecutor, error) {
	if config == nil {
		return nil, fmt.Errorf("candidate search config is required")
	}
	if config.BaseInput == nil {
		return nil, fmt.Errorf("base synthesis input is required")
	}
	if config.ScoringEngine == nil {
		return nil, fmt.Errorf("scoring engine is required")
	}
	if config.VariantCount <= 0 {
		config.VariantCount = 5
	}
	if config.MaxParetoCandidates <= 0 {
		config.MaxParetoCandidates = config.VariantCount + 1
	}
	if config.HardConstraints == nil {
		config.HardConstraints = NewHardConstraintSet()
	}
	return &CandidateSearchExecutor{config: config}, nil
}

// Execute generates a deterministic candidate set with ranking metadata and Pareto frontier.
func (cse *CandidateSearchExecutor) Execute() (*CandidateSearchResult, error) {
	fallbackInput := cloneSynthesisInput(cse.config.BaseInput)
	fallbackInput.LayoutID = fmt.Sprintf("%s-fallback", cse.config.BaseInput.LayoutID)
	fallbackGraph, err := SynthesizeInfrastructure(fallbackInput, cse.config.HardConstraints)
	if err != nil {
		return nil, fmt.Errorf("fallback synthesis failed: %w", err)
	}
	fallbackCandidate, err := cse.buildCandidate(fallbackGraph, 0, "deterministic fallback candidate")
	if err != nil {
		return nil, err
	}

	rankedInputGraphs := make([]*CandidateArtifactGraph, 0, cse.config.VariantCount+1)
	if cse.config.IncludeDeterministicFallback {
		rankedInputGraphs = append(rankedInputGraphs, fallbackGraph)
	}

	infeasibleCount := 0
	for i := 0; i < cse.config.VariantCount; i++ {
		variantInput := deriveVariantInput(cse.config.BaseInput, i)
		graph, err := SynthesizeInfrastructure(variantInput, cse.config.HardConstraints)
		if err != nil {
			infeasibleCount++
			continue
		}
		rankedInputGraphs = append(rankedInputGraphs, graph)
	}

	if len(rankedInputGraphs) == 0 {
		return nil, fmt.Errorf("candidate search produced no feasible candidates")
	}

	rankedCandidates, err := cse.config.ScoringEngine.RankCandidates(rankedInputGraphs)
	if err != nil {
		return nil, err
	}

	for i, candidate := range rankedCandidates {
		candidate.ParentCandidateIDs = []string{cse.config.BaseInput.LayoutID}
		candidate.SelectionReasoning = fmt.Sprintf("candidate %d ranked from deterministic search variant set", i+1)
		candidate.ConfidenceLower = candidate.CompositeScore * 0.95
		candidate.ConfidenceUpper = candidate.CompositeScore
	}

	pareto := SelectParetoFront(rankedCandidates)
	if len(pareto) > cse.config.MaxParetoCandidates {
		pareto = pareto[:cse.config.MaxParetoCandidates]
	}

	result := &CandidateSearchResult{
		RankedCandidates:      rankedCandidates,
		ParetoFrontCandidates: pareto,
		DeterministicFallback: fallbackCandidate,
		Metadata: &CandidateSearchMetadata{
			SearchSeed:               cse.config.BaseInput.Seed,
			VariantCount:             cse.config.VariantCount,
			FeasibleCandidateCount:   len(rankedCandidates),
			InfeasibleCandidateCount: infeasibleCount,
			ParetoCandidateCount:     len(pareto),
			FallbackCandidateID:      fallbackCandidate.CandidateID,
		},
	}

	return result, nil
}

func (cse *CandidateSearchExecutor) buildCandidate(graph *CandidateArtifactGraph, rank int32, reason string) (*MLCandidate, error) {
	breakdown, err := cse.config.ScoringEngine.ScoreCandidate(graph)
	if err != nil {
		return nil, err
	}
	return &MLCandidate{
		CandidateID:   fmt.Sprintf("candidate-%s", graph.LayoutID),
		ArtifactGraph: graph,
		ObjectiveScores: map[string]float64{
			"feasibility":  breakdown.FeasibilityScore,
			"mw_fit":       breakdown.MwFitScore,
			"cost":         breakdown.CostScore,
			"land_use":     breakdown.LandUseScore,
			"soft_penalty": breakdown.SoftPenalty,
		},
		CompositeScore:        breakdown.CompositeScore,
		Rank:                  rank,
		SelectionReasoning:    reason,
		OptimizationAlgorithm: "candidate_search_v1",
	}, nil
}

// SelectParetoFront filters ranked candidates down to non-dominated candidates.
func SelectParetoFront(candidates []*MLCandidate) []*MLCandidate {
	if len(candidates) == 0 {
		return nil
	}
	front := make([]*MLCandidate, 0, len(candidates))
	for i, candidate := range candidates {
		dominated := false
		for j, other := range candidates {
			if i == j {
				continue
			}
			if dominates(other, candidate) {
				dominated = true
				break
			}
		}
		if !dominated {
			front = append(front, candidate)
		}
	}
	return front
}

func dominates(a, b *MLCandidate) bool {
	metrics := []string{"feasibility", "mw_fit", "cost", "land_use"}
	strictlyBetter := false
	for _, metric := range metrics {
		av := a.ObjectiveScores[metric]
		bv := b.ObjectiveScores[metric]
		if av < bv {
			return false
		}
		if av > bv {
			strictlyBetter = true
		}
	}
	return strictlyBetter
}

func deriveVariantInput(base *SynthesisInput, idx int) *SynthesisInput {
	variant := cloneSynthesisInput(base)
	variant.Seed = base.Seed + int64(idx+1)
	variant.LayoutID = fmt.Sprintf("%s-v%02d", base.LayoutID, idx+1)
	if base.TargetInverterCount <= 0 {
		variant.TargetInverterCount = 2 + (idx % 3)
	} else {
		variant.TargetInverterCount = base.TargetInverterCount + (idx % 2)
	}
	if base.TargetTxCount <= 0 {
		variant.TargetTxCount = 1 + (idx % 2)
	} else {
		variant.TargetTxCount = base.TargetTxCount + ((idx + 1) % 2)
	}
	return variant
}

func cloneSynthesisInput(input *SynthesisInput) *SynthesisInput {
	if input == nil {
		return nil
	}
	clone := *input
	boundaryVertices := make([]Point3D, len(input.Boundary.Vertices))
	copy(boundaryVertices, input.Boundary.Vertices)
	clone.Boundary = Geometry{
		Vertices:        boundaryVertices,
		ElevationSource: input.Boundary.ElevationSource,
		DatumOffsetM:    input.Boundary.DatumOffsetM,
	}
	if input.DEM != nil {
		demClone := &DEMGrid{Rows: input.DEM.Rows, Cols: input.DEM.Cols, CellSizeM: input.DEM.CellSizeM}
		demClone.ValuesM = make([][]float64, len(input.DEM.ValuesM))
		for i := range input.DEM.ValuesM {
			demClone.ValuesM[i] = make([]float64, len(input.DEM.ValuesM[i]))
			copy(demClone.ValuesM[i], input.DEM.ValuesM[i])
		}
		clone.DEM = demClone
	}
	return &clone
}
