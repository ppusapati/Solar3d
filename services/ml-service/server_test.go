package main

import (
	"context"
	"testing"

	"p9e.in/samavaya/solar3d/ml-service/internal/handler"
	"p9e.in/samavaya/solar3d/ml-service/internal/service"
)

// newHandler creates a handler wired to the pure-Go backend for testing.
func newHandler() *handler.Handler {
	return handler.New(service.New(service.NewGoBackend()))
}

// ─────────────────────────────────────────────────────────────────────────────
// Positive-path tests — verify the Go backend produces sane values
// ─────────────────────────────────────────────────────────────────────────────

func TestPredictYield(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	result, err := h.PredictYield(ctx, &handler.PredictYieldRequest{
		ModelOutput:  map[string]interface{}{"output": 1000.0},
		Uncertainty:  0.1,
		Temperature:  25.0,
		Irradiance:   800.0,
		Humidity:     60.0,
		Pressure:     1013.0,
		WindSpeed:    5.0,
		Altitude:     30.0,
		Azimuth:      180.0,
		AirMass:      1.5,
		ClearnessIdx: 0.8,
	})
	if err != nil {
		t.Fatalf("PredictYield: unexpected error: %v", err)
	}

	expectedYield, ok := result["expected_yield"].(float64)
	if !ok || expectedYield <= 0 {
		t.Fatalf("expected positive expected_yield, got %v", result["expected_yield"])
	}
	p5, _ := result["p5"].(float64)
	p95, _ := result["p95"].(float64)
	if p5 >= p95 {
		t.Fatalf("expected p5 < p95, got p5=%v p95=%v", p5, p95)
	}
	if p5 > expectedYield || expectedYield > p95 {
		t.Fatalf("expected_yield must be within [p5, p95]: %v not in [%v, %v]", expectedYield, p5, p95)
	}
	confidence, _ := result["confidence"].(float64)
	if confidence < 0 || confidence > 1 {
		t.Fatalf("confidence out of [0,1]: %v", confidence)
	}
}

func TestPredictYieldZeroIrradiance(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	result, err := h.PredictYield(ctx, &handler.PredictYieldRequest{
		ModelOutput:  map[string]interface{}{"output": 500.0},
		Uncertainty:  0.2,
		Temperature:  20.0,
		Irradiance:   0.0, // night or total cloud cover
		ClearnessIdx: 0.0,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	// Zero irradiance → zero yield
	if y, _ := result["expected_yield"].(float64); y != 0 {
		t.Fatalf("expected zero yield at zero irradiance, got %v", y)
	}
}

func TestPredictYieldHotTemperature(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	base, _ := h.PredictYield(ctx, &handler.PredictYieldRequest{
		ModelOutput:  map[string]interface{}{"output": 1000.0},
		Temperature:  25.0,
		Irradiance:   1000.0,
		ClearnessIdx: 1.0,
	})
	hot, _ := h.PredictYield(ctx, &handler.PredictYieldRequest{
		ModelOutput:  map[string]interface{}{"output": 1000.0},
		Temperature:  50.0, // 25 °C above reference → −10 % yield
		Irradiance:   1000.0,
		ClearnessIdx: 1.0,
	})
	baseY, _ := base["expected_yield"].(float64)
	hotY, _ := hot["expected_yield"].(float64)
	if hotY >= baseY {
		t.Fatalf("higher temperature should reduce yield: base=%v hot=%v", baseY, hotY)
	}
}

func TestDetectAnomaly(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	result, err := h.DetectAnomaly(ctx, &handler.DetectAnomalyRequest{
		Features: map[string]float64{
			"irradiance":  800.0,
			"temperature": 25.0,
			"humidity":    60.0,
		},
	})
	if err != nil {
		t.Fatalf("DetectAnomaly: unexpected error: %v", err)
	}
	score, _ := result["score"].(float64)
	if score < 0 || score > 1 {
		t.Fatalf("score must be in [0,1]: %v", score)
	}
	// Uniform distribution: very similar values → low score, not anomalous.
	if isAnomaly, _ := result["is_anomaly"].(bool); isAnomaly {
		t.Fatalf("uniform feature values should not be anomalous, score=%v", score)
	}
}

func TestDetectAnomalyOutlier(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	result, err := h.DetectAnomaly(ctx, &handler.DetectAnomalyRequest{
		Features: map[string]float64{
			"a": 100.0,
			"b": 101.0,
			"c": 99.0,
			"d": 100.5,
			"e": 1000.0, // extreme outlier
		},
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if isAnomaly, _ := result["is_anomaly"].(bool); !isAnomaly {
		t.Fatalf("extreme outlier should be anomalous, score=%v", result["score"])
	}
}

func TestForecastDegradation(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	result, err := h.ForecastDegradation(ctx, &handler.ForecastDegradationRequest{
		TimeSeries: []float64{1000, 995, 989, 983, 977},
		TimeSteps:  10,
	})
	if err != nil {
		t.Fatalf("ForecastDegradation: unexpected error: %v", err)
	}

	slope, _ := result["trend_slope"].(float64)
	if slope >= 0 {
		t.Fatalf("expected negative slope for declining series, got %v", slope)
	}

	projected, ok := result["projected_values"].([]float64)
	if !ok || len(projected) != 10 {
		t.Fatalf("expected 10 projected values, got %T len=%d", result["projected_values"], len(projected))
	}

	confidence, _ := result["confidence"].(float64)
	if confidence < 0 || confidence > 1 {
		t.Fatalf("confidence out of [0,1]: %v", confidence)
	}
}

func TestForecastDegradationFlatSeries(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	result, err := h.ForecastDegradation(ctx, &handler.ForecastDegradationRequest{
		TimeSeries: []float64{500, 500, 500, 500, 500},
		TimeSteps:  5,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	slope, _ := result["trend_slope"].(float64)
	if slope != 0 {
		t.Fatalf("flat series should have zero slope, got %v", slope)
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Validation tests — handler should reject bad input before reaching the backend
// ─────────────────────────────────────────────────────────────────────────────

func TestPredictYieldValidation(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	_, err := h.PredictYield(ctx, &handler.PredictYieldRequest{})
	if err == nil {
		t.Fatal("expected error for empty model output")
	}
}

func TestDetectAnomalyValidation(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	_, err := h.DetectAnomaly(ctx, &handler.DetectAnomalyRequest{
		Features: map[string]float64{},
	})
	if err == nil {
		t.Fatal("expected error for empty features")
	}
}

func TestForecastDegradationValidation(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	_, err := h.ForecastDegradation(ctx, &handler.ForecastDegradationRequest{
		TimeSeries: []float64{1000},
		TimeSteps:  10,
	})
	if err == nil {
		t.Fatal("expected error for time series too short")
	}
}

func TestInvalidTimeSteps(t *testing.T) {
	ctx := context.Background()
	h := newHandler()

	_, err := h.ForecastDegradation(ctx, &handler.ForecastDegradationRequest{
		TimeSeries: []float64{1000, 995},
		TimeSteps:  0,
	})
	if err == nil {
		t.Fatal("expected error for zero time steps")
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Determinism — same inputs must always produce the same outputs
// ─────────────────────────────────────────────────────────────────────────────

func TestYieldPredictionIsDeterministic(t *testing.T) {
	ctx := context.Background()
	req := &handler.PredictYieldRequest{
		ModelOutput:  map[string]interface{}{"output": 750.0},
		Uncertainty:  0.15,
		Temperature:  30.0,
		Irradiance:   900.0,
		ClearnessIdx: 0.85,
	}

	h := newHandler()
	r1, _ := h.PredictYield(ctx, req)
	r2, _ := h.PredictYield(ctx, req)
	if r1["expected_yield"] != r2["expected_yield"] {
		t.Fatalf("non-deterministic: %v vs %v", r1["expected_yield"], r2["expected_yield"])
	}
}

func TestAnomalyDetectionIsDeterministic(t *testing.T) {
	ctx := context.Background()
	req := &handler.DetectAnomalyRequest{
		Features: map[string]float64{"a": 1.0, "b": 2.0, "c": 100.0},
	}

	h := newHandler()
	r1, _ := h.DetectAnomaly(ctx, req)
	r2, _ := h.DetectAnomaly(ctx, req)
	if r1["score"] != r2["score"] {
		t.Fatalf("non-deterministic: %v vs %v", r1["score"], r2["score"])
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Benchmarks
// ─────────────────────────────────────────────────────────────────────────────

func BenchmarkYieldPrediction(b *testing.B) {
	ctx := context.Background()
	h := newHandler()
	req := &handler.PredictYieldRequest{
		ModelOutput:  map[string]interface{}{"output": 1000.0},
		Uncertainty:  0.1,
		Temperature:  25.0,
		Irradiance:   800.0,
		ClearnessIdx: 0.8,
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		h.PredictYield(ctx, req) //nolint:errcheck
	}
}

func BenchmarkAnomalyDetection(b *testing.B) {
	ctx := context.Background()
	h := newHandler()
	req := &handler.DetectAnomalyRequest{
		Features: map[string]float64{
			"irradiance": 800.0, "temperature": 25.0, "humidity": 60.0,
		},
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		h.DetectAnomaly(ctx, req) //nolint:errcheck
	}
}

func BenchmarkDegradationForecast(b *testing.B) {
	ctx := context.Background()
	h := newHandler()
	req := &handler.ForecastDegradationRequest{
		TimeSeries: []float64{1000, 995, 989, 983, 977, 971, 964},
		TimeSteps:  20,
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		h.ForecastDegradation(ctx, req) //nolint:errcheck
	}
}

