package models

import (
	"time"
)

// KMLUploadJob represents a KML/KMZ file upload and processing job.
type KMLUploadJob struct {
	ID                 int64
	UploadJobID        string // UUID
	FileName           string
	FileSizeBytes      int64
	FileHash           string // SHA256 for deduplication
	SourceCRSEPSG      int    // Detected CRS from KML
	TargetCRSEPSG      int    // Normalization target (default 4326)
	Status             string // PENDING, PROCESSING, COMPLETED, FAILED
	FeaturesTotal      int    // Total features in file
	FeaturesProcessed  int    // Features successfully parsed
	GeometriesImported int    // Geometries stored to DB
	ErrorMessage       string // Error if failed
	ProjectID          string // Optional project association
	UserID             string // User who uploaded
	Tags               map[string]string
	CreatedAt          time.Time
	StartedAt          *time.Time
	CompletedAt        *time.Time
}

// ImportedGeometry represents a single geometry imported from KML.
type ImportedGeometry struct {
	ID                 int64
	GeometryID         string // UUID
	UploadJobID        string // Reference to upload job
	FeatureName        string
	FeatureDescription string
	FeatureProperties  map[string]string // KML properties
	GeometryType       string            // POINT, LINESTRING, POLYGON, MULTIPOLYGON
	GeometrySourceCRS  int               // Original CRS
	GeometryData       string            // WKT or serialized format
	BBoxMinX           float64
	BBoxMinY           float64
	BBoxMaxX           float64
	BBoxMaxY           float64
	GeometryHash       string // SHA256 for deduplication
	IsValid            bool
	ValidationErrors   string
	ImportedAt         time.Time
	DeletedAt          *time.Time
}

// GeometryCollection groups imported geometries.
type GeometryCollection struct {
	ID           int64
	CollectionID string // UUID
	Name         string
	Description  string
	ProjectID    string
	CreatedBy    string
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// UploadKMLRequest is the domain request to upload a KML/KMZ file.
type UploadKMLRequest struct {
	FileData  []byte            // Raw file bytes
	FileName  string            // Name with extension
	SourceCRS int               // Optional EPSG code (default 4326)
	ProjectID string            // Optional project association
	Tags      map[string]string // Metadata tags
}

// UploadKMLResponse is the domain response to upload initiation.
type UploadKMLResponse struct {
	UploadJobID string // UUID for tracking
	Status      string // Initial status
	CreatedAt   time.Time
}

// GetUploadStatusRequest retrieves upload job status.
type GetUploadStatusRequest struct {
	UploadJobID string
}

// GetUploadStatusResponse returns current status and progress.
type GetUploadStatusResponse struct {
	UploadJobID       string
	Status            string
	FeaturesProcessed int
	TotalFeatures     int
	ErrorMessage      string
	DetectedCRS       int
	StartedAt         *time.Time
	CompletedAt       *time.Time
}

// ListImportedGeometriesRequest retrieves geometries from upload.
type ListImportedGeometriesRequest struct {
	UploadJobID  string
	GeometryType string // Optional filter
	Limit        int
	Offset       int
}

// ListImportedGeometriesResponse returns paginated geometry list.
type ListImportedGeometriesResponse struct {
	Geometries []*ImportedGeometryStub
	TotalCount int64
}

// ImportedGeometryStub is a summary of an imported geometry.
type ImportedGeometryStub struct {
	GeometryID   string
	Name         string
	GeometryType string
	BoundingBox  BoundingBoxModel
	FeatureCount int
}

// GetImportedGeometryRequest retrieves full geometry details.
type GetImportedGeometryRequest struct {
	UploadJobID string
	GeometryID  string
}

// GetImportedGeometryResponse returns full geometry details.
type GetImportedGeometryResponse struct {
	GeometryID        string
	Name              string
	Description       string
	Properties        map[string]string
	GeometryType      string
	SourceCRS         int
	CanonicalGeometry string // WKT or serialized
	BoundingBox       BoundingBoxModel
	GeometryHash      string
	ImportedAt        time.Time
}

// DeleteUploadRequest removes upload and geometries.
type DeleteUploadRequest struct {
	UploadJobID string
}

// DeleteUploadResponse confirms deletion.
type DeleteUploadResponse struct {
	UploadJobID       string
	Deleted           bool
	GeometriesDeleted int64
}
