package commissioning

import (
	"time"
)

// ========================================================================
// Thermal Imagery Ingest
// ========================================================================

// ThermalImage represents a thermal IR scan of a module or string,
// captured by drone-mounted FLIR, DJI Zenmuse XT2, or handheld camera.
type ThermalImage struct {
	ID             string    `json:"id"`
	ProjectID      string    `json:"project_id"`
	FilePath       string    `json:"file_path"`       // S3 / local path to RJPEG or TIFF
	Format         string    `json:"format"`           // "flir_rjpeg", "dji_rjpeg", "tiff_16bit"
	CapturedAt     time.Time `json:"captured_at"`
	CapturedBy     string    `json:"captured_by"`      // operator or drone ID
	Latitude       float64   `json:"latitude"`
	Longitude      float64   `json:"longitude"`
	AltitudeM      float64   `json:"altitude_m"`       // flight altitude AGL

	// Temperature data
	MinTempC       float64   `json:"min_temp_c"`
	MaxTempC       float64   `json:"max_temp_c"`
	MeanTempC      float64   `json:"mean_temp_c"`
	AmbientTempC   float64   `json:"ambient_temp_c"`
	Emissivity     float64   `json:"emissivity"`       // typically 0.85–0.95 for glass

	// Anomaly detection
	Anomalies      []ThermalAnomaly `json:"anomalies,omitempty"`
}

// ThermalAnomaly is a detected hot spot or cold spot on a module.
type ThermalAnomaly struct {
	ID              string  `json:"id"`
	AnomalyType     string  `json:"anomaly_type"`    // "hot_spot", "hot_cell", "bypass_diode", "string_fault", "delamination", "junction_box"
	Severity        string  `json:"severity"`         // "critical" (ΔT>20°C), "major" (10-20°C), "minor" (5-10°C)
	DeltaTempC      float64 `json:"delta_temp_c"`     // temperature difference from mean
	MaxTempC        float64 `json:"max_temp_c"`
	LocationX       float64 `json:"location_x"`       // pixel coordinates in image
	LocationY       float64 `json:"location_y"`
	AffectedModuleID string `json:"affected_module_id,omitempty"`
	AffectedStringID string `json:"affected_string_id,omitempty"`
	RecommendedAction string `json:"recommended_action"`
}

// ClassifyThermalAnomaly assigns type and severity based on temperature delta.
func ClassifyThermalAnomaly(deltaT, maxTemp float64) (anomalyType, severity, action string) {
	switch {
	case deltaT >= 20:
		severity = "critical"
		if maxTemp > 85 {
			anomalyType = "hot_spot"
			action = "immediate replacement — fire risk per IEC TS 62446-3"
		} else {
			anomalyType = "bypass_diode"
			action = "replace bypass diode; check affected sub-string"
		}
	case deltaT >= 10:
		severity = "major"
		anomalyType = "hot_cell"
		action = "schedule replacement within 30 days; monitor for degradation"
	case deltaT >= 5:
		severity = "minor"
		anomalyType = "hot_cell"
		action = "monitor at next scheduled inspection"
	default:
		severity = "info"
		anomalyType = "normal"
		action = "no action required"
	}
	return
}

// ========================================================================
// Insulation Resistance / PI Test
// ========================================================================

// InsulationResistanceTest records a megohmmeter (megger) test per IEC 62446-1 §7.3.
type InsulationResistanceTest struct {
	ID               string    `json:"id"`
	ProjectID        string    `json:"project_id"`
	StringID         string    `json:"string_id"`
	TestVoltageV     float64   `json:"test_voltage_v"`      // typically 1000V or 1500V
	ResistanceMOhm   float64   `json:"resistance_mohm"`     // measured insulation resistance
	MinRequiredMOhm  float64   `json:"min_required_mohm"`   // per IEC: 40 MΩ for ≤1000V, 40 MΩ for >1000V
	PassFail         string    `json:"pass_fail"`
	TestedAt         time.Time `json:"tested_at"`
	TestedBy         string    `json:"tested_by"`
	AmbientTempC     float64   `json:"ambient_temp_c"`
	HumidityPct      float64   `json:"humidity_pct"`
	Notes            string    `json:"notes,omitempty"`
}

// EvaluateInsulationTest checks if the measured resistance meets the IEC minimum.
func EvaluateInsulationTest(t *InsulationResistanceTest) {
	// IEC 62446-1 §7.3: minimum 40 MΩ at test voltage
	if t.MinRequiredMOhm == 0 {
		t.MinRequiredMOhm = 40.0
	}
	if t.ResistanceMOhm >= t.MinRequiredMOhm {
		t.PassFail = "pass"
	} else {
		t.PassFail = "fail"
	}
}

// PolarizationIndexTest records a PI test (10-minute insulation resistance ratio).
type PolarizationIndexTest struct {
	ID              string    `json:"id"`
	ProjectID       string    `json:"project_id"`
	EquipmentID     string    `json:"equipment_id"`    // transformer, cable, etc.
	R1MinMOhm      float64   `json:"r_1min_mohm"`     // resistance at 1 minute
	R10MinMOhm     float64   `json:"r_10min_mohm"`    // resistance at 10 minutes
	PI              float64   `json:"pi"`              // R10/R1 — should be > 2.0
	PassFail        string    `json:"pass_fail"`
	TestedAt        time.Time `json:"tested_at"`
	TestedBy        string    `json:"tested_by"`
}

// EvaluatePITest computes the Polarization Index and evaluates per IEEE 43.
func EvaluatePITest(t *PolarizationIndexTest) {
	if t.R1MinMOhm > 0 {
		t.PI = t.R10MinMOhm / t.R1MinMOhm
	}
	// IEEE 43: PI > 2.0 = good, 1.0-2.0 = questionable, < 1.0 = bad
	if t.PI >= 2.0 {
		t.PassFail = "pass"
	} else if t.PI >= 1.0 {
		t.PassFail = "marginal"
	} else {
		t.PassFail = "fail"
	}
}

// ========================================================================
// Performance Ratio Validation
// ========================================================================

// PRValidation compares measured PR against the simulation model prediction.
type PRValidation struct {
	ProjectID         string  `json:"project_id"`
	MeasurementPeriod string  `json:"measurement_period"`  // "7-day", "30-day"
	MeasuredEnergyKWh float64 `json:"measured_energy_kwh"` // revenue-grade meter
	SimulatedEnergyKWh float64 `json:"simulated_energy_kwh"`
	MeasuredPR        float64 `json:"measured_pr"`         // measured / (GHI × capacity)
	SimulatedPR       float64 `json:"simulated_pr"`
	PRRatio           float64 `json:"pr_ratio"`            // measured / simulated
	DeviationPct      float64 `json:"deviation_pct"`
	AcceptanceThreshold float64 `json:"acceptance_threshold"` // typically 0.95 (5% tolerance)
	PassFail          string  `json:"pass_fail"`
}

// ValidatePR compares measured vs simulated energy and determines acceptance.
func ValidatePR(
	measuredKWh, simulatedKWh, measuredGHIKWhM2, systemCapacityKW, acceptanceThreshold float64,
) *PRValidation {
	v := &PRValidation{
		MeasuredEnergyKWh:   measuredKWh,
		SimulatedEnergyKWh:  simulatedKWh,
		AcceptanceThreshold: acceptanceThreshold,
	}

	if measuredGHIKWhM2 > 0 && systemCapacityKW > 0 {
		v.MeasuredPR = measuredKWh / (measuredGHIKWhM2 * systemCapacityKW)
	}
	if simulatedKWh > 0 {
		v.PRRatio = measuredKWh / simulatedKWh
		v.DeviationPct = (1.0 - v.PRRatio) * 100.0
	}
	if v.PRRatio >= acceptanceThreshold {
		v.PassFail = "pass"
	} else {
		v.PassFail = "fail"
	}
	return v
}

// ========================================================================
// Turnover Document Pack
// ========================================================================

// TurnoverDocument is one document in the commissioning handover package.
type TurnoverDocument struct {
	Name        string `json:"name"`
	Category    string `json:"category"`    // "design", "test_report", "warranty", "permit", "manual"
	Required    bool   `json:"required"`
	FilePath    string `json:"file_path,omitempty"`
	Status      string `json:"status"`      // "provided", "missing", "na"
}

// TurnoverPack is the complete handover document set per IEC 62446-1 Annex A.
type TurnoverPack struct {
	ProjectID    string             `json:"project_id"`
	Documents    []TurnoverDocument `json:"documents"`
	CompletePct  float64            `json:"complete_pct"`
	ReadyForHandover bool           `json:"ready_for_handover"`
}

// DefaultTurnoverDocuments returns the standard document list per IEC 62446-1.
func DefaultTurnoverDocuments() []TurnoverDocument {
	return []TurnoverDocument{
		{Name: "As-built single-line diagram", Category: "design", Required: true, Status: "missing"},
		{Name: "As-built layout drawing", Category: "design", Required: true, Status: "missing"},
		{Name: "Stringing table (MPPT assignment)", Category: "design", Required: true, Status: "missing"},
		{Name: "Equipment datasheets", Category: "design", Required: true, Status: "missing"},
		{Name: "Module serial number list", Category: "test_report", Required: true, Status: "missing"},
		{Name: "IV-curve test reports", Category: "test_report", Required: true, Status: "missing"},
		{Name: "Thermal imaging report", Category: "test_report", Required: true, Status: "missing"},
		{Name: "Insulation resistance test results", Category: "test_report", Required: true, Status: "missing"},
		{Name: "Ground continuity test results", Category: "test_report", Required: true, Status: "missing"},
		{Name: "Functional performance test report", Category: "test_report", Required: true, Status: "missing"},
		{Name: "PR validation report", Category: "test_report", Required: true, Status: "missing"},
		{Name: "Module manufacturer warranty certificates", Category: "warranty", Required: true, Status: "missing"},
		{Name: "Inverter manufacturer warranty", Category: "warranty", Required: true, Status: "missing"},
		{Name: "Workmanship warranty", Category: "warranty", Required: true, Status: "missing"},
		{Name: "Building permit (final inspection)", Category: "permit", Required: true, Status: "missing"},
		{Name: "Electrical permit (final inspection)", Category: "permit", Required: true, Status: "missing"},
		{Name: "Interconnection agreement (executed)", Category: "permit", Required: true, Status: "missing"},
		{Name: "O&M manual", Category: "manual", Required: true, Status: "missing"},
		{Name: "Emergency response plan", Category: "manual", Required: true, Status: "missing"},
		{Name: "SCADA / monitoring configuration", Category: "manual", Required: false, Status: "missing"},
	}
}

// EvaluateTurnoverPack computes completion percentage and readiness.
func EvaluateTurnoverPack(pack *TurnoverPack) {
	total := 0
	provided := 0
	requiredMissing := 0

	for _, doc := range pack.Documents {
		if doc.Status == "na" {
			continue
		}
		total++
		if doc.Status == "provided" {
			provided++
		} else if doc.Required {
			requiredMissing++
		}
	}

	if total > 0 {
		pack.CompletePct = float64(provided) / float64(total) * 100.0
	}
	pack.ReadyForHandover = requiredMissing == 0
}
