// Package service — pure Go ML backend.
//
// This file ports the algorithms from compute/ml-inference (Rust) so the service
// can operate without the Rust bridge. Algorithms are numerically equivalent to
// the Rust implementations; see compute/ml-inference/src/ for the reference.
package service

import (
	"context"
	"fmt"
	"math"
	"sort"
)

// GoBackend is a pure-Go, dependency-free implementation of MLBackend.
// It is suitable for production use when the Rust bridge is unavailable,
// for unit/integration testing, and as a reference implementation.
type GoBackend struct {
	// Yield forecaster tuning (mirrors YieldForecaster in Rust)
	modelMeanMultiplier float64 // multiplier on raw model output
	modelVarianceWeight float64 // fraction of uncertainty used for variance

	// Degradation forecaster parameters
	confidenceDecayPerStep float64 // how quickly confidence falls with horizon
}

// NewGoBackend returns a GoBackend with the same default parameters as the Rust crate.
func NewGoBackend() *GoBackend {
	return &GoBackend{
		modelMeanMultiplier:    1.0,
		modelVarianceWeight:    0.15,
		confidenceDecayPerStep: 0.02,
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Yield Forecasting
// Reference: compute/ml-inference/src/yield_forecasting.rs — YieldForecaster
// ─────────────────────────────────────────────────────────────────────────────

// ForecastYield predicts solar yield with 5th/95th percentile confidence bounds.
//
// Algorithm (mirrors Rust YieldForecaster.forecast):
//  1. Extract the primary scalar output from modelOutput map.
//  2. Apply irradiance normalisation (relative to 1000 W/m² STC reference).
//  3. Apply standard temperature coefficient −0.4 %/°C above 25 °C.
//  4. Scale by the solar clearness index.
//  5. Compute variance = (uncertainty × varianceWeight)² → stdDev = √variance.
//  6. P5  = max(0, prediction − 1.645·σ),  P95 = prediction + 1.645·σ  (90 % CI).
//  7. Confidence = clamp(1 − uncertainty, 0, 1).
func (b *GoBackend) ForecastYield(
	_ context.Context,
	modelOutput map[string]interface{},
	uncertainty float64,
	weather *WeatherFeatures,
	solar *SolarFeatures,
) (*YieldForecast, error) {

	if len(modelOutput) == 0 {
		return nil, fmt.Errorf("model output is required")
	}
	if uncertainty < 0 || math.IsInf(uncertainty, 0) || math.IsNaN(uncertainty) {
		return nil, fmt.Errorf("uncertainty must be non-negative")
	}

	outputVal, err := extractScalar(modelOutput)
	if err != nil {
		return nil, err
	}

	// Normalise irradiance: STC reference is 1000 W/m².
	irradianceFactor := weather.Irradiance / 1000.0
	if irradianceFactor < 0 {
		irradianceFactor = 0
	}

	// Temperature coefficient: −0.004 per °C above 25 °C (standard mono-Si).
	tempFactor := 1.0 - 0.004*(weather.Temperature-25.0)
	if tempFactor < 0.5 {
		tempFactor = 0.5
	}

	// Clearness index (0–1): accounts for atmospheric attenuation.
	clearnessIdx := solar.ClearnessIdx
	if clearnessIdx <= 0 {
		clearnessIdx = 1.0
	}
	if clearnessIdx > 1 {
		clearnessIdx = 1.0
	}

	predicted := outputVal * b.modelMeanMultiplier * irradianceFactor * tempFactor * clearnessIdx
	if predicted < 0 {
		predicted = 0
	}

	// Confidence intervals: variance = (uncertainty*weight)², CI uses 1.645σ.
	variance := math.Pow(uncertainty*b.modelVarianceWeight, 2)
	stdDev := math.Sqrt(variance)
	p5 := math.Max(0, predicted-1.645*stdDev)
	p95 := predicted + 1.645*stdDev
	confidence := math.Max(0, math.Min(1.0, 1.0-uncertainty))

	return &YieldForecast{
		ExpectedYield: predicted,
		P5:            p5,
		P95:           p95,
		Confidence:    confidence,
	}, nil
}

// extractScalar pulls the first numeric value from a map[string]interface{}.
func extractScalar(m map[string]interface{}) (float64, error) {
	for _, key := range []string{"output", "value", "result"} {
		if v, ok := m[key]; ok {
			if f, err := toFloat64(v); err == nil {
				if f < 0 || math.IsInf(f, 0) || math.IsNaN(f) {
					return 0, fmt.Errorf("model output must be a non-negative finite number")
				}
				return f, nil
			}
		}
	}
	for _, v := range m {
		if f, err := toFloat64(v); err == nil {
			if f < 0 || math.IsInf(f, 0) || math.IsNaN(f) {
				return 0, fmt.Errorf("model output must be a non-negative finite number")
			}
			return f, nil
		}
	}
	return 0, fmt.Errorf("model output map contains no numeric value")
}

func toFloat64(v interface{}) (float64, error) {
	switch t := v.(type) {
	case float64:
		return t, nil
	case float32:
		return float64(t), nil
	case int:
		return float64(t), nil
	case int32:
		return float64(t), nil
	case int64:
		return float64(t), nil
	}
	return 0, fmt.Errorf("unsupported type %T", v)
}

// ─────────────────────────────────────────────────────────────────────────────
// Anomaly Detection
// Reference: compute/ml-inference/src/anomaly_detection.rs — AnomalyDetector
// ─────────────────────────────────────────────────────────────────────────────

// DetectAnomaly classifies a feature vector using Tukey IQR fences.
//
// IQR-based detection is robust against a single outlier inflating the
// mean/stddev, which would mask it in a naive z-score approach.
// This mirrors the logic of Rust AnomalyDetector.detect_sensor_fault:
//  1. Sort feature values; compute Q1 (25th pct) and Q3 (75th pct).
//  2. IQR = Q3 − Q1 (floored at 1e-6).
//  3. Tukey fences: lower = Q1 − 1.5·IQR,  upper = Q3 + 1.5·IQR.
//  4. maxExtent = maximum distance of any value beyond a fence, normalised by IQR.
//  5. score = 0 when no outlier; 0.5 + maxExtent/(maxExtent+2)·0.5 otherwise.
//  6. isAnomaly iff score > 0.5.
func (b *GoBackend) DetectAnomaly(_ context.Context, features map[string]float64) (*AnomalyScore, error) {
	if len(features) == 0 {
		return nil, fmt.Errorf("features cannot be empty")
	}

	values := make([]float64, 0, len(features))
	for _, v := range features {
		if math.IsInf(v, 0) || math.IsNaN(v) {
			return nil, fmt.Errorf("feature values must be finite")
		}
		values = append(values, v)
	}

	sort.Float64s(values)
	n := len(values)

	// Quartile indices — integer division, matches Rust n/4 and 3*n/4.
	q1 := values[n/4]
	q3Idx := (3 * n) / 4
	if q3Idx >= n {
		q3Idx = n - 1
	}
	q3 := values[q3Idx]

	iqr := math.Abs(q3 - q1)
	if iqr < 1e-6 {
		iqr = 1e-6
	}
	lowerFence := q1 - 1.5*iqr
	upperFence := q3 + 1.5*iqr

	maxExtent := 0.0
	for _, v := range values {
		if v < lowerFence {
			if ext := (lowerFence - v) / iqr; ext > maxExtent {
				maxExtent = ext
			}
		} else if v > upperFence {
			if ext := (v - upperFence) / iqr; ext > maxExtent {
				maxExtent = ext
			}
		}
	}

	// Monotonically maps (0,∞) to (0.5, 1.0) so any outlier exceeds the threshold.
	const scoreThreshold = 0.5
	var score float64
	if maxExtent > 0 {
		score = 0.5 + math.Min(maxExtent/(maxExtent+2.0), 1.0)*0.5
	}

	return &AnomalyScore{
		Score:     score,
		Threshold: scoreThreshold,
		IsAnomaly: score > scoreThreshold,
	}, nil
}

// ─────────────────────────────────────────────────────────────────────────────
// Degradation Forecasting
// Reference: compute/ml-inference/src/degradation_forecasting.rs — DegradationForecaster
// ─────────────────────────────────────────────────────────────────────────────

// ForecastDegradation fits a linear trend to the time series and projects
// forward by timeSteps, matching the Rust forecast_linear logic.
//
// Algorithm:
//  1. Ordinary least-squares linear regression over (i, timeSeries[i]).
//  2. Compute slope (trend per step) and intercept.
//  3. Project timeSteps future values: prediction[k] = intercept + slope*(last+k+1).
//  4. Compute R² as a quality measure; confidence = R² × max(0.5, 1−decay·steps).
func (b *GoBackend) ForecastDegradation(_ context.Context, timeSeries []float64, timeSteps int) (*DegradationForecast, error) {
	if len(timeSeries) < 2 {
		return nil, fmt.Errorf("time series must have at least 2 points")
	}
	if timeSteps <= 0 {
		return nil, fmt.Errorf("time steps must be positive")
	}
	for i, v := range timeSeries {
		if math.IsInf(v, 0) || math.IsNaN(v) {
			return nil, fmt.Errorf("time series value at index %d must be finite", i)
		}
	}

	slope, intercept := olsLinear(timeSeries)

	lastIdx := float64(len(timeSeries) - 1)
	projected := make([]float64, timeSteps)
	for k := range projected {
		pred := intercept + slope*(lastIdx+float64(k+1))
		if pred < 0 {
			pred = 0
		}
		projected[k] = pred
	}

	r2 := computeR2(timeSeries, slope, intercept)
	if r2 < 0 {
		r2 = 0
	}
	confidence := r2 * math.Max(0.5, 1.0-b.confidenceDecayPerStep*float64(timeSteps))

	return &DegradationForecast{
		TrendSlope:    slope,
		ProjectedVals: projected,
		Confidence:    confidence,
	}, nil
}

// olsLinear computes OLS slope and intercept for (i, y[i]).
func olsLinear(y []float64) (slope, intercept float64) {
	n := float64(len(y))
	var sumX, sumY, sumXY, sumX2 float64
	for i, v := range y {
		x := float64(i)
		sumX += x
		sumY += v
		sumXY += x * v
		sumX2 += x * x
	}
	denom := n*sumX2 - sumX*sumX
	if math.Abs(denom) < 1e-10 {
		return 0, sumY / n
	}
	slope = (n*sumXY - sumX*sumY) / denom
	intercept = (sumY - slope*sumX) / n
	return
}

// computeR2 returns the coefficient of determination R² for a linear fit.
func computeR2(y []float64, slope, intercept float64) float64 {
	n := float64(len(y))
	meanY := 0.0
	for _, v := range y {
		meanY += v
	}
	meanY /= n

	var ssRes, ssTot float64
	for i, v := range y {
		yHat := intercept + slope*float64(i)
		ssRes += (v - yHat) * (v - yHat)
		ssTot += (v - meanY) * (v - meanY)
	}
	if ssTot < 1e-10 {
		return 1.0
	}
	return 1.0 - ssRes/ssTot
}

// ─────────────────────────────────────────────────────────────────────────────
// Health
// ─────────────────────────────────────────────────────────────────────────────

// Health always returns nil — the Go backend has no external dependencies.
func (b *GoBackend) Health(_ context.Context) error {
	return nil
}

