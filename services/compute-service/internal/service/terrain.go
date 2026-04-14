package service

import (
	"context"
	"fmt"

	"solar3d/compute-service/internal/models"
	"solar3d/compute-service/internal/repository"
)

type TerrainService struct {
	repo repository.TerrainRepository
}

func NewTerrainService(repo repository.TerrainRepository) *TerrainService {
	return &TerrainService{repo: repo}
}

func (s *TerrainService) GetElevation(ctx context.Context, req *models.GetElevationRequest) (*models.GetElevationResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("get elevation request is nil")
	}
	resp, err := s.repo.GetElevation(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("get elevation failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("get elevation response is nil")
	}
	return resp, nil
}

func (s *TerrainService) GetElevationGrid(ctx context.Context, req *models.GetElevationGridRequest) (*models.GetElevationGridResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("get elevation grid request is nil")
	}
	resp, err := s.repo.GetElevationGrid(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("get elevation grid failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("get elevation grid response is nil")
	}
	return resp, nil
}

func (s *TerrainService) ComputeSlope(ctx context.Context, req *models.ComputeSlopeRequest) (*models.ComputeSlopeResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("compute slope request is nil")
	}
	resp, err := s.repo.ComputeSlope(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("compute slope failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("compute slope response is nil")
	}
	return resp, nil
}

func (s *TerrainService) ComputeAspect(ctx context.Context, req *models.ComputeAspectRequest) (*models.ComputeAspectResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("compute aspect request is nil")
	}
	resp, err := s.repo.ComputeAspect(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("compute aspect failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("compute aspect response is nil")
	}
	return resp, nil
}

