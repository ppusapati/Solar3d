package gis

import (
	"archive/zip"
	"bytes"
	"strings"
	"testing"
)

func TestParseSiteBoundaryKML(t *testing.T) {
	payload := []byte(`<?xml version="1.0" encoding="UTF-8"?>
	<kml xmlns="http://www.opengis.net/kml/2.2">
	  <Document>
	    <Placemark>
	      <name>Parcel A</name>
	      <Polygon>
	        <outerBoundaryIs>
	          <LinearRing>
	            <coordinates>
	              -105.0,40.0,0 -104.0,40.0,0 -104.0,41.0,0 -105.0,41.0,0 -105.0,40.0,0
	            </coordinates>
	          </LinearRing>
	        </outerBoundaryIs>
	      </Polygon>
	    </Placemark>
	  </Document>
	</kml>`)

	boundary, err := ParseSiteBoundary("parcel.kml", payload)
	if err != nil {
		t.Fatalf("ParseSiteBoundary returned error: %v", err)
	}
	if boundary.Name != "Parcel A" {
		t.Fatalf("expected Parcel A, got %q", boundary.Name)
	}
	if !strings.Contains(boundary.GeoJSON, `"type":"Polygon"`) {
		t.Fatalf("expected polygon geojson, got %s", boundary.GeoJSON)
	}
	if !strings.Contains(boundary.GeoJSON, `[-105,40]`) {
		t.Fatalf("expected boundary coordinates in geojson, got %s", boundary.GeoJSON)
	}
}

func TestParseSiteBoundaryKMZ(t *testing.T) {
	buffer := &bytes.Buffer{}
	archive := zip.NewWriter(buffer)
	entry, err := archive.Create("doc.kml")
	if err != nil {
		t.Fatalf("create kmz entry: %v", err)
	}
	_, err = entry.Write([]byte(`<?xml version="1.0" encoding="UTF-8"?>
	<kml xmlns="http://www.opengis.net/kml/2.2">
	  <Placemark>
	    <name>Imported Site</name>
	    <Polygon>
	      <outerBoundaryIs><LinearRing><coordinates>
	        -101.0,35.0,0 -100.0,35.0,0 -100.0,36.0,0 -101.0,36.0,0 -101.0,35.0,0
	      </coordinates></LinearRing></outerBoundaryIs>
	    </Polygon>
	  </Placemark>
	</kml>`))
	if err != nil {
		t.Fatalf("write kmz entry: %v", err)
	}
	if err := archive.Close(); err != nil {
		t.Fatalf("close kmz archive: %v", err)
	}

	boundary, err := ParseSiteBoundary("parcel.kmz", buffer.Bytes())
	if err != nil {
		t.Fatalf("ParseSiteBoundary returned error: %v", err)
	}
	if boundary.Name != "Imported Site" {
		t.Fatalf("expected Imported Site, got %q", boundary.Name)
	}
}

func TestParseConstraintZones(t *testing.T) {
	payload := []byte(`<?xml version="1.0" encoding="UTF-8"?>
	<kml xmlns="http://www.opengis.net/kml/2.2">
	  <Document>
	    <Placemark>
	      <name>Protected Wetland Area</name>
	      <Polygon>
	        <outerBoundaryIs>
	          <LinearRing>
	            <coordinates>
	              -105.1,40.1,0 -104.9,40.1,0 -104.9,40.3,0 -105.1,40.3,0 -105.1,40.1,0
	            </coordinates>
	          </LinearRing>
	        </outerBoundaryIs>
	      </Polygon>
	    </Placemark>
	    <Placemark>
	      <name>100-Year Floodplain</name>
	      <Polygon>
	        <outerBoundaryIs>
	          <LinearRing>
	            <coordinates>
	              -104.8,40.0,0 -104.6,40.0,0 -104.6,40.2,0 -104.8,40.2,0 -104.8,40.0,0
	            </coordinates>
	          </LinearRing>
	        </outerBoundaryIs>
	      </Polygon>
	    </Placemark>
	  </Document>
	</kml>`)

	zones, err := ParseConstraintZones(payload)
	if err != nil {
		t.Fatalf("ParseConstraintZones returned error: %v", err)
	}
	if len(zones) != 2 {
		t.Fatalf("expected 2 zones, got %d", len(zones))
	}

	// Check wetland zone
	found := false
	for _, zone := range zones {
		if strings.Contains(zone.Name, "Wetland") {
			if zone.ZoneType != "wetland" {
				t.Fatalf("expected zone type 'wetland', got %q", zone.ZoneType)
			}
			if zone.SeverityLevel != 5 {
				t.Fatalf("expected severity 5 for wetland, got %d", zone.SeverityLevel)
			}
			found = true
		}
	}
	if !found {
		t.Fatal("wetland zone not parsed correctly")
	}
}
