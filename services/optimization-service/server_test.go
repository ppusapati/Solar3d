package main

import (
	"context"
	"testing"

	"solar3d/optimization-service/internal/client"
	"solar3d/optimization-service/internal/handler"
	"solar3d/optimization-service/internal/service"
)

// MockOptimizationClient is a mock implementation
type MockOptimizationClient struct {
	psoResult *client.OptimizationResult
	gaResult  *client.OptimizationResult
	saResult  *client.OptimizationResult
	healthErr error
}

func (m *MockOptimizationClient) Health(ctx context.Context) error {
	return m.healthErr
}

func (m *MockOptimizationClient) SolveParticleSwarmOptimization(ctx context.Context, config *client.PSOConfig, objectiveName string, bounds [][]float64) (*client.OptimizationResult, error) {
	if m.psoResult != nil {
		return m.psoResult, nil
	}
	return &client.OptimizationResult{
		BestX:     []float64{1.5, 2.5},
		BestValue: -3.5,
		ComputeMs: 1000,
	}, nil
}

func (m *MockOptimizationClient) SolveGeneticAlgorithm(ctx context.Context, config *client.GAConfig, objectiveName string, bounds [][]float64) (*client.OptimizationResult, error) {
	if m.gaResult != nil {
		return m.gaResult, nil
	}
	return &client.OptimizationResult{
		BestX:     []float64{1.2, 2.1},
		BestValue: -2.3,
		ComputeMs: 800,
	}, nil
}

func (m *MockOptimizationClient) SolveSimulatedAnnealing(ctx context.Context, config *client.SAConfig, objectiveName string, bounds [][]float64) (*client.OptimizationResult, error) {
	if m.saResult != nil {
		return m.saResult, nil
	}
	return &client.OptimizationResult{
		BestX:     []float64{1.1, 2.2},
		BestValue: -2.5,
		ComputeMs: 600,
	}, nil
}

// TestPSO tests PSO solver
func TestPSO(t *testing.T) {
	mockClient := &MockOptimizationClient{}
	svc := service.New(mockClient)

	ctx := context.Background()
	h := handler.New(svc)

	// Test PSO with valid config
	req := &handler.OptimizeWithPSORequest{
		SwarmSize:      30,
		Generations:    50,
		InertiaWeight:  0.7,
		CognitiveCoeff: 1.5,
		SocialCoeff:    1.5,
		Seed:           42,
		ObjectiveName:  "sphere",
		Bounds:         [][]float64{{-10, 10}, {-10, 10}},
	}

	_, err := h.OptimizeWithPSO(ctx, req)

	if err == nil {
		t.Log("PSO test passed")
	} else {
		t.Fatalf("unexpected PSO error: %v", err)
	}
}

// TestGA tests GA solver
func TestGA(t *testing.T) {
	mockClient := &MockOptimizationClient{}
	svc := service.New(mockClient)

	ctx := context.Background()
	h := handler.New(svc)

	req := &handler.OptimizeWithGARequest{
		PopulationSize: 50,
		Generations:    100,
		MutationRate:   0.1,
		CrossoverRate:  0.8,
		Seed:           42,
		ObjectiveName:  "ackley",
		Bounds:         [][]float64{{-32.768, 32.768}, {-32.768, 32.768}},
	}

	_, err := h.OptimizeWithGA(ctx, req)
	if err == nil {
		t.Log("GA test passed")
	} else {
		t.Fatalf("unexpected GA error: %v", err)
	}
}

// TestSimulatedAnnealing tests SA solver
func TestSimulatedAnnealing(t *testing.T) {
	mockClient := &MockOptimizationClient{}
	svc := service.New(mockClient)

	ctx := context.Background()
	h := handler.New(svc)

	req := &handler.OptimizeWithSARequest{
		InitialTemp:   100.0,
		CoolingRate:   0.95,
		MaxIterations: 1000,
		Seed:          42,
		ObjectiveName: "rosenbrock",
		Bounds:        [][]float64{{-5, 10}, {-5, 10}},
	}

	_, err := h.OptimizeWithSimulatedAnnealing(ctx, req)
	if err == nil {
		t.Log("SA test passed")
	} else {
		t.Fatalf("unexpected SA error: %v", err)
	}
}

// TestPSOValidation tests PSO validation
func TestPSOValidation(t *testing.T) {
	ctx := context.Background()
	h := handler.New(nil)

	// Test with invalid swarm size
	req := &handler.OptimizeWithPSORequest{
		SwarmSize:   1, // Invalid
		Generations: 50,
		Bounds:      [][]float64{{-10, 10}},
	}

	_, err := h.OptimizeWithPSO(ctx, req)

	if err == nil {
		t.Fatal("expected error for invalid swarm size")
	}
}

// TestGAValidation tests GA validation
func TestGAValidation(t *testing.T) {
	ctx := context.Background()
	h := handler.New(nil)

	// Test with invalid population size
	req := &handler.OptimizeWithGARequest{
		PopulationSize: 1, // Invalid
		Generations:    100,
		Bounds:         [][]float64{{-32.768, 32.768}},
	}

	_, err := h.OptimizeWithGA(ctx, req)

	if err == nil {
		t.Fatal("expected error for invalid population size")
	}
}

// TestSAValidation tests SA validation
func TestSAValidation(t *testing.T) {
	ctx := context.Background()
	h := handler.New(nil)

	// Test with invalid cooling rate
	req := &handler.OptimizeWithSARequest{
		InitialTemp:   100.0,
		CoolingRate:   1.5, // Invalid (must be 0-1)
		MaxIterations: 1000,
		Bounds:        [][]float64{{-5, 10}},
	}

	_, err := h.OptimizeWithSimulatedAnnealing(ctx, req)

	if err == nil {
		t.Fatal("expected error for invalid cooling rate")
	}
}

// BenchmarkPSO benchmarks PSO solver
func BenchmarkPSO(b *testing.B) {
	ctx := context.Background()
	h := handler.New(nil)

	req := &handler.OptimizeWithPSORequest{
		SwarmSize:     30,
		Generations:   50,
		ObjectiveName: "sphere",
		Bounds:        [][]float64{{-10, 10}, {-10, 10}},
	}

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		h.OptimizeWithPSO(ctx, req)
	}
}

