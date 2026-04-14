package handler

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"solar3d/ml-service/internal/service"
	"solar3d/shared/middleware"
)

// Handler implements HTTP REST handlers for ML inference operations
type Handler struct {
	svc *service.Service
}

// New creates a new handler with a service
func New(svc *service.Service) *Handler {
	return &Handler{svc: svc}
}

// RegisterHTTPRoutes registers all HTTP REST routes with the mux
func (h *Handler) RegisterHTTPRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /yield", h.handlePredictYield)
	mux.HandleFunc("POST /anomaly", h.handleDetectAnomaly)
	mux.HandleFunc("POST /degradation", h.handleForecastDegradation)
	log.Println("ML HTTP routes registered")
}

func (h *Handler) handlePredictYield(w http.ResponseWriter, r *http.Request) {
	var req PredictYieldRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.PredictYield(r.Context(), &req)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Yield prediction failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, result)
}

func (h *Handler) handleDetectAnomaly(w http.ResponseWriter, r *http.Request) {
	var req DetectAnomalyRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.DetectAnomaly(r.Context(), &req)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Anomaly detection failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, result)
}

func (h *Handler) handleForecastDegradation(w http.ResponseWriter, r *http.Request) {
	var req ForecastDegradationRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.ForecastDegradation(r.Context(), &req)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Degradation forecast failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, result)
}

func (h *Handler) handleHealth(w http.ResponseWriter, r *http.Request) {
	err := h.Health(r.Context())
	if err != nil {
		middleware.WriteError(w, http.StatusServiceUnavailable, "Health check failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, map[string]string{"status": "ok"})
}

// PredictYieldRequest holds yield prediction parameters
type PredictYieldRequest struct {
	ModelOutput  map[string]interface{} `json:"model_output"`
	Uncertainty  float64                `json:"uncertainty"`
	Temperature  float64                `json:"temperature"`
	Irradiance   float64                `json:"irradiance"`
	Humidity     float64                `json:"humidity"`
	Pressure     float64                `json:"pressure"`
	WindSpeed    float64                `json:"wind_speed"`
	Altitude     float64                `json:"altitude"`
	Azimuth      float64                `json:"azimuth"`
	AirMass      float64                `json:"air_mass"`
	ClearnessIdx float64                `json:"clearness_index"`
}

func (h *Handler) PredictYield(ctx context.Context, req *PredictYieldRequest) (map[string]interface{}, error) {
	if req == nil {
		return nil, fmt.Errorf("validation failed: request is nil")
	}
	if len(req.ModelOutput) == 0 {
		return nil, fmt.Errorf("validation failed: model output is required")
	}

	weather := &service.WeatherFeatures{
		Temperature: req.Temperature,
		Irradiance:  req.Irradiance,
		Humidity:    req.Humidity,
		Pressure:    req.Pressure,
		WindSpeed:   req.WindSpeed,
	}
	solar := &service.SolarFeatures{
		Altitude:     req.Altitude,
		Azimuth:      req.Azimuth,
		AirMass:      req.AirMass,
		ClearnessIdx: req.ClearnessIdx,
	}

	result, err := h.svc.PredictYield(ctx, req.ModelOutput, req.Uncertainty, weather, solar)
	if err != nil {
		log.Printf("PredictYield error: %v", err)
		return nil, fmt.Errorf("yield prediction failed: %w", err)
	}

	return map[string]interface{}{"expected_yield": result.ExpectedYield, "p5": result.P5, "p95": result.P95, "confidence": result.Confidence}, nil
}

// DetectAnomalyRequest holds anomaly detection parameters
type DetectAnomalyRequest struct {
	Features map[string]float64 `json:"features"`
}

func (h *Handler) DetectAnomaly(ctx context.Context, req *DetectAnomalyRequest) (map[string]interface{}, error) {
	if req == nil {
		return nil, fmt.Errorf("validation failed: request is nil")
	}
	if len(req.Features) == 0 {
		return nil, fmt.Errorf("validation failed: features cannot be empty")
	}

	result, err := h.svc.DetectAnomaly(ctx, req.Features)
	if err != nil {
		log.Printf("DetectAnomaly error: %v", err)
		return nil, fmt.Errorf("anomaly detection failed: %w", err)
	}

	return map[string]interface{}{"score": result.Score, "threshold": result.Threshold, "is_anomaly": result.IsAnomaly}, nil
}

// ForecastDegradationRequest holds degradation forecasting parameters
type ForecastDegradationRequest struct {
	TimeSeries []float64 `json:"time_series"`
	TimeSteps  int       `json:"time_steps"`
}

func (h *Handler) ForecastDegradation(ctx context.Context, req *ForecastDegradationRequest) (map[string]interface{}, error) {
	if req == nil {
		return nil, fmt.Errorf("validation failed: request is nil")
	}
	if len(req.TimeSeries) < 2 {
		return nil, fmt.Errorf("validation failed: time series must have at least 2 points")
	}
	if req.TimeSteps <= 0 {
		return nil, fmt.Errorf("validation failed: time steps must be positive")
	}

	result, err := h.svc.ForecastDegradation(ctx, req.TimeSeries, req.TimeSteps)
	if err != nil {
		log.Printf("ForecastDegradation error: %v", err)
		return nil, fmt.Errorf("degradation forecasting failed: %w", err)
	}

	return map[string]interface{}{"trend_slope": result.TrendSlope, "projected_values": result.ProjectedVals, "confidence": result.Confidence}, nil
}

// Health checks service health
func (h *Handler) Health(ctx context.Context) error {
	return h.svc.Health(ctx)
}

