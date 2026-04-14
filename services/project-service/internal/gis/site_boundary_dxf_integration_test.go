package gis

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestParseSiteBoundary_JannurLikeDXF(t *testing.T) {
	path := filepath.Join("testdata", "jannur_like_boundary.dxf")
	payload, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read sample dxf failed: %v", err)
	}

	boundary, err := ParseSiteBoundary("jannur_like_boundary.dxf", payload)
	if err != nil {
		t.Fatalf("ParseSiteBoundary returned error: %v", err)
	}
	if !strings.Contains(boundary.GeoJSON, `"type":"Polygon"`) {
		t.Fatalf("expected polygon geojson, got %s", boundary.GeoJSON)
	}
	if !strings.Contains(boundary.GeoJSON, "76.") {
		t.Fatalf("expected converted Karnataka longitude range in geojson, got %s", boundary.GeoJSON)
	}
	if !strings.Contains(boundary.GeoJSON, "12.") {
		t.Fatalf("expected converted Karnataka latitude range in geojson, got %s", boundary.GeoJSON)
	}
}
