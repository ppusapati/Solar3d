package gis

import (
	"bufio"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"sort"
	"strconv"
	"strings"
)

type CADFeature struct {
	Layer       string
	EntityType  string
	Geometry    map[string]any
	BoundingBox [4]float64 // minX, minY, maxX, maxY
	Closed      bool
	AreaScore   float64
}

type CADParseResult struct {
	Features    []CADFeature
	Layers      []string
	SourceCRS   string
	CoordinateM string
}

func ParseDXF(payload []byte) (*CADParseResult, error) {
	if len(payload) == 0 {
		return nil, errors.New("empty dxf payload")
	}

	pairs := readDXFPairs(string(payload))
	if len(pairs) == 0 {
		return nil, errors.New("invalid dxf content")
	}

	entities := extractEntitiesPairs(pairs)
	if len(entities) == 0 {
		return nil, errors.New("no entities found in dxf")
	}

	result := &CADParseResult{Features: make([]CADFeature, 0), SourceCRS: "EPSG:4326", CoordinateM: "wgs84"}
	layers := map[string]struct{}{}

	for i := 0; i < len(entities); {
		if entities[i].Code != "0" {
			i++
			continue
		}

		entityType := strings.ToUpper(strings.TrimSpace(entities[i].Value))
		switch entityType {
		case "LWPOLYLINE":
			feature, consumed, ok := parseLWPolyline(entities[i:])
			if ok {
				result.Features = append(result.Features, feature)
				if feature.Layer != "" {
					layers[feature.Layer] = struct{}{}
				}
			}
			i += consumed
		case "POLYLINE":
			feature, consumed, ok := parsePolyline(entities[i:])
			if ok {
				result.Features = append(result.Features, feature)
				if feature.Layer != "" {
					layers[feature.Layer] = struct{}{}
				}
			}
			i += consumed
		case "LINE":
			feature, consumed, ok := parseLine(entities[i:])
			if ok {
				result.Features = append(result.Features, feature)
				if feature.Layer != "" {
					layers[feature.Layer] = struct{}{}
				}
			}
			i += consumed
		default:
			i += entityRecordLength(entities[i:])
		}
	}

	if len(result.Features) == 0 {
		return nil, errors.New("no supported dxf geometry entities found")
	}

	// Determine coordinate mode once from all extents.
	minX, minY, maxX, maxY := result.Features[0].BoundingBox[0], result.Features[0].BoundingBox[1], result.Features[0].BoundingBox[2], result.Features[0].BoundingBox[3]
	for _, feature := range result.Features[1:] {
		if feature.BoundingBox[0] < minX {
			minX = feature.BoundingBox[0]
		}
		if feature.BoundingBox[1] < minY {
			minY = feature.BoundingBox[1]
		}
		if feature.BoundingBox[2] > maxX {
			maxX = feature.BoundingBox[2]
		}
		if feature.BoundingBox[3] > maxY {
			maxY = feature.BoundingBox[3]
		}
	}

	if looksProjected(minX, minY, maxX, maxY) {
		result.SourceCRS = "EPSG:32643"
		result.CoordinateM = "utm"
		for idx := range result.Features {
			convertFeatureUTMToWGS84(&result.Features[idx])
		}
	}

	result.Layers = make([]string, 0, len(layers))
	for layer := range layers {
		result.Layers = append(result.Layers, layer)
	}
	sort.Strings(result.Layers)

	return result, nil
}

func DXFPrimaryBoundary(parsed *CADParseResult, sourceName string) (*SiteBoundary, error) {
	if parsed == nil || len(parsed.Features) == 0 {
		return nil, errors.New("no parsed cad features")
	}

	var best *CADFeature
	for idx := range parsed.Features {
		feature := &parsed.Features[idx]
		if strings.EqualFold(feature.EntityType, "Polygon") && feature.AreaScore > 0 {
			if best == nil || feature.AreaScore > best.AreaScore {
				best = feature
			}
		}
	}

	if best == nil {
		return nil, errors.New("no closed polygon boundary found in dxf")
	}

	coordsAny, ok := best.Geometry["coordinates"]
	if !ok {
		return nil, errors.New("polygon geometry missing coordinates")
	}
	encoded, err := json.Marshal(map[string]any{"type": "Polygon", "coordinates": coordsAny})
	if err != nil {
		return nil, fmt.Errorf("encode geojson polygon: %w", err)
	}

	name := strings.TrimSpace(sourceName)
	if name == "" {
		name = "Imported DXF Boundary"
	}

	return &SiteBoundary{Name: name, GeoJSON: string(encoded)}, nil
}

type dxfPair struct {
	Code  string
	Value string
}

func readDXFPairs(text string) []dxfPair {
	scanner := bufio.NewScanner(strings.NewReader(text))
	lines := make([]string, 0)
	for scanner.Scan() {
		line := strings.TrimRight(scanner.Text(), "\r")
		lines = append(lines, line)
	}

	pairs := make([]dxfPair, 0, len(lines)/2)
	for i := 0; i+1 < len(lines); i += 2 {
		pairs = append(pairs, dxfPair{Code: strings.TrimSpace(lines[i]), Value: strings.TrimSpace(lines[i+1])})
	}
	return pairs
}

func extractEntitiesPairs(pairs []dxfPair) []dxfPair {
	inEntities := false
	out := make([]dxfPair, 0)
	for idx := 0; idx < len(pairs); idx++ {
		p := pairs[idx]
		if p.Code == "0" && strings.EqualFold(p.Value, "SECTION") {
			if idx+1 < len(pairs) && pairs[idx+1].Code == "2" && strings.EqualFold(strings.TrimSpace(pairs[idx+1].Value), "ENTITIES") {
				inEntities = true
				idx++
				continue
			}
		}
		if inEntities && p.Code == "0" && strings.EqualFold(p.Value, "ENDSEC") {
			break
		}
		if inEntities {
			out = append(out, p)
		}
	}
	return out
}

func entityRecordLength(pairs []dxfPair) int {
	if len(pairs) == 0 {
		return 0
	}
	for i := 1; i < len(pairs); i++ {
		if pairs[i].Code == "0" {
			return i
		}
	}
	return len(pairs)
}

func parseLWPolyline(pairs []dxfPair) (CADFeature, int, bool) {
	consumed := entityRecordLength(pairs)
	record := pairs[:consumed]
	layer := "0"
	closed := false
	vertices := make([][]float64, 0)
	var pendingX *float64

	for i := 1; i < len(record); i++ {
		switch record[i].Code {
		case "8":
			layer = record[i].Value
		case "70":
			flag, _ := strconv.Atoi(strings.TrimSpace(record[i].Value))
			closed = (flag & 1) == 1
		case "10":
			x, err := parseFloat(record[i].Value)
			if err == nil {
				pendingX = &x
			}
		case "20":
			if pendingX == nil {
				continue
			}
			y, err := parseFloat(record[i].Value)
			if err == nil {
				vertices = append(vertices, []float64{*pendingX, y})
			}
			pendingX = nil
		}
	}

	if len(vertices) < 2 {
		return CADFeature{}, consumed, false
	}

	return cadFeatureFromVertices(layer, vertices, closed), consumed, true
}

func parsePolyline(pairs []dxfPair) (CADFeature, int, bool) {
	if len(pairs) == 0 {
		return CADFeature{}, 0, false
	}
	layer := "0"
	closed := false
	vertices := make([][]float64, 0)
	i := 1

	for ; i < len(pairs); i++ {
		if pairs[i].Code == "0" {
			break
		}
		switch pairs[i].Code {
		case "8":
			layer = pairs[i].Value
		case "70":
			flag, _ := strconv.Atoi(strings.TrimSpace(pairs[i].Value))
			closed = (flag & 1) == 1
		}
	}

	for i < len(pairs) {
		if pairs[i].Code != "0" {
			i++
			continue
		}
		typ := strings.ToUpper(strings.TrimSpace(pairs[i].Value))
		if typ == "SEQEND" {
			i++
			break
		}
		if typ != "VERTEX" {
			i += entityRecordLength(pairs[i:])
			continue
		}

		length := entityRecordLength(pairs[i:])
		rec := pairs[i : i+length]
		var x, y float64
		hasX := false
		hasY := false
		for j := 1; j < len(rec); j++ {
			switch rec[j].Code {
			case "10":
				if parsed, err := parseFloat(rec[j].Value); err == nil {
					x = parsed
					hasX = true
				}
			case "20":
				if parsed, err := parseFloat(rec[j].Value); err == nil {
					y = parsed
					hasY = true
				}
			}
		}
		if hasX && hasY {
			vertices = append(vertices, []float64{x, y})
		}
		i += length
	}

	if len(vertices) < 2 {
		return CADFeature{}, i, false
	}

	return cadFeatureFromVertices(layer, vertices, closed), i, true
}

func parseLine(pairs []dxfPair) (CADFeature, int, bool) {
	consumed := entityRecordLength(pairs)
	record := pairs[:consumed]
	layer := "0"
	var x1, y1, x2, y2 float64
	hasX1, hasY1, hasX2, hasY2 := false, false, false, false

	for i := 1; i < len(record); i++ {
		switch record[i].Code {
		case "8":
			layer = record[i].Value
		case "10":
			if parsed, err := parseFloat(record[i].Value); err == nil {
				x1 = parsed
				hasX1 = true
			}
		case "20":
			if parsed, err := parseFloat(record[i].Value); err == nil {
				y1 = parsed
				hasY1 = true
			}
		case "11":
			if parsed, err := parseFloat(record[i].Value); err == nil {
				x2 = parsed
				hasX2 = true
			}
		case "21":
			if parsed, err := parseFloat(record[i].Value); err == nil {
				y2 = parsed
				hasY2 = true
			}
		}
	}

	if !(hasX1 && hasY1 && hasX2 && hasY2) {
		return CADFeature{}, consumed, false
	}

	coords := [][]float64{{x1, y1}, {x2, y2}}
	bbox := verticesBBox(coords)
	return CADFeature{
		Layer:      layer,
		EntityType: "LineString",
		Geometry: map[string]any{
			"type":        "LineString",
			"coordinates": coords,
		},
		BoundingBox: bbox,
	}, consumed, true
}

func cadFeatureFromVertices(layer string, vertices [][]float64, closed bool) CADFeature {
	if closed && !sameCoordinate(vertices[0], vertices[len(vertices)-1]) {
		vertices = append(vertices, []float64{vertices[0][0], vertices[0][1]})
	}
	bbox := verticesBBox(vertices)

	if closed && len(vertices) >= 4 {
		ring := make([][]float64, len(vertices))
		copy(ring, vertices)
		return CADFeature{
			Layer:      layer,
			EntityType: "Polygon",
			Geometry: map[string]any{
				"type":        "Polygon",
				"coordinates": [][][]float64{ring},
			},
			BoundingBox: bbox,
			Closed:      true,
			AreaScore:   polygonScore(ring),
		}
	}

	return CADFeature{
		Layer:      layer,
		EntityType: "LineString",
		Geometry: map[string]any{
			"type":        "LineString",
			"coordinates": vertices,
		},
		BoundingBox: bbox,
		Closed:      closed,
	}
}

func verticesBBox(vertices [][]float64) [4]float64 {
	bbox := [4]float64{vertices[0][0], vertices[0][1], vertices[0][0], vertices[0][1]}
	for i := 1; i < len(vertices); i++ {
		if vertices[i][0] < bbox[0] {
			bbox[0] = vertices[i][0]
		}
		if vertices[i][1] < bbox[1] {
			bbox[1] = vertices[i][1]
		}
		if vertices[i][0] > bbox[2] {
			bbox[2] = vertices[i][0]
		}
		if vertices[i][1] > bbox[3] {
			bbox[3] = vertices[i][1]
		}
	}
	return bbox
}

func looksProjected(minX, minY, maxX, maxY float64) bool {
	return math.Abs(minX) > 180 || math.Abs(maxX) > 180 || math.Abs(minY) > 90 || math.Abs(maxY) > 90
}

func convertFeatureUTMToWGS84(feature *CADFeature) {
	if feature == nil || feature.Geometry == nil {
		return
	}

	switch strings.ToLower(feature.EntityType) {
	case "polygon":
		coordsAny, ok := feature.Geometry["coordinates"].([][][]float64)
		if !ok {
			return
		}
		for i := range coordsAny {
			for j := range coordsAny[i] {
				lat, lon := utmToLatLon(coordsAny[i][j][0], coordsAny[i][j][1], 43, true)
				coordsAny[i][j][0] = lon
				coordsAny[i][j][1] = lat
			}
		}
		feature.Geometry["coordinates"] = coordsAny
		feature.BoundingBox = coordsRingsBBox(coordsAny)
		if len(coordsAny) > 0 {
			feature.AreaScore = polygonScore(coordsAny[0])
		}
	default:
		coordsAny, ok := feature.Geometry["coordinates"].([][]float64)
		if !ok {
			return
		}
		for i := range coordsAny {
			lat, lon := utmToLatLon(coordsAny[i][0], coordsAny[i][1], 43, true)
			coordsAny[i][0] = lon
			coordsAny[i][1] = lat
		}
		feature.Geometry["coordinates"] = coordsAny
		feature.BoundingBox = verticesBBox(coordsAny)
	}
}

func coordsRingsBBox(rings [][][]float64) [4]float64 {
	bbox := [4]float64{rings[0][0][0], rings[0][0][1], rings[0][0][0], rings[0][0][1]}
	for _, ring := range rings {
		for _, pt := range ring {
			if pt[0] < bbox[0] {
				bbox[0] = pt[0]
			}
			if pt[1] < bbox[1] {
				bbox[1] = pt[1]
			}
			if pt[0] > bbox[2] {
				bbox[2] = pt[0]
			}
			if pt[1] > bbox[3] {
				bbox[3] = pt[1]
			}
		}
	}
	return bbox
}

// utmToLatLon converts UTM coordinates to latitude/longitude (WGS84).
func utmToLatLon(easting, northing float64, zone int, northern bool) (float64, float64) {
	a := 6378137.0
	f := 1 / 298.257223563
	k0 := 0.9996
	e := math.Sqrt(f * (2 - f))
	e1sq := e * e / (1 - e*e)

	x := easting - 500000.0
	y := northing
	if !northern {
		y -= 10000000.0
	}

	m := y / k0
	mu := m / (a * (1 - e*e/4 - 3*math.Pow(e, 4)/64 - 5*math.Pow(e, 6)/256))

	e1 := (1 - math.Sqrt(1-e*e)) / (1 + math.Sqrt(1-e*e))
	j1 := (3*e1/2 - 27*math.Pow(e1, 3)/32)
	j2 := (21*math.Pow(e1, 2)/16 - 55*math.Pow(e1, 4)/32)
	j3 := (151 * math.Pow(e1, 3) / 96)
	j4 := (1097 * math.Pow(e1, 4) / 512)

	fp := mu + j1*math.Sin(2*mu) + j2*math.Sin(4*mu) + j3*math.Sin(6*mu) + j4*math.Sin(8*mu)

	sinFp := math.Sin(fp)
	cosFp := math.Cos(fp)
	tanFp := math.Tan(fp)

	c1 := e1sq * cosFp * cosFp
	t1 := tanFp * tanFp
	r1 := a * (1 - e*e) / math.Pow(1-e*e*sinFp*sinFp, 1.5)
	n1 := a / math.Sqrt(1-e*e*sinFp*sinFp)
	d := x / (n1 * k0)

	q1 := n1 * tanFp / r1
	q2 := (d*d/2 - (5+3*t1+10*c1-4*c1*c1-9*e1sq)*math.Pow(d, 4)/24 + (61+90*t1+298*c1+45*t1*t1-252*e1sq-3*c1*c1)*math.Pow(d, 6)/720)
	lat := fp - q1*q2

	q3 := d - (1+2*t1+c1)*math.Pow(d, 3)/6 + (5-2*c1+28*t1-3*c1*c1+8*e1sq+24*t1*t1)*math.Pow(d, 5)/120
	lon0 := (float64(zone)-1)*6 - 180 + 3
	lon := lon0 + q3/cosFp*180/math.Pi

	return lat * 180 / math.Pi, lon
}
