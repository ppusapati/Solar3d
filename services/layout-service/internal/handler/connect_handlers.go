package handler

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/layout-service/internal/domain"
	"p9e.in/samavaya/solar3d/layout-service/internal/service"

	"github.com/rs/zerolog"
)

// Handler provides REST/JSON endpoints for layout operations.
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

// RegisterRoutes wires up all endpoints on the given mux.
func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	// Layout CRUD
	mux.HandleFunc("POST /api/v1/layouts", h.CreateLayout)
	mux.HandleFunc("GET /api/v1/layouts/{id}", h.GetLayout)
	mux.HandleFunc("GET /api/v1/projects/{projectId}/layouts", h.ListLayouts)
	mux.HandleFunc("PUT /api/v1/layouts/{id}", h.UpdateLayout)
	mux.HandleFunc("DELETE /api/v1/layouts/{id}", h.DeleteLayout)
	mux.HandleFunc("POST /api/v1/layouts/{id}/submit-review", h.SubmitLayoutForReview)
	mux.HandleFunc("POST /api/v1/layouts/{id}/approve", h.ApproveLayout)
	mux.HandleFunc("POST /api/v1/layouts/{id}/reject", h.RejectLayout)

	// Components
	mux.HandleFunc("POST /api/v1/layouts/{layoutId}/components", h.PlaceComponent)
	mux.HandleFunc("GET /api/v1/components/{id}", h.GetComponent)
	mux.HandleFunc("GET /api/v1/layouts/{layoutId}/components", h.ListComponents)
	mux.HandleFunc("DELETE /api/v1/components/{id}", h.DeleteComponent)

	// Panel array generation
	mux.HandleFunc("POST /api/v1/layouts/{layoutId}/generate-array", h.GeneratePanelArray)
	mux.HandleFunc("POST /api/v1/layouts/{layoutId}/import-candidate", h.ImportCandidate)
	mux.HandleFunc("POST /api/v1/layouts/{layoutId}/plan-zones", h.PlanZones)

	// Spatial tile queries
	mux.HandleFunc("POST /api/v1/layouts/{layoutId}/tiles/query", h.QueryTiles)
	mux.HandleFunc("GET /api/v1/tiles/{tileId}/panels", h.GetPanelsByTile)
}

// ---------------------------------------------------------------------------
// Layout handlers
// ---------------------------------------------------------------------------

type createLayoutRequest struct {
	ProjectID string `json:"project_id"`
	Name      string `json:"name"`
}

func (h *Handler) CreateLayout(w http.ResponseWriter, r *http.Request) {
	var req createLayoutRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	projectID, err := uuid.Parse(req.ProjectID)
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}
	if req.Name == "" {
		writeError(w, http.StatusBadRequest, "name is required")
		return
	}

	layout, err := h.svc.CreateLayout(r.Context(), projectID, req.Name)
	if err != nil {
		h.logger.Error().Err(err).Msg("create layout failed")
		writeError(w, http.StatusInternalServerError, "failed to create layout")
		return
	}

	h.writeJSON(w, http.StatusCreated, layout)
}

func (h *Handler) GetLayout(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout id")
		return
	}

	layout, err := h.svc.GetLayout(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "layout not found")
		return
	}

	h.writeJSON(w, http.StatusOK, layout)
}

func (h *Handler) ListLayouts(w http.ResponseWriter, r *http.Request) {
	projectID, err := uuid.Parse(r.PathValue("projectId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}

	layouts, err := h.svc.ListLayouts(r.Context(), projectID)
	if err != nil {
		h.logger.Error().Err(err).Msg("list layouts failed")
		writeError(w, http.StatusInternalServerError, "failed to list layouts")
		return
	}
	if layouts == nil {
		layouts = []*domain.Layout{}
	}

	h.writeJSON(w, http.StatusOK, layouts)
}

func (h *Handler) UpdateLayout(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout id")
		return
	}

	var req struct {
		Name string `json:"name"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	layout, err := h.svc.GetLayout(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "layout not found")
		return
	}

	if req.Name != "" {
		layout.Name = req.Name
	}

	if err := h.svc.UpdateLayout(r.Context(), layout); err != nil {
		h.logger.Error().Err(err).Msg("update layout failed")
		writeError(w, http.StatusInternalServerError, "failed to update layout")
		return
	}

	h.writeJSON(w, http.StatusOK, layout)
}

func (h *Handler) DeleteLayout(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout id")
		return
	}

	if err := h.svc.DeleteLayout(r.Context(), id); err != nil {
		h.logger.Error().Err(err).Msg("delete layout failed")
		writeError(w, http.StatusInternalServerError, "failed to delete layout")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (h *Handler) SubmitLayoutForReview(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout id")
		return
	}

	var req struct {
		SubmissionReason string `json:"submission_reason"`
		SubmittedByActor string `json:"submitted_by_actor_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	layout, err := h.svc.SubmitForReview(r.Context(), service.SubmitForReviewRequest{
		LayoutID:         layoutID,
		SubmissionReason: req.SubmissionReason,
		ActorID:          req.SubmittedByActor,
	})
	if err != nil {
		h.logger.Error().Err(err).Str("layout_id", layoutID.String()).Msg("submit layout for review failed")
		writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, layout)
}

func (h *Handler) ApproveLayout(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout id")
		return
	}

	var req struct {
		QualityScore      float64  `json:"quality_score"`
		ApprovalComments  []string `json:"approval_comments"`
		ApprovedByActorID string   `json:"approved_by_actor_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	layout, err := h.svc.ApproveLayout(r.Context(), service.ApproveLayoutRequest{
		LayoutID:         layoutID,
		QualityScore:     req.QualityScore,
		ApprovalComments: req.ApprovalComments,
		ActorID:          req.ApprovedByActorID,
	})
	if err != nil {
		h.logger.Error().Err(err).Str("layout_id", layoutID.String()).Msg("approve layout failed")
		writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, layout)
}

func (h *Handler) RejectLayout(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout id")
		return
	}

	var req struct {
		RejectionReasons []string `json:"rejection_reasons"`
		RejectedByActor  string   `json:"rejected_by_actor_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	layout, err := h.svc.RejectLayout(r.Context(), service.RejectLayoutRequest{
		LayoutID:         layoutID,
		RejectionReasons: req.RejectionReasons,
		ActorID:          req.RejectedByActor,
	})
	if err != nil {
		h.logger.Error().Err(err).Str("layout_id", layoutID.String()).Msg("reject layout failed")
		writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, layout)
}

// ---------------------------------------------------------------------------
// Component handlers
// ---------------------------------------------------------------------------

func (h *Handler) PlaceComponent(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("layoutId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout_id")
		return
	}

	var c domain.Component
	if err := json.NewDecoder(r.Body).Decode(&c); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	c.LayoutID = layoutID

	if err := h.svc.PlaceComponent(r.Context(), &c); err != nil {
		h.logger.Error().Err(err).Msg("place component failed")
		writeError(w, http.StatusInternalServerError, "failed to place component")
		return
	}

	h.writeJSON(w, http.StatusCreated, c)
}

func (h *Handler) GetComponent(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid component id")
		return
	}

	c, err := h.svc.GetComponent(r.Context(), id)
	if err != nil {
		writeError(w, http.StatusNotFound, "component not found")
		return
	}

	h.writeJSON(w, http.StatusOK, c)
}

func (h *Handler) ListComponents(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("layoutId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout_id")
		return
	}

	components, err := h.svc.ListComponents(r.Context(), layoutID)
	if err != nil {
		h.logger.Error().Err(err).Msg("list components failed")
		writeError(w, http.StatusInternalServerError, "failed to list components")
		return
	}
	if components == nil {
		components = []*domain.Component{}
	}

	h.writeJSON(w, http.StatusOK, components)
}

func (h *Handler) DeleteComponent(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid component id")
		return
	}

	if err := h.svc.DeleteComponent(r.Context(), id); err != nil {
		h.logger.Error().Err(err).Msg("delete component failed")
		writeError(w, http.StatusInternalServerError, "failed to delete component")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// ---------------------------------------------------------------------------
// Panel array generation handler
// ---------------------------------------------------------------------------

func (h *Handler) GeneratePanelArray(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("layoutId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout_id")
		return
	}

	var params domain.PanelArrayParams
	if err := json.NewDecoder(r.Body).Decode(&params); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	// Validate required fields.
	if params.PanelWidth <= 0 || params.PanelHeight <= 0 {
		writeError(w, http.StatusBadRequest, "panel_width and panel_height must be positive")
		return
	}
	if params.TiltAngle < 0 || params.TiltAngle > 90 {
		writeError(w, http.StatusBadRequest, "tilt_angle must be between 0 and 90 degrees")
		return
	}
	if len(params.FillAreaGeoJSON) == 0 {
		writeError(w, http.StatusBadRequest, "fill_area_geojson is required")
		return
	}

	result, err := h.svc.GeneratePanelArray(r.Context(), layoutID, params)
	if err != nil {
		h.logger.Error().Err(err).Str("layout_id", layoutID.String()).Msg("generate panel array failed")
		writeError(w, http.StatusInternalServerError, fmt.Sprintf("array generation failed: %v", err))
		return
	}

	h.writeJSON(w, http.StatusOK, result)
}

func (h *Handler) ImportCandidate(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("layoutId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout_id")
		return
	}

	var req struct {
		CandidateID string `json:"candidate_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	candidateID, err := uuid.Parse(req.CandidateID)
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid candidate_id")
		return
	}

	result, err := h.svc.ImportCandidateArtifacts(r.Context(), layoutID, candidateID)
	if err != nil {
		h.logger.Error().Err(err).
			Str("layout_id", layoutID.String()).
			Str("candidate_id", candidateID.String()).
			Msg("import candidate failed")
		switch {
		case errors.Is(err, domain.ErrCandidateNotFound):
			writeError(w, http.StatusNotFound, "candidate not found")
		case errors.Is(err, domain.ErrCandidateProjectScope):
			writeError(w, http.StatusUnprocessableEntity, "candidate project does not match layout project")
		case errors.Is(err, domain.ErrCandidateEmpty), errors.Is(err, domain.ErrInvalidCandidateGeom):
			writeError(w, http.StatusUnprocessableEntity, err.Error())
		default:
			writeError(w, http.StatusInternalServerError, "failed to import candidate")
		}
		return
	}

	h.writeJSON(w, http.StatusOK, result)
}

func (h *Handler) PlanZones(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("layoutId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout_id")
		return
	}

	var req domain.ZonePlanRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	if req.TargetCapacityMW <= 0 {
		writeError(w, http.StatusBadRequest, "target_capacity_mw must be positive")
		return
	}
	if req.BoundaryGeoJSON == "" {
		writeError(w, http.StatusBadRequest, "boundary_geojson is required")
		return
	}

	plan, err := h.svc.PlanInfrastructureZones(r.Context(), layoutID, req)
	if err != nil {
		h.logger.Error().Err(err).Msg("plan zones failed")
		writeError(w, http.StatusUnprocessableEntity, fmt.Sprintf("zone planning failed: %v", err))
		return
	}

	h.writeJSON(w, http.StatusOK, plan)
}

// ---------------------------------------------------------------------------
// Spatial tile query handlers
// ---------------------------------------------------------------------------

func (h *Handler) QueryTiles(w http.ResponseWriter, r *http.Request) {
	layoutID, err := uuid.Parse(r.PathValue("layoutId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid layout_id")
		return
	}

	var vq domain.ViewportQuery
	if err := json.NewDecoder(r.Body).Decode(&vq); err != nil {
		writeError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	tiles, err := h.svc.GetTiles(r.Context(), layoutID, vq)
	if err != nil {
		h.logger.Error().Err(err).Msg("query tiles failed")
		writeError(w, http.StatusInternalServerError, "failed to query tiles")
		return
	}
	if tiles == nil {
		tiles = []*domain.LayoutTile{}
	}

	h.writeJSON(w, http.StatusOK, tiles)
}

func (h *Handler) GetPanelsByTile(w http.ResponseWriter, r *http.Request) {
	tileID, err := uuid.Parse(r.PathValue("tileId"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "invalid tile_id")
		return
	}

	panels, err := h.svc.GetPanelsByTile(r.Context(), tileID)
	if err != nil {
		h.logger.Error().Err(err).Msg("get panels by tile failed")
		writeError(w, http.StatusInternalServerError, "failed to get panels")
		return
	}
	if panels == nil {
		panels = []*domain.Panel{}
	}

	h.writeJSON(w, http.StatusOK, panels)
}

// ---------------------------------------------------------------------------
// Response helpers
// ---------------------------------------------------------------------------

func (h *Handler) writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(v); err != nil {
		h.logger.Error().Err(err).Msg("failed to encode response")
	}
}

type errorResponse struct {
	Error string `json:"error"`
}

func writeError(w http.ResponseWriter, status int, msg string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(errorResponse{Error: msg})
}
