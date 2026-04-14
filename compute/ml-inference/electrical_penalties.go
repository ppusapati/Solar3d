// Package ml_inference — Task 9: Electrical-aware penalties and heuristics.
//
// This file adds three penalty categories that the ScoringEngine applies
// on top of the soft-constraint layer:
//
//	E1 – Infeasible stringing / inverter assignment
//	E2 – Transformer overload risk
//	E3 – Excessive cable proxy (length × current risk)
//
// Each penalty returns a value in [0, 1] where 0 = no penalty, 1 = maximum
// violation.  Weights are tuned to align with the validation thresholds used
// by the backend electrical service so that ML candidates with high electrical
// penalties are naturally deprioritised before the backend rejects them.
package ml_inference

import "math"

// ========== Penalty type ==========

// ElectricalPenalty is a named, weighted function that scores an electrical risk
// in [0, 1].  It parallels SoftConstraint but is deliberately separate so the
// Plan's "reuse extension hierarchy" is respected: ElectricalPenalty is a new
// concern (not a clothing of the existing S1–S5 penalties) because it models
// backend-threshold alignment, not user preference.
type ElectricalPenalty struct {
	PenaltyID   string
	Name        string
	Description string
	Weight      float64                               // [0, 1]
	Metric      func(*CandidateArtifactGraph) float64 // Returns penalty [0, 1]
}

// ElectricalPenaltySet groups all three electrical penalties.
type ElectricalPenaltySet struct {
	// E1: Infeasible stringing / inverter assignment penalty.
	InfeasibleStringing *ElectricalPenalty

	// E2: Transformer overload risk penalty.
	TransformerOverloadRisk *ElectricalPenalty

	// E3: Excessive cable proxy penalty.
	ExcessiveCableProxy *ElectricalPenalty

	AllPenalties []*ElectricalPenalty
}

// NewElectricalPenaltySet constructs all three penalties with tuned thresholds.
//
// Parameters align with the backend electrical service validation thresholds
// documented in TASK_3_ML_INTERFACES.md §Constraints:
//   maxInverterGroupDcKw  – maximum DC input per inverter (kW); default 1250 kW
//   txOverloadThreshold   – fraction of KVA rating that triggers risk flag; default 0.90
//   maxCableLengthM       – cable run length above which excessive-cable risk begins; default 1500 m
func NewElectricalPenaltySet(
	maxInverterGroupDcKw float64,
	txOverloadThreshold float64,
	maxCableLengthM float64,
) *ElectricalPenaltySet {
	if maxInverterGroupDcKw <= 0 {
		maxInverterGroupDcKw = 1250.0
	}
	if txOverloadThreshold <= 0 || txOverloadThreshold > 1 {
		txOverloadThreshold = 0.90
	}
	if maxCableLengthM <= 0 {
		maxCableLengthM = 1500.0
	}

	ps := &ElectricalPenaltySet{}

	// ── E1: Infeasible stringing ─────────────────────────────────────────────
	// Fires when any inverter group exceeds its DC input rating OR when strings
	// carry voltage outside the standard MPPT window [200 V, 900 V].
	// The penalty is the fraction of inverter groups / strings that violate their
	// electrical bounds, normalised to [0, 1].
	ps.InfeasibleStringing = &ElectricalPenalty{
		PenaltyID:   "E1_InfeasibleStringing",
		Name:        "Infeasible Stringing",
		Description: "Fraction of inverter groups or strings outside electrical bounds",
		Weight:      0.40,
		Metric: func(g *CandidateArtifactGraph) float64 {
			violations := 0
			total := len(g.InverterGroups) + len(g.PanelStrings)
			if total == 0 {
				return 0
			}

			for _, inv := range g.InverterGroups {
				if inv.DcInputKw > maxInverterGroupDcKw {
					violations++
				}
				if inv.DcAcRatio < 1.1 || inv.DcAcRatio > 1.5 {
					violations++
					total++ // Count each violated property as additional unit.
				}
			}

			for _, str := range g.PanelStrings {
				if str.StringVoltageVdc < 200 || str.StringVoltageVdc > 900 {
					violations++
				}
			}

			return math.Min(1.0, float64(violations)/math.Max(1.0, float64(total)))
		},
	}

	// ── E2: Transformer overload risk ────────────────────────────────────────
	// Fires when any transformer's load utilisation approaches or exceeds the
	// overload threshold.  Uses a smooth ramp:
	//   utilisation < threshold  → penalty = 0
	//   utilisation in [threshold, 1.0] → penalty ramps 0→1
	//   utilisation > 1.0 (overloaded)  → penalty = 1
	ps.TransformerOverloadRisk = &ElectricalPenalty{
		PenaltyID:   "E2_TransformerOverloadRisk",
		Name:        "Transformer Overload Risk",
		Description: "Smooth penalty approaching transformer capacity ceiling",
		Weight:      0.35,
		Metric: func(g *CandidateArtifactGraph) float64 {
			worstPenalty := 0.0
			for _, tx := range g.TransformerNodes {
				if tx.KvaRating <= 0 {
					continue
				}
				utilisation := tx.LoadKva / tx.KvaRating
				var penalty float64
				if utilisation <= txOverloadThreshold {
					penalty = 0
				} else if utilisation >= 1.0 {
					penalty = 1.0
				} else {
					// Linear ramp over the risk band [threshold, 1.0].
					penalty = (utilisation - txOverloadThreshold) / (1.0 - txOverloadThreshold)
				}
				if penalty > worstPenalty {
					worstPenalty = penalty
				}
			}
			return worstPenalty
		},
	}

	// ── E3: Excessive cable proxy ─────────────────────────────────────────────
	// Each cable corridor beyond maxCableLengthM adds proportional penalty.
	// The aggregate penalty is the mean per-cable excess ratio capped at 1.
	//   excess_ratio = max(0, (length - maxCableLengthM) / maxCableLengthM)
	//   penalty = mean(excess_ratio per cable)
	ps.ExcessiveCableProxy = &ElectricalPenalty{
		PenaltyID:   "E3_ExcessiveCableProxy",
		Name:        "Excessive Cable Proxy",
		Description: "Mean fractional excess over maximum viable cable length",
		Weight:      0.25,
		Metric: func(g *CandidateArtifactGraph) float64 {
			if len(g.CableCorridors) == 0 {
				return 0
			}
			totalExcess := 0.0
			for _, cable := range g.CableCorridors {
				excess := math.Max(0, (cable.LengthM-maxCableLengthM)/maxCableLengthM)
				totalExcess += excess
			}
			mean := totalExcess / float64(len(g.CableCorridors))
			return math.Min(1.0, mean)
		},
	}

	ps.AllPenalties = []*ElectricalPenalty{
		ps.InfeasibleStringing,
		ps.TransformerOverloadRisk,
		ps.ExcessiveCableProxy,
	}

	return ps
}

// ComputeAggregatePenalty returns the weighted sum of all electrical penalties
// in [0, 1].  This is the value the ScoringEngine subtracts from the composite
// score via WithElectricalPenalties.
func (ps *ElectricalPenaltySet) ComputeAggregatePenalty(g *CandidateArtifactGraph) float64 {
	weightSum := 0.0
	penaltySum := 0.0
	for _, p := range ps.AllPenalties {
		penaltySum += p.Weight * p.Metric(g)
		weightSum += p.Weight
	}
	if weightSum == 0 {
		return 0
	}
	return math.Min(1.0, penaltySum/weightSum)
}

// ElectricalFeasibilityScore returns a [0, 1] score that aligns with backend
// electrical validation thresholds.  1.0 means no electrical risk detected;
// 0.0 means all penalties are at maximum.
func (ps *ElectricalPenaltySet) ElectricalFeasibilityScore(g *CandidateArtifactGraph) float64 {
	return 1.0 - ps.ComputeAggregatePenalty(g)
}

// ========== ScoringEngine extension ==========

// WithElectricalPenalties returns a new ScoringEngine that folds the electrical
// penalty set into the composite score computation.  The combined formula is:
//
//	composite = weighted_objectives × (1 − 0.25×soft_penalty) × (1 − elec_weight×elec_penalty)
//
// elec_weight defaults to 0.20, giving electrical penalties meaningful but not
// dominating influence over the final score.
func (se *ScoringEngine) WithElectricalPenalties(ps *ElectricalPenaltySet) *ScoringEngineWithElectrical {
	if ps == nil {
		ps = NewElectricalPenaltySet(0, 0, 0)
	}
	return &ScoringEngineWithElectrical{
		base:         se,
		electricalPS: ps,
		elecWeight:   0.20,
	}
}

// ScoringEngineWithElectrical wraps ScoringEngine and adds electrical penalties.
type ScoringEngineWithElectrical struct {
	base         *ScoringEngine
	electricalPS *ElectricalPenaltySet
	elecWeight   float64
}

// ScoreBreakdownElectrical extends ScoreBreakdown with electrical penalty detail.
type ScoreBreakdownElectrical struct {
	ScoreBreakdown
	ElectricalPenalty       float64
	ElectricalFeasibility   float64
	InfeasibleStringPenalty float64
	TransformerOverload     float64
	ExcessiveCablePenalty   float64
	AdjustedCompositeScore  float64
}

// ScoreCandidate computes the full composite score including electrical penalties.
func (se *ScoringEngineWithElectrical) ScoreCandidate(g *CandidateArtifactGraph) (*ScoreBreakdownElectrical, error) {
	base, err := se.base.ScoreCandidate(g)
	if err != nil {
		return nil, err
	}

	elecPenalty := se.electricalPS.ComputeAggregatePenalty(g)
	elecFeasibility := 1.0 - elecPenalty

	infeasStr := se.electricalPS.InfeasibleStringing.Metric(g)
	txOverload := se.electricalPS.TransformerOverloadRisk.Metric(g)
	cableExcess := se.electricalPS.ExcessiveCableProxy.Metric(g)

	// Adjusted composite: dampen by electrical penalty with configurable weight.
	adjusted := base.CompositeScore * (1.0 - se.elecWeight*elecPenalty)
	adjusted = clamp01(adjusted)

	return &ScoreBreakdownElectrical{
		ScoreBreakdown:          *base,
		ElectricalPenalty:       elecPenalty,
		ElectricalFeasibility:   elecFeasibility,
		InfeasibleStringPenalty: infeasStr,
		TransformerOverload:     txOverload,
		ExcessiveCablePenalty:   cableExcess,
		AdjustedCompositeScore:  adjusted,
	}, nil
}

// RankCandidates scores and ranks using the electrical-adjusted composite score.
func (se *ScoringEngineWithElectrical) RankCandidates(candidates []*CandidateArtifactGraph) ([]*MLCandidate, error) {
	if len(candidates) == 0 {
		return nil, nil
	}

	type scoredItem struct {
		graph     *CandidateArtifactGraph
		breakdown *ScoreBreakdownElectrical
	}

	items := make([]*scoredItem, 0, len(candidates))
	for _, g := range candidates {
		bd, err := se.ScoreCandidate(g)
		if err != nil {
			return nil, err
		}
		items = append(items, &scoredItem{graph: g, breakdown: bd})
	}

	// Stable deterministic sort: adjusted composite desc, tie-break on LayoutID asc.
	for i := 1; i < len(items); i++ {
		for j := i; j > 0; j-- {
			li := items[j-1]
			lj := items[j]
			if li.breakdown.AdjustedCompositeScore < lj.breakdown.AdjustedCompositeScore ||
				(li.breakdown.AdjustedCompositeScore == lj.breakdown.AdjustedCompositeScore &&
					li.graph.LayoutID > lj.graph.LayoutID) {
				items[j-1], items[j] = items[j], items[j-1]
			}
		}
	}

	results := make([]*MLCandidate, 0, len(items))
	for i, item := range items {
		scores := map[string]float64{
			"feasibility":            item.breakdown.FeasibilityScore,
			"mw_fit":                 item.breakdown.MwFitScore,
			"cost":                   item.breakdown.CostScore,
			"land_use":               item.breakdown.LandUseScore,
			"soft_penalty":           item.breakdown.SoftPenalty,
			"electrical_penalty":     item.breakdown.ElectricalPenalty,
			"electrical_feasibility": item.breakdown.ElectricalFeasibility,
		}
		results = append(results, &MLCandidate{
			CandidateID:           "candidate-" + item.graph.LayoutID,
			ArtifactGraph:         item.graph,
			ObjectiveScores:       scores,
			CompositeScore:        item.breakdown.AdjustedCompositeScore,
			Rank:                  int32(i + 1),
			SelectionReasoning:    "ranked by electrical-adjusted lexicographic objectives",
			OptimizationAlgorithm: "electrical_scoring_v1",
		})
	}

	return results, nil
}
