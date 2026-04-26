package erp

import (
	"bytes"
	"strings"
	"testing"
	"time"
)

func sampleBOM() *BOMExport {
	return &BOMExport{
		ProjectID:   "proj-001",
		ProjectName: "Solar Farm Alpha",
		ExportedAt:  time.Date(2026, 4, 16, 12, 0, 0, 0, time.UTC),
		Items: []BOMLineItem{
			{LineNumber: 1, Category: "panel", Manufacturer: "Trina Solar", Model: "TSM-NEG19RC.20", Description: "605W TOPCon bifacial", Quantity: 5000, Unit: "ea", UnitCostUSD: 180.0, TotalCostUSD: 900000, CriticalPath: true, ERPMaterialCode: "MAT-PNL-001", ProjectID: "proj-001", ExportedAt: "2026-04-16"},
			{LineNumber: 2, Category: "inverter", Manufacturer: "Sungrow", Model: "SG250HX", Description: "250kW string inverter", Quantity: 12, Unit: "ea", UnitCostUSD: 12000.0, TotalCostUSD: 144000, CriticalPath: true, ERPMaterialCode: "MAT-INV-001", ProjectID: "proj-001", ExportedAt: "2026-04-16"},
			{LineNumber: 3, Category: "cable", Manufacturer: "Prysmian", Model: "H1Z2Z2-K-6mm2", Description: "6mm² PV DC cable", Quantity: 15000, Unit: "m", UnitCostUSD: 0.85, TotalCostUSD: 12750, CriticalPath: false, ERPMaterialCode: "MAT-CBL-001", ProjectID: "proj-001", ExportedAt: "2026-04-16"},
		},
	}
}

func TestApplySpares(t *testing.T) {
	bom := sampleBOM()
	bom.ApplySpares()

	// Panels: 2% spares → 100 spare
	if bom.Items[0].SpareQuantity != 100 {
		t.Errorf("panel spares: got %d, want 100", bom.Items[0].SpareQuantity)
	}
	if bom.Items[0].TotalWithSpares != 5100 {
		t.Errorf("panel total w/ spares: got %d, want 5100", bom.Items[0].TotalWithSpares)
	}

	// Inverters: 0% spares (warranty)
	if bom.Items[1].SpareQuantity != 0 {
		t.Errorf("inverter spares: got %d, want 0", bom.Items[1].SpareQuantity)
	}

	// Cable: 3% spares → 450
	if bom.Items[2].SpareQuantity != 450 {
		t.Errorf("cable spares: got %d, want 450", bom.Items[2].SpareQuantity)
	}
}

func TestToCSV(t *testing.T) {
	bom := sampleBOM()
	bom.ApplySpares()
	bom.TotalLines = len(bom.Items)

	var buf bytes.Buffer
	if err := bom.ToCSV(&buf); err != nil {
		t.Fatalf("ToCSV: %v", err)
	}
	csv := buf.String()
	if !strings.Contains(csv, "Trina Solar") {
		t.Error("CSV should contain manufacturer")
	}
	if !strings.Contains(csv, "TSM-NEG19RC.20") {
		t.Error("CSV should contain model")
	}
	lines := strings.Split(strings.TrimSpace(csv), "\n")
	if len(lines) != 4 { // header + 3 data rows
		t.Errorf("expected 4 lines, got %d", len(lines))
	}
}

func TestToJSON(t *testing.T) {
	bom := sampleBOM()
	var buf bytes.Buffer
	if err := bom.ToJSON(&buf); err != nil {
		t.Fatalf("ToJSON: %v", err)
	}
	if !strings.Contains(buf.String(), "proj-001") {
		t.Error("JSON should contain project_id")
	}
}

func TestToSAPIDoc(t *testing.T) {
	bom := sampleBOM()
	bom.ApplySpares()
	bom.TotalLines = len(bom.Items)

	var buf bytes.Buffer
	if err := bom.ToSAPIDoc(&buf); err != nil {
		t.Fatalf("ToSAPIDoc: %v", err)
	}
	idoc := buf.String()
	if !strings.Contains(idoc, "E1STZOM") {
		t.Error("should contain header segment")
	}
	if !strings.Contains(idoc, "E1STPOM") {
		t.Error("should contain item segments")
	}
}

func TestToNetSuiteCSV(t *testing.T) {
	bom := sampleBOM()
	bom.ApplySpares()

	var buf bytes.Buffer
	if err := bom.ToNetSuiteCSV(&buf); err != nil {
		t.Fatalf("ToNetSuiteCSV: %v", err)
	}
	csv := buf.String()
	if !strings.Contains(csv, "External ID") {
		t.Error("should contain NetSuite header")
	}
	if !strings.Contains(csv, "S3D-proj-001") {
		t.Error("should contain Solar3D external ID prefix")
	}
}

func TestReconcile_AllFulfilled(t *testing.T) {
	bom := sampleBOM()
	bom.ApplySpares()

	inventory := []ERPInventoryItem{
		{MaterialCode: "MAT-PNL-001", AvailableQty: 6000},
		{MaterialCode: "MAT-INV-001", AvailableQty: 20},
		{MaterialCode: "MAT-CBL-001", AvailableQty: 20000},
	}

	result := Reconcile(bom, inventory)
	if !result.ReadyForConstruction {
		t.Error("should be ready: all materials fulfilled")
	}
	if result.Shortages != 0 {
		t.Errorf("shortages: got %d, want 0", result.Shortages)
	}
}

func TestReconcile_CriticalShortage(t *testing.T) {
	bom := sampleBOM()
	bom.ApplySpares()

	inventory := []ERPInventoryItem{
		{MaterialCode: "MAT-PNL-001", AvailableQty: 1000}, // short!
		{MaterialCode: "MAT-INV-001", AvailableQty: 20},
		{MaterialCode: "MAT-CBL-001", AvailableQty: 20000},
	}

	result := Reconcile(bom, inventory)
	if result.ReadyForConstruction {
		t.Error("should NOT be ready: panels are critical-path and short")
	}
	if result.Shortages == 0 {
		t.Error("should have shortages")
	}
}

func TestProcurementGate(t *testing.T) {
	bom := sampleBOM()
	bom.ApplySpares()

	inventory := []ERPInventoryItem{
		{MaterialCode: "MAT-PNL-001", AvailableQty: 1000},
		{MaterialCode: "MAT-INV-001", AvailableQty: 20},
		{MaterialCode: "MAT-CBL-001", AvailableQty: 20000},
	}

	recon := Reconcile(bom, inventory)
	gate := EvaluateProcurementGate(recon)

	if gate.CanProceed {
		t.Error("gate should block: critical panel shortage")
	}
	if gate.CriticalShortages == 0 {
		t.Error("should have critical shortages")
	}
	if len(gate.BlockerReasons) == 0 {
		t.Error("should have blocker reasons")
	}
}
