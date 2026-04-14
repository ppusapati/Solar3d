package domain

// LOD 400 checklist types implementing EN 17412-1 Level of Development 400
// (fabrication/installation detail) gate evaluation.
//
// Standards reference:
//   - EN 17412-1: BIM Level of Development definitions.
//   - IEC 62446-1: PV system documentation requirements.
//   - IEC 60255: Protection relay coordination.
//   - IEC 60909: Fault current calculations.

import (
	"time"

	"github.com/google/uuid"
)

// LOD400AssetClass identifies the asset class being evaluated in a checklist item.
type LOD400AssetClass string

const (
	// LOD400AssetClassPanel covers placed solar panel geometry and string assignments.
	LOD400AssetClassPanel LOD400AssetClass = "PANEL"
	// LOD400AssetClassInverter covers inverter placement, AC/DC ratio, and string wiring.
	LOD400AssetClassInverter LOD400AssetClass = "INVERTER"
	// LOD400AssetClassTransformer covers step-up transformer placement.
	LOD400AssetClassTransformer LOD400AssetClass = "TRANSFORMER"
	// LOD400AssetClassCombinerBox covers DC combiner box placement count.
	LOD400AssetClassCombinerBox LOD400AssetClass = "COMBINER_BOX"
	// LOD400AssetClassRoad covers access road placement.
	LOD400AssetClassRoad LOD400AssetClass = "ROAD"
	// LOD400AssetClassElectrical covers the electrical network acceptance and feasibility.
	LOD400AssetClassElectrical LOD400AssetClass = "ELECTRICAL_NETWORK"
	// LOD400AssetClassTransmission covers the transmission route, acceptance, and fault coverage.
	LOD400AssetClassTransmission LOD400AssetClass = "TRANSMISSION_ROUTE"
)

// LOD400CheckType categorizes the aspect of an asset class under evaluation.
type LOD400CheckType string

const (
	// LOD400CheckGeometry verifies spatial placement of physical assets.
	LOD400CheckGeometry LOD400CheckType = "GEOMETRY"
	// LOD400CheckTopology verifies connectivity and assignment relationships.
	LOD400CheckTopology LOD400CheckType = "TOPOLOGY"
	// LOD400CheckElectrical verifies electrical parameter ranges and limits.
	LOD400CheckElectrical LOD400CheckType = "ELECTRICAL_PARAMS"
	// LOD400CheckStandards verifies compliance with applicable standards.
	LOD400CheckStandards LOD400CheckType = "STANDARDS_COMPLIANCE"
	// LOD400CheckFaultCoverage verifies fault isolation and protection device coverage.
	LOD400CheckFaultCoverage LOD400CheckType = "FAULT_COVERAGE"
	// LOD400CheckAcceptance verifies the acceptance workflow status.
	LOD400CheckAcceptance LOD400CheckType = "ACCEPTANCE_STATUS"
)

// LOD400ItemStatus is the outcome of evaluating a single checklist item.
type LOD400ItemStatus string

const (
	// LOD400ItemPassed indicates the item criterion was satisfied.
	LOD400ItemPassed LOD400ItemStatus = "PASSED"
	// LOD400ItemFailed indicates the item criterion was not satisfied.
	LOD400ItemFailed LOD400ItemStatus = "FAILED"
	// LOD400ItemSkipped indicates the item was not applicable (data source absent).
	LOD400ItemSkipped LOD400ItemStatus = "SKIPPED"
)

// LOD400ChecklistItem is one evaluated criterion in the LOD 400 checklist.
// Items are evaluated deterministically; the same input always produces the same output.
type LOD400ChecklistItem struct {
	// ID is a stable dot-notation identifier (e.g. "PANEL.GEOMETRY.COUNT").
	ID string `json:"id"`
	// AssetClass is the category of asset this item evaluates.
	AssetClass LOD400AssetClass `json:"asset_class"`
	// CheckType is the aspect being evaluated.
	CheckType LOD400CheckType `json:"check_type"`
	// Description is a human-readable label for display in audit reports.
	Description string `json:"description"`
	// IsMandatory flags whether a FAILED status blocks IsLOD400Ready regardless of score.
	IsMandatory bool `json:"is_mandatory"`
	// Status is the outcome of evaluating this item.
	Status LOD400ItemStatus `json:"status"`
	// Evidence records what was observed during evaluation (e.g. "42 panels placed").
	Evidence string `json:"evidence"`
	// BlockerReason is populated only when Status == FAILED and IsMandatory == true.
	BlockerReason string `json:"blocker_reason,omitempty"`
	// Weight is the contribution of this item to the aggregate score [0, 1].
	// Mandatory items each carry weight 1.0; non-mandatory items carry explicit weights.
	Weight float64 `json:"weight"`
}

// LOD400ChecklistResult is the complete output of one LOD 400 scoring run.
// It is persisted to lod400_checklist_results and consumed by the Step 17 export gate.
type LOD400ChecklistResult struct {
	// ID is the unique identifier for this scored result.
	ID uuid.UUID `json:"id"`
	// ProjectID is the owning project.
	ProjectID uuid.UUID `json:"project_id"`
	// LayoutID is the layout being evaluated.
	LayoutID uuid.UUID `json:"layout_id"`
	// ElectricalNetworkID is the electrical network from the layout, if found.
	ElectricalNetworkID *uuid.UUID `json:"electrical_network_id,omitempty"`
	// ScoredAt is the UTC timestamp when this scoring run was executed.
	ScoredAt time.Time `json:"scored_at"`
	// ScoredByActorID is the identity of the actor who triggered the scoring run.
	ScoredByActorID string `json:"scored_by_actor_id"`
	// IsLOD400Ready is true only when all mandatory items are PASSED.
	// A non-zero aggregate score does NOT override a mandatory failure.
	IsLOD400Ready bool `json:"is_lod400_ready"`
	// AggregateScore is the weighted ratio of PASSED items to all active items. Range [0, 1].
	// Formula: sum(weight of PASSED items) / sum(weight of non-SKIPPED items)
	AggregateScore float64 `json:"aggregate_score"`
	// MandatoryBlockers is the ordered list of BlockerReason strings from all failed
	// mandatory items. Empty when IsLOD400Ready is true.
	MandatoryBlockers []string `json:"mandatory_blockers"`
	// Items is the full evaluated checklist in evaluation order.
	Items []LOD400ChecklistItem `json:"items"`
}
