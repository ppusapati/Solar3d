package main

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/client"
	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/handler"
	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/service"
)

// MockGeoComputeClient is a mock implementation for testing
type MockGeoComputeClient struct {
	bufferPoints       []*client.Polygon
	contourLinesResult []client.ContourLine
	nearestResult      *client.NearestNeighbor
	kNearestResult     []client.NearestNeighbor
	healthErr          error
}

func (m *MockGeoComputeClient) BufferPoint(ctx context.Context, center client.Point2D, radius float64, segments int) (*client.Polygon, error) {
	if m.bufferPoints == nil {
		m.bufferPoints = make([]*client.Polygon, 0)
	}
	if len(m.bufferPoints) > 0 {
		return m.bufferPoints[0], nil
	}
	// Return valid mock polygon
	ring := make([]client.Point2D, segments)
	for i := 0; i < segments; i++ {
		ring[i] = client.Point2D{X: float64(i), Y: float64(i)}
	}
	return &client.Polygon{Ring: ring}, nil
}

func (m *MockGeoComputeClient) GenerateContours(ctx context.Context, gridXMin, gridXMax, gridYMin, gridYMax int, values, levels []float64) ([]client.ContourLine, error) {
	if m.contourLinesResult != nil {
		return m.contourLinesResult, nil
	}
	result := make([]client.ContourLine, len(levels))
	for i, level := range levels {
		result[i] = client.ContourLine{Level: level, Points: make([]client.Point2D, 0)}
	}
	return result, nil
}

func (m *MockGeoComputeClient) NearestNeighbor(ctx context.Context, points []client.Point2D, query client.Point2D) (*client.NearestNeighbor, error) {
	if m.nearestResult != nil {
		return m.nearestResult, nil
	}
	return &client.NearestNeighbor{Index: 0, Distance: 0.0}, nil
}

func (m *MockGeoComputeClient) KNearestNeighbors(ctx context.Context, points []client.Point2D, query client.Point2D, k int) ([]client.NearestNeighbor, error) {
	if m.kNearestResult != nil {
		return m.kNearestResult, nil
	}
	return make([]client.NearestNeighbor, k), nil
}

func (m *MockGeoComputeClient) Health(ctx context.Context) error {
	return m.healthErr
}

// TestBufferPoint tests the buffer point operation
func TestBufferPoint(t *testing.T) {
	mockClient := &MockGeoComputeClient{}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	result, err := h.BufferPoint(ctx, 0, 0, 50, 32)

	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result == nil {
		t.Fatal("result is nil")
	}

	if ring, ok := result["ring"]; !ok {
		t.Fatal("result missing ring field")
	} else if ringSlice, ok := ring.([]map[string]float64); !ok || len(ringSlice) != 32 {
		t.Fatal("ring field has incorrect format or length")
	}
}

func TestBufferPointInvalidRadius(t *testing.T) {
	mockClient := &MockGeoComputeClient{}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	_, err := h.BufferPoint(ctx, 0, 0, -1, 32)

	if err == nil {
		t.Fatal("expected error for negative radius")
	}
}

func TestBufferPointInvalidSegments(t *testing.T) {
	mockClient := &MockGeoComputeClient{}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	_, err := h.BufferPoint(ctx, 0, 0, 50, 2)

	if err == nil {
		t.Fatal("expected error for segments < 3")
	}
}

// TestGenerateContours tests contour generation
func TestGenerateContours(t *testing.T) {
	mockClient := &MockGeoComputeClient{
		contourLinesResult: []client.ContourLine{
			{Level: 100, Points: []client.Point2D{{X: 100, Y: 100}}},
			{Level: 200, Points: []client.Point2D{{X: 200, Y: 200}}},
		},
	}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	result, err := h.GenerateContours(ctx, 0, 100, 0, 100, []float64{1, 2, 3}, []float64{100, 200})

	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if len(result) != 2 {
		t.Fatalf("expected 2 contours, got %d", len(result))
	}
}

// TestFindNearestPoint tests nearest point search
func TestFindNearestPoint(t *testing.T) {
	mockClient := &MockGeoComputeClient{
		nearestResult: &client.NearestNeighbor{
			Index:    0,
			Distance: 0.0,
			Point:    client.Point2D{X: 0, Y: 0},
		},
	}
	svc := service.New(mockClient)
	h := handler.New(svc)

	points := []map[string]float64{
		{"x": 0, "y": 0},
		{"x": 1, "y": 1},
	}

	ctx := context.Background()
	result, err := h.FindNearestPoint(ctx, points, 0, 0)

	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result == nil {
		t.Fatal("result is nil")
	}

	if idx, ok := result["index"].(int); !ok || idx != 0 {
		if idx2, ok2 := result["index"].(float64); ok2 {
			// Index might be float64 if marshaled
			if idx2 != 0 {
				t.Fatal("result index should be 0")
			}
		} else {
			t.Fatalf("result missing or invalid index: %v (type: %T)", result["index"], result["index"])
		}
	}
}

// TestServiceHealth tests health check
func TestServiceHealth(t *testing.T) {
	mockClient := &MockGeoComputeClient{}
	svc := service.New(mockClient)

	ctx := context.Background()
	err := svc.Health(ctx)

	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

// BenchmarkBufferPoint benchmarks buffer point operation
func BenchmarkBufferPoint(b *testing.B) {
	mockClient := &MockGeoComputeClient{}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		h.BufferPoint(ctx, 0, 0, 50, 32)
	}
}

// TestHTTPServer tests the HTTP server
func TestHTTPServer(t *testing.T) {
	mockClient := &MockGeoComputeClient{}
	svc := service.New(mockClient)

	// Test health endpoint
	req := httptest.NewRequest("GET", "/health", nil)
	w := httptest.NewRecorder()

	// Create a simple HTTP handler for testing
	http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
		defer cancel()

		if err := svc.Health(ctx); err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusServiceUnavailable)
			io.WriteString(w, `{"status":"unhealthy"}`)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		io.WriteString(w, `{"status":"healthy"}`)
	}).ServeHTTP(w, req)

	resp := w.Result()
	if resp.StatusCode != http.StatusOK {
		t.Fatalf("expected status 200, got %d", resp.StatusCode)
	}

	body, _ := io.ReadAll(resp.Body)
	var result map[string]interface{}
	if err := json.Unmarshal(body, &result); err != nil {
		t.Fatalf("failed to unmarshal response: %v", err)
	}

	if status, ok := result["status"].(string); !ok || status != "healthy" {
		t.Fatal("expected healthy status")
	}
}

// TestConcurrentRequests tests handling multiple concurrent requests
func TestConcurrentRequests(t *testing.T) {
	mockClient := &MockGeoComputeClient{}
	svc := service.New(mockClient)
	h := handler.New(svc)

	ctx := context.Background()
	errChan := make(chan error, 10)

	for i := 0; i < 10; i++ {
		go func() {
			_, err := h.BufferPoint(ctx, float64(i), float64(i), 50, 32)
			errChan <- err
		}()
	}

	for i := 0; i < 10; i++ {
		if err := <-errChan; err != nil {
			t.Fatalf("concurrent request failed: %v", err)
		}
	}
}

