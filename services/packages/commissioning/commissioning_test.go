package commissioning

import (
	"math"
	"strings"
	"testing"
)

func TestIVCurveExtract(t *testing.T) {
	trace := &IVCurveTrace{
		IrradianceWm2: 950,
		CellTempC:     40,
		Points: []IVPoint{
			{0, 18.0},  // near Isc
			{10, 17.5},
			{20, 17.0},
			{30, 16.0},
			{35, 14.5}, // Pmax region
			{37, 12.0},
			{40, 5.0},
			{41, 0.5},  // near Voc
		},
	}
	trace.ExtractIVParams()

	if trace.IscMeasured < 17.0 {
		t.Errorf("Isc: got %.1f", trace.IscMeasured)
	}
	if trace.VocMeasured < 40.0 {
		t.Errorf("Voc: got %.1f", trace.VocMeasured)
	}
	if trace.PmaxMeasured < 400 {
		t.Errorf("Pmax: got %.1f", trace.PmaxMeasured)
	}
	if trace.FillFactor < 0.5 || trace.FillFactor > 0.9 {
		t.Errorf("FF: got %.3f", trace.FillFactor)
	}
}

func TestIVCurveSTCTranslation(t *testing.T) {
	trace := &IVCurveTrace{
		IrradianceWm2: 800,
		CellTempC:     50,
		VocMeasured:   38.0,
		IscMeasured:   15.0,
		PmaxMeasured:  400.0,
	}
	trace.TranslateToSTC(-0.25, 0.048)

	// STC Isc should be higher (more irradiance + cooler)
	if trace.IscSTC <= trace.IscMeasured {
		t.Errorf("IscSTC should increase: measured=%.1f stc=%.1f", trace.IscMeasured, trace.IscSTC)
	}
	// STC Pmax should be higher
	if trace.PmaxSTC <= trace.PmaxMeasured {
		t.Errorf("PmaxSTC should increase: measured=%.1f stc=%.1f", trace.PmaxMeasured, trace.PmaxSTC)
	}
}

func TestIVCurveEvaluation(t *testing.T) {
	trace := &IVCurveTrace{PmaxSTC: 590}
	trace.EvaluateAgainstDatasheet(605, 3.0) // 3% tolerance → threshold 0.97
	// 590/605 = 0.975 → pass
	if trace.PassFail != "pass" {
		t.Errorf("590/605 = %.3f should pass at 3%% tolerance", trace.PmaxRatio)
	}

	trace2 := &IVCurveTrace{PmaxSTC: 570}
	trace2.EvaluateAgainstDatasheet(605, 3.0)
	// 570/605 = 0.942 → fail
	if trace2.PassFail != "fail" {
		t.Errorf("570/605 = %.3f should fail at 3%% tolerance", trace2.PmaxRatio)
	}
}

func TestParseDaystarCSV(t *testing.T) {
	data := "Voltage(V),Current(A)\n0.0,18.5\n10.0,18.2\n35.0,15.0\n41.0,0.1\n"
	points, err := ParseDaystarCSV(strings.NewReader(data))
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	if len(points) != 4 {
		t.Errorf("expected 4 points, got %d", len(points))
	}
}

func TestParseSolmetricCSV(t *testing.T) {
	data := "Header info\nDevice: PVA-1500\nBEGIN IV DATA\n0.0,18.5\n10.0,18.2\n35.0,15.0\n41.0,0.1\nEND IV DATA\n"
	points, err := ParseSolmetricCSV(strings.NewReader(data))
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	if len(points) != 4 {
		t.Errorf("expected 4 points, got %d", len(points))
	}
}

func TestThermalAnomalyClassification(t *testing.T) {
	aType, sev, _ := ClassifyThermalAnomaly(25, 90)
	if sev != "critical" || aType != "hot_spot" {
		t.Errorf("ΔT=25: got %s/%s", sev, aType)
	}

	aType, sev, _ = ClassifyThermalAnomaly(12, 60)
	if sev != "major" || aType != "hot_cell" {
		t.Errorf("ΔT=12: got %s/%s", sev, aType)
	}

	_, sev, _ = ClassifyThermalAnomaly(3, 45)
	if sev != "info" {
		t.Errorf("ΔT=3: got severity %s", sev)
	}
}

func TestInsulationResistance(t *testing.T) {
	test := &InsulationResistanceTest{ResistanceMOhm: 500}
	EvaluateInsulationTest(test)
	if test.PassFail != "pass" {
		t.Errorf("500 MΩ should pass")
	}

	test2 := &InsulationResistanceTest{ResistanceMOhm: 20}
	EvaluateInsulationTest(test2)
	if test2.PassFail != "fail" {
		t.Errorf("20 MΩ should fail")
	}
}

func TestPITest(t *testing.T) {
	test := &PolarizationIndexTest{R1MinMOhm: 100, R10MinMOhm: 250}
	EvaluatePITest(test)
	if test.PI < 2.0 || test.PassFail != "pass" {
		t.Errorf("PI=%.1f should pass", test.PI)
	}

	test2 := &PolarizationIndexTest{R1MinMOhm: 100, R10MinMOhm: 120}
	EvaluatePITest(test2)
	if test2.PassFail != "marginal" {
		t.Errorf("PI=%.1f should be marginal", test2.PI)
	}
}

func TestPRValidation(t *testing.T) {
	v := ValidatePR(95000, 100000, 1800, 100, 0.95)
	if v.PassFail != "pass" {
		t.Errorf("95/100 should pass: ratio=%.3f", v.PRRatio)
	}

	v2 := ValidatePR(85000, 100000, 1800, 100, 0.95)
	if v2.PassFail != "fail" {
		t.Errorf("85/100 should fail: ratio=%.3f", v2.PRRatio)
	}
}

func TestTurnoverPack(t *testing.T) {
	docs := DefaultTurnoverDocuments()
	pack := &TurnoverPack{ProjectID: "proj-001", Documents: docs}
	EvaluateTurnoverPack(pack)
	if pack.ReadyForHandover {
		t.Error("all missing — should not be ready")
	}
	if pack.CompletePct != 0 {
		t.Errorf("complete: got %.0f%%", pack.CompletePct)
	}

	// Mark all required as provided
	for i := range pack.Documents {
		pack.Documents[i].Status = "provided"
	}
	EvaluateTurnoverPack(pack)
	if !pack.ReadyForHandover {
		t.Error("all provided — should be ready")
	}
}

func TestDegradation(t *testing.T) {
	records := []AnnualPRRecord{
		{Year: 2022, PR: 0.82},
		{Year: 2023, PR: 0.815},
		{Year: 2024, PR: 0.808},
		{Year: 2025, PR: 0.801},
	}
	d := ComputeDegradation(records, 1.0) // 1.0%/year warranty limit
	if d.DegradationRatePct <= 0 {
		t.Errorf("should have positive degradation rate: got %.3f", d.DegradationRatePct)
	}
	if d.DegradationRatePct > 1.0 {
		t.Errorf("degradation too high: got %.3f%%/year", d.DegradationRatePct)
	}
	// ~0.78%/year → should be within 1.0% warranty limit
	if !d.WarrantyCompliant {
		t.Errorf("should be warranty compliant: rate=%.3f%%, limit=%.1f%%",
			d.DegradationRatePct, d.WarrantyLimitPct)
	}
}

func TestFaultDictionary(t *testing.T) {
	faults := DefaultFaultDictionary()
	if len(faults) < 10 {
		t.Errorf("expected ≥10 fault codes, got %d", len(faults))
	}
	for _, f := range faults {
		if f.VendorCode == "" || f.Description == "" || f.Action == "" {
			t.Errorf("incomplete fault code: %+v", f)
		}
	}
}

func TestPMSchedules(t *testing.T) {
	schedules := DefaultPMSchedules("proj-001")
	if len(schedules) < 5 {
		t.Errorf("expected ≥5 PM schedules, got %d", len(schedules))
	}
	for _, s := range schedules {
		if s.FrequencyDays <= 0 {
			t.Errorf("schedule %s has invalid frequency: %d", s.ID, s.FrequencyDays)
		}
	}
}

func floatClose(a, b, tol float64) bool {
	return math.Abs(a-b) <= tol
}
