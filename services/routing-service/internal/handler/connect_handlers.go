package handler

import (
	"encoding/json"
	"net/http"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/routing-service/internal/domain"
	"p9e.in/samavaya/solar3d/routing-service/internal/service"
)

type RoutingHandler struct {
	svc    *service.RoutingService
	logger zerolog.Logger
}

func NewRoutingHandler(svc *service.RoutingService, logger zerolog.Logger) *RoutingHandler {
	return &RoutingHandler{
		svc:    svc,
		logger: logger.With().Str("component", "handler").Logger(),
	}
}

func (h *RoutingHandler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/routes", h.CreateRoute)
	mux.HandleFunc("GET /api/v1/routes/{id}", h.GetRoute)
	mux.HandleFunc("GET /api/v1/routes", h.ListRoutes)
	mux.HandleFunc("DELETE /api/v1/routes/{id}", h.DeleteRoute)
	mux.HandleFunc("POST /api/v1/routes/calculate", h.CalculateRoute)
	mux.HandleFunc("POST /api/v1/routes/cable", h.CreateCableRoute)
	mux.HandleFunc("POST /api/v1/routes/road", h.CreateRoadRoute)
	mux.HandleFunc("POST /api/v1/routes/optimize/{projectId}", h.OptimizeRoutes)
}

func (h *RoutingHandler) CreateRoute(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateRouteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	route, err := h.svc.CreateRoute(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to create route")
		writeError(w, http.StatusInternalServerError, "failed to create route")
		return
	}

	h.writeJSON(w, http.StatusCreated, route)
}

func (h *RoutingHandler) GetRoute(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid route ID")
		return
	}

	route, err := h.svc.GetRoute(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "route not found")
		return
	}

	h.writeJSON(w, http.StatusOK, route)
}

func (h *RoutingHandler) ListRoutes(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id parameter")
		return
	}

	routes, err := h.svc.ListRoutes(r.Context(), projectID)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to list routes")
		writeError(w, http.StatusInternalServerError, "failed to list routes")
		return
	}

	h.writeJSON(w, http.StatusOK, routes)
}

func (h *RoutingHandler) DeleteRoute(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid route ID")
		return
	}

	if err := h.svc.DeleteRoute(r.Context(), id); err != nil {
		writeError(w, http.StatusNotFound, "route not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *RoutingHandler) CalculateRoute(w http.ResponseWriter, r *http.Request) {
	var req domain.CalculateRouteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	route, err := h.svc.CalculateRoute(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to calculate route")
		writeError(w, http.StatusInternalServerError, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, route)
}

func (h *RoutingHandler) CreateCableRoute(w http.ResponseWriter, r *http.Request) {
	var req domain.CalculateRouteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	route, err := h.svc.CreateCableRoute(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to create cable route")
		writeError(w, http.StatusInternalServerError, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, route)
}

func (h *RoutingHandler) CreateRoadRoute(w http.ResponseWriter, r *http.Request) {
	var req domain.CalculateRouteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	route, err := h.svc.CreateRoadRoute(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to create road route")
		writeError(w, http.StatusInternalServerError, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, route)
}

func (h *RoutingHandler) OptimizeRoutes(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.PathValue("projectId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project ID")
		return
	}

	routes, err := h.svc.OptimizeRoutes(r.Context(), projectID)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to optimize routes")
		writeError(w, http.StatusInternalServerError, "failed to optimize routes")
		return
	}

	h.writeJSON(w, http.StatusOK, routes)
}

func (h *RoutingHandler) writeJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		h.logger.Error().Err(err).Msg("failed to encode response")
	}
}

func writeError(w http.ResponseWriter, status int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(map[string]string{"error": message})
}

