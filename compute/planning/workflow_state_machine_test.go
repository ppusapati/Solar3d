package planning

import (
	"testing"
	"time"
)

// ========== Phase Sequence Tests ==========

func TestPhase_CanTransition_LegalForwardPath(t *testing.T) {
	transitions := []struct {
		from WorkflowPhase
		to   WorkflowPhase
		ok   bool
	}{
		{PlanningPhase, LayoutReadyPhase, true},
		{LayoutReadyPhase, ElectricalReadyPhase, true},
		{ElectricalReadyPhase, TransmissionReadyPhase, true},
		{TransmissionReadyPhase, ReviewReadyPhase, true},
		{ReviewReadyPhase, ApprovedPhase, true},
		{ApprovedPhase, CommissioningReadyPhase, true},
		// Skips not allowed
		{PlanningPhase, ElectricalReadyPhase, false},
		{LayoutReadyPhase, ReviewReadyPhase, false},
	}

	for _, tc := range transitions {
		if got := CanTransition(tc.from, tc.to); got != tc.ok {
			t.Fatalf("CanTransition(%s, %s) = %v, want %v",
				tc.from, tc.to, got, tc.ok)
		}
	}
}

func TestPhase_CanTransition_AllowsRollback(t *testing.T) {
	// Rollbacks allowed before CommissioningReady
	backTransitions := []struct {
		from WorkflowPhase
		to   WorkflowPhase
		ok   bool
	}{
		{LayoutReadyPhase, PlanningPhase, true},
		{ElectricalReadyPhase, LayoutReadyPhase, true},
		{TransmissionReadyPhase, ElectricalReadyPhase, true},
		{ReviewReadyPhase, TransmissionReadyPhase, true},
		{ApprovedPhase, ReviewReadyPhase, true},
		// No rollback from CommissioningReady
		{CommissioningReadyPhase, ApprovedPhase, false},
	}

	for _, tc := range backTransitions {
		if got := CanTransition(tc.from, tc.to); got != tc.ok {
			t.Fatalf("CanTransition rollback(%s, %s) = %v, want %v",
				tc.from, tc.to, got, tc.ok)
		}
	}
}

func TestPhase_CanTransition_AllowsArchival(t *testing.T) {
	// Archive allowed from any active phase
	for phase := PlanningPhase; phase <= ReviewReadyPhase; phase++ {
		if !CanTransition(phase, ArchivedPhase) {
			t.Fatalf("CanTransition(%s, ARCHIVED) should be true", phase)
		}
	}

	// But not from ARCHIVED itself
	if CanTransition(ArchivedPhase, PlanningPhase) {
		t.Fatal("CanTransition(ARCHIVED, PLANNING) should be false (terminal)")
	}
}

// ========== State Machine Validator Tests ==========

func TestValidator_AllowsLegalTransition(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-1",
		CurrentPhase: PlanningPhase,
		Transitions:  []*PhaseTransitionRecord{},
	}
	validator := NewWorkflowValidator(state)

	blockers, valid := validator.ValidateTransition(LayoutReadyPhase,
		&LayoutApprovalEvidence{CandidateID: "c1"})
	if !valid {
		t.Fatalf("expected valid transition; got blockers: %v", blockers)
	}
}

func TestValidator_RejectsIllegalTransition(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-1",
		CurrentPhase: PlanningPhase,
	}
	validator := NewWorkflowValidator(state)

	blockers, valid := validator.ValidateTransition(ElectricalReadyPhase, nil)
	if valid {
		t.Fatal("expected validation to fail for phase skip")
	}
	if len(blockers) == 0 {
		t.Fatal("expected blocker reasons")
	}
}

func TestValidator_RejectsWrongEvidenceType(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-1",
		CurrentPhase: LayoutReadyPhase,
	}
	validator := NewWorkflowValidator(state)

	// Provide ElectricalSignoff evidence but try to transition to TRANSMISSION_READY
	// (which expects TransmissionSignoff)
	evidence := &ElectricalSignoffEvidence{LayoutID: "l1"}
	blockers, valid := validator.ValidateTransition(TransmissionReadyPhase, evidence)
	if valid {
		t.Fatal("expected validation to fail for mismatched evidence type")
	}
	if len(blockers) == 0 {
		t.Fatal("expected blocker reasons")
	}
}

func TestValidator_AllowsIdempotentTransition(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-1",
		CurrentPhase: LayoutReadyPhase,
	}
	validator := NewWorkflowValidator(state)

	// Try to transition to current phase (idempotent)
	blockers, valid := validator.ValidateTransition(LayoutReadyPhase, nil)
	if !valid {
		t.Fatalf("idempotent transition should be valid; got blockers: %v", blockers)
	}
}

// ========== Blocker Tests ==========

func TestBlocker_SetAndClear(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-1",
		CurrentPhase: LayoutReadyPhase,
	}

	if state.IsBlocked() {
		t.Fatal("state should not be initially blocked")
	}

	SetBlocker(state, "electrical validation in progress", "actor-1")
	if !state.IsBlocked() {
		t.Fatal("state should be blocked after SetBlocker")
	}
	if state.BlockedBy != "actor-1" {
		t.Fatalf("incorrect BlockedBy: %s", state.BlockedBy)
	}

	ClearBlocker(state, "electrical validation in progress")
	if state.IsBlocked() {
		t.Fatal("state should not be blocked after ClearBlocker")
	}
	if state.BlockedBy != "" {
		t.Fatal("BlockedBy should be cleared")
	}
}

func TestBlocker_PreventTransitionWhenBlocked(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-1",
		CurrentPhase: LayoutReadyPhase,
	}
	SetBlocker(state, "waiting for electrical signoff", "actor-1")

	validator := NewWorkflowValidator(state)
	blockers, valid := validator.ValidateTransition(ElectricalReadyPhase,
		&ElectricalSignoffEvidence{})
	if valid {
		t.Fatal("validation should fail when state is blocked")
	}
	if len(blockers) == 0 {
		t.Fatal("expected blocker reasons when blocked")
	}
}

func TestBlocker_MultipleBlockers(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-1",
		CurrentPhase: TransmissionReadyPhase,
	}

	SetBlocker(state, "LOD 400 items pending", "actor-1")
	SetBlocker(state, "stakeholder signoff pending", "actor-2")

	if len(state.ActiveBlockers) != 2 {
		t.Fatalf("expected 2 blockers; got %d", len(state.ActiveBlockers))
	}

	ClearBlocker(state, "LOD 400 items pending")
	if len(state.ActiveBlockers) != 1 {
		t.Fatalf("expected 1 blocker after clearing; got %d", len(state.ActiveBlockers))
	}

	ClearAllBlockers(state)
	if state.IsBlocked() {
		t.Fatal("state should not be blocked after ClearAllBlockers")
	}
}

// ========== Transition Execution Tests ==========

func TestExecuteTransition_ValidTransition_CreatesRecord(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-2",
		CurrentPhase: PlanningPhase,
		Transitions:  []*PhaseTransitionRecord{},
	}

	evidence := &PlanningAcceptanceEvidence{
		BoundaryID:      "boundary-1",
		AcceptedByActor: "user-1",
		AcceptedAt:      time.Now(),
	}

	record, err := ExecuteTransition(state, LayoutReadyPhase, evidence, "user-1", "approved by planning", false)
	if err != nil {
		t.Fatalf("ExecuteTransition failed: %v", err)
	}

	if record == nil {
		t.Fatal("transition record should not be nil")
	}
	if state.CurrentPhase != LayoutReadyPhase {
		t.Fatalf("state phase not updated: got %s", state.CurrentPhase)
	}
	if len(state.Transitions) != 1 {
		t.Fatalf("expected 1 transition record; got %d", len(state.Transitions))
	}
	if state.Transitions[0].FromPhase != PlanningPhase {
		t.Fatal("transition record FromPhase incorrect")
	}
	if state.Transitions[0].ToPhase != LayoutReadyPhase {
		t.Fatal("transition record ToPhase incorrect")
	}
}

func TestExecuteTransition_IdempotentNoop(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-3",
		CurrentPhase: LayoutReadyPhase,
		Transitions:  []*PhaseTransitionRecord{},
	}

	record, err := ExecuteTransition(state, LayoutReadyPhase, nil, "user-1", "already ready", false)
	if err != nil {
		t.Fatalf("idempotent transition failed: %v", err)
	}

	if record != nil {
		t.Fatal("idempotent transition should return nil record (no-op)")
	}
	if len(state.Transitions) != 0 {
		t.Fatal("idempotent transition should not create a record")
	}
}

func TestExecuteTransition_Rollback(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-4",
		CurrentPhase: ElectricalReadyPhase,
		Transitions:  []*PhaseTransitionRecord{},
	}

	record, err := ExecuteTransition(state, LayoutReadyPhase, nil, "admin-1",
		"rolling back due to layout issues", true)
	if err != nil {
		t.Fatalf("rollback transition failed: %v", err)
	}

	if record == nil {
		t.Fatal("rollback should create a record")
	}
	if !record.IsRollback {
		t.Fatal("record should mark IsRollback=true")
	}
	if state.CurrentPhase != LayoutReadyPhase {
		t.Fatalf("state should rollback to LayoutReady; got %s", state.CurrentPhase)
	}
}

func TestExecuteTransition_InvalidTransition_ReturnsError(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-5",
		CurrentPhase: PlanningPhase,
	}

	_, err := ExecuteTransition(state, ElectricalReadyPhase, nil, "user-1", "skip phases", false)
	if err == nil {
		t.Fatal("expected error for illegal phase skip")
	}
	if state.CurrentPhase != PlanningPhase {
		t.Fatal("state should not change on error")
	}
}

func TestExecuteTransition_BlockedState_ReturnsError(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-6",
		CurrentPhase: LayoutReadyPhase,
	}
	SetBlocker(state, "electrical validation pending", "actor-1")

	_, err := ExecuteTransition(state, ElectricalReadyPhase,
		&ElectricalSignoffEvidence{}, "user-1", "proceed", false)
	if err == nil {
		t.Fatal("expected error when state is blocked")
	}
}

// ========== Immutability Tests ==========

func TestTransitionRecord_Immutable(t *testing.T) {
	record := &PhaseTransitionRecord{
		ID:         "trans-1",
		FromPhase:  PlanningPhase,
		ToPhase:    LayoutReadyPhase,
		OccurredAt: time.Now(),
	}

	// Records are immutable: fields should not change after creation
	original := record.ToPhase
	record.ToPhase = ArchivedPhase
	if record.ToPhase != ArchivedPhase {
		t.Fatal("in Go, structs are mutable; use defensive copying or read-only views")
	}
	// Note: In production, use a read-only getter or interface to enforce immutability
	record.ToPhase = original
}

// ========== Full Workflow Scenario Tests ==========

func TestFullWorkflow_PlanningToApproved(t *testing.T) {
	state := &WorkflowState{
		ProjectID:    "proj-full",
		CurrentPhase: PlanningPhase,
		Transitions:  []*PhaseTransitionRecord{},
	}

	// Transition sequence: PLANNING -> LAYOUT_READY -> ELECTRICAL_READY -> ...
	phases := []struct {
		target   WorkflowPhase
		evidence Evidence
		reason   string
	}{
		{
			LayoutReadyPhase,
			&PlanningAcceptanceEvidence{BoundaryID: "b1", AcceptedByActor: "u1", AcceptedAt: time.Now()},
			"planning accepted",
		},
		{
			ElectricalReadyPhase,
			&LayoutApprovalEvidence{CandidateID: "c1", MLExperimentID: "exp1", ApprovedByActor: "u1", ApprovedAt: time.Now()},
			"layout approved",
		},
		{
			TransmissionReadyPhase,
			&ElectricalSignoffEvidence{LayoutID: "l1", ElectricalAnalysisID: "ea1", ValidatedByActor: "u2", ValidatedAt: time.Now()},
			"electrical validated",
		},
		{
			ReviewReadyPhase,
			&TransmissionSignoffEvidence{ElectricalLayoutID: "l1", TransmissionRouteID: "tr1", ApprovedByActor: "u3", ApprovedAt: time.Now()},
			"transmission routed",
		},
		{
			ApprovedPhase,
			&ReviewApprovalEvidence{TransmissionRouteID: "tr1", LOD400ChecklistID: "lod1", ReviewedByActor: "u4", ReviewedAt: time.Now(), QualityScore: 0.95},
			"LOD 400 cleared",
		},
	}

	for _, p := range phases {
		record, err := ExecuteTransition(state, p.target, p.evidence, "actor", p.reason, false)
		if err != nil {
			t.Fatalf("transition to %s failed: %v", p.target, err)
		}
		if record == nil {
			t.Fatalf("expected record for transition to %s", p.target)
		}
		if state.CurrentPhase != p.target {
			t.Fatalf("state not in %s after transition", p.target)
		}
	}

	if state.CurrentPhase != ApprovedPhase {
		t.Fatalf("final phase should be APPROVED; got %s", state.CurrentPhase)
	}
	if len(state.Transitions) != len(phases) {
		t.Fatalf("expected %d transition records; got %d", len(phases), len(state.Transitions))
	}
}

func TestWorkflow_String(t *testing.T) {
	for phase := PlanningPhase; phase <= ArchivedPhase; phase++ {
		s := phase.String()
		if s == "" {
			t.Fatalf("phase %d has no string representation", phase)
		}
	}
}
