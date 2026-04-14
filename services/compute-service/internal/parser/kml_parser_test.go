package parser

import (
	"testing"
)

// TestParseKML_SimplePoint tests parsing a simple KML with a point.
func TestParseKML_SimplePoint(t *testing.T) {
	kml := `<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test Document</name>
    <Placemark>
      <name>Test Point</name>
      <Point>
        <coordinates>-122.0822035425683,37.42228990140251,0</coordinates>
      </Point>
    </Placemark>
  </Document>
</kml>`

	doc, err := ParseKML([]byte(kml))
	if err != nil {
		t.Fatalf("ParseKML failed: %v", err)
	}

	if doc == nil {
		t.Fatal("ParseKML returned nil document")
	}

	if len(doc.Features) != 1 {
		t.Fatalf("Expected 1 feature, got %d", len(doc.Features))
	}

	feature := doc.Features[0]
	if feature.Name != "Test Point" {
		t.Fatalf("Expected feature name 'Test Point', got '%s'", feature.Name)
	}

	if feature.Geometry == nil {
		t.Fatal("Feature has no geometry")
	}

	if feature.Geometry.Type != "Point" {
		t.Fatalf("Expected Point geometry, got %s", feature.Geometry.Type)
	}

	if len(feature.Geometry.Points) != 1 {
		t.Fatalf("Expected 1 point, got %d", len(feature.Geometry.Points))
	}

	p := feature.Geometry.Points[0]
	if p.X != -122.0822035425683 || p.Y != 37.42228990140251 {
		t.Fatalf("Unexpected coordinates: (%.6f, %.6f)", p.X, p.Y)
	}
}

// TestParseKML_Polygon tests parsing a polygon.
func TestParseKML_Polygon(t *testing.T) {
	kml := `<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test</name>
    <Placemark>
      <name>Polygon</name>
      <Polygon>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>
              0,0,0
              10,0,0
              10,10,0
              0,10,0
              0,0,0
            </coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    </Placemark>
  </Document>
</kml>`

	doc, err := ParseKML([]byte(kml))
	if err != nil {
		t.Fatalf("ParseKML failed: %v", err)
	}

	if len(doc.Features) != 1 {
		t.Fatalf("Expected 1 feature, got %d", len(doc.Features))
	}

	feature := doc.Features[0]
	if feature.Geometry.Type != "Polygon" {
		t.Fatalf("Expected Polygon, got %s", feature.Geometry.Type)
	}

	if len(feature.Geometry.Rings) != 1 {
		t.Fatalf("Expected 1 ring, got %d", len(feature.Geometry.Rings))
	}

	ring := feature.Geometry.Rings[0]
	if len(ring.Points) != 5 {
		t.Fatalf("Expected 5 points (closed), got %d", len(ring.Points))
	}

	// Check closure
	if ring.Points[0].X != ring.Points[4].X || ring.Points[0].Y != ring.Points[4].Y {
		t.Fatal("Polygon ring is not closed")
	}
}

// TestParseKML_InvalidXML tests error handling for malformed XML.
func TestParseKML_InvalidXML(t *testing.T) {
	kml := `<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test</name>`

	_, err := ParseKML([]byte(kml))
	if err == nil {
		t.Fatal("Expected error for malformed XML")
	}
}

// TestParseKML_MultipleFeatures tests parsing multiple placemarks.
func TestParseKML_MultipleFeatures(t *testing.T) {
	kml := `<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test</name>
    <Placemark>
      <name>Point 1</name>
      <Point><coordinates>0,0,0</coordinates></Point>
    </Placemark>
    <Placemark>
      <name>Point 2</name>
      <Point><coordinates>10,10,0</coordinates></Point>
    </Placemark>
  </Document>
</kml>`

	doc, err := ParseKML([]byte(kml))
	if err != nil {
		t.Fatalf("ParseKML failed: %v", err)
	}

	if len(doc.Features) != 2 {
		t.Fatalf("Expected 2 features, got %d", len(doc.Features))
	}

	if doc.Features[0].Name != "Point 1" {
		t.Fatalf("Expected 'Point 1', got '%s'", doc.Features[0].Name)
	}
	if doc.Features[1].Name != "Point 2" {
		t.Fatalf("Expected 'Point 2', got '%s'", doc.Features[1].Name)
	}
}

// TestCalculateBoundingBox_Point tests bounding box calculation for a point.
func TestCalculateBoundingBox_Point(t *testing.T) {
	geom := &KMLGeometry{
		Type:   "Point",
		Points: []Point2D{{X: 10, Y: 20}},
	}

	bbox := CalculateBoundingBox(geom)
	if bbox == nil {
		t.Fatal("BoundingBox is nil")
	}

	if bbox.MinX != 10 || bbox.MaxX != 10 || bbox.MinY != 20 || bbox.MaxY != 20 {
		t.Fatalf("Unexpected bounding box: (%.1f,%.1f)-(%.1f,%.1f)", bbox.MinX, bbox.MinY, bbox.MaxX, bbox.MaxY)
	}
}

// TestCalculateBoundingBox_Polygon tests bounding box for a polygon.
func TestCalculateBoundingBox_Polygon(t *testing.T) {
	geom := &KMLGeometry{
		Type: "Polygon",
		Rings: []Ring{
			{
				Points: []Point2D{
					{X: 0, Y: 0},
					{X: 10, Y: 5},
					{X: 20, Y: 10},
					{X: 0, Y: 0},
				},
			},
		},
	}

	bbox := CalculateBoundingBox(geom)
	if bbox == nil {
		t.Fatal("BoundingBox is nil")
	}

	if bbox.MinX != 0 || bbox.MaxX != 20 || bbox.MinY != 0 || bbox.MaxY != 10 {
		t.Fatalf("Unexpected bounding box: (%.1f,%.1f)-(%.1f,%.1f)", bbox.MinX, bbox.MinY, bbox.MaxX, bbox.MaxY)
	}
}

// TestParseKML_EmptyDocument tests handling of empty KML.
func TestParseKML_EmptyDocument(t *testing.T) {
	kml := `<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Empty</name>
  </Document>
</kml>`

	doc, err := ParseKML([]byte(kml))
	if err != nil {
		t.Fatalf("ParseKML failed: %v", err)
	}

	if doc == nil {
		t.Fatal("Document is nil")
	}

	if len(doc.Features) != 0 {
		t.Fatalf("Expected 0 features, got %d", len(doc.Features))
	}
}

// TestParseKML_LineString tests parsing a LineString.
func TestParseKML_LineString(t *testing.T) {
	kml := `<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test</name>
    <Placemark>
      <name>Route</name>
      <LineString>
        <coordinates>
          -122.08,37.42,0
          -122.09,37.43,0
          -122.10,37.44,0
        </coordinates>
      </LineString>
    </Placemark>
  </Document>
</kml>`

	doc, err := ParseKML([]byte(kml))
	if err != nil {
		t.Fatalf("ParseKML failed: %v", err)
	}

	feature := doc.Features[0]
	if feature.Geometry.Type != "LineString" {
		t.Fatalf("Expected LineString, got %s", feature.Geometry.Type)
	}

	if len(feature.Geometry.Points) != 3 {
		t.Fatalf("Expected 3 points, got %d", len(feature.Geometry.Points))
	}
}
