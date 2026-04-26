package construction

import (
	"testing"
	"time"
)

func TestConstructionGate_AllReady(t *testing.T) {
	input := &ConstructionGateInput{
		DesignApproved: true, ProcurementReady: true, PermitsObtained: true,
		SiteAccessConfirmed: true, EnvironmentalClearance: true,
		InterconnectionAgreed: true, InsuranceInPlace: true,
	}
	result := EvaluateConstructionGate(input)
	if !result.CanProceed {
		t.Errorf("should proceed: blockers=%v", result.BlockerReasons)
	}
	if result.ReadyCount != 7 {
		t.Errorf("ready count: got %d, want 7", result.ReadyCount)
	}
}

func TestConstructionGate_MissingPermits(t *testing.T) {
	input := &ConstructionGateInput{
		DesignApproved: true, ProcurementReady: true, PermitsObtained: false,
		SiteAccessConfirmed: true, EnvironmentalClearance: true,
		InterconnectionAgreed: true, InsuranceInPlace: true,
	}
	result := EvaluateConstructionGate(input)
	if result.CanProceed {
		t.Error("should NOT proceed: permits missing")
	}
	if len(result.BlockerReasons) != 1 {
		t.Errorf("expected 1 blocker, got %d: %v", len(result.BlockerReasons), result.BlockerReasons)
	}
}

func TestDefaultMilestones(t *testing.T) {
	ms := DefaultMilestones("proj-001", time.Date(2026, 6, 1, 0, 0, 0, 0, time.UTC))
	if len(ms) != 10 {
		t.Errorf("expected 10 milestones, got %d", len(ms))
	}
	for _, m := range ms {
		if m.ProjectID != "proj-001" {
			t.Errorf("wrong project ID: %s", m.ProjectID)
		}
		if m.Status != MilestoneNotStarted {
			t.Errorf("milestone %s should be not_started", m.ID)
		}
	}
	// Last milestone should be after first
	if !ms[9].PlannedDate.After(ms[0].PlannedDate) {
		t.Error("last milestone should be after first")
	}
}

func TestEVM(t *testing.T) {
	evm := ComputeEVM(1000000, 800000, 900000, 5000000)
	if evm.CPI >= 1.0 {
		t.Errorf("CPI should be < 1.0 (over budget): got %.2f", evm.CPI)
	}
	if evm.SPI >= 1.0 {
		t.Errorf("SPI should be < 1.0 (behind schedule): got %.2f", evm.SPI)
	}
	status := evm.HealthStatus()
	if status != "over_budget_behind_schedule" {
		t.Errorf("status: got %s", status)
	}
}

func TestQCChecklist_Foundation(t *testing.T) {
	cl := DefaultFoundationChecklist("proj-001", "Block A")
	if len(cl.Items) == 0 {
		t.Fatal("checklist should have items")
	}
	if cl.OverallStatus != "not_started" {
		t.Errorf("should be not_started: got %s", cl.OverallStatus)
	}

	// Mark all as passed
	for i := range cl.Items {
		cl.Items[i].PassFail = "pass"
	}
	EvaluateChecklist(cl)
	if cl.OverallStatus != "passed" {
		t.Errorf("all passed but status: %s", cl.OverallStatus)
	}
}

func TestQCChecklist_FailureBlocksPass(t *testing.T) {
	cl := DefaultModuleChecklist("proj-001", "Block B")
	for i := range cl.Items {
		cl.Items[i].PassFail = "pass"
	}
	cl.Items[0].PassFail = "fail" // one failure
	EvaluateChecklist(cl)
	if cl.OverallStatus != "failed" {
		t.Errorf("one failure should fail checklist: got %s", cl.OverallStatus)
	}
}

func TestAsBuiltSummary(t *testing.T) {
	now := time.Now()
	deviations := []AsBuiltDeviation{
		{Severity: "critical", RequiresRedesign: true},
		{Severity: "major"},
		{Severity: "minor", ResolvedAt: &now},
	}
	s := SummarizeAsBuilt("proj-001", deviations)
	if s.TotalDeviations != 3 { t.Errorf("total: %d", s.TotalDeviations) }
	if s.Critical != 1 { t.Errorf("critical: %d", s.Critical) }
	if s.RequiresRedesign != 1 { t.Errorf("redesign: %d", s.RequiresRedesign) }
	if s.Resolved != 1 { t.Errorf("resolved: %d", s.Resolved) }
}

func TestJSATemplates(t *testing.T) {
	templates := DefaultJSATemplates()
	if len(templates) != 3 {
		t.Errorf("expected 3 JSA templates, got %d", len(templates))
	}
	for _, tmpl := range templates {
		if len(tmpl.Steps) == 0 {
			t.Errorf("JSA %s has no steps", tmpl.ID)
		}
		for _, step := range tmpl.Steps {
			if len(step.Hazards) == 0 {
				t.Errorf("JSA %s step %d has no hazards", tmpl.ID, step.StepNumber)
			}
			if len(step.Controls) == 0 {
				t.Errorf("JSA %s step %d has no controls", tmpl.ID, step.StepNumber)
			}
			if len(step.PPERequired) == 0 {
				t.Errorf("JSA %s step %d has no PPE", tmpl.ID, step.StepNumber)
			}
		}
	}
}

func TestPlacementVerification(t *testing.T) {
	// Two points ~11m apart (0.0001° latitude ≈ 11.1m)
	err, within := VerifyPlacement(34.0500, -118.2500, 34.0501, -118.2500, 15.0)
	if err < 10.0 || err > 13.0 {
		t.Errorf("expected ~11m error, got %.1f", err)
	}
	if !within {
		t.Errorf("should be within 15m tolerance: error=%.1f", err)
	}

	// Same test with tight tolerance
	_, within = VerifyPlacement(34.0500, -118.2500, 34.0501, -118.2500, 5.0)
	if within {
		t.Error("should NOT be within 5m tolerance")
	}
}
