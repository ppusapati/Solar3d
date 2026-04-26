package service

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"math"
	"net/http"
	"sort"
	"strings"
	"time"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/repository"
)

var ErrInvalidInput = errors.New("invalid transmission route input")

const routeAnchorToleranceDeg = 0.0002

type transmissionRepository interface {
	Create(ctx context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error)
	GetByID(ctx context.Context, id uuid.UUID) (*domain.TransmissionRoute, error)
	ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.TransmissionRoute, error)
	Delete(ctx context.Context, id uuid.UUID) error
	SubmitForReview(ctx context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error)
	Approve(ctx context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error)
	Reject(ctx context.Context, route *domain.TransmissionRoute) (*domain.TransmissionRoute, error)
}

type TransmissionService struct {
	repo       transmissionRepository
	bridgeURL  string
	projectURL string
	httpClient *http.Client
	demSources []DEMSource
}

func NewTransmissionService(repo *repository.Repository, bridgeURL, terrainServiceURL, projectServiceURL string) *TransmissionService {
	return &TransmissionService{
		repo:       repo,
		bridgeURL:  bridgeURL,
		projectURL: strings.TrimRight(projectServiceURL, "/"),
		httpClient: &http.Client{
			Timeout: 45 * time.Second,
		},
		demSources: []DEMSource{
			NewTerrainServiceDEMSource(terrainServiceURL),
			NewOpenElevationDEMSource(""),
		},
	}
}

func (s *TransmissionService) CalculateTransmissionRoute(ctx context.Context, req domain.CalculateTransmissionRouteRequest) (*domain.TransmissionRoute, error) {
	return s.calculate(ctx, req, nil)
}

func (s *TransmissionService) StreamTransmissionRoute(ctx context.Context, req domain.CalculateTransmissionRouteRequest, emit func(domain.ProgressUpdate) error) (*domain.TransmissionRoute, error) {
	return s.calculate(ctx, req, emit)
}

func (s *TransmissionService) GetTransmissionRoute(ctx context.Context, id uuid.UUID) (*domain.TransmissionRoute, error) {
	route, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if route == nil {
		return nil, repository.ErrNotFound
	}
	if route.ApprovalStatus == "" {
		route.ApprovalStatus = domain.ApprovalStatusDraft
	}
	if route.RouteScore == nil {
		score := ScoreRoute(route)
		route.RouteScore = &score
	}
	return route, nil
}

func (s *TransmissionService) ListTransmissionRoutes(ctx context.Context, projectID uuid.UUID) ([]domain.TransmissionRoute, error) {
	routes, err := s.repo.ListByProject(ctx, projectID)
	if err != nil {
		return nil, err
	}
	for index := range routes {
		if routes[index].ApprovalStatus == "" {
			routes[index].ApprovalStatus = domain.ApprovalStatusDraft
		}
	}
	annotateParetoRoutes(routes)
	return routes, nil
}

func (s *TransmissionService) DeleteTransmissionRoute(ctx context.Context, id uuid.UUID) error {
	return s.repo.Delete(ctx, id)
}

func (s *TransmissionService) calculate(ctx context.Context, req domain.CalculateTransmissionRouteRequest, emit func(domain.ProgressUpdate) error) (*domain.TransmissionRoute, error) {
	if err := validateRequest(req); err != nil {
		return nil, err
	}
	if err := s.validateRouteAnchors(ctx, req); err != nil {
		return nil, err
	}
	constraints := resolveConstraints(req.VoltageClass, req.Constraints)

	fmt.Printf("[transmission] route request: farm=(%.6f, %.6f) grid=(%.6f, %.6f) voltage=%s\n",
		req.FarmOutputPoint.Lat, req.FarmOutputPoint.Lon,
		req.GridInjectionPoint.Lat, req.GridInjectionPoint.Lon,
		req.VoltageClass)
	fmt.Printf("[transmission] raster: %dx%d cellSize=%.0fm origin=(%.6f, %.6f)\n",
		req.ElevationRaster.Width, req.ElevationRaster.Height,
		req.ElevationRaster.CellSizeM,
		req.ElevationRaster.OriginLat, req.ElevationRaster.OriginLon)

	allFeatures := append([]domain.VectorFeature{}, req.VectorFeatures...)
	if s.projectURL != "" {
		zoneFeatures, err := s.fetchConstraintZoneFeatures(ctx, req.ProjectID)
		if err == nil {
			allFeatures = append(allFeatures, zoneFeatures...)
		}
	}
	req.VectorFeatures = allFeatures

	// Phase 4: auto-fetch real DEM elevation when the client sent a synthesised flat raster.
	demSourceID := "client_provided"
	demAutoFetched := false
	if len(s.demSources) > 0 && isRasterFlat(req.ElevationRaster) {
		_ = sendProgress(emit, domain.ProgressUpdate{Phase: "dem_fetch", PercentComplete: 12, Message: "fetching DEM elevation data"})
		for _, source := range s.demSources {
			fetched, fetchedSourceID, err := source.FetchRaster(
				ctx,
				&req.ProjectID,
				req.ElevationRaster.OriginLon,
				req.ElevationRaster.OriginLat,
				rasterMaxLon(req.ElevationRaster),
				rasterMaxLat(req.ElevationRaster),
				req.ElevationRaster.CellSizeM,
			)
			if err == nil {
				req.ElevationRaster = fetched
				demAutoFetched = true
				demSourceID = fetchedSourceID
				break
			}
		}
	}

	_ = sendProgress(emit, domain.ProgressUpdate{Phase: "preprocessing", PercentComplete: 15, Message: "validating raster inputs"})

	// Count road features for diagnostics.
	roadFeatureCount := 0
	for _, f := range req.VectorFeatures {
		if isRoadLikeForBuffer(f.FeatureType) {
			roadFeatureCount++
		}
	}
	fmt.Printf("[transmission] features: %d total, %d road-like, offRoadPenalty=%.1f roadBufferM=%.0f\n",
		len(req.VectorFeatures), roadFeatureCount, constraints.OffRoadPenalty, constraints.RoadBufferM)

	costGrid := buildCostGrid(req.ElevationRaster, req.ObstacleRaster, req.VectorFeatures, constraints)
	_ = sendProgress(emit, domain.ProgressUpdate{Phase: "vectorization", PercentComplete: 25, Message: "building terrain cost grid"})

	route, bridgeErr := s.calculateViaBridge(ctx, req, constraints, costGrid)
	if bridgeErr != nil {
		_ = sendProgress(emit, domain.ProgressUpdate{Phase: "fallback", PercentComplete: 35, Message: "terrain bridge unavailable, using Go fallback"})
		fallback, err := buildFallbackRoute(req, constraints, costGrid)
		if err != nil {
			return nil, fmt.Errorf("bridge failed: %w; fallback failed: %w", bridgeErr, err)
		}
		route = fallback
	} else {
		_ = sendProgress(emit, domain.ProgressUpdate{Phase: "pathfinding", PercentComplete: 70, Message: "terrain bridge returned route candidate"})
	}

	route.ID = uuid.New()
	route.ProjectID = req.ProjectID
	route.Name = req.Name
	route.VoltageClass = req.VoltageClass
	route.FarmOutputPoint = req.FarmOutputPoint
	route.GridInjectionPoint = req.GridInjectionPoint
	route.ApprovalStatus = domain.ApprovalStatusDraft
	routeScore := ScoreRoute(route)
	route.RouteScore = &routeScore
	if route.RouteSummary == "" {
		route.RouteSummary = buildRouteSummary(route)
	}

	// Phase 4: attach data source snapshot for reproducibility and audit trail.
	snapshot := buildDataSourceSnapshot(req, demAutoFetched, demSourceID)
	if route.Metadata == nil {
		route.Metadata = make(map[string]interface{})
	}
	route.Metadata["route_score"] = routeScore
	route.Metadata["data_source_snapshot"] = snapshot
	if err := populateRouteTraceability(route, req, snapshot); err != nil {
		return nil, err
	}
	appendGovernanceEvent(route, "created", "system", "route calculated and stored as draft", "", domain.ApprovalStatusDraft, time.Now().UTC())
	demLabel := "client"
	if demAutoFetched {
		demLabel = "auto-fetched"
	}
	shortID := snapshot.SnapshotID
	if len(shortID) > 8 {
		shortID = shortID[:8]
	}
	if route.RouteSummary != "" {
		route.RouteSummary += "; "
	}
	route.RouteSummary += fmt.Sprintf("data-snapshot:%s (dem:%s, features:%d)", shortID, demLabel, snapshot.VectorFeatureCount)
	if routeScore.RecommendationReason != "" {
		route.RouteSummary += "; " + routeScore.RecommendationReason
	}

	_ = sendProgress(emit, domain.ProgressUpdate{Phase: "persisting", PercentComplete: 90, Message: "saving transmission route"})
	saved, err := s.repo.Create(ctx, route)
	if err != nil {
		return nil, err
	}
	_ = sendProgress(emit, domain.ProgressUpdate{Phase: "complete", PercentComplete: 100, Message: "route ready", Route: saved})
	return saved, nil
}

type constraintZonesResponse struct {
	Zones []constraintZonePayload `json:"zones"`
}

type projectAnchorPayload struct {
	ID               string  `json:"id"`
	InitialLatitude  float64 `json:"initial_latitude"`
	InitialLongitude float64 `json:"initial_longitude"`
	Notes            string  `json:"notes"`
}

type projectAnchorResponse struct {
	ID               string                `json:"id"`
	InitialLatitude  float64               `json:"initial_latitude"`
	InitialLongitude float64               `json:"initial_longitude"`
	Notes            string                `json:"notes"`
	Project          *projectAnchorPayload `json:"project"`
}

type gridConnectionCenter struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type latLonPoint struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type projectNotesPayload struct {
	GridConnectionCenter *gridConnectionCenter `json:"grid_connection_center"`
}

// farmLocationNotes is a separate struct for extracting farm location from notes.
// solar_farm_boundary_vertices are stored as [[lon,lat],...] coordinate pairs (GeoJSON convention).
type farmLocationNotes struct {
	ProjectLocation           *latLonPoint `json:"project_location"`
	FarmLocation              *latLonPoint `json:"farm_location"`
	SolarFarmCenter           *latLonPoint `json:"solar_farm_center"`
	SolarFarmBoundaryVertices [][]float64  `json:"solar_farm_boundary_vertices"`
}

func (s *TransmissionService) validateRouteAnchors(ctx context.Context, req domain.CalculateTransmissionRouteRequest) error {
	if s.projectURL == "" || req.ProjectID == uuid.Nil {
		return nil
	}

	anchor, err := s.fetchProjectAnchor(ctx, req.ProjectID)
	if err != nil {
		return err
	}

	if !withinTolerance(req.FarmOutputPoint.Lat, anchor.InitialLatitude, routeAnchorToleranceDeg) ||
		!withinTolerance(req.FarmOutputPoint.Lon, anchor.InitialLongitude, routeAnchorToleranceDeg) {
		return fmt.Errorf(
			"%w: farm_output_point must match project location (expected %.6f, %.6f; got %.6f, %.6f)",
			ErrInvalidInput,
			anchor.InitialLatitude,
			anchor.InitialLongitude,
			req.FarmOutputPoint.Lat,
			req.FarmOutputPoint.Lon,
		)
	}

	grid, err := parseGridConnectionCenter(anchor.Notes)
	if err != nil {
		return err
	}

	if !withinTolerance(req.GridInjectionPoint.Lat, grid.Latitude, routeAnchorToleranceDeg) ||
		!withinTolerance(req.GridInjectionPoint.Lon, grid.Longitude, routeAnchorToleranceDeg) {
		return fmt.Errorf(
			"%w: grid_injection_point must match project grid/substation location (expected %.6f, %.6f; got %.6f, %.6f)",
			ErrInvalidInput,
			grid.Latitude,
			grid.Longitude,
			req.GridInjectionPoint.Lat,
			req.GridInjectionPoint.Lon,
		)
	}

	return nil
}

func (s *TransmissionService) fetchProjectAnchor(ctx context.Context, projectID uuid.UUID) (*projectAnchorPayload, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, fmt.Sprintf("%s/api/v1/projects/%s", s.projectURL, projectID.String()), nil)
	if err != nil {
		return nil, fmt.Errorf("create project anchor request: %w", err)
	}

	resp, err := s.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("fetch project anchor: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, fmt.Errorf("%w: project %s not found", ErrInvalidInput, projectID.String())
	}
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("fetch project anchor failed with status %d", resp.StatusCode)
	}

	var response projectAnchorResponse
	if err := json.NewDecoder(resp.Body).Decode(&response); err != nil {
		return nil, fmt.Errorf("decode project anchor response: %w", err)
	}

	payload := response.Project
	if payload == nil {
		payload = &projectAnchorPayload{
			ID:               response.ID,
			InitialLatitude:  response.InitialLatitude,
			InitialLongitude: response.InitialLongitude,
			Notes:            response.Notes,
		}
	}
	if payload.ID == "" {
		payload.ID = projectID.String()
	}
	if payload.InitialLatitude == 0 && payload.InitialLongitude == 0 {
		// Fall back to location data stored in project notes JSON
		lat, lon, ok := parseFarmLocationFromNotes(payload.Notes)
		if !ok {
			return nil, fmt.Errorf("%w: project anchor response missing initial location", ErrInvalidInput)
		}
		payload.InitialLatitude = lat
		payload.InitialLongitude = lon
	}

	return payload, nil
}

// parseFarmLocationFromNotes extracts a farm/project lat-lon from the notes JSON.
// It tries project_location, farm_location, solar_farm_center, then the centroid
// of solar_farm_boundary_vertices (stored as [[lon,lat],...] GeoJSON pairs).
func parseFarmLocationFromNotes(raw string) (lat, lon float64, ok bool) {
	if strings.TrimSpace(raw) == "" {
		return 0, 0, false
	}
	var n farmLocationNotes
	if err := json.Unmarshal([]byte(raw), &n); err != nil {
		return 0, 0, false
	}
	for _, pt := range []*latLonPoint{n.ProjectLocation, n.FarmLocation, n.SolarFarmCenter} {
		if pt != nil && (pt.Latitude != 0 || pt.Longitude != 0) {
			return pt.Latitude, pt.Longitude, true
		}
	}
	if len(n.SolarFarmBoundaryVertices) > 0 {
		var sumLat, sumLon float64
		var count int
		for _, v := range n.SolarFarmBoundaryVertices {
			if len(v) >= 2 {
				// GeoJSON convention: [longitude, latitude]
				sumLon += v[0]
				sumLat += v[1]
				count++
			}
		}
		if count > 0 {
			return sumLat / float64(count), sumLon / float64(count), true
		}
	}
	return 0, 0, false
}

func parseGridConnectionCenter(raw string) (*gridConnectionCenter, error) {
	trimmed := strings.TrimSpace(raw)
	if trimmed == "" {
		return nil, fmt.Errorf("%w: project notes missing grid_connection_center", ErrInvalidInput)
	}

	var parsed projectNotesPayload
	if err := json.Unmarshal([]byte(trimmed), &parsed); err != nil {
		return nil, fmt.Errorf("%w: project notes JSON is invalid (%v)", ErrInvalidInput, err)
	}
	if parsed.GridConnectionCenter == nil {
		return nil, fmt.Errorf("%w: project notes missing grid_connection_center", ErrInvalidInput)
	}

	return parsed.GridConnectionCenter, nil
}

func withinTolerance(a, b, tolerance float64) bool {
	return math.Abs(a-b) <= tolerance
}

type constraintZonePayload struct {
	ZoneType        string `json:"zone_type"`
	BoundaryGeoJSON string `json:"boundary_geojson"`
	SeverityLevel   int    `json:"severity_level"`
}

func (s *TransmissionService) fetchConstraintZoneFeatures(ctx context.Context, projectID uuid.UUID) ([]domain.VectorFeature, error) {
	if projectID == uuid.Nil || s.projectURL == "" {
		return nil, nil
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, fmt.Sprintf("%s/api/v1/projects/%s/zones", s.projectURL, projectID.String()), nil)
	if err != nil {
		return nil, err
	}

	resp, err := s.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, nil
	}
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("constraint zone fetch failed with status %d", resp.StatusCode)
	}

	var payload constraintZonesResponse
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil, err
	}

	features := make([]domain.VectorFeature, 0, len(payload.Zones))
	for _, zone := range payload.Zones {
		if strings.TrimSpace(zone.BoundaryGeoJSON) == "" {
			continue
		}
		features = append(features, mapConstraintZoneToFeature(zone))
	}

	return features, nil
}

func mapConstraintZoneToFeature(zone constraintZonePayload) domain.VectorFeature {
	zoneType := strings.ToLower(strings.TrimSpace(zone.ZoneType))
	if zoneType == "wetland" || zoneType == "exclusion" {
		return domain.VectorFeature{
			FeatureType:     "no_go",
			GeometryGeoJSON: zone.BoundaryGeoJSON,
			CostMultiplier:  math.Inf(1),
		}
	}

	severity := zone.SeverityLevel
	if severity < 1 {
		severity = 1
	}
	if severity > 5 {
		severity = 5
	}

	multiplier := 1.2 + float64(severity-1)*0.8
	featureType := "protected_area"
	if zoneType == "setback" {
		featureType = "urban"
		multiplier = 1.4
	}

	return domain.VectorFeature{
		FeatureType:     featureType,
		GeometryGeoJSON: zone.BoundaryGeoJSON,
		CostMultiplier:  multiplier,
	}
}

func validateRequest(req domain.CalculateTransmissionRouteRequest) error {
	if req.ProjectID == uuid.Nil {
		return fmt.Errorf("%w: project_id is required", ErrInvalidInput)
	}
	if req.ElevationRaster.Width <= 1 || req.ElevationRaster.Height <= 1 {
		return fmt.Errorf("%w: elevation raster must have width/height > 1", ErrInvalidInput)
	}
	if req.ElevationRaster.CellSizeM <= 0 {
		return fmt.Errorf("%w: elevation raster cell_size_m must be > 0", ErrInvalidInput)
	}
	if len(req.ElevationRaster.Elevations) != req.ElevationRaster.Width*req.ElevationRaster.Height {
		return fmt.Errorf("%w: elevation raster values do not match width*height", ErrInvalidInput)
	}
	return nil
}

type transmissionBridgeRequest struct {
	Dem          bridgeElevationGrid            `json:"dem"`
	CostGrid     []float64                      `json:"cost_grid"`
	Source       bridgeWaypoint                 `json:"source"`
	Destination  bridgeWaypoint                 `json:"destination"`
	VoltageClass string                         `json:"voltage_class"`
	Constraints  domain.TransmissionConstraints `json:"constraints"`
}

type bridgeElevationGrid struct {
	Width      int       `json:"width"`
	Height     int       `json:"height"`
	Resolution float64   `json:"resolution"`
	OriginX    float64   `json:"origin_x"`
	OriginY    float64   `json:"origin_y"`
	Data       []float64 `json:"data"`
}

type bridgeWaypoint struct {
	X         float64 `json:"x"`
	Y         float64 `json:"y"`
	Elevation float64 `json:"elevation"`
}

type bridgeTowerPosition struct {
	X         float64 `json:"x"`
	Y         float64 `json:"y"`
	Elevation float64 `json:"elevation"`
	SpanM     float64 `json:"span_m"`
}

type bridgeSegmentExplanation struct {
	FromIndex      int     `json:"from_index"`
	SlopeDeg       float64 `json:"slope_deg"`
	LandType       string  `json:"land_type"`
	CostMultiplier float64 `json:"cost_multiplier"`
	DecisionReason string  `json:"decision_reason"`
}

type transmissionBridgeResponse struct {
	Waypoints           []bridgeWaypoint           `json:"waypoints"`
	TowerPositions      []bridgeTowerPosition      `json:"tower_positions"`
	DistanceM           float64                    `json:"distance_m"`
	ConductorCost       float64                    `json:"conductor_cost"`
	TowerCost           float64                    `json:"tower_cost"`
	RowAcquisitionCost  float64                    `json:"row_acquisition_cost"`
	CrossingPremium     float64                    `json:"crossing_premium"`
	TotalCost           float64                    `json:"total_cost"`
	CostPerKm           float64                    `json:"cost_per_km"`
	SegmentExplanations []bridgeSegmentExplanation `json:"segment_explanations"`
	RouteSummary        string                     `json:"route_summary"`
}

func (s *TransmissionService) calculateViaBridge(ctx context.Context, req domain.CalculateTransmissionRouteRequest, constraints domain.TransmissionConstraints, costGrid [][]float64) (*domain.TransmissionRoute, error) {
	payload := transmissionBridgeRequest{
		Dem: bridgeElevationGrid{
			Width:      req.ElevationRaster.Width,
			Height:     req.ElevationRaster.Height,
			Resolution: req.ElevationRaster.CellSizeM,
			OriginX:    req.ElevationRaster.OriginLon,
			OriginY:    req.ElevationRaster.OriginLat,
			Data:       append([]float64(nil), req.ElevationRaster.Elevations...),
		},
		CostGrid:     flattenCostGrid(costGrid),
		Source:       bridgeWaypoint{X: req.FarmOutputPoint.Lon, Y: req.FarmOutputPoint.Lat, Elevation: req.FarmOutputPoint.Elevation},
		Destination:  bridgeWaypoint{X: req.GridInjectionPoint.Lon, Y: req.GridInjectionPoint.Lat, Elevation: req.GridInjectionPoint.Elevation},
		VoltageClass: string(req.VoltageClass),
		Constraints:  constraints,
	}
	body, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("marshal bridge request: %w", err)
	}
	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, s.bridgeURL+"/v1/terrain/transmission-path", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create bridge request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")
	resp, err := s.httpClient.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("call terrain bridge: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("terrain bridge returned status %d", resp.StatusCode)
	}
	var bridgeResp transmissionBridgeResponse
	if err := json.NewDecoder(resp.Body).Decode(&bridgeResp); err != nil {
		return nil, fmt.Errorf("decode bridge response: %w", err)
	}
	return bridgeResponseToRoute(bridgeResp, req.VoltageClass, constraints, req.ElevationRaster, costGrid, req.VectorFeatures), nil
}

func buildFallbackRoute(req domain.CalculateTransmissionRouteRequest, constraints domain.TransmissionConstraints, costGrid [][]float64) (*domain.TransmissionRoute, error) {
	waypoints, distanceM, err := calculateFallbackPath(req, constraints, costGrid, false)
	usedUndergroundFallback := false
	if err != nil {
		waypoints, distanceM, err = calculateFallbackPath(req, constraints, costGrid, true)
		if err != nil {
			relaxed := constraints
			relaxed.MaxSlopeDeg = 90
			relaxed.MaxDeflectionDeg = 180
			relaxed.TurnPenaltyFactor = 0.25
			waypoints, distanceM, err = calculateFallbackPath(req, relaxed, costGrid, true)
			if err != nil {
				return nil, err
			}
		}
		usedUndergroundFallback = true
	}
	waypoints = refineRouteWaypoints(waypoints, constraints)
	distanceM = calculatePathDistance(waypoints)

	fmt.Printf("[transmission] route: %d waypoints (after simplification), distance=%.0fm\n", len(waypoints), distanceM)
	if len(waypoints) >= 2 {
		fmt.Printf("[transmission] wp[0]=(%.6f, %.6f)  wp[last]=(%.6f, %.6f)\n",
			waypoints[0].Lat, waypoints[0].Lon,
			waypoints[len(waypoints)-1].Lat, waypoints[len(waypoints)-1].Lon)
	}

	towers := placeTowers(waypoints, constraints, req.VoltageClass, req.ElevationRaster, req.VectorFeatures)

	fmt.Printf("[transmission] towers: %d placed\n", len(towers))
	for i, t := range towers {
		if i < 3 || i == len(towers)-1 {
			fmt.Printf("[transmission]   tower[%d]: lat=%.6f lon=%.6f elev=%.1f height=%.1fm span=%.0fm\n",
				i, t.Lat, t.Lon, t.Elevation, t.HeightM, t.SpanToNextM)
		}
	}
	segments, crossingPremium := explainSegments(waypoints, costGrid, req.ElevationRaster, constraints)
	pathGeoJSON := waypointsToGeoJSON(waypoints)
	breakdown, uncertaintyPct := computeCostBreakdown(req.VoltageClass, waypoints, towers, constraints.RowWidthM, crossingPremium, segments)
	routeSummary := ""
	if usedUndergroundFallback {
		routeSummary = "Route required underground cable segments to traverse hard-blocked zones (e.g. lakes/buildings/forbidden areas)"
	}
	if uncertaintyPct > 0 {
		if routeSummary != "" {
			routeSummary += "; "
		}
		routeSummary += fmt.Sprintf("phase-3 cost model applied (uncertainty +/- %.1f%%)", uncertaintyPct*100)
	}
	if containsUndergroundSegments(segments) && !strings.Contains(strings.ToLower(routeSummary), "underground") {
		if routeSummary != "" {
			routeSummary += "; "
		}
		routeSummary += "hybrid route includes engineered underground cable sections"
	}
	return &domain.TransmissionRoute{
		VoltageClass:        req.VoltageClass,
		PathGeoJSON:         pathGeoJSON,
		TowerPositions:      towers,
		DistanceM:           distanceM,
		CostBreakdown:       breakdown,
		SegmentExplanations: segments,
		RouteSummary:        routeSummary,
	}, nil
}

func bridgeResponseToRoute(resp transmissionBridgeResponse, voltageClass domain.VoltageClass, constraints domain.TransmissionConstraints, raster domain.ElevationRaster, costGrid [][]float64, vectorFeatures []domain.VectorFeature) *domain.TransmissionRoute {
	waypoints := make([]domain.Waypoint, 0, len(resp.Waypoints))
	for _, waypoint := range resp.Waypoints {
		waypoints = append(waypoints, domain.Waypoint{Lon: waypoint.X, Lat: waypoint.Y, Elevation: waypoint.Elevation})
	}
	waypoints = refineRouteWaypoints(waypoints, constraints)
	towers := placeTowers(waypoints, constraints, voltageClass, raster, vectorFeatures)
	segments, crossingPremium := explainSegments(waypoints, costGrid, raster, constraints)
	breakdown, uncertaintyPct := computeCostBreakdown(voltageClass, waypoints, towers, constraints.RowWidthM, crossingPremium, segments)
	routeSummary := resp.RouteSummary
	if uncertaintyPct > 0 {
		if routeSummary != "" {
			routeSummary += "; "
		}
		routeSummary += fmt.Sprintf("phase-3 cost model applied (uncertainty +/- %.1f%%)", uncertaintyPct*100)
	}
	if containsUndergroundSegments(segments) && !strings.Contains(strings.ToLower(routeSummary), "underground") {
		if routeSummary != "" {
			routeSummary += "; "
		}
		routeSummary += "hybrid route includes engineered underground cable sections"
	}

	return &domain.TransmissionRoute{
		PathGeoJSON:         waypointsToGeoJSON(waypoints),
		TowerPositions:      towers,
		DistanceM:           calculatePathDistance(waypoints),
		CostBreakdown:       breakdown,
		SegmentExplanations: segments,
		RouteSummary:        routeSummary,
	}
}

func flattenCostGrid(grid [][]float64) []float64 {
	flat := make([]float64, 0, len(grid)*len(grid[0]))
	for _, row := range grid {
		flat = append(flat, row...)
	}
	return flat
}

// sendProgress emits a streaming progress update. Failures are logged but
// not returned: the routing job itself must not abort because the client's
// progress stream closed early (a normal pattern when the user navigates
// away from the streaming UI). Critical state lives in the persisted
// route record, not in the progress channel.
func sendProgress(emit func(domain.ProgressUpdate) error, update domain.ProgressUpdate) error {
	if emit == nil {
		return nil
	}
	if err := emit(update); err != nil {
		log.Printf("event=transmission.progress_emit_failed phase=%s pct=%d err=%v", update.Phase, update.PercentComplete, err)
		return err
	}
	return nil
}

func placeTowers(waypoints []domain.Waypoint, constraints domain.TransmissionConstraints, voltageClass domain.VoltageClass, raster domain.ElevationRaster, vectorFeatures []domain.VectorFeature) []domain.TowerPosition {
	if len(waypoints) == 0 {
		return nil
	}
	if len(waypoints) == 1 {
		return []domain.TowerPosition{{Lon: waypoints[0].Lon, Lat: waypoints[0].Lat, Elevation: waypoints[0].Elevation, HeightM: computePoleHeightM(voltageClass, constraints.MinSpanM, 0)}}
	}

	maxSpan := math.Max(constraints.MaxSpanM, constraints.MinSpanM)
	if maxSpan <= 0 {
		maxSpan = constraints.MinSpanM
	}
	if maxSpan <= 0 {
		maxSpan = 250
	}
	towerWaypoints := densifyWaypointsForTowerPlacement(waypoints, maxSpan, raster)
	targetSpan := math.Min(maxSpan*0.9, math.Max(constraints.MinSpanM, maxSpan*0.6))
	if targetSpan <= 0 {
		targetSpan = maxSpan * 0.75
	}

	cum := cumulativeDistances(towerWaypoints)
	indices := []int{0}
	lastIdx := 0
	for lastIdx < len(towerWaypoints)-1 {
		feasible := -1
		fallbackFeasible := -1
		for idx := lastIdx + 1; idx < len(towerWaypoints); idx++ {
			span := distBetween(cum, lastIdx, idx)
			if span > maxSpan {
				break
			}
			if !spanHasClearance(towerWaypoints[lastIdx], towerWaypoints[idx], span, voltageClass, raster) {
				continue
			}
			if fallbackFeasible == -1 {
				fallbackFeasible = idx
			}
			if span < constraints.MinSpanM && idx < len(towerWaypoints)-1 {
				continue
			}
			feasible = idx
			if span >= targetSpan {
				break
			}
		}

		if feasible == -1 {
			feasible = fallbackFeasible
		}

		if feasible == -1 {
			// Last-resort progress to avoid infinite loops on malformed or externally supplied geometry.
			feasible = minInt(lastIdx+1, len(towerWaypoints)-1)
		}

		indices = append(indices, feasible)
		lastIdx = feasible
	}
	requiredTurnIndices := mandatoryTurnTowerIndices(towerWaypoints, constraints)
	indices = mergeTowerIndices(indices, requiredTurnIndices)

	// Build final tower positions with engineered pole heights.
	towers := make([]domain.TowerPosition, 0, len(indices))
	for i, idx := range indices {
		spanToNext := 0.0
		slopeDeg := 0.0
		if i < len(indices)-1 {
			nextIdx := indices[i+1]
			spanToNext = distBetween(cum, idx, nextIdx)
			horizontal := horizontalDistance(towerWaypoints[idx], towerWaypoints[nextIdx])
			if horizontal > 0 {
				delta := math.Abs(towerWaypoints[nextIdx].Elevation - towerWaypoints[idx].Elevation)
				slopeDeg = math.Atan(delta/horizontal) * 180 / math.Pi
			}
		}
		towers = append(towers, domain.TowerPosition{
			Lon:         towerWaypoints[idx].Lon,
			Lat:         towerWaypoints[idx].Lat,
			Elevation:   towerWaypoints[idx].Elevation,
			SpanToNextM: spanToNext,
			HeightM:     computePoleHeightM(voltageClass, spanToNext, slopeDeg),
		})
	}

	// Keep overhead structures consistently on one side of the nearest road when road geometry is available.
	towers = offsetTowersToRoadSide(towers, vectorFeatures, 8.0)

	return towers
}

func mandatoryTurnTowerIndices(waypoints []domain.Waypoint, constraints domain.TransmissionConstraints) []int {
	if len(waypoints) < 3 {
		return nil
	}
	threshold := math.Max(5, math.Min(28, constraints.MaxDeflectionDeg*0.35))
	indices := make([]int, 0, len(waypoints)/4)
	for i := 1; i < len(waypoints)-1; i++ {
		turn := waypointDeflectionDeg(waypoints[i-1], waypoints[i], waypoints[i+1])
		if turn >= threshold {
			indices = append(indices, i)
		}
	}
	return indices
}

func mergeTowerIndices(base []int, required []int) []int {
	if len(required) == 0 {
		return base
	}
	seen := make(map[int]struct{}, len(base)+len(required))
	merged := make([]int, 0, len(base)+len(required))
	for _, idx := range base {
		if _, ok := seen[idx]; ok {
			continue
		}
		seen[idx] = struct{}{}
		merged = append(merged, idx)
	}
	for _, idx := range required {
		if _, ok := seen[idx]; ok {
			continue
		}
		seen[idx] = struct{}{}
		merged = append(merged, idx)
	}
	sort.Ints(merged)
	return merged
}

type geoLineSegment struct {
	A domain.Waypoint
	B domain.Waypoint
}

func offsetTowersToRoadSide(towers []domain.TowerPosition, vectorFeatures []domain.VectorFeature, offsetM float64) []domain.TowerPosition {
	if len(towers) < 2 || offsetM <= 0 {
		return towers
	}
	roadSegments := extractRoadLikeSegments(vectorFeatures)
	shifted := make([]domain.TowerPosition, len(towers))
	copy(shifted, towers)

	for i := range shifted {
		prev := towers[max(0, i-1)]
		next := towers[minInt(len(towers)-1, i+1)]
		if i == 0 {
			prev = towers[0]
			next = towers[1]
		}
		if i == len(towers)-1 {
			prev = towers[len(towers)-2]
			next = towers[len(towers)-1]
		}

		routeEast := (next.Lon - prev.Lon) * 111320.0 * math.Cos(towers[i].Lat*math.Pi/180.0)
		routeNorth := (next.Lat - prev.Lat) * 111320.0
		routeNorm := math.Sqrt(routeEast*routeEast + routeNorth*routeNorth)
		if routeNorm < 1e-6 {
			continue
		}

		dirEast := routeEast
		dirNorth := routeNorth
		if roadEast, roadNorth, ok := nearestRoadDirection(towers[i], roadSegments); ok {
			if roadEast*routeEast+roadNorth*routeNorth < 0 {
				roadEast = -roadEast
				roadNorth = -roadNorth
			}
			dirEast = roadEast
			dirNorth = roadNorth
		}

		dirNorm := math.Sqrt(dirEast*dirEast + dirNorth*dirNorth)
		if dirNorm < 1e-6 {
			continue
		}

		// Right-hand normal keeps all towers consistently on one side of alignment.
		offsetEast := (dirNorth / dirNorm) * offsetM
		offsetNorth := (-dirEast / dirNorm) * offsetM

		latDelta := offsetNorth / 111320.0
		lonScale := 111320.0 * math.Max(0.1, math.Cos(shifted[i].Lat*math.Pi/180.0))
		lonDelta := offsetEast / lonScale

		shifted[i].Lat += latDelta
		shifted[i].Lon += lonDelta
	}

	for i := 0; i < len(shifted)-1; i++ {
		a := domain.Waypoint{Lon: shifted[i].Lon, Lat: shifted[i].Lat, Elevation: shifted[i].Elevation}
		b := domain.Waypoint{Lon: shifted[i+1].Lon, Lat: shifted[i+1].Lat, Elevation: shifted[i+1].Elevation}
		shifted[i].SpanToNextM = segmentDistance(a, b)
	}
	shifted[len(shifted)-1].SpanToNextM = 0

	return shifted
}

func extractRoadLikeSegments(features []domain.VectorFeature) []geoLineSegment {
	segments := make([]geoLineSegment, 0)
	for _, feature := range features {
		if !isRoadLikeFeatureType(feature.FeatureType) {
			continue
		}
		segments = append(segments, parseLineSegmentsFromGeoJSON(feature.GeometryGeoJSON)...)
	}
	return segments
}

func isRoadLikeFeatureType(featureType string) bool {
	ft := strings.ToLower(strings.TrimSpace(featureType))
	switch ft {
	case "road", "roadway", "road_centerline", "road-centerline", "access_road", "service_road", "preferred_corridor", "corridor":
		return true
	default:
		return strings.Contains(ft, "road")
	}
}

func parseLineSegmentsFromGeoJSON(raw string) []geoLineSegment {
	var payload struct {
		Type        string          `json:"type"`
		Coordinates json.RawMessage `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(raw), &payload); err != nil {
		return nil
	}

	var lines [][][]float64
	switch strings.ToLower(payload.Type) {
	case "linestring":
		var coords [][]float64
		if err := json.Unmarshal(payload.Coordinates, &coords); err != nil {
			return nil
		}
		lines = append(lines, coords)
	case "multilinestring":
		if err := json.Unmarshal(payload.Coordinates, &lines); err != nil {
			return nil
		}
	case "polygon":
		var polygon [][][]float64
		if err := json.Unmarshal(payload.Coordinates, &polygon); err != nil || len(polygon) == 0 {
			return nil
		}
		lines = append(lines, polygon[0])
	case "multipolygon":
		var polygons [][][][]float64
		if err := json.Unmarshal(payload.Coordinates, &polygons); err != nil {
			return nil
		}
		for _, polygon := range polygons {
			if len(polygon) == 0 {
				continue
			}
			lines = append(lines, polygon[0])
		}
	default:
		return nil
	}

	segments := make([]geoLineSegment, 0)
	for _, line := range lines {
		for i := 1; i < len(line); i++ {
			a := line[i-1]
			b := line[i]
			if len(a) < 2 || len(b) < 2 {
				continue
			}
			segments = append(segments, geoLineSegment{
				A: domain.Waypoint{Lon: a[0], Lat: a[1]},
				B: domain.Waypoint{Lon: b[0], Lat: b[1]},
			})
		}
	}
	return segments
}

func nearestRoadDirection(tower domain.TowerPosition, segments []geoLineSegment) (east float64, north float64, ok bool) {
	if len(segments) == 0 {
		return 0, 0, false
	}
	bestDist := math.Inf(1)
	for _, segment := range segments {
		d := pointToSegmentDistanceMeters(tower.Lon, tower.Lat, segment)
		if d < bestDist {
			bestDist = d
			east = (segment.B.Lon - segment.A.Lon) * 111320.0 * math.Cos(tower.Lat*math.Pi/180.0)
			north = (segment.B.Lat - segment.A.Lat) * 111320.0
		}
	}
	if !math.IsInf(bestDist, 1) && bestDist <= 60 {
		return east, north, true
	}
	return 0, 0, false
}

func pointToSegmentDistanceMeters(lon, lat float64, segment geoLineSegment) float64 {
	lonScale := 111320.0 * math.Max(0.1, math.Cos(lat*math.Pi/180.0))
	ax := (segment.A.Lon - lon) * lonScale
	ay := (segment.A.Lat - lat) * 111320.0
	bx := (segment.B.Lon - lon) * lonScale
	by := (segment.B.Lat - lat) * 111320.0
	vx := bx - ax
	vy := by - ay
	vLen2 := vx*vx + vy*vy
	if vLen2 < 1e-9 {
		return math.Sqrt(ax*ax + ay*ay)
	}
	t := -(ax*vx + ay*vy) / vLen2
	if t < 0 {
		t = 0
	}
	if t > 1 {
		t = 1
	}
	px := ax + vx*t
	py := ay + vy*t
	return math.Sqrt(px*px + py*py)
}

func densifyWaypointsForTowerPlacement(waypoints []domain.Waypoint, maxSpan float64, raster domain.ElevationRaster) []domain.Waypoint {
	if len(waypoints) < 2 || maxSpan <= 0 {
		return waypoints
	}
	densified := make([]domain.Waypoint, 0, len(waypoints))
	densified = append(densified, waypoints[0])
	for index := 1; index < len(waypoints); index++ {
		start := waypoints[index-1]
		end := waypoints[index]
		segmentLength := segmentDistance(start, end)
		steps := int(math.Ceil(segmentLength / maxSpan))
		if steps < 1 {
			steps = 1
		}
		for step := 1; step < steps; step++ {
			t := float64(step) / float64(steps)
			lon := start.Lon + (end.Lon-start.Lon)*t
			lat := start.Lat + (end.Lat-start.Lat)*t
			densified = append(densified, domain.Waypoint{
				Lon:       lon,
				Lat:       lat,
				Elevation: sampleElevationAtRaster(raster, lon, lat),
			})
		}
		densified = append(densified, end)
	}
	return densified
}

func refineRouteWaypoints(waypoints []domain.Waypoint, constraints domain.TransmissionConstraints) []domain.Waypoint {
	if len(waypoints) < 3 {
		return waypoints
	}

	// Phase 1: Line-of-sight simplification.
	// Walk the path forwards; from the current anchor, find the furthest
	// waypoint that can be reached in a straight line without deviating
	// more than one grid cell (≈ a few hundred meters) from the intermediate
	// path. This removes the A* staircase while preserving real turns.
	simplified := lineOfSightSimplify(waypoints)

	// Phase 2: Remove subtle inflection points (< threshold angle) that
	// don't represent meaningful turns.
	angleThreshold := math.Max(3, math.Min(18, constraints.MaxDeflectionDeg*0.2))
	out := make([]domain.Waypoint, 0, len(simplified))
	out = append(out, simplified[0])
	for i := 1; i < len(simplified)-1; i++ {
		prev := out[len(out)-1]
		cur := simplified[i]
		next := simplified[i+1]
		turn := waypointDeflectionDeg(prev, cur, next)
		if turn < angleThreshold {
			continue
		}
		out = append(out, cur)
	}
	out = append(out, simplified[len(simplified)-1])
	return out
}

// lineOfSightSimplify removes staircase artifacts from grid-based pathfinding.
// From the current anchor, it looks ahead as far as possible.  When the straight
// line from anchor to a candidate skips too far from the actual path in between,
// the last good candidate becomes the next anchor and the process repeats.
func lineOfSightSimplify(waypoints []domain.Waypoint) []domain.Waypoint {
	if len(waypoints) < 3 {
		return waypoints
	}

	// Maximum perpendicular deviation (meters) before inserting a new anchor.
	const maxDeviationM = 150.0

	result := make([]domain.Waypoint, 0, len(waypoints)/2)
	result = append(result, waypoints[0])
	anchor := 0

	for anchor < len(waypoints)-1 {
		best := anchor + 1
		for candidate := anchor + 2; candidate < len(waypoints); candidate++ {
			if maxPerpendicularDeviation(waypoints, anchor, candidate) <= maxDeviationM {
				best = candidate
			} else {
				break
			}
		}
		result = append(result, waypoints[best])
		anchor = best
	}
	return result
}

// maxPerpendicularDeviation returns the maximum perpendicular distance (meters)
// of any intermediate waypoint from the straight line between waypoints[from]
// and waypoints[to].
func maxPerpendicularDeviation(waypoints []domain.Waypoint, from, to int) float64 {
	a := waypoints[from]
	b := waypoints[to]
	abLon := b.Lon - a.Lon
	abLat := b.Lat - a.Lat
	abLen2 := abLon*abLon + abLat*abLat
	if abLen2 < 1e-18 {
		return 0
	}

	lonScale := 111320.0 * math.Max(0.1, math.Cos(a.Lat*math.Pi/180.0))
	maxDev := 0.0
	for i := from + 1; i < to; i++ {
		p := waypoints[i]
		apLon := p.Lon - a.Lon
		apLat := p.Lat - a.Lat
		t := (apLon*abLon + apLat*abLat) / abLen2
		if t < 0 {
			t = 0
		}
		if t > 1 {
			t = 1
		}
		projLon := a.Lon + t*abLon
		projLat := a.Lat + t*abLat
		dLon := (p.Lon - projLon) * lonScale
		dLat := (p.Lat - projLat) * 111320.0
		dev := math.Sqrt(dLon*dLon + dLat*dLat)
		if dev > maxDev {
			maxDev = dev
		}
	}
	return maxDev
}

func waypointDeflectionDeg(prev, current, next domain.Waypoint) float64 {
	v1x := current.Lon - prev.Lon
	v1y := current.Lat - prev.Lat
	v2x := next.Lon - current.Lon
	v2y := next.Lat - current.Lat
	mag1 := math.Sqrt(v1x*v1x + v1y*v1y)
	mag2 := math.Sqrt(v2x*v2x + v2y*v2y)
	if mag1 == 0 || mag2 == 0 {
		return 0
	}
	cosTheta := (v1x*v2x + v1y*v2y) / (mag1 * mag2)
	if cosTheta > 1 {
		cosTheta = 1
	}
	if cosTheta < -1 {
		cosTheta = -1
	}
	return math.Acos(cosTheta) * 180 / math.Pi
}

func cumulativeDistances(waypoints []domain.Waypoint) []float64 {
	cum := make([]float64, len(waypoints))
	for i := 1; i < len(waypoints); i++ {
		cum[i] = cum[i-1] + segmentDistance(waypoints[i-1], waypoints[i])
	}
	return cum
}

func distBetween(cum []float64, fromIdx, toIdx int) float64 {
	if fromIdx < 0 || toIdx >= len(cum) || toIdx < fromIdx {
		return 0
	}
	return cum[toIdx] - cum[fromIdx]
}

func estimateSagMeters(voltageClass domain.VoltageClass, spanM float64) float64 {
	baseFactor := 0.012
	switch voltageClass {
	case domain.VoltageClass220kV:
		baseFactor = 0.015
	case domain.VoltageClass400kV:
		baseFactor = 0.018
	}
	return math.Max(1.5, spanM*baseFactor)
}

func spanHasClearance(start, end domain.Waypoint, spanM float64, voltageClass domain.VoltageClass, raster domain.ElevationRaster) bool {
	if spanM <= 0 {
		return true
	}
	requiredClearance := baseGroundClearanceM(voltageClass)
	slopeDeg := 0.0
	horizontal := horizontalDistance(start, end)
	if horizontal > 0 {
		delta := math.Abs(end.Elevation - start.Elevation)
		slopeDeg = math.Atan(delta/horizontal) * 180 / math.Pi
	}
	startTop := start.Elevation + computePoleHeightM(voltageClass, spanM, slopeDeg)
	endTop := end.Elevation + computePoleHeightM(voltageClass, spanM, slopeDeg)
	sagMax := estimateSagMeters(voltageClass, spanM)

	samples := max(5, int(spanM/50))
	for i := 1; i < samples; i++ {
		t := float64(i) / float64(samples)
		lon := start.Lon + (end.Lon-start.Lon)*t
		lat := start.Lat + (end.Lat-start.Lat)*t
		terrain := sampleElevationAtRaster(raster, lon, lat)
		lineTop := startTop + (endTop-startTop)*t
		sag := 4 * sagMax * t * (1 - t)
		conductorHeight := lineTop - sag
		if conductorHeight-terrain < requiredClearance {
			return false
		}
	}
	return true
}

func sampleElevationAtRaster(raster domain.ElevationRaster, lon, lat float64) float64 {
	if raster.Width <= 0 || raster.Height <= 0 || len(raster.Elevations) == 0 {
		return 0
	}
	node := clampToGrid(raster, waypointToGrid(raster, domain.Waypoint{Lon: lon, Lat: lat}))
	idx := node.Row*raster.Width + node.Col
	if idx < 0 || idx >= len(raster.Elevations) {
		return 0
	}
	return raster.Elevations[idx]
}

func minInt(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func baseGroundClearanceM(voltageClass domain.VoltageClass) float64 {
	switch voltageClass {
	case domain.VoltageClass11kV:
		return 6.0
	case domain.VoltageClass33kV:
		return 7.0
	case domain.VoltageClass66kV:
		return 8.0
	case domain.VoltageClass132kV:
		return 9.0
	case domain.VoltageClass220kV:
		return 10.0
	case domain.VoltageClass400kV:
		return 12.0
	default:
		return 8.0
	}
}

func computePoleHeightM(voltageClass domain.VoltageClass, spanM, slopeDeg float64) float64 {
	clearance := baseGroundClearanceM(voltageClass)
	// Tower height does not grow one-to-one with span sag; keep conservative growth.
	sagAllowance := math.Max(2.0, spanM*0.007)
	terrainAllowance := math.Max(0, slopeDeg*0.12)
	structureAllowance := 3.5
	minByClass := math.Max(12, clearance+4)
	height := clearance + sagAllowance + terrainAllowance + structureAllowance
	if height < minByClass {
		height = minByClass
	}
	return height
}

func explainSegments(waypoints []domain.Waypoint, costGrid [][]float64, raster domain.ElevationRaster, constraints domain.TransmissionConstraints) ([]domain.SegmentExplanation, float64) {
	segments := make([]domain.SegmentExplanation, 0, max(len(waypoints)-1, 0))
	crossingPremium := 0.0
	for index := 1; index < len(waypoints); index++ {
		distance := segmentDistance(waypoints[index-1], waypoints[index])
		horizontal := horizontalDistance(waypoints[index-1], waypoints[index])
		delta := math.Abs(waypoints[index].Elevation - waypoints[index-1].Elevation)
		slopeDeg := 0.0
		if horizontal > 0 {
			slopeDeg = math.Atan(delta/horizontal) * 180 / math.Pi
		}
		row, col := waypointToGrid(raster, waypoints[index]).Row, waypointToGrid(raster, waypoints[index]).Col
		row = clampInt(row, 0, raster.Height-1)
		col = clampInt(col, 0, raster.Width-1)
		costMultiplier := costGrid[row][col]
		landType := "overhead"
		installationMode := domain.InstallationModeOverhead
		reason := "overhead segment selected by minimum integrated terrain and ROW cost"
		if math.IsInf(costMultiplier, 1) {
			landType = "underground_cable"
			installationMode = domain.InstallationModeUnderground
			costMultiplier = undergroundCableCostMultiplier
			reason = "overhead alignment blocked; controlled underground cable segment selected"
			crossingPremium += distance * (costMultiplier - 1.0)
		} else if isUndergroundRequiredCost(costMultiplier) {
			landType = "underground_required_cable"
			installationMode = domain.InstallationModeUnderground
			costMultiplier = undergroundCableCostMultiplier
			reason = "underground-only corridor enforced by corridor policy or surface constraints"
			crossingPremium += distance * (costMultiplier - 1.0)
		} else if costMultiplier >= constraints.WaterCrossingCostMult {
			landType = "water_crossing_overhead"
			reason = "overhead water crossing selected because detour cost exceeded crossing premium"
			crossingPremium += distance * (costMultiplier - 1.0)
		} else if costMultiplier < 1.0 {
			landType = "road_corridor_overhead"
			reason = "overhead segment follows road corridor to reduce land acquisition cost"
		} else if costMultiplier > 1.5 {
			landType = "sensitive_land_overhead"
			reason = "overhead segment crosses higher-cost land only where alternatives were longer or steeper"
		}
		segments = append(segments, domain.SegmentExplanation{FromIndex: index - 1, SlopeDeg: slopeDeg, LandType: landType, CostMultiplier: costMultiplier, DecisionReason: reason, InstallationMode: installationMode})
	}
	return segments, crossingPremium
}

func containsUndergroundSegments(segments []domain.SegmentExplanation) bool {
	for _, segment := range segments {
		if segment.InstallationMode == domain.InstallationModeUnderground || strings.Contains(strings.ToLower(segment.LandType), "underground") {
			return true
		}
	}
	return false
}

func waypointsToGeoJSON(waypoints []domain.Waypoint) string {
	coordinates := make([][]float64, 0, len(waypoints))
	for _, waypoint := range waypoints {
		coordinates = append(coordinates, []float64{waypoint.Lon, waypoint.Lat, waypoint.Elevation})
	}
	payload, _ := json.Marshal(map[string]interface{}{"type": "LineString", "coordinates": coordinates})
	return string(payload)
}

func segmentDistance(a, b domain.Waypoint) float64 {
	dx := (b.Lon - a.Lon) * 111320.0 * math.Cos(a.Lat*math.Pi/180.0)
	dy := (b.Lat - a.Lat) * 111320.0
	dz := b.Elevation - a.Elevation
	return math.Sqrt(dx*dx + dy*dy + dz*dz)
}

func horizontalDistance(a, b domain.Waypoint) float64 {
	dx := (b.Lon - a.Lon) * 111320.0 * math.Cos(a.Lat*math.Pi/180.0)
	dy := (b.Lat - a.Lat) * 111320.0
	return math.Sqrt(dx*dx + dy*dy)
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
