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

// GraphComputeClient wraps HTTP calls to the Rust graph-compute bridge
type GraphComputeClient struct {
	baseURL string
	client  *http.Client
}

// New creates a new GraphComputeClient
func New(baseURL string) *GraphComputeClient {
	return &GraphComputeClient{
		baseURL: baseURL,
		client: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

// Graph represents a network of nodes with weighted edges
type Graph struct {
	NodeCount int
	Edges     []Edge
}

// Edge represents a connection between two nodes
type Edge struct {
	U      int
	V      int
	Weight float64
}

// MinimumSpanningTreeRequest is the request payload for MST computation
type MinimumSpanningTreeRequest struct {
	NodeCount int    `json:"node_count"`
	Edges     []Edge `json:"edges"`
}

// MinimumSpanningTreeResponse is the response from MST computation
type MinimumSpanningTreeResponse struct {
	Edges []Edge  `json:"edges"`
	Error string  `json:"error,omitempty"`
	Cost  float64 `json:"cost"`
}

// MinimumSpanningTree computes the minimum spanning tree of a graph using Kruskal's algorithm
func (c *GraphComputeClient) MinimumSpanningTree(ctx context.Context, graph *Graph) ([]Edge, float64, error) {
	payload := MinimumSpanningTreeRequest{
		NodeCount: graph.NodeCount,
		Edges:     graph.Edges,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, 0, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/mst", bytes.NewReader(body))
	if err != nil {
		return nil, 0, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, 0, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, 0, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, 0, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var mstResp MinimumSpanningTreeResponse
	if err := json.Unmarshal(respBody, &mstResp); err != nil {
		return nil, 0, fmt.Errorf("unmarshal response: %w", err)
	}

	if mstResp.Error != "" {
		return nil, 0, fmt.Errorf("compute error: %s", mstResp.Error)
	}

	return mstResp.Edges, mstResp.Cost, nil
}

// SteinerTreeRequest is the request payload for Steiner tree computation
type SteinerTreeRequest struct {
	NodeCount int    `json:"node_count"`
	Edges     []Edge `json:"edges"`
	Terminals []int  `json:"terminals"`
}

// SteinerTreeResponse is the response from Steiner tree computation
type SteinerTreeResponse struct {
	Edges []Edge  `json:"edges"`
	Error string  `json:"error,omitempty"`
	Cost  float64 `json:"cost"`
}

// ApproximateSteinerTree computes an approximate Steiner tree for a set of terminal nodes
func (c *GraphComputeClient) ApproximateSteinerTree(ctx context.Context, graph *Graph, terminals []int) ([]Edge, float64, error) {
	payload := SteinerTreeRequest{
		NodeCount: graph.NodeCount,
		Edges:     graph.Edges,
		Terminals: terminals,
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return nil, 0, fmt.Errorf("marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/steiner", bytes.NewReader(body))
	if err != nil {
		return nil, 0, fmt.Errorf("create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, 0, fmt.Errorf("send request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, 0, fmt.Errorf("read response: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, 0, fmt.Errorf("http error: %d, body: %s", resp.StatusCode, string(respBody))
	}

	var steinerResp SteinerTreeResponse
	if err := json.Unmarshal(respBody, &steinerResp); err != nil {
		return nil, 0, fmt.Errorf("unmarshal response: %w", err)
	}

	if steinerResp.Error != "" {
		return nil, 0, fmt.Errorf("compute error: %s", steinerResp.Error)
	}

	return steinerResp.Edges, steinerResp.Cost, nil
}

// HealthResponse is the response from a health check
type HealthResponse struct {
	Status string `json:"status"`
}

// Health checks if the Rust bridge is responding
func (c *GraphComputeClient) Health(ctx context.Context) error {
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

