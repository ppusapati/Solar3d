package repository

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"solar3d/compute-service/internal/models"
)

type RustSimulationRepository struct {
	baseURL string
	client  *http.Client
}

func NewRustSimulationRepository(baseURL string) *RustSimulationRepository {
	normalized := strings.TrimRight(baseURL, "/")
	if normalized == "" {
		normalized = "http://127.0.0.1:8083"
	}
	return &RustSimulationRepository{
		baseURL: normalized,
		client:  &http.Client{Timeout: 10 * time.Second},
	}
}

func (r *RustSimulationRepository) GetSunPosition(ctx context.Context, req *models.GetSunPositionRequest) (*models.GetSunPositionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := simGetSunPositionPayload{
		Latitude:      req.Latitude,
		Longitude:     req.Longitude,
		TimestampUnix: req.TimestampUnix,
	}
	var out models.GetSunPositionResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/solar/sun-position", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustSimulationRepository) GetShadowMap(ctx context.Context, req *models.GetShadowMapRequest) (*models.GetShadowMapResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := simGetShadowMapPayload{
		LayoutID:      req.LayoutID,
		Latitude:      req.Latitude,
		Longitude:     req.Longitude,
		TimestampUnix: req.TimestampUnix,
	}
	var out models.GetShadowMapResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/solar/shadow-map", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

type simGetSunPositionPayload struct {
	Latitude      float64 `json:"latitude"`
	Longitude     float64 `json:"longitude"`
	TimestampUnix int64   `json:"timestamp_unix"`
}

type simGetShadowMapPayload struct {
	LayoutID      string  `json:"layout_id"`
	Latitude      float64 `json:"latitude"`
	Longitude     float64 `json:"longitude"`
	TimestampUnix int64   `json:"timestamp_unix"`
}

