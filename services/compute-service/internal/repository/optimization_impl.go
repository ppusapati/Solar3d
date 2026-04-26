package repository

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
)

type RustOptimizationRepository struct {
	baseURL string
	client  *http.Client
}

func NewRustOptimizationRepository(baseURL string) *RustOptimizationRepository {
	normalized := strings.TrimRight(baseURL, "/")
	if normalized == "" {
		normalized = "http://127.0.0.1:8082"
	}
	return &RustOptimizationRepository{
		baseURL: normalized,
		client:  &http.Client{Timeout: 10 * time.Second},
	}
}

func (r *RustOptimizationRepository) ParetoFrontier(ctx context.Context, req *models.ParetoFrontierRequest) (*models.ParetoFrontierResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	objectives := make([]optObjectivePayload, 0, len(req.Objectives))
	for _, o := range req.Objectives {
		objectives = append(objectives, optObjectivePayload{Name: o.Name, Kind: o.Kind, Weight: o.Weight})
	}
	payload := optParetoRequestPayload{
		Objectives: objectives,
		NewSolution: optSolutionPayload{
			ID:               req.NewSolution.ID,
			Variables:        req.NewSolution.Variables,
			Objectives:       req.NewSolution.Objectives,
			Rank:             req.NewSolution.Rank,
			CrowdingDistance: req.NewSolution.CrowdingDistance,
		},
	}
	var out models.ParetoFrontierResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/opt/pareto/frontier", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustOptimizationRepository) MonteCarloSampling(ctx context.Context, req *models.MonteCarloRequest) (*models.MonteCarloResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	dists := make([]optDistributionPayload, 0, len(req.Distributions))
	for _, d := range req.Distributions {
		dists = append(dists, optDistributionPayload{Mean: d.Mean, StdDev: d.StdDev})
	}
	payload := optMonteCarloRequestPayload{
		Distributions: dists,
		NumSamples:    req.NumSamples,
		Seed:          req.Seed,
	}
	var out models.MonteCarloResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/opt/monte-carlo/sample", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

type optObjectivePayload struct {
	Name   string  `json:"name"`
	Kind   string  `json:"kind"`
	Weight float64 `json:"weight"`
}

type optSolutionPayload struct {
	ID               int32     `json:"id"`
	Variables        []float64 `json:"variables"`
	Objectives       []float64 `json:"objectives"`
	Rank             float64   `json:"rank"`
	CrowdingDistance float64   `json:"crowding_distance"`
}

type optParetoRequestPayload struct {
	Objectives  []optObjectivePayload `json:"objectives"`
	NewSolution optSolutionPayload    `json:"new_solution"`
}

func (r *RustOptimizationRepository) GeneticAlgorithm(ctx context.Context, req *models.GARequest) (*models.GAResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := optGARequestPayload{
		PopulationSize:    req.PopulationSize,
		Generations:       req.Generations,
		CrossoverRate:     req.CrossoverRate,
		MutationRate:      req.MutationRate,
		EliteCount:        req.EliteCount,
		Seed:              req.Seed,
		InitialPopulation: req.InitialPopulation,
	}
	var out models.GAResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/opt/ga/run", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustOptimizationRepository) SimulatedAnnealing(ctx context.Context, req *models.SARequest) (*models.SAResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := optSARequestPayload{
		InitialTemperature: req.InitialTemperature,
		CoolingRate:        req.CoolingRate,
		Iterations:         req.Iterations,
		PerturbationScale:  req.PerturbationScale,
		Seed:               req.Seed,
		InitialSolution:    req.InitialSolution,
	}
	var out models.SAResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/opt/sa/run", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustOptimizationRepository) ParticleSwarmOptimization(ctx context.Context, req *models.PSORequest) (*models.PSOResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	payload := optPSORequestPayload{
		NumParticles: req.NumParticles,
		Iterations:   req.Iterations,
		C1:           req.C1,
		C2:           req.C2,
		W:            req.W,
		BoundaryMin:  req.BoundaryMin,
		BoundaryMax:  req.BoundaryMax,
		Seed:         req.Seed,
	}
	var out models.PSOResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/opt/pso/run", payload, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

type optDistributionPayload struct {
	Mean   float64 `json:"mean"`
	StdDev float64 `json:"std_dev"`
}

type optMonteCarloRequestPayload struct {
	Distributions []optDistributionPayload `json:"distributions"`
	NumSamples    int32                    `json:"num_samples"`
	Seed          int64                    `json:"seed"`
}

type optGARequestPayload struct {
	PopulationSize    int32     `json:"population_size"`
	Generations       int32     `json:"generations"`
	CrossoverRate     float64   `json:"crossover_rate"`
	MutationRate      float64   `json:"mutation_rate"`
	EliteCount        int32     `json:"elite_count"`
	Seed              int64     `json:"seed"`
	InitialPopulation []float64 `json:"initial_population"`
}

type optSARequestPayload struct {
	InitialTemperature float64   `json:"initial_temperature"`
	CoolingRate        float64   `json:"cooling_rate"`
	Iterations         int32     `json:"iterations"`
	PerturbationScale  float64   `json:"perturbation_scale"`
	Seed               int64     `json:"seed"`
	InitialSolution    []float64 `json:"initial_solution"`
}

type optPSORequestPayload struct {
	NumParticles int32   `json:"num_particles"`
	Iterations   int32   `json:"iterations"`
	C1           float64 `json:"c1"`
	C2           float64 `json:"c2"`
	W            float64 `json:"w"`
	BoundaryMin  float64 `json:"boundary_min"`
	BoundaryMax  float64 `json:"boundary_max"`
	Seed         int64   `json:"seed"`
}

