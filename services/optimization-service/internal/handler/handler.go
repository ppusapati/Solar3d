package handler

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

	pkgErrors "p9e.in/samavaya/packages/errors"

	"p9e.in/samavaya/solar3d/optimization-service/internal/service"
	"p9e.in/samavaya/packages/httpmiddleware"
)

// Handler implements HTTP REST handlers for optimization operations
type Handler struct {
	svc *service.Service
}

// New creates a new handler with a service
func New(svc *service.Service) *Handler {
	return &Handler{svc: svc}
}

// RegisterHTTPRoutes registers all HTTP REST routes with the mux
func (h *Handler) RegisterHTTPRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /pso", h.handlePSO)
	mux.HandleFunc("POST /ga", h.handleGA)
	mux.HandleFunc("POST /sa", h.handleSA)
	log.Println("Optimization HTTP routes registered")
}

func (h *Handler) handlePSO(w http.ResponseWriter, r *http.Request) {
	var req OptimizeWithPSORequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.OptimizeWithPSO(r.Context(), &req)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "PSO solver failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, result)
}

func (h *Handler) handleGA(w http.ResponseWriter, r *http.Request) {
	var req OptimizeWithGARequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.OptimizeWithGA(r.Context(), &req)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "GA solver failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, result)
}

func (h *Handler) handleSA(w http.ResponseWriter, r *http.Request) {
	var req OptimizeWithSARequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.OptimizeWithSimulatedAnnealing(r.Context(), &req)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "SA solver failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, result)
}

func (h *Handler) handleHealth(w http.ResponseWriter, r *http.Request) {
	err := h.Health(r.Context())
	if err != nil {
		middleware.WriteError(w, http.StatusServiceUnavailable, "Health check failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, map[string]string{"status": "ok"})
}

// OptimizeWithPSORequest holds PSO optimization parameters
type OptimizeWithPSORequest struct {
	SwarmSize      int         `json:"swarm_size"`
	Generations    int         `json:"generations"`
	InertiaWeight  float64     `json:"inertia_weight"`
	CognitiveCoeff float64     `json:"cognitive_coeff"`
	SocialCoeff    float64     `json:"social_coeff"`
	Seed           int64       `json:"seed"`
	ObjectiveName  string      `json:"objective_name"`
	Bounds         [][]float64 `json:"bounds"`
}

func (h *Handler) OptimizeWithPSO(ctx context.Context, req *OptimizeWithPSORequest) (map[string]interface{}, error) {
	if req == nil {
		return nil, pkgErrors.InvalidArgumentf("validation failed: request is nil")
	}
	if req.SwarmSize < 2 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: swarmSize must be at least 2")
	}
	if req.Generations < 1 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: generations must be at least 1")
	}
	if len(req.Bounds) == 0 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: bounds cannot be empty")
	}

	config := &service.PSOConfig{
		SwarmSize:      req.SwarmSize,
		Generations:    req.Generations,
		InertiaWeight:  req.InertiaWeight,
		CognitiveCoeff: req.CognitiveCoeff,
		SocialCoeff:    req.SocialCoeff,
		Seed:           req.Seed,
	}

	result, err := h.svc.OptimizeWithPSO(ctx, config, req.ObjectiveName, req.Bounds)
	if err != nil {
		log.Printf("OptimizeWithPSO error: %v", err)
		return nil, pkgErrors.Internal("PSO optimization failed", err.Error())
	}

	return map[string]interface{}{"best_x": result.BestX, "best_value": result.BestValue, "generations": result.Generations, "compute_ms": result.ComputeMs}, nil
}

// OptimizeWithGARequest holds GA optimization parameters
type OptimizeWithGARequest struct {
	PopulationSize int         `json:"population_size"`
	Generations    int         `json:"generations"`
	MutationRate   float64     `json:"mutation_rate"`
	CrossoverRate  float64     `json:"crossover_rate"`
	Seed           int64       `json:"seed"`
	ObjectiveName  string      `json:"objective_name"`
	Bounds         [][]float64 `json:"bounds"`
}

func (h *Handler) OptimizeWithGA(ctx context.Context, req *OptimizeWithGARequest) (map[string]interface{}, error) {
	if req == nil {
		return nil, pkgErrors.InvalidArgumentf("validation failed: request is nil")
	}
	if req.PopulationSize < 2 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: populationSize must be at least 2")
	}
	if req.Generations < 1 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: generations must be at least 1")
	}
	if len(req.Bounds) == 0 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: bounds cannot be empty")
	}

	config := &service.GAConfig{
		PopulationSize: req.PopulationSize,
		Generations:    req.Generations,
		MutationRate:   req.MutationRate,
		CrossoverRate:  req.CrossoverRate,
		Seed:           req.Seed,
	}

	result, err := h.svc.OptimizeWithGA(ctx, config, req.ObjectiveName, req.Bounds)
	if err != nil {
		log.Printf("OptimizeWithGA error: %v", err)
		return nil, pkgErrors.Internal("GA optimization failed", err.Error())
	}

	return map[string]interface{}{"best_x": result.BestX, "best_value": result.BestValue, "generations": result.Generations, "compute_ms": result.ComputeMs}, nil
}

// OptimizeWithSARequest holds SA optimization parameters
type OptimizeWithSARequest struct {
	InitialTemp   float64     `json:"initial_temp"`
	CoolingRate   float64     `json:"cooling_rate"`
	MaxIterations int         `json:"max_iterations"`
	Seed          int64       `json:"seed"`
	ObjectiveName string      `json:"objective_name"`
	Bounds        [][]float64 `json:"bounds"`
}

func (h *Handler) OptimizeWithSimulatedAnnealing(ctx context.Context, req *OptimizeWithSARequest) (map[string]interface{}, error) {
	if req == nil {
		return nil, pkgErrors.InvalidArgumentf("validation failed: request is nil")
	}
	if req.InitialTemp <= 0 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: initialTemp must be positive")
	}
	if req.CoolingRate <= 0 || req.CoolingRate > 1 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: coolingRate must be between 0 and 1")
	}
	if len(req.Bounds) == 0 {
		return nil, pkgErrors.InvalidArgumentf("validation failed: bounds cannot be empty")
	}

	config := &service.SAConfig{
		InitialTemp:   req.InitialTemp,
		CoolingRate:   req.CoolingRate,
		MaxIterations: req.MaxIterations,
		Seed:          req.Seed,
	}

	result, err := h.svc.OptimizeWithSimulatedAnnealing(ctx, config, req.ObjectiveName, req.Bounds)
	if err != nil {
		log.Printf("OptimizeWithSimulatedAnnealing error: %v", err)
		return nil, pkgErrors.Internal("SA optimization failed", err.Error())
	}

	return map[string]interface{}{"best_x": result.BestX, "best_value": result.BestValue, "generations": result.Generations, "compute_ms": result.ComputeMs}, nil
}

// Health checks service health
func (h *Handler) Health(ctx context.Context) error {
	return h.svc.Health(ctx)
}
