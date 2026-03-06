package handler

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"github.com/solar3d/solar3d/services/project-service/internal/domain"
	"github.com/solar3d/solar3d/services/project-service/internal/service"
)

// ProjectHandler exposes the project service over HTTP/JSON following
// ConnectRPC-style URL conventions. This serves as a gateway layer until full
// proto generation is wired up.
type ProjectHandler struct {
	svc    *service.ProjectService
	logger zerolog.Logger
}

// NewProjectHandler creates a new handler wired to the given service.
func NewProjectHandler(svc *service.ProjectService, logger zerolog.Logger) *ProjectHandler {
	return &ProjectHandler{
		svc:    svc,
		logger: logger.With().Str("component", "handler").Logger(),
	}
}

// Register mounts all routes onto the provided mux using ConnectRPC-style paths.
func (h *ProjectHandler) Register(mux *http.ServeMux) {
	mux.HandleFunc("POST /solar.project.v1.ProjectService/CreateProject", h.CreateProject)
	mux.HandleFunc("POST /solar.project.v1.ProjectService/GetProject", h.GetProject)
	mux.HandleFunc("POST /solar.project.v1.ProjectService/ListProjects", h.ListProjects)
	mux.HandleFunc("POST /solar.project.v1.ProjectService/UpdateProject", h.UpdateProject)
	mux.HandleFunc("POST /solar.project.v1.ProjectService/DeleteProject", h.DeleteProject)
	mux.HandleFunc("POST /solar.project.v1.ProjectService/CreateSite", h.CreateSite)
	mux.HandleFunc("POST /solar.project.v1.ProjectService/GetSiteByProjectID", h.GetSiteByProjectID)
}

// --- Request / Response DTOs ---

// CreateProjectRequest is the JSON body for creating a project.
type CreateProjectRequest struct {
	Name             string  `json:"name"`
	Description      string  `json:"description"`
	Status           string  `json:"status"`
	TargetCapacityMW float64 `json:"target_capacity_mw"`
	LocationName     string  `json:"location_name"`
	ClientName       string  `json:"client_name"`
	Notes            string  `json:"notes"`
}

// IDRequest is used for single-entity lookups and deletes.
type IDRequest struct {
	ID string `json:"id"`
}

// ListProjectsRequest supports simple pagination.
type ListProjectsRequest struct {
	Limit  int `json:"limit"`
	Offset int `json:"offset"`
}

// UpdateProjectRequest carries updated fields together with the target ID.
type UpdateProjectRequest struct {
	ID               string  `json:"id"`
	Name             string  `json:"name"`
	Description      string  `json:"description"`
	Status           string  `json:"status"`
	TargetCapacityMW float64 `json:"target_capacity_mw"`
	LocationName     string  `json:"location_name"`
	ClientName       string  `json:"client_name"`
	Notes            string  `json:"notes"`
}

// CreateSiteRequest is the JSON body for creating a site.
type CreateSiteRequest struct {
	ProjectID       string  `json:"project_id"`
	Name            string  `json:"name"`
	BoundaryGeoJSON string  `json:"boundary_geojson"`
	AreaSqm         float64 `json:"area_sqm"`
	Latitude        float64 `json:"latitude"`
	Longitude       float64 `json:"longitude"`
	Timezone        string  `json:"timezone"`
}

// --- Handlers ---

// CreateProject handles project creation.
func (h *ProjectHandler) CreateProject(w http.ResponseWriter, r *http.Request) {
	var req CreateProjectRequest
	if !h.decode(w, r, &req) {
		return
	}

	p := &domain.Project{
		Name:             req.Name,
		Description:      req.Description,
		Status:           domain.ProjectStatus(req.Status),
		TargetCapacityMW: req.TargetCapacityMW,
		LocationName:     req.LocationName,
		ClientName:       req.ClientName,
		Notes:            req.Notes,
	}

	if err := h.svc.CreateProject(r.Context(), p); err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, p)
}

// GetProject handles project retrieval by ID.
func (h *ProjectHandler) GetProject(w http.ResponseWriter, r *http.Request) {
	var req IDRequest
	if !h.decode(w, r, &req) {
		return
	}

	id, err := uuid.Parse(req.ID)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return
	}

	p, err := h.svc.GetProject(r.Context(), id)
	if err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, p)
}

// ListProjects handles paginated project listing.
func (h *ProjectHandler) ListProjects(w http.ResponseWriter, r *http.Request) {
	var req ListProjectsRequest
	if !h.decode(w, r, &req) {
		return
	}

	// Also accept query params for convenience.
	if req.Limit == 0 {
		if v := r.URL.Query().Get("limit"); v != "" {
			parsed, err := strconv.Atoi(v)
			if err != nil {
				h.handleError(w, fmt.Errorf("invalid limit parameter: %w", err))
				return
			}
			req.Limit = parsed
		}
	}

	projects, err := h.svc.ListProjects(r.Context(), req.Limit, req.Offset)
	if err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, map[string]any{"projects": projects})
}

// UpdateProject handles project updates.
func (h *ProjectHandler) UpdateProject(w http.ResponseWriter, r *http.Request) {
	var req UpdateProjectRequest
	if !h.decode(w, r, &req) {
		return
	}

	id, err := uuid.Parse(req.ID)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return
	}

	p := &domain.Project{
		ID:               id,
		Name:             req.Name,
		Description:      req.Description,
		Status:           domain.ProjectStatus(req.Status),
		TargetCapacityMW: req.TargetCapacityMW,
		LocationName:     req.LocationName,
		ClientName:       req.ClientName,
		Notes:            req.Notes,
	}

	if err := h.svc.UpdateProject(r.Context(), p); err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, p)
}

// DeleteProject handles project deletion.
func (h *ProjectHandler) DeleteProject(w http.ResponseWriter, r *http.Request) {
	var req IDRequest
	if !h.decode(w, r, &req) {
		return
	}

	id, err := uuid.Parse(req.ID)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return
	}

	if err := h.svc.DeleteProject(r.Context(), id); err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, map[string]string{"status": "deleted"})
}

// CreateSite handles site creation.
func (h *ProjectHandler) CreateSite(w http.ResponseWriter, r *http.Request) {
	var req CreateSiteRequest
	if !h.decode(w, r, &req) {
		return
	}

	projectID, err := uuid.Parse(req.ProjectID)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project_id")
		return
	}

	site := &domain.Site{
		ProjectID:       projectID,
		Name:            req.Name,
		BoundaryGeoJSON: req.BoundaryGeoJSON,
		AreaSqm:         req.AreaSqm,
		Latitude:        req.Latitude,
		Longitude:       req.Longitude,
		Timezone:        req.Timezone,
	}

	if err := h.svc.CreateSite(r.Context(), site); err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, site)
}

// GetSiteByProjectID handles site retrieval by project ID.
func (h *ProjectHandler) GetSiteByProjectID(w http.ResponseWriter, r *http.Request) {
	var req IDRequest
	if !h.decode(w, r, &req) {
		return
	}

	projectID, err := uuid.Parse(req.ID)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return
	}

	site, err := h.svc.GetSiteByProjectID(r.Context(), projectID)
	if err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, site)
}

// --- Helpers ---

func (h *ProjectHandler) decode(w http.ResponseWriter, r *http.Request, dst any) bool {
	if r.Header.Get("Content-Type") != "" && r.Header.Get("Content-Type") != "application/json" {
		h.respondError(w, http.StatusUnsupportedMediaType, "content-type must be application/json")
		return false
	}
	if err := json.NewDecoder(r.Body).Decode(dst); err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return false
	}
	return true
}

func (h *ProjectHandler) respond(w http.ResponseWriter, code int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		h.logger.Error().Err(err).Msg("failed to encode response")
	}
}

func (h *ProjectHandler) respondError(w http.ResponseWriter, code int, message string) {
	h.respond(w, code, map[string]string{"error": message})
}

func (h *ProjectHandler) handleError(w http.ResponseWriter, err error) {
	switch {
	case errors.Is(err, service.ErrNotFound):
		h.respondError(w, http.StatusNotFound, "resource not found")
	case errors.Is(err, service.ErrInvalidInput):
		h.respondError(w, http.StatusBadRequest, err.Error())
	default:
		h.logger.Error().Err(err).Msg("internal error")
		h.respondError(w, http.StatusInternalServerError, "internal server error")
	}
}
