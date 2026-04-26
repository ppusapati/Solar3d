package export

import (
	"bytes"
	"strings"
	"testing"
	"time"
)

func TestPVsystPRJ(t *testing.T) {
	p := &PVsystProject{
		ProjectName: "Test Farm", Latitude: 34.05, Longitude: -118.25,
		Altitude: 100, TimeZone: -8,
		ModuleName: "TSM-NEG19RC.20", ModulePnomW: 605,
		ModuleVocV: 41.7, ModuleIscA: 18.35, ModuleVmpV: 35.1, ModuleImpA: 17.23,
		ModulesPerString: 28, StringsPerInv: 12, NumInverters: 4,
		InverterName: "SG250HX", InverterPnomKW: 250,
		InverterVmppMinV: 500, InverterVmppMaxV: 1500,
		TiltDeg: 25, AzimuthDeg: 180, GCR: 0.4,
		SoilingPct: 2, MismatchPct: 1, CableLossPct: 1.5, AvailabilityPct: 98,
	}

	var buf bytes.Buffer
	if err := p.WritePRJ(&buf); err != nil {
		t.Fatalf("WritePRJ: %v", err)
	}
	prj := buf.String()

	if !strings.Contains(prj, "PVObject_=pvProject") {
		t.Error("missing project header")
	}
	if !strings.Contains(prj, "TSM-NEG19RC.20") {
		t.Error("missing module model")
	}
	if !strings.Contains(prj, "SG250HX") {
		t.Error("missing inverter model")
	}
	if !strings.Contains(prj, "End of PVObject pvProject") {
		t.Error("missing closing tag")
	}
	// Check nested structure is balanced
	opens := strings.Count(prj, "PVObject_")
	closes := strings.Count(prj, "End of PVObject")
	if opens != closes {
		t.Errorf("unbalanced PVObject blocks: %d opens, %d closes", opens, closes)
	}
}

func TestIFCExport(t *testing.T) {
	guidCounter = 0 // reset for deterministic test

	p := &IFCProject{
		ProjectName: "Test Farm", Author: "Engineer", Organization: "Solar Co",
		Latitude: 34.05, Longitude: -118.25,
		Panels: []IFCPanel{
			{ID: "p1", Name: "Panel-1", Model: "TSM-NEG19RC.20", Manufacturer: "Trina",
				X: 10, Y: 20, Z: 1.5, Tilt: 25, Azimuth: 180, Width: 2.384, Height: 1.134, PowerW: 605},
		},
	}

	var buf bytes.Buffer
	if err := p.WriteIFC(&buf); err != nil {
		t.Fatalf("WriteIFC: %v", err)
	}
	ifc := buf.String()

	if !strings.Contains(ifc, "ISO-10303-21") {
		t.Error("missing STEP header")
	}
	if !strings.Contains(ifc, "IFC4") {
		t.Error("missing IFC4 schema reference")
	}
	if !strings.Contains(ifc, "IFCPROJECT") {
		t.Error("missing IfcProject")
	}
	if !strings.Contains(ifc, "IFCBUILDINGELEMENTPROXY") {
		t.Error("missing panel entity")
	}
	if !strings.Contains(ifc, "Power_W") {
		t.Error("missing power property")
	}
	if !strings.Contains(ifc, "END-ISO-10303-21") {
		t.Error("missing STEP footer")
	}
}

func TestIEC61724Export(t *testing.T) {
	records := []IEC61724Record{
		{Timestamp: time.Date(2025, 6, 15, 10, 0, 0, 0, time.UTC), IntervalMinutes: 60,
			GHIWm2: 800, POAWm2: 850, AmbientTempC: 28, ModuleTempC: 45,
			WindSpeedMS: 3, DCPowerKW: 400, ACPowerKW: 380, ACEnergyKWh: 380,
			GridExportKWh: 380, Availability: 1.0, PR: 0.82},
		{Timestamp: time.Date(2025, 6, 15, 11, 0, 0, 0, time.UTC), IntervalMinutes: 60,
			GHIWm2: 950, POAWm2: 1000, AmbientTempC: 30, ModuleTempC: 50,
			WindSpeedMS: 2, DCPowerKW: 480, ACPowerKW: 460, ACEnergyKWh: 460,
			GridExportKWh: 460, Availability: 1.0, PR: 0.80},
	}

	summary := ComputeIEC61724Summary("Test Farm", 600, "2025-06", records)
	if summary.TotalACEnergyMWh <= 0 {
		t.Errorf("total energy should be > 0: got %.4f", summary.TotalACEnergyMWh)
	}
	if summary.AvgPR < 0.7 || summary.AvgPR > 0.9 {
		t.Errorf("avg PR should be ~0.81: got %.3f", summary.AvgPR)
	}

	var buf bytes.Buffer
	if err := WriteIEC61724CSV(&buf, summary, records); err != nil {
		t.Fatalf("WriteIEC61724CSV: %v", err)
	}
	csv := buf.String()

	if !strings.Contains(csv, "IEC 61724") {
		t.Error("missing IEC 61724 header")
	}
	if !strings.Contains(csv, "Test Farm") {
		t.Error("missing project name")
	}
	if !strings.Contains(csv, "PR") {
		t.Error("missing PR column")
	}
}

func TestIEC61724Summary(t *testing.T) {
	records := make([]IEC61724Record, 0, 8760)
	start := time.Date(2025, 1, 1, 0, 0, 0, 0, time.UTC)
	for i := 0; i < 8760; i++ {
		ts := start.Add(time.Duration(i) * time.Hour)
		ghi := 0.0
		if ts.Hour() >= 6 && ts.Hour() < 18 {
			ghi = 600.0
		}
		ac := ghi * 0.5 * 0.80 // 500 kW system, 80% PR
		records = append(records, IEC61724Record{
			Timestamp: ts, IntervalMinutes: 60,
			GHIWm2: ghi, POAWm2: ghi, ACPowerKW: ac, ACEnergyKWh: ac,
			GridExportKWh: ac, Availability: 1.0,
			PR: func() float64 { if ghi > 50 { return 0.80 }; return 0 }(),
		})
	}

	summary := ComputeIEC61724Summary("Annual Test", 500, "2025", records)
	// 12h/day × 365 × 600 W/m² × 0.80 PR × 500 kW / 1000 = 1051.2 MWh
	if summary.TotalACEnergyMWh < 900 || summary.TotalACEnergyMWh > 1200 {
		t.Errorf("annual energy out of range: got %.1f MWh", summary.TotalACEnergyMWh)
	}
	if summary.SpecificYieldKWhKWp < 1800 || summary.SpecificYieldKWhKWp > 2400 {
		t.Errorf("specific yield out of range: got %.0f kWh/kWp", summary.SpecificYieldKWhKWp)
	}
}
