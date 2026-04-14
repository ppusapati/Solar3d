package service

import (
	"encoding/json"
	"math"
	"strings"

	"solar3d/transmission-routing-service/internal/domain"
)

var hardBlockedFeatureTypes = map[string]struct{}{
	"building":   {},
	"buildings":  {},
	"structure":  {},
	"structures": {},
	"lake":       {},
	"lakes":      {},
	"waterbody":  {},
	"reservoir":  {},
	"wetland":    {},
	"airport":    {},
	"military":   {},
	"protected":  {},
	"forbidden":  {},
	"no_go":      {},
	"no-go":      {},
	"no_build":   {},
	"no-build":   {},
}

const undergroundRequiredCostMarker = -1000000.0

func isHardBlockedFeatureType(featureType string) bool {
	_, blocked := hardBlockedFeatureTypes[strings.ToLower(strings.TrimSpace(featureType))]
	return blocked
}

func isUndergroundOnlyFeatureType(featureType string) bool {
	normalized := strings.ToLower(strings.TrimSpace(featureType))
	return normalized == "underground_only" || normalized == "underground-only"
}

func isUndergroundRequiredCost(value float64) bool {
	return value == undergroundRequiredCostMarker
}

func buildCostGrid(raster domain.ElevationRaster, obstacle *domain.ObstacleRaster, features []domain.VectorFeature, constraints domain.TransmissionConstraints) [][]float64 {
	grid := make([][]float64, raster.Height)
	for row := 0; row < raster.Height; row++ {
		grid[row] = make([]float64, raster.Width)
		for col := 0; col < raster.Width; col++ {
			grid[row][col] = 1.0
		}
	}

	if obstacle != nil && obstacle.Width == raster.Width && obstacle.Height == raster.Height {
		for row := 0; row < raster.Height; row++ {
			for col := 0; col < raster.Width; col++ {
				value := obstacle.Values[row*raster.Width+col]
				if value > 0 {
					grid[row][col] = math.Max(grid[row][col], constraints.WaterCrossingCostMult*value)
				}
			}
		}
	}

	// Track which cells are within road/corridor buffer so we can penalize off-road cells.
	roadMask := make([][]bool, raster.Height)
	for row := 0; row < raster.Height; row++ {
		roadMask[row] = make([]bool, raster.Width)
	}

	hasRoadFeatures := false
	for _, feature := range features {
		if isRoadLikeForBuffer(feature.FeatureType) {
			applyRoadCorridorCost(grid, roadMask, raster, feature, constraints)
			hasRoadFeatures = true
		} else {
			applyFeatureCost(grid, raster, feature, constraints)
		}
	}

	// Apply off-road (land acquisition) penalty to cells not near any road/corridor.
	// Only apply when road features actually exist; without road data the penalty would
	// uniformly scale every cell which changes cost magnitudes without affecting the path.
	if hasRoadFeatures && constraints.OffRoadPenalty > 1.0 {
		for row := 0; row < raster.Height; row++ {
			for col := 0; col < raster.Width; col++ {
				if !roadMask[row][col] && !math.IsInf(grid[row][col], 1) && !isUndergroundRequiredCost(grid[row][col]) {
					grid[row][col] *= constraints.OffRoadPenalty
				}
			}
		}
	}

	return grid
}

func applyFeatureCost(grid [][]float64, raster domain.ElevationRaster, feature domain.VectorFeature, constraints domain.TransmissionConstraints) {
	if _, ok := featureBounds(feature.GeometryGeoJSON); !ok {
		return
	}

	if isHardBlockedFeatureType(feature.FeatureType) {
		applyGeometryMultiplier(grid, raster, feature, math.Inf(1))
		return
	}
	if isUndergroundOnlyFeatureType(feature.FeatureType) {
		applyGeometryMultiplier(grid, raster, feature, undergroundRequiredCostMarker)
		return
	}

	multiplier := feature.CostMultiplier
	if multiplier <= 0 {
		switch strings.ToLower(feature.FeatureType) {
		case "road":
			multiplier = constraints.RoadParallelDiscount
		// preferred_corridor: strong incentive to route through (e.g. existing ROW, road corridor)
		case "preferred_corridor", "corridor":
			multiplier = 0.35
		case "water", "river", "canal", "water_body":
			multiplier = constraints.WaterCrossingCostMult
		// protected_area: allowed but expensive (nature reserve, partial restriction)
		case "protected_area":
			multiplier = 4.0
		case "urban":
			multiplier = 3.0
		case "forest":
			multiplier = 1.8
		default:
			multiplier = 1.2
		}
	}
	applyGeometryMultiplier(grid, raster, feature, multiplier)
}

func applyGeometryMultiplier(grid [][]float64, raster domain.ElevationRaster, feature domain.VectorFeature, multiplier float64) {
	if applied := applyPolygonOrMultipolygon(grid, raster, feature, multiplier); applied {
		return
	}
	applyBoundsMultiplier(grid, raster, feature, multiplier)
}

func applyPolygonOrMultipolygon(grid [][]float64, raster domain.ElevationRaster, feature domain.VectorFeature, multiplier float64) bool {
	var payload struct {
		Type        string          `json:"type"`
		Coordinates json.RawMessage `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(feature.GeometryGeoJSON), &payload); err != nil {
		return false
	}

	switch strings.ToLower(payload.Type) {
	case "polygon":
		var rings [][][]float64
		if err := json.Unmarshal(payload.Coordinates, &rings); err != nil || len(rings) == 0 {
			return false
		}
		applyPolygonRings(grid, raster, rings, multiplier)
		return true
	case "multipolygon":
		var polygons [][][][]float64
		if err := json.Unmarshal(payload.Coordinates, &polygons); err != nil || len(polygons) == 0 {
			return false
		}
		for _, polygon := range polygons {
			if len(polygon) == 0 {
				continue
			}
			applyPolygonRings(grid, raster, polygon, multiplier)
		}
		return true
	default:
		return false
	}
}

func applyPolygonRings(grid [][]float64, raster domain.ElevationRaster, rings [][][]float64, multiplier float64) {
	if len(rings) == 0 || len(rings[0]) < 3 {
		return
	}

	bounds := boundsFromRing(rings[0])
	minRow, minCol := latLonToGrid(raster, bounds.minLat, bounds.minLon)
	maxRow, maxCol := latLonToGrid(raster, bounds.maxLat, bounds.maxLon)
	if minRow > maxRow {
		minRow, maxRow = maxRow, minRow
	}
	if minCol > maxCol {
		minCol, maxCol = maxCol, minCol
	}

	startRow := clampInt(minRow, 0, raster.Height-1)
	endRow := clampInt(maxRow, 0, raster.Height-1)
	startCol := clampInt(minCol, 0, raster.Width-1)
	endCol := clampInt(maxCol, 0, raster.Width-1)

	for row := startRow; row <= endRow; row++ {
		for col := startCol; col <= endCol; col++ {
			lat, lon := gridCellCenter(raster, row, col)
			if pointInsidePolygonWithHoles(lon, lat, rings) {
				if math.IsInf(multiplier, 1) {
					grid[row][col] = math.Inf(1)
					continue
				}
				if isUndergroundRequiredCost(multiplier) {
					if !math.IsInf(grid[row][col], 1) {
						grid[row][col] = undergroundRequiredCostMarker
					}
					continue
				}
				if !math.IsInf(grid[row][col], 1) {
					grid[row][col] *= multiplier
				}
			}
		}
	}
}

func boundsFromRing(ring [][]float64) geoBounds {
	bounds := geoBounds{minLon: ring[0][0], maxLon: ring[0][0], minLat: ring[0][1], maxLat: ring[0][1]}
	for _, coord := range ring[1:] {
		if len(coord) < 2 {
			continue
		}
		bounds.minLon = math.Min(bounds.minLon, coord[0])
		bounds.maxLon = math.Max(bounds.maxLon, coord[0])
		bounds.minLat = math.Min(bounds.minLat, coord[1])
		bounds.maxLat = math.Max(bounds.maxLat, coord[1])
	}
	return bounds
}

func pointInsidePolygonWithHoles(lon, lat float64, rings [][][]float64) bool {
	if len(rings) == 0 {
		return false
	}
	if !pointInRing(lon, lat, rings[0]) {
		return false
	}
	for index := 1; index < len(rings); index++ {
		if pointInRing(lon, lat, rings[index]) {
			return false
		}
	}
	return true
}

func pointInRing(lon, lat float64, ring [][]float64) bool {
	inside := false
	if len(ring) < 3 {
		return false
	}
	for i, j := 0, len(ring)-1; i < len(ring); j, i = i, i+1 {
		xi, yi := ring[i][0], ring[i][1]
		xj, yj := ring[j][0], ring[j][1]
		intersects := ((yi > lat) != (yj > lat)) &&
			(lon < (xj-xi)*(lat-yi)/(yj-yi+1e-12)+xi)
		if intersects {
			inside = !inside
		}
	}
	return inside
}

func gridCellCenter(raster domain.ElevationRaster, row, col int) (lat float64, lon float64) {
	lat = raster.OriginLat + (float64(row)+0.5)*raster.CellSizeM/111320.0
	lonScale := 111320.0 * math.Cos(raster.OriginLat*math.Pi/180.0)
	lon = raster.OriginLon + (float64(col)+0.5)*raster.CellSizeM/lonScale
	return lat, lon
}

func applyBoundsMultiplier(grid [][]float64, raster domain.ElevationRaster, feature domain.VectorFeature, multiplier float64) {
	bounds, ok := featureBounds(feature.GeometryGeoJSON)
	if !ok {
		return
	}
	minRow, minCol := latLonToGrid(raster, bounds.minLat, bounds.minLon)
	maxRow, maxCol := latLonToGrid(raster, bounds.maxLat, bounds.maxLon)
	if minRow > maxRow {
		minRow, maxRow = maxRow, minRow
	}
	if minCol > maxCol {
		minCol, maxCol = maxCol, minCol
	}
	if strings.EqualFold(feature.FeatureType, "road") {
		minRow--
		minCol--
		maxRow++
		maxCol++
	}
	for row := clampInt(minRow, 0, raster.Height-1); row <= clampInt(maxRow, 0, raster.Height-1); row++ {
		for col := clampInt(minCol, 0, raster.Width-1); col <= clampInt(maxCol, 0, raster.Width-1); col++ {
			if math.IsInf(multiplier, 1) {
				grid[row][col] = math.Inf(1)
				continue
			}
			if isUndergroundRequiredCost(multiplier) {
				if !math.IsInf(grid[row][col], 1) {
					grid[row][col] = undergroundRequiredCostMarker
				}
				continue
			}
			if !math.IsInf(grid[row][col], 1) {
				grid[row][col] *= multiplier
			}
		}
	}
}

type geoBounds struct {
	minLon float64
	minLat float64
	maxLon float64
	maxLat float64
}

func featureBounds(raw string) (geoBounds, bool) {
	var payload struct {
		Type        string          `json:"type"`
		Coordinates json.RawMessage `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(raw), &payload); err != nil {
		return geoBounds{}, false
	}
	coords := make([][]float64, 0)
	collectCoords(payload.Coordinates, &coords)
	if len(coords) == 0 {
		return geoBounds{}, false
	}
	bounds := geoBounds{minLon: coords[0][0], maxLon: coords[0][0], minLat: coords[0][1], maxLat: coords[0][1]}
	for _, coord := range coords[1:] {
		if len(coord) < 2 {
			continue
		}
		bounds.minLon = math.Min(bounds.minLon, coord[0])
		bounds.maxLon = math.Max(bounds.maxLon, coord[0])
		bounds.minLat = math.Min(bounds.minLat, coord[1])
		bounds.maxLat = math.Max(bounds.maxLat, coord[1])
	}
	return bounds, true
}

func collectCoords(raw json.RawMessage, out *[][]float64) {
	var point []float64
	if err := json.Unmarshal(raw, &point); err == nil && len(point) >= 2 {
		*out = append(*out, point)
		return
	}
	var nested []json.RawMessage
	if err := json.Unmarshal(raw, &nested); err != nil {
		return
	}
	for _, item := range nested {
		collectCoords(item, out)
	}
}

func latLonToGrid(raster domain.ElevationRaster, lat, lon float64) (int, int) {
	row := int(math.Round((lat - raster.OriginLat) * 111320.0 / raster.CellSizeM))
	lonScale := 111320.0 * math.Cos(raster.OriginLat*math.Pi/180.0)
	col := int(math.Round((lon - raster.OriginLon) * lonScale / raster.CellSizeM))
	return row, col
}

func clampInt(value, minValue, maxValue int) int {
	if value < minValue {
		return minValue
	}
	if value > maxValue {
		return maxValue
	}
	return value
}

// isRoadLikeForBuffer returns true for feature types that should be treated as
// road corridors for the purpose of buffering and off-road penalty application.
func isRoadLikeForBuffer(featureType string) bool {
	ft := strings.ToLower(strings.TrimSpace(featureType))
	switch ft {
	case "road", "roadway", "road_centerline", "road-centerline",
		"access_road", "service_road", "highway", "national_highway",
		"state_highway", "preferred_corridor", "corridor":
		return true
	default:
		return strings.Contains(ft, "road") || strings.Contains(ft, "corridor")
	}
}

// applyRoadCorridorCost buffers road LineString/MultiLineString geometries into a
// one-sided corridor strip and applies the road discount to cells within the buffer.
// It marks buffered cells in roadMask so off-road penalty can be applied elsewhere.
// The corridor extends only to one side (right-hand side of travel direction) to
// model real-world road-parallel transmission routing without crossing the road.
func applyRoadCorridorCost(grid [][]float64, roadMask [][]bool, raster domain.ElevationRaster, feature domain.VectorFeature, constraints domain.TransmissionConstraints) {
	segments := parseLineSegmentsForBuffer(feature.GeometryGeoJSON)
	if len(segments) == 0 {
		// Not a line geometry — fall back to standard feature cost application.
		applyFeatureCost(grid, raster, feature, constraints)
		return
	}

	bufferM := constraints.RoadBufferM
	if bufferM <= 0 {
		bufferM = 20
	}
	discount := constraints.RoadParallelDiscount
	if discount <= 0 || discount >= 1 {
		discount = 0.3
	}

	lonScale := 111320.0 * math.Max(0.1, math.Cos(raster.OriginLat*math.Pi/180.0))

	// For each segment, compute the right-hand perpendicular offset and mark cells
	// within the buffer strip on that side of the road.
	for _, seg := range segments {
		dLat := seg.B[1] - seg.A[1]
		dLon := seg.B[0] - seg.A[0]
		eastM := dLon * lonScale
		northM := dLat * 111320.0
		segLen := math.Sqrt(eastM*eastM + northM*northM)
		if segLen < 0.5 {
			continue
		}

		// Right-hand normal (perpendicular to travel direction, one side only)
		normEast := northM / segLen
		normNorth := -eastM / segLen

		// Determine the bounding grid area for this segment + buffer.
		bufLat := bufferM / 111320.0
		bufLon := bufferM / lonScale
		minLat := math.Min(seg.A[1], seg.B[1]) - bufLat
		maxLat := math.Max(seg.A[1], seg.B[1]) + bufLat
		minLon := math.Min(seg.A[0], seg.B[0]) - bufLon
		maxLon := math.Max(seg.A[0], seg.B[0]) + bufLon

		minRow, minCol := latLonToGrid(raster, minLat, minLon)
		maxRow, maxCol := latLonToGrid(raster, maxLat, maxLon)
		if minRow > maxRow {
			minRow, maxRow = maxRow, minRow
		}
		if minCol > maxCol {
			minCol, maxCol = maxCol, minCol
		}

		startRow := clampInt(minRow, 0, raster.Height-1)
		endRow := clampInt(maxRow, 0, raster.Height-1)
		startCol := clampInt(minCol, 0, raster.Width-1)
		endCol := clampInt(maxCol, 0, raster.Width-1)

		for row := startRow; row <= endRow; row++ {
			for col := startCol; col <= endCol; col++ {
				lat, lon := gridCellCenter(raster, row, col)

				// Vector from segment start to cell center
				toEast := (lon - seg.A[0]) * lonScale
				toNorth := (lat - seg.A[1]) * 111320.0

				// Project onto segment direction to get the along-segment parameter [0,1]
				t := (toEast*eastM + toNorth*northM) / (segLen * segLen)
				if t < -0.05 || t > 1.05 {
					continue // past segment endpoints
				}

				// Project onto normal to get signed perpendicular distance.
				// Positive = right-hand side of travel direction.
				perpDist := toEast*normEast + toNorth*normNorth

				// Accept cells that are on the right-hand side within buffer,
				// plus a small tolerance on the road itself (within ~3m of centerline).
				if perpDist >= -3.0 && perpDist <= bufferM {
					roadMask[row][col] = true
					if !math.IsInf(grid[row][col], 1) && !isUndergroundRequiredCost(grid[row][col]) {
						grid[row][col] *= discount
					}
				}
			}
		}
	}
}

// parseLineSegmentsForBuffer extracts line segments from GeoJSON for road buffering.
// Returns [][2][lon,lat] pairs for each segment.
func parseLineSegmentsForBuffer(raw string) []lineSegCoord {
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
	default:
		return nil // Polygons and other types are not road centerlines.
	}

	segments := make([]lineSegCoord, 0)
	for _, line := range lines {
		for i := 1; i < len(line); i++ {
			a := line[i-1]
			b := line[i]
			if len(a) < 2 || len(b) < 2 {
				continue
			}
			segments = append(segments, lineSegCoord{
				A: [2]float64{a[0], a[1]}, // [lon, lat]
				B: [2]float64{b[0], b[1]},
			})
		}
	}
	return segments
}

type lineSegCoord struct {
	A [2]float64 // [lon, lat]
	B [2]float64
}
