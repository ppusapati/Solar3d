package parser

import (
	"archive/zip"
	"bytes"
	"encoding/xml"
	"fmt"
	"io"
	"strings"
)

// KMLFeature represents a single KML Placemark or Feature.
type KMLFeature struct {
	ID          string
	Name        string
	Description string
	Properties  map[string]string
	Geometry    *KMLGeometry
}

// KMLGeometry represents a parsed KML geometry (Point, LineString, Polygon, etc).
type KMLGeometry struct {
	Type       string         // "Point", "LineString", "Polygon", "MultiGeometry"
	Points     []Point2D      // For Point or LineString
	Rings      []Ring         // For Polygon (outer ring + holes)
	Geometries []*KMLGeometry // For MultiGeometry
}

// Point2D represents a 2D coordinate (lon, lat or x, y).
type Point2D struct {
	X float64
	Y float64
}

// Ring represents a linear ring (closed sequence of points).
type Ring struct {
	Points []Point2D
}

// BoundingBox is the extent of a geometry.
type BoundingBox struct {
	MinX float64
	MinY float64
	MaxX float64
	MaxY float64
}

// KMLDocument represents a parsed KML document.
type KMLDocument struct {
	Name     string
	Features []*KMLFeature
	CRS      int // EPSG code (default 4326 for WGS84)
}

// ParseKML parses KML bytes and returns the document.
func ParseKML(data []byte) (*KMLDocument, error) {
	var doc KML
	err := xml.Unmarshal(data, &doc)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal KML: %w", err)
	}

	result := &KMLDocument{
		Name:     doc.Document.Name,
		Features: make([]*KMLFeature, 0),
		CRS:      4326, // Default to WGS84
	}

	// Extract features from Placemarks
	if doc.Document.Folder != nil {
		extractFeaturesFromFolder(doc.Document.Folder, result.Features)
	}
	for _, pm := range doc.Document.Placemarks {
		feature := placemarkToFeature(pm, len(result.Features))
		if feature != nil {
			*(&result.Features) = append(result.Features, feature)
		}
	}

	return result, nil
}

// ParseKMZ parses KMZ (zipped KML) bytes and returns the document.
func ParseKMZ(data []byte) (*KMLDocument, error) {
	reader := bytes.NewReader(data)
	zr, err := zip.NewReader(reader, int64(len(data)))
	if err != nil {
		return nil, fmt.Errorf("failed to read KMZ zip: %w", err)
	}

	// Find the .kml file in the archive
	var kmlFile *zip.File
	for _, f := range zr.File {
		if strings.HasSuffix(strings.ToLower(f.Name), ".kml") {
			kmlFile = f
			break
		}
	}

	if kmlFile == nil {
		return nil, fmt.Errorf("no .kml file found in KMZ archive")
	}

	// Read the KML file from the archive
	rc, err := kmlFile.Open()
	if err != nil {
		return nil, fmt.Errorf("failed to open KML file in archive: %w", err)
	}
	defer rc.Close()

	kmlData, err := io.ReadAll(rc)
	if err != nil {
		return nil, fmt.Errorf("failed to read KML data from archive: %w", err)
	}

	return ParseKML(kmlData)
}

// CalculateBoundingBox calculates bounding box of a geometry.
func CalculateBoundingBox(geom *KMLGeometry) *BoundingBox {
	if geom == nil {
		return nil
	}

	bbox := &BoundingBox{
		MinX: 180, MaxX: -180,
		MinY: 90, MaxY: -90,
	}

	updateBBox := func(p Point2D) {
		if p.X < bbox.MinX {
			bbox.MinX = p.X
		}
		if p.X > bbox.MaxX {
			bbox.MaxX = p.X
		}
		if p.Y < bbox.MinY {
			bbox.MinY = p.Y
		}
		if p.Y > bbox.MaxY {
			bbox.MaxY = p.Y
		}
	}

	switch geom.Type {
	case "Point":
		if len(geom.Points) > 0 {
			updateBBox(geom.Points[0])
		}
	case "LineString":
		for _, p := range geom.Points {
			updateBBox(p)
		}
	case "Polygon":
		for _, ring := range geom.Rings {
			for _, p := range ring.Points {
				updateBBox(p)
			}
		}
	case "MultiGeometry":
		for _, subGeom := range geom.Geometries {
			subBBox := CalculateBoundingBox(subGeom)
			if subBBox != nil {
				updateBBox(Point2D{X: subBBox.MinX, Y: subBBox.MinY})
				updateBBox(Point2D{X: subBBox.MaxX, Y: subBBox.MaxY})
			}
		}
	}

	return bbox
}

// --- Internal XML structures for unmarshaling ---

type KML struct {
	XMLName  xml.Name `xml:"kml"`
	Document Document `xml:"Document"`
}

type Document struct {
	name       string `xml:"name"`
	Name       string
	Folder     *Folder     `xml:"Folder"`
	Placemarks []Placemark `xml:"Placemark"`
}

type Folder struct {
	Name       string      `xml:"name"`
	Placemarks []Placemark `xml:"Placemark"`
	Folders    []*Folder   `xml:"Folder"`
}

type Placemark struct {
	Name          string         `xml:"name"`
	Description   string         `xml:"description"`
	Point         *Point         `xml:"Point"`
	LineString    *LineString    `xml:"LineString"`
	Polygon       *Polygon       `xml:"Polygon"`
	MultiGeometry *MultiGeometry `xml:"MultiGeometry"`
	ExtendedData  *ExtendedData  `xml:"ExtendedData"`
}

type Point struct {
	Coordinates string `xml:"coordinates"`
}

type LineString struct {
	Coordinates string `xml:"coordinates"`
}

type Polygon struct {
	OuterBoundary   *LinearRing   `xml:"outerBoundaryIs>LinearRing"`
	InnerBoundaries []*LinearRing `xml:"innerBoundaryIs>LinearRing"`
}

type LinearRing struct {
	Coordinates string `xml:"coordinates"`
}

type MultiGeometry struct {
	Points          []*Point         `xml:"Point"`
	LineStrings     []*LineString    `xml:"LineString"`
	Polygons        []*Polygon       `xml:"Polygon"`
	MultiGeometries []*MultiGeometry `xml:"MultiGeometry"`
}

type ExtendedData struct {
	Data []Data `xml:"Data"`
}

type Data struct {
	Name  string `xml:"name,attr"`
	Value string `xml:"value"`
}

// --- Helper functions ---

func extractFeaturesFromFolder(folder *Folder, features []*KMLFeature) {
	for _, pm := range folder.Placemarks {
		feature := placemarkToFeature(pm, len(features))
		if feature != nil {
			features = append(features, feature)
		}
	}
	for _, f := range folder.Folders {
		extractFeaturesFromFolder(f, features)
	}
}

func placemarkToFeature(pm Placemark, idx int) *KMLFeature {
	feature := &KMLFeature{
		ID:          fmt.Sprintf("feature_%d", idx),
		Name:        pm.Name,
		Description: pm.Description,
		Properties:  make(map[string]string),
	}

	// Extract properties from ExtendedData
	if pm.ExtendedData != nil {
		for _, d := range pm.ExtendedData.Data {
			feature.Properties[d.Name] = d.Value
		}
	}

	// Extract geometry
	if pm.Point != nil {
		feature.Geometry = parsePoint(pm.Point)
	} else if pm.LineString != nil {
		feature.Geometry = parseLineString(pm.LineString)
	} else if pm.Polygon != nil {
		feature.Geometry = parsePolygon(pm.Polygon)
	} else if pm.MultiGeometry != nil {
		feature.Geometry = parseMultiGeometry(pm.MultiGeometry)
	}

	if feature.Geometry == nil {
		return nil
	}

	return feature
}

func parsePoint(p *Point) *KMLGeometry {
	coords := parseCoordinates(p.Coordinates)
	if len(coords) == 0 {
		return nil
	}
	return &KMLGeometry{
		Type:   "Point",
		Points: coords,
	}
}

func parseLineString(ls *LineString) *KMLGeometry {
	coords := parseCoordinates(ls.Coordinates)
	if len(coords) == 0 {
		return nil
	}
	return &KMLGeometry{
		Type:   "LineString",
		Points: coords,
	}
}

func parsePolygon(p *Polygon) *KMLGeometry {
	geom := &KMLGeometry{
		Type:  "Polygon",
		Rings: make([]Ring, 0),
	}

	if p.OuterBoundary != nil {
		outerCoords := parseCoordinates(p.OuterBoundary.Coordinates)
		if len(outerCoords) > 0 {
			geom.Rings = append(geom.Rings, Ring{Points: outerCoords})
		}
	}

	for _, ib := range p.InnerBoundaries {
		innerCoords := parseCoordinates(ib.Coordinates)
		if len(innerCoords) > 0 {
			geom.Rings = append(geom.Rings, Ring{Points: innerCoords})
		}
	}

	if len(geom.Rings) == 0 {
		return nil
	}
	return geom
}

func parseMultiGeometry(mg *MultiGeometry) *KMLGeometry {
	geom := &KMLGeometry{
		Type:       "MultiGeometry",
		Geometries: make([]*KMLGeometry, 0),
	}

	for _, pt := range mg.Points {
		if sub := parsePoint(pt); sub != nil {
			geom.Geometries = append(geom.Geometries, sub)
		}
	}

	for _, ls := range mg.LineStrings {
		if sub := parseLineString(ls); sub != nil {
			geom.Geometries = append(geom.Geometries, sub)
		}
	}

	for _, p := range mg.Polygons {
		if sub := parsePolygon(p); sub != nil {
			geom.Geometries = append(geom.Geometries, sub)
		}
	}

	for _, subMg := range mg.MultiGeometries {
		if sub := parseMultiGeometry(subMg); sub != nil {
			geom.Geometries = append(geom.Geometries, sub)
		}
	}

	if len(geom.Geometries) == 0 {
		return nil
	}
	return geom
}

func parseCoordinates(coordStr string) []Point2D {
	coords := make([]Point2D, 0)

	// KML format: "lon,lat,alt lon,lat,alt ..."
	// We only care about lon,lat
	pairs := strings.Fields(strings.TrimSpace(coordStr))

	for _, pair := range pairs {
		parts := strings.Split(pair, ",")
		if len(parts) >= 2 {
			var x, y float64
			fmt.Sscanf(parts[0], "%f", &x)
			fmt.Sscanf(parts[1], "%f", &y)
			coords = append(coords, Point2D{X: x, Y: y})
		}
	}

	return coords
}
