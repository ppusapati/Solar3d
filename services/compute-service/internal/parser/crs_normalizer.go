package parser

import (
	"fmt"
	"regexp"
	"strconv"
)

// CRSInfo represents coordinate reference system metadata.
type CRSInfo struct {
	EPSG         int
	Name         string
	Axis         string // "Long/Lat" for geographic, "X/Y" for projected
	Units        string // "degrees" or "metres"
	IsGeographic bool   // true if lat/lon, false if projected
}

// EPSGRegistry maps common EPSG codes to metadata.
var EPSGRegistry = map[int]CRSInfo{
	4326: {
		EPSG:         4326,
		Name:         "WGS 84",
		Axis:         "Long/Lat",
		Units:        "degrees",
		IsGeographic: true,
	},
	4269: {
		EPSG:         4269,
		Name:         "NAD 83",
		Axis:         "Long/Lat",
		Units:        "degrees",
		IsGeographic: true,
	},
	3857: {
		EPSG:         3857,
		Name:         "Web Mercator",
		Axis:         "X/Y",
		Units:        "metres",
		IsGeographic: false,
	},
	3395: {
		EPSG:         3395,
		Name:         "World Mercator",
		Axis:         "X/Y",
		Units:        "metres",
		IsGeographic: false,
	},
	// UTM zones (example for illustration; 60 zones exist)
	32601: {EPSG: 32601, Name: "UTM Zone 1N", Axis: "X/Y", Units: "metres", IsGeographic: false},
	32633: {EPSG: 32633, Name: "UTM Zone 33N", Axis: "X/Y", Units: "metres", IsGeographic: false},
	32701: {EPSG: 32701, Name: "UTM Zone 1S", Axis: "X/Y", Units: "metres", IsGeographic: false},
}

// CRSNormalizer handles coordinate reference system detection and normalization.
type CRSNormalizer struct {
	// Canonical CRS (target for normalization)
	CanonicalCRS int // Default 4326 (WGS84)
}

// NewCRSNormalizer creates a normalizer that targets WGS84.
func NewCRSNormalizer() *CRSNormalizer {
	return &CRSNormalizer{
		CanonicalCRS: 4326,
	}
}

// DetectCRS attempts to detect CRS from KML/metadata.
// Returns EPSG code and confidence level.
func (cn *CRSNormalizer) DetectCRS(metadata map[string]string) (int, float64) {
	// Check for explicit EPSG in metadata
	if epsgStr, ok := metadata["EPSG"]; ok {
		if epsg, err := strconv.Atoi(epsgStr); err == nil && cn.IsKnownCRS(epsg) {
			return epsg, 0.95 // High confidence
		}
	}

	// Check for CRS URI in metadata (common in KML)
	if crsURI, ok := metadata["CRS"]; ok {
		if epsg := cn.ExtractEPSGFromURI(crsURI); epsg > 0 && cn.IsKnownCRS(epsg) {
			return epsg, 0.85
		}
	}

	// Fallback to WGS84
	return 4326, 0.5 // Low confidence (default)
}

// ExtractEPSGFromURI extracts EPSG code from common URI formats.
// Supports:
//   - "EPSG:4326"
//   - "urn:ogc:def:crs:EPSG::4326"
//   - "http://www.opengis.net/gml/srs/epsg.xml#4326"
func (cn *CRSNormalizer) ExtractEPSGFromURI(uri string) int {
	// Simple EPSG:code format
	if len(uri) > 5 && uri[:5] == "EPSG:" {
		if code, err := strconv.Atoi(uri[5:]); err == nil {
			return code
		}
	}

	// OGC URN format: urn:ogc:def:crs:EPSG::4326
	re := regexp.MustCompile(`EPSG::(\d+)`)
	if matches := re.FindStringSubmatch(uri); len(matches) > 1 {
		if code, err := strconv.Atoi(matches[1]); err == nil {
			return code
		}
	}

	// OpenGIS URL format
	re = regexp.MustCompile(`#(\d+)$`)
	if matches := re.FindStringSubmatch(uri); len(matches) > 1 {
		if code, err := strconv.Atoi(matches[1]); err == nil {
			return code
		}
	}

	return 0
}

// IsKnownCRS returns true if the EPSG code is registered.
func (cn *CRSNormalizer) IsKnownCRS(epsg int) bool {
	_, known := EPSGRegistry[epsg]
	if known {
		return true
	}
	// Accept any EPSG code in valid range (even if not in registry)
	return epsg >= 1000 && epsg <= 32767
}

// GetCRSInfo returns metadata about a CRS.
func (cn *CRSNormalizer) GetCRSInfo(epsg int) *CRSInfo {
	if info, ok := EPSGRegistry[epsg]; ok {
		return &info
	}

	// Return generic info if not in registry
	return &CRSInfo{
		EPSG:         epsg,
		Name:         fmt.Sprintf("EPSG:%d", epsg),
		Axis:         "Unknown",
		Units:        "unknown",
		IsGeographic: false,
	}
}

// NormalizableToWGS84 checks if a CRS can be normalized to WGS84.
// For MVP, we mark geographic CRS as normalizablefor point transformations.
func (cn *CRSNormalizer) NormalizableToWGS84(sourceCRS int) bool {
	info := cn.GetCRSInfo(sourceCRS)

	// Geographic CRS can be normalized (already lat/lon-like)
	if info.IsGeographic {
		return true
	}

	// Projected CRS would need proper transformation
	// For MVP, we flag these as needing PostGIS transformation
	return false
}

// GetNormalizationHint provides SQL or parameters needed for coordinate transformation.
// For PostGIS, this would be used in ST_Transform and ST_GeomFromText calls.
func (cn *CRSNormalizer) GetNormalizationHint(sourceCRS int) string {
	if sourceCRS == cn.CanonicalCRS {
		return ""
	}

	// Return the transformation hint for use in PostGIS
	// Example: "SELECT ST_AsText(ST_Transform(geometry, 4326)) ..."
	return fmt.Sprintf("ST_Transform(?, %d)", cn.CanonicalCRS)
}

// AxisOrder returns the canonical axis order for a CRS.
// KML always uses (lon, lat) but some CRS define (lat, lon).
func (cn *CRSNormalizer) AxisOrder(epsg int) string {
	info := cn.GetCRSInfo(epsg)
	if info.IsGeographic && epsg != 4326 && epsg != 4269 {
		// Many geographic CRS use lat/lon order
		return "LatLon"
	}
	return "LonLat"
}

// CoerceToWGS84 is a simple normalizer for geographic CRS.
// For truly projected coordinates, PostGIS must be used server-side.
func (cn *CRSNormalizer) CoerceToWGS84(geometry *KMLGeometry, sourceCRS int) *KMLGeometry {
	if sourceCRS == 4326 {
		return geometry // Already in target
	}

	info := cn.GetCRSInfo(sourceCRS)
	if !info.IsGeographic {
		// Cannot do client-side transformation for projected CRS
		// This must be done in the database with PostGIS
		return geometry
	}

	// For geographic CRS, check if axis order needs adjustment
	// Most KML is in (lon, lat) already, but some CRS may specify (lat, lon)
	if cn.AxisOrder(sourceCRS) == "LatLon" {
		// Swap X and Y for all points
		return cn.swapCoordinates(geometry)
	}

	return geometry
}

func (cn *CRSNormalizer) swapCoordinates(geometry *KMLGeometry) *KMLGeometry {
	if geometry == nil {
		return nil
	}

	newGeom := &KMLGeometry{Type: geometry.Type}

	// Swap points
	for _, p := range geometry.Points {
		newGeom.Points = append(newGeom.Points, Point2D{X: p.Y, Y: p.X})
	}

	// Swap rings
	for _, ring := range geometry.Rings {
		newRing := Ring{Points: make([]Point2D, 0)}
		for _, p := range ring.Points {
			newRing.Points = append(newRing.Points, Point2D{X: p.Y, Y: p.X})
		}
		newGeom.Rings = append(newGeom.Rings, newRing)
	}

	// Recursively swap sub-geometries
	for _, sub := range geometry.Geometries {
		newGeom.Geometries = append(newGeom.Geometries, cn.swapCoordinates(sub))
	}

	return newGeom
}
