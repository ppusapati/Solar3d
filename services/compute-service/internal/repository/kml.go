package repository

import (
	"context"
	"fmt"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
)

// KMLRepository defines the interface for KML ingestion and geometry storage operations.
type KMLRepository interface {
	// Upload jobs
	CreateUploadJob(ctx context.Context, job *models.KMLUploadJob) (string, error)
	GetUploadJob(ctx context.Context, uploadJobID string) (*models.KMLUploadJob, error)
	UpdateUploadJobStatus(ctx context.Context, uploadJobID, status string, errorMsg *string, completedAt time.Time, featuresTotal, geometriesImported int) error
	UpdateUploadJobProgress(ctx context.Context, uploadJobID string, featuresTotal, geometriesImported int) error
	ListUploadJobs(ctx context.Context, projectID string, limit, offset int) ([]*models.KMLUploadJob, int64, error)
	DeleteUpload(ctx context.Context, uploadJobID string) (int64, error)

	// Imported geometries
	CreateGeometry(ctx context.Context, geom *models.ImportedGeometry) (string, error)
	GetGeometry(ctx context.Context, geometryID string) (*models.ImportedGeometry, error)
	ListGeometries(ctx context.Context, uploadJobID string, geometryType string, limit, offset int) ([]*models.ImportedGeometry, int64, error)
	ListGeometriesByProject(ctx context.Context, projectID string, limit int) ([]*models.ImportedGeometry, error)
	UpdateGeometry(ctx context.Context, geometry *models.ImportedGeometry) error
	DeleteGeometry(ctx context.Context, geometryID string) error
	SoftDeleteGeometry(ctx context.Context, geometryID string) error

	// Geometry collections
	CreateCollection(ctx context.Context, collection *models.GeometryCollection) (string, error)
	GetCollection(ctx context.Context, collectionID string) (*models.GeometryCollection, error)
	UpdateCollection(ctx context.Context, collection *models.GeometryCollection) error
	DeleteCollection(ctx context.Context, collectionID string) error

	// Geometry collection items
	AddGeometryToCollection(ctx context.Context, collectionID, geometryID string, sortOrder int) error
	RemoveGeometryFromCollection(ctx context.Context, collectionID, geometryID string) error
	ListCollectionGeometries(ctx context.Context, collectionID string) ([]*models.ImportedGeometry, error)

	// Queries and searches
	SearchGeometriesByBoundingBox(ctx context.Context, minX, minY, maxX, maxY float64) ([]*models.ImportedGeometry, error)
	FindDuplicateGeometries(ctx context.Context, uploadJobID string) ([][]string, error) // Groups of duplicate geometry IDs
	GetUploadStatistics(ctx context.Context, uploadJobID string) (map[string]interface{}, error)

	// Audit log
	LogAuditEvent(ctx context.Context, operation string, uploadJobID, geometryID string, status string, errorMsg string) error
	GetAuditEvents(ctx context.Context, uploadJobID string, limit int) ([]map[string]interface{}, error)

	// Maintenance
	CleanupOldJobs(ctx context.Context, keepDays int) (int64, error)
	CleanupOrphanedGeometries(ctx context.Context) (int64, error)
}

// MockKMLRepository for testing purposes
type MockKMLRepository struct {
	uploadJobs   map[string]*models.KMLUploadJob
	geometries   map[string]*models.ImportedGeometry
	collections  map[string]*models.GeometryCollection
	auditLog     []map[string]interface{}
	nextUploadID int64
	nextGeomID   int64
}

// NewMockKMLRepository creates a new mock repository
func NewMockKMLRepository() *MockKMLRepository {
	return &MockKMLRepository{
		uploadJobs:  make(map[string]*models.KMLUploadJob),
		geometries:  make(map[string]*models.ImportedGeometry),
		collections: make(map[string]*models.GeometryCollection),
		auditLog:    make([]map[string]interface{}, 0),
	}
}

func (m *MockKMLRepository) CreateUploadJob(ctx context.Context, job *models.KMLUploadJob) (string, error) {
	if job.UploadJobID == "" {
		m.nextUploadID++
		job.UploadJobID = fmt.Sprintf("test-upload-%d", m.nextUploadID)
	}
	m.uploadJobs[job.UploadJobID] = job
	return job.UploadJobID, nil
}

func (m *MockKMLRepository) GetUploadJob(ctx context.Context, uploadJobID string) (*models.KMLUploadJob, error) {
	return m.uploadJobs[uploadJobID], nil
}

func (m *MockKMLRepository) UpdateUploadJobStatus(ctx context.Context, uploadJobID, status string, errorMsg *string, completedAt time.Time, featuresTotal, geometriesImported int) error {
	if job, ok := m.uploadJobs[uploadJobID]; ok {
		job.Status = status
		job.FeaturesTotal = featuresTotal
		job.GeometriesImported = geometriesImported
		if errorMsg != nil {
			job.ErrorMessage = *errorMsg
		}
		if !completedAt.IsZero() {
			job.CompletedAt = &completedAt
		}
	}
	return nil
}

func (m *MockKMLRepository) UpdateUploadJobProgress(ctx context.Context, uploadJobID string, featuresTotal, geometriesImported int) error {
	if job, ok := m.uploadJobs[uploadJobID]; ok {
		job.FeaturesTotal = featuresTotal
		job.FeaturesProcessed = geometriesImported
	}
	return nil
}

func (m *MockKMLRepository) ListUploadJobs(ctx context.Context, projectID string, limit, offset int) ([]*models.KMLUploadJob, int64, error) {
	return nil, 0, nil
}

func (m *MockKMLRepository) DeleteUpload(ctx context.Context, uploadJobID string) (int64, error) {
	delete(m.uploadJobs, uploadJobID)
	count := int64(len(m.geometries))
	m.geometries = make(map[string]*models.ImportedGeometry)
	return count, nil
}

func (m *MockKMLRepository) CreateGeometry(ctx context.Context, geom *models.ImportedGeometry) (string, error) {
	if geom.GeometryID == "" {
		m.nextGeomID++
		geom.GeometryID = fmt.Sprintf("geom-%d", m.nextGeomID)
	}
	m.geometries[geom.GeometryID] = geom
	return geom.GeometryID, nil
}

func (m *MockKMLRepository) GetGeometry(ctx context.Context, geometryID string) (*models.ImportedGeometry, error) {
	return m.geometries[geometryID], nil
}

func (m *MockKMLRepository) ListGeometries(ctx context.Context, uploadJobID string, geometryType string, limit, offset int) ([]*models.ImportedGeometry, int64, error) {
	var results []*models.ImportedGeometry
	for _, g := range m.geometries {
		if g.UploadJobID == uploadJobID {
			if geometryType == "" || g.GeometryType == geometryType {
				results = append(results, g)
			}
		}
	}
	return results, int64(len(results)), nil
}

func (m *MockKMLRepository) ListGeometriesByProject(ctx context.Context, projectID string, limit int) ([]*models.ImportedGeometry, error) {
	return nil, nil
}

func (m *MockKMLRepository) UpdateGeometry(ctx context.Context, geometry *models.ImportedGeometry) error {
	m.geometries[geometry.GeometryID] = geometry
	return nil
}

func (m *MockKMLRepository) DeleteGeometry(ctx context.Context, geometryID string) error {
	delete(m.geometries, geometryID)
	return nil
}

func (m *MockKMLRepository) SoftDeleteGeometry(ctx context.Context, geometryID string) error {
	if geom, ok := m.geometries[geometryID]; ok {
		now := time.Now()
		geom.DeletedAt = &now
	}
	return nil
}

func (m *MockKMLRepository) CreateCollection(ctx context.Context, collection *models.GeometryCollection) (string, error) {
	m.collections[collection.CollectionID] = collection
	return collection.CollectionID, nil
}

func (m *MockKMLRepository) GetCollection(ctx context.Context, collectionID string) (*models.GeometryCollection, error) {
	return m.collections[collectionID], nil
}

func (m *MockKMLRepository) UpdateCollection(ctx context.Context, collection *models.GeometryCollection) error {
	m.collections[collection.CollectionID] = collection
	return nil
}

func (m *MockKMLRepository) DeleteCollection(ctx context.Context, collectionID string) error {
	delete(m.collections, collectionID)
	return nil
}

func (m *MockKMLRepository) AddGeometryToCollection(ctx context.Context, collectionID, geometryID string, sortOrder int) error {
	return nil
}

func (m *MockKMLRepository) RemoveGeometryFromCollection(ctx context.Context, collectionID, geometryID string) error {
	return nil
}

func (m *MockKMLRepository) ListCollectionGeometries(ctx context.Context, collectionID string) ([]*models.ImportedGeometry, error) {
	return nil, nil
}

func (m *MockKMLRepository) SearchGeometriesByBoundingBox(ctx context.Context, minX, minY, maxX, maxY float64) ([]*models.ImportedGeometry, error) {
	return nil, nil
}

func (m *MockKMLRepository) FindDuplicateGeometries(ctx context.Context, uploadJobID string) ([][]string, error) {
	return nil, nil
}

func (m *MockKMLRepository) GetUploadStatistics(ctx context.Context, uploadJobID string) (map[string]interface{}, error) {
	return nil, nil
}

func (m *MockKMLRepository) LogAuditEvent(ctx context.Context, operation string, uploadJobID, geometryID string, status string, errorMsg string) error {
	return nil
}

func (m *MockKMLRepository) GetAuditEvents(ctx context.Context, uploadJobID string, limit int) ([]map[string]interface{}, error) {
	return nil, nil
}

func (m *MockKMLRepository) CleanupOldJobs(ctx context.Context, keepDays int) (int64, error) {
	return 0, nil
}

func (m *MockKMLRepository) CleanupOrphanedGeometries(ctx context.Context) (int64, error) {
	return 0, nil
}
