package service

import (
	"encoding/json"
	"fmt"
	"math"
	"sort"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/layout-service/internal/domain"
)

// ArrayGenerator produces panel arrays that fill a polygon with optimally
// spaced rows of solar panels. It handles the core spatial computation for
// utility-scale farms with 100k-500k panels.
type ArrayGenerator struct {
	// TileSize is the spatial tile edge length in meters.
	TileSize float64
}

// Point2D is a 2D coordinate in project-local space (meters).
type Point2D struct {
	X float64
	Y float64
}

// Polygon2D is a closed polygon defined by its vertices (CCW winding).
type Polygon2D struct {
	Exterior []Point2D
}

// GenerateArray is the main entry point. It:
//  1. Parses the fill area GeoJSON polygon
//  2. Computes row spacing from tilt if not provided
//  3. Creates a grid of panels filling the polygon
//  4. Partitions panels into spatial tiles
//  5. Returns tiles and panels ready for bulk insert
func (ag *ArrayGenerator) GenerateArray(params domain.PanelArrayParams, layoutID uuid.UUID) ([]*domain.LayoutTile, []*domain.Panel, error) {
	// Parse the fill polygon from GeoJSON.
	poly, err := parseGeoJSONPolygon(params.FillAreaGeoJSON)
	if err != nil {
		return nil, nil, fmt.Errorf("parse fill area: %w", err)
	}
	if len(poly.Exterior) < 3 {
		return nil, nil, fmt.Errorf("fill area polygon must have at least 3 vertices")
	}

	// Compute row spacing.
	rowSpacing := params.RowSpacing
	if rowSpacing <= 0 {
		rowSpacing = computeRowSpacing(params.PanelHeight, params.TiltAngle)
	}

	colSpacing := params.ColumnSpacing
	if colSpacing <= 0 {
		colSpacing = params.PanelWidth + 0.02 // 2cm default gap
	}

	log.Debug().
		Float64("row_spacing", rowSpacing).
		Float64("col_spacing", colSpacing).
		Msg("array spacing computed")

	// Generate panels within the polygon.
	panels := createPanelGrid(poly, params, rowSpacing, colSpacing)

	if len(panels) == 0 {
		return nil, nil, fmt.Errorf("no panels fit within the fill area")
	}

	log.Debug().Int("raw_panels", len(panels)).Msg("panel grid generated")

	// Partition into spatial tiles.
	tiles, panelsWithTiles := partitionIntoTiles(panels, layoutID, ag.TileSize)

	log.Info().
		Int("tiles", len(tiles)).
		Int("panels", len(panelsWithTiles)).
		Msg("spatial partitioning complete")

	return tiles, panelsWithTiles, nil
}

// computeRowSpacing calculates inter-row spacing to avoid shading.
// Uses the formula: spacing = panel_height * cos(tilt) + panel_height * sin(tilt) / tan(solar_elevation)
// We assume a worst-case solar elevation of ~25 degrees (winter solstice, mid-latitudes).
func computeRowSpacing(panelHeight, tiltAngleDeg float64) float64 {
	const worstCaseSolarElevationDeg = 25.0
	tiltRad := tiltAngleDeg * math.Pi / 180.0
	solarElevRad := worstCaseSolarElevationDeg * math.Pi / 180.0

	// The panel projects a shadow behind it. The row spacing must accommodate:
	// - The horizontal projection of the tilted panel: panelHeight * cos(tilt)
	// - The shadow length: panelHeight * sin(tilt) / tan(solar_elevation)
	horizontalProjection := panelHeight * math.Cos(tiltRad)
	shadowLength := panelHeight * math.Sin(tiltRad) / math.Tan(solarElevRad)

	spacing := horizontalProjection + shadowLength

	// Enforce a minimum spacing equal to the panel height.
	if spacing < panelHeight {
		spacing = panelHeight
	}

	return spacing
}

// createPanelGrid generates panel positions within the fill polygon.
// It creates rows along the azimuth direction, filling each row with panels
// that have their centroids inside the polygon.
func createPanelGrid(poly *Polygon2D, params domain.PanelArrayParams, rowSpacing, colSpacing float64) []*generatedPanel {
	// Compute the bounding box of the polygon.
	bbox := polygonBBox(poly)

	// Azimuth rotation: panels face the azimuth direction, rows are perpendicular.
	// Convert azimuth to radians. Azimuth 180 = south-facing (row axis runs E-W).
	azRad := params.Azimuth * math.Pi / 180.0

	// Row direction is perpendicular to the panel face direction.
	// Panel face direction = azimuth (compass bearing from north).
	// Row axis = azimuth + 90 degrees.
	rowDirX := math.Sin(azRad + math.Pi/2.0)
	rowDirY := math.Cos(azRad + math.Pi/2.0)

	// Column direction = azimuth direction (the direction panels face away from).
	colDirX := math.Sin(azRad)
	colDirY := math.Cos(azRad)

	// To iterate in a rotated coordinate system, we project the bounding box
	// corners onto the row/col axes to determine the sweep range.
	corners := []Point2D{
		{bbox.MinX, bbox.MinY},
		{bbox.MaxX, bbox.MinY},
		{bbox.MaxX, bbox.MaxY},
		{bbox.MinX, bbox.MaxY},
	}

	var minRow, maxRow, minCol, maxCol float64
	for i, c := range corners {
		// Project onto row and col axes.
		rowProj := c.X*rowDirX + c.Y*rowDirY
		colProj := c.X*colDirX + c.Y*colDirY
		if i == 0 {
			minRow, maxRow = rowProj, rowProj
			minCol, maxCol = colProj, colProj
		} else {
			if rowProj < minRow {
				minRow = rowProj
			}
			if rowProj > maxRow {
				maxRow = rowProj
			}
			if colProj < minCol {
				minCol = colProj
			}
			if colProj > maxCol {
				maxCol = colProj
			}
		}
	}

	var panels []*generatedPanel
	panelIdx := 0
	stringIdx := 0

	// Sweep along the column direction (row-by-row).
	for colPos := minCol; colPos <= maxCol; colPos += rowSpacing {
		stringIdx++
		panelsInString := 0

		// Sweep along the row direction (panel-by-panel within a row).
		for rowPos := minRow; rowPos <= maxRow; rowPos += colSpacing {
			// Convert back to world coordinates.
			cx := rowPos*rowDirX + colPos*colDirX
			cy := rowPos*rowDirY + colPos*colDirY

			// Check if the panel centroid is inside the polygon.
			if !pointInPolygon(Point2D{cx, cy}, poly) {
				continue
			}

			panelIdx++
			panelsInString++

			// Build the panel geometry as a GeoJSON Polygon (4 corners of the panel).
			geom := panelGeometry(cx, cy, params.PanelWidth, params.PanelHeight, azRad)

			panels = append(panels, &generatedPanel{
				CenterX:  cx,
				CenterY:  cy,
				StringID: fmt.Sprintf("S%04d-P%04d", stringIdx, panelsInString),
				Geometry: geom,
				Tilt:     params.TiltAngle,
				Azimuth:  params.Azimuth,
			})
		}
	}

	return panels
}

// generatedPanel is an intermediate representation before tile assignment.
type generatedPanel struct {
	CenterX  float64
	CenterY  float64
	StringID string
	Geometry json.RawMessage
	Tilt     float64
	Azimuth  float64
}

// partitionIntoTiles assigns panels to spatial tiles based on tile size.
// Tiles are axis-aligned squares covering the extent of all panels.
func partitionIntoTiles(panels []*generatedPanel, layoutID uuid.UUID, tileSize float64) ([]*domain.LayoutTile, []*domain.Panel) {
	if len(panels) == 0 {
		return nil, nil
	}

	// Find extent.
	minX, minY := panels[0].CenterX, panels[0].CenterY
	maxX, maxY := minX, minY
	for _, p := range panels {
		if p.CenterX < minX {
			minX = p.CenterX
		}
		if p.CenterX > maxX {
			maxX = p.CenterX
		}
		if p.CenterY < minY {
			minY = p.CenterY
		}
		if p.CenterY > maxY {
			maxY = p.CenterY
		}
	}

	// Snap origin to tile grid.
	originX := math.Floor(minX/tileSize) * tileSize
	originY := math.Floor(minY/tileSize) * tileSize

	nCols := int(math.Ceil((maxX-originX)/tileSize)) + 1
	nRows := int(math.Ceil((maxY-originY)/tileSize)) + 1

	// Map tile grid index -> list of panels.
	type tileKey struct{ col, row int }
	tilePanels := make(map[tileKey][]*generatedPanel)

	for _, p := range panels {
		col := int(math.Floor((p.CenterX - originX) / tileSize))
		row := int(math.Floor((p.CenterY - originY) / tileSize))
		key := tileKey{col, row}
		tilePanels[key] = append(tilePanels[key], p)
	}

	// Sort keys for deterministic output.
	keys := make([]tileKey, 0, len(tilePanels))
	for k := range tilePanels {
		keys = append(keys, k)
	}
	sort.Slice(keys, func(i, j int) bool {
		if keys[i].row != keys[j].row {
			return keys[i].row < keys[j].row
		}
		return keys[i].col < keys[j].col
	})

	// Compute LOD level based on panel density.
	// LOD 0 = full detail, LOD 1 = medium, LOD 2 = coarse.
	computeLOD := func(panelCount int) int {
		switch {
		case panelCount > 1000:
			return 0 // Dense tile, needs all LOD levels
		case panelCount > 100:
			return 0
		default:
			return 0
		}
	}
	_ = nCols
	_ = nRows

	var domainTiles []*domain.LayoutTile
	var domainPanels []*domain.Panel

	for _, key := range keys {
		gp := tilePanels[key]

		tileMinX := originX + float64(key.col)*tileSize
		tileMinY := originY + float64(key.row)*tileSize
		tileMaxX := tileMinX + tileSize
		tileMaxY := tileMinY + tileSize

		// Create a tile with a pre-allocated UUID. BulkInsertTiles will overwrite
		// this, but we need it now so panels can reference the tile.
		tileID := uuid.New()

		tile := &domain.LayoutTile{
			ID:       tileID,
			LayoutID: layoutID,
			BBox: domain.BoundingBox{
				MinX: tileMinX,
				MinY: tileMinY,
				MaxX: tileMaxX,
				MaxY: tileMaxY,
			},
			LODLevel:   computeLOD(len(gp)),
			PanelCount: len(gp),
		}
		domainTiles = append(domainTiles, tile)

		for _, p := range gp {
			domainPanels = append(domainPanels, &domain.Panel{
				TileID:          tileID,
				StringID:        p.StringID,
				GeometryGeoJSON: p.Geometry,
				Tilt:            p.Tilt,
				Azimuth:         p.Azimuth,
				Elevation:       0, // Ground-mount default
			})
		}
	}

	return domainTiles, domainPanels
}

// ---------------------------------------------------------------------------
// Geometry helpers
// ---------------------------------------------------------------------------

// parseGeoJSONPolygon extracts the exterior ring of a GeoJSON Polygon.
func parseGeoJSONPolygon(raw json.RawMessage) (*Polygon2D, error) {
	var geojson struct {
		Type        string          `json:"type"`
		Coordinates json.RawMessage `json:"coordinates"`
	}
	if err := json.Unmarshal(raw, &geojson); err != nil {
		return nil, fmt.Errorf("unmarshal geojson: %w", err)
	}

	switch geojson.Type {
	case "Polygon":
		var rings [][][2]float64
		if err := json.Unmarshal(geojson.Coordinates, &rings); err != nil {
			return nil, fmt.Errorf("unmarshal polygon coordinates: %w", err)
		}
		if len(rings) == 0 || len(rings[0]) < 3 {
			return nil, fmt.Errorf("polygon must have an exterior ring with >= 3 points")
		}
		poly := &Polygon2D{Exterior: make([]Point2D, len(rings[0]))}
		for i, coord := range rings[0] {
			poly.Exterior[i] = Point2D{X: coord[0], Y: coord[1]}
		}
		return poly, nil
	default:
		return nil, fmt.Errorf("unsupported geometry type %q, expected Polygon", geojson.Type)
	}
}

// polygonBBox computes the axis-aligned bounding box of a polygon.
func polygonBBox(poly *Polygon2D) domain.BoundingBox {
	bb := domain.BoundingBox{
		MinX: poly.Exterior[0].X,
		MinY: poly.Exterior[0].Y,
		MaxX: poly.Exterior[0].X,
		MaxY: poly.Exterior[0].Y,
	}
	for _, p := range poly.Exterior[1:] {
		if p.X < bb.MinX {
			bb.MinX = p.X
		}
		if p.X > bb.MaxX {
			bb.MaxX = p.X
		}
		if p.Y < bb.MinY {
			bb.MinY = p.Y
		}
		if p.Y > bb.MaxY {
			bb.MaxY = p.Y
		}
	}
	return bb
}

// pointInPolygon uses the ray-casting algorithm to test if a point is inside a polygon.
func pointInPolygon(pt Point2D, poly *Polygon2D) bool {
	n := len(poly.Exterior)
	inside := false

	j := n - 1
	for i := 0; i < n; i++ {
		xi, yi := poly.Exterior[i].X, poly.Exterior[i].Y
		xj, yj := poly.Exterior[j].X, poly.Exterior[j].Y

		// Ray cast: does a horizontal ray from pt cross edge (i, j)?
		if ((yi > pt.Y) != (yj > pt.Y)) &&
			(pt.X < (xj-xi)*(pt.Y-yi)/(yj-yi)+xi) {
			inside = !inside
		}
		j = i
	}
	return inside
}

// panelGeometry produces a GeoJSON Polygon for a single panel, given its
// center, dimensions, and azimuth rotation.
func panelGeometry(cx, cy, width, height float64, azRad float64) json.RawMessage {
	hw := width / 2.0
	hh := height / 2.0

	// Panel local corners (before rotation).
	localCorners := [4]Point2D{
		{-hw, -hh},
		{hw, -hh},
		{hw, hh},
		{-hw, hh},
	}

	cosA := math.Cos(azRad)
	sinA := math.Sin(azRad)

	coords := make([][2]float64, 5) // 4 corners + close
	for i, lc := range localCorners {
		// Rotate by azimuth around center.
		rx := lc.X*cosA - lc.Y*sinA + cx
		ry := lc.X*sinA + lc.Y*cosA + cy
		coords[i] = [2]float64{rx, ry}
	}
	coords[4] = coords[0] // Close the ring.

	geojson := struct {
		Type        string          `json:"type"`
		Coordinates [][][2]float64  `json:"coordinates"`
	}{
		Type:        "Polygon",
		Coordinates: [][][2]float64{coords[:]},
	}
	data, _ := json.Marshal(geojson)
	return data
}
