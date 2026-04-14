package main

import (
	"context"
	"testing"

	"solar3d/graph-service/internal/client"
	"solar3d/graph-service/internal/handler"
	"solar3d/graph-service/internal/service"
)

// MockGraphComputeClient is a mock implementation
type MockGraphComputeClient struct {
	mstResult   []client.Edge
	mstCost     float64
	steinerCost float64
	healthErr   error
}

func (m *MockGraphComputeClient) MinimumSpanningTree(ctx context.Context, graph *client.Graph) ([]client.Edge, float64, error) {
	return m.mstResult, m.mstCost, nil
}

func (m *MockGraphComputeClient) ApproximateSteinerTree(ctx context.Context, graph *client.Graph, terminals []int) ([]client.Edge, float64, error) {
	return m.mstResult, m.steinerCost, nil
}

func (m *MockGraphComputeClient) Health(ctx context.Context) error {
	return m.healthErr
}

// TestMinimumSpanningTree tests MST computation
func TestMinimumSpanningTree(t *testing.T) {
	// Create test nodes and edges
	nodeCount := 4
	edges := []map[string]interface{}{
		{"u": 0.0, "v": 1.0, "weight": 1.0},
		{"u": 1.0, "v": 2.0, "weight": 2.0},
		{"u": 2.0, "v": 3.0, "weight": 3.0},
		{"u": 0.0, "v": 3.0, "weight": 10.0},
	}

	mockClient := &MockGraphComputeClient{
		mstCost: 6.0,
	}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	result, err := h.ComputeMinimumSpanningTree(ctx, nodeCount, edges)

	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result == nil {
		t.Fatal("result is nil")
	}

	if cost, ok := result["cost"].(float64); !ok || cost <= 0 {
		t.Fatal("result missing or invalid cost")
	}
}

// TestSteinerTree tests Steiner tree computation
func TestSteinerTree(t *testing.T) {
	nodeCount := 4
	edges := []map[string]interface{}{
		{"u": 0.0, "v": 1.0, "weight": 1.0},
		{"u": 1.0, "v": 2.0, "weight": 2.0},
		{"u": 2.0, "v": 3.0, "weight": 3.0},
	}
	terminals := []int{0, 2, 3}

	mockClient := &MockGraphComputeClient{
		steinerCost: 5.0,
	}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	result, err := h.ComputeSteinerTree(ctx, nodeCount, edges, terminals)

	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result == nil {
		t.Fatal("result is nil")
	}
}

// TestInvalidNodeCount tests validation
func TestInvalidNodeCount(t *testing.T) {
	mockClient := &MockGraphComputeClient{}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	_, err := h.ComputeMinimumSpanningTree(ctx, 0, nil)

	if err == nil {
		t.Fatal("expected error for node count 0")
	}
}

// TestEmptyEdges tests validation
func TestEmptyEdges(t *testing.T) {
	mockClient := &MockGraphComputeClient{}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	_, err := h.ComputeMinimumSpanningTree(ctx, 4, []map[string]interface{}{})

	if err == nil {
		t.Fatal("expected error for empty edges")
	}
}

// BenchmarkMST benchmarks MST computation
func BenchmarkMST(b *testing.B) {
	mockClient := &MockGraphComputeClient{
		mstCost: 10.0,
	}
	svc := service.New(mockClient)
	h := handler.New(svc)

	edges := []map[string]interface{}{
		{"u": 0.0, "v": 1.0, "weight": 1.0},
		{"u": 1.0, "v": 2.0, "weight": 2.0},
	}

	ctx := context.Background()
	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		h.ComputeMinimumSpanningTree(ctx, 3, edges)
	}
}

