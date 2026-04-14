package gis

import (
	"encoding/json"
	"encoding/xml"
	"strings"
)

// ConstraintZone represents a parsed constraint zone from KML
type ConstraintZone struct {
	Name          string
	ZoneType      string // wetland, floodplain, setback, exclusion, habitat, etc.
	GeoJSON       string
	SeverityLevel int // 1-5
}

// ParseConstraintZones extracts constraint zones from KML content
// Looks for placemarks with names/descriptions indicating zone type
func ParseConstraintZones(kmlData []byte) ([]ConstraintZone, error) {
	// Try to extract as KMZ first, fall back to KML
	kmlPayload, err := extractKMLPayload("zones.kml", kmlData)
	if err != nil {
		return nil, err
	}

	var kml kmlFile
	if err := xml.Unmarshal(kmlPayload, &kml); err != nil {
		return nil, err
	}

	var zones []ConstraintZone
	zoneMap := make(map[string]*ConstraintZone) // Deduplicate by GeoJSON

	// Extract zones from all placemarks
	extractZonesFromPlacemarks(kml.Placemarks, zoneMap)
	for _, container := range kml.Folders {
		extractZonesFromContainers([]kmlContainer{container}, zoneMap)
	}
	for _, container := range kml.Documents {
		extractZonesFromContainers([]kmlContainer{container}, zoneMap)
	}

	for _, zone := range zoneMap {
		zones = append(zones, *zone)
	}

	return zones, nil
}

func extractZonesFromContainers(containers []kmlContainer, zoneMap map[string]*ConstraintZone) {
	for _, container := range containers {
		// Process nested folders
		extractZonesFromContainers(container.Folders, zoneMap)
		// Process placemarks in this container
		extractZonesFromPlacemarks(container.Placemarks, zoneMap)
	}
}

func extractZonesFromPlacemarks(placemarks []kmlPlacemark, zoneMap map[string]*ConstraintZone) {
	for _, pm := range placemarks {
		// Process polygon
		if pm.Polygon != nil {
			zone := parseZoneFromPolygon(pm.Name, pm.Polygon.OuterBoundary.LinearRing.Coordinates)
			if zone != nil && zone.GeoJSON != "" {
				if _, exists := zoneMap[zone.GeoJSON]; !exists {
					zoneMap[zone.GeoJSON] = zone
				}
			}
		}

		// Also process multi-geometries that contain polygons
		if pm.MultiGeometry != nil {
			extractZonesFromMultiGeometry(pm.Name, pm.MultiGeometry, zoneMap)
		}
	}
}

func extractZonesFromMultiGeometry(parentName string, mg *kmlMultiGeometry, zoneMap map[string]*ConstraintZone) {
	// Process polygons in this multi-geometry
	for _, poly := range mg.Polygons {
		zone := parseZoneFromPolygon(parentName, poly.OuterBoundary.LinearRing.Coordinates)
		if zone != nil && zone.GeoJSON != "" {
			if _, exists := zoneMap[zone.GeoJSON]; !exists {
				zoneMap[zone.GeoJSON] = zone
			}
		}
	}

	// Recurse into nested multi-geometries
	for _, inner := range mg.MultiGeometries {
		extractZonesFromMultiGeometry(parentName, &inner, zoneMap)
	}
}

func parseZoneFromPolygon(name string, coordString string) *ConstraintZone {
	coords, err := parseCoordinates(coordString)
	if err != nil || len(coords) < 3 {
		return nil
	}

	// Ensure polygon is closed
	if len(coords) > 0 && (coords[0][0] != coords[len(coords)-1][0] || coords[0][1] != coords[len(coords)-1][1]) {
		coords = append(coords, coords[0])
	}

	// Create GeoJSON polygon
	polygon := map[string]interface{}{
		"type":        "Polygon",
		"coordinates": [][][]float64{coords},
	}

	geoJSONBytes, err := json.Marshal(polygon)
	if err != nil {
		return nil
	}

	// Detect zone type from name/description
	zoneType, severity := detectZoneType(name)

	zone := &ConstraintZone{
		Name:          strings.TrimSpace(name),
		ZoneType:      zoneType,
		GeoJSON:       string(geoJSONBytes),
		SeverityLevel: severity,
	}

	return zone
}

func detectZoneType(name string) (string, int) {
	nameLower := strings.ToLower(name)

	// High severity - no build allowed
	if strings.Contains(nameLower, "wetland") || strings.Contains(nameLower, "marsh") ||
		strings.Contains(nameLower, "swamp") {
		return "wetland", 5
	}
	if strings.Contains(nameLower, "exclusion") {
		return "exclusion", 5
	}

	// Medium-high severity - strong avoidance
	if strings.Contains(nameLower, "floodplain") || strings.Contains(nameLower, "flood") {
		return "floodplain", 4
	}
	if strings.Contains(nameLower, "habitat") || strings.Contains(nameLower, "critical habitat") {
		return "habitat", 4
	}

	// Medium severity - penalty
	if strings.Contains(nameLower, "setback") || strings.Contains(nameLower, "buffer") {
		return "setback", 2
	}
	if strings.Contains(nameLower, "archeological") || strings.Contains(nameLower, "archaeological") ||
		strings.Contains(nameLower, "historic") {
		return "archeological", 3
	}
	if strings.Contains(nameLower, "transmission") || strings.Contains(nameLower, "high voltage") ||
		strings.Contains(nameLower, "utility") {
		return "high_voltage", 2
	}

	// Default: treat as low-severity setback
	return "setback", 1
}
