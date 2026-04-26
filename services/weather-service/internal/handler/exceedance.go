package handler

import (
	"math"
	"sort"

	"p9e.in/samavaya/solar3d/weather-service/internal/domain"
)

// computeExceedance derives P50/P75/P90/P95/P99 exceedance probabilities from
// the GHI timeseries. For a TMY with 8760 records this represents the single-
// year median; for multi-year data the inter-annual variability drives the
// spread. The algorithm:
//
//  1. Partition records into calendar months.
//  2. Per-month, compute the mean monthly GHI (Wh/m²). If multi-year, each
//     month appears N times → N monthly totals.
//  3. Sum monthly totals into annual candidates. For TMY (1 year) there is
//     exactly one candidate → P50=P90=P99. For multi-year, sort candidates and
//     interpolate percentiles.
//  4. If systemCapacityKW > 0, scale GHI (kWh/m²) by a simplified PR-adjusted
//     capacity factor: annual_yield_kWh ≈ GHI * (capacity_kW / 1000) * 0.80.
//
// This is a simplified approach suitable for feasibility-stage estimates.
// Production bankable yield assessments should use a full probabilistic model
// (e.g., Weibull + Monte Carlo) fed by multi-source datasets.
func computeExceedance(records []domain.HourlyRecord, systemCapacityKW float64) []domain.YieldExceedance {
	if len(records) == 0 {
		return nil
	}

	// Group by (year, month)
	type ym struct {
		year  int
		month int
	}
	monthly := map[ym]float64{}
	yearly := map[int]float64{}

	for _, r := range records {
		k := ym{r.Timestamp.Year(), int(r.Timestamp.Month())}
		monthly[k] += r.GHI // Wh/m²
	}
	for k, wh := range monthly {
		yearly[k.year] += wh
	}

	// Collect annual GHI values (kWh/m²)
	annuals := make([]float64, 0, len(yearly))
	for _, wh := range yearly {
		annuals = append(annuals, wh/1000.0)
	}
	sort.Float64s(annuals)

	percentiles := []int{50, 75, 90, 95, 99}
	out := make([]domain.YieldExceedance, 0, len(percentiles))
	for _, p := range percentiles {
		ghiVal := percentileExceedance(annuals, p)
		if systemCapacityKW > 0 {
			// Simplified PR-adjusted scaling: yield ≈ GHI × (Pdc/1000) × PR
			ghiVal = ghiVal * (systemCapacityKW / 1000.0) * 0.80
		}
		out = append(out, domain.YieldExceedance{
			Percentile:     p,
			AnnualGHIKWhM2: math.Round(ghiVal*100) / 100,
		})
	}
	return out
}

// percentileExceedance returns the value that is exceeded with probability p%.
// For an exceedance curve, P90 means 90 % probability of exceeding, so we want
// the (100-p)th percentile of the sorted data. With a single data point (TMY),
// all percentiles equal that point.
func percentileExceedance(sorted []float64, p int) float64 {
	n := len(sorted)
	if n == 0 {
		return 0
	}
	if n == 1 {
		return sorted[0]
	}
	// Exceedance: value exceeded p% of the time = (100-p)th percentile
	rank := float64(100-p) / 100.0 * float64(n-1)
	lo := int(math.Floor(rank))
	hi := lo + 1
	if hi >= n {
		return sorted[n-1]
	}
	frac := rank - float64(lo)
	return sorted[lo]*(1-frac) + sorted[hi]*frac
}
