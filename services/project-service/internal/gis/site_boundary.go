package gis

import (
	"archive/zip"
	"bytes"
	"encoding/json"
	"encoding/xml"
	"errors"
	"fmt"
	"math"
	"path/filepath"
	"strings"
)

type SiteBoundary struct {
	Name    string
	GeoJSON string
}

type kmlFile struct {
	Documents  []kmlContainer `xml:"Document"`
	Folders    []kmlContainer `xml:"Folder"`
	Placemarks []kmlPlacemark `xml:"Placemark"`
}

type kmlContainer struct {
	Name       string         `xml:"name"`
	Folders    []kmlContainer `xml:"Folder"`
	Placemarks []kmlPlacemark `xml:"Placemark"`
}

type kmlPlacemark struct {
	Name          string            `xml:"name"`
	Polygon       *kmlPolygon       `xml:"Polygon"`
	MultiGeometry *kmlMultiGeometry `xml:"MultiGeometry"`
}

type kmlMultiGeometry struct {
	Polygons        []kmlPolygon       `xml:"Polygon"`
	MultiGeometries []kmlMultiGeometry `xml:"MultiGeometry"`
}

type kmlPolygon struct {
	OuterBoundary kmlBoundary `xml:"outerBoundaryIs"`
}

type kmlBoundary struct {
	LinearRing kmlLinearRing `xml:"LinearRing"`
}

type kmlLinearRing struct {
	Coordinates string `xml:"coordinates"`
}

type geoJSONPolygon struct {
	Type        string        `json:"type"`
	Coordinates [][][]float64 `json:"coordinates"`
}

type namedPolygon struct {
	Name        string
	Coordinates [][]float64
	Score       float64
}

func ParseSiteBoundary(sourceName string, payload []byte) (*SiteBoundary, error) {
	if len(payload) == 0 {
		return nil, errors.New("empty boundary payload")
	}

	format := DetectFormat(sourceName, payload)
	if format == FileFormatDWG {
		return nil, DWGGuidanceError(sourceName)
	}
	if format == FileFormatDXF {
		parsed, err := ParseDXF(payload)
		if err != nil {
			return nil, err
		}
		return DXFPrimaryBoundary(parsed, sourceName)
	}
	if format != FileFormatKML && format != FileFormatKMZ {
		return nil, errors.New("unsupported file format; use .kml, .kmz, or .dxf")
	}

	kmlPayload, err := extractKMLPayload(sourceName, payload)
	if err != nil {
		return nil, err
	}

	var doc kmlFile
	if err := xml.Unmarshal(kmlPayload, &doc); err != nil {
		return nil, fmt.Errorf("parse kml: %w", err)
	}

	polygons := collectPolygons(doc)
	if len(polygons) == 0 {
		return nil, errors.New("no polygon boundary found in KML/KMZ")
	}

	selected := polygons[0]
	for _, candidate := range polygons[1:] {
		if candidate.Score > selected.Score {
			selected = candidate
		}
	}

	encoded, err := json.Marshal(geoJSONPolygon{
		Type:        "Polygon",
		Coordinates: [][][]float64{selected.Coordinates},
	})
	if err != nil {
		return nil, fmt.Errorf("encode geojson: %w", err)
	}

	name := strings.TrimSpace(selected.Name)
	if name == "" {
		name = strings.TrimSuffix(filepath.Base(sourceName), filepath.Ext(sourceName))
	}

	return &SiteBoundary{Name: name, GeoJSON: string(encoded)}, nil
}

func extractKMLPayload(sourceName string, payload []byte) ([]byte, error) {
	if strings.EqualFold(filepath.Ext(sourceName), ".kmz") {
		reader, err := zip.NewReader(bytes.NewReader(payload), int64(len(payload)))
		if err != nil {
			return nil, fmt.Errorf("open kmz archive: %w", err)
		}
		for _, file := range reader.File {
			if !strings.EqualFold(filepath.Ext(file.Name), ".kml") {
				continue
			}
			rc, err := file.Open()
			if err != nil {
				return nil, fmt.Errorf("open kml entry: %w", err)
			}
			defer rc.Close()
			return ioReadAll(rc)
		}
		return nil, errors.New("kmz archive does not contain a KML document")
	}
	return payload, nil
}

func collectPolygons(doc kmlFile) []namedPolygon {
	var polygons []namedPolygon
	for _, placemark := range doc.Placemarks {
		polygons = append(polygons, placemarkPolygons(placemark)...)
	}
	for _, container := range doc.Folders {
		polygons = append(polygons, containerPolygons(container)...)
	}
	for _, container := range doc.Documents {
		polygons = append(polygons, containerPolygons(container)...)
	}
	return polygons
}

func containerPolygons(container kmlContainer) []namedPolygon {
	var polygons []namedPolygon
	for _, placemark := range container.Placemarks {
		polygons = append(polygons, placemarkPolygons(placemark)...)
	}
	for _, child := range container.Folders {
		polygons = append(polygons, containerPolygons(child)...)
	}
	return polygons
}

func placemarkPolygons(placemark kmlPlacemark) []namedPolygon {
	var polygons []namedPolygon
	if placemark.Polygon != nil {
		if polygon, err := polygonFromCoordinates(placemark.Name, placemark.Polygon.OuterBoundary.LinearRing.Coordinates); err == nil {
			polygons = append(polygons, polygon)
		}
	}
	if placemark.MultiGeometry != nil {
		polygons = append(polygons, multiGeometryPolygons(placemark.Name, *placemark.MultiGeometry)...)
	}
	return polygons
}

func multiGeometryPolygons(name string, geometry kmlMultiGeometry) []namedPolygon {
	var polygons []namedPolygon
	for _, polygon := range geometry.Polygons {
		if parsed, err := polygonFromCoordinates(name, polygon.OuterBoundary.LinearRing.Coordinates); err == nil {
			polygons = append(polygons, parsed)
		}
	}
	for _, nested := range geometry.MultiGeometries {
		polygons = append(polygons, multiGeometryPolygons(name, nested)...)
	}
	return polygons
}

func polygonFromCoordinates(name, raw string) (namedPolygon, error) {
	coordinates, err := parseCoordinates(raw)
	if err != nil {
		return namedPolygon{}, err
	}
	return namedPolygon{Name: strings.TrimSpace(name), Coordinates: coordinates, Score: polygonScore(coordinates)}, nil
}

func parseCoordinates(raw string) ([][]float64, error) {
	fields := strings.Fields(strings.TrimSpace(raw))
	if len(fields) < 3 {
		return nil, errors.New("polygon must contain at least three coordinate pairs")
	}
	coordinates := make([][]float64, 0, len(fields)+1)
	for _, field := range fields {
		parts := strings.Split(field, ",")
		if len(parts) < 2 {
			return nil, fmt.Errorf("invalid coordinate %q", field)
		}
		lon, err := parseFloat(parts[0])
		if err != nil {
			return nil, fmt.Errorf("invalid longitude %q", parts[0])
		}
		lat, err := parseFloat(parts[1])
		if err != nil {
			return nil, fmt.Errorf("invalid latitude %q", parts[1])
		}
		coordinates = append(coordinates, []float64{lon, lat})
	}
	if !sameCoordinate(coordinates[0], coordinates[len(coordinates)-1]) {
		coordinates = append(coordinates, []float64{coordinates[0][0], coordinates[0][1]})
	}
	if len(coordinates) < 4 {
		return nil, errors.New("polygon ring must contain at least four points including closure")
	}
	return coordinates, nil
}

func polygonScore(coordinates [][]float64) float64 {
	var area float64
	for index := 0; index < len(coordinates)-1; index++ {
		current := coordinates[index]
		next := coordinates[index+1]
		area += current[0]*next[1] - next[0]*current[1]
	}
	return math.Abs(area) / 2
}

func sameCoordinate(a, b []float64) bool {
	return len(a) >= 2 && len(b) >= 2 && a[0] == b[0] && a[1] == b[1]
}

func parseFloat(value string) (float64, error) {
	return strconvParseFloat(strings.TrimSpace(value), 64)
}
