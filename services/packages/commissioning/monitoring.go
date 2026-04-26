package commissioning

import (
	"time"
)

// ========================================================================
// SCADA / Monitoring Data Models
// ========================================================================

// SCADAProtocol identifies the communication protocol for data ingestion.
type SCADAProtocol string

const (
	ProtocolModbusTCP SCADAProtocol = "modbus_tcp"
	ProtocolDNP3      SCADAProtocol = "dnp3"
	ProtocolOPCUA     SCADAProtocol = "opc_ua"
	ProtocolMQTT      SCADAProtocol = "mqtt"
	ProtocolHTTPAPI   SCADAProtocol = "http_api"
)

// SCADADataPoint is a single timestamped measurement from a monitoring system.
type SCADADataPoint struct {
	DeviceID    string    `json:"device_id"`     // inverter/meter/weather station ID
	Metric      string    `json:"metric"`        // "ac_power_kw", "dc_voltage", "energy_kwh", "irradiance", etc.
	Value       float64   `json:"value"`
	Unit        string    `json:"unit"`
	Quality     string    `json:"quality"`       // "good", "uncertain", "bad"
	Timestamp   time.Time `json:"timestamp"`
}

// StringMonitoringData is per-string current/voltage for fault detection.
type StringMonitoringData struct {
	InverterID  string    `json:"inverter_id"`
	MPPTID      int       `json:"mppt_id"`
	StringID    int       `json:"string_id"`
	CurrentA    float64   `json:"current_a"`
	VoltageV    float64   `json:"voltage_v"`
	PowerW      float64   `json:"power_w"`
	Timestamp   time.Time `json:"timestamp"`
}

// ========================================================================
// Inverter Fault Codes
// ========================================================================

// FaultCode maps vendor-specific fault codes to standardized descriptions.
type FaultCode struct {
	VendorCode   string `json:"vendor_code"`
	Vendor       string `json:"vendor"`        // "sungrow", "sma", "huawei", "solaredge"
	Description  string `json:"description"`
	Severity     string `json:"severity"`       // "info", "warning", "fault", "critical"
	Category     string `json:"category"`       // "grid", "dc_input", "temperature", "communication", "internal"
	Action       string `json:"recommended_action"`
}

// DefaultFaultDictionary returns common inverter fault codes across vendors.
func DefaultFaultDictionary() []FaultCode {
	return []FaultCode{
		// Sungrow
		{VendorCode: "SG-101", Vendor: "sungrow", Description: "Grid overvoltage", Severity: "warning", Category: "grid", Action: "Check grid voltage; may need utility coordination"},
		{VendorCode: "SG-102", Vendor: "sungrow", Description: "Grid undervoltage", Severity: "warning", Category: "grid", Action: "Check grid connection; verify voltage at POI"},
		{VendorCode: "SG-103", Vendor: "sungrow", Description: "Grid overfrequency", Severity: "warning", Category: "grid", Action: "Self-clearing; contact utility if persistent"},
		{VendorCode: "SG-201", Vendor: "sungrow", Description: "DC insulation fault", Severity: "critical", Category: "dc_input", Action: "LOTO and megger test all strings; check for ground fault"},
		{VendorCode: "SG-202", Vendor: "sungrow", Description: "DC overvoltage", Severity: "fault", Category: "dc_input", Action: "Check string configuration; reduce modules per string if needed"},
		{VendorCode: "SG-301", Vendor: "sungrow", Description: "Over-temperature shutdown", Severity: "fault", Category: "temperature", Action: "Check ventilation; clean air filters; verify ambient temp"},
		// SMA
		{VendorCode: "SMA-3501", Vendor: "sma", Description: "Insulation resistance too low", Severity: "critical", Category: "dc_input", Action: "Isolate and test DC circuits; check for moisture ingress"},
		{VendorCode: "SMA-3601", Vendor: "sma", Description: "Grid disturbance", Severity: "warning", Category: "grid", Action: "Self-clearing; log frequency and duration"},
		{VendorCode: "SMA-6002", Vendor: "sma", Description: "Internal communication error", Severity: "warning", Category: "communication", Action: "Restart inverter; update firmware if persistent"},
		// Huawei
		{VendorCode: "HW-2001", Vendor: "huawei", Description: "String reverse polarity", Severity: "critical", Category: "dc_input", Action: "LOTO immediately; verify string polarity before re-energizing"},
		{VendorCode: "HW-2011", Vendor: "huawei", Description: "PID detected", Severity: "warning", Category: "dc_input", Action: "Enable PID recovery mode; schedule nighttime recovery cycle"},
		{VendorCode: "HW-3001", Vendor: "huawei", Description: "Fan failure", Severity: "fault", Category: "temperature", Action: "Replace cooling fan; derate until repaired"},
	}
}

// ========================================================================
// Alarm Manager
// ========================================================================

// Alarm is an active or historical alarm event.
type Alarm struct {
	ID            string    `json:"id"`
	ProjectID     string    `json:"project_id"`
	DeviceID      string    `json:"device_id"`
	AlarmCode     string    `json:"alarm_code"`
	Description   string    `json:"description"`
	Priority      string    `json:"priority"`       // "critical", "high", "medium", "low"
	State         string    `json:"state"`           // "active", "acknowledged", "cleared"
	OccurredAt    time.Time `json:"occurred_at"`
	AcknowledgedAt *time.Time `json:"acknowledged_at,omitempty"`
	AcknowledgedBy string   `json:"acknowledged_by,omitempty"`
	ClearedAt     *time.Time `json:"cleared_at,omitempty"`
}

// ========================================================================
// Work Order System
// ========================================================================

// WorkOrder tracks a maintenance task from creation through completion.
type WorkOrder struct {
	ID            string     `json:"id"`
	ProjectID     string     `json:"project_id"`
	Title         string     `json:"title"`
	Description   string     `json:"description"`
	Category      string     `json:"category"`        // "corrective", "preventive", "emergency"
	Priority      string     `json:"priority"`         // "critical", "high", "medium", "low"
	Status        string     `json:"status"`           // "open", "dispatched", "in_progress", "complete"
	AssignedTo    string     `json:"assigned_to,omitempty"`
	RelatedAlarmID string    `json:"related_alarm_id,omitempty"`
	RelatedAssetID string    `json:"related_asset_id,omitempty"`
	CreatedAt     time.Time  `json:"created_at"`
	DispatchedAt  *time.Time `json:"dispatched_at,omitempty"`
	CompletedAt   *time.Time `json:"completed_at,omitempty"`
	CompletedBy   string     `json:"completed_by,omitempty"`
	ResolutionNotes string   `json:"resolution_notes,omitempty"`
}

// ========================================================================
// Preventive Maintenance Schedule
// ========================================================================

// PMSchedule defines a recurring maintenance task.
type PMSchedule struct {
	ID            string `json:"id"`
	ProjectID     string `json:"project_id"`
	TaskName      string `json:"task_name"`
	Description   string `json:"description"`
	FrequencyDays int    `json:"frequency_days"` // interval between executions
	Category      string `json:"category"`       // "inspection", "cleaning", "calibration", "replacement"
	Equipment     string `json:"equipment"`      // affected equipment type
	EstDurationHrs float64 `json:"est_duration_hrs"`
}

// DefaultPMSchedules returns standard preventive maintenance for utility-scale PV.
func DefaultPMSchedules(projectID string) []PMSchedule {
	return []PMSchedule{
		{ID: "pm-001", ProjectID: projectID, TaskName: "Module visual inspection", Description: "Walk-down visual inspection of all modules for cracks, discoloration, hotspots", FrequencyDays: 180, Category: "inspection", Equipment: "modules", EstDurationHrs: 8},
		{ID: "pm-002", ProjectID: projectID, TaskName: "Thermal IR scan (drone)", Description: "Drone-mounted IR camera scan of entire array", FrequencyDays: 365, Category: "inspection", Equipment: "modules", EstDurationHrs: 4},
		{ID: "pm-003", ProjectID: projectID, TaskName: "Inverter filter cleaning", Description: "Clean air intake filters on all inverters", FrequencyDays: 90, Category: "cleaning", Equipment: "inverters", EstDurationHrs: 2},
		{ID: "pm-004", ProjectID: projectID, TaskName: "Tracker lubrication", Description: "Lubricate tracker bearings and slew drives", FrequencyDays: 365, Category: "cleaning", Equipment: "trackers", EstDurationHrs: 4},
		{ID: "pm-005", ProjectID: projectID, TaskName: "Module washing", Description: "Pressure wash module surfaces (soiling mitigation)", FrequencyDays: 180, Category: "cleaning", Equipment: "modules", EstDurationHrs: 16},
		{ID: "pm-006", ProjectID: projectID, TaskName: "Revenue meter calibration", Description: "Verify revenue meter accuracy per utility requirements", FrequencyDays: 365, Category: "calibration", Equipment: "meters", EstDurationHrs: 2},
		{ID: "pm-007", ProjectID: projectID, TaskName: "Transformer oil analysis", Description: "Draw oil sample for DGA (dissolved gas analysis)", FrequencyDays: 365, Category: "inspection", Equipment: "transformers", EstDurationHrs: 1},
		{ID: "pm-008", ProjectID: projectID, TaskName: "Vegetation management", Description: "Mow / herbicide treatment under and around array", FrequencyDays: 90, Category: "cleaning", Equipment: "site", EstDurationHrs: 8},
	}
}

// ========================================================================
// Warranty Tracker
// ========================================================================

// WarrantyRecord tracks warranty terms for a specific asset.
type WarrantyRecord struct {
	ID               string    `json:"id"`
	ProjectID        string    `json:"project_id"`
	AssetSerialNumber string   `json:"asset_serial_number"`
	AssetType        string    `json:"asset_type"`        // "module", "inverter", "transformer"
	Manufacturer     string    `json:"manufacturer"`
	Model            string    `json:"model"`
	InstallDate      time.Time `json:"install_date"`
	ProductWarrantyYrs int     `json:"product_warranty_yrs"`   // material/manufacturing defects
	PerformanceWarrantyYrs int `json:"performance_warranty_yrs"` // power output guarantee (modules)
	ProductWarrantyEnd time.Time `json:"product_warranty_end"`
	PerformanceWarrantyEnd time.Time `json:"performance_warranty_end"`
	ClaimHistory     []WarrantyClaim `json:"claim_history,omitempty"`
}

// WarrantyClaim records a warranty claim event.
type WarrantyClaim struct {
	ClaimID     string    `json:"claim_id"`
	ClaimDate   time.Time `json:"claim_date"`
	IssueType   string    `json:"issue_type"`
	Description string    `json:"description"`
	Status      string    `json:"status"`     // "submitted", "approved", "denied", "resolved"
	Resolution  string    `json:"resolution,omitempty"`
}

// ========================================================================
// Degradation Analysis
// ========================================================================

// AnnualPRRecord is one year's performance ratio measurement.
type AnnualPRRecord struct {
	Year           int     `json:"year"`
	AnnualEnergyKWh float64 `json:"annual_energy_kwh"`
	AnnualGHIKWhM2 float64  `json:"annual_ghi_kwh_m2"`
	PR             float64 `json:"pr"`
}

// DegradationAnalysis computes year-over-year PR degradation rate.
type DegradationAnalysis struct {
	ProjectID          string           `json:"project_id"`
	Records            []AnnualPRRecord `json:"records"`
	DegradationRatePct float64          `json:"degradation_rate_pct"` // annual % decline
	WarrantyCompliant  bool             `json:"warranty_compliant"`
	WarrantyLimitPct   float64          `json:"warranty_limit_pct"`   // typically 0.5-0.7%/year
}

// ComputeDegradation fits a linear trend to year-over-year PR data and
// extracts the annual degradation rate.
func ComputeDegradation(records []AnnualPRRecord, warrantyLimitPct float64) *DegradationAnalysis {
	d := &DegradationAnalysis{
		Records:          records,
		WarrantyLimitPct: warrantyLimitPct,
	}

	n := len(records)
	if n < 2 {
		return d
	}

	// Linear regression: PR = a + b × year
	var sumX, sumY, sumXY, sumX2 float64
	for _, r := range records {
		x := float64(r.Year)
		y := r.PR
		sumX += x
		sumY += y
		sumXY += x * y
		sumX2 += x * x
	}
	nf := float64(n)
	denom := nf*sumX2 - sumX*sumX
	if denom == 0 {
		return d
	}
	b := (nf*sumXY - sumX*sumY) / denom // slope (%PR per year)

	// Degradation rate = -slope (positive means declining)
	// Normalise to first year's PR
	if records[0].PR > 0 {
		d.DegradationRatePct = -b / records[0].PR * 100.0
	}
	d.WarrantyCompliant = d.DegradationRatePct <= warrantyLimitPct
	return d
}
