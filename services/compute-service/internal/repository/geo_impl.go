package repository

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"solar3d/compute-service/internal/models"
)

type RustGeoRepository struct {
	baseURL string
	client  *http.Client
}

func NewRustGeoRepository(baseURL string) *RustGeoRepository {
	normalized := strings.TrimRight(baseURL, "/")
	if normalized == "" {
		normalized = "http://127.0.0.1:8087"
	}
	return &RustGeoRepository{baseURL: normalized, client: &http.Client{Timeout: 10 * time.Second}}
}

func (r *RustGeoRepository) BufferPoint(ctx context.Context, req *models.BufferPointRequest) (*models.BufferPointResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.BufferPointResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/geo/buffer-point", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustGeoRepository) NearestPoint(ctx context.Context, req *models.NearestPointRequest) (*models.NearestPointResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.NearestPointResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/geo/nearest-point", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustGeoRepository) GenerateContours(ctx context.Context, req *models.GenerateContoursRequest) (*models.GenerateContoursResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.GenerateContoursResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/geo/contours", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

