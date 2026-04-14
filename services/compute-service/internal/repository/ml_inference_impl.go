package repository

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"solar3d/compute-service/internal/models"
)

// RustMLInferenceRepository implements MLInferenceRepository
type RustMLInferenceRepository struct {
	baseURL string
	client  *http.Client
}

// NewRustMLInferenceRepository creates a new repository instance
func NewRustMLInferenceRepository(baseURL string) *RustMLInferenceRepository {
	normalized := strings.TrimRight(baseURL, "/")
	if normalized == "" {
		normalized = "http://127.0.0.1:8081"
	}

	return &RustMLInferenceRepository{
		baseURL: normalized,
		client: &http.Client{
			Timeout: 10 * time.Second,
		},
	}
}

// ExtractFeatures calls the ml-inference Rust crate
func (r *RustMLInferenceRepository) ExtractFeatures(ctx context.Context, req *models.ExtractFeaturesRequest) (*models.FeatureVectorModel, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}

	payload := extractFeaturesBridgeRequest{
		Weather: weatherPayload{
			TemperatureC: req.Weather.TemperatureCelsius,
			Irradiance:   req.Weather.IrradianceWM2,
			Humidity:     req.Weather.HumidityPercent,
			Pressure:     req.Weather.PressureMb,
			WindSpeed:    req.Weather.WindSpeedMS,
		},
		Solar: solarPayload{
			Altitude:       req.Solar.SolarAltitudeDeg,
			Azimuth:        req.Solar.SolarAzimuthDeg,
			AirMass:        req.Solar.AirMass,
			ClearnessIndex: req.Solar.ClearnessIndex,
		},
		Time: timePayload{
			HourOfDay: req.Time.HourOfDay,
			DayOfYear: req.Time.DayOfYear,
			Month:     req.Time.Month,
			IsWeekend: req.Time.IsWeekend,
		},
	}

	var bridgeResp extractFeaturesBridgeResponse
	if err := r.postJSON(ctx, "/v1/ml/features/extract", payload, &bridgeResp); err != nil {
		return nil, fmt.Errorf("failed to decode bridge response: %w", err)
	}

	return &models.FeatureVectorModel{
		Features:     bridgeResp.Features,
		FeatureNames: bridgeResp.FeatureNames,
		FeatureCount: int32(bridgeResp.FeatureCount),
		ExtractedAt:  bridgeResp.ExtractedAt,
	}, nil
}

func (r *RustMLInferenceRepository) PredictYield(ctx context.Context, req *models.YieldPredictionRequest) (*models.YieldPredictionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}

	payload := predictYieldBridgeRequest{
		ModelOutput:         req.ModelOutput,
		UncertaintyEstimate: req.UncertaintyEstimate,
	}

	var bridgeResp predictYieldBridgeResponse
	if err := r.postJSON(ctx, "/v1/ml/yield/predict", payload, &bridgeResp); err != nil {
		return nil, err
	}

	return &models.YieldPredictionResponse{
		Forecast: models.YieldForecastModel{
			PredictedYieldKwh: bridgeResp.Forecast.PredictedYieldKwh,
			ConfidenceLower:   bridgeResp.Forecast.ConfidenceLower,
			ConfidenceUpper:   bridgeResp.Forecast.ConfidenceUpper,
			ExpectedValue:     bridgeResp.Forecast.ExpectedValue,
			Variance:          bridgeResp.Forecast.Variance,
		},
		EnsembleForecasts: []models.YieldForecastModel{},
	}, nil
}

func (r *RustMLInferenceRepository) DetectAnomaly(ctx context.Context, req *models.AnomalyDetectionRequest) (*models.AnomalyDetectionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}

	payload := detectAnomalyBridgeRequest{
		ExpectedYield:   req.ExpectedYield,
		ActualYield:     req.ActualYield,
		ModelPrediction: req.ModelPrediction,
		SensorVariance:  req.SensorVariance,
	}

	var bridgeResp detectAnomalyBridgeResponse
	if err := r.postJSON(ctx, "/v1/ml/anomaly/detect", payload, &bridgeResp); err != nil {
		return nil, err
	}

	return &models.AnomalyDetectionResponse{
		Score: models.AnomalyScoreModel{
			Score:       bridgeResp.Score,
			AnomalyType: bridgeResp.AnomalyType,
			Confidence:  bridgeResp.Confidence,
		},
		IsAnomalous:    bridgeResp.IsAnomalous,
		Recommendation: bridgeResp.Recommendation,
	}, nil
}

func (r *RustMLInferenceRepository) ForecastDegradation(ctx context.Context, req *models.DegradationRequest) (*models.DegradationResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}

	payload := forecastDegradationBridgeRequest{
		CurrentDegradation: req.CurrentDegradation,
		AnnualRate:         req.AnnualRate,
		Years:              req.Years,
		EndOfLifeThreshold: req.EndOfLifeThreshold,
	}

	var bridgeResp forecastDegradationBridgeResponse
	if err := r.postJSON(ctx, "/v1/ml/degradation/forecast", payload, &bridgeResp); err != nil {
		return nil, err
	}

	return &models.DegradationResponse{
		Forecast: models.DegradationForecastModel{
			CurrentDegradationPercent: bridgeResp.Forecast.CurrentDegradationPercent,
			AnnualDegradationRate:     bridgeResp.Forecast.AnnualDegradationRate,
			ProjectedDegradation5Yr:   bridgeResp.Forecast.ProjectedDegradation5Yr,
			ProjectedDegradation10Yr:  bridgeResp.Forecast.ProjectedDegradation10Yr,
			ConfidenceInterval:        bridgeResp.Forecast.ConfidenceInterval,
		},
		RemainingUsefulLifeYears: bridgeResp.RemainingUsefulLifeYears,
	}, nil
}

func (r *RustMLInferenceRepository) postJSON(ctx context.Context, path string, payload any, out any) error {
	return postJSONWithClient(ctx, r.client, r.baseURL+path, payload, out)
}

func postJSONWithClient(ctx context.Context, client *http.Client, url string, payload any, out any) error {
	body, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal bridge request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(
		ctx,
		http.MethodPost,
		url,
		bytes.NewReader(body),
	)
	if err != nil {
		return fmt.Errorf("failed to create bridge request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	httpResp, err := client.Do(httpReq)
	if err != nil {
		return fmt.Errorf("bridge request failed: %w", err)
	}
	defer httpResp.Body.Close()

	respBody, err := io.ReadAll(httpResp.Body)
	if err != nil {
		return fmt.Errorf("failed to read bridge response: %w", err)
	}

	if httpResp.StatusCode != http.StatusOK {
		var bridgeErr bridgeErrorResponse
		if json.Unmarshal(respBody, &bridgeErr) == nil && bridgeErr.Error != "" {
			return fmt.Errorf("bridge error (%d): %s", httpResp.StatusCode, bridgeErr.Error)
		}
		return fmt.Errorf("bridge error (%d): %s", httpResp.StatusCode, string(respBody))
	}

	if err := json.Unmarshal(respBody, out); err != nil {
		return fmt.Errorf("failed to decode bridge response: %w", err)
	}

	return nil
}

type extractFeaturesBridgeRequest struct {
	Weather weatherPayload `json:"weather"`
	Solar   solarPayload   `json:"solar"`
	Time    timePayload    `json:"time"`
}

type weatherPayload struct {
	TemperatureC float64 `json:"temperature_c"`
	Irradiance   float64 `json:"irradiance_w_m2"`
	Humidity     float64 `json:"humidity_percent"`
	Pressure     float64 `json:"pressure_mb"`
	WindSpeed    float64 `json:"wind_speed_m_s"`
}

type solarPayload struct {
	Altitude       float64 `json:"solar_altitude_deg"`
	Azimuth        float64 `json:"solar_azimuth_deg"`
	AirMass        float64 `json:"air_mass"`
	ClearnessIndex float64 `json:"clearness_index"`
}

type timePayload struct {
	HourOfDay int32 `json:"hour_of_day"`
	DayOfYear int32 `json:"day_of_year"`
	Month     int32 `json:"month"`
	IsWeekend bool  `json:"is_weekend"`
}

type extractFeaturesBridgeResponse struct {
	Features     []float64 `json:"features"`
	FeatureNames []string  `json:"feature_names"`
	FeatureCount int       `json:"feature_count"`
	ExtractedAt  int64     `json:"extracted_at"`
}

type bridgeErrorResponse struct {
	Error string `json:"error"`
}

type predictYieldBridgeRequest struct {
	ModelOutput         float64 `json:"model_output"`
	UncertaintyEstimate float64 `json:"uncertainty_estimate"`
}

type yieldForecastBridgePayload struct {
	PredictedYieldKwh float64 `json:"predicted_yield_kwh"`
	ConfidenceLower   float64 `json:"confidence_lower"`
	ConfidenceUpper   float64 `json:"confidence_upper"`
	ExpectedValue     float64 `json:"expected_value"`
	Variance          float64 `json:"variance"`
}

type predictYieldBridgeResponse struct {
	Forecast yieldForecastBridgePayload `json:"forecast"`
}

type detectAnomalyBridgeRequest struct {
	ExpectedYield   float64 `json:"expected_yield"`
	ActualYield     float64 `json:"actual_yield"`
	ModelPrediction float64 `json:"model_prediction"`
	SensorVariance  float64 `json:"sensor_variance"`
}

type detectAnomalyBridgeResponse struct {
	Score          float64 `json:"score"`
	AnomalyType    string  `json:"anomaly_type"`
	Confidence     float64 `json:"confidence"`
	IsAnomalous    bool    `json:"is_anomalous"`
	Recommendation string  `json:"recommendation"`
}

type forecastDegradationBridgeRequest struct {
	CurrentDegradation float64 `json:"current_degradation"`
	AnnualRate         float64 `json:"annual_rate"`
	Years              int32   `json:"years"`
	EndOfLifeThreshold float64 `json:"end_of_life_threshold"`
}

type degradationForecastBridgePayload struct {
	CurrentDegradationPercent float64 `json:"current_degradation_percent"`
	AnnualDegradationRate     float64 `json:"annual_degradation_rate"`
	ProjectedDegradation5Yr   float64 `json:"projected_degradation_5yr"`
	ProjectedDegradation10Yr  float64 `json:"projected_degradation_10yr"`
	ConfidenceInterval        float64 `json:"confidence_interval"`
}

type forecastDegradationBridgeResponse struct {
	Forecast                 degradationForecastBridgePayload `json:"forecast"`
	RemainingUsefulLifeYears float64                          `json:"remaining_useful_life_years"`
}

