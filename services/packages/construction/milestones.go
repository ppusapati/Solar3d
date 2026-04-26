// Package construction provides construction-phase domain models and logic
// for the design↔construction bridge in Solar3D. Full construction management
// (scheduling, crew, daily reports, RFI) is handled by external platforms
// (Procore, P6); this package owns the data that references the design model.
package construction

import (
	"fmt"
	"time"
)

// ========================================================================
// Milestones
// ========================================================================

// MilestoneStatus tracks progress of a construction milestone.
type MilestoneStatus string

const (
	MilestoneNotStarted MilestoneStatus = "not_started"
	MilestoneInProgress MilestoneStatus = "in_progress"
	MilestoneCompleted  MilestoneStatus = "completed"
	MilestoneBlocked    MilestoneStatus = "blocked"
)

// Milestone is a key construction event tied to the project workflow.
type Milestone struct {
	ID              string          `json:"id"`
	ProjectID       string          `json:"project_id"`
	Name            string          `json:"name"`
	Description     string          `json:"description,omitempty"`
	Phase           string          `json:"phase"`         // "foundation", "racking", "module_install", "electrical", "commissioning"
	PlannedDate     time.Time       `json:"planned_date"`
	ActualDate      *time.Time      `json:"actual_date,omitempty"`
	Status          MilestoneStatus `json:"status"`
	DependsOn       []string        `json:"depends_on,omitempty"` // milestone IDs
	CompletedBy     string          `json:"completed_by,omitempty"`
	BlockerReason   string          `json:"blocker_reason,omitempty"`
	ExternalRef     string          `json:"external_ref,omitempty"` // Procore/P6 task ID
}

// DefaultMilestones returns the standard milestone set for a utility-scale
// solar construction project.
func DefaultMilestones(projectID string, constructionStart time.Time) []Milestone {
	day := 24 * time.Hour
	return []Milestone{
		{ID: "ms-001", ProjectID: projectID, Name: "Site mobilization", Phase: "foundation", PlannedDate: constructionStart, Status: MilestoneNotStarted},
		{ID: "ms-002", ProjectID: projectID, Name: "Survey & staking complete", Phase: "foundation", PlannedDate: constructionStart.Add(7 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-001"}},
		{ID: "ms-003", ProjectID: projectID, Name: "Grading complete", Phase: "foundation", PlannedDate: constructionStart.Add(21 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-002"}},
		{ID: "ms-004", ProjectID: projectID, Name: "Pile driving complete", Phase: "foundation", PlannedDate: constructionStart.Add(42 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-003"}},
		{ID: "ms-005", ProjectID: projectID, Name: "Racking installed", Phase: "racking", PlannedDate: constructionStart.Add(63 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-004"}},
		{ID: "ms-006", ProjectID: projectID, Name: "Module installation complete", Phase: "module_install", PlannedDate: constructionStart.Add(84 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-005"}},
		{ID: "ms-007", ProjectID: projectID, Name: "DC wiring complete", Phase: "electrical", PlannedDate: constructionStart.Add(98 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-006"}},
		{ID: "ms-008", ProjectID: projectID, Name: "Inverter commissioning", Phase: "electrical", PlannedDate: constructionStart.Add(105 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-007"}},
		{ID: "ms-009", ProjectID: projectID, Name: "Transformer energization", Phase: "electrical", PlannedDate: constructionStart.Add(112 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-008"}},
		{ID: "ms-010", ProjectID: projectID, Name: "Substantial completion", Phase: "commissioning", PlannedDate: constructionStart.Add(120 * day), Status: MilestoneNotStarted, DependsOn: []string{"ms-009"}},
	}
}

// ========================================================================
// Construction Readiness Gate
// ========================================================================

// ConstructionGateInput collects all prerequisites for the construction gate.
type ConstructionGateInput struct {
	DesignApproved        bool   `json:"design_approved"`
	ProcurementReady      bool   `json:"procurement_ready"`      // from ERP gate
	PermitsObtained       bool   `json:"permits_obtained"`
	SiteAccessConfirmed   bool   `json:"site_access_confirmed"`
	EnvironmentalClearance bool  `json:"environmental_clearance"`
	InterconnectionAgreed bool   `json:"interconnection_agreed"`
	InsuranceInPlace      bool   `json:"insurance_in_place"`
}

// ConstructionGateResult is the go/no-go decision.
type ConstructionGateResult struct {
	CanProceed     bool     `json:"can_proceed"`
	BlockerReasons []string `json:"blocker_reasons,omitempty"`
	ReadyCount     int      `json:"ready_count"`
	TotalChecks    int      `json:"total_checks"`
}

// EvaluateConstructionGate checks all prerequisites.
func EvaluateConstructionGate(input *ConstructionGateInput) *ConstructionGateResult {
	result := &ConstructionGateResult{TotalChecks: 7}

	checks := []struct {
		ready  bool
		reason string
	}{
		{input.DesignApproved, "design not approved (workflow phase < APPROVED)"},
		{input.ProcurementReady, "critical materials not procured (ERP procurement gate failed)"},
		{input.PermitsObtained, "building/electrical permits not obtained"},
		{input.SiteAccessConfirmed, "site access not confirmed with landowner"},
		{input.EnvironmentalClearance, "environmental clearance pending"},
		{input.InterconnectionAgreed, "interconnection agreement not executed"},
		{input.InsuranceInPlace, "builder's risk / liability insurance not in place"},
	}

	for _, c := range checks {
		if c.ready {
			result.ReadyCount++
		} else {
			result.BlockerReasons = append(result.BlockerReasons, c.reason)
		}
	}

	result.CanProceed = result.ReadyCount == result.TotalChecks
	return result
}

// ========================================================================
// EVM Summary (manual input or from external scheduler)
// ========================================================================

// EVMSummary holds Earned Value Management metrics for progress reporting.
type EVMSummary struct {
	ProjectID       string    `json:"project_id"`
	AsOfDate        time.Time `json:"as_of_date"`
	PlannedValueUSD float64   `json:"planned_value_usd"`  // PV (BCWS)
	EarnedValueUSD  float64   `json:"earned_value_usd"`   // EV (BCWP)
	ActualCostUSD   float64   `json:"actual_cost_usd"`    // AC (ACWP)
	CPI             float64   `json:"cpi"`                // EV/AC
	SPI             float64   `json:"spi"`                // EV/PV
	EstimateAtCompletion float64 `json:"eac_usd"`         // BAC/CPI
	VarianceAtCompletion float64 `json:"vac_usd"`         // BAC - EAC
}

// ComputeEVM calculates EVM metrics from raw values.
func ComputeEVM(pv, ev, ac, budgetAtCompletion float64) *EVMSummary {
	evm := &EVMSummary{
		PlannedValueUSD: pv,
		EarnedValueUSD:  ev,
		ActualCostUSD:   ac,
		AsOfDate:        time.Now().UTC(),
	}

	if ac > 0 {
		evm.CPI = ev / ac
	}
	if pv > 0 {
		evm.SPI = ev / pv
	}
	if evm.CPI > 0 {
		evm.EstimateAtCompletion = budgetAtCompletion / evm.CPI
	}
	evm.VarianceAtCompletion = budgetAtCompletion - evm.EstimateAtCompletion

	return evm
}

// EVMHealthStatus returns a human-readable assessment.
func (e *EVMSummary) HealthStatus() string {
	switch {
	case e.CPI >= 1.0 && e.SPI >= 1.0:
		return "on_budget_on_schedule"
	case e.CPI >= 1.0 && e.SPI < 1.0:
		return "on_budget_behind_schedule"
	case e.CPI < 1.0 && e.SPI >= 1.0:
		return "over_budget_on_schedule"
	default:
		return "over_budget_behind_schedule"
	}
}

// FormatSummary returns a text summary for reporting.
func (e *EVMSummary) FormatSummary() string {
	return fmt.Sprintf("EVM as of %s: PV=$%.0f EV=$%.0f AC=$%.0f | CPI=%.2f SPI=%.2f | EAC=$%.0f VAC=$%.0f | %s",
		e.AsOfDate.Format("2006-01-02"), e.PlannedValueUSD, e.EarnedValueUSD, e.ActualCostUSD,
		e.CPI, e.SPI, e.EstimateAtCompletion, e.VarianceAtCompletion, e.HealthStatus())
}
