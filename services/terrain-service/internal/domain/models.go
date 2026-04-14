package domain

import (
	"fmt"
	"time"

	"github.com/google/uuid"
)

// LayerType represents the type of terrain analysis layer.
type LayerType string

const (
	LayerTypeDEM       LayerType = "DEM"
	LayerTypeSlope     LayerType = "Slope"
	LayerTypeAspect    LayerType = "Aspect"
	LayerTypeHillshade LayerType = "Hillshade"
)

// ValidLayerTypes enumerates all accepted layer types.
var ValidLayerTypes = map[LayerType]bool{
	LayerTypeDEM:       true,
	LayerTypeSlope:     true,
	LayerTypeAspect:    true,
	LayerTypeHillshade: true,
}

// ParseLayerType converts a string to a validated LayerType.
func ParseLayerType(s string) (LayerType, error) {
	lt := LayerType(s)
	if !ValidLayerTypes[lt] {
		return "", fmt.Errorf("invalid layer type %q: must be one of DEM, Slope, Aspect, Hillshade", s)
	}
	return lt, nil
}

// BoundingBox represents a geographic bounding box in the layer's CRS.
type BoundingBox struct {
	MinX float64 `json:"min_x"`
	MinY float64 `json:"min_y"`
	MaxX float64 `json:"max_x"`
	MaxY float64 `json:"max_y"`
}

// Valid checks that the bounding box has non-zero area and correct ordering.
func (b BoundingBox) Valid() bool {
	return b.MinX < b.MaxX && b.MinY < b.MaxY
}

// TerrainLayer is the core domain entity representing a terrain data layer
// associated with a solar EPC project.
type TerrainLayer struct {
	ID           uuid.UUID   `json:"id"`
	ProjectID    uuid.UUID   `json:"project_id"`
	Name         string      `json:"name"`
	LayerType    LayerType   `json:"layer_type"`
	SourceFile   string      `json:"source_file"`
	Bounds       BoundingBox `json:"bounds"`
	ResolutionM  float64     `json:"resolution_m"`
	CRS          string      `json:"crs"`
	MinElevation float64     `json:"min_elevation"`
	MaxElevation float64     `json:"max_elevation"`
	CreatedAt    time.Time   `json:"created_at"`
}

// ElevationGrid holds a rectangular grid of elevation values, typically
// extracted from a DEM for a given bounding region.
type ElevationGrid struct {
	Width      int       `json:"width"`
	Height     int       `json:"height"`
	Elevations []float64 `json:"elevations"`
	MinElev    float64   `json:"min_elev"`
	MaxElev    float64   `json:"max_elev"`
}

// ElevationPoint represents a single elevation query result.
type ElevationPoint struct {
	X         float64 `json:"x"`
	Y         float64 `json:"y"`
	Elevation float64 `json:"elevation"`
}

// ============================================================
// Copernicus DEM Caching Models
// ============================================================

// CopernicusDEMJobStatus tracks the state of a DEM download job
type CopernicusDEMJobStatus string

const (
	DEMJobStatusPending     CopernicusDEMJobStatus = "pending"
	DEMJobStatusDownloading CopernicusDEMJobStatus = "downloading"
	DEMJobStatusIngesting   CopernicusDEMJobStatus = "ingesting"
	DEMJobStatusCompleted   CopernicusDEMJobStatus = "completed"
	DEMJobStatusFailed      CopernicusDEMJobStatus = "failed"
)

// CopernicusDEMJob represents a background job for downloading and ingesting Copernicus DEM data
type CopernicusDEMJob struct {
	ID                  uuid.UUID              `json:"id"`
	TerrainLayerID      uuid.UUID              `json:"terrain_layer_id"`
	ProjectID           uuid.UUID              `json:"project_id"`
	Status              CopernicusDEMJobStatus `json:"status"`
	ProgressPercent     int                    `json:"progress_percent"`
	SourceURI           string                 `json:"source_uri"`
	Bounds              BoundingBox            `json:"bounds"`
	ResolutionM         float64                `json:"resolution_m"`
	TotalTilesRequested int                    `json:"total_tiles_requested"`
	TilesDownloaded     int                    `json:"tiles_downloaded"`
	TilesIngested       int                    `json:"tiles_ingested"`
	TilesFailed         int                    `json:"tiles_failed"`
	ErrorMessage        string                 `json:"error_message,omitempty"`
	RetryCount          int                    `json:"retry_count"`
	MaxRetries          int                    `json:"max_retries"`
	StartedAt           *time.Time             `json:"started_at,omitempty"`
	CompletedAt         *time.Time             `json:"completed_at,omitempty"`
	NextRetryAt         *time.Time             `json:"next_retry_at,omitempty"`
	CreatedAt           time.Time              `json:"created_at"`
	UpdatedAt           time.Time              `json:"updated_at"`
}

// DEMTileCache represents a cached DEM tile with elevation data
type DEMTileCache struct {
	ID              uuid.UUID   `json:"id"`
	ProjectID       uuid.UUID   `json:"project_id"`
	TerrainLayerID  uuid.UUID   `json:"terrain_layer_id"`
	TileRow         int         `json:"tile_row"`
	TileCol         int         `json:"tile_col"`
	SourceURI       string      `json:"source_uri"`
	Bounds          BoundingBox `json:"bounds"`
	ElevationData   []byte      `json:"elevation_data,omitempty"` // Compressed GeoTIFF
	Width           int         `json:"width"`
	Height          int         `json:"height"`
	ResolutionM     float64     `json:"resolution_m"`
	MinElevation    float64     `json:"min_elevation"`
	MaxElevation    float64     `json:"max_elevation"`
	SourceTimestamp *time.Time  `json:"source_timestamp,omitempty"`
	IngestedAt      time.Time   `json:"ingested_at"`
	ExpiresAt       *time.Time  `json:"expires_at,omitempty"`
	Checksum        string      `json:"checksum,omitempty"`
}

// CopernicusManifestEntry tracks downloaded GeoTIFF files to avoid re-fetching
type CopernicusManifestEntry struct {
	ID                 uuid.UUID   `json:"id"`
	CopernicusFilename string      `json:"copernicus_filename"`
	SourceURL          string      `json:"source_url"`
	Bounds             BoundingBox `json:"bounds"`
	FileSizeBytes      int64       `json:"file_size_bytes,omitempty"`
	Checksum           string      `json:"checksum,omitempty"`
	Status             string      `json:"status"` // pending, downloading, cached, failed
	LocalCachePath     string      `json:"local_cache_path,omitempty"`
	DownloadedAt       *time.Time  `json:"downloaded_at,omitempty"`
	ExpiresAt          *time.Time  `json:"expires_at,omitempty"`
	CreatedAt          time.Time   `json:"created_at"`
}

// DEMMetrics summarizes Copernicus DEM job and tile-cache health for monitoring.
type DEMMetrics struct {
	ProjectID        *uuid.UUID `json:"project_id,omitempty"`
	PendingJobs      int        `json:"pending_jobs"`
	DownloadingJobs  int        `json:"downloading_jobs"`
	IngestingJobs    int        `json:"ingesting_jobs"`
	CompletedJobs    int        `json:"completed_jobs"`
	FailedJobs       int        `json:"failed_jobs"`
	CachedTileCount  int        `json:"cached_tile_count"`
	CachedBytes      int64      `json:"cached_bytes"`
	ExpiredTileCount int        `json:"expired_tile_count"`
}

