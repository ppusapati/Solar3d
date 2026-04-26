package construction

import (
	"time"
)

// ========================================================================
// As-Built vs As-Designed Comparison
// ========================================================================

// AsBuiltDeviation records a difference between the design model and
// what was actually installed in the field.
type AsBuiltDeviation struct {
	ID               string    `json:"id"`
	ProjectID        string    `json:"project_id"`
	ComponentType    string    `json:"component_type"`    // "module", "inverter", "racking", "cable", "foundation"
	DesignAssetID    string    `json:"design_asset_id"`   // from layout-service
	InstalledAssetID string    `json:"installed_asset_id"` // from field scan
	DeviationType    string    `json:"deviation_type"`    // "position", "model_substitution", "orientation", "missing", "extra"
	Description      string    `json:"description"`
	DesignValue      string    `json:"design_value"`
	AsBuiltValue     string    `json:"as_built_value"`
	PositionDeltaM   float64   `json:"position_delta_m,omitempty"`  // distance from design position
	OrientationDelta float64   `json:"orientation_delta_deg,omitempty"`
	Severity         string    `json:"severity"`          // "critical", "major", "minor", "info"
	RequiresRedesign bool      `json:"requires_redesign"`
	ReportedBy       string    `json:"reported_by"`
	ReportedAt       time.Time `json:"reported_at"`
	ResolvedAt       *time.Time `json:"resolved_at,omitempty"`
	Resolution       string    `json:"resolution,omitempty"`
}

// AsBuiltSummary summarizes deviations for a project.
type AsBuiltSummary struct {
	ProjectID       string `json:"project_id"`
	TotalDeviations int    `json:"total_deviations"`
	Critical        int    `json:"critical"`
	Major           int    `json:"major"`
	Minor           int    `json:"minor"`
	RequiresRedesign int   `json:"requires_redesign"`
	Resolved         int   `json:"resolved"`
}

// Summarize computes the as-built summary from a list of deviations.
func SummarizeAsBuilt(projectID string, deviations []AsBuiltDeviation) *AsBuiltSummary {
	s := &AsBuiltSummary{
		ProjectID:       projectID,
		TotalDeviations: len(deviations),
	}
	for _, d := range deviations {
		switch d.Severity {
		case "critical":
			s.Critical++
		case "major":
			s.Major++
		case "minor":
			s.Minor++
		}
		if d.RequiresRedesign {
			s.RequiresRedesign++
		}
		if d.ResolvedAt != nil {
			s.Resolved++
		}
	}
	return s
}

// ========================================================================
// QC Checklists
// ========================================================================

// QCChecklistType identifies the construction phase for the checklist.
type QCChecklistType string

const (
	QCFoundation QCChecklistType = "foundation"
	QCRacking    QCChecklistType = "racking"
	QCModule     QCChecklistType = "module_install"
	QCElectrical QCChecklistType = "electrical"
)

// QCChecklistItem is a single inspection point.
type QCChecklistItem struct {
	ID              string  `json:"id"`
	Section         string  `json:"section"`          // grouping within the checklist
	Description     string  `json:"description"`
	InspectionCriteria string `json:"inspection_criteria"`
	PassFail        string  `json:"pass_fail"`        // "pass", "fail", "na", ""
	Notes           string  `json:"notes,omitempty"`
	PhotoRequired   bool    `json:"photo_required"`
	PhotoURL        string  `json:"photo_url,omitempty"`
	InspectedBy     string  `json:"inspected_by,omitempty"`
	InspectedAt     *time.Time `json:"inspected_at,omitempty"`
}

// QCChecklist is a complete inspection checklist for a construction phase.
type QCChecklist struct {
	ID            string            `json:"id"`
	ProjectID     string            `json:"project_id"`
	Type          QCChecklistType   `json:"type"`
	Area          string            `json:"area"`           // site area / block identifier
	Items         []QCChecklistItem `json:"items"`
	OverallStatus string            `json:"overall_status"` // "not_started", "in_progress", "passed", "failed"
	CreatedAt     time.Time         `json:"created_at"`
	CompletedAt   *time.Time        `json:"completed_at,omitempty"`
	SignedOffBy   string            `json:"signed_off_by,omitempty"`
}

// DefaultFoundationChecklist returns the standard QC checklist for foundation work.
func DefaultFoundationChecklist(projectID, area string) *QCChecklist {
	return &QCChecklist{
		ProjectID: projectID, Type: QCFoundation, Area: area, OverallStatus: "not_started",
		CreatedAt: time.Now().UTC(),
		Items: []QCChecklistItem{
			{ID: "fnd-01", Section: "Survey", Description: "Pile locations staked per layout drawing", InspectionCriteria: "Within ±50mm of design coordinates", PhotoRequired: true},
			{ID: "fnd-02", Section: "Survey", Description: "Ground elevation matches grading plan", InspectionCriteria: "Within ±100mm of design elevation", PhotoRequired: false},
			{ID: "fnd-03", Section: "Pile Driving", Description: "Pile embedment depth meets design", InspectionCriteria: "Minimum depth per structural engineer spec", PhotoRequired: true},
			{ID: "fnd-04", Section: "Pile Driving", Description: "Pile plumb within tolerance", InspectionCriteria: "Vertical within 2° of plumb", PhotoRequired: true},
			{ID: "fnd-05", Section: "Pile Driving", Description: "Pull-out test passed (sample basis)", InspectionCriteria: "Load test per IBC 1810.3.3.1.2 at 200% design load", PhotoRequired: true},
			{ID: "fnd-06", Section: "Concrete", Description: "Concrete slump test (if applicable)", InspectionCriteria: "Within specified range (typically 4-6 inches)", PhotoRequired: false},
			{ID: "fnd-07", Section: "Grounding", Description: "Ground rod installed at pile", InspectionCriteria: "Connected to EGC per NEC 250", PhotoRequired: true},
		},
	}
}

// DefaultRackingChecklist returns the QC checklist for racking/tracker installation.
func DefaultRackingChecklist(projectID, area string) *QCChecklist {
	return &QCChecklist{
		ProjectID: projectID, Type: QCRacking, Area: area, OverallStatus: "not_started",
		CreatedAt: time.Now().UTC(),
		Items: []QCChecklistItem{
			{ID: "rck-01", Section: "Assembly", Description: "Torque tube/purlin bolts torqued to spec", InspectionCriteria: "Per manufacturer torque values with calibrated wrench", PhotoRequired: false},
			{ID: "rck-02", Section: "Assembly", Description: "Clamp spacing per layout", InspectionCriteria: "Module clamps at manufacturer-specified positions", PhotoRequired: true},
			{ID: "rck-03", Section: "Alignment", Description: "Row alignment within tolerance", InspectionCriteria: "Straight within ±25mm over 100m", PhotoRequired: true},
			{ID: "rck-04", Section: "Alignment", Description: "Tilt angle matches design", InspectionCriteria: "Within ±0.5° of design tilt", PhotoRequired: true},
			{ID: "rck-05", Section: "Grounding", Description: "Racking grounding continuity", InspectionCriteria: "< 25Ω resistance per NEC 250.53(A)(2)", PhotoRequired: false},
			{ID: "rck-06", Section: "Tracker", Description: "Tracker motor/actuator functional test", InspectionCriteria: "Full range rotation ±60° without binding", PhotoRequired: true},
		},
	}
}

// DefaultModuleChecklist returns the QC checklist for module installation.
func DefaultModuleChecklist(projectID, area string) *QCChecklist {
	return &QCChecklist{
		ProjectID: projectID, Type: QCModule, Area: area, OverallStatus: "not_started",
		CreatedAt: time.Now().UTC(),
		Items: []QCChecklistItem{
			{ID: "mod-01", Section: "Visual", Description: "Module face free of defects (cracks, chips, discoloration)", InspectionCriteria: "100% visual inspection per IEC 61215", PhotoRequired: true},
			{ID: "mod-02", Section: "Visual", Description: "Module serial numbers recorded and match BOM", InspectionCriteria: "Barcode scan matches asset-service identity", PhotoRequired: true},
			{ID: "mod-03", Section: "Mechanical", Description: "Module clamp engagement verified", InspectionCriteria: "All clamps seated with correct torque", PhotoRequired: false},
			{ID: "mod-04", Section: "Electrical", Description: "String Voc measured and within spec", InspectionCriteria: "Within ±5% of design Voc at current temperature", PhotoRequired: false},
			{ID: "mod-05", Section: "Electrical", Description: "String polarity verified", InspectionCriteria: "Positive to positive, negative to negative per stringing diagram", PhotoRequired: false},
			{ID: "mod-06", Section: "Electrical", Description: "Connector seating verified (MC4 click test)", InspectionCriteria: "Audible click + pull test at 40N", PhotoRequired: false},
			{ID: "mod-07", Section: "Insulation", Description: "Insulation resistance test (megger)", InspectionCriteria: "> 40MΩ per IEC 62446-1 §7.3", PhotoRequired: true},
		},
	}
}

// DefaultElectricalChecklist returns the QC checklist for electrical work.
func DefaultElectricalChecklist(projectID, area string) *QCChecklist {
	return &QCChecklist{
		ProjectID: projectID, Type: QCElectrical, Area: area, OverallStatus: "not_started",
		CreatedAt: time.Now().UTC(),
		Items: []QCChecklistItem{
			{ID: "elc-01", Section: "Combiner", Description: "Fuse ratings match design", InspectionCriteria: "Fuse amp rating per electrical design BOM", PhotoRequired: true},
			{ID: "elc-02", Section: "Combiner", Description: "String current balance", InspectionCriteria: "All strings within ±10% of mean Isc", PhotoRequired: false},
			{ID: "elc-03", Section: "Inverter", Description: "Inverter commissioning test passed", InspectionCriteria: "Per manufacturer commissioning checklist", PhotoRequired: true},
			{ID: "elc-04", Section: "Inverter", Description: "MPPT assignment matches stringing diagram", InspectionCriteria: "Each string connected to correct MPPT input", PhotoRequired: false},
			{ID: "elc-05", Section: "Grounding", Description: "GEC continuity verified", InspectionCriteria: "< 25Ω per NEC 250.53", PhotoRequired: false},
			{ID: "elc-06", Section: "Transformer", Description: "Transformer turns ratio test", InspectionCriteria: "Within ±0.5% of nameplate ratio", PhotoRequired: false},
			{ID: "elc-07", Section: "Protection", Description: "Protective relay settings verified", InspectionCriteria: "Settings match protection coordination study", PhotoRequired: true},
			{ID: "elc-08", Section: "Labeling", Description: "All equipment labeled per NEC 690.31(G)", InspectionCriteria: "DC warning labels at all access points", PhotoRequired: true},
		},
	}
}

// EvaluateChecklist computes the overall status from item results.
func EvaluateChecklist(cl *QCChecklist) {
	total := len(cl.Items)
	passed := 0
	failed := 0
	inspected := 0

	for _, item := range cl.Items {
		switch item.PassFail {
		case "pass":
			passed++
			inspected++
		case "fail":
			failed++
			inspected++
		case "na":
			inspected++
			passed++ // N/A counts as acceptable
		}
	}

	if inspected == 0 {
		cl.OverallStatus = "not_started"
	} else if failed > 0 {
		cl.OverallStatus = "failed"
	} else if passed == total {
		cl.OverallStatus = "passed"
	} else {
		cl.OverallStatus = "in_progress"
	}
}

// ========================================================================
// Punch List
// ========================================================================

// PunchItem is an outstanding issue found during QC inspection.
type PunchItem struct {
	ID            string     `json:"id"`
	ProjectID     string     `json:"project_id"`
	Area          string     `json:"area"`
	Description   string     `json:"description"`
	Category      string     `json:"category"`       // "electrical", "mechanical", "cosmetic", "safety"
	Priority      string     `json:"priority"`        // "critical", "high", "medium", "low"
	AssignedTo    string     `json:"assigned_to"`
	PhotoURL      string     `json:"photo_url,omitempty"`
	Latitude      float64    `json:"latitude,omitempty"`
	Longitude     float64    `json:"longitude,omitempty"`
	Status        string     `json:"status"`          // "open", "in_progress", "resolved", "verified"
	CreatedBy     string     `json:"created_by"`
	CreatedAt     time.Time  `json:"created_at"`
	ResolvedAt    *time.Time `json:"resolved_at,omitempty"`
	ResolvedBy    string     `json:"resolved_by,omitempty"`
	VerifiedAt    *time.Time `json:"verified_at,omitempty"`
	VerifiedBy    string     `json:"verified_by,omitempty"`
}

// ========================================================================
// Non-Conformance Report (NCR)
// ========================================================================

// NCR documents a deviation from design that requires formal disposition.
type NCR struct {
	ID               string     `json:"id"`
	ProjectID        string     `json:"project_id"`
	Title            string     `json:"title"`
	Description      string     `json:"description"`
	RootCause        string     `json:"root_cause"`
	AffectedArea     string     `json:"affected_area"`
	AffectedAssets   []string   `json:"affected_assets"`
	ImpactAssessment string     `json:"impact_assessment"`     // "no_impact", "minor_rework", "major_rework", "redesign_required"
	Disposition      string     `json:"disposition"`           // "use_as_is", "rework", "repair", "reject_replace"
	CorrectiveAction string     `json:"corrective_action"`
	PreventiveAction string     `json:"preventive_action"`
	Status           string     `json:"status"`                // "open", "dispositioned", "closed"
	IssuedBy         string     `json:"issued_by"`
	IssuedAt         time.Time  `json:"issued_at"`
	DispositionedBy  string     `json:"dispositioned_by,omitempty"`
	DispositionedAt  *time.Time `json:"dispositioned_at,omitempty"`
	ClosedBy         string     `json:"closed_by,omitempty"`
	ClosedAt         *time.Time `json:"closed_at,omitempty"`
}
