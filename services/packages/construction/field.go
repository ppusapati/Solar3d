package construction

import (
	"math"
	"time"
)

// ========================================================================
// Field Data Capture Models (consumed by Flutter mobile app)
// ========================================================================

// FieldPhoto is a geotagged photo captured on-site and linked to a
// project asset or QC inspection item.
type FieldPhoto struct {
	ID            string    `json:"id"`
	ProjectID     string    `json:"project_id"`
	AssetID       string    `json:"asset_id,omitempty"`       // linked panel/inverter/combiner
	ChecklistItemID string  `json:"checklist_item_id,omitempty"`
	PunchItemID   string    `json:"punch_item_id,omitempty"`
	FilePath      string    `json:"file_path"`                // S3 / local path
	MimeType      string    `json:"mime_type"`                // "image/jpeg", "image/png"
	FileSizeBytes int64     `json:"file_size_bytes"`
	Latitude      float64   `json:"latitude"`
	Longitude     float64   `json:"longitude"`
	Altitude      float64   `json:"altitude,omitempty"`
	Bearing       float64   `json:"bearing,omitempty"`        // compass heading (degrees)
	CapturedAt    time.Time `json:"captured_at"`
	CapturedBy    string    `json:"captured_by"`
	Notes         string    `json:"notes,omitempty"`
	Tags          []string  `json:"tags,omitempty"`           // "qc", "defect", "progress", etc.
}

// ========================================================================
// Barcode / QR Scan for Serial Number Tracking
// ========================================================================

// BarcodeScan records a barcode or QR code scan linking a physical asset
// (by serial number) to its design identity in the asset-service.
type BarcodeScan struct {
	ID                string    `json:"id"`
	ProjectID         string    `json:"project_id"`
	ScanType          string    `json:"scan_type"`          // "barcode", "qr", "datamatrix"
	RawValue          string    `json:"raw_value"`          // decoded string
	SerialNumber      string    `json:"serial_number"`      // extracted serial
	Manufacturer      string    `json:"manufacturer,omitempty"`
	Model             string    `json:"model,omitempty"`
	DesignAssetID     string    `json:"design_asset_id,omitempty"` // mapped from layout
	AssetIdentityID   string    `json:"asset_identity_id,omitempty"` // created in twin-service
	InstalledPosition string    `json:"installed_position,omitempty"` // row/column/string ID
	Latitude          float64   `json:"latitude,omitempty"`
	Longitude         float64   `json:"longitude,omitempty"`
	ScannedAt         time.Time `json:"scanned_at"`
	ScannedBy         string    `json:"scanned_by"`
	Verified          bool      `json:"verified"`           // matched against BOM
}

// ========================================================================
// GPS-Guided Panel Placement Verification
// ========================================================================

// PlacementVerification compares the GPS-measured installed position of a
// module against its design position from the layout-service.
type PlacementVerification struct {
	ID               string  `json:"id"`
	ProjectID        string  `json:"project_id"`
	DesignAssetID    string  `json:"design_asset_id"`
	DesignLatitude   float64 `json:"design_latitude"`
	DesignLongitude  float64 `json:"design_longitude"`
	MeasuredLatitude float64 `json:"measured_latitude"`
	MeasuredLongitude float64 `json:"measured_longitude"`
	HorizontalErrorM float64 `json:"horizontal_error_m"`
	WithinTolerance  bool    `json:"within_tolerance"`
	ToleranceM       float64 `json:"tolerance_m"`        // typically 0.5m for utility-scale
	VerifiedAt       time.Time `json:"verified_at"`
	VerifiedBy       string  `json:"verified_by"`
}

// VerifyPlacement computes the placement error and checks tolerance.
// Uses the Haversine formula for GPS distance.
func VerifyPlacement(
	designLat, designLon, measuredLat, measuredLon, toleranceM float64,
) (errorM float64, withinTolerance bool) {
	errorM = haversineDistanceM(designLat, designLon, measuredLat, measuredLon)
	withinTolerance = errorM <= toleranceM
	return
}

func haversineDistanceM(lat1, lon1, lat2, lon2 float64) float64 {
	const earthRadiusM = 6371000.0
	dLat := (lat2 - lat1) * math.Pi / 180.0
	dLon := (lon2 - lon1) * math.Pi / 180.0
	lat1R := lat1 * math.Pi / 180.0
	lat2R := lat2 * math.Pi / 180.0

	a := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Cos(lat1R)*math.Cos(lat2R)*math.Sin(dLon/2)*math.Sin(dLon/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))
	return earthRadiusM * c
}
