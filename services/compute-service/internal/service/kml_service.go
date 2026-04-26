package service

import (
	"archive/zip"
	"bytes"
	"context"
	"crypto/sha256"
	"fmt"
	"io"
	"log"
	"strings"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/parser"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

// KMLService orchestrates KML ingestion, parsing, and geometry storage.
type KMLService struct {
	repo       repository.KMLRepository
	normalizer *parser.CRSNormalizer
}

// NewKMLService creates a new KML ingestion service.
func NewKMLService(repo repository.KMLRepository) *KMLService {
	return &KMLService{
		repo:       repo,
		normalizer: parser.NewCRSNormalizer(),
	}
}

// UploadKML initiates async KML/KMZ processing.
func (s *KMLService) UploadKML(ctx context.Context, fileData []byte, fileName string, sourceCRS int, projectID string, tags map[string]string) (string, error) {
	if fileData == nil || len(fileData) == 0 {
		return "", fmt.Errorf("file data is empty")
	}

	if fileName == "" {
		return "", fmt.Errorf("file name is required")
	}

	// Validate file type (KML or KMZ)
	if !strings.HasSuffix(strings.ToLower(fileName), ".kml") && !strings.HasSuffix(strings.ToLower(fileName), ".kmz") {
		return "", fmt.Errorf("file must be KML or KMZ format")
	}

	if len(fileData) > 100*1024*1024 { // 100MB limit
		return "", fmt.Errorf("file size exceeds 100MB limit")
	}

	// Calculate file hash for deduplication
	fileHash := calculateHash(fileData)

	// Create upload job record
	uploadJobID, err := s.repo.CreateUploadJob(ctx, &models.KMLUploadJob{
		FileName:      fileName,
		FileSizeBytes: int64(len(fileData)),
		FileHash:      fileHash,
		SourceCRSEPSG: sourceCRS,
		TargetCRSEPSG: 4326, // Always normalize to WGS84
		Status:        "PENDING",
		ProjectID:     projectID,
		Tags:          tags,
		CreatedAt:     time.Now(),
	})

	if err != nil {
		return "", fmt.Errorf("failed to create upload job: %w", err)
	}

	// Parse and import asynchronously
	// In production, this would be queued to a job processor
	go s.processUploadAsync(context.Background(), uploadJobID, fileData, fileName)

	return uploadJobID, nil
}

// GetUploadStatus retrieves the status of a KML upload job.
func (s *KMLService) GetUploadStatus(ctx context.Context, uploadJobID string) (*models.KMLUploadJob, error) {
	if uploadJobID == "" {
		return nil, fmt.Errorf("upload job ID is required")
	}

	job, err := s.repo.GetUploadJob(ctx, uploadJobID)
	if err != nil {
		return nil, fmt.Errorf("failed to get upload job: %w", err)
	}

	if job == nil {
		return nil, fmt.Errorf("upload job not found")
	}

	return job, nil
}

// ListImportedGeometries retrieves geometries from a completed upload.
func (s *KMLService) ListImportedGeometries(ctx context.Context, uploadJobID string, geometryType string, limit, offset int) ([]*models.ImportedGeometry, int64, error) {
	if uploadJobID == "" {
		return nil, 0, fmt.Errorf("upload job ID is required")
	}

	if limit <= 0 {
		limit = 50
	}
	if limit > 1000 {
		limit = 1000
	}
	if offset < 0 {
		offset = 0
	}

	geometries, totalCount, err := s.repo.ListGeometries(ctx, uploadJobID, geometryType, limit, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to list geometries: %w", err)
	}

	return geometries, totalCount, nil
}

// GetImportedGeometry retrieves full details of a single geometry.
func (s *KMLService) GetImportedGeometry(ctx context.Context, geometryID string) (*models.ImportedGeometry, error) {
	if geometryID == "" {
		return nil, fmt.Errorf("geometry ID is required")
	}

	geom, err := s.repo.GetGeometry(ctx, geometryID)
	if err != nil {
		return nil, fmt.Errorf("failed to get geometry: %w", err)
	}

	if geom == nil {
		return nil, fmt.Errorf("geometry not found")
	}

	return geom, nil
}

// DeleteUpload removes an upload job and associated geometries.
func (s *KMLService) DeleteUpload(ctx context.Context, uploadJobID string) (int64, error) {
	if uploadJobID == "" {
		return 0, fmt.Errorf("upload job ID is required")
	}

	count, err := s.repo.DeleteUpload(ctx, uploadJobID)
	if err != nil {
		return 0, fmt.Errorf("failed to delete upload: %w", err)
	}

	return count, nil
}

// --- Private methods ---

// processUploadAsync handles the async parsing and import of KML files.
func (s *KMLService) processUploadAsync(ctx context.Context, uploadJobID string, fileData []byte, fileName string) {
	// Update status to PROCESSING
	_ = s.repo.UpdateUploadJobStatus(ctx, uploadJobID, "PROCESSING", nil, time.Now(), 0, 0)

	// Determine file type and parse
	var kmlDoc *parser.KMLDocument
	var err error

	fileName = strings.ToLower(fileName)
	if strings.HasSuffix(fileName, ".kmz") {
		kmlDoc, err = parser.ParseKMZ(fileData)
	} else {
		kmlDoc, err = parser.ParseKML(fileData)
	}

	if err != nil {
		errMsg := fmt.Sprintf("Failed to parse KML: %v", err)
		if updErr := s.repo.UpdateUploadJobStatus(ctx, uploadJobID, "FAILED", &errMsg, time.Now(), 0, 0); updErr != nil {
			log.Printf("event=kml.status_update_failed job_id=%s err=%v", uploadJobID, updErr)
		}
		return
	}

	// Process parsed features
	geometriesImported := 0
	var parseErrors []string

	for idx, feature := range kmlDoc.Features {
		if feature.Geometry == nil {
			parseErrors = append(parseErrors, fmt.Sprintf("Feature %d (%s) has no geometry", idx, feature.Name))
			continue
		}

		// Validate geometry
		if !s.validateGeometry(feature.Geometry) {
			parseErrors = append(parseErrors, fmt.Sprintf("Feature %d (%s) has invalid geometry", idx, feature.Name))
			continue
		}

		// Normalize CRS if needed
		normalizedGeom := s.normalizer.CoerceToWGS84(feature.Geometry, kmlDoc.CRS)

		// Calculate bounding box
		bbox := parser.CalculateBoundingBox(normalizedGeom)
		if bbox == nil {
			parseErrors = append(parseErrors, fmt.Sprintf("Feature %d (%s) has invalid bounding box", idx, feature.Name))
			continue
		}

		geomHash := calculateHash([]byte(fmt.Sprintf("%v", feature.Geometry)))

		// Create imported geometry record
		importedGeom := &models.ImportedGeometry{
			UploadJobID:        uploadJobID,
			FeatureName:        feature.Name,
			FeatureDescription: feature.Description,
			FeatureProperties:  feature.Properties,
			GeometryType:       feature.Geometry.Type,
			GeometrySourceCRS:  kmlDoc.CRS,
			GeometryData:       serializeGeometry(normalizedGeom),
			BBoxMinX:           bbox.MinX,
			BBoxMinY:           bbox.MinY,
			BBoxMaxX:           bbox.MaxX,
			BBoxMaxY:           bbox.MaxY,
			GeometryHash:       geomHash,
			IsValid:            true,
			ImportedAt:         time.Now(),
		}

		// Store geometry
		_, err := s.repo.CreateGeometry(ctx, importedGeom)
		if err != nil {
			parseErrors = append(parseErrors, fmt.Sprintf("Feature %d (%s) failed to store: %v", idx, feature.Name, err))
			continue
		}

		geometriesImported++

		// Update progress (best-effort — a transient progress write failure
		// must not abort the import; the final status update is the source of truth)
		if err := s.repo.UpdateUploadJobProgress(ctx, uploadJobID, len(kmlDoc.Features), geometriesImported); err != nil {
			log.Printf("event=kml.progress_update_failed job_id=%s err=%v", uploadJobID, err)
		}
	}

	// Finalize upload job
	if geometriesImported > 0 {
		if err := s.repo.UpdateUploadJobStatus(ctx, uploadJobID, "COMPLETED", nil, time.Now(), len(kmlDoc.Features), geometriesImported); err != nil {
			log.Printf("event=kml.status_update_failed job_id=%s err=%v", uploadJobID, err)
		}
	} else {
		errMsg := "No valid geometries were imported"
		if err := s.repo.UpdateUploadJobStatus(ctx, uploadJobID, "FAILED", &errMsg, time.Now(), len(kmlDoc.Features), 0); err != nil {
			log.Printf("event=kml.status_update_failed job_id=%s err=%v", uploadJobID, err)
		}
	}
}

// validateGeometry checks if a geometry is valid and non-empty.
func (s *KMLService) validateGeometry(geom *parser.KMLGeometry) bool {
	if geom == nil {
		return false
	}

	switch geom.Type {
	case "Point":
		return len(geom.Points) > 0
	case "LineString":
		return len(geom.Points) >= 2
	case "Polygon":
		return len(geom.Rings) > 0 && len(geom.Rings[0].Points) >= 4
	case "MultiGeometry":
		return len(geom.Geometries) > 0
	default:
		return false
	}
}

// serializeGeometry converts a geometry to WKT or JSON for storage.
func serializeGeometry(geom *parser.KMLGeometry) string {
	// For now, serialize to a simple JSON-like format
	// In production, this would be WKT for PostGIS
	return fmt.Sprintf(`{"type":"%s","data":%v}`, geom.Type, geom)
}

// calculateHash calculates SHA256 hash of data.
func calculateHash(data []byte) string {
	hash := sha256.Sum256(data)
	return fmt.Sprintf("%x", hash)
}

// IsKMZ checks if file is KMZ format.
func isKMZ(data []byte) bool {
	// Check for ZIP magic number: PK\x03\x04
	return len(data) >= 4 && data[0] == 0x50 && data[1] == 0x4B && data[2] == 0x03 && data[3] == 0x04
}

// ExtractKMLFromKMZ extracts the first KML file from a KMZ archive.
func extractKMLFromKMZ(data []byte) ([]byte, error) {
	if !isKMZ(data) {
		return nil, fmt.Errorf("not a valid KMZ file")
	}

	reader := bytes.NewReader(data)
	zr, err := zip.NewReader(reader, int64(len(data)))
	if err != nil {
		return nil, fmt.Errorf("failed to read KMZ: %w", err)
	}

	// Find first KML file
	for _, f := range zr.File {
		if strings.HasSuffix(strings.ToLower(f.Name), ".kml") {
			rc, err := f.Open()
			if err != nil {
				return nil, err
			}
			defer rc.Close()
			return io.ReadAll(rc)
		}
	}

	return nil, fmt.Errorf("no KML file found in KMZ archive")
}
