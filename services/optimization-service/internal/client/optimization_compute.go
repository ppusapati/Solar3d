package client

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// OptimizationClient wraps HTTP calls to the Rust optimization-compute bridge
type OptimizationClient struct {
	baseURL string
	client  *http.Client
}

// New creates a new OptimizationClient
func New(baseURL string) *OptimizationClient {
	return &OptimizationClient{
		baseURL: baseURL,
		client: &http.Client{
			Timeout: 60 * time.Second,
		},
	}
}

// PSO Config for particle swarm optimization
type PSOConfig struct {
	SwarmSize      int     `json:"swarm_size"`
	Generations    int     `json:"generations"`
	InertiaWeight  float64 `json:"inertia_weight"`
	CognitiveCoeff float64 `json:"cognitive_coeff"`
	SocialCoeff    float64 `json:"social_coeff"`
	Seed           int64   `json:"seed"`
}

// PSORequest is the request payload for PSO
type PSORequest struct {
	Config        PSOConfig   `json:"config"`
	ObjectiveName string      `json:"objective_name"`
	Bounds        [][]float64 `json:"bounds"` // [dim 1: [min, max], dim 2: [min, max], ...]
}

// OptimizationResult is the response from PSO/GA/SA solvers
type OptimizationResult struct {
	BestX       []float64 `json:"best_x"`
	BestValue   float64   `json:"best_value"`
	Generations int       `json:"generations"`
	Error       string    `json:"error,omitempty"`
	ComputeMs   int64     `json:"compute_ms"`
}

// SolveParticleSwarmOptimization solves optimization using PSO algorithm
func (c *OptimizationClient) SolveParticleSwarmOptimization(ctx context.Context, config *PSOConfig, objectiveName string, bounds [][]float64) (*OptimizationResult, error) {
	payload := PSORequest{
		Config:        *config,
		ObjectiveName: objectiveName,
		Bounds:        bounds,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/solve/pso", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var result OptimizationResult
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("unmarshal response: %w", err)
	}

	if result.Error != "" {
		return nil, fmt.Errorf("compute error: %s", result.Error)
	}

	return &result, nil
}

// GAConfig for genetic algorithm
type GAConfig struct {
	PopulationSize int     `json:"population_size"`
	Generations    int     `json:"generations"`
	MutationRate   float64 `json:"mutation_rate"`
	CrossoverRate  float64 `json:"crossover_rate"`
	Seed           int64   `json:"seed"`
}

// GARequest is the request payload for GA
type GARequest struct {
	Config        GAConfig    `json:"config"`
	ObjectiveName string      `json:"objective_name"`
	Bounds        [][]float64 `json:"bounds"`
}

// SolveGeneticAlgorithm solves optimization using genetic algorithm
func (c *OptimizationClient) SolveGeneticAlgorithm(ctx context.Context, config *GAConfig, objectiveName string, bounds [][]float64) (*OptimizationResult, error) {
	payload := GARequest{
		Config:        *config,
		ObjectiveName: objectiveName,
		Bounds:        bounds,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/solve/ga", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var result OptimizationResult
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("unmarshal response: %w", err)
	}

	if result.Error != "" {
		return nil, fmt.Errorf("compute error: %s", result.Error)
	}

	return &result, nil
}

// SAConfig for simulated annealing
type SAConfig struct {
	InitialTemp   float64 `json:"initial_temp"`
	CoolingRate   float64 `json:"cooling_rate"`
	MaxIterations int     `json:"max_iterations"`
	Seed          int64   `json:"seed"`
}

// SARequest is the request payload for SA
type SARequest struct {
	Config        SAConfig    `json:"config"`
	ObjectiveName string      `json:"objective_name"`
	Bounds        [][]float64 `json:"bounds"`
}

// SolveSimulatedAnnealing solves optimization using simulated annealing
func (c *OptimizationClient) SolveSimulatedAnnealing(ctx context.Context, config *SAConfig, objectiveName string, bounds [][]float64) (*OptimizationResult, error) {
	payload := SARequest{
		Config:        *config,
		ObjectiveName: objectiveName,
		Bounds:        bounds,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/solve/sa", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var result OptimizationResult
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("unmarshal response: %w", err)
	}

	if result.Error != "" {
		return nil, fmt.Errorf("compute error: %s", result.Error)
	}

	return &result, nil
}

// HealthResponse is the response from a health check
type HealthResponse struct {
	Status string `json:"status"`
}

// Health checks if the Rust bridge is responding
func (c *OptimizationClient) Health(ctx context.Context) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, c.baseURL+"/health", nil)
	if err != nil {
		return fmt.Errorf("create request: %w", err)
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("health check failed: %d, body: %s", resp.StatusCode, string(body))
	}

	var healthResp HealthResponse
	if err := json.NewDecoder(resp.Body).Decode(&healthResp); err != nil {
		return fmt.Errorf("decode health response: %w", err)
	}

	if healthResp.Status != "ok" {
		return fmt.Errorf("health status: %s", healthResp.Status)
	}

	return nil
}

