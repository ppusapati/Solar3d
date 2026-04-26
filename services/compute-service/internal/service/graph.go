package service

import (
	"context"
	"fmt"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

type GraphService struct {
	repo repository.GraphRepository
}

func NewGraphService(repo repository.GraphRepository) *GraphService {
	return &GraphService{repo: repo}
}

func (s *GraphService) MinimumSpanningTree(ctx context.Context, req *models.MinimumSpanningTreeRequest) (*models.MinimumSpanningTreeResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("mst request is nil")
	}
	resp, err := s.repo.MinimumSpanningTree(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("mst failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("mst response is nil")
	}
	return resp, nil
}

func (s *GraphService) ApproximateSteinerTree(ctx context.Context, req *models.ApproximateSteinerTreeRequest) (*models.ApproximateSteinerTreeResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("steiner request is nil")
	}
	resp, err := s.repo.ApproximateSteinerTree(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("steiner failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("steiner response is nil")
	}
	return resp, nil
}

