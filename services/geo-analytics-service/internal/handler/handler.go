package handler

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/service"
	"p9e.in/samavaya/packages/httpmiddleware"
)

// Handler implements HTTP REST handlers for geo-analytics operations
type Handler struct {
	svc *service.Service
}

// New creates a new handler with a service
func New(svc *service.Service) *Handler {
	return &Handler{
		svc: svc,
	}
}

// RegisterHTTPRoutes registers all HTTP REST routes with the mux
func (h *Handler) RegisterHTTPRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /buffer", h.handleBufferPoint)
	mux.HandleFunc("POST /contours", h.handleGenerateContours)
	mux.HandleFunc("POST /nearest", h.handleFindNearestPoint)
	mux.HandleFunc("POST /knearest", h.handleFindKNearestPoints)
	mux.HandleFunc("GET /health", h.handleHealth)
	log.Println("Geo-Analytics HTTP routes registered")
}

// handleBufferPoint handles HTTP POST /buffer
func (h *Handler) handleBufferPoint(w http.ResponseWriter, r *http.Request) {
	var req struct {
		CenterX  float64 `json:"center_x"`
		CenterY  float64 `json:"center_y"`
		Radius   float64 `json:"radius"`
		Segments int     `json:"segments"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.BufferPoint(r.Context(), req.CenterX, req.CenterY, req.Radius, req.Segments)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Buffer point failed", err.Error())
		return
	}

	middleware.WriteSuccess(w, http.StatusOK, result)
}

// handleGenerateContours handles HTTP POST /contours
func (h *Handler) handleGenerateContours(w http.ResponseWriter, r *http.Request) {
	var req struct {
		GridXMin float64   `json:"grid_x_min"`
		GridXMax float64   `json:"grid_x_max"`
		GridYMin float64   `json:"grid_y_min"`
		GridYMax float64   `json:"grid_y_max"`
		Values   []float64 `json:"values"`
		Levels   []float64 `json:"levels"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.GenerateContours(r.Context(), req.GridXMin, req.GridXMax, req.GridYMin, req.GridYMax, req.Values, req.Levels)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Generate contours failed", err.Error())
		return
	}

	middleware.WriteSuccess(w, http.StatusOK, result)
}

// handleFindNearestPoint handles HTTP POST /nearest
func (h *Handler) handleFindNearestPoint(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Points []map[string]float64 `json:"points"`
		QueryX float64              `json:"query_x"`
		QueryY float64              `json:"query_y"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.FindNearestPoint(r.Context(), req.Points, req.QueryX, req.QueryY)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Nearest point search failed", err.Error())
		return
	}

	middleware.WriteSuccess(w, http.StatusOK, result)
}

// handleFindKNearestPoints handles HTTP POST /knearest
func (h *Handler) handleFindKNearestPoints(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Points []map[string]float64 `json:"points"`
		QueryX float64              `json:"query_x"`
		QueryY float64              `json:"query_y"`
		K      int                  `json:"k"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	result, err := h.FindKNearestPoints(r.Context(), req.Points, req.QueryX, req.QueryY, req.K)
	if err != nil {
		middleware.WriteError(w, http.StatusBadRequest, "K-nearest search failed", err.Error())
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

// BufferPoint handles buffering a single point
// This wraps the service.BufferPoint call with request validation and response formatting
func (h *Handler) BufferPoint(ctx context.Context, centerX, centerY, radius float64, segments int) (map[string]interface{}, error) {
	if radius <= 0 {
		return nil, fmt.Errorf("validation failed: radius must be positive")
	}

	if segments < 3 {
		return nil, fmt.Errorf("validation failed: segments must be at least 3")
	}

	result, err := h.svc.BufferPoint(ctx, &service.BufferPointRequest{
		CenterX:  centerX,
		CenterY:  centerY,
		Radius:   radius,
		Segments: segments,
	})
	if err != nil {
		log.Printf("BufferPoint error: %v", err)
		return nil, fmt.Errorf("buffer point failed: %w", err)
	}

	// Convert result to JSON-serializable format
	ring := make([]map[string]float64, len(result.Ring))
	for i, point := range result.Ring {
		ring[i] = map[string]float64{
			"x": point.X,
			"y": point.Y,
		}
	}

	return map[string]interface{}{
		"ring": ring,
	}, nil
}

// GenerateContours handles generating contour lines
func (h *Handler) GenerateContours(ctx context.Context, gridXMin, gridXMax, gridYMin, gridYMax float64, values []float64, levels []float64) ([]map[string]interface{}, error) {
	if gridXMax <= gridXMin {
		return nil, fmt.Errorf("validation failed: grid_x_max must be greater than grid_x_min")
	}

	if gridYMax <= gridYMin {
		return nil, fmt.Errorf("validation failed: grid_y_max must be greater than grid_y_min")
	}

	if len(values) == 0 {
		return nil, fmt.Errorf("validation failed: values cannot be empty")
	}

	if len(levels) == 0 {
		return nil, fmt.Errorf("validation failed: levels cannot be empty")
	}

	results, err := h.svc.GenerateContours(ctx, &service.ContoursRequest{
		GridXMin: gridXMin,
		GridXMax: gridXMax,
		GridYMin: gridYMin,
		GridYMax: gridYMax,
		Values:   values,
		Levels:   levels,
	})

	if err != nil {
		log.Printf("GenerateContours error: %v", err)
		return nil, fmt.Errorf("contour generation failed: %w", err)
	}

	// Convert results to JSON-serializable format
	output := make([]map[string]interface{}, len(results))
	for i, contour := range results {
		ring := make([]map[string]float64, len(contour.Points))
		for j, point := range contour.Points {
			ring[j] = map[string]float64{
				"x": point.X,
				"y": point.Y,
			}
		}

		output[i] = map[string]interface{}{
			"level": contour.Level,
			"ring":  ring,
		}
	}

	return output, nil
}

// FindNearestPoint handles finding the nearest point
func (h *Handler) FindNearestPoint(ctx context.Context, points []map[string]float64, queryX, queryY float64) (map[string]interface{}, error) {
	if len(points) == 0 {
		return nil, fmt.Errorf("validation failed: points cannot be empty")
	}

	// Convert input points to service format
	srvPoints := make([]service.Point, len(points))
	for i, p := range points {
		x := p["x"]
		y := p["y"]
		srvPoints[i] = service.Point{X: x, Y: y}
	}

	result, err := h.svc.FindNearestPoint(ctx, srvPoints, service.Point{X: queryX, Y: queryY})
	if err != nil {
		log.Printf("FindNearestPoint error: %v", err)
		return nil, fmt.Errorf("nearest point search failed: %w", err)
	}

	return map[string]interface{}{
		"index":    result.Index,
		"distance": result.Distance,
		"point": map[string]float64{
			"x": result.Point.X,
			"y": result.Point.Y,
		},
	}, nil
}

// FindKNearestPoints handles finding k nearest points
func (h *Handler) FindKNearestPoints(ctx context.Context, points []map[string]float64, queryX, queryY float64, k int) ([]map[string]interface{}, error) {
	if len(points) == 0 {
		return nil, fmt.Errorf("validation failed: points cannot be empty")
	}

	if k <= 0 {
		return nil, fmt.Errorf("validation failed: k must be positive")
	}

	if k > len(points) {
		return nil, fmt.Errorf("validation failed: k cannot be greater than number of points")
	}

	// Convert input points to service format
	srvPoints := make([]service.Point, len(points))
	for i, p := range points {
		x := p["x"]
		y := p["y"]
		srvPoints[i] = service.Point{X: x, Y: y}
	}

	results, err := h.svc.FindKNearestPoints(ctx, srvPoints, service.Point{X: queryX, Y: queryY}, k)
	if err != nil {
		log.Printf("FindKNearestPoints error: %v", err)
		return nil, fmt.Errorf("k-nearest search failed: %w", err)
	}

	// Convert results to JSON-serializable format
	output := make([]map[string]interface{}, len(results))
	for i, result := range results {
		output[i] = map[string]interface{}{
			"index":    result.Index,
			"distance": result.Distance,
			"point": map[string]float64{
				"x": result.Point.X,
				"y": result.Point.Y,
			},
		}
	}

	return output, nil
}

// Health checks service health
func (h *Handler) Health(ctx context.Context) error {
	return h.svc.Health(ctx)
}

