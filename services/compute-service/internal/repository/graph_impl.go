package repository

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"solar3d/compute-service/internal/models"
)

type RustGraphRepository struct {
	baseURL string
	client  *http.Client
}

func NewRustGraphRepository(baseURL string) *RustGraphRepository {
	normalized := strings.TrimRight(baseURL, "/")
	if normalized == "" {
		normalized = "http://127.0.0.1:8086"
	}
	return &RustGraphRepository{baseURL: normalized, client: &http.Client{Timeout: 10 * time.Second}}
}

func (r *RustGraphRepository) MinimumSpanningTree(ctx context.Context, req *models.MinimumSpanningTreeRequest) (*models.MinimumSpanningTreeResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.MinimumSpanningTreeResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/graph/mst", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustGraphRepository) ApproximateSteinerTree(ctx context.Context, req *models.ApproximateSteinerTreeRequest) (*models.ApproximateSteinerTreeResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.ApproximateSteinerTreeResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/graph/steiner", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

