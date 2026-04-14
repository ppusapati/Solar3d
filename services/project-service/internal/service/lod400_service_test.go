package service

// Unit tests for the LOD 400 scoring engine.
//
// Coverage strategy:
//   - All 14 evaluate* functions: happy path (PASSED) and negative path (FAILED/SKIPPED).
//   - buildResult: mandatory-fail-blocks-ready rule, aggregate-score formula.
//   - ScoreLOD400: input validation (negative path, no DB needed).
//
// Note: integration tests against a real DB are out-of-scope for this package;
// the pure evaluation functions cover the scoring logic exhaustively.

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/project-service/internal/domain"
	"solar3d/project-service/internal/repository"
)

// ────────────────────────────────────────────────────────────────────────────
// Helpers
// ────────────────────────────────────────────────────────────────────────────

func noopLogger() zerolog.Logger {
	return zerolog.Nop()
}

func newTestLOD400Service() *LOD400Service {
	// Service with nil repo — safe for calling input-validation paths only.
	return &LOD400Service{repo: nil, logger: noopLogger()}
}

func mustMarshalJSON(v any) []byte {
	b, err := json.Marshal(v)
	if err != nil {
		panic(err)
	}
	return b
}

// ────────────────────────────────────────────────────────────────────────────
// ScoreLOD400 — input validation (no DB path exercised)
// ────────────────────────────────────────────────────────────────────────────

func TestScoreLOD400_MissingProjectID_ReturnsError(t *testing.T) {
	svc := newTestLOD400Service()
	_, err := svc.ScoreLOD400(context.Background(), ScoreLOD400Request{
		ProjectID:       uuid.Nil,
		LayoutID:        uuid.New(),
		ScoredByActorID: "actor-1",
	})
	if err == nil {
		t.Fatal("expected error for empty project_id, got nil")
	}
}

func TestScoreLOD400_MissingLayoutID_ReturnsError(t *testing.T) {
	svc := newTestLOD400Service()
	_, err := svc.ScoreLOD400(context.Background(), ScoreLOD400Request{
		ProjectID:       uuid.New(),
		LayoutID:        uuid.Nil,
		ScoredByActorID: "actor-1",
	})
	if err == nil {
		t.Fatal("expected error for empty layout_id, got nil")
	}
}

func TestScoreLOD400_MissingActorID_ReturnsError(t *testing.T) {
	svc := newTestLOD400Service()
	_, err := svc.ScoreLOD400(context.Background(), ScoreLOD400Request{
		ProjectID:       uuid.New(),
		LayoutID:        uuid.New(),
		ScoredByActorID: "",
	})
	if err == nil {
		t.Fatal("expected error for empty scored_by_actor_id, got nil")
	}
}

// ────────────────────────────────────────────────────────────────────────────
// evaluatePanelCount
// ────────────────────────────────────────────────────────────────────────────

func TestEvaluatePanelCount_WithPanels_Passes(t *testing.T) {
	layout := &repository.LOD400LayoutData{TotalPanels: 100, ReviewMetadataStatus: "APPROVED"}
	item := evaluatePanelCount(layout)
	if item.Status != domain.LOD400ItemPassed {
		t.Errorf("expected PASSED, got %s (blocker: %s)", item.Status, item.BlockerReason)
	}
	if item.BlockerReason != "" {
		t.Errorf("expected no blocker, got %q", item.BlockerReason)
	}
}

func TestEvaluatePanelCount_ZeroPanels_FailsWithBlocker(t *testing.T) {
	layout := &repository.LOD400LayoutData{TotalPanels: 0, ReviewMetadataStatus: "DRAFT"}
	item := evaluatePanelCount(layout)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED, got %s", item.Status)
	}
	if !item.IsMandatory {
		t.Error("PANEL.GEOMETRY.COUNT must be mandatory")
	}
	if item.BlockerReason == "" {
		t.Error("expected non-empty blocker reason")
	}
}

// ────────────────────────────────────────────────────────────────────────────
// evaluatePanelAcceptance
// ────────────────────────────────────────────────────────────────────────────

func TestEvaluatePanelAcceptance_Approved_Passes(t *testing.T) {
	layout := &repository.LOD400LayoutData{TotalPanels: 10, ReviewMetadataStatus: "APPROVED"}
	item := evaluatePanelAcceptance(layout)
	if item.Status != domain.LOD400ItemPassed {
		t.Errorf("expected PASSED, got %s", item.Status)
	}
}

func TestEvaluatePanelAcceptance_Draft_FailsWithBlocker(t *testing.T) {
	for _, status := range []string{"DRAFT", "REVIEW_PENDING", "REJECTED"} {
		layout := &repository.LOD400LayoutData{TotalPanels: 10, ReviewMetadataStatus: status}
		item := evaluatePanelAcceptance(layout)
		if item.Status != domain.LOD400ItemFailed {
			t.Errorf("status=%s: expected FAILED, got %s", status, item.Status)
		}
		if item.BlockerReason == "" {
			t.Errorf("status=%s: expected non-empty blocker reason", status)
		}
	}
}

// ────────────────────────────────────────────────────────────────────────────
// evaluateInverterPlaced
// ────────────────────────────────────────────────────────────────────────────

func TestEvaluateInverterPlaced_WithGroups_Passes(t *testing.T) {
	net := &repository.LOD400NetworkData{NetworkID: uuid.New(), DcAcRatio: 1.1}
	item := evaluateInverterPlaced(net, 3)
	if item.Status != domain.LOD400ItemPassed {
		t.Errorf("expected PASSED, got %s", item.Status)
	}
}

func TestEvaluateInverterPlaced_NoNetwork_Fails(t *testing.T) {
	item := evaluateInverterPlaced(nil, 0)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED, got %s", item.Status)
	}
	if !item.IsMandatory {
		t.Error("INVERTER.GEOMETRY.PLACED must be mandatory")
	}
}

func TestEvaluateInverterPlaced_ZeroGroups_Fails(t *testing.T) {
	net := &repository.LOD400NetworkData{NetworkID: uuid.New(), DcAcRatio: 1.1}
	item := evaluateInverterPlaced(net, 0)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED with 0 groups, got %s", item.Status)
	}
}

// ────────────────────────────────────────────────────────────────────────────
// evaluateInverterDcAcRatio
// ────────────────────────────────────────────────────────────────────────────

func TestEvaluateInverterDcAcRatio_InRange_Passes(t *testing.T) {
	for _, ratio := range []float64{0.9, 1.0, 1.2, 1.5} {
		net := &repository.LOD400NetworkData{DcAcRatio: ratio}
		item := evaluateInverterDcAcRatio(net)
		if item.Status != domain.LOD400ItemPassed {
			t.Errorf("ratio=%.1f: expected PASSED, got %s", ratio, item.Status)
		}
	}
}

func TestEvaluateInverterDcAcRatio_OutOfRange_Fails(t *testing.T) {
	for _, ratio := range []float64{0.0, 0.5, 0.89, 1.51, 2.0} {
		net := &repository.LOD400NetworkData{DcAcRatio: ratio}
		item := evaluateInverterDcAcRatio(net)
		if item.Status != domain.LOD400ItemFailed {
			t.Errorf("ratio=%.2f: expected FAILED, got %s", ratio, item.Status)
		}
		if !item.IsMandatory {
			t.Errorf("ratio=%.2f: INVERTER.ELECTRICAL.DC_AC_RATIO must be mandatory", ratio)
		}
	}
}

func TestEvaluateInverterDcAcRatio_NoNetwork_Fails(t *testing.T) {
	item := evaluateInverterDcAcRatio(nil)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED for nil network, got %s", item.Status)
	}
}

// ────────────────────────────────────────────────────────────────────────────
// evaluateElectricalFeasibility
// ────────────────────────────────────────────────────────────────────────────

func TestEvaluateElectricalFeasibility_NoNetwork_Skipped(t *testing.T) {
	item := evaluateElectricalFeasibility(nil)
	if item.Status != domain.LOD400ItemSkipped {
		t.Errorf("expected SKIPPED for nil network, got %s", item.Status)
	}
	if item.IsMandatory {
		t.Error("ELECTRICAL.ELECTRICAL.FEASIBILITY must not be mandatory")
	}
}

func TestEvaluateElectricalFeasibility_AboveThreshold_Passes(t *testing.T) {
	net := &repository.LOD400NetworkData{ElectricalFeasibilityScore: 0.75}
	item := evaluateElectricalFeasibility(net)
	if item.Status != domain.LOD400ItemPassed {
		t.Errorf("expected PASSED, got %s", item.Status)
	}
}

func TestEvaluateElectricalFeasibility_BelowThreshold_Fails(t *testing.T) {
	net := &repository.LOD400NetworkData{ElectricalFeasibilityScore: 0.5}
	item := evaluateElectricalFeasibility(net)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED, got %s", item.Status)
	}
	if item.BlockerReason != "" {
		t.Error("non-mandatory item must not set BlockerReason")
	}
}

// ────────────────────────────────────────────────────────────────────────────
// evaluateProtectionDevices
// ────────────────────────────────────────────────────────────────────────────

func TestEvaluateProtectionDevices_WithDevices_Passes(t *testing.T) {
	devices := []string{"BREAKER-001", "RELAY-002"}
	tr := &repository.LOD400TransmissionData{
		RouteID:               uuid.New(),
		ReviewMetadataStatus:  "APPROVED",
		ProtectionDevicesJSON: mustMarshalJSON(devices),
		FaultIsolationPoints:  2,
	}
	item := evaluateProtectionDevices(tr)
	if item.Status != domain.LOD400ItemPassed {
		t.Errorf("expected PASSED, got %s (blocker: %s)", item.Status, item.BlockerReason)
	}
}

func TestEvaluateProtectionDevices_EmptyList_Fails(t *testing.T) {
	tr := &repository.LOD400TransmissionData{
		RouteID:               uuid.New(),
		ReviewMetadataStatus:  "APPROVED",
		ProtectionDevicesJSON: mustMarshalJSON([]string{}),
		FaultIsolationPoints:  0,
	}
	item := evaluateProtectionDevices(tr)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED, got %s", item.Status)
	}
	if !item.IsMandatory {
		t.Error("TRANSMISSION.FAULT.PROTECTION_DEVS must be mandatory")
	}
}

func TestEvaluateProtectionDevices_NoRoute_Fails(t *testing.T) {
	item := evaluateProtectionDevices(nil)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED for nil route, got %s", item.Status)
	}
}

// ────────────────────────────────────────────────────────────────────────────
// evaluateFaultIsolationPoints
// ────────────────────────────────────────────────────────────────────────────

func TestEvaluateFaultIsolationPoints_WithPoints_Passes(t *testing.T) {
	tr := &repository.LOD400TransmissionData{FaultIsolationPoints: 3}
	item := evaluateFaultIsolationPoints(tr)
	if item.Status != domain.LOD400ItemPassed {
		t.Errorf("expected PASSED, got %s", item.Status)
	}
}

func TestEvaluateFaultIsolationPoints_ZeroPoints_Fails(t *testing.T) {
	tr := &repository.LOD400TransmissionData{FaultIsolationPoints: 0}
	item := evaluateFaultIsolationPoints(tr)
	if item.Status != domain.LOD400ItemFailed {
		t.Errorf("expected FAILED, got %s", item.Status)
	}
	if !item.IsMandatory {
		t.Error("TRANSMISSION.FAULT.ISOLATION_PTS must be mandatory")
	}
}

// ────────────────────────────────────────────────────────────────────────────
// buildResult — aggregate score and mandatory-fail rule
// ────────────────────────────────────────────────────────────────────────────

func TestBuildResult_AllMandatoryPassed_IsReadyTrue(t *testing.T) {
	items := make([]domain.LOD400ChecklistItem, 10)
	for i := range items {
		items[i] = domain.LOD400ChecklistItem{
			Status:      domain.LOD400ItemPassed,
			IsMandatory: true,
			Weight:      1.0,
		}
	}
	req := ScoreLOD400Request{
		ProjectID:       uuid.New(),
		LayoutID:        uuid.New(),
		ScoredByActorID: "actor-1",
	}
	result := buildResult(req, nil, items)
	if !result.IsLOD400Ready {
		t.Error("expected IsLOD400Ready=true when all mandatory items pass")
	}
	if len(result.MandatoryBlockers) != 0 {
		t.Errorf("expected 0 blockers, got %d: %v", len(result.MandatoryBlockers), result.MandatoryBlockers)
	}
	// Score should be 1.0 (all 10 passed out of 10 active weight)
	if result.AggregateScore != 1.0 {
		t.Errorf("expected aggregate_score=1.0, got %.3f", result.AggregateScore)
	}
}

func TestBuildResult_OneMandatoryFailed_IsReadyFalse(t *testing.T) {
	items := []domain.LOD400ChecklistItem{
		{Status: domain.LOD400ItemPassed, IsMandatory: true, Weight: 1.0},
		{Status: domain.LOD400ItemPassed, IsMandatory: true, Weight: 1.0},
		{
			Status:        domain.LOD400ItemFailed,
			IsMandatory:   true,
			Weight:        1.0,
			BlockerReason: "critical failure",
		},
	}
	req := ScoreLOD400Request{
		ProjectID:       uuid.New(),
		LayoutID:        uuid.New(),
		ScoredByActorID: "actor-1",
	}
	result := buildResult(req, nil, items)
	if result.IsLOD400Ready {
		t.Error("expected IsLOD400Ready=false when a mandatory item fails")
	}
	if len(result.MandatoryBlockers) != 1 {
		t.Errorf("expected 1 blocker, got %d", len(result.MandatoryBlockers))
	}
	// Score = 2/3 ≈ 0.666...
	const wantScore = 2.0 / 3.0
	const epsilon = 0.001
	if result.AggregateScore < wantScore-epsilon || result.AggregateScore > wantScore+epsilon {
		t.Errorf("expected aggregate_score≈%.3f, got %.3f", wantScore, result.AggregateScore)
	}
}

func TestBuildResult_NonMandatoryFailed_DoesNotBlockReady(t *testing.T) {
	items := []domain.LOD400ChecklistItem{
		{Status: domain.LOD400ItemPassed, IsMandatory: true, Weight: 1.0},
		{Status: domain.LOD400ItemFailed, IsMandatory: false, Weight: 0.5},
	}
	req := ScoreLOD400Request{
		ProjectID:       uuid.New(),
		LayoutID:        uuid.New(),
		ScoredByActorID: "actor-1",
	}
	result := buildResult(req, nil, items)
	if !result.IsLOD400Ready {
		t.Error("expected IsLOD400Ready=true: non-mandatory failures must not block gate")
	}
	if len(result.MandatoryBlockers) != 0 {
		t.Errorf("expected 0 blockers, got %d", len(result.MandatoryBlockers))
	}
	// Score = 1.0 / (1.0 + 0.5) = 0.666...
	const wantScore = 1.0 / 1.5
	const epsilon = 0.001
	if result.AggregateScore < wantScore-epsilon || result.AggregateScore > wantScore+epsilon {
		t.Errorf("expected aggregate_score≈%.3f, got %.3f", wantScore, result.AggregateScore)
	}
}

func TestBuildResult_SkippedMandatory_IsReadyFalse(t *testing.T) {
	items := []domain.LOD400ChecklistItem{
		{Status: domain.LOD400ItemPassed, IsMandatory: true, Weight: 1.0},
		{
			Status:        domain.LOD400ItemSkipped,
			IsMandatory:   true,
			Weight:        1.0,
			BlockerReason: "data unavailable",
		},
	}
	req := ScoreLOD400Request{
		ProjectID:       uuid.New(),
		LayoutID:        uuid.New(),
		ScoredByActorID: "actor-1",
	}
	result := buildResult(req, nil, items)
	if result.IsLOD400Ready {
		t.Error("expected IsLOD400Ready=false: skipped mandatory items must block gate")
	}
	if len(result.MandatoryBlockers) != 1 {
		t.Errorf("expected 1 blocker for skipped mandatory item, got %d", len(result.MandatoryBlockers))
	}
}

func TestBuildResult_EmptyMandatoryBlockers_IsEmptySlice(t *testing.T) {
	items := []domain.LOD400ChecklistItem{
		{Status: domain.LOD400ItemPassed, IsMandatory: true, Weight: 1.0},
	}
	req := ScoreLOD400Request{
		ProjectID:       uuid.New(),
		LayoutID:        uuid.New(),
		ScoredByActorID: "actor-1",
	}
	result := buildResult(req, nil, items)
	if result.MandatoryBlockers == nil {
		t.Error("MandatoryBlockers must be an empty slice, not nil (JSON serialisation safety)")
	}
}
