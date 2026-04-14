// Package graph_analysis — integration with graph-compute for electrical networks
package service

import (
	"fmt"
)

// ElectricalNetworkAnalysis uses graph-compute to analyze electrical networks
type ElectricalNetworkAnalysis struct {
	nodes   map[string]*ElectricalNode
	edges   map[string]*ElectricalEdge
	cableDB map[string]*CableSpec
}

// ElectricalNode represents an electrical component (inverter, junction, etc.)
type ElectricalNode struct {
	ID         string
	Type       string  // "inverter", "junction", "mccb", "transformer"
	Voltage    float64 // volts
	MaxCurrent float64 // amps
	Latitude   float64
	Longitude  float64
}

// ElectricalEdge represents a cable connection between nodes
type ElectricalEdge struct {
	ID         string
	FromNode   string
	ToNode     string
	CableType  string
	Length     float64 // meters
	Resistance float64 // ohms
	Ampacity   float64 // maximum current capacity (amps)
	Cost       float64 // estimated cost
}

// CableSpec defines electrical properties of a cable type
type CableSpec struct {
	Name       string
	Diameter   float64 // mm
	Area       float64 // mm²
	Resistance float64 // ohms/km
	MaxCurrent float64 // amps (at 30°C ambient)
	CostPerM   float64 // price per meter
}

// NewElectricalNetworkAnalysis creates a new network analyzer
func NewElectricalNetworkAnalysis() *ElectricalNetworkAnalysis {
	return &ElectricalNetworkAnalysis{
		nodes:   make(map[string]*ElectricalNode),
		edges:   make(map[string]*ElectricalEdge),
		cableDB: initCableDatabase(),
	}
}

// AddNode adds an electrical component to the network
func (ena *ElectricalNetworkAnalysis) AddNode(node *ElectricalNode) error {
	if node.ID == "" {
		return fmt.Errorf("node ID required")
	}
	if node.MaxCurrent <= 0 {
		return fmt.Errorf("max current must be positive")
	}
	ena.nodes[node.ID] = node
	return nil
}

// AddEdge adds a cable connection to the network
func (ena *ElectricalNetworkAnalysis) AddEdge(edge *ElectricalEdge) error {
	if edge.ID == "" {
		return fmt.Errorf("edge ID required")
	}
	if _, ok := ena.nodes[edge.FromNode]; !ok {
		return fmt.Errorf("from_node %s not found", edge.FromNode)
	}
	if _, ok := ena.nodes[edge.ToNode]; !ok {
		return fmt.Errorf("to_node %s not found", edge.ToNode)
	}

	// Compute resistance from cable type
	if spec, ok := ena.cableDB[edge.CableType]; ok {
		edge.Resistance = (spec.Resistance / 1000.0) * edge.Length
		edge.Ampacity = spec.MaxCurrent
		edge.Cost = edge.Length * spec.CostPerM
	}

	ena.edges[edge.ID] = edge
	return nil
}

// ValidateNetwork checks electrical constraints
// Returns violations for overcurrent, voltage drop, etc.
func (ena *ElectricalNetworkAnalysis) ValidateNetwork() []string {
	var violations []string

	// Check each cable for overcurrent
	for edgeID, edge := range ena.edges {
		fromNode := ena.nodes[edge.FromNode]
		toNode := ena.nodes[edge.ToNode]

		// Simple check: max current on edge should not exceed cable ampacity
		// In real system, this would include actual load analysis
		if fromNode.MaxCurrent > edge.Ampacity {
			violations = append(violations, fmt.Sprintf(
				"edge %s: max current %f A exceeds cable ampacity %f A",
				edgeID, fromNode.MaxCurrent, edge.Ampacity,
			))
		}

		// Check voltage drop (simplified: 3% rule for feeders)
		// Vdrop = I * R; max allowed = 0.03 * Voltage
		maxVdrop := 0.03 * toNode.Voltage
		actualVdrop := fromNode.MaxCurrent * edge.Resistance
		if actualVdrop > maxVdrop {
			violations = append(violations, fmt.Sprintf(
				"edge %s: voltage drop %f V exceeds limit %f V",
				edgeID, actualVdrop, maxVdrop,
			))
		}
	}

	return violations
}

// CalculateNetworkCost sums all cable costs
func (ena *ElectricalNetworkAnalysis) CalculateNetworkCost() float64 {
	total := 0.0
	for _, edge := range ena.edges {
		total += edge.Cost
	}
	return total
}

// FindShortestPath uses Dijkstra-like algorithm to find lowest-cost route
// (In production, this would use graph-compute crate's MST/Steiner tree solvers)
func (ena *ElectricalNetworkAnalysis) FindShortestPath(from, to string) ([]string, error) {
	if _, ok := ena.nodes[from]; !ok {
		return nil, fmt.Errorf("start node %s not found", from)
	}
	if _, ok := ena.nodes[to]; !ok {
		return nil, fmt.Errorf("end node %s not found", to)
	}

	// Simplified Dijkstra (production code uses graph-compute)
	distances := make(map[string]float64)
	previous := make(map[string]string)
	unvisited := make(map[string]bool)

	for nodeID := range ena.nodes {
		distances[nodeID] = 1e9
		unvisited[nodeID] = true
	}
	distances[from] = 0

	for len(unvisited) > 0 {
		// Find unvisited node with min distance
		current := ""
		minDist := 1e9
		for nodeID := range unvisited {
			if distances[nodeID] < minDist {
				minDist = distances[nodeID]
				current = nodeID
			}
		}
		if current == "" || minDist == 1e9 {
			break
		}
		delete(unvisited, current)

		if current == to {
			break
		}

		// Check all adjacent edges
		for _, edge := range ena.edges {
			var neighbor string
			if edge.FromNode == current {
				neighbor = edge.ToNode
			} else if edge.ToNode == current {
				neighbor = edge.FromNode
			} else {
				continue
			}

			if !unvisited[neighbor] {
				continue
			}

			newDist := distances[current] + edge.Cost
			if newDist < distances[neighbor] {
				distances[neighbor] = newDist
				previous[neighbor] = current
			}
		}
	}

	// Reconstruct path
	path := []string{}
	current := to
	for current != "" {
		path = append([]string{current}, path...)
		if prev, ok := previous[current]; ok {
			current = prev
		} else if current == from {
			break
		} else {
			return nil, fmt.Errorf("no path found from %s to %s", from, to)
		}
	}

	return path, nil
}

// initCableDatabase returns standard cable specifications
func initCableDatabase() map[string]*CableSpec {
	return map[string]*CableSpec{
		"awg_10": {
			Name:       "AWG 10",
			Diameter:   2.588,
			Area:       5.26,
			Resistance: 3.277, // ohms/km
			MaxCurrent: 30,
			CostPerM:   1.50,
		},
		"awg_6": {
			Name:       "AWG 6",
			Diameter:   4.115,
			Area:       13.3,
			Resistance: 1.296, // ohms/km
			MaxCurrent: 55,
			CostPerM:   2.50,
		},
		"awg_2": {
			Name:       "AWG 2",
			Diameter:   6.543,
			Area:       33.6,
			Resistance: 0.517, // ohms/km
			MaxCurrent: 95,
			CostPerM:   4.00,
		},
	}
}

