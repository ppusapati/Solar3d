package handler

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"github.com/solar3d/solar3d/services/terrain-service/internal/domain"
	"github.com/solar3d/solar3d/services/terrain-service/internal/service"
)

// Handler provides HTTP handlers for the terrain service API.
type Handler struct {
	svc    *service.Service
	logger zerolog.Logger
}

// New creates a new Handler.
func New(svc *service.Service, logger zerolog.Logger) *Handler {
	return &Handler{
		svc:    svc,
		logger: logger.With().Str("component", "handler").Logger(),
	}
}

// RegisterRoutes wires all terrain endpoints to the given ServeMux.
func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/terrain/layers", h.UploadTerrain)
	mux.HandleFunc("GET /api/v1/terrain/layers/{id}", h.GetLayer)
	mux.HandleFunc("GET /api/v1/terrain/layers", h.ListLayers)
	mux.HandleFunc("DELETE /api/v1/terrain/layers/{id}", h.DeleteLayer)
	mux.HandleFunc("GET /api/v1/terrain/layers/{id}/elevation", h.GetElevation)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/elevation-grid", h.GetElevationGrid)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/compute/slope", h.ComputeSlope)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/compute/aspect", h.ComputeAspect)
}

// UploadTerrain handles POST /api/v1/terrain/layers.
func (h *Handler) UploadTerrain(w http.ResponseWriter, r *http.Request) {
	var req service.UploadTerrainRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	layer, err := h.svc.UploadTerrain(r.Context(), req)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, layer)
}

// GetLayer handles GET /api/v1/terrain/layers/{id}.
func (h *Handler) GetLayer(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	layer, err := h.svc.GetLayer(r.Context(), id)
	if err != nil {
		h.writeError(w, http.StatusNotFound, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, layer)
}

// ListLayers handles GET /api/v1/terrain/layers?project_id=...
func (h *Handler) ListLayers(w http.ResponseWriter, r *http.Request) {
	projectIDStr := r.URL.Query().Get("project_id")
	if projectIDStr == "" {
		h.writeError(w, http.StatusBadRequest, "project_id query parameter is required")
		return
	}

	projectID, err := uuid.Parse(projectIDStr)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}

	layers, err := h.svc.ListLayers(r.Context(), projectID)
	if err != nil {
		h.writeError(w, http.StatusInternalServerError, err.Error())
		return
	}

	if layers == nil {
		layers = []domain.TerrainLayer{}
	}

	h.writeJSON(w, http.StatusOK, layers)
}

// DeleteLayer handles DELETE /api/v1/terrain/layers/{id}.
func (h *Handler) DeleteLayer(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	if err := h.svc.DeleteLayer(r.Context(), id); err != nil {
		h.writeError(w, http.StatusNotFound, err.Error())
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// elevationRequest is used to parse query params for point elevation queries.
type elevationResponse struct {
	X         float64 `json:"x"`
	Y         float64 `json:"y"`
	Elevation float64 `json:"elevation"`
}

// GetElevation handles GET /api/v1/terrain/layers/{id}/elevation?x=...&y=...
func (h *Handler) GetElevation(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	x, err := strconv.ParseFloat(r.URL.Query().Get("x"), 64)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid or missing x parameter")
		return
	}

	y, err := strconv.ParseFloat(r.URL.Query().Get("y"), 64)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid or missing y parameter")
		return
	}

	point, err := h.svc.GetElevation(r.Context(), id, x, y)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, elevationResponse{
		X:         point.X,
		Y:         point.Y,
		Elevation: point.Elevation,
	})
}

// elevationGridRequest carries the parameters for a grid elevation query.
type elevationGridRequest struct {
	Bounds domain.BoundingBox `json:"bounds"`
	Width  int                `json:"width"`
	Height int                `json:"height"`
}

// GetElevationGrid handles POST /api/v1/terrain/layers/{id}/elevation-grid.
func (h *Handler) GetElevationGrid(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	var req elevationGridRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	grid, err := h.svc.GetElevationGrid(r.Context(), id, req.Bounds, req.Width, req.Height)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, grid)
}

// ComputeSlope handles POST /api/v1/terrain/layers/{id}/compute/slope.
func (h *Handler) ComputeSlope(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	layer, err := h.svc.ComputeSlope(r.Context(), id)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, layer)
}

// ComputeAspect handles POST /api/v1/terrain/layers/{id}/compute/aspect.
func (h *Handler) ComputeAspect(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	layer, err := h.svc.ComputeAspect(r.Context(), id)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, layer)
}

// apiError is the standard error response envelope.
type apiError struct {
	Error string `json:"error"`
}

func (h *Handler) writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(v); err != nil {
		h.logger.Error().Err(err).Msg("failed to encode response")
	}
}

func (h *Handler) writeError(w http.ResponseWriter, status int, msg string) {
	h.logger.Warn().Int("status", status).Str("error", msg).Msg("request error")
	h.writeJSON(w, status, apiError{Error: msg})
}
