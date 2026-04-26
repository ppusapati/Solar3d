package handler

import (
	"encoding/json"
	"net/http"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/electrical-service/internal/domain"
	"p9e.in/samavaya/solar3d/electrical-service/internal/service"
)

type ElectricalHandler struct {
	svc    *service.ElectricalService
	logger zerolog.Logger
}

func NewElectricalHandler(svc *service.ElectricalService, logger zerolog.Logger) *ElectricalHandler {
	return &ElectricalHandler{
		svc:    svc,
		logger: logger.With().Str("component", "handler").Logger(),
	}
}

func (h *ElectricalHandler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/networks", h.CreateNetwork)
	mux.HandleFunc("GET /api/v1/networks/{id}", h.GetNetwork)
	mux.HandleFunc("GET /api/v1/networks", h.ListNetworks)
	mux.HandleFunc("DELETE /api/v1/networks/{id}", h.DeleteNetwork)
	mux.HandleFunc("POST /api/v1/strings", h.CreateString)
	mux.HandleFunc("POST /api/v1/networks/{id}/auto-generate", h.AutoGenerateStrings)
	mux.HandleFunc("GET /api/v1/networks/{id}/dc-capacity", h.CalculateDCCapacity)
	mux.HandleFunc("GET /api/v1/networks/{id}/ac-capacity", h.CalculateACCapacity)
	mux.HandleFunc("GET /api/v1/networks/{id}/losses", h.CalculateLosses)
	mux.HandleFunc("POST /api/v1/networks/{id}/validate-sizing", h.ValidateSizing)
	mux.HandleFunc("POST /api/v1/networks/{id}/validate", h.ValidateNetwork)
	mux.HandleFunc("POST /api/v1/networks/{id}/bom", h.GenerateNetworkBOM)
}

func (h *ElectricalHandler) CreateNetwork(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateNetworkRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	net, err := h.svc.CreateNetwork(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to create network")
		writeError(w, http.StatusInternalServerError, "failed to create network")
		return
	}

	h.writeJSON(w, http.StatusCreated, net)
}

func (h *ElectricalHandler) GetNetwork(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	net, err := h.svc.GetNetwork(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "network not found")
		return
	}

	h.writeJSON(w, http.StatusOK, net)
}

func (h *ElectricalHandler) ListNetworks(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id parameter")
		return
	}

	networks, err := h.svc.ListNetworks(r.Context(), projectID)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to list networks")
		writeError(w, http.StatusInternalServerError, "failed to list networks")
		return
	}

	h.writeJSON(w, http.StatusOK, networks)
}

func (h *ElectricalHandler) DeleteNetwork(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	if err := h.svc.DeleteNetwork(r.Context(), id); err != nil {
		writeError(w, http.StatusNotFound, "network not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *ElectricalHandler) CreateString(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateStringRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	ps, err := h.svc.CreateString(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to create string")
		writeError(w, http.StatusInternalServerError, "failed to create string")
		return
	}

	h.writeJSON(w, http.StatusCreated, ps)
}

func (h *ElectricalHandler) AutoGenerateStrings(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	var req domain.AutoGenerateRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.NetworkID = id

	net, err := h.svc.AutoGenerateStrings(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to auto-generate strings")
		writeError(w, http.StatusInternalServerError, "failed to auto-generate strings")
		return
	}

	h.writeJSON(w, http.StatusOK, net)
}

func (h *ElectricalHandler) CalculateDCCapacity(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	dcKW, err := h.svc.CalculateDCCapacity(r.Context(), id)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to calculate DC capacity")
		writeError(w, http.StatusInternalServerError, "failed to calculate DC capacity")
		return
	}

	h.writeJSON(w, http.StatusOK, map[string]float64{"dc_capacity_kw": dcKW})
}

func (h *ElectricalHandler) CalculateACCapacity(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	acKW, err := h.svc.CalculateACCapacity(r.Context(), id)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to calculate AC capacity")
		writeError(w, http.StatusInternalServerError, "failed to calculate AC capacity")
		return
	}

	h.writeJSON(w, http.StatusOK, map[string]float64{"ac_capacity_kw": acKW})
}

func (h *ElectricalHandler) CalculateLosses(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	losses, err := h.svc.CalculateLosses(r.Context(), id)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to calculate losses")
		writeError(w, http.StatusInternalServerError, "failed to calculate losses")
		return
	}

	h.writeJSON(w, http.StatusOK, losses)
}

func (h *ElectricalHandler) ValidateSizing(w http.ResponseWriter, r *http.Request) {
	networkID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	var req domain.ValidateSizingRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.NetworkID = networkID

	result, err := h.svc.ValidateSizing(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to validate sizing")
		writeError(w, http.StatusInternalServerError, "failed to validate sizing")
		return
	}

	h.writeJSON(w, http.StatusOK, result)
}

func (h *ElectricalHandler) writeJSON(w http.ResponseWriter, status int, data any) {
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

func (h *ElectricalHandler) ValidateNetwork(w http.ResponseWriter, r *http.Request) {
	networkID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	var req domain.ValidateNetworkRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.NetworkID = networkID

	result, err := h.svc.ValidateNetwork(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to validate network")
		writeError(w, http.StatusInternalServerError, "failed to validate network")
		return
	}

	h.writeJSON(w, http.StatusOK, result)
}

func (h *ElectricalHandler) GenerateNetworkBOM(w http.ResponseWriter, r *http.Request) {
	networkID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid network ID")
		return
	}

	var req domain.GenerateNetworkBOMRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.NetworkID = networkID

	bom, err := h.svc.GenerateNetworkBOM(r.Context(), req)
	if err != nil {
		h.logger.Error().Err(err).Msg("failed to generate network BOM")
		writeError(w, http.StatusInternalServerError, "failed to generate network BOM")
		return
	}

	h.writeJSON(w, http.StatusOK, bom)
}
