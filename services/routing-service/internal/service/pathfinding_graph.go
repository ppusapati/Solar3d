// Package pathfinding — integration with graph-compute for optimal cable routing
package service

import (
	"context"
	"fmt"
	"math"
)

// RoutingGraph represents cable routing network as a graph for Steiner tree optimization
type RoutingGraph struct {
	nodes     map[string]*RoutingNode
	edges     map[string]*RoutingEdge
	terminals []string // Target nodes (e.g., inverters to connect)
}

// RoutingNode represents a location (junction, inverter, combiner box, etc.)
type RoutingNode struct {
	ID        string
	Latitude  float64
	Longitude float64
	Type      string // "inverter", "junction", "combiner", "mccb"
	Cost      float64
}

// RoutingEdge represents a potential cable route with cost
type RoutingEdge struct {
	ID     string
	From   string
	To     string
	Length float64 // meters
	Cost   float64 // €/meter
	Cable  string  // cable type (AWG, mm², etc.)
}

// NewRoutingGraph creates a new routing graph
func NewRoutingGraph() *RoutingGraph {
	return &RoutingGraph{
		nodes:     make(map[string]*RoutingNode),
		edges:     make(map[string]*RoutingEdge),
		terminals: []string{},
	}
}

// AddNode adds a routing node (location)
func (rg *RoutingGraph) AddNode(node *RoutingNode) error {
	if node.ID == "" {
		return fmt.Errorf("node ID required")
	}
	rg.nodes[node.ID] = node
	return nil
}

// AddEdge adds a potential cable route
func (rg *RoutingGraph) AddEdge(edge *RoutingEdge) error {
	if edge.ID == "" {
		return fmt.Errorf("edge ID required")
	}
	if _, ok := rg.nodes[edge.From]; !ok {
		return fmt.Errorf("from node %s not found", edge.From)
	}
	if _, ok := rg.nodes[edge.To]; !ok {
		return fmt.Errorf("to node %s not found", edge.To)
	}
	rg.edges[edge.ID] = edge
	return nil
}

// AddTerminal marks a node as must-connect (e.g., an inverter)
func (rg *RoutingGraph) AddTerminal(nodeID string) error {
	if _, ok := rg.nodes[nodeID]; !ok {
		return fmt.Errorf("terminal node %s not found", nodeID)
	}
	rg.terminals = append(rg.terminals, nodeID)
	return nil
}

// ComputeMinimumSpanningTree finds the minimum-cost tree connecting all terminals
// In production, this would use graph-compute crate's MST solver with Prim/Kruskal.
// This is a simplified greedy implementation.
func (rg *RoutingGraph) ComputeMinimumSpanningTree() ([]string, float64, error) {
	if len(rg.terminals) < 2 {
		return nil, 0, fmt.Errorf("at least 2 terminals required")
	}

	// Sort edges by cost (greedy: add cheapest edges that don't create cycles)
	type edgeWithCost struct {
		edge *RoutingEdge
		cost float64
	}
	var edgeList []edgeWithCost
	for _, edge := range rg.edges {
		cost := edge.Cost * edge.Length
		edgeList = append(edgeList, edgeWithCost{edge, cost})
	}

	// Simple sort by cost
	for i := 0; i < len(edgeList); i++ {
		for j := i + 1; j < len(edgeList); j++ {
			if edgeList[j].cost < edgeList[i].cost {
				edgeList[i], edgeList[j] = edgeList[j], edgeList[i]
			}
		}
	}

	// Union-find for cycle detection
	uf := make(map[string]string)
	var find func(string) string
	find = func(x string) string {
		if parent, ok := uf[x]; ok && parent != x {
			uf[x] = find(parent)
			return uf[x]
		}
		if _, ok := uf[x]; !ok {
			uf[x] = x
		}
		return uf[x]
	}

	selectedEdges := []string{}
	totalCost := 0.0
	edgesAdded := 0

	for _, ec := range edgeList {
		rootA := find(ec.edge.From)
		rootB := find(ec.edge.To)

		if rootA != rootB {
			// No cycle: add this edge
			uf[rootA] = rootB
			selectedEdges = append(selectedEdges, ec.edge.ID)
			totalCost += ec.cost
			edgesAdded++

			// MST has n-1 edges; stop when we have enough
			if edgesAdded >= len(rg.nodes)-1 {
				break
			}
		}
	}

	return selectedEdges, totalCost, nil
}

// ComputeSteinerTree finds the lowest-cost tree connecting terminals (may add Steiner points)
// Simplified: for now, delegates to MST (production uses Steiner tree solver)
func (rg *RoutingGraph) ComputeSteinerTree(ctx context.Context) ([]string, float64, error) {
	// In production, would iterate to find Steiner points (junctions that reduce total cost)
	// For now, use MST as approximation
	return rg.ComputeMinimumSpanningTree()
}

// CalculateRouteDistance sums lengths of selected edges (for route visualization)
func (rg *RoutingGraph) CalculateRouteDistance(edgeIDs []string) float64 {
	total := 0.0
	for _, edgeID := range edgeIDs {
		if edge, ok := rg.edges[edgeID]; ok {
			total += edge.Length
		}
	}
	return total
}

// CalculateRouteCost sums total cost of selected edges
func (rg *RoutingGraph) CalculateRouteCost(edgeIDs []string) float64 {
	total := 0.0
	for _, edgeID := range edgeIDs {
		if edge, ok := rg.edges[edgeID]; ok {
			total += edge.Cost * edge.Length
		}
	}
	return total
}

// DistanceM calculates geographic distance in meters between two points
func DistanceM(lat1, lon1, lat2, lon2 float64) float64 {
	const earthRadiusM = 6371000
	dlat := (lat2 - lat1) * math.Pi / 180
	dlon := (lon2 - lon1) * math.Pi / 180
	a := math.Sin(dlat/2)*math.Sin(dlat/2) +
		math.Cos(lat1*math.Pi/180)*math.Cos(lat2*math.Pi/180)*
			math.Sin(dlon/2)*math.Sin(dlon/2)
	c := 2 * math.Asin(math.Sqrt(a))
	return earthRadiusM * c
}

