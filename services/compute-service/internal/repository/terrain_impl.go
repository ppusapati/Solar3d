package repository

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
)

type RustTerrainRepository struct {
	baseURL string
	client  *http.Client
}

func NewRustTerrainRepository(baseURL string) *RustTerrainRepository {
	normalized := strings.TrimRight(baseURL, "/")
	if normalized == "" {
		normalized = "http://127.0.0.1:8084"
	}
	return &RustTerrainRepository{
		baseURL: normalized,
		client:  &http.Client{Timeout: 10 * time.Second},
	}
}

func (r *RustTerrainRepository) GetElevation(ctx context.Context, req *models.GetElevationRequest) (*models.GetElevationResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := terrainGetElevationPayload{ProjectID: req.ProjectID, Longitude: req.Longitude, Latitude: req.Latitude}
	var out models.GetElevationResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/terrain/elevation", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustTerrainRepository) GetElevationGrid(ctx context.Context, req *models.GetElevationGridRequest) (*models.GetElevationGridResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := terrainGetElevationGridPayload{ProjectID: req.ProjectID, Bounds: req.Bounds, ResolutionM: req.ResolutionM}
	var out models.GetElevationGridResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/terrain/elevation-grid", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustTerrainRepository) ComputeSlope(ctx context.Context, req *models.ComputeSlopeRequest) (*models.ComputeSlopeResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := terrainLayerRequestPayload{TerrainLayerID: req.TerrainLayerID}
	var out models.ComputeSlopeResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/terrain/slope", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustTerrainRepository) ComputeAspect(ctx context.Context, req *models.ComputeAspectRequest) (*models.ComputeAspectResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := terrainLayerRequestPayload{TerrainLayerID: req.TerrainLayerID}
	var out models.ComputeAspectResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/terrain/aspect", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

type terrainGetElevationPayload struct {
	ProjectID string  `json:"project_id"`
	Longitude float64 `json:"longitude"`
	Latitude  float64 `json:"latitude"`
}

type terrainGetElevationGridPayload struct {
	ProjectID   string                  `json:"project_id"`
	Bounds      models.BoundingBoxModel `json:"bounds"`
	ResolutionM float64                 `json:"resolution_m"`
}

type terrainLayerRequestPayload struct {
	TerrainLayerID string `json:"terrain_layer_id"`
}

