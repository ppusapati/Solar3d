package service

import (
	"context"
	"fmt"
	"sync"

	"solar3d/geo-analytics-service/internal/client"
)

// GeoCompute defines the interface for geo-compute operations
type GeoCompute interface {
	BufferPoint(ctx context.Context, center client.Point2D, radius float64, segments int) (*client.Polygon, error)
	GenerateContours(ctx context.Context, gridXMin, gridXMax, gridYMin, gridYMax int, values, levels []float64) ([]client.ContourLine, error)
	NearestNeighbor(ctx context.Context, points []client.Point2D, query client.Point2D) (*client.NearestNeighbor, error)
	KNearestNeighbors(ctx context.Context, points []client.Point2D, query client.Point2D, k int) ([]client.NearestNeighbor, error)
	Health(ctx context.Context) error
}

// Service provides geospatial analytics operations with orchestration and caching
type Service struct {
	rustClient GeoCompute

	// Optional: LRU cache for small results (can be added later with lru dependency)
	// bufferCache *lru.Cache[BufferCacheKey, *Polygon]

	mu sync.RWMutex
}

// New creates a new geo-analytics service
func New(rustClient GeoCompute) *Service {
	return &Service{
		rustClient: rustClient,
	}
}

// BufferPointRequest holds parameters for buffering a single point
type BufferPointRequest struct {
	CenterX  float64
	CenterY  float64
	Radius   float64
	Segments int
}

// Polygon represents a buffered region (reexport from client)
type Polygon = client.Polygon

// BufferPoint creates a circular buffer around a point
// This is a simple passthrough to the Rust bridge for now
// Can be extended with caching, validation, multi-step processing
func (s *Service) BufferPoint(ctx context.Context, req *BufferPointRequest) (*Polygon, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}

	if req.Radius <= 0 {
		return nil, fmt.Errorf("radius must be positive")
	}

	if req.Segments < 3 {
		return nil, fmt.Errorf("segments must be at least 3")
	}

	// Convert to client types and call
	return s.rustClient.BufferPoint(ctx, client.Point2D{
		X: req.CenterX,
		Y: req.CenterY,
	}, req.Radius, req.Segments)
}

// ContoursRequest holds parameters for generating contours
type ContoursRequest struct {
	GridXMin float64
	GridXMax float64
	GridYMin float64
	GridYMax float64
	Values   []float64
	Levels   []float64
}

// ContourLine represents a single contour (reexport from client)
type ContourLine = client.ContourLine

// GenerateContours generates contour lines from a scalar field
func (s *Service) GenerateContours(ctx context.Context, req *ContoursRequest) ([]ContourLine, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}

	if req.GridXMin >= req.GridXMax {
		return nil, fmt.Errorf("gridXMin must be less than gridXMax")
	}

	if req.GridYMin >= req.GridYMax {
		return nil, fmt.Errorf("gridYMin must be less than gridYMax")
	}

	if len(req.Levels) == 0 {
		return nil, fmt.Errorf("levels cannot be empty")
	}

	// Convert float64 grid parameters to int for the client API
	return s.rustClient.GenerateContours(ctx,
		int(req.GridXMin), int(req.GridXMax),
		int(req.GridYMin), int(req.GridYMax),
		req.Values, req.Levels)
}

// Point holds X, Y coordinates (reexport from client)
type Point = client.Point2D

// NearestNeighbor represents the nearest point and its distance (reexport from client)
type NearestNeighbor = client.NearestNeighbor

// FindNearestPoint finds the nearest point in a set to a query point
func (s *Service) FindNearestPoint(ctx context.Context, points []Point, query Point) (*NearestNeighbor, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if len(points) == 0 {
		return nil, fmt.Errorf("points cannot be empty")
	}

	// Points and query are already client.Point2D, so pass directly
	return s.rustClient.NearestNeighbor(ctx, points, query)
}

// FindKNearestPoints finds the k nearest points in a set to a query point
func (s *Service) FindKNearestPoints(ctx context.Context, points []Point, query Point, k int) ([]NearestNeighbor, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if len(points) == 0 {
		return nil, fmt.Errorf("points cannot be empty")
	}

	if k <= 0 {
		return nil, fmt.Errorf("k must be positive")
	}

	if k > len(points) {
		return nil, fmt.Errorf("k cannot be greater than number of points")
	}

	// Points and query are already client.Point2D, so pass directly
	return s.rustClient.KNearestNeighbors(ctx, points, query, k)
}

// Health checks the health of the service and its dependencies
func (s *Service) Health(ctx context.Context) error {
	return s.rustClient.Health(ctx)
}

