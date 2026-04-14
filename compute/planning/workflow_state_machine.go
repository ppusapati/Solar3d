// Package planning — Task 13: Planning Workflow proto contracts and state machine.
//
// This package implements the workflow phase state machine that orchestrates
// project progression through planning, design validation, and approval phases.
//
// Key invariants:
//  1. Phases are strictly ordered: PLANNING -> LAYOUT_READY -> ELECTRICAL_READY ->
//     TRANSMISSION_READY -> REVIEW_READY -> APPROVED -> COMMISSIONING_READY
//  2. Each phase transition requires typed evidence payloads specific to that phase.
//  3. Backward transitions (rollback) are allowed only before COMMISSIONING_READY.
//  4. All transitions are immutable and logged (audit trail).
//  5. Idempotent: transitioning to the current phase is a no-op with success.
package planning

import (
	"fmt"
	"time"
)

// ========== Workflow State Machine ==========

// WorkflowPhase represents the distinct phases in the project lifecycle.
type WorkflowPhase int

const (
	PhaseUnspecified WorkflowPhase = iota
	PlanningPhase
	LayoutReadyPhase
	ElectricalReadyPhase
	TransmissionReadyPhase
	ReviewReadyPhase
	ApprovedPhase
	CommissioningReadyPhase
	ArchivedPhase
)

// String returns the human-readable phase name.
func (p WorkflowPhase) String() string {
	return map[WorkflowPhase]string{
		PhaseUnspecified:        "UNSPECIFIED",
		PlanningPhase:           "PLANNING",
		LayoutReadyPhase:        "LAYOUT_READY",
		ElectricalReadyPhase:    "ELECTRICAL_READY",
		TransmissionReadyPhase:  "TRANSMISSION_READY",
		ReviewReadyPhase:        "REVIEW_READY",
		ApprovedPhase:           "APPROVED",
		CommissioningReadyPhase: "COMMISSIONING_READY",
		ArchivedPhase:           "ARCHIVED",
	}[p]
}

// ValidPhaseSequence defines the legal forward transitions.
// Key: current phase, Value: list of allowed next phases.
var ValidPhaseSequence = map[WorkflowPhase][]WorkflowPhase{
	PlanningPhase:           {LayoutReadyPhase, ArchivedPhase},
	LayoutReadyPhase:        {ElectricalReadyPhase, PlanningPhase, ArchivedPhase},
	ElectricalReadyPhase:    {TransmissionReadyPhase, LayoutReadyPhase, ArchivedPhase},
	TransmissionReadyPhase:  {ReviewReadyPhase, ElectricalReadyPhase, ArchivedPhase},
	ReviewReadyPhase:        {ApprovedPhase, TransmissionReadyPhase, ArchivedPhase},
	ApprovedPhase:           {CommissioningReadyPhase, ReviewReadyPhase, ArchivedPhase},
	CommissioningReadyPhase: {ArchivedPhase}, // No backward transition from commissioning
	ArchivedPhase:           {},              // Terminal state
}

// CanTransition checks if a transition from current to target phase is legal.
func CanTransition(current, target WorkflowPhase) bool {
	allowed, ok := ValidPhaseSequence[current]
	if !ok {
		return false
	}
	for _, a := range allowed {
		if a == target {
			return true
		}
	}
	return false
}

// ========== Evidence Types ==========

// Evidence is the interface all transition evidence types must satisfy.
type Evidence interface {
	// PhaseTransitionEvidence returns the phase this evidence supports
	PhaseTransitionEvidence() WorkflowPhase
}

// PlanningAcceptanceEvidence marks planning inputs accepted by user.
type PlanningAcceptanceEvidence struct {
	BoundaryID      string
	AcceptedByActor string
	AcceptedAt      time.Time
	Notes           string
}

func (e *PlanningAcceptanceEvidence) PhaseTransitionEvidence() WorkflowPhase {
	return LayoutReadyPhase
}

// LayoutApprovalEvidence marks ML candidate set approved and preferred candidate selected.
type LayoutApprovalEvidence struct {
	CandidateID             string
	MLExperimentID          string
	ApprovedByActor         string
	ApprovedAt              time.Time
	CandidateCompositeScore float64
	SelectionRationale      string
}

func (e *LayoutApprovalEvidence) PhaseTransitionEvidence() WorkflowPhase {
	return ElectricalReadyPhase
}

// ElectricalSignoffEvidence marks layout validated by electrical service.
type ElectricalSignoffEvidence struct {
	LayoutID                   string
	ElectricalAnalysisID       string
	ValidatedByActor           string
	ValidatedAt                time.Time
	Violations                 []string // Empty if none
	ElectricalFeasibilityScore float64
}

func (e *ElectricalSignoffEvidence) PhaseTransitionEvidence() WorkflowPhase {
	return TransmissionReadyPhase
}

// TransmissionSignoffEvidence marks transmission routing complete and validated.
type TransmissionSignoffEvidence struct {
	ElectricalLayoutID   string
	TransmissionRouteID  string
	ApprovedByActor      string
	ApprovedAt           time.Time
	ProtectionDevices    []string
	FaultIsolationPoints int32
}

func (e *TransmissionSignoffEvidence) PhaseTransitionEvidence() WorkflowPhase {
	return ReviewReadyPhase
}

// ReviewApprovalEvidence marks LOD 400 checklist review complete.
type ReviewApprovalEvidence struct {
	TransmissionRouteID    string
	LOD400ChecklistID      string
	ReviewedByActor        string
	ReviewedAt             time.Time
	MandatoryItemsVerified int32
	Blockers               []string // Empty if all resolved
	QualityScore           float64  // [0, 1]
}

func (e *ReviewApprovalEvidence) PhaseTransitionEvidence() WorkflowPhase {
	return ApprovedPhase
}

// AssetIdentityMapping links a design artifact to a commissioned physical asset.
// This mapping is propagated during commissioning handover so twin provisioning
// can immediately establish identity lineage.
type AssetIdentityMapping struct {
	DesignAssetID        string
	DesignAssetType      string
	PhysicalSerialNumber string
	CommissioningRef     string
}

// StakeholderApprovalEvidence marks project approved for commissioning by stakeholder.
type StakeholderApprovalEvidence struct {
	ReviewApprovedLayoutID string
	ElectricalAnalysisID   string
	TransmissionRouteID    string
	AssetIdentityMappings  []AssetIdentityMapping
	ApprovedByActor        string
	ActorRole              string // e.g., "designer", "manager", "owner"
	ApprovedAt             time.Time
	ApprovalNotes          string
}

func (e *StakeholderApprovalEvidence) PhaseTransitionEvidence() WorkflowPhase {
	return CommissioningReadyPhase
}

// CommissioningConfirmationEvidence marks twin provisioned and linked.
type CommissioningConfirmationEvidence struct {
	ApprovedProjectID      string
	TwinID                 string
	ProvisionedByActor     string
	ProvisionedAt          time.Time
	AssetIdentityLinkCount int32
}

func (e *CommissioningConfirmationEvidence) PhaseTransitionEvidence() WorkflowPhase {
	return ArchivedPhase // Or terminal commissioning state
}

// ========== Transition Record ==========

// PhaseTransitionRecord is an immutable audit record of a single phase transition.
type PhaseTransitionRecord struct {
	ID             string // UUID
	ProjectID      string
	FromPhase      WorkflowPhase
	ToPhase        WorkflowPhase
	Evidence       Evidence
	OccurredAt     time.Time
	ActorID        string // User or system that performed it
	Reason         string // Human-readable reason
	IsRollback     bool
	RollbackReason string
}

// ========== Workflow State ==========

// WorkflowState represents the mutable state of a project's workflow.
type WorkflowState struct {
	ProjectID         string
	CurrentPhase      WorkflowPhase
	PhaseEnteredAt    time.Time
	Transitions       []*PhaseTransitionRecord // Immutable history in order
	ActiveBlockers    []string                 // Reasons why further progress is blocked
	BlockersSinceTime time.Time
	BlockedBy         string // Actor ID that caused the block (if applicable)
}

// InPhase returns true if the workflow is in the specified phase.
func (ws *WorkflowState) InPhase(phase WorkflowPhase) bool {
	return ws.CurrentPhase == phase
}

// IsBlocked returns true if forward progress is blocked.
func (ws *WorkflowState) IsBlocked() bool {
	return len(ws.ActiveBlockers) > 0
}

// ========== State Machine Validator ==========

// WorkflowValidator enforces phase transition rules and gate logic.
type WorkflowValidator struct {
	state *WorkflowState
}

// NewWorkflowValidator creates a validator for a given state.
func NewWorkflowValidator(state *WorkflowState) *WorkflowValidator {
	if state == nil {
		state = &WorkflowState{
			CurrentPhase: PlanningPhase,
		}
	}
	return &WorkflowValidator{state: state}
}

// ValidateTransition checks if a transition is allowed and returns blocker reasons.
// If valid, returns (nil, true). If invalid, returns reasons and false.
func (v *WorkflowValidator) ValidateTransition(target WorkflowPhase, evidence Evidence) ([]string, bool) {
	var blockers []string

	// Check if transition is legal in sequence.
	if !CanTransition(v.state.CurrentPhase, target) {
		blockers = append(blockers,
			fmt.Sprintf("phase %s cannot transition to %s", v.state.CurrentPhase, target))
	}

	// Check if currently blocked.
	if v.state.IsBlocked() && target != v.state.CurrentPhase {
		blockers = append(blockers,
			fmt.Sprintf("project blocked: %v", v.state.ActiveBlockers))
	}

	// Verify evidence type matches target phase (if provided).
	if evidence != nil && evidence.PhaseTransitionEvidence() != target {
		blockers = append(blockers,
			fmt.Sprintf("evidence type %T does not match target phase %s",
				evidence, target))
	}

	// Idempotent: no blockers if already in target phase.
	if v.state.CurrentPhase == target {
		return nil, true
	}

	return blockers, len(blockers) == 0
}

// ========== Transition Executor ==========

// ExecuteTransition applies a validated transition and returns the new record.
func ExecuteTransition(state *WorkflowState, target WorkflowPhase, evidence Evidence, actor string, reason string, isRollback bool) (*PhaseTransitionRecord, error) {
	// Revalidate before commit (defensive).
	validator := NewWorkflowValidator(state)
	blockers, valid := validator.ValidateTransition(target, evidence)
	if !valid && target != state.CurrentPhase {
		return nil, fmt.Errorf("transition blocked: %v", blockers)
	}

	// Idempotent no-op.
	if state.CurrentPhase == target {
		return nil, nil // No new record; already in target phase
	}

	// Create immutable record.
	record := &PhaseTransitionRecord{
		ID:             fmt.Sprintf("trans-%d", len(state.Transitions)+1), // UUID in real impl
		ProjectID:      state.ProjectID,
		FromPhase:      state.CurrentPhase,
		ToPhase:        target,
		Evidence:       evidence,
		OccurredAt:     time.Now(),
		ActorID:        actor,
		Reason:         reason,
		IsRollback:     isRollback,
		RollbackReason: "", // Populated if rollback
	}

	// Update mutable state.
	state.CurrentPhase = target
	state.PhaseEnteredAt = time.Now()
	state.Transitions = append(state.Transitions, record)

	// Clear blockers on successful transition (or set if needed).
	state.ActiveBlockers = nil
	state.BlockersSinceTime = time.Time{}

	return record, nil
}

// ========== Blocker Management ==========

// SetBlocker adds a blocker reason and records when it started.
func SetBlocker(state *WorkflowState, reason string, actor string) {
	state.ActiveBlockers = append(state.ActiveBlockers, reason)
	state.BlockedBy = actor
	state.BlockersSinceTime = time.Now()
}

// ClearBlocker removes a specific blocker reason.
func ClearBlocker(state *WorkflowState, reason string) {
	var remaining []string
	for _, b := range state.ActiveBlockers {
		if b != reason {
			remaining = append(remaining, b)
		}
	}
	state.ActiveBlockers = remaining
	if len(state.ActiveBlockers) == 0 {
		state.BlockersSinceTime = time.Time{}
		state.BlockedBy = ""
	}
}

// ClearAllBlockers removes all blockers.
func ClearAllBlockers(state *WorkflowState) {
	state.ActiveBlockers = nil
	state.BlockersSinceTime = time.Time{}
	state.BlockedBy = ""
}

// ========== Phase Helpers ==========

// PhaseDescription returns a human-readable description of a phase.
func PhaseDescription(phase WorkflowPhase) string {
	return map[WorkflowPhase]string{
		PlanningPhase:           "Project planning: boundary and target inputs captured",
		LayoutReadyPhase:        "ML layout synthesis complete: candidate set approved",
		ElectricalReadyPhase:    "Electrical validation complete: stringing and safety passed",
		TransmissionReadyPhase:  "Transmission routing complete: route and protection validated",
		ReviewReadyPhase:        "LOD 400 checklist cleared: quality gates passed",
		ApprovedPhase:           "Project approved for commissioning by stakeholders",
		CommissioningReadyPhase: "Twin provisioned and asset identities linked",
		ArchivedPhase:           "Project archived (end of lifecycle)",
	}[phase]
}
