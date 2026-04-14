package handler

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/terrain-service/internal/domain"
	"solar3d/terrain-service/internal/service"
)

// Handler provides HTTP handlers for the terrain service API.
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

// RegisterRoutes wires all terrain endpoints to the given ServeMux.
func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("POST /api/v1/terrain/layers", h.UploadTerrain)
	mux.HandleFunc("GET /api/v1/terrain/layers/{id}", h.GetLayer)
	mux.HandleFunc("GET /api/v1/terrain/layers", h.ListLayers)
	mux.HandleFunc("GET /api/v1/terrain/dem/metrics", h.GetDEMMetrics)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/analyze/earthwork", h.AnalyzeEarthwork)
	mux.HandleFunc("POST /api/v1/terrain/analyze-site", h.AnalyzeSite)
	mux.HandleFunc("DELETE /api/v1/terrain/layers/{id}", h.DeleteLayer)
	mux.HandleFunc("GET /api/v1/terrain/layers/{id}/elevation", h.GetElevation)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/elevation-grid", h.GetElevationGrid)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/compute/slope", h.ComputeSlope)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/compute/aspect", h.ComputeAspect)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/diff", h.DiffTerrainLayers)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/diff/export.csv", h.DiffTerrainLayersCSV)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/grading-plan", h.GenerateGradingPlan)
	mux.HandleFunc("POST /api/v1/terrain/layers/{id}/grading-plan/report.txt", h.GradingPlanReport)
}

type analyzeEarthworkRequest struct {
	TargetElevationM *float64 `json:"target_elevation_m"`
	BoundaryGeoJSON  string   `json:"boundary_geojson"`
	MinDeltaM        float64  `json:"min_delta_m"`
	HaulFactor       float64  `json:"haul_factor"`
	GridWidth        int      `json:"grid_width"`
	GridHeight       int      `json:"grid_height"`
}

// AnalyzeEarthwork handles POST /api/v1/terrain/layers/{id}/analyze/earthwork.
func (h *Handler) AnalyzeEarthwork(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	var req analyzeEarthworkRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	summary, err := h.svc.AnalyzeEarthwork(r.Context(), id, service.AnalyzeEarthworkRequest{
		TargetElevationM: req.TargetElevationM,
		BoundaryGeoJSON:  req.BoundaryGeoJSON,
		MinDeltaM:        req.MinDeltaM,
		HaulFactor:       req.HaulFactor,
		GridWidth:        req.GridWidth,
		GridHeight:       req.GridHeight,
	})
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, summary)
}

type analyzeSiteRequest struct {
	ProjectID                   string  `json:"project_id"`
	BoundaryGeoJSON             string  `json:"boundary_geojson"`
	VegetationDensityPerHectare float64 `json:"vegetation_density_per_hectare"`
}

// AnalyzeSite handles POST /api/v1/terrain/analyze-site.
func (h *Handler) AnalyzeSite(w http.ResponseWriter, r *http.Request) {
	var req analyzeSiteRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	projectID, err := uuid.Parse(req.ProjectID)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}

	summary, err := h.svc.AnalyzeSite(r.Context(), service.AnalyzeSiteRequest{
		ProjectID:                   projectID,
		BoundaryGeoJSON:             req.BoundaryGeoJSON,
		VegetationDensityPerHectare: req.VegetationDensityPerHectare,
	})
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, summary)
}

// UploadTerrain handles POST /api/v1/terrain/layers.
func (h *Handler) UploadTerrain(w http.ResponseWriter, r *http.Request) {
	var req service.UploadTerrainRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	layer, err := h.svc.UploadTerrain(r.Context(), req)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, layer)
}

// GetLayer handles GET /api/v1/terrain/layers/{id}.
func (h *Handler) GetLayer(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	layer, err := h.svc.GetLayer(r.Context(), id)
	if err != nil {
		h.writeError(w, http.StatusNotFound, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, layer)
}

// ListLayers handles GET /api/v1/terrain/layers?project_id=...
func (h *Handler) ListLayers(w http.ResponseWriter, r *http.Request) {
	projectIDStr := r.URL.Query().Get("project_id")
	if projectIDStr == "" {
		h.writeError(w, http.StatusBadRequest, "project_id query parameter is required")
		return
	}

	projectID, err := uuid.Parse(projectIDStr)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid project_id")
		return
	}

	layers, err := h.svc.ListLayers(r.Context(), projectID)
	if err != nil {
		h.writeError(w, http.StatusInternalServerError, err.Error())
		return
	}

	if layers == nil {
		layers = []domain.TerrainLayer{}
	}

	h.writeJSON(w, http.StatusOK, layers)
}

// GetDEMMetrics handles GET /api/v1/terrain/dem/metrics?project_id=... (optional).
func (h *Handler) GetDEMMetrics(w http.ResponseWriter, r *http.Request) {
	projectIDStr := strings.TrimSpace(r.URL.Query().Get("project_id"))
	var projectID *uuid.UUID
	if projectIDStr != "" {
		parsed, err := uuid.Parse(projectIDStr)
		if err != nil {
			h.writeError(w, http.StatusBadRequest, "invalid project_id")
			return
		}
		projectID = &parsed
	}

	metrics, err := h.svc.GetDEMMetrics(r.Context(), projectID)
	if err != nil {
		h.writeError(w, http.StatusInternalServerError, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, metrics)
}

// DeleteLayer handles DELETE /api/v1/terrain/layers/{id}.
func (h *Handler) DeleteLayer(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	if err := h.svc.DeleteLayer(r.Context(), id); err != nil {
		h.writeError(w, http.StatusNotFound, err.Error())
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// elevationRequest is used to parse query params for point elevation queries.
type elevationResponse struct {
	X         float64 `json:"x"`
	Y         float64 `json:"y"`
	Elevation float64 `json:"elevation"`
}

// GetElevation handles GET /api/v1/terrain/layers/{id}/elevation?x=...&y=...
func (h *Handler) GetElevation(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	x, err := strconv.ParseFloat(r.URL.Query().Get("x"), 64)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid or missing x parameter")
		return
	}

	y, err := strconv.ParseFloat(r.URL.Query().Get("y"), 64)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid or missing y parameter")
		return
	}

	point, err := h.svc.GetElevation(r.Context(), id, x, y)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, elevationResponse{
		X:         point.X,
		Y:         point.Y,
		Elevation: point.Elevation,
	})
}

// elevationGridRequest carries the parameters for a grid elevation query.
type elevationGridRequest struct {
	Bounds domain.BoundingBox `json:"bounds"`
	Width  int                `json:"width"`
	Height int                `json:"height"`
}

// GetElevationGrid handles POST /api/v1/terrain/layers/{id}/elevation-grid.
func (h *Handler) GetElevationGrid(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	var req elevationGridRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	grid, err := h.svc.GetElevationGrid(r.Context(), id, req.Bounds, req.Width, req.Height)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, grid)
}

// ComputeSlope handles POST /api/v1/terrain/layers/{id}/compute/slope.
func (h *Handler) ComputeSlope(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	layer, err := h.svc.ComputeSlope(r.Context(), id)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, layer)
}

// ComputeAspect handles POST /api/v1/terrain/layers/{id}/compute/aspect.
func (h *Handler) ComputeAspect(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid layer id")
		return
	}

	layer, err := h.svc.ComputeAspect(r.Context(), id)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusCreated, layer)
}

// apiError is the standard error response envelope.
type apiError struct {
	Error string `json:"error"`
}

func (h *Handler) writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(v); err != nil {
		h.logger.Error().Err(err).Msg("failed to encode response")
	}
}

func (h *Handler) writeError(w http.ResponseWriter, status int, msg string) {
	h.logger.Warn().Int("status", status).Str("error", msg).Msg("request error")
	h.writeJSON(w, status, apiError{Error: msg})
}

type diffTerrainLayersRequest struct {
	CompareLayerID string `json:"compare_layer_id"`
	GridWidth      int    `json:"grid_width"`
	GridHeight     int    `json:"grid_height"`
}

// DiffTerrainLayers handles POST /api/v1/terrain/layers/{id}/diff.
// Returns a JSON summary of per-cell elevation differences between the base
// layer (path {id}) and the compare layer specified in the request body.
func (h *Handler) DiffTerrainLayers(w http.ResponseWriter, r *http.Request) {
	baseID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid base layer id")
		return
	}

	var req diffTerrainLayersRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	compareID, err := uuid.Parse(strings.TrimSpace(req.CompareLayerID))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid compare_layer_id")
		return
	}

	diff, err := h.svc.DiffTerrainLayers(r.Context(), baseID, service.DiffTerrainLayersRequest{
		CompareLayerID: compareID,
		GridWidth:      req.GridWidth,
		GridHeight:     req.GridHeight,
	})
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	h.writeJSON(w, http.StatusOK, diff)
}

// DiffTerrainLayersCSV handles POST /api/v1/terrain/layers/{id}/diff/export.csv.
// Returns the per-cell elevation delta as a RFC 4180 CSV attachment with columns:
// lon, lat, delta_m  (compare minus base, in metres; row-major order).
func (h *Handler) DiffTerrainLayersCSV(w http.ResponseWriter, r *http.Request) {
	baseID, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid base layer id")
		return
	}

	var req diffTerrainLayersRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid request body: "+err.Error())
		return
	}

	compareID, err := uuid.Parse(strings.TrimSpace(req.CompareLayerID))
	if err != nil {
		h.writeError(w, http.StatusBadRequest, "invalid compare_layer_id")
		return
	}

	diff, err := h.svc.DiffTerrainLayers(r.Context(), baseID, service.DiffTerrainLayersRequest{
		CompareLayerID: compareID,
		GridWidth:      req.GridWidth,
		GridHeight:     req.GridHeight,
	})
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	filename := fmt.Sprintf("terrain-diff-%s-vs-%s.csv", baseID, compareID)
	w.Header().Set("Content-Type", "text/csv; charset=utf-8")
	w.Header().Set("Content-Disposition", "attachment; filename=\""+filename+"\"")
	w.WriteHeader(http.StatusOK)

	cw := csv.NewWriter(w)
	_ = cw.Write([]string{"lon", "lat", "delta_m"})

	bounds := diff.OverlapBounds
	cellW := (bounds.MaxX - bounds.MinX) / float64(diff.GridWidth)
	cellH := (bounds.MaxY - bounds.MinY) / float64(diff.GridHeight)
	for row := 0; row < diff.GridHeight; row++ {
		lat := bounds.MinY + (float64(row)+0.5)*cellH
		for col := 0; col < diff.GridWidth; col++ {
			lon := bounds.MinX + (float64(col)+0.5)*cellW
			delta := diff.DeltaElevations[row*diff.GridWidth+col]
			_ = cw.Write([]string{
				strconv.FormatFloat(lon, 'f', 8, 64),
				strconv.FormatFloat(lat, 'f', 8, 64),
				strconv.FormatFloat(delta, 'f', 4, 64),
			})
		}
	}
	cw.Flush()
}

type generateGradingPlanRequest struct {
	TargetElevationM *float64 `json:"target_elevation_m"`
	BoundaryGeoJSON  string   `json:"boundary_geojson"`
	MinDeltaM        float64  `json:"min_delta_m"`
	HaulFactor       float64  `json:"haul_factor"`
	GridWidth        int      `json:"grid_width"`
	GridHeight       int      `json:"grid_height"`
	CutRatePerM3     float64  `json:"cut_rate_per_m3"`
	FillRatePerM3    float64  `json:"fill_rate_per_m3"`
	HaulRatePerM3M   float64  `json:"haul_rate_per_m3m"`
	ImportRatePerM3  float64  `json:"import_rate_per_m3"`
	ExportRatePerM3  float64  `json:"export_rate_per_m3"`
	CompactionFactor float64  `json:"compaction_factor"`
	CurrencyCode     string   `json:"currency_code"`
}

func parseGradingPlanRequest(r *http.Request) (uuid.UUID, service.GradingPlanRequest, error) {
	id, err := uuid.Parse(r.PathValue("id"))
	if err != nil {
		return uuid.Nil, service.GradingPlanRequest{}, fmt.Errorf("invalid layer id")
	}
	var req generateGradingPlanRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		return uuid.Nil, service.GradingPlanRequest{}, fmt.Errorf("invalid request body: %w", err)
	}
	return id, service.GradingPlanRequest{
		TargetElevationM: req.TargetElevationM,
		BoundaryGeoJSON:  req.BoundaryGeoJSON,
		MinDeltaM:        req.MinDeltaM,
		HaulFactor:       req.HaulFactor,
		GridWidth:        req.GridWidth,
		GridHeight:       req.GridHeight,
		CutRatePerM3:     req.CutRatePerM3,
		FillRatePerM3:    req.FillRatePerM3,
		HaulRatePerM3M:   req.HaulRatePerM3M,
		ImportRatePerM3:  req.ImportRatePerM3,
		ExportRatePerM3:  req.ExportRatePerM3,
		CompactionFactor: req.CompactionFactor,
		CurrencyCode:     req.CurrencyCode,
	}, nil
}

// GenerateGradingPlan handles POST /api/v1/terrain/layers/{id}/grading-plan.
func (h *Handler) GenerateGradingPlan(w http.ResponseWriter, r *http.Request) {
	id, svcReq, err := parseGradingPlanRequest(r)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, err.Error())
		return
	}
	plan, err := h.svc.GenerateGradingPlan(r.Context(), id, svcReq)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}
	h.writeJSON(w, http.StatusOK, plan)
}

// GradingPlanReport handles POST /api/v1/terrain/layers/{id}/grading-plan/report.txt.
// Returns a plain-text engineering report with all assumptions and cost figures
// traceable to real computed values.
func (h *Handler) GradingPlanReport(w http.ResponseWriter, r *http.Request) {
	id, svcReq, err := parseGradingPlanRequest(r)
	if err != nil {
		h.writeError(w, http.StatusBadRequest, err.Error())
		return
	}
	plan, err := h.svc.GenerateGradingPlan(r.Context(), id, svcReq)
	if err != nil {
		h.writeError(w, http.StatusUnprocessableEntity, err.Error())
		return
	}

	cur := plan.Cost.CurrencyCode
	if cur == "" {
		cur = "USD"
	}
	report := buildGradingPlanReport(plan, cur)
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="grading-plan-%s.txt"`, id))
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, report)
}

func buildGradingPlanReport(p *service.GradingPlan, cur string) string {
	f := func(v float64) string { return strconv.FormatFloat(v, 'f', 2, 64) }
	vol := func(v float64) string { return f(v) + " m³" }
	cost := func(v float64) string { return cur + " " + f(v) }

	var b strings.Builder
	b.WriteString("==========================================================\n")
	b.WriteString("  EARTHWORK GRADING PLAN REPORT\n")
	b.WriteString("==========================================================\n\n")

	b.WriteString("--- ASSUMPTIONS ---\n")
	fmt.Fprintf(&b, "  DEM layer:          %s\n", p.DEMLayerID)
	fmt.Fprintf(&b, "  Target elevation:   %s m\n", f(p.TargetElevationM))
	fmt.Fprintf(&b, "  Mean elevation:     %s m\n", f(p.MeanElevationM))
	fmt.Fprintf(&b, "  Compaction factor:  %.4f  (in-situ cut / compacted fill)\n", p.CompactionFactor)
	fmt.Fprintf(&b, "  Cut unit rate:      %s / m³\n", cost(p.CutRatePerM3))
	fmt.Fprintf(&b, "  Fill unit rate:     %s / m³\n", cost(p.FillRatePerM3))
	fmt.Fprintf(&b, "  Haul unit rate:     %s / m³·m\n", cost(p.HaulRatePerM3M))
	fmt.Fprintf(&b, "  Import unit rate:   %s / m³\n", cost(p.ImportRatePerM3))
	fmt.Fprintf(&b, "  Export unit rate:   %s / m³\n", cost(p.ExportRatePerM3))
	b.WriteByte('\n')

	b.WriteString("--- EARTHWORK VOLUMES ---\n")
	fmt.Fprintf(&b, "  Affected area:      %s m²\n", f(p.AffectedAreaSqm))
	fmt.Fprintf(&b, "  Cut volume:         %s\n", vol(p.Cost.CutVolumeM3))
	fmt.Fprintf(&b, "  Fill volume:        %s\n", vol(p.Cost.FillVolumeM3))
	fmt.Fprintf(&b, "  Fill demand (cut):  %s  (fill × compaction factor)\n", vol(p.Cost.FillDemandM3))
	fmt.Fprintf(&b, "  Balanced ratio:     %.2f\n", p.BalancedVolumeRatio)
	fmt.Fprintf(&b, "  Hauled on-site:     %s\n", vol(p.Cost.HauledVolumeM3))
	fmt.Fprintf(&b, "  Haul distance:      %s m  (volume-weighted centroid)\n", f(p.Cost.HaulDistanceM))
	fmt.Fprintf(&b, "  Haul effort:        %s m³·m\n", f(p.Cost.HaulEffortM3M))
	fmt.Fprintf(&b, "  Export (surplus):   %s\n", vol(p.Cost.ExportVolumeM3))
	fmt.Fprintf(&b, "  Import (shortfall): %s\n", vol(p.Cost.ImportVolumeM3))
	b.WriteByte('\n')

	b.WriteString("--- COST BREAKDOWN ---\n")
	fmt.Fprintf(&b, "  Cut:                %s\n", cost(p.Cost.CutCost))
	fmt.Fprintf(&b, "  Fill:               %s\n", cost(p.Cost.FillCost))
	fmt.Fprintf(&b, "  Haul:               %s\n", cost(p.Cost.HaulCost))
	fmt.Fprintf(&b, "  Import:             %s\n", cost(p.Cost.ImportCost))
	fmt.Fprintf(&b, "  Export (disposal):  %s\n", cost(p.Cost.ExportCost))
	b.WriteString("  ----------------------------------\n")
	fmt.Fprintf(&b, "  TOTAL:              %s\n", cost(p.Cost.TotalCost))
	b.WriteString("\n==========================================================\n")
	b.WriteString("  All figures are computed from DEM grid analysis.\n")
	b.WriteString("  Costs are estimates only. Verify with site conditions.\n")
	b.WriteString("==========================================================\n")

	return b.String()
}
