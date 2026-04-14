package client

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// MLClient wraps HTTP calls to the Rust ml-inference bridge
type MLClient struct {
	baseURL string
	client  *http.Client
}

// New creates a new MLClient
func New(baseURL string) *MLClient {
	return &MLClient{
		baseURL: baseURL,
		client: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

// WeatherFeatures represents weather input for yield forecasting
type WeatherFeatures struct {
	Temperature float64 `json:"temperature"`
	Irradiance  float64 `json:"irradiance"`
	Humidity    float64 `json:"humidity"`
	Pressure    float64 `json:"pressure"`
	WindSpeed   float64 `json:"wind_speed"`
}

// SolarFeatures represents solar geometry input
type SolarFeatures struct {
	Altitude     float64 `json:"altitude"`
	Azimuth      float64 `json:"azimuth"`
	AirMass      float64 `json:"air_mass"`
	ClearnessIdx float64 `json:"clearness_index"`
}

// YieldForecastRequest is the request for yield forecasting
type YieldForecastRequest struct {
	ModelOutput map[string]interface{} `json:"model_output"`
	Uncertainty float64                `json:"uncertainty"`
	Weather     WeatherFeatures        `json:"weather"`
	Solar       SolarFeatures          `json:"solar"`
}

// YieldForecast is the result of yield forecasting
type YieldForecast struct {
	ExpectedYield float64 `json:"expected_yield"`
	P5            float64 `json:"p5"`
	P95           float64 `json:"p95"`
	Confidence    float64 `json:"confidence"`
	Error         string  `json:"error,omitempty"`
}

// ForecastYield predicts solar yield with confidence intervals
func (c *MLClient) ForecastYield(ctx context.Context, modelOutput map[string]interface{}, uncertainty float64,
	weather *WeatherFeatures, solar *SolarFeatures) (*YieldForecast, error) {

	payload := YieldForecastRequest{
		ModelOutput: modelOutput,
		Uncertainty: uncertainty,
		Weather:     *weather,
		Solar:       *solar,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/forecast/yield", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var result YieldForecast
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("unmarshal response: %w", err)
	}

	if result.Error != "" {
		return nil, fmt.Errorf("compute error: %s", result.Error)
	}

	return &result, nil
}

// AnomalyDetectionRequest is the request for anomaly detection
type AnomalyDetectionRequest struct {
	Features map[string]float64 `json:"features"`
}

// AnomalyScore is the result of anomaly detection
type AnomalyScore struct {
	Score     float64 `json:"score"`
	Threshold float64 `json:"threshold"`
	IsAnomaly bool    `json:"is_anomaly"`
	Error     string  `json:"error,omitempty"`
}

// DetectAnomaly scores a data point for anomaly
func (c *MLClient) DetectAnomaly(ctx context.Context, features map[string]float64) (*AnomalyScore, error) {
	payload := AnomalyDetectionRequest{
		Features: features,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/detect/anomaly", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var result AnomalyScore
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("unmarshal response: %w", err)
	}

	if result.Error != "" {
		return nil, fmt.Errorf("compute error: %s", result.Error)
	}

	return &result, nil
}

// DegradationForecastRequest is the request for degradation forecasting
type DegradationForecastRequest struct {
	TimeSeries []float64 `json:"time_series"`
	TimeSteps  int       `json:"time_steps"`
}

// DegradationForecast is the result of degradation forecasting
type DegradationForecast struct {
	TrendSlope    float64   `json:"trend_slope"`
	ProjectedVals []float64 `json:"projected_values"`
	Confidence    float64   `json:"confidence"`
	Error         string    `json:"error,omitempty"`
}

// ForecastDegradation predicts degradation trend
func (c *MLClient) ForecastDegradation(ctx context.Context, timeSeries []float64, timeSteps int) (*DegradationForecast, error) {
	payload := DegradationForecastRequest{
		TimeSeries: timeSeries,
		TimeSteps:  timeSteps,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/forecast/degradation", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var result DegradationForecast
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("unmarshal response: %w", err)
	}

	if result.Error != "" {
		return nil, fmt.Errorf("compute error: %s", result.Error)
	}

	return &result, nil
}

// HealthResponse is the response from a health check
type HealthResponse struct {
	Status string `json:"status"`
}

// Health checks if the Rust bridge is responding
func (c *MLClient) Health(ctx context.Context) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, c.baseURL+"/health", nil)
	if err != nil {
		return fmt.Errorf("create request: %w", err)
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("health check failed: %d, body: %s", resp.StatusCode, string(body))
	}

	var healthResp HealthResponse
	if err := json.NewDecoder(resp.Body).Decode(&healthResp); err != nil {
		return fmt.Errorf("decode health response: %w", err)
	}

	if healthResp.Status != "ok" {
		return fmt.Errorf("health status: %s", healthResp.Status)
	}

	return nil
}

