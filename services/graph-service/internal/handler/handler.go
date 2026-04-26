package handler

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"p9e.in/samavaya/solar3d/graph-service/internal/service"
	"p9e.in/samavaya/packages/httpmiddleware"
)

// Handler implements HTTP REST handlers for graph optimization operations
type Handler struct {
	svc *service.Service
}

// New creates a new handler with a service
func New(svc *service.Service) *Handler {
	return &Handler{svc: svc}
}

// RegisterHTTPRoutes registers all HTTP REST routes with the mux
func (h *Handler) RegisterHTTPRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /mst", h.handleMinimumSpanningTree)
	mux.HandleFunc("POST /steiner", h.handleSteinerTree)
	log.Println("Graph HTTP routes registered")
}

// handleMinimumSpanningTree handles HTTP POST /mst
func (h *Handler) handleMinimumSpanningTree(w http.ResponseWriter, r *http.Request) {
	var req struct {
		NodeCount int                      `json:"node_count"`
		Edges     []map[string]interface{} `json:"edges"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.ComputeMinimumSpanningTree(r.Context(), req.NodeCount, req.Edges)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "MST computation failed", err.Error())
		return
	}

	middleware.WriteSuccess(w, http.StatusOK, result)
}

// handleSteinerTree handles HTTP POST /steiner
func (h *Handler) handleSteinerTree(w http.ResponseWriter, r *http.Request) {
	var req struct {
		NodeCount int                      `json:"node_count"`
		Terminals []int                    `json:"terminals"`
		Edges     []map[string]interface{} `json:"edges"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.ComputeSteinerTree(r.Context(), req.NodeCount, req.Edges, req.Terminals)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Steiner tree computation failed", err.Error())
		return
	}

	middleware.WriteSuccess(w, http.StatusOK, result)
}

// handleHealth handles HTTP GET /health
func (h *Handler) handleHealth(w http.ResponseWriter, r *http.Request) {
	err := h.Health(r.Context())
	if err != nil {
		middleware.WriteError(w, http.StatusServiceUnavailable, "Health check failed", err.Error())
		return
	}
	middleware.WriteSuccess(w, http.StatusOK, map[string]string{"status": "ok"})
}

// ComputeMinimumSpanningTree handles MST computation
func (h *Handler) ComputeMinimumSpanningTree(ctx context.Context, nodeCount int, edges []map[string]interface{}) (map[string]interface{}, error) {
	if nodeCount < 1 {
		return nil, fmt.Errorf("validation failed: nodeCount must be at least 1")
	}
	if len(edges) == 0 {
		return nil, fmt.Errorf("validation failed: edges cannot be empty")
	}

	srvEdges := make([]service.Edge, len(edges))
	for i, edgeMap := range edges {
		u, ok := edgeMap["u"].(float64)
		if !ok {
			return nil, fmt.Errorf("validation failed: edge %d missing u", i)
		}
		v, ok := edgeMap["v"].(float64)
		if !ok {
			return nil, fmt.Errorf("validation failed: edge %d missing v", i)
		}
		weight, ok := edgeMap["weight"].(float64)
		if !ok {
			return nil, fmt.Errorf("validation failed: edge %d missing weight", i)
		}

		srvEdges[i] = service.Edge{U: int(u), V: int(v), Weight: weight}
	}

	graph := &service.Graph{NodeCount: nodeCount, Edges: srvEdges}
	mstEdges, cost, err := h.svc.ComputeMinimumSpanningTree(ctx, graph)
	if err != nil {
		log.Printf("ComputeMinimumSpanningTree error: %v", err)
		return nil, fmt.Errorf("MST computation failed: %w", err)
	}

	resultEdges := make([]map[string]interface{}, len(mstEdges))
	for i, edge := range mstEdges {
		resultEdges[i] = map[string]interface{}{"u": edge.U, "v": edge.V, "weight": edge.Weight}
	}

	return map[string]interface{}{"edges": resultEdges, "cost": cost}, nil
}

// ComputeSteinerTree handles Steiner tree computation
func (h *Handler) ComputeSteinerTree(ctx context.Context, nodeCount int, edges []map[string]interface{}, terminals []int) (map[string]interface{}, error) {
	if nodeCount < 1 {
		return nil, fmt.Errorf("validation failed: nodeCount must be at least 1")
	}
	if len(edges) == 0 {
		return nil, fmt.Errorf("validation failed: edges cannot be empty")
	}
	if len(terminals) < 2 {
		return nil, fmt.Errorf("validation failed: at least 2 terminals required")
	}

	srvEdges := make([]service.Edge, len(edges))
	for i, edgeMap := range edges {
		u, ok := edgeMap["u"].(float64)
		if !ok {
			return nil, fmt.Errorf("validation failed: edge %d missing u", i)
		}
		v, ok := edgeMap["v"].(float64)
		if !ok {
			return nil, fmt.Errorf("validation failed: edge %d missing v", i)
		}
		weight, ok := edgeMap["weight"].(float64)
		if !ok {
			return nil, fmt.Errorf("validation failed: edge %d missing weight", i)
		}

		srvEdges[i] = service.Edge{U: int(u), V: int(v), Weight: weight}
	}

	graph := &service.Graph{NodeCount: nodeCount, Edges: srvEdges}
	steinerEdges, cost, err := h.svc.ComputeSteinerTree(ctx, graph, terminals)
	if err != nil {
		log.Printf("ComputeSteinerTree error: %v", err)
		return nil, fmt.Errorf("Steiner tree computation failed: %w", err)
	}

	resultEdges := make([]map[string]interface{}, len(steinerEdges))
	for i, edge := range steinerEdges {
		resultEdges[i] = map[string]interface{}{"u": edge.U, "v": edge.V, "weight": edge.Weight}
	}

	return map[string]interface{}{"edges": resultEdges, "cost": cost, "terminals": terminals}, nil
}

// Health checks service health
func (h *Handler) Health(ctx context.Context) error {
	return h.svc.Health(ctx)
}

