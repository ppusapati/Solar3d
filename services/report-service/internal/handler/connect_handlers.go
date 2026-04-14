package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"solar3d/report-service/internal/domain"
	"solar3d/report-service/internal/service"
)

type ReportHandler struct {
	svc *service.ReportService
}

func NewReportHandler(svc *service.ReportService) *ReportHandler {
	return &ReportHandler{svc: svc}
}

func (h *ReportHandler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/reports", h.GenerateReport)
	mux.HandleFunc("GET /api/v1/reports/{id}", h.GetReport)
	mux.HandleFunc("GET /api/v1/reports", h.ListReports)
	mux.HandleFunc("DELETE /api/v1/reports/{id}", h.DeleteReport)
	mux.HandleFunc("POST /api/v1/reports/bom", h.GenerateBOM)
	mux.HandleFunc("POST /api/v1/reports/export-layout", h.ExportLayout)
}

func (h *ReportHandler) GenerateReport(w http.ResponseWriter, r *http.Request) {
	var req domain.GenerateReportRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	report, err := h.svc.GenerateReport(r.Context(), req)
	if err != nil {
		log.Error().Err(err).Msg("failed to generate report")
		if errors.Is(err, service.ErrApprovalRequired) || errors.Is(err, service.ErrLOD400GateNotPassed) {
			writeError(w, http.StatusUnprocessableEntity, err.Error())
			return
		}
		writeError(w, http.StatusInternalServerError, "failed to generate report")
		return
	}

	writeJSON(w, http.StatusCreated, report)
}

func (h *ReportHandler) GetReport(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid report ID")
		return
	}

	report, err := h.svc.GetReport(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "report not found")
		return
	}

	writeJSON(w, http.StatusOK, report)
}

func (h *ReportHandler) ListReports(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.URL.Query().Get("project_id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id parameter")
		return
	}

	reports, err := h.svc.ListReports(r.Context(), projectID)
	if err != nil {
		log.Error().Err(err).Msg("failed to list reports")
		writeError(w, http.StatusInternalServerError, "failed to list reports")
		return
	}

	writeJSON(w, http.StatusOK, reports)
}

func (h *ReportHandler) DeleteReport(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid report ID")
		return
	}

	if err := h.svc.DeleteReport(r.Context(), id); err != nil {
		writeError(w, http.StatusNotFound, "report not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *ReportHandler) GenerateBOM(w http.ResponseWriter, r *http.Request) {
	var req domain.GenerateBOMRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	bom, err := h.svc.GenerateBOM(r.Context(), req)
	if err != nil {
		log.Error().Err(err).Msg("failed to generate BOM")
		writeError(w, http.StatusInternalServerError, "failed to generate BOM")
		return
	}

	writeJSON(w, http.StatusOK, bom)
}

func (h *ReportHandler) ExportLayout(w http.ResponseWriter, r *http.Request) {
	var req domain.ExportLayoutRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	report, err := h.svc.ExportLayout(r.Context(), req)
	if err != nil {
		log.Error().Err(err).Msg("failed to export layout")
		if errors.Is(err, service.ErrApprovalRequired) || errors.Is(err, service.ErrLOD400GateNotPassed) {
			writeError(w, http.StatusUnprocessableEntity, err.Error())
			return
		}
		writeError(w, http.StatusInternalServerError, "failed to export layout")
		return
	}

	writeJSON(w, http.StatusOK, report)
}

func writeJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		log.Error().Err(err).Msg("failed to encode response")
	}
}

func writeError(w http.ResponseWriter, status int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(map[string]string{"error": message}); err != nil {
		log.Error().Err(err).Str("message", message).Msg("failed to encode error response")
	}
}
