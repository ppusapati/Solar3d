package service

import (
	"math"
	"testing"
)

// earthworkSummaryForTest constructs a minimal EarthworkSummary for cost tests.
func earthworkSummaryForTest(cut, fill, haulDistM, haulEffortM3M float64) *EarthworkSummary {
	return &EarthworkSummary{
		CutVolumeM3:   cut,
		FillVolumeM3:  fill,
		HaulDistanceM: haulDistM,
		HaulEffortM3M: haulEffortM3M,
	}
}

func approxEqual(a, b float64) bool {
	return math.Abs(a-b) < 1e-9
}

// TestComputeGradingPlanCostBalanced: cut == fill demand (compaction 1.0).
// No import or export should be needed.
func TestComputeGradingPlanCostBalanced(t *testing.T) {
	e := earthworkSummaryForTest(100, 100, 50, 5000)
	got := computeGradingPlanCost(e, 10, 8, 0.5, 15, 12, 1.0, "USD")

	if !approxEqual(got.FillDemandM3, 100) {
		t.Errorf("fill demand: want 100, got %f", got.FillDemandM3)
	}
	if !approxEqual(got.ExportVolumeM3, 0) {
		t.Errorf("export: want 0, got %f", got.ExportVolumeM3)
	}
	if !approxEqual(got.ImportVolumeM3, 0) {
		t.Errorf("import: want 0, got %f", got.ImportVolumeM3)
	}
	if !approxEqual(got.HauledVolumeM3, 100) {
		t.Errorf("hauled: want 100, got %f", got.HauledVolumeM3)
	}

	wantCut := 100 * 10.0
	wantFill := 100 * 8.0
	wantHaul := 5000 * 0.5
	wantTotal := wantCut + wantFill + wantHaul
	if !approxEqual(got.TotalCost, wantTotal) {
		t.Errorf("total cost: want %f, got %f", wantTotal, got.TotalCost)
	}
	if got.CurrencyCode != "USD" {
		t.Errorf("currency: want USD, got %s", got.CurrencyCode)
	}
}

// TestComputeGradingPlanCostCutSurplus: cut > fill demand → export surplus.
func TestComputeGradingPlanCostCutSurplus(t *testing.T) {
	// cut=200, fill=100, compaction=1.0 → fillDemand=100, export=100
	e := earthworkSummaryForTest(200, 100, 30, 3000)
	got := computeGradingPlanCost(e, 10, 8, 0.5, 15, 12, 1.0, "EUR")

	if !approxEqual(got.FillDemandM3, 100) {
		t.Errorf("fill demand: want 100, got %f", got.FillDemandM3)
	}
	if !approxEqual(got.ExportVolumeM3, 100) {
		t.Errorf("export: want 100, got %f", got.ExportVolumeM3)
	}
	if !approxEqual(got.ImportVolumeM3, 0) {
		t.Errorf("import: want 0, got %f", got.ImportVolumeM3)
	}
	if !approxEqual(got.HauledVolumeM3, 100) {
		t.Errorf("hauled: want 100, got %f", got.HauledVolumeM3)
	}

	wantExportCost := 100.0 * 12.0
	if !approxEqual(got.ExportCost, wantExportCost) {
		t.Errorf("export cost: want %f, got %f", wantExportCost, got.ExportCost)
	}
	if !approxEqual(got.ImportCost, 0) {
		t.Errorf("import cost: want 0, got %f", got.ImportCost)
	}
}

// TestComputeGradingPlanCostFillDeficit: cut < fill demand → import shortfall.
func TestComputeGradingPlanCostFillDeficit(t *testing.T) {
	// cut=50, fill=100, compaction=1.0 → fillDemand=100, import=50
	e := earthworkSummaryForTest(50, 100, 20, 1000)
	got := computeGradingPlanCost(e, 10, 8, 0.5, 15, 12, 1.0, "USD")

	if !approxEqual(got.FillDemandM3, 100) {
		t.Errorf("fill demand: want 100, got %f", got.FillDemandM3)
	}
	if !approxEqual(got.ImportVolumeM3, 50) {
		t.Errorf("import: want 50, got %f", got.ImportVolumeM3)
	}
	if !approxEqual(got.ExportVolumeM3, 0) {
		t.Errorf("export: want 0, got %f", got.ExportVolumeM3)
	}
	if !approxEqual(got.HauledVolumeM3, 50) {
		t.Errorf("hauled: want 50, got %f", got.HauledVolumeM3)
	}

	wantImportCost := 50.0 * 15.0
	if !approxEqual(got.ImportCost, wantImportCost) {
		t.Errorf("import cost: want %f, got %f", wantImportCost, got.ImportCost)
	}
}

// TestComputeGradingPlanCostZeroRates: all unit rates zero → all costs zero,
// volumes still computed correctly.
func TestComputeGradingPlanCostZeroRates(t *testing.T) {
	e := earthworkSummaryForTest(80, 120, 40, 4800)
	got := computeGradingPlanCost(e, 0, 0, 0, 0, 0, 1.0, "USD")

	if !approxEqual(got.TotalCost, 0) {
		t.Errorf("total cost with zero rates: want 0, got %f", got.TotalCost)
	}
	// volumes still derived correctly
	if !approxEqual(got.CutVolumeM3, 80) {
		t.Errorf("cut volume: want 80, got %f", got.CutVolumeM3)
	}
	if !approxEqual(got.ImportVolumeM3, 40) {
		t.Errorf("import: want 40, got %f", got.ImportVolumeM3)
	}
}

// TestComputeGradingPlanCostCompaction: compaction_factor = 1.2 increases fill demand.
func TestComputeGradingPlanCostCompaction(t *testing.T) {
	// cut=100, fill=100, compaction=1.2 → fillDemand=120 → import=20
	e := earthworkSummaryForTest(100, 100, 50, 5000)
	got := computeGradingPlanCost(e, 10, 8, 0.5, 15, 12, 1.2, "USD")

	wantFillDemand := 100.0 * 1.2
	if !approxEqual(got.FillDemandM3, wantFillDemand) {
		t.Errorf("fill demand: want %f, got %f", wantFillDemand, got.FillDemandM3)
	}
	wantImport := wantFillDemand - 100
	if !approxEqual(got.ImportVolumeM3, wantImport) {
		t.Errorf("import: want %f, got %f", wantImport, got.ImportVolumeM3)
	}
	if !approxEqual(got.ExportVolumeM3, 0) {
		t.Errorf("export: want 0, got %f", got.ExportVolumeM3)
	}
}
