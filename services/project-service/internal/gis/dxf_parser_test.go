package gis

import "testing"

func TestParseDXFPolygon(t *testing.T) {
	dxf := []byte("0\nSECTION\n2\nENTITIES\n0\nLWPOLYLINE\n8\nBOUNDARY\n70\n1\n10\n76.5\n20\n12.1\n10\n76.6\n20\n12.1\n10\n76.6\n20\n12.2\n10\n76.5\n20\n12.2\n0\nENDSEC\n0\nEOF\n")

	parsed, err := ParseDXF(dxf)
	if err != nil {
		t.Fatalf("ParseDXF returned error: %v", err)
	}
	if len(parsed.Features) == 0 {
		t.Fatal("expected parsed features")
	}
	if parsed.Features[0].EntityType != "Polygon" {
		t.Fatalf("expected polygon, got %s", parsed.Features[0].EntityType)
	}
	boundary, err := DXFPrimaryBoundary(parsed, "parcel.dxf")
	if err != nil {
		t.Fatalf("DXFPrimaryBoundary returned error: %v", err)
	}
	if boundary.GeoJSON == "" {
		t.Fatal("expected boundary geojson")
	}
}

func TestParseDXFProjectedCoordinatesConvertsToWGS84(t *testing.T) {
	dxf := []byte("0\nSECTION\n2\nENTITIES\n0\nLWPOLYLINE\n8\nBOUNDARY\n70\n1\n10\n708000\n20\n1332000\n10\n708200\n20\n1332000\n10\n708200\n20\n1332200\n10\n708000\n20\n1332200\n0\nENDSEC\n0\nEOF\n")

	parsed, err := ParseDXF(dxf)
	if err != nil {
		t.Fatalf("ParseDXF returned error: %v", err)
	}
	if parsed.SourceCRS != "EPSG:32643" {
		t.Fatalf("expected EPSG:32643, got %s", parsed.SourceCRS)
	}
	if parsed.Features[0].BoundingBox[0] < 60 || parsed.Features[0].BoundingBox[0] > 90 {
		t.Fatalf("expected longitude-like bbox after conversion, got %v", parsed.Features[0].BoundingBox)
	}
}
