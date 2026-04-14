package parser

import (
	"fmt"
	"math"
)

// ValidationError represents a geometry validation error.
type ValidationError struct {
	Field      string   // Name of field that failed
	Message    string   // Human-readable error message
	Coordinate *Point2D // If applicable, the problematic coordinate
	Severity   string   // "ERROR" or "WARNING"
}

// GeometryValidator validates KML geometries for correctness and constraints.
type GeometryValidator struct {
	// Configuration
	MaxFeatures          int64 // Maximum geometries per upload
	MaxPointsPerGeometry int   // Max points in any single geometry
	AllowNegativeAreas   bool  // Allow counter-clockwise polygons
	StrictBounds         bool  // Validate against WGS84 bounds
}

// NewGeometryValidator creates a validator with default constraints.
func NewGeometryValidator() *GeometryValidator {
	return &GeometryValidator{
		MaxFeatures:          100000,
		MaxPointsPerGeometry: 10000,
		AllowNegativeAreas:   true,
		StrictBounds:         true,
	}
}

// ValidateGeometry checks a geometry for errors and returns validation results.
func (v *GeometryValidator) ValidateGeometry(geom *KMLGeometry, featureIndex int) []ValidationError {
	var errors []ValidationError

	if geom == nil {
		errors = append(errors, ValidationError{
			Field:    "geometry",
			Message:  "Geometry is nil",
			Severity: "ERROR",
		})
		return errors
	}

	// Type-specific validation
	switch geom.Type {
	case "Point":
		errors = append(errors, v.validatePoint(geom)...)
	case "LineString":
		errors = append(errors, v.validateLineString(geom)...)
	case "Polygon":
		errors = append(errors, v.validatePolygon(geom)...)
	case "MultiGeometry":
		errors = append(errors, v.validateMultiGeometry(geom)...)
	default:
		errors = append(errors, ValidationError{
			Field:    "type",
			Message:  fmt.Sprintf("Unknown geometry type: %s", geom.Type),
			Severity: "ERROR",
		})
	}

	return errors
}

// validatePoint checks Point geometry.
func (v *GeometryValidator) validatePoint(geom *KMLGeometry) []ValidationError {
	var errors []ValidationError

	if len(geom.Points) == 0 {
		errors = append(errors, ValidationError{
			Field:    "points",
			Message:  "Point has no coordinates",
			Severity: "ERROR",
		})
		return errors
	}

	if len(geom.Points) > 1 {
		errors = append(errors, ValidationError{
			Field:    "points",
			Message:  fmt.Sprintf("Point should have exactly 1 coordinate, got %d", len(geom.Points)),
			Severity: "WARNING",
		})
	}

	pt := geom.Points[0]
	if err := v.validateCoordinate(pt); err.Severity == "ERROR" {
		errors = append(errors, err)
	}

	return errors
}

// validateLineString checks LineString geometry.
func (v *GeometryValidator) validateLineString(geom *KMLGeometry) []ValidationError {
	var errors []ValidationError

	if len(geom.Points) < 2 {
		errors = append(errors, ValidationError{
			Field:    "points",
			Message:  fmt.Sprintf("LineString must have at least 2 points, got %d", len(geom.Points)),
			Severity: "ERROR",
		})
		return errors
	}

	if len(geom.Points) > v.MaxPointsPerGeometry {
		errors = append(errors, ValidationError{
			Field:    "points",
			Message:  fmt.Sprintf("LineString exceeds maximum points: %d > %d", len(geom.Points), v.MaxPointsPerGeometry),
			Severity: "ERROR",
		})
	}

	// Validate all coordinates
	for i, pt := range geom.Points {
		if err := v.validateCoordinate(pt); err.Severity == "ERROR" {
			err.Message = fmt.Sprintf("Point %d: %s", i, err.Message)
			errors = append(errors, err)
		}
	}

	// Check for duplicate consecutive points
	for i := 0; i < len(geom.Points)-1; i++ {
		if geom.Points[i].X == geom.Points[i+1].X && geom.Points[i].Y == geom.Points[i+1].Y {
			errors = append(errors, ValidationError{
				Field:    "points",
				Message:  fmt.Sprintf("Duplicate consecutive points at index %d", i),
				Severity: "WARNING",
			})
		}
	}

	return errors
}

// validatePolygon checks Polygon geometry.
func (v *GeometryValidator) validatePolygon(geom *KMLGeometry) []ValidationError {
	var errors []ValidationError

	if len(geom.Rings) == 0 {
		errors = append(errors, ValidationError{
			Field:    "rings",
			Message:  "Polygon has no rings",
			Severity: "ERROR",
		})
		return errors
	}

	// Validate outer ring
	outerRing := geom.Rings[0]
	if err := v.validateRing(outerRing, 0, true); err != nil {
		errors = append(errors, err...)
	}

	// Validate inner rings (holes)
	for i := 1; i < len(geom.Rings); i++ {
		if err := v.validateRing(geom.Rings[i], i, false); err != nil {
			errors = append(errors, err...)
		}
	}

	// Calculate area (check for degenerate polygons)
	area := v.calculateRingArea(outerRing)
	if math.Abs(area) < 1e-10 {
		errors = append(errors, ValidationError{
			Field:    "polygon",
			Message:  "Polygon has zero or near-zero area (degenerate)",
			Severity: "WARNING",
		})
	}

	return errors
}

// validateRing checks a linear ring.
func (v *GeometryValidator) validateRing(ring Ring, ringIndex int, isOuter bool) []ValidationError {
	var errors []ValidationError

	if len(ring.Points) < 4 {
		ringType := "Ring"
		if isOuter {
			ringType = "Outer ring"
		} else {
			ringType = fmt.Sprintf("Inner ring %d", ringIndex)
		}
		errors = append(errors, ValidationError{
			Field:    "ring",
			Message:  fmt.Sprintf("%s must have at least 4 points (closed), got %d", ringType, len(ring.Points)),
			Severity: "ERROR",
		})
		return errors
	}

	if len(ring.Points) > v.MaxPointsPerGeometry {
		errors = append(errors, ValidationError{
			Field:    "ring",
			Message:  fmt.Sprintf("Ring exceeds maximum points: %d > %d", len(ring.Points), v.MaxPointsPerGeometry),
			Severity: "ERROR",
		})
	}

	// Validate closure: first and last points must be identical
	first := ring.Points[0]
	last := ring.Points[len(ring.Points)-1]
	if first.X != last.X || first.Y != last.Y {
		errors = append(errors, ValidationError{
			Field:    "ring",
			Message:  fmt.Sprintf("Ring is not closed: first point (%.6f, %.6f) != last point (%.6f, %.6f)", first.X, first.Y, last.X, last.Y),
			Severity: "ERROR",
		})
	}

	// Validate all coordinates
	for i, pt := range ring.Points {
		if err := v.validateCoordinate(pt); err.Severity == "ERROR" {
			err.Message = fmt.Sprintf("Point %d: %s", i, err.Message)
			errors = append(errors, err)
		}
	}

	return errors
}

// validateCoordinate checks a single coordinate.
func (v *GeometryValidator) validateCoordinate(pt Point2D) ValidationError {
	// Check for NaN
	if math.IsNaN(pt.X) || math.IsNaN(pt.Y) {
		return ValidationError{
			Field:      "coordinate",
			Message:    fmt.Sprintf("Coordinate contains NaN: (%.6f, %.6f)", pt.X, pt.Y),
			Coordinate: &pt,
			Severity:   "ERROR",
		}
	}

	// Check for Infinity
	if math.IsInf(pt.X, 0) || math.IsInf(pt.Y, 0) {
		return ValidationError{
			Field:      "coordinate",
			Message:    fmt.Sprintf("Coordinate contains Infinity: (%.6f, %.6f)", pt.X, pt.Y),
			Coordinate: &pt,
			Severity:   "ERROR",
		}
	}

	// Strict bounds check (WGS84)
	if v.StrictBounds {
		if pt.X < -180 || pt.X > 180 {
			return ValidationError{
				Field:      "longitude",
				Message:    fmt.Sprintf("Longitude out of bounds: %.6f (must be -180 to 180)", pt.X),
				Coordinate: &pt,
				Severity:   "ERROR",
			}
		}
		if pt.Y < -90 || pt.Y > 90 {
			return ValidationError{
				Field:      "latitude",
				Message:    fmt.Sprintf("Latitude out of bounds: %.6f (must be -90 to 90)", pt.Y),
				Coordinate: &pt,
				Severity:   "ERROR",
			}
		}
	}

	return ValidationError{} // No error
}

// validateMultiGeometry checks MultiGeometry.
func (v *GeometryValidator) validateMultiGeometry(geom *KMLGeometry) []ValidationError {
	var errors []ValidationError

	if len(geom.Geometries) == 0 {
		errors = append(errors, ValidationError{
			Field:    "geometries",
			Message:  "MultiGeometry has no child geometries",
			Severity: "ERROR",
		})
		return errors
	}

	// Validate each child geometry recursively
	for i, child := range geom.Geometries {
		if child == nil {
			errors = append(errors, ValidationError{
				Field:    "geometries",
				Message:  fmt.Sprintf("Child geometry %d is nil", i),
				Severity: "ERROR",
			})
			continue
		}

		childErrors := v.ValidateGeometry(child, i)
		for _, err := range childErrors {
			err.Message = fmt.Sprintf("Child %d: %s", i, err.Message)
			errors = append(errors, err)
		}
	}

	return errors
}

// calculateRingArea calculates the signed area of a ring using the shoelace formula.
// Positive area = counter-clockwise, Negative area = clockwise.
func (v *GeometryValidator) calculateRingArea(ring Ring) float64 {
	if len(ring.Points) < 3 {
		return 0
	}

	area := 0.0
	for i := 0; i < len(ring.Points)-1; i++ {
		p1 := ring.Points[i]
		p2 := ring.Points[i+1]
		area += (p2.X - p1.X) * (p2.Y + p1.Y)
	}
	return area / 2.0
}

// ValidateFeature validates a complete KML feature.
func (v *GeometryValidator) ValidateFeature(feature *KMLFeature, featureIndex int) []ValidationError {
	var errors []ValidationError

	if feature == nil {
		errors = append(errors, ValidationError{
			Field:    "feature",
			Message:  "Feature is nil",
			Severity: "ERROR",
		})
		return errors
	}

	if feature.Name == "" {
		errors = append(errors, ValidationError{
			Field:    "name",
			Message:  "Feature has no name",
			Severity: "WARNING",
		})
	}

	if feature.Geometry == nil {
		errors = append(errors, ValidationError{
			Field:    "geometry",
			Message:  fmt.Sprintf("Feature %d has no geometry", featureIndex),
			Severity: "ERROR",
		})
		return errors
	}

	// Validate geometry
	geomErrors := v.ValidateGeometry(feature.Geometry, featureIndex)
	errors = append(errors, geomErrors...)

	return errors
}

// ValidateDocument validates a complete KML document.
func (v *GeometryValidator) ValidateDocument(doc *KMLDocument) map[int][]ValidationError {
	results := make(map[int][]ValidationError)

	if doc == nil {
		results[-1] = []ValidationError{{
			Field:    "document",
			Message:  "Document is nil",
			Severity: "ERROR",
		}}
		return results
	}

	if int64(len(doc.Features)) > v.MaxFeatures {
		results[-1] = []ValidationError{{
			Field:    "features",
			Message:  fmt.Sprintf("Feature count exceeds limit: %d > %d", len(doc.Features), v.MaxFeatures),
			Severity: "ERROR",
		}}
		return results
	}

	// Validate each feature
	for i, feature := range doc.Features {
		featureErrors := v.ValidateFeature(feature, i)
		if len(featureErrors) > 0 {
			results[i] = featureErrors
		}
	}

	return results
}

// HasErrors checks if there are any ERROR-severity validation errors.
func (v *GeometryValidator) HasErrors(errors []ValidationError) bool {
	for _, err := range errors {
		if err.Severity == "ERROR" {
			return true
		}
	}
	return false
}

// ErrorSummary returns a human-readable summary of validation results.
func (v *GeometryValidator) ErrorSummary(errors []ValidationError) string {
	errorCount := 0
	warningCount := 0

	for _, err := range errors {
		if err.Severity == "ERROR" {
			errorCount++
		} else if err.Severity == "WARNING" {
			warningCount++
		}
	}

	return fmt.Sprintf("%d errors, %d warnings", errorCount, warningCount)
}
