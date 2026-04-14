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

// GeoComputeClient wraps calls to the geo-compute HTTP bridge
type GeoComputeClient struct {
	baseURL string
	client  *http.Client
}

// NewGeoComputeClient creates a new client for geo-compute service
func NewGeoComputeClient(baseURL string) *GeoComputeClient {
	return &GeoComputeClient{
		baseURL: baseURL,
		client: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

// Point2D represents a 2D point
type Point2D struct {
	X float64 `json:"x"`
	Y float64 `json:"y"`
}

// Polygon represents a polygon ring
type Polygon struct {
	Ring []Point2D `json:"ring"`
}

// BufferRequest is the request to buffer a point
type BufferRequest struct {
	Point    Point2D `json:"point"`
	Radius   float64 `json:"radius"`
	Segments int     `json:"segments"`
}

// BufferResponse is the response containing buffered polygon
type BufferResponse struct {
	Ring  []Point2D `json:"ring"`
	Error string    `json:"error,omitempty"`
}

// BufferPoint calls the geo-compute bridge to buffer a point
func (c *GeoComputeClient) BufferPoint(ctx context.Context, center Point2D, radius float64, segments int) (*Polygon, error) {
	req := BufferRequest{
		Point:    center,
		Radius:   radius,
		Segments: segments,
	}

	body, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", fmt.Sprintf("%s/geo/buffer", c.baseURL), bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("call geo-compute: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("geo-compute error (%d): %s", resp.StatusCode, string(body))
	}

	var bufResp BufferResponse
	if err := json.NewDecoder(resp.Body).Decode(&bufResp); err != nil {
		return nil, fmt.Errorf("decode response: %w", err)
	}

	if bufResp.Error != "" {
		return nil, fmt.Errorf("geo-compute error: %s", bufResp.Error)
	}

	return &Polygon{Ring: bufResp.Ring}, nil
}

// ContourLine represents a contour line
type ContourLine struct {
	Level  float64   `json:"level"`
	Points []Point2D `json:"points"`
}

// ContoursRequest is the request for contour generation
type ContoursRequest struct {
	GridXMin int       `json:"grid_x_min"`
	GridXMax int       `json:"grid_x_max"`
	GridYMin int       `json:"grid_y_min"`
	GridYMax int       `json:"grid_y_max"`
	Values   []float64 `json:"values"`
	Levels   []float64 `json:"levels"`
}

// ContoursResponse is the response containing contour lines
type ContoursResponse struct {
	Contours []ContourLine `json:"contours"`
	Error    string        `json:"error,omitempty"`
}

// GenerateContours calls the geo-compute bridge to generate contours
func (c *GeoComputeClient) GenerateContours(ctx context.Context, gridXMin, gridXMax, gridYMin, gridYMax int, values []float64, levels []float64) ([]ContourLine, error) {
	req := ContoursRequest{
		GridXMin: gridXMin,
		GridXMax: gridXMax,
		GridYMin: gridYMin,
		GridYMax: gridYMax,
		Values:   values,
		Levels:   levels,
	}

	body, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", fmt.Sprintf("%s/geo/contours", c.baseURL), bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("call geo-compute: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("geo-compute error (%d): %s", resp.StatusCode, string(body))
	}

	var cResp ContoursResponse
	if err := json.NewDecoder(resp.Body).Decode(&cResp); err != nil {
		return nil, fmt.Errorf("decode response: %w", err)
	}

	if cResp.Error != "" {
		return nil, fmt.Errorf("geo-compute error: %s", cResp.Error)
	}

	return cResp.Contours, nil
}

// NearestNeighbor represents a nearest neighbor result
type NearestNeighbor struct {
	Index    int     `json:"index"`
	Point    Point2D `json:"point"`
	Distance float64 `json:"distance"`
}

// ProximityRequest is the request for nearest neighbor search
type ProximityRequest struct {
	Points []Point2D `json:"points"`
	Query  Point2D   `json:"query"`
	K      int       `json:"k"`
}

// ProximityResponse is the response with nearest neighbors
type ProximityResponse struct {
	Neighbors []NearestNeighbor `json:"neighbors"`
	Error     string            `json:"error,omitempty"`
}

// NearestNeighbor calls the geo-compute bridge to find nearest neighbor
func (c *GeoComputeClient) NearestNeighbor(ctx context.Context, points []Point2D, query Point2D) (*NearestNeighbor, error) {
	req := ProximityRequest{
		Points: points,
		Query:  query,
		K:      1,
	}

	body, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", fmt.Sprintf("%s/geo/proximity", c.baseURL), bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("call geo-compute: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("geo-compute error (%d): %s", resp.StatusCode, string(body))
	}

	var pResp ProximityResponse
	if err := json.NewDecoder(resp.Body).Decode(&pResp); err != nil {
		return nil, fmt.Errorf("decode response: %w", err)
	}

	if pResp.Error != "" {
		return nil, fmt.Errorf("geo-compute error: %s", pResp.Error)
	}

	if len(pResp.Neighbors) == 0 {
		return nil, fmt.Errorf("no neighbors found")
	}

	return &pResp.Neighbors[0], nil
}

// KNearestNeighbors calls the geo-compute bridge to find k nearest neighbors
func (c *GeoComputeClient) KNearestNeighbors(ctx context.Context, points []Point2D, query Point2D, k int) ([]NearestNeighbor, error) {
	if k <= 0 {
		return nil, fmt.Errorf("k must be positive")
	}

	req := ProximityRequest{
		Points: points,
		Query:  query,
		K:      k,
	}

	body, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", fmt.Sprintf("%s/geo/proximity", c.baseURL), bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("call geo-compute: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("geo-compute error (%d): %s", resp.StatusCode, string(body))
	}

	var pResp ProximityResponse
	if err := json.NewDecoder(resp.Body).Decode(&pResp); err != nil {
		return nil, fmt.Errorf("decode response: %w", err)
	}

	if pResp.Error != "" {
		return nil, fmt.Errorf("geo-compute error: %s", pResp.Error)
	}

	return pResp.Neighbors, nil
}

// Health checks if the geo-compute bridge is reachable
func (c *GeoComputeClient) Health(ctx context.Context) error {
	httpReq, err := http.NewRequestWithContext(ctx, "GET", fmt.Sprintf("%s/health", c.baseURL), nil)
	if err != nil {
		return fmt.Errorf("create request: %w", err)
	}

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return fmt.Errorf("health check failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("geo-compute health check failed: status %d", resp.StatusCode)
	}

	return nil
}

