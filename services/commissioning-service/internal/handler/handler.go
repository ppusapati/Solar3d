package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/commissioning-service/internal/domain"
	"p9e.in/samavaya/solar3d/commissioning-service/internal/service"
)

type Handler struct {
	svc    *service.Service
	logger zerolog.Logger
}

func New(svc *service.Service, logger zerolog.Logger) *Handler {
	return &Handler{svc: svc, logger: logger.With().Str("component", "handler").Logger()}
}

func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	// Checklist CRUD
	mux.HandleFunc("POST /api/v1/commissioning/checklists", h.CreateChecklist)
	mux.HandleFunc("GET /api/v1/commissioning/checklists/{id}", h.GetChecklist)
	mux.HandleFunc("GET /api/v1/commissioning/checklists", h.ListChecklists)

	// Checklist items
	mux.HandleFunc("POST /api/v1/commissioning/checklists/{id}/items", h.AddChecklistItem)
	mux.HandleFunc("PUT /api/v1/commissioning/items/{item_id}", h.UpdateChecklistItem)

	// Signoff
	mux.HandleFunc("POST /api/v1/commissioning/checklists/{id}/signoff", h.SignOffChecklist)
	mux.HandleFunc("GET /api/v1/commissioning/checklists/{id}/signoffs", h.ListSignoffs)

	// Handover
	mux.HandleFunc("POST /api/v1/commissioning/handovers", h.CreateHandover)
	mux.HandleFunc("GET /api/v1/commissioning/handovers/{id}", h.GetHandover)

	// As-built
	mux.HandleFunc("POST /api/v1/commissioning/as-built", h.RecordAsBuilt)
	mux.HandleFunc("GET /api/v1/commissioning/as-built", h.ListAsBuiltArtifacts)

	// Report
	mux.HandleFunc("GET /api/v1/commissioning/checklists/{id}/report.txt", h.GenerateReport)
}

// ── Checklist ─────────────────────────────────────────────────────────────

func (h *Handler) CreateChecklist(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateChecklistRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	cl, err := h.svc.CreateChecklist(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusCreated, cl)
}

func (h *Handler) GetChecklist(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid checklist ID")
		return
	}
	cl, err := h.svc.GetChecklist(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "checklist not found")
		return
	}
	h.writeJSON(w, http.StatusOK, cl)
}

func (h *Handler) ListChecklists(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}
	cls, err := h.svc.ListChecklists(r.Context(), projectID)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, cls)
}

// ── ChecklistItem ─────────────────────────────────────────────────────────

func (h *Handler) AddChecklistItem(w http.ResponseWriter, r *http.Request) {
	checklistID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid checklist ID")
		return
	}
	var req domain.AddChecklistItemRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.ChecklistID = checklistID
	item, err := h.svc.AddChecklistItem(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusCreated, item)
}

func (h *Handler) UpdateChecklistItem(w http.ResponseWriter, r *http.Request) {
	itemID, err := uuid.Parse(r.PathValue("item_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid item ID")
		return
	}
	var req domain.UpdateChecklistItemRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.ItemID = itemID
	item, err := h.svc.UpdateChecklistItem(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, item)
}

// ── Signoff ───────────────────────────────────────────────────────────────

func (h *Handler) SignOffChecklist(w http.ResponseWriter, r *http.Request) {
	checklistID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid checklist ID")
		return
	}
	var req domain.SignOffChecklistRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	req.ChecklistID = checklistID
	signoff, updated, err := h.svc.SignOffChecklist(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusCreated, map[string]any{
		"signoff":           signoff,
		"updated_checklist": updated,
	})
}

func (h *Handler) ListSignoffs(w http.ResponseWriter, r *http.Request) {
	checklistID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid checklist ID")
		return
	}
	signoffs, err := h.svc.ListSignoffs(r.Context(), checklistID)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, signoffs)
}

// ── Handover ──────────────────────────────────────────────────────────────

func (h *Handler) CreateHandover(w http.ResponseWriter, r *http.Request) {
	var req domain.CreateHandoverRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	handover, err := h.svc.CreateHandover(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusCreated, handover)
}

func (h *Handler) GetHandover(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid handover ID")
		return
	}
	handover, err := h.svc.GetHandover(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "handover not found")
		return
	}
	h.writeJSON(w, http.StatusOK, handover)
}

// ── AsBuilt ───────────────────────────────────────────────────────────────

func (h *Handler) RecordAsBuilt(w http.ResponseWriter, r *http.Request) {
	var req domain.RecordAsBuiltRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	art, err := h.svc.RecordAsBuilt(r.Context(), req)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusCreated, art)
}

func (h *Handler) ListAsBuiltArtifacts(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}
	arts, err := h.svc.ListAsBuiltArtifacts(r.Context(), projectID)
	if err != nil {
		h.writeErr(w, err)
		return
	}
	h.writeJSON(w, http.StatusOK, arts)
}

// ── Report ─────────────────────────────────────────────────────────────────

func (h *Handler) GenerateReport(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid checklist ID")
		return
	}
	report, err := h.svc.GenerateReport(r.Context(), domain.GenerateReportRequest{ChecklistID: id})
	if err != nil {
		h.writeErr(w, err)
		return
	}
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="commissioning-%s.txt"`, id))
	w.WriteHeader(http.StatusOK)
	_, _ = strings.NewReader(report).WriteTo(w)
}

// ── Helpers ───────────────────────────────────────────────────────────────

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
