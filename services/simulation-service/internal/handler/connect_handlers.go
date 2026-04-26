package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/simulation-service/internal/domain"
	"p9e.in/samavaya/solar3d/simulation-service/internal/service"
)

type SimulationHandler struct {
	svc    *service.SimulationService
	logger zerolog.Logger
}

func NewSimulationHandler(svc *service.SimulationService, logger zerolog.Logger) *SimulationHandler {
	return &SimulationHandler{
		svc:    svc,
		logger: logger.With().Str("component", "handler").Logger(),
	}
}

func (h *SimulationHandler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/simulations", h.Create)
	mux.HandleFunc("GET /api/v1/simulations/{id}", h.GetByID)
	mux.HandleFunc("GET /api/v1/simulations", h.ListByProject)
	mux.HandleFunc("DELETE /api/v1/simulations/{id}", h.Delete)
	mux.HandleFunc("POST /api/v1/simulations/{id}/run", h.Run)
	mux.HandleFunc("GET /api/v1/solar/position", h.GetSunPosition)
	mux.HandleFunc("GET /api/v1/solar/shadow-map", h.GetShadowMap)
}

func (h *SimulationHandler) Create(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateSimulationRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	sim, err := h.svc.Create(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to create simulation")
		h.writeError(w, http.StatusInternalServerError, "failed to create simulation")
		return
	}

	h.writeJSON(w, http.StatusCreated, sim)
}

func (h *SimulationHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid simulation ID")
		return
	}

	sim, err := h.svc.GetByID(r.Context(), id)
	if err != nil {
		h.logger.Error().Err(err).Str("id", id.String()).Msg("failed to get simulation")
		h.writeError(w, http.StatusNotFound, "simulation not found")
		return
	}

	h.writeJSON(w, http.StatusOK, sim)
}

func (h *SimulationHandler) ListByProject(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid project_id parameter")
		return
	}

	sims, err := h.svc.ListByProject(r.Context(), projectID)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to list simulations")
		h.writeError(w, http.StatusInternalServerError, "failed to list simulations")
		return
	}

	h.writeJSON(w, http.StatusOK, sims)
}

func (h *SimulationHandler) Delete(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid simulation ID")
		return
	}

	if err := h.svc.Delete(r.Context(), id); err != nil {
		h.logger.Error().Err(err).Str("id", id.String()).Msg("failed to delete simulation")
		h.writeError(w, http.StatusNotFound, "simulation not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *SimulationHandler) Run(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid simulation ID")
		return
	}

	sim, err := h.svc.RunSimulation(r.Context(), id)
	if err != nil {
		h.logger.Error().Err(err).Str("id", id.String()).Msg("failed to run simulation")
		h.writeError(w, http.StatusInternalServerError, "failed to run simulation")
		return
	}

	h.writeJSON(w, http.StatusOK, sim)
}

func (h *SimulationHandler) GetSunPosition(w http.ResponseWriter, r *http.Request) {
	var req domain.SunPositionRequest
	q := r.URL.Query()

	lat, err := parseFloat(q.Get("lat"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid lat parameter")
		return
	}
	lon, err := parseFloat(q.Get("lon"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid lon parameter")
		return
	}

	req.Lat = lat
	req.Lon = lon

	tsStr := q.Get("timestamp")
	if tsStr != "" {
		ts, err := time.Parse(time.RFC3339, tsStr)
		if err != nil {
			h.writeError(w, http.StatusBadRequest, "invalid timestamp format, use RFC3339")
			return
		}
		req.Timestamp = ts
	} else {
		req.Timestamp = time.Now().UTC()
	}

	pos := h.svc.GetSunPosition(req.Lat, req.Lon, req.Timestamp)
	h.writeJSON(w, http.StatusOK, pos)
}

func (h *SimulationHandler) GetShadowMap(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	lat, err := parseFloat(q.Get("lat"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid lat parameter")
		return
	}
	lon, err := parseFloat(q.Get("lon"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid lon parameter")
		return
	}

	ts := time.Now().UTC()
	if tsStr := q.Get("date"); tsStr != "" {
		parsed, err := time.Parse("2006-01-02", tsStr)
		if err != nil {
			h.writeError(w, http.StatusBadRequest, "invalid date format, use YYYY-MM-DD")
			return
		}
		ts = parsed
	}

	positions, err := h.svc.GetShadowMap(r.Context(), lat, lon, ts)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to compute shadow map")
		h.writeError(w, http.StatusInternalServerError, "failed to compute shadow map")
		return
	}

	h.writeJSON(w, http.StatusOK, positions)
}

func (h *SimulationHandler) writeJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		h.logger.Error().Err(err).Msg("failed to encode response")
	}
}

func (h *SimulationHandler) writeError(w http.ResponseWriter, status int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(map[string]string{"error": message}); err != nil {
		h.logger.Error().Err(err).Str("message", message).Msg("failed to encode error response")
	}
}

func parseFloat(s string) (float64, error) {
	f, err := json.Number(s).Float64()
	if err != nil {
		return 0, fmt.Errorf("invalid float %q: %w", s, err)
	}
	return f, nil
}

