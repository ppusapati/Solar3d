package repository

import (
	"context"
	"encoding/json"
	"math"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"testing"

	"solar3d/compute-service/internal/models"
)

func TestCompareFinancialScenarios(t *testing.T) {
	t.Parallel()

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/v1/extended/financial-metrics" {
			t.Fatalf("unexpected path %s", r.URL.Path)
		}

		var req models.FinancialMetricsRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Fatalf("decode request: %v", err)
		}

		cashflowSum := 0.0
		for _, flow := range req.AnnualCashflows {
			cashflowSum += flow
		}

		_ = json.NewEncoder(w).Encode(models.FinancialMetricsResponse{
			NPVUSD:      cashflowSum - req.InitialInvestment,
			IRRPercent:  req.DiscountRate * 100,
			PICoeff:     1.1,
			CROPPercent: req.PRActual - req.PRBaseline,
		})
	}))
	defer server.Close()

	repo := NewRustExtendedRepository(server.URL, filepath.Join(t.TempDir(), "financial_scenarios.json"))

	resp, err := repo.CompareFinancialScenarios(context.Background(), &models.FinancialScenarioComparisonRequest{
		AnnualYieldKWh:        10000,
		AnnualOMUSD:           100,
		ProjectLifeYears:      2,
		BaseInitialInvestment: 1000,
		PRBaseline:            0.82,
		Scenarios: []models.FinancialScenario{
			{
				Name:                  "Base",
				ElectricityPrice:      0.1,
				EscalationRatePercent: 10,
				DegradationRate:       5,
				DiscountRatePercent:   6,
				PRActual:              0.8,
				CapexMultiplier:       1,
			},
			{
				Name:                  "Upside",
				ElectricityPrice:      0.12,
				EscalationRatePercent: 0,
				DegradationRate:       0,
				DiscountRatePercent:   5,
				PRActual:              0.84,
				CapexMultiplier:       0,
			},
		},
	})
	if err != nil {
		t.Fatalf("CompareFinancialScenarios returned error: %v", err)
	}
	if len(resp.Scenarios) != 2 {
		t.Fatalf("expected 2 scenarios, got %d", len(resp.Scenarios))
	}

	base := resp.Scenarios[0]
	if got, want := base.AnnualRevenueUSD, 1000.0; !almostEqual(got, want) {
		t.Fatalf("base annual revenue = %v, want %v", got, want)
	}
	if got, want := base.NetAnnualCashflowUSD, 900.0; !almostEqual(got, want) {
		t.Fatalf("base net annual cashflow = %v, want %v", got, want)
	}
	if got, want := base.SimplePaybackYears, 1000.0/900.0; !almostEqual(got, want) {
		t.Fatalf("base payback = %v, want %v", got, want)
	}
	if got, want := base.Metrics.NPVUSD, 845.0; !almostEqual(got, want) {
		t.Fatalf("base npv = %v, want %v", got, want)
	}
	if got, want := base.Metrics.CROPPercent, -0.02; !almostEqual(got, want) {
		t.Fatalf("base crop = %v, want %v", got, want)
	}

	upside := resp.Scenarios[1]
	if got, want := upside.SimplePaybackYears, 1000.0/1100.0; !almostEqual(got, want) {
		t.Fatalf("upside payback = %v, want %v", got, want)
	}
	if got, want := upside.Metrics.IRRPercent, 5.0; !almostEqual(got, want) {
		t.Fatalf("upside irr = %v, want %v", got, want)
	}
	if got, want := upside.Metrics.NPVUSD, 1200.0; !almostEqual(got, want) {
		t.Fatalf("upside npv = %v, want %v", got, want)
	}
}

func TestCompareFinancialScenarios_ScaleBands(t *testing.T) {
	t.Parallel()

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/v1/extended/financial-metrics" {
			t.Fatalf("unexpected path %s", r.URL.Path)
		}

		var req models.FinancialMetricsRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Fatalf("decode request: %v", err)
		}

		cashflowSum := 0.0
		for _, flow := range req.AnnualCashflows {
			cashflowSum += flow
		}

		_ = json.NewEncoder(w).Encode(models.FinancialMetricsResponse{
			NPVUSD:      cashflowSum - req.InitialInvestment,
			IRRPercent:  req.DiscountRate * 100,
			PICoeff:     1.0,
			CROPPercent: req.PRActual - req.PRBaseline,
		})
	}))
	defer server.Close()

	repo := NewRustExtendedRepository(server.URL, filepath.Join(t.TempDir(), "financial_scenarios.json"))
	capacityBandsMW := []float64{1, 50, 250, 1000}

	for _, capacityMW := range capacityBandsMW {
		capacityKW := capacityMW * 1000.0
		annualYieldKWh := capacityKW * 1800.0
		baseInvestment := capacityKW * 1000.0 * 0.55

		resp, err := repo.CompareFinancialScenarios(context.Background(), &models.FinancialScenarioComparisonRequest{
			AnnualYieldKWh:        annualYieldKWh,
			AnnualOMUSD:           capacityKW * 15,
			ProjectLifeYears:      25,
			BaseInitialInvestment: baseInvestment,
			PRBaseline:            0.82,
			Scenarios: []models.FinancialScenario{
				{
					Name:                  "Base",
					ElectricityPrice:      0.06,
					EscalationRatePercent: 2,
					DegradationRate:       0.5,
					DiscountRatePercent:   6,
					PRActual:              0.8,
					CapexMultiplier:       1,
				},
			},
		})
		if err != nil {
			t.Fatalf("capacity %.0fMW returned error: %v", capacityMW, err)
		}
		if len(resp.Scenarios) != 1 {
			t.Fatalf("capacity %.0fMW expected 1 scenario, got %d", capacityMW, len(resp.Scenarios))
		}

		result := resp.Scenarios[0]
		if math.IsNaN(result.Metrics.NPVUSD) || math.IsInf(result.Metrics.NPVUSD, 0) {
			t.Fatalf("capacity %.0fMW returned invalid NPV: %v", capacityMW, result.Metrics.NPVUSD)
		}
		if math.IsNaN(result.SimplePaybackYears) || math.IsInf(result.SimplePaybackYears, 0) {
			t.Fatalf("capacity %.0fMW returned invalid payback: %v", capacityMW, result.SimplePaybackYears)
		}
	}
}

func almostEqual(left, right float64) bool {
	return math.Abs(left-right) < 1e-6
}

