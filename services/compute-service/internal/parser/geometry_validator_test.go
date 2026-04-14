package parser

import (
	"math"
	"testing"
)

// TestGeometryValidator_ValidatePoint_Valid tests valid point validation.
func TestGeometryValidator_ValidatePoint_Valid(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type:   "Point",
		Points: []Point2D{{X: -122.08, Y: 37.42}},
	}

	errors := v.ValidateGeometry(geom, 0)
	if len(errors) > 0 && v.HasErrors(errors) {
		t.Fatalf("Valid point should have no errors, got %d", len(errors))
	}
}

// TestGeometryValidator_ValidatePoint_InvalidBounds tests point validation out of bounds.
func TestGeometryValidator_ValidatePoint_InvalidBounds(t *testing.T) {
	v := NewGeometryValidator()
	v.StrictBounds = true

	geom := &KMLGeometry{
		Type:   "Point",
		Points: []Point2D{{X: 200, Y: 37.42}}, // Invalid longitude
	}

	errors := v.ValidateGeometry(geom, 0)
	if !v.HasErrors(errors) {
		t.Fatal("Out-of-bounds point should have errors")
	}
}

// TestGeometryValidator_ValidateLineString_Valid tests valid linestring.
func TestGeometryValidator_ValidateLineString_Valid(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type: "LineString",
		Points: []Point2D{
			{X: 0, Y: 0},
			{X: 10, Y: 10},
		},
	}

	errors := v.ValidateGeometry(geom, 0)
	if len(errors) > 0 && v.HasErrors(errors) {
		t.Fatalf("Valid linestring should have no errors")
	}
}

// TestGeometryValidator_ValidateLineString_TooFewPoints tests linestring with too few points.
func TestGeometryValidator_ValidateLineString_TooFewPoints(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type:   "LineString",
		Points: []Point2D{{X: 0, Y: 0}}, // Only 1 point
	}

	errors := v.ValidateGeometry(geom, 0)
	if !v.HasErrors(errors) {
		t.Fatal("LineString with 1 point should have errors")
	}
}

// TestGeometryValidator_ValidatePolygon_Valid tests valid polygon.
func TestGeometryValidator_ValidatePolygon_Valid(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type: "Polygon",
		Rings: []Ring{
			{
				Points: []Point2D{
					{X: 0, Y: 0},
					{X: 10, Y: 0},
					{X: 10, Y: 10},
					{X: 0, Y: 0}, // Closed
				},
			},
		},
	}

	errors := v.ValidateGeometry(geom, 0)
	if len(errors) > 0 && v.HasErrors(errors) {
		t.Fatalf("Valid polygon should have no errors")
	}
}

// TestGeometryValidator_ValidatePolygon_NotClosed tests unclosed polygon.
func TestGeometryValidator_ValidatePolygon_NotClosed(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type: "Polygon",
		Rings: []Ring{
			{
				Points: []Point2D{
					{X: 0, Y: 0},
					{X: 10, Y: 0},
					{X: 10, Y: 10},
					{X: 5, Y: 5}, // Not closed
				},
			},
		},
	}

	errors := v.ValidateGeometry(geom, 0)
	if !v.HasErrors(errors) {
		t.Fatal("Unclosed polygon should have errors")
	}
}

// TestGeometryValidator_ValidatePolygon_NoRings tests polygon with no rings.
func TestGeometryValidator_ValidatePolygon_NoRings(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type:  "Polygon",
		Rings: []Ring{},
	}

	errors := v.ValidateGeometry(geom, 0)
	if !v.HasErrors(errors) {
		t.Fatal("Polygon with no rings should have errors")
	}
}

// TestGeometryValidator_ValidateMultiGeometry_Valid tests valid multigeometry.
func TestGeometryValidator_ValidateMultiGeometry_Valid(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type: "MultiGeometry",
		Geometries: []*KMLGeometry{
			{
				Type:   "Point",
				Points: []Point2D{{X: 0, Y: 0}},
			},
			{
				Type:   "Point",
				Points: []Point2D{{X: 10, Y: 10}},
			},
		},
	}

	errors := v.ValidateGeometry(geom, 0)
	if len(errors) > 0 && v.HasErrors(errors) {
		t.Fatalf("Valid multigeometry should have no errors")
	}
}

// TestGeometryValidator_ValidateMultiGeometry_Empty tests empty multigeometry.
func TestGeometryValidator_ValidateMultiGeometry_Empty(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type:       "MultiGeometry",
		Geometries: []*KMLGeometry{},
	}

	errors := v.ValidateGeometry(geom, 0)
	if !v.HasErrors(errors) {
		t.Fatal("Empty MultiGeometry should have errors")
	}
}

// TestGeometryValidator_ValidateCoordinate_NaN tests NaN coordinate detection.
func TestGeometryValidator_ValidateCoordinate_NaN(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type:   "Point",
		Points: []Point2D{{X: math.NaN(), Y: 37.42}},
	}

	errors := v.ValidateGeometry(geom, 0)
	if !v.HasErrors(errors) {
		t.Fatal("NaN coordinate should have errors")
	}
}

// TestGeometryValidator_ValidatePolygon_DuplicateConsecutive tests duplicate point detection.
func TestGeometryValidator_ValidatePolygon_DuplicateConsecutive(t *testing.T) {
	v := NewGeometryValidator()

	geom := &KMLGeometry{
		Type: "LineString",
		Points: []Point2D{
			{X: 0, Y: 0},
			{X: 0, Y: 0}, // Duplicate
			{X: 10, Y: 10},
		},
	}

	errors := v.ValidateGeometry(geom, 0)
	// Should have warnings but not errors
	hasWarnings := false
	for _, err := range errors {
		if err.Severity == "WARNING" {
			hasWarnings = true
		}
	}
	if !hasWarnings {
		t.Fatal("Duplicate consecutive points should generate warnings")
	}
}

// TestGeometryValidator_ValidateFeature_NoName tests feature without name generates warning.
func TestGeometryValidator_ValidateFeature_NoName(t *testing.T) {
	v := NewGeometryValidator()

	feature := &KMLFeature{
		Name: "", // No name
		Geometry: &KMLGeometry{
			Type:   "Point",
			Points: []Point2D{{X: 0, Y: 0}},
		},
	}

	errors := v.ValidateFeature(feature, 0)
	hasWarnings := false
	for _, err := range errors {
		if err.Severity == "WARNING" && err.Field == "name" {
			hasWarnings = true
		}
	}
	if !hasWarnings {
		t.Fatal("Feature without name should generate warning")
	}
}

// TestGeometryValidator_ValidateDocument tests document-level validation.
func TestGeometryValidator_ValidateDocument(t *testing.T) {
	v := NewGeometryValidator()

	doc := &KMLDocument{
		Name: "Test",
		Features: []*KMLFeature{
			{
				Name: "Point1",
				Geometry: &KMLGeometry{
					Type:   "Point",
					Points: []Point2D{{X: 0, Y: 0}},
				},
			},
		},
	}

	results := v.ValidateDocument(doc)
	if len(results) > 0 {
		// Check if only valid entries (0 or positive indices with no errors)
		for idx, errs := range results {
			if idx >= 0 && len(errs) > 0 && v.HasErrors(errs) {
				t.Fatalf("Document with valid features should not have errors at index %d", idx)
			}
		}
	}
}

// TestGeometryValidator_MaxPointsExceeded tests maximum points constraint.
func TestGeometryValidator_MaxPointsExceeded(t *testing.T) {
	v := NewGeometryValidator()
	v.MaxPointsPerGeometry = 10

	points := make([]Point2D, 20)
	for i := 0; i < 20; i++ {
		points[i] = Point2D{X: float64(i), Y: float64(i)}
	}

	geom := &KMLGeometry{
		Type:   "LineString",
		Points: points,
	}

	errors := v.ValidateGeometry(geom, 0)
	if !v.HasErrors(errors) {
		t.Fatal("LineString exceeding max points should have errors")
	}
}

// TestGeometryValidator_ErrorSummary tests error summary formatting.
func TestGeometryValidator_ErrorSummary(t *testing.T) {
	v := NewGeometryValidator()

	errors := []ValidationError{
		{Field: "a", Severity: "ERROR"},
		{Field: "b", Severity: "ERROR"},
		{Field: "c", Severity: "WARNING"},
	}

	summary := v.ErrorSummary(errors)
	if summary != "2 errors, 1 warnings" {
		t.Fatalf("Unexpected summary: %s", summary)
	}
}
