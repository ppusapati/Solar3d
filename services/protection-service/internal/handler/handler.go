package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/protection-service/internal/domain"
	"solar3d/protection-service/internal/service"
)

type Handler struct {
	svc    *service.Service
	logger zerolog.Logger
}

func New(svc *service.Service, logger zerolog.Logger) *Handler {
	return &Handler{svc: svc, logger: logger.With().Str("component", "handler").Logger()}
}

func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/protection/studies", h.CreateStudy)
	mux.HandleFunc("GET /api/v1/protection/studies/{id}", h.GetStudy)
	mux.HandleFunc("GET /api/v1/protection/studies", h.ListStudies)
	mux.HandleFunc("DELETE /api/v1/protection/studies/{id}", h.DeleteStudy)

	mux.HandleFunc("POST /api/v1/protection/studies/{id}/short-circuit", h.ComputeShortCircuit)
	mux.HandleFunc("POST /api/v1/protection/studies/{id}/earth-fault", h.ComputeEarthFault)
	mux.HandleFunc("POST /api/v1/protection/studies/{id}/select-relay", h.SelectRelay)
	mux.HandleFunc("POST /api/v1/protection/studies/{id}/relay-settings", h.ComputeRelaySettings)
	mux.HandleFunc("POST /api/v1/protection/studies/{id}/coordination", h.ValidateCoordination)
	mux.HandleFunc("GET /api/v1/protection/studies/{id}/report.txt", h.GenerateReport)
}

func (h *Handler) CreateStudy(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateStudyRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	study, err := h.svc.CreateStudy(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusCreated, study)
}

func (h *Handler) GetStudy(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	study, err := h.svc.GetStudy(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "study not found")
		return
	}
	h.writeJSON(w, http.StatusOK, study)
}

func (h *Handler) ListStudies(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}
	studies, err := h.svc.ListStudies(r.Context(), projectID)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, studies)
}

func (h *Handler) DeleteStudy(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	if err := h.svc.DeleteStudy(r.Context(), id); err != nil {
		writeError(w, http.StatusNotFound, "study not found")
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (h *Handler) ComputeShortCircuit(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	var req domain.ComputeShortCircuitRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.StudyID = id
	resp, err := h.svc.ComputeShortCircuit(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) ComputeEarthFault(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	var req domain.ComputeEarthFaultRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.StudyID = id
	resp, err := h.svc.ComputeEarthFault(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) SelectRelay(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	var req domain.SelectRelayRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.StudyID = id
	resp, err := h.svc.SelectRelay(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) ComputeRelaySettings(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	var req domain.ComputeRelaySettingsRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.StudyID = id
	resp, err := h.svc.ComputeRelaySettings(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) ValidateCoordination(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	var req domain.ValidateCoordinationRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.StudyID = id
	resp, err := h.svc.ValidateCoordination(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) GenerateReport(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid study ID")
		return
	}
	report, err := h.svc.GenerateProtectionReport(r.Context(), id)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="protection-study-%s.txt"`, id))
	w.WriteHeader(http.StatusOK)
	_, _ = strings.NewReader(report).WriteTo(w)
}

func (h *Handler) writeJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		h.logger.Error().Err(err).Msg("failed to encode response")
	}
}

func (h *Handler) writeErr(w http.ResponseWriter, err error) {
	h.logger.Error().Err(err).Msg("handler error")
	writeError(w, http.StatusUnprocessableEntity, err.Error())
}

func writeError(w http.ResponseWriter, status int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(map[string]string{"error": message})
}
