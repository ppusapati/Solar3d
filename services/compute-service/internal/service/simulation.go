package service

import (
	"context"
	"fmt"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

type SimulationService struct {
	repo repository.SimulationRepository
}

func NewSimulationService(repo repository.SimulationRepository) *SimulationService {
	return &SimulationService{repo: repo}
}

func (s *SimulationService) GetSunPosition(ctx context.Context, req *models.GetSunPositionRequest) (*models.GetSunPositionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("get sun position request is nil")
	}
	resp, err := s.repo.GetSunPosition(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("get sun position failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("get sun position response is nil")
	}
	return resp, nil
}

func (s *SimulationService) GetShadowMap(ctx context.Context, req *models.GetShadowMapRequest) (*models.GetShadowMapResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("get shadow map request is nil")
	}
	resp, err := s.repo.GetShadowMap(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("get shadow map failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("get shadow map response is nil")
	}
	return resp, nil
}

