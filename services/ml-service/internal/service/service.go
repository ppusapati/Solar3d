package service

import (
	"context"
	"fmt"

	"p9e.in/samavaya/solar3d/ml-service/internal/client"
)

// MLBackend defines the contract for ML inference operations.
// It is satisfied by both the HTTP bridge client (*client.MLClient) and
// the pure-Go implementation (*GoBackend).
type MLBackend interface {
	ForecastYield(ctx context.Context, modelOutput map[string]interface{}, uncertainty float64,
		weather *WeatherFeatures, solar *SolarFeatures) (*YieldForecast, error)
	DetectAnomaly(ctx context.Context, features map[string]float64) (*AnomalyScore, error)
	ForecastDegradation(ctx context.Context, timeSeries []float64, timeSteps int) (*DegradationForecast, error)
	Health(ctx context.Context) error
}

// Type aliases to client types — shared across all backends.
type WeatherFeatures = client.WeatherFeatures
type SolarFeatures = client.SolarFeatures
type YieldForecast = client.YieldForecast
type AnomalyScore = client.AnomalyScore
type DegradationForecast = client.DegradationForecast

// Service provides machine learning inference operations.
type Service struct {
	backend MLBackend
}

// New creates a new ML service backed by any MLBackend implementation.
// Pass service.NewGoBackend() for pure-Go operation, or client.New(url) for the Rust bridge.
func New(backend MLBackend) *Service {
	return &Service{backend: backend}
}

// PredictYield predicts solar yield with confidence intervals.
func (s *Service) PredictYield(ctx context.Context, modelOutput map[string]interface{}, uncertainty float64,
	weather *WeatherFeatures, solar *SolarFeatures) (*YieldForecast, error) {

	if weather == nil {
		return nil, fmt.Errorf("weather features required")
	}
	if solar == nil {
		return nil, fmt.Errorf("solar features required")
	}
	return s.backend.ForecastYield(ctx, modelOutput, uncertainty, weather, solar)
}

// DetectAnomaly scores a data point for anomalies.
func (s *Service) DetectAnomaly(ctx context.Context, features map[string]float64) (*AnomalyScore, error) {
	if len(features) == 0 {
		return nil, fmt.Errorf("features cannot be empty")
	}
	return s.backend.DetectAnomaly(ctx, features)
}

// ForecastDegradation predicts degradation trend over time.
func (s *Service) ForecastDegradation(ctx context.Context, timeSeries []float64, timeSteps int) (*DegradationForecast, error) {
	if len(timeSeries) < 2 {
		return nil, fmt.Errorf("time series must have at least 2 points")
	}
	if timeSteps <= 0 {
		return nil, fmt.Errorf("time steps must be positive")
	}
	return s.backend.ForecastDegradation(ctx, timeSeries, timeSteps)
}

// Health checks the health of the service and its dependencies.
func (s *Service) Health(ctx context.Context) error {
	return s.backend.Health(ctx)
}

