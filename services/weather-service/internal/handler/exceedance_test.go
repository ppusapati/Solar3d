package handler

import (
	"math"
	"testing"
	"time"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

func TestComputeExceedance_SingleYear(t *testing.T) {
	// Generate a synthetic year (8760 hours) with constant GHI 500 W/m²
	// during daylight (6AM-6PM = 12h) and 0 at night.
	// Daily GHI: 12h × 500 = 6000 Wh/m². Annual: 365 × 6000 = 2190000 Wh/m² = 2190 kWh/m².
	records := make([]domain.HourlyRecord, 0, 8760)
	start := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	for i := 0; i < 8760; i++ {
		ts := start.Add(time.Duration(i) * time.Hour)
		ghi := 0.0
		if ts.Hour() >= 6 && ts.Hour() < 18 {
			ghi = 500.0
		}
		records = append(records, domain.HourlyRecord{Timestamp: ts, GHI: ghi})
	}

	exceedances := computeExceedance(records, 0)
	if len(exceedances) == 0 {
		t.Fatal("no exceedances returned")
	}

	// With only one year, all percentiles should be the same value.
	expected := 2190.0
	for _, e := range exceedances {
		if math.Abs(e.AnnualGHIKWhM2-expected) > 1 {
			t.Errorf("P%d: got %.1f, want ~%.1f", e.Percentile, e.AnnualGHIKWhM2, expected)
		}
	}
}

func TestComputeExceedance_WithSystemScaling(t *testing.T) {
	// 1 hour at 1000 W/m² → 1 kWh/m² annual GHI (trivially).
	records := []domain.HourlyRecord{
		{Timestamp: time.Date(2024, 6, 15, 12, 0, 0, 0, time.UTC), GHI: 1000},
	}
	exceedances := computeExceedance(records, 100) // 100 kW system
	if len(exceedances) == 0 {
		t.Fatal("no exceedances returned")
	}
	// yield ≈ 1.0 kWh/m² × (100/1000) × 0.80 = 0.08
	for _, e := range exceedances {
		if math.Abs(e.AnnualGHIKWhM2-0.08) > 0.01 {
			t.Errorf("P%d: got %.4f, want ~0.08", e.Percentile, e.AnnualGHIKWhM2)
		}
	}
}

func TestComputeExceedance_EmptyRecords(t *testing.T) {
	result := computeExceedance(nil, 0)
	if result != nil {
		t.Errorf("expected nil, got %v", result)
	}
}

func TestPercentileExceedance_MultipleYears(t *testing.T) {
	// sorted ascending: 100, 200, 300, 400, 500
	data := []float64{100, 200, 300, 400, 500}

	// P50 exceedance = value exceeded 50% of the time = 50th percentile from top
	// = (100-50)/100 * 4 = 2.0 → index 2 → 300
	p50 := percentileExceedance(data, 50)
	if math.Abs(p50-300) > 0.01 {
		t.Errorf("P50: got %.1f, want 300", p50)
	}

	// P90 = value exceeded 90% of the time = (100-90)/100 * 4 = 0.4
	// → 100×0.6 + 200×0.4 = 60+80 = 140
	p90 := percentileExceedance(data, 90)
	if math.Abs(p90-140) > 0.01 {
		t.Errorf("P90: got %.1f, want 140", p90)
	}
}
