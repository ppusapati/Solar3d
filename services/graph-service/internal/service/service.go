package service

import (
	"context"
	"fmt"

	"solar3d/graph-service/internal/client"
)

// GraphCompute defines the interface for graph-compute operations
type GraphCompute interface {
	MinimumSpanningTree(ctx context.Context, graph *client.Graph) ([]client.Edge, float64, error)
	ApproximateSteinerTree(ctx context.Context, graph *client.Graph, terminals []int) ([]client.Edge, float64, error)
	Health(ctx context.Context) error
}

// Service provides graph optimization operations
type Service struct {
	rustClient GraphCompute
}

// New creates a new graph service
func New(rustClient GraphCompute) *Service {
	return &Service{
		rustClient: rustClient,
	}
}

// Graph and Edge are aliases to client types
type Graph = client.Graph
type Edge = client.Edge

// ComputeMinimumSpanningTree computes the MST of a graph
// Returns the edges forming the MST and the total cost
func (s *Service) ComputeMinimumSpanningTree(ctx context.Context, graph *Graph) ([]Edge, float64, error) {
	if graph == nil {
		return nil, 0, fmt.Errorf("graph is nil")
	}

	if graph.NodeCount < 1 {
		return nil, 0, fmt.Errorf("node count must be at least 1")
	}

	if len(graph.Edges) == 0 {
		return nil, 0, fmt.Errorf("edges cannot be empty for connected graph")
	}

	// Pass graph directly since it's a client type alias
	edges, cost, err := s.rustClient.MinimumSpanningTree(ctx, graph)
	if err != nil {
		return nil, 0, fmt.Errorf("compute MST: %w", err)
	}

	// Edges are already client types, no conversion needed
	return edges, cost, nil
}

// ComputeSteinerTree computes an approximate Steiner tree for terminal nodes
// Returns the edges forming the tree and the total cost
func (s *Service) ComputeSteinerTree(ctx context.Context, graph *Graph, terminals []int) ([]Edge, float64, error) {
	if graph == nil {
		return nil, 0, fmt.Errorf("graph is nil")
	}

	if len(terminals) < 2 {
		return nil, 0, fmt.Errorf("at least 2 terminals required")
	}

	if graph.NodeCount < len(terminals) {
		return nil, 0, fmt.Errorf("terminal count exceeds node count")
	}

	// Validate terminal node indices
	for _, t := range terminals {
		if t < 0 || t >= graph.NodeCount {
			return nil, 0, fmt.Errorf("invalid terminal node: %d", t)
		}
	}

	// Pass graph directly since it's a client type alias
	edges, cost, err := s.rustClient.ApproximateSteinerTree(ctx, graph, terminals)
	if err != nil {
		return nil, 0, fmt.Errorf("compute Steiner tree: %w", err)
	}

	// Edges are already client types, no conversion needed
	return edges, cost, nil
}

// Health checks the health of the service and its dependencies
func (s *Service) Health(ctx context.Context) error {
	return s.rustClient.Health(ctx)
}

