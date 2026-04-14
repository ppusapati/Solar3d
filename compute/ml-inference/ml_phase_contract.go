// Package ml_inference — Task 12: Frozen ML/Algorithm contracts for backend integration.
//
// This file documents the versioned public contracts that backend services
// (layout_service, electrical_service, transmission_service, and the main
// workflow orchestrator) depend on.
//
// VERSION: 1.0
// COMMIT_SHA: [TBD — to be populated at Phase 1 freeze]
// RELEASE_DATE: [TBD — April 2026 planned for Phase 1 production readiness]
//
// ========== Introduction ==========
//
// The ML/Algorithm phase produces candidate solar layouts by synthesizing
// infrastructure, scoring multi-objective tradeoffs, and ranking via a
// lightweight ML proxy.  The backend integration point is the MLPhaseOutput
// struct, which contains the complete ranked candidate set plus deterministic
// fallback.
//
// All types in this contract are immutable and deterministic: given identical
// seeds and boundaries, repeated runs produce identical outputs (verified via
// Task 11 reproducibility tests).
//
// ========== Versioning and Migration ==========
//
// Contract Version 1.0 covers Tasks 1–12 (Phase 1 ML/Algorithm):
//   - Deterministic infrastructure synthesis
//   - Multi-objective scoring (feasibility, MW fit, cost, land-use)
//   - Electrical-aware penalties (infeasible stringing, transformer overload, excessive cable)
//   - Candidate search with Pareto filtering
//   - ML ranking layer with fallback guarantee
//
// Breaking changes (if any) will be prefixed "v2_" and documented in BREAKING_CHANGES.md.
// Additive changes (new optional fields) are backward-compatible within v1.
//
// Consumers planning upgrades should read MIGRATION_NOTES_v1_to_v2.md (when v2 exists).
//
// ========== Public API Contract ==========

package ml_inference

import "time"

// ────── Synthesis Input Contract ──────

// SynthesisInput is the primary input to the ML phase.  It captures
// a boundary, target infrastructure counts, and a deterministic seed
// that gates reproducibility.  This struct is stable and versioned
// for backend consumers.
//
// CONTRACT GUARANTEE: identical SynthesisInput + identical hardware
// produces identical CandidateArtifactGraph outputs (verified by
// Task 11 reproducibility tests).
type SynthesisInput struct {
	LayoutID            string    // UUID
	ProjectID           string    // UUID
	Seed                int64     // Deterministic seed [0, 2^63-1]
	Boundary            *Geometry // WGS84 polygon with elevation
	TargetInverterCount int32     // Desired inverter count
	TargetTxCount       int32     // Desired transformer count
	DemSourceGcsPath    *string   // Optional GCS path for DEM; default uses project DEM
	CreatedAt           time.Time // Audit timestamp
}

// ────── Output Artifact Contract ──────

// CandidateArtifactGraph represents a complete feasible layout.
// This is the core artifact produced by synthesis and consumed by
// electrical, transmission, and backend services.
//
// CONTRACT GUARANTEE: all geometry is WGS84 (lon, lat, elev_m);
// all entity IDs are UUID v4; all SoftPenalty/FeasibilityScore values
// in [0, 1]; checksums are deterministic SHA256 over sorted entity lists.
//
// Backend consumers should treat this as immutable and not modify fields.
type CandidateArtifactGraph struct {
	LayoutID  string
	ProjectID string

	Infrastructure   *InfrastructureLayout
	SolarPanels      []*SolarPanel
	PanelStrings     []*PanelString
	InverterGroups   []*InverterGroup
	TransformerNodes []*TransformerNode
	CableCorridors   []*CableCorridorSegment
	FaultIdentifiers []*FaultIdentifier

	Lineage   *CandidateLineage
	CreatedAt time.Time
	Version   string
}

// ────── Ranking Output Contract ──────

// MLCandidate wraps a ranked artifact graph with scores and confidence intervals.
// The Rank field is the final ranking (1 = best) after all deterministic
// optimization and ML re-ranking.
//
// CONTRACT GUARANTEE: Rank is stable within a run (identical seed ⇒ identical Rank);
// ConfidenceLower/ConfidenceUpper are [0, 1]; CompositeScore is [0, 1] and
// represents the final optimized score (either from multi-objective engine
// or ML ranker, depending on config).
//
// Backend consumers can use Rank to tier candidates (e.g., prefer Rank ≤ 3).
type MLCandidate struct {
	CandidateID           string
	ArtifactGraph         *CandidateArtifactGraph
	ObjectiveScores       map[string]float64 // "feasibility", "mw_fit", "cost", "land_use", "soft_penalty", "electrical_penalty", "electrical_feasibility"
	CompositeScore        float64
	Rank                  int32
	ConfidenceLower       float64
	ConfidenceUpper       float64
	SelectionReasoning    string
	ParentCandidateIDs    []string
	OptimizationAlgorithm string
	CreatedAt             time.Time
}

// ────── Search Result Contract ──────

// CandidateSearchResult is the output of deterministic candidate search.
// It contains a ranked list of feasible candidates plus a Pareto frontier
// and a guaranteed deterministic fallback.
//
// CONTRACT GUARANTEE: RankedCandidates is sorted by composite score (desc);
// DeterministicFallback is always present (never nil); ParetoFrontCandidates
// is non-dominated under the four-objective dominance relation (≥ on all metrics,
// strictly > on at least one).
//
// Backend consumers should always check DeterministicFallback before proceeding
// with top-ranked candidate to ensure a safe fallback path is available.
type CandidateSearchResult struct {
	RankedCandidates      []*MLCandidate
	ParetoFrontCandidates []*MLCandidate
	DeterministicFallback *MLCandidate
	Metadata              *CandidateSearchMetadata
}

// ────── ML Ranking Output Contract ──────

// MLRankResult is the output of the ML ranking layer (Task 10).
// When ML is enabled, candidates are re-ranked by a feature-based proxy score.
// When ML is disabled, the result is a deterministic pass-through of the
// optimizer ranking.
//
// CONTRACT GUARANTEE: FinalRankedCandidates is sorted by ML proxy score (desc)
// or optimizer rank when ML disabled; FallbackCandidateID is always set;
// RecommendedCandidateID is the top-ranked candidate; MLEnabled flag indicates
// whether re-ranking was applied.  System never fails when result is nil (per
// Step 10 requirement: "If ML disabled, system still returns deterministic +
// optimization result without failure").
//
// Backend consumers should prefer RecommendedCandidateID for automation,
// but always have FallbackCandidateID available for manual override.
type MLRankResult struct {
	FinalRankedCandidates  []*MLCandidate
	RecommendedCandidateID string
	FallbackCandidateID    string
	MLEnabled              bool
	ModelVersion           string
	FeatureExtractedCount  int
	RankingReasoning       string
}

// ────── Primary Output Contract ──────

// MLPhaseOutput is the complete output of the ML phase delivered to backend services.
// This is the integration point: electrical_service, transmission_service, and
// the layout_service workflow orchestrator consume this struct.
//
// CONTRACT GUARANTEE: no fields are nil when properly produced; all UUIDs are
// unique within scope; Candidate rankings are deterministic given Metadata.BaseLayoutSeed.
//
// Backend consumers should deserialize from JSON/Protobuf and treat as immutable.
// Any modifications should be recorded in the candidate's Lineage.OptimizationHistory.
type MLPhaseOutput struct {
	ProjectID    string
	LayoutID     string
	ExperimentID string // Unique per run
	Timestamp    time.Time
	Version      string // "1.0"

	// Core ranking result
	FinalRankedCandidates  []*MLCandidate
	RecommendedCandidateID string
	FallbackCandidateID    string

	// Pareto frontier for advanced users
	ParetoFrontier []*MLCandidate

	// Metadata for reproducibility and audit
	DeterministicSeed        int64
	TotalCandidatesEvaluated int32
	SoftConstraintSetHash    string
	HardConstraintSetHash    string
	ElectricalPenaltySetHash string
	MLRankerConfigHash       string

	// Lineage and traceability
	PhaseStartTime    time.Time
	PhaseEndTime      time.Time
	ExecutionTimeMs   float64
	SelectedCandidate *MLCandidate // Top recommended
}

// ========== Backward Compatibility Notes ==========
//
// Contract Version 1.0 is the first freeze.  The following are forward-compatible:
//
//   1. New optional fields in MLPhaseOutput (e.g., optional "confidence_reasoning" field)
//      will be ignored by v1.0 backends; no action required.
//
//   2. New ObjectiveScores keys in MLCandidate.ObjectiveScores (e.g.,
//      "ancillary_cost", "logistics_penalty") are additive; backends can ignore
//      unfamiliar keys.
//
//   3. New SynthesisInput optional fields will default to zero/nil if absent;
//      backends do not need to update unless features are required.
//
// The following would be breaking changes and require v2.x release:
//
//   • Renaming or removing any field in the core types above
//   • Changing the dominance relation for Pareto filtering
//   • Remocing the DeterministicFallback guarantee
//   • Changing the composite score calculation formula
//
// ========== Integration Test Fixture Location ==========
//
// See ml_phase_contract_test.go for:
//   - Minimal valid MLPhaseOutput instance
//   - Example deserialization from JSON
//   - Contract validation checklist
//

// TODO(contract-v1): Verify no unresolved TODOs in this package by end of Phase 1.
// TODO(migration-v1-v2): Prepare BREAKING_CHANGES.md when v2 scoped.
