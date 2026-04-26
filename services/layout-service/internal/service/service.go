package service

import (
	"context"
	"encoding/json"
	"fmt"
	"math"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"p9e.in/samavaya/solar3d/layout-service/internal/config"
	"p9e.in/samavaya/solar3d/layout-service/internal/domain"
	"p9e.in/samavaya/solar3d/layout-service/internal/repository"
)

// Service contains core business logic for the layout domain.
type Service struct {
	repo *repository.Repository
	cfg  *config.Config
}

// New creates a new layout Service.
func New(repo *repository.Repository, cfg *config.Config) *Service {
	return &Service{repo: repo, cfg: cfg}
}

// ---------------------------------------------------------------------------
// Layout CRUD
// ---------------------------------------------------------------------------

// CreateLayout creates a new layout for a project.
func (s *Service) CreateLayout(ctx context.Context, projectID uuid.UUID, name string) (*domain.Layout, error) {
	layout := &domain.Layout{
		ProjectID: projectID,
		Name:      name,
	}
	if err := s.repo.CreateLayout(ctx, layout); err != nil {
		return nil, fmt.Errorf("service create layout: %w", err)
	}
	log.Info().Str("layout_id", layout.ID.String()).Str("name", name).Msg("layout created")
	return layout, nil
}

// GetLayout retrieves a layout by ID.
func (s *Service) GetLayout(ctx context.Context, id uuid.UUID) (*domain.Layout, error) {
	return s.repo.GetLayout(ctx, id)
}

// ListLayouts returns all layouts for a project.
func (s *Service) ListLayouts(ctx context.Context, projectID uuid.UUID) ([]*domain.Layout, error) {
	return s.repo.ListLayoutsByProject(ctx, projectID)
}

// UpdateLayout updates a layout's mutable fields.
func (s *Service) UpdateLayout(ctx context.Context, layout *domain.Layout) error {
	return s.repo.UpdateLayout(ctx, layout)
}

// DeleteLayout removes a layout and all its children.
func (s *Service) DeleteLayout(ctx context.Context, id uuid.UUID) error {
	return s.repo.DeleteLayout(ctx, id)
}

// ---------------------------------------------------------------------------
// Component placement
// ---------------------------------------------------------------------------

// PlaceComponent adds a component to a layout at the given position.
func (s *Service) PlaceComponent(ctx context.Context, c *domain.Component) error {
	if c.LayoutID == uuid.Nil {
		return fmt.Errorf("component requires a layout_id")
	}
	if c.ComponentType == "" {
		return fmt.Errorf("component requires a component_type")
	}

	if err := s.repo.CreateComponent(ctx, c); err != nil {
		return fmt.Errorf("service place component: %w", err)
	}
	log.Info().
		Str("component_id", c.ID.String()).
		Str("type", string(c.ComponentType)).
		Msg("component placed")
	return nil
}

// GetComponent retrieves a component by ID.
func (s *Service) GetComponent(ctx context.Context, id uuid.UUID) (*domain.Component, error) {
	return s.repo.GetComponent(ctx, id)
}

// ListComponents returns all components for a layout.
func (s *Service) ListComponents(ctx context.Context, layoutID uuid.UUID) ([]*domain.Component, error) {
	return s.repo.ListComponentsByLayout(ctx, layoutID)
}

// MoveComponent updates a component position and rotation.
func (s *Service) MoveComponent(ctx context.Context, id uuid.UUID, position domain.Position, rotation domain.Position) (*domain.Component, error) {
	if id == uuid.Nil {
		return nil, fmt.Errorf("component requires an id")
	}

	if err := s.repo.MoveComponent(ctx, id, position, rotation); err != nil {
		return nil, fmt.Errorf("service move component: %w", err)
	}

	component, err := s.repo.GetComponent(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("service move component load: %w", err)
	}

	log.Info().
		Str("component_id", id.String()).
		Float64("x", position.X).
		Float64("y", position.Y).
		Msg("component moved")

	return component, nil
}

// DeleteComponent removes a component.
func (s *Service) DeleteComponent(ctx context.Context, id uuid.UUID) error {
	return s.repo.DeleteComponent(ctx, id)
}

// ---------------------------------------------------------------------------
// Panel array generation
// ---------------------------------------------------------------------------

// GeneratePanelArray is the key algorithm that:
//  1. Takes PanelArrayParams (panel dimensions, tilt, fill polygon, etc.)
//  2. Computes row spacing from tilt angle if not explicitly provided
//  3. Generates a grid of panels filling the polygon area
//  4. Partitions panels into spatial tiles based on configurable tile size
//  5. Bulk inserts tiles and panels
//  6. Updates the layout with totals
//
// This handles 100k-500k panel arrays for utility-scale solar farms.
func (s *Service) GeneratePanelArray(ctx context.Context, layoutID uuid.UUID, params domain.PanelArrayParams) (*domain.PanelArrayResult, error) {
	logger := log.With().Str("layout_id", layoutID.String()).Logger()

	// Validate layout exists.
	layout, err := s.repo.GetLayout(ctx, layoutID)
	if err != nil {
		return nil, fmt.Errorf("layout not found: %w", err)
	}

	logger.Info().
		Float64("panel_w", params.PanelWidth).
		Float64("panel_h", params.PanelHeight).
		Float64("tilt", params.TiltAngle).
		Msg("generating panel array")

	// By default generation replaces layout panels.
	// Multi-area generation opts in to append mode via a UUID sentinel in
	// terrain_layer_id (keeps API/proto compatibility without new fields).
	appendModeSentinel := uuid.MustParse("00000000-0000-0000-0000-00000000a11e")
	appendMode := params.TerrainLayerID != nil && *params.TerrainLayerID == appendModeSentinel
	if !appendMode {
		if err := s.repo.DeleteTilesByLayout(ctx, layoutID); err != nil {
			return nil, fmt.Errorf("clear existing tiles: %w", err)
		}
	}

	// Generate the array: panels + tile assignments.
	gen := &ArrayGenerator{TileSize: s.cfg.TileSize, MaxPanels: s.cfg.MaxPanels}
	tiles, panels, err := gen.GenerateArray(params, layoutID)
	if err != nil {
		return nil, fmt.Errorf("array generation: %w", err)
	}

	totalPanels := int64(len(panels))
	// Prefer selected module rating when provided by the client; otherwise
	// fall back to a stable utility-scale default.
	perPanelKW := 0.55
	if params.PanelRatedPowerW > 0 {
		perPanelKW = params.PanelRatedPowerW / 1000.0
	}
	totalCapacity := float64(totalPanels) * perPanelKW

	logger.Info().
		Int64("total_panels", totalPanels).
		Float64("total_capacity_kw", totalCapacity).
		Int("tile_count", len(tiles)).
		Msg("array generated, persisting")

	// Bulk insert tiles. Tile IDs are pre-assigned by the generator so that
	// panels can reference them before insertion; BulkInsertTiles preserves
	// existing IDs and only generates one if a tile somehow arrives with uuid.Nil.
	if err := s.repo.BulkInsertTiles(ctx, tiles); err != nil {
		return nil, fmt.Errorf("persist tiles: %w", err)
	}

	// Bulk insert panels. Panel TileIDs already match the inserted tile IDs.
	if err := s.repo.BulkInsertPanels(ctx, panels); err != nil {
		return nil, fmt.Errorf("persist panels: %w", err)
	}

	// Update layout totals.
	layout.TotalPanels = totalPanels
	layout.TotalCapacityKW = totalCapacity
	layout.TileCount = len(tiles)
	if err := s.repo.UpdateLayout(ctx, layout); err != nil {
		return nil, fmt.Errorf("update layout totals: %w", err)
	}

	logger.Info().Msg("panel array generation complete")

	return &domain.PanelArrayResult{
		LayoutID:        layoutID,
		TotalPanels:     totalPanels,
		TotalCapacityKW: totalCapacity,
		TileCount:       len(tiles),
	}, nil
}

// ---------------------------------------------------------------------------
// Spatial queries
// ---------------------------------------------------------------------------

// GetTiles returns tiles for a layout that intersect the given viewport.
func (s *Service) GetTiles(ctx context.Context, layoutID uuid.UUID, vq domain.ViewportQuery) ([]*domain.LayoutTile, error) {
	return s.repo.GetTilesByViewport(ctx, layoutID, vq)
}

// GetPanelsByTile returns all panels belonging to a specific tile.
func (s *Service) GetPanelsByTile(ctx context.Context, tileID uuid.UUID) ([]*domain.Panel, error) {
	return s.repo.GetPanelsByTile(ctx, tileID)
}

// PlanInfrastructureZones computes area allocations and map geometries for
// panel fields and balance-of-plant zones based on capacity and boundary shape.
func (s *Service) PlanInfrastructureZones(ctx context.Context, layoutID uuid.UUID, req domain.ZonePlanRequest) (*domain.ZonePlanResult, error) {
	if req.TargetCapacityMW <= 0 {
		return nil, fmt.Errorf("target_capacity_mw must be positive")
	}
	if len(req.BoundaryGeoJSON) == 0 {
		return nil, fmt.Errorf("boundary_geojson is required")
	}

	if _, err := s.repo.GetLayout(ctx, layoutID); err != nil {
		return nil, fmt.Errorf("layout not found: %w", err)
	}

	ring, err := parsePolygonRing(req.BoundaryGeoJSON)
	if err != nil {
		return nil, fmt.Errorf("invalid boundary polygon: %w", err)
	}

	areaSqm := polygonAreaSqm(ring)
	if areaSqm <= 0 {
		return nil, fmt.Errorf("boundary area must be greater than zero")
	}

	// Utility-scale assumptions, tuned to keep allocation realistic while stable.
	const panelMwPerHa = 0.90
	const dcAcRatio = 1.25

	panelTargetArea := req.TargetCapacityMW / panelMwPerHa * 10000.0
	if panelTargetArea > areaSqm*0.82 {
		panelTargetArea = areaSqm * 0.82
	}
	if panelTargetArea < areaSqm*0.45 {
		panelTargetArea = areaSqm * 0.45
	}

	zoneTargets := map[string]float64{
		"panel":       panelTargetArea,
		"inverter":    math.Max(areaSqm*0.025, req.TargetCapacityMW*220),
		"transformer": math.Max(areaSqm*0.012, req.TargetCapacityMW*95),
		"roadway":     areaSqm * 0.08,
		"drainage":    areaSqm * 0.07,
		"electrical":  areaSqm * 0.04,
	}

	totalAssigned := 0.0
	for _, v := range zoneTargets {
		totalAssigned += v
	}
	if totalAssigned > areaSqm {
		scale := areaSqm / totalAssigned
		for k, v := range zoneTargets {
			zoneTargets[k] = v * scale
		}
	}

	local := buildLocalTransform(ring)
	localRing := make([][2]float64, 0, len(ring))
	for _, p := range ring {
		x, y := local.toXY(p[0], p[1])
		localRing = append(localRing, [2]float64{x, y})
	}

	bbox := ringBoundsLocal(localRing)
	anchors := map[string][2]float64{
		"inverter":    {bbox.MinX + 0.20*bbox.Width(), bbox.MinY + 0.18*bbox.Height()},
		"transformer": {bbox.MinX + 0.78*bbox.Width(), bbox.MinY + 0.20*bbox.Height()},
		"roadway":     {bbox.MinX + 0.50*bbox.Width(), bbox.MinY + 0.08*bbox.Height()},
		"drainage":    {bbox.MinX + 0.50*bbox.Width(), bbox.MinY + 0.87*bbox.Height()},
		"electrical":  {bbox.MinX + 0.80*bbox.Width(), bbox.MinY + 0.82*bbox.Height()},
	}

	zones := make([]domain.ZoneAllocation, 0, 6)

	// Panels use the full boundary as primary planning envelope.
	zones = append(zones, domain.ZoneAllocation{
		ZoneType:          "panel",
		TargetAreaSqm:     zoneTargets["panel"],
		PlannedAreaSqm:    areaSqm,
		CoveragePercent:   100,
		GeometryGeoJSON:   string(req.BoundaryGeoJSON),
		DesignDescription: "Primary panel envelope. Internal exclusion zones are reserved for BOS infrastructure.",
	})

	for _, zoneType := range []string{"inverter", "transformer", "roadway", "drainage", "electrical"} {
		target := zoneTargets[zoneType]
		rect := fitContainedRectangle(localRing, anchors[zoneType], target, zoneAspectRatio(zoneType))
		geojson := rectangleToGeoJSON(rect, local)
		coverage := 0.0
		if target > 0 {
			coverage = (rect.Area / target) * 100
		}
		if coverage > 100 {
			coverage = 100
		}

		zones = append(zones, domain.ZoneAllocation{
			ZoneType:          zoneType,
			TargetAreaSqm:     target,
			PlannedAreaSqm:    rect.Area,
			CoveragePercent:   coverage,
			GeometryGeoJSON:   geojson,
			DesignDescription: zoneDesignDescription(zoneType),
		})
	}

	result := &domain.ZonePlanResult{
		LayoutID:         layoutID,
		BoundaryAreaSqm:  areaSqm,
		TargetCapacityMW: req.TargetCapacityMW,
		EstimatedDcMw:    req.TargetCapacityMW,
		RecommendedAcMw:  req.TargetCapacityMW / dcAcRatio,
		Zones:            zones,
		Assumptions: []string{
			"Panel power density set to 0.90 MW per hectare for utility-scale fixed-tilt planning.",
			"DC/AC ratio set to 1.25 for inverter and transformer sizing guidance.",
			"Balance-of-plant zones are generated as contained rectangles for fast constructability planning.",
		},
	}

	return result, nil
}

type localTransform struct {
	originLon float64
	originLat float64
	mPerDegX  float64
	mPerDegY  float64
}

func buildLocalTransform(ring [][2]float64) localTransform {
	lat := 0.0
	for _, p := range ring {
		lat += p[1]
	}
	if len(ring) > 0 {
		lat /= float64(len(ring))
	}
	return localTransform{
		originLon: ring[0][0],
		originLat: lat,
		mPerDegX:  111320.0 * math.Max(0.1, math.Cos(lat*math.Pi/180.0)),
		mPerDegY:  111320.0,
	}
}

func (t localTransform) toXY(lon, lat float64) (float64, float64) {
	return (lon - t.originLon) * t.mPerDegX, (lat - t.originLat) * t.mPerDegY
}

func (t localTransform) toLonLat(x, y float64) (float64, float64) {
	return t.originLon + x/t.mPerDegX, t.originLat + y/t.mPerDegY
}

type localBounds struct {
	MinX float64
	MinY float64
	MaxX float64
	MaxY float64
}

func (b localBounds) Width() float64 {
	return b.MaxX - b.MinX
}

func (b localBounds) Height() float64 {
	return b.MaxY - b.MinY
}

func ringBoundsLocal(ring [][2]float64) localBounds {
	b := localBounds{MinX: math.MaxFloat64, MinY: math.MaxFloat64, MaxX: -math.MaxFloat64, MaxY: -math.MaxFloat64}
	for _, p := range ring {
		if p[0] < b.MinX {
			b.MinX = p[0]
		}
		if p[0] > b.MaxX {
			b.MaxX = p[0]
		}
		if p[1] < b.MinY {
			b.MinY = p[1]
		}
		if p[1] > b.MaxY {
			b.MaxY = p[1]
		}
	}
	return b
}

type plannedRect struct {
	Corners [][2]float64
	Area    float64
}

func fitContainedRectangle(polygon [][2]float64, center [2]float64, targetAreaSqm, aspectRatio float64) plannedRect {
	if targetAreaSqm <= 0 {
		return plannedRect{Corners: rectangleCorners(center[0], center[1], 1, 1), Area: 1}
	}

	width := math.Sqrt(targetAreaSqm * aspectRatio)
	height := targetAreaSqm / math.Max(width, 1)
	if height <= 0 {
		height = 1
	}

	if !pointInPolygonLocal(center[0], center[1], polygon) {
		center = findNearestInteriorPoint(center, polygon)
	}

	for i := 0; i < 28; i++ {
		corners := rectangleCorners(center[0], center[1], width, height)
		if allCornersInside(corners, polygon) {
			return plannedRect{Corners: corners, Area: width * height}
		}
		width *= 0.92
		height *= 0.92
	}

	fallback := rectangleCorners(center[0], center[1], 8, 8)
	return plannedRect{Corners: fallback, Area: 64}
}

func rectangleCorners(cx, cy, w, h float64) [][2]float64 {
	hw := w / 2
	hh := h / 2
	return [][2]float64{
		{cx - hw, cy - hh},
		{cx + hw, cy - hh},
		{cx + hw, cy + hh},
		{cx - hw, cy + hh},
		{cx - hw, cy - hh},
	}
}

func allCornersInside(corners [][2]float64, polygon [][2]float64) bool {
	for _, c := range corners {
		if !pointInPolygonLocal(c[0], c[1], polygon) {
			return false
		}
	}
	return true
}

func findNearestInteriorPoint(seed [2]float64, polygon [][2]float64) [2]float64 {
	if pointInPolygonLocal(seed[0], seed[1], polygon) {
		return seed
	}
	step := 15.0
	for radius := step; radius <= 1200; radius += step {
		for a := 0.0; a < 2*math.Pi; a += math.Pi / 12 {
			x := seed[0] + radius*math.Cos(a)
			y := seed[1] + radius*math.Sin(a)
			if pointInPolygonLocal(x, y, polygon) {
				return [2]float64{x, y}
			}
		}
	}
	return polygon[0]
}

func pointInPolygonLocal(x, y float64, ring [][2]float64) bool {
	inside := false
	for i, j := 0, len(ring)-1; i < len(ring); j, i = i, i+1 {
		xi, yi := ring[i][0], ring[i][1]
		xj, yj := ring[j][0], ring[j][1]
		if ((yi > y) != (yj > y)) && (x < (xj-xi)*(y-yi)/(yj-yi+1e-12)+xi) {
			inside = !inside
		}
	}
	return inside
}

func rectangleToGeoJSON(rect plannedRect, transform localTransform) string {
	coords := make([][]float64, 0, len(rect.Corners))
	for _, c := range rect.Corners {
		lon, lat := transform.toLonLat(c[0], c[1])
		coords = append(coords, []float64{lon, lat})
	}
	polygon := map[string]any{
		"type":        "Polygon",
		"coordinates": []any{coords},
	}
	b, err := json.Marshal(polygon)
	if err != nil {
		return `{"type":"Polygon","coordinates":[]}`
	}
	return string(b)
}

func parsePolygonRing(geojson string) ([][2]float64, error) {
	var poly struct {
		Type        string        `json:"type"`
		Coordinates [][][]float64 `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(geojson), &poly); err != nil {
		return nil, err
	}
	if poly.Type != "Polygon" || len(poly.Coordinates) == 0 || len(poly.Coordinates[0]) < 4 {
		return nil, fmt.Errorf("polygon must contain a closed ring")
	}
	ring := make([][2]float64, 0, len(poly.Coordinates[0]))
	for _, c := range poly.Coordinates[0] {
		if len(c) < 2 {
			continue
		}
		ring = append(ring, [2]float64{c[0], c[1]})
	}
	if len(ring) < 4 {
		return nil, fmt.Errorf("polygon has insufficient coordinates")
	}
	return ring, nil
}

func polygonAreaSqm(ring [][2]float64) float64 {
	if len(ring) < 3 {
		return 0
	}
	lat := 0.0
	for _, p := range ring {
		lat += p[1]
	}
	lat /= float64(len(ring))
	mPerDegY := 111320.0
	mPerDegX := 111320.0 * math.Max(0.1, math.Cos(lat*math.Pi/180.0))
	sum := 0.0
	for i := 0; i < len(ring)-1; i++ {
		x1 := ring[i][0] * mPerDegX
		y1 := ring[i][1] * mPerDegY
		x2 := ring[i+1][0] * mPerDegX
		y2 := ring[i+1][1] * mPerDegY
		sum += x1*y2 - x2*y1
	}
	return math.Abs(sum) / 2.0
}

func zoneAspectRatio(zoneType string) float64 {
	switch zoneType {
	case "roadway":
		return 8.0
	case "drainage":
		return 5.5
	case "electrical":
		return 3.2
	case "transformer":
		return 1.5
	default:
		return 1.8
	}
}

func zoneDesignDescription(zoneType string) string {
	switch zoneType {
	case "inverter":
		return "Distributed inverter pads near panel blocks for short DC homeruns and maintainability."
	case "transformer":
		return "Main transformer yard with clearances for switchgear, fire access, and maintenance maneuvers."
	case "roadway":
		return "Primary internal access corridor for construction and O&M vehicles."
	case "drainage":
		return "Stormwater retention and drainage corridor reserved for runoff control and erosion mitigation."
	case "electrical":
		return "Electrical BOS corridor for MV collection, communications, and trenching separation."
	default:
		return "Planned infrastructure zone."
	}
}
