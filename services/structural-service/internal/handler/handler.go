package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/structural-service/internal/domain"
	"solar3d/structural-service/internal/service"
)

type Handler struct {
	svc    *service.Service
	logger zerolog.Logger
}

func New(svc *service.Service, logger zerolog.Logger) *Handler {
	return &Handler{svc: svc, logger: logger.With().Str("component", "handler").Logger()}
}

func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/structural/designs", h.CreateDesign)
	mux.HandleFunc("GET /api/v1/structural/designs/{id}", h.GetDesign)
	mux.HandleFunc("GET /api/v1/structural/designs", h.ListDesigns)
	mux.HandleFunc("DELETE /api/v1/structural/designs/{id}", h.DeleteDesign)

	mux.HandleFunc("POST /api/v1/structural/designs/{id}/dead-load", h.ComputeDeadLoad)
	mux.HandleFunc("POST /api/v1/structural/designs/{id}/wind-load", h.ComputeWindLoad)
	mux.HandleFunc("POST /api/v1/structural/designs/{id}/seismic-load", h.ComputeSeismicLoad)
	mux.HandleFunc("POST /api/v1/structural/designs/{id}/foundation", h.ComputeFoundation)
	mux.HandleFunc("POST /api/v1/structural/designs/{id}/validate", h.Validate)

	mux.HandleFunc("POST /api/v1/structural/designs/{id}/submit", h.SubmitForReview)
	mux.HandleFunc("POST /api/v1/structural/designs/{id}/approve", h.ApproveDesign)
	mux.HandleFunc("POST /api/v1/structural/designs/{id}/reject", h.RejectDesign)

	mux.HandleFunc("GET /api/v1/structural/designs/{id}/report.txt", h.GenerateReport)
}

func (h *Handler) CreateDesign(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateDesignRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	d, err := h.svc.CreateDesign(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusCreated, d)
}

func (h *Handler) GetDesign(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	d, err := h.svc.GetDesign(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "design not found")
		return
	}
	h.writeJSON(w, http.StatusOK, d)
}

func (h *Handler) ListDesigns(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}
	designs, err := h.svc.ListDesigns(r.Context(), projectID)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, designs)
}

func (h *Handler) DeleteDesign(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	if err := h.svc.DeleteDesign(r.Context(), id); err != nil {
		writeError(w, http.StatusNotFound, "design not found")
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (h *Handler) ComputeDeadLoad(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ComputeDeadLoadRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	resp, err := h.svc.ComputeDeadLoad(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) ComputeWindLoad(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ComputeWindLoadRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	resp, err := h.svc.ComputeWindLoad(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) ComputeSeismicLoad(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ComputeSeismicLoadRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	resp, err := h.svc.ComputeSeismicLoad(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) ComputeFoundation(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ComputeFoundationRequirementRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	resp, err := h.svc.ComputeFoundationRequirement(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) Validate(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ValidateStructuralDesignRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	resp, err := h.svc.ValidateStructuralDesign(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, resp)
}

func (h *Handler) SubmitForReview(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ReviewRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	d, err := h.svc.SubmitForReview(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, d)
}

func (h *Handler) ApproveDesign(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ReviewRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	d, err := h.svc.ApproveDesign(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, d)
}

func (h *Handler) RejectDesign(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	var req domain.ReviewRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.DesignID = id
	d, err := h.svc.RejectDesign(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, d)
}

func (h *Handler) GenerateReport(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid design ID")
		return
	}
	report, err := h.svc.GenerateStructuralReport(r.Context(), id)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="structural-design-%s.txt"`, id))
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
