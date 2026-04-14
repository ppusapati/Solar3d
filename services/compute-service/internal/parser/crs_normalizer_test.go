package parser

import (
	"testing"
)

// TestCRSNormalizer_DetectWGS84 tests detection of WGS84 CRS.
func TestCRSNormalizer_DetectWGS84(t *testing.T) {
	norm := NewCRSNormalizer()

	metadata := map[string]string{"EPSG": "4326"}
	epsg, confidence := norm.DetectCRS(metadata)

	if epsg != 4326 {
		t.Fatalf("Expected EPSG 4326, got %d", epsg)
	}

	if confidence < 0.9 {
		t.Fatalf("Expected confidence > 0.9, got %.2f", confidence)
	}
}

// TestCRSNormalizer_ExtractEPSGFromURI_SimpleFormat tests EPSG:code format.
func TestCRSNormalizer_ExtractEPSGFromURI_SimpleFormat(t *testing.T) {
	norm := NewCRSNormalizer()

	epsg := norm.ExtractEPSGFromURI("EPSG:4326")
	if epsg != 4326 {
		t.Fatalf("Expected 4326, got %d", epsg)
	}

	epsg = norm.ExtractEPSGFromURI("EPSG:3857")
	if epsg != 3857 {
		t.Fatalf("Expected 3857, got %d", epsg)
	}
}

// TestCRSNormalizer_ExtractEPSGFromURI_OGCFormat tests OGC URN format.
func TestCRSNormalizer_ExtractEPSGFromURI_OGCFormat(t *testing.T) {
	norm := NewCRSNormalizer()

	epsg := norm.ExtractEPSGFromURI("urn:ogc:def:crs:EPSG::4326")
	if epsg != 4326 {
		t.Fatalf("Expected 4326, got %d", epsg)
	}
}

// TestCRSNormalizer_ExtractEPSGFromURI_OpenGISFormat tests OpenGIS URL format.
func TestCRSNormalizer_ExtractEPSGFromURI_OpenGISFormat(t *testing.T) {
	norm := NewCRSNormalizer()

	epsg := norm.ExtractEPSGFromURI("http://www.opengis.net/gml/srs/epsg.xml#4326")
	if epsg != 4326 {
		t.Fatalf("Expected 4326, got %d", epsg)
	}
}

// TestCRSNormalizer_IsKnownCRS tests known CRS check.
func TestCRSNormalizer_IsKnownCRS(t *testing.T) {
	norm := NewCRSNormalizer()

	// Known codes
	if !norm.IsKnownCRS(4326) {
		t.Fatal("4326 should be known")
	}

	if !norm.IsKnownCRS(3857) {
		t.Fatal("3857 should be known")
	}

	// Unknown but valid range
	if !norm.IsKnownCRS(5000) {
		t.Fatal("5000 should be valid")
	}

	// Invalid range
	if norm.IsKnownCRS(100) {
		t.Fatal("100 should not be valid")
	}
}

// TestCRSNormalizer_NormalizableToWGS84 tests geographic CRS normalization.
func TestCRSNormalizer_NormalizableToWGS84(t *testing.T) {
	norm := NewCRSNormalizer()

	// WGS84 and NAD83 are geographic
	if !norm.NormalizableToWGS84(4326) {
		t.Fatal("4326 should be normalizable")
	}

	if !norm.NormalizableToWGS84(4269) {
		t.Fatal("4269 should be normalizable")
	}

	// Web Mercator is projected
	if norm.NormalizableToWGS84(3857) {
		t.Fatal("3857 should not be normalizable client-side")
	}
}

// TestCRSNormalizer_GetCRSInfo tests CRS information retrieval.
func TestCRSNormalizer_GetCRSInfo(t *testing.T) {
	norm := NewCRSNormalizer()

	info := norm.GetCRSInfo(4326)
	if info.EPSG != 4326 {
		t.Fatalf("Expected EPSG 4326, got %d", info.EPSG)
	}

	if !info.IsGeographic {
		t.Fatal("4326 should be geographic")
	}

	if info.Units != "degrees" {
		t.Fatalf("Expected units 'degrees', got '%s'", info.Units)
	}
}

// TestCRSNormalizer_AxisOrder tests axis order detection.
func TestCRSNormalizer_AxisOrder(t *testing.T) {
	norm := NewCRSNormalizer()

	// WGS84 uses LonLat
	order := norm.AxisOrder(4326)
	if order != "LonLat" {
		t.Fatalf("Expected LonLat, got %s", order)
	}
}

// TestCRSNormalizer_GetNormalizationHint tests transformation hints.
func TestCRSNormalizer_GetNormalizationHint(t *testing.T) {
	norm := NewCRSNormalizer()

	hint := norm.GetNormalizationHint(4326)
	if hint != "" {
		t.Fatalf("Expected no hint for same CRS, got '%s'", hint)
	}

	hint = norm.GetNormalizationHint(3857)
	if hint == "" {
		t.Fatal("Expected hint for 3857 to 4326 transformation")
	}

	if hint != "ST_Transform(?, 4326)" {
		t.Fatalf("Unexpected hint: %s", hint)
	}
}

// TestCRSNormalizer_CoerceToWGS84_Geographic tests coordinate coercion for geographic CRS.
func TestCRSNormalizer_CoerceToWGS84_Geographic(t *testing.T) {
	norm := NewCRSNormalizer()

	geom := &KMLGeometry{
		Type:   "Point",
		Points: []Point2D{{X: -122.08, Y: 37.42}},
	}

	// WGS84 should return unchanged
	result := norm.CoerceToWGS84(geom, 4326)
	if result.Points[0].X != -122.08 || result.Points[0].Y != 37.42 {
		t.Fatal("WGS84 coordinates should not change")
	}
}

// TestCRSNormalizer_DetectCRS_NoMetadata tests default CRS when no metadata.
func TestCRSNormalizer_DetectCRS_NoMetadata(t *testing.T) {
	norm := NewCRSNormalizer()

	epsg, confidence := norm.DetectCRS(map[string]string{})
	if epsg != 4326 {
		t.Fatalf("Expected default 4326, got %d", epsg)
	}

	if confidence > 0.6 {
		t.Fatalf("Expected low confidence, got %.2f", confidence)
	}
}

// TestCRSNormalizer_ExtractEPSGFromURI_InvalidFormat tests invalid URI.
func TestCRSNormalizer_ExtractEPSGFromURI_InvalidFormat(t *testing.T) {
	norm := NewCRSNormalizer()

	epsg := norm.ExtractEPSGFromURI("not-a-valid-uri")
	if epsg != 0 {
		t.Fatalf("Expected 0 for invalid URI, got %d", epsg)
	}
}
