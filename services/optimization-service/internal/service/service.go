package service

import (
	"context"
	"fmt"

	"solar3d/optimization-service/internal/client"
)

// OptimizationCompute defines the interface for optimization-compute operations
type OptimizationCompute interface {
	Health(ctx context.Context) error
	SolveParticleSwarmOptimization(ctx context.Context, config *client.PSOConfig, objectiveName string, bounds [][]float64) (*client.OptimizationResult, error)
	SolveGeneticAlgorithm(ctx context.Context, config *client.GAConfig, objectiveName string, bounds [][]float64) (*client.OptimizationResult, error)
	SolveSimulatedAnnealing(ctx context.Context, config *client.SAConfig, objectiveName string, bounds [][]float64) (*client.OptimizationResult, error)
}

// Service provides optimization operations
type Service struct {
	rustClient OptimizationCompute
}

// New creates a new optimization service
func New(rustClient OptimizationCompute) *Service {
	return &Service{
		rustClient: rustClient,
	}
}

// OptimizationResult and config types are aliases to client types
type OptimizationResult = client.OptimizationResult
type PSOConfig = client.PSOConfig
type GAConfig = client.GAConfig
type SAConfig = client.SAConfig

// OptimizeWithPSO solves an optimization problem using particle swarm optimization
func (s *Service) OptimizeWithPSO(ctx context.Context, config *PSOConfig, objectiveName string, bounds [][]float64) (*OptimizationResult, error) {
	if config == nil {
		return nil, fmt.Errorf("config is nil")
	}

	if config.SwarmSize < 2 {
		return nil, fmt.Errorf("swarm size must be at least 2")
	}

	if config.Generations < 1 {
		return nil, fmt.Errorf("generations must be at least 1")
	}

	if len(bounds) == 0 {
		return nil, fmt.Errorf("bounds cannot be empty")
	}

	// Pass config directly since it's a client type alias
	result, err := s.rustClient.SolveParticleSwarmOptimization(ctx, config, objectiveName, bounds)
	if err != nil {
		return nil, fmt.Errorf("PSO optimization failed: %w", err)
	}

	return result, nil
}

// OptimizeWithGA solves an optimization problem using genetic algorithm
func (s *Service) OptimizeWithGA(ctx context.Context, config *GAConfig, objectiveName string, bounds [][]float64) (*OptimizationResult, error) {
	if config == nil {
		return nil, fmt.Errorf("config is nil")
	}

	if config.PopulationSize < 2 {
		return nil, fmt.Errorf("population size must be at least 2")
	}

	if config.Generations < 1 {
		return nil, fmt.Errorf("generations must be at least 1")
	}

	if len(bounds) == 0 {
		return nil, fmt.Errorf("bounds cannot be empty")
	}

	// Pass config directly since it's a client type alias
	result, err := s.rustClient.SolveGeneticAlgorithm(ctx, config, objectiveName, bounds)
	if err != nil {
		return nil, fmt.Errorf("GA optimization failed: %w", err)
	}

	return result, nil
}

// OptimizeWithSimulatedAnnealing solves an optimization problem using simulated annealing
func (s *Service) OptimizeWithSimulatedAnnealing(ctx context.Context, config *SAConfig, objectiveName string, bounds [][]float64) (*OptimizationResult, error) {
	if config == nil {
		return nil, fmt.Errorf("config is nil")
	}

	if config.InitialTemp <= 0 {
		return nil, fmt.Errorf("initial temperature must be positive")
	}

	if config.CoolingRate <= 0 || config.CoolingRate > 1 {
		return nil, fmt.Errorf("cooling rate must be between 0 and 1")
	}

	if len(bounds) == 0 {
		return nil, fmt.Errorf("bounds cannot be empty")
	}

	// Pass config directly since it's a client type alias
	result, err := s.rustClient.SolveSimulatedAnnealing(ctx, config, objectiveName, bounds)
	if err != nil {
		return nil, fmt.Errorf("SA optimization failed: %w", err)
	}

	return result, nil
}

// Health checks the health of the service and its dependencies
func (s *Service) Health(ctx context.Context) error {
	return s.rustClient.Health(ctx)
}

