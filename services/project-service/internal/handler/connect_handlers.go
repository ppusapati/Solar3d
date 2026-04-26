package handler

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/project-service/internal/domain"
	"p9e.in/samavaya/solar3d/project-service/internal/gis"
	"p9e.in/samavaya/solar3d/project-service/internal/service"
)

// ProjectHandler exposes the project service over HTTP/JSON following
// ConnectRPC-style URL conventions. This serves as a gateway layer until full
// proto generation is wired up.
type ProjectHandler struct {
	svc    *service.ProjectService
	logger zerolog.Logger
}

const maxCadParseUploadBytes = 32 << 20

// NewProjectHandler creates a new handler wired to the given service.
func NewProjectHandler(svc *service.ProjectService, logger zerolog.Logger) *ProjectHandler {
	return &ProjectHandler{
		svc:    svc,
		logger: logger.With().Str("component", "handler").Logger(),
	}
}

// Register mounts all routes onto the provided mux.
func (h *ProjectHandler) Register(mux *http.ServeMux) {
	// REST routes used by the frontend.
	mux.HandleFunc("POST /api/v1/projects", h.CreateProjectREST)
	mux.HandleFunc("GET /api/v1/projects", h.ListProjectsREST)
	mux.HandleFunc("GET /api/v1/projects/{id}", h.GetProjectREST)
	mux.HandleFunc("PUT /api/v1/projects/{id}", h.UpdateProjectREST)
	mux.HandleFunc("DELETE /api/v1/projects/{id}", h.DeleteProjectREST)
	mux.HandleFunc("POST /api/v1/projects/{id}/site/import-boundary", h.ImportSiteBoundaryREST)
	mux.HandleFunc("POST /api/v1/cad/parse", h.ParseCadFileREST)
	mux.HandleFunc("POST /api/v1/projects/{id}/zones/import", h.ImportConstraintZonesREST)
	mux.HandleFunc("GET /api/v1/projects/{id}/zones", h.ListConstraintZonesREST)

	// ConnectRPC-style routes.
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
	InitialLatitude  float64 `json:"initial_latitude"`
	InitialLongitude float64 `json:"initial_longitude"`
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
	InitialLatitude  float64 `json:"initial_latitude"`
	InitialLongitude float64 `json:"initial_longitude"`
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

type projectEnvelope struct {
	Project *domain.Project `json:"project"`
}

type listProjectsResponse struct {
	Projects      []*domain.Project `json:"projects"`
	NextPageToken string            `json:"next_page_token"`
	TotalCount    int               `json:"total_count"`
}

type updateProjectPatchRequest struct {
	Name             *string  `json:"name"`
	Description      *string  `json:"description"`
	Status           *string  `json:"status"`
	TargetCapacityMW *float64 `json:"target_capacity_mw"`
	LocationName     *string  `json:"location_name"`
	ClientName       *string  `json:"client_name"`
	Notes            *string  `json:"notes"`
	InitialLatitude  *float64 `json:"initial_latitude"`
	InitialLongitude *float64 `json:"initial_longitude"`
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
		InitialLatitude:  req.InitialLatitude,
		InitialLongitude: req.InitialLongitude,
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
		InitialLatitude:  req.InitialLatitude,
		InitialLongitude: req.InitialLongitude,
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

	// Sync project initial_latitude/longitude from site centroid if not yet set.
	if req.Latitude != 0 || req.Longitude != 0 {
		project, pErr := h.svc.GetProject(r.Context(), projectID)
		if pErr == nil && project.InitialLatitude == 0 && project.InitialLongitude == 0 {
			project.InitialLatitude = req.Latitude
			project.InitialLongitude = req.Longitude
			_ = h.svc.UpdateProject(r.Context(), project)
		}
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

func (h *ProjectHandler) ImportSiteBoundaryREST(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return
	}

	if err := r.ParseMultipartForm(32 << 20); err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid multipart form")
		return
	}

	file, header, err := r.FormFile("file")
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "file is required")
		return
	}
	defer file.Close()

	payload, err := io.ReadAll(file)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "failed to read uploaded file")
		return
	}

	sourceName := header.Filename
	if sourceName == "" {
		sourceName = "site-boundary"
	}

	sourceFormat := gis.DetectFormat(sourceName, payload)
	if sourceFormat == gis.FileFormatUnknown {
		h.respondError(w, http.StatusBadRequest, "file must be .kml, .kmz, or .dxf")
		return
	}
	if sourceFormat == gis.FileFormatDWG {
		h.respondDWGError(w, http.StatusUnprocessableEntity, sourceName, payload)
		return
	}

	site, err := h.svc.ImportSiteBoundary(
		r.Context(),
		projectID,
		sourceName,
		payload,
		r.FormValue("name"),
		r.FormValue("timezone"),
	)
	if err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, site)
}

func (h *ProjectHandler) ParseCadFileREST(w http.ResponseWriter, r *http.Request) {
	r.Body = http.MaxBytesReader(w, r.Body, maxCadParseUploadBytes)
	if err := r.ParseMultipartForm(maxCadParseUploadBytes); err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "request body too large") {
			h.respondError(w, http.StatusRequestEntityTooLarge, "uploaded CAD file exceeds 32MB limit")
			return
		}
		h.respondError(w, http.StatusBadRequest, "invalid multipart form")
		return
	}

	file, header, err := r.FormFile("file")
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "file is required")
		return
	}
	defer file.Close()

	payload, err := io.ReadAll(file)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "failed to read uploaded file")
		return
	}

	sourceName := "cad-upload"
	if header != nil && strings.TrimSpace(header.Filename) != "" {
		sourceName = header.Filename
	}

	format := gis.DetectFormat(sourceName, payload)
	if format == gis.FileFormatUnknown {
		h.respondError(w, http.StatusBadRequest, "unsupported format; use .kml, .kmz, or .dxf")
		return
	}
	if format == gis.FileFormatDWG {
		h.respondDWGError(w, http.StatusUnprocessableEntity, sourceName, payload)
		return
	}

	if format == gis.FileFormatKML || format == gis.FileFormatKMZ {
		boundary, err := gis.ParseSiteBoundary(sourceName, payload)
		if err != nil {
			h.respondError(w, http.StatusBadRequest, err.Error())
			return
		}

		var boundaryGeom map[string]any
		if err := json.Unmarshal([]byte(boundary.GeoJSON), &boundaryGeom); err != nil {
			h.respondError(w, http.StatusBadRequest, "failed to decode boundary geometry")
			return
		}

		h.respond(w, http.StatusOK, map[string]any{
			"source_format": "kml",
			"source_crs":    "EPSG:4326",
			"layers":        []string{"KML"},
			"feature_collection": map[string]any{
				"type": "FeatureCollection",
				"features": []map[string]any{
					{
						"type":       "Feature",
						"geometry":   boundaryGeom,
						"properties": map[string]any{"layer": "KML", "name": boundary.Name, "entity_type": "Polygon"},
					},
				},
			},
		})
		return
	}

	parsed, err := gis.ParseDXF(payload)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, err.Error())
		return
	}

	features := make([]map[string]any, 0, len(parsed.Features))
	for _, feature := range parsed.Features {
		features = append(features, map[string]any{
			"type":     "Feature",
			"geometry": feature.Geometry,
			"properties": map[string]any{
				"layer":       feature.Layer,
				"entity_type": feature.EntityType,
				"closed":      feature.Closed,
			},
		})
	}

	h.respond(w, http.StatusOK, map[string]any{
		"source_format": "dxf",
		"source_crs":    parsed.SourceCRS,
		"layers":        parsed.Layers,
		"feature_collection": map[string]any{
			"type":     "FeatureCollection",
			"features": features,
		},
	})
}

func (h *ProjectHandler) ImportConstraintZonesREST(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return
	}

	if err := r.ParseMultipartForm(32 << 20); err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid multipart form")
		return
	}

	file, header, err := r.FormFile("file")
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "file is required")
		return
	}
	defer file.Close()

	payload, err := io.ReadAll(file)
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "failed to read uploaded file")
		return
	}

	sourceName := header.Filename
	if sourceName == "" {
		sourceName = "constraint-zones"
	}
	if ext := strings.ToLower(filepath.Ext(sourceName)); ext != ".kml" && ext != ".kmz" {
		h.respondError(w, http.StatusBadRequest, "file must be .kml or .kmz")
		return
	}

	zones, err := h.svc.ImportConstraintZones(
		r.Context(),
		projectID,
		sourceName,
		payload,
	)
	if err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, map[string]interface{}{
		"zones": zones,
		"count": len(zones),
	})
}

func (h *ProjectHandler) ListConstraintZonesREST(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return
	}

	zones, err := h.svc.GetConstraintZonesByProject(r.Context(), projectID)
	if err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, map[string]interface{}{
		"zones": zones,
		"count": len(zones),
	})
}

// --- REST handlers ---

func (h *ProjectHandler) CreateProjectREST(w http.ResponseWriter, r *http.Request) {
	var req CreateProjectRequest
	if !h.decode(w, r, &req) {
		return
	}

	project := &domain.Project{
		Name:             req.Name,
		Description:      req.Description,
		Status:           domain.ProjectStatus(req.Status),
		TargetCapacityMW: req.TargetCapacityMW,
		LocationName:     req.LocationName,
		ClientName:       req.ClientName,
		Notes:            req.Notes,
		InitialLatitude:  req.InitialLatitude,
		InitialLongitude: req.InitialLongitude,
	}

	if err := h.svc.CreateProject(r.Context(), project); err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusCreated, projectEnvelope{Project: project})
}

func (h *ProjectHandler) GetProjectREST(w http.ResponseWriter, r *http.Request) {
	id, ok := h.parseProjectIDFromPath(w, r)
	if !ok {
		return
	}

	project, err := h.svc.GetProject(r.Context(), id)
	if err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, projectEnvelope{Project: project})
}

func (h *ProjectHandler) ListProjectsREST(w http.ResponseWriter, r *http.Request) {
	pageSize := 20
	if raw := strings.TrimSpace(r.URL.Query().Get("page_size")); raw != "" {
		parsed, err := strconv.Atoi(raw)
		if err != nil {
			h.respondError(w, http.StatusBadRequest, "invalid page_size")
			return
		}
		pageSize = parsed
	}

	offset := 0
	if raw := strings.TrimSpace(r.URL.Query().Get("page_token")); raw != "" {
		parsed, err := strconv.Atoi(raw)
		if err != nil {
			h.respondError(w, http.StatusBadRequest, "invalid page_token")
			return
		}
		offset = parsed
	}

	if pageSize <= 0 {
		h.respondError(w, http.StatusBadRequest, "page_size must be greater than 0")
		return
	}

	projects, err := h.svc.ListProjects(r.Context(), pageSize, offset)
	if err != nil {
		h.handleError(w, err)
		return
	}
	if projects == nil {
		projects = []*domain.Project{}
	}

	nextPageToken := ""
	if len(projects) == pageSize {
		nextPageToken = strconv.Itoa(offset + len(projects))
	}

	h.respond(w, http.StatusOK, listProjectsResponse{
		Projects:      projects,
		NextPageToken: nextPageToken,
		TotalCount:    offset + len(projects),
	})
}

func (h *ProjectHandler) UpdateProjectREST(w http.ResponseWriter, r *http.Request) {
	id, ok := h.parseProjectIDFromPath(w, r)
	if !ok {
		return
	}

	var req updateProjectPatchRequest
	if !h.decode(w, r, &req) {
		return
	}

	project, err := h.svc.GetProject(r.Context(), id)
	if err != nil {
		h.handleError(w, err)
		return
	}

	if req.Name != nil {
		project.Name = *req.Name
	}
	if req.Description != nil {
		project.Description = *req.Description
	}
	if req.Status != nil {
		project.Status = domain.ProjectStatus(*req.Status)
	}
	if req.TargetCapacityMW != nil {
		project.TargetCapacityMW = *req.TargetCapacityMW
	}
	if req.LocationName != nil {
		project.LocationName = *req.LocationName
	}
	if req.ClientName != nil {
		project.ClientName = *req.ClientName
	}
	if req.Notes != nil {
		project.Notes = *req.Notes
	}
	if req.InitialLatitude != nil {
		project.InitialLatitude = *req.InitialLatitude
	}
	if req.InitialLongitude != nil {
		project.InitialLongitude = *req.InitialLongitude
	}

	if err := h.svc.UpdateProject(r.Context(), project); err != nil {
		h.handleError(w, err)
		return
	}

	h.respond(w, http.StatusOK, projectEnvelope{Project: project})
}

func (h *ProjectHandler) DeleteProjectREST(w http.ResponseWriter, r *http.Request) {
	id, ok := h.parseProjectIDFromPath(w, r)
	if !ok {
		return
	}

	if err := h.svc.DeleteProject(r.Context(), id); err != nil {
		h.handleError(w, err)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// --- Helpers ---

func (h *ProjectHandler) decode(w http.ResponseWriter, r *http.Request, dst any) bool {
	if r.Header.Get("Content-Type") != "" && r.Header.Get("Content-Type") != "application/json" {
		h.respondError(w, http.StatusUnsupportedMediaType, "content-type must be application/json")
		return false
	}
	if err := json.NewDecoder(r.Body).Decode(dst); err != nil {
		if errors.Is(err, io.EOF) {
			return true
		}
		h.respondError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return false
	}
	return true
}

func (h *ProjectHandler) parseProjectIDFromPath(w http.ResponseWriter, r *http.Request) (uuid.UUID, bool) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.respondError(w, http.StatusBadRequest, "invalid project id")
		return uuid.Nil, false
	}

	return id, true
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

func (h *ProjectHandler) respondDWGError(w http.ResponseWriter, code int, sourceName string, payload []byte) {
	dwgErr := gis.NewDWGUploadError(sourceName, payload)
	h.respond(w, code, map[string]string{
		"error":            dwgErr.Error(),
		"code":             "dwg_not_supported",
		"format":           "dwg",
		"dwg_version":      dwgErr.Version,
		"reason":           dwgErr.Reason,
		"suggested_action": dwgErr.SuggestedAction,
	})
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
