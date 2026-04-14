package service

import (
	"context"
	"fmt"

	"solar3d/compute-service/internal/models"
	"solar3d/compute-service/internal/repository"
)

// OptimizationService contains business logic for optimization operations
type OptimizationService struct {
	repo repository.OptimizationRepository
}

// NewOptimizationService creates a new optimization service
func NewOptimizationService(repo repository.OptimizationRepository) *OptimizationService {
	return &OptimizationService{repo: repo}
}

func (s *OptimizationService) ParetoFrontier(ctx context.Context, req *models.ParetoFrontierRequest) (*models.ParetoFrontierResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("pareto request is nil")
	}
	resp, err := s.repo.ParetoFrontier(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("pareto frontier failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("pareto response is nil")
	}
	return resp, nil
}

func (s *OptimizationService) MonteCarloSampling(ctx context.Context, req *models.MonteCarloRequest) (*models.MonteCarloResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("monte carlo request is nil")
	}
	resp, err := s.repo.MonteCarloSampling(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("monte carlo failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("monte carlo response is nil")
	}
	return resp, nil
}

func (s *OptimizationService) GeneticAlgorithm(ctx context.Context, req *models.GARequest) (*models.GAResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("ga request is nil")
	}
	resp, err := s.repo.GeneticAlgorithm(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("ga failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("ga response is nil")
	}
	return resp, nil
}

func (s *OptimizationService) SimulatedAnnealing(ctx context.Context, req *models.SARequest) (*models.SAResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("sa request is nil")
	}
	resp, err := s.repo.SimulatedAnnealing(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("sa failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("sa response is nil")
	}
	return resp, nil
}

func (s *OptimizationService) ParticleSwarmOptimization(ctx context.Context, req *models.PSORequest) (*models.PSOResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("pso request is nil")
	}
	resp, err := s.repo.ParticleSwarmOptimization(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("pso failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("pso response is nil")
	}
	return resp, nil
}

