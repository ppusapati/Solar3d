package repository

import (
	"context"
	"fmt"
	"sync"
	"time"

	"solar3d/compute-service/internal/models"
)

// ConstraintRepository defines zone data access operations.
type ConstraintRepository interface {
	// Zone CRUD
	CreateZone(ctx context.Context, zone *models.ConstraintZone) error
	GetZone(ctx context.Context, zoneID string) (*models.ConstraintZone, error)
	UpdateZone(ctx context.Context, zone *models.ConstraintZone) error
	DeleteZone(ctx context.Context, zoneID string, reason string) error
	ListZones(ctx context.Context, filter *models.ZoneQueryFilter) ([]*models.ConstraintZone, int64, error)

	// Spatial queries
	FindZonesIntersecting(ctx context.Context, projectID string, geometryWKT string) ([]*models.ConstraintZone, error)
	FindZonesContaining(ctx context.Context, projectID string, geometryWKT string) ([]*models.ConstraintZone, error)
	FindZonesNear(ctx context.Context, projectID string, lat float64, lon float64, radiusM float32) ([]*models.ConstraintZone, error)

	// History & audit
	AddZoneHistory(ctx context.Context, history *models.ZoneHistory) error
	GetZoneHistory(ctx context.Context, zoneID string, limit int32) ([]*models.ZoneHistory, error)

	// Permissions
	AddPermission(ctx context.Context, perm *models.ZonePermission) error
	GetPermissions(ctx context.Context, zoneID string) ([]*models.ZonePermission, error)
	CheckPermission(ctx context.Context, zoneID string, userID string) (string, error) // Returns permission level

	// Siting analysis
	CreateSitingAnalysis(ctx context.Context, analysis *models.SitingAnalysis) error
	GetSitingAnalysis(ctx context.Context, analysisID string) (*models.SitingAnalysis, error)
	AddSitingConflict(ctx context.Context, conflict *models.SitingConflict) error
	GetConflictsForAnalysis(ctx context.Context, analysisID string) ([]*models.SitingConflict, error)

	// Statistics
	GetZoneStats(ctx context.Context, projectID string) (*models.ConstraintZoneStats, error)
	GetZonesExpiringBefore(ctx context.Context, projectID string, before time.Time) ([]*models.ConstraintZone, error)

	// Bulk operations
	ImportZones(ctx context.Context, importReq *models.ZoneImportRequest) (*models.ZoneImportResult, error)

	// Cleanup
	PurgeDeletedZones(ctx context.Context, olderThan time.Time) (int64, error)
}

// MockConstraintRepository implements ConstraintRepository for testing.
type MockConstraintRepository struct {
	mu               sync.RWMutex
	zones            map[string]*models.ConstraintZone
	history          map[string][]*models.ZoneHistory
	permissions      map[string][]*models.ZonePermission
	sitingAnalyses   map[string]*models.SitingAnalysis
	sitingConflicts  map[string][]*models.SitingConflict
	nextZoneID       int64
	nextHistoryID    int64
	nextPermissionID int64
	nextAnalysisID   int64
	nextConflictID   int64
}

// NewMockConstraintRepository creates a new mock repository.
func NewMockConstraintRepository() *MockConstraintRepository {
	return &MockConstraintRepository{
		zones:           make(map[string]*models.ConstraintZone),
		history:         make(map[string][]*models.ZoneHistory),
		permissions:     make(map[string][]*models.ZonePermission),
		sitingAnalyses:  make(map[string]*models.SitingAnalysis),
		sitingConflicts: make(map[string][]*models.SitingConflict),
	}
}

// ================== Zone CRUD ==================

func (m *MockConstraintRepository) CreateZone(ctx context.Context, zone *models.ConstraintZone) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if _, exists := m.zones[zone.ZoneID]; exists {
		return fmt.Errorf("zone with ID %s already exists", zone.ZoneID)
	}

	m.nextZoneID++
	zone.ID = m.nextZoneID
	zone.CreatedAt = time.Now()
	zone.UpdatedAt = time.Now()

	m.zones[zone.ZoneID] = zone
	return nil
}

func (m *MockConstraintRepository) GetZone(ctx context.Context, zoneID string) (*models.ConstraintZone, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	zone, exists := m.zones[zoneID]
	if !exists {
		return nil, fmt.Errorf("zone not found: %s", zoneID)
	}
	return zone, nil
}

func (m *MockConstraintRepository) UpdateZone(ctx context.Context, zone *models.ConstraintZone) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, exists := m.zones[zone.ZoneID]
	if !exists {
		return fmt.Errorf("zone not found: %s", zone.ZoneID)
	}

	zone.ID = existing.ID
	zone.CreatedAt = existing.CreatedAt
	zone.UpdatedAt = time.Now()
	m.zones[zone.ZoneID] = zone
	return nil
}

func (m *MockConstraintRepository) DeleteZone(ctx context.Context, zoneID string, reason string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	zone, exists := m.zones[zoneID]
	if !exists {
		return fmt.Errorf("zone not found: %s", zoneID)
	}

	now := time.Now()
	zone.DeletedAt = &now
	zone.DeletedReason = reason
	zone.UpdatedAt = now
	return nil
}

func (m *MockConstraintRepository) ListZones(ctx context.Context, filter *models.ZoneQueryFilter) ([]*models.ConstraintZone, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*models.ConstraintZone

	for _, zone := range m.zones {
		// Skip deleted zones unless filtering for them
		if zone.DeletedAt != nil {
			continue
		}

		// Apply filters
		if filter.ProjectID != "" && zone.ProjectID != filter.ProjectID {
			continue
		}
		if filter.ZoneType != "" && zone.ZoneType != filter.ZoneType {
			continue
		}
		if filter.ZoneCategory != "" && zone.ZoneCategory != filter.ZoneCategory {
			continue
		}
		if filter.ZoneStatus != "" && zone.ZoneStatus != filter.ZoneStatus {
			continue
		}

		result = append(result, zone)
	}

	total := int64(len(result))

	// Apply pagination
	if filter.Limit > 0 {
		start := int(filter.Offset)
		end := start + int(filter.Limit)
		if start >= len(result) {
			result = []*models.ConstraintZone{}
		} else if end > len(result) {
			result = result[start:]
		} else {
			result = result[start:end]
		}
	}

	return result, total, nil
}

// ================== Spatial Queries ==================

func (m *MockConstraintRepository) FindZonesIntersecting(ctx context.Context, projectID string, geometryWKT string) ([]*models.ConstraintZone, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*models.ConstraintZone
	for _, zone := range m.zones {
		if zone.ProjectID == projectID && zone.DeletedAt == nil {
			// In mock, we do simple name-based filtering instead of true spatial queries
			// Real implementation would use PostGIS ST_Intersects
			result = append(result, zone)
		}
	}
	return result, nil
}

func (m *MockConstraintRepository) FindZonesContaining(ctx context.Context, projectID string, geometryWKT string) ([]*models.ConstraintZone, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*models.ConstraintZone
	for _, zone := range m.zones {
		if zone.ProjectID == projectID && zone.ZoneType == "INCLUSION" && zone.DeletedAt == nil {
			result = append(result, zone)
		}
	}
	return result, nil
}

func (m *MockConstraintRepository) FindZonesNear(ctx context.Context, projectID string, lat float64, lon float64, radiusM float32) ([]*models.ConstraintZone, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*models.ConstraintZone
	for _, zone := range m.zones {
		if zone.ProjectID == projectID && zone.DeletedAt == nil {
			// Mock: return active zones without true distance calculation
			if zone.ZoneStatus == "ACTIVE" {
				result = append(result, zone)
			}
		}
	}
	return result, nil
}

// ================== History & Audit ==================

func (m *MockConstraintRepository) AddZoneHistory(ctx context.Context, history *models.ZoneHistory) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.nextHistoryID++
	history.ID = m.nextHistoryID
	m.history[history.ZoneID] = append(m.history[history.ZoneID], history)
	return nil
}

func (m *MockConstraintRepository) GetZoneHistory(ctx context.Context, zoneID string, limit int32) ([]*models.ZoneHistory, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	history := m.history[zoneID]
	if limit > 0 && int32(len(history)) > limit {
		history = history[:limit]
	}
	return history, nil
}

// ================== Permissions ==================

func (m *MockConstraintRepository) AddPermission(ctx context.Context, perm *models.ZonePermission) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.nextPermissionID++
	perm.ID = m.nextPermissionID
	m.permissions[perm.ZoneID] = append(m.permissions[perm.ZoneID], perm)
	return nil
}

func (m *MockConstraintRepository) GetPermissions(ctx context.Context, zoneID string) ([]*models.ZonePermission, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	return m.permissions[zoneID], nil
}

func (m *MockConstraintRepository) CheckPermission(ctx context.Context, zoneID string, userID string) (string, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	perms := m.permissions[zoneID]
	for _, p := range perms {
		if p.UserID == userID {
			return p.Permission, nil
		}
	}
	return "", fmt.Errorf("no permission found for user %s on zone %s", userID, zoneID)
}

// ================== Siting Analysis ==================

func (m *MockConstraintRepository) CreateSitingAnalysis(ctx context.Context, analysis *models.SitingAnalysis) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.nextAnalysisID++
	analysis.AnalysisID = fmt.Sprintf("analysis-%d", m.nextAnalysisID)
	m.sitingAnalyses[analysis.AnalysisID] = analysis
	return nil
}

func (m *MockConstraintRepository) GetSitingAnalysis(ctx context.Context, analysisID string) (*models.SitingAnalysis, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	analysis, exists := m.sitingAnalyses[analysisID]
	if !exists {
		return nil, fmt.Errorf("analysis not found: %s", analysisID)
	}
	return analysis, nil
}

func (m *MockConstraintRepository) AddSitingConflict(ctx context.Context, conflict *models.SitingConflict) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.nextConflictID++
	conflict.ID = m.nextConflictID
	m.sitingConflicts[conflict.ConflictID] = append(m.sitingConflicts[conflict.ConflictID], conflict)
	return nil
}

func (m *MockConstraintRepository) GetConflictsForAnalysis(ctx context.Context, analysisID string) ([]*models.SitingConflict, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	// In mock, conflicts are keyed by conflict_id, not analysis_id
	// Real implementation would query by analysis_id
	var result []*models.SitingConflict
	for _, conflicts := range m.sitingConflicts {
		result = append(result, conflicts...)
	}
	return result, nil
}

// ================== Statistics ==================

func (m *MockConstraintRepository) GetZoneStats(ctx context.Context, projectID string) (*models.ConstraintZoneStats, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	stats := &models.ConstraintZoneStats{
		ProjectID:  projectID,
		ByType:     make(map[string]int32),
		ByCategory: make(map[string]int32),
	}

	var lastModified time.Time
	for _, zone := range m.zones {
		if zone.ProjectID == projectID && zone.DeletedAt == nil {
			stats.TotalZones++
			stats.ByType[zone.ZoneType]++
			stats.ByCategory[zone.ZoneCategory]++

			if zone.UpdatedAt.After(lastModified) {
				lastModified = zone.UpdatedAt
			}

			if zone.ZoneStatus == "ACTIVE" {
				stats.ActiveZones++
			} else if zone.ZoneStatus == "INACTIVE" {
				stats.InactiveZones++
			} else if zone.ZoneStatus == "EXPIRED" {
				stats.ExpiredZones++
			}
		}
	}

	stats.LastZoneModifiedAt = lastModified
	return stats, nil
}

func (m *MockConstraintRepository) GetZonesExpiringBefore(ctx context.Context, projectID string, before time.Time) ([]*models.ConstraintZone, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*models.ConstraintZone
	for _, zone := range m.zones {
		if zone.ProjectID == projectID && zone.DeletedAt == nil &&
			zone.EffectiveEndAt != nil && zone.EffectiveEndAt.Before(before) {
			result = append(result, zone)
		}
	}
	return result, nil
}

// ================== Bulk Operations ==================

func (m *MockConstraintRepository) ImportZones(ctx context.Context, importReq *models.ZoneImportRequest) (*models.ZoneImportResult, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	result := &models.ZoneImportResult{
		ImportID:   fmt.Sprintf("import-%d", m.nextAnalysisID+1),
		ProjectID:  importReq.ProjectID,
		TotalZones: int32(len(importReq.Zones)),
		ImportedAt: time.Now(),
	}

	for _, zone := range importReq.Zones {
		if _, exists := m.zones[zone.ZoneID]; exists {
			result.FailureCount++
			result.Errors = append(result.Errors, models.ZoneImportError{
				ZoneName:       zone.Name,
				Error:          "Zone already exists",
				Recommendation: "Skip or update existing zone",
			})
		} else {
			zone.CreatedAt = time.Now()
			zone.UpdatedAt = time.Now()
			m.zones[zone.ZoneID] = &zone
			result.SuccessCount++
		}
	}

	return result, nil
}

// ================== Cleanup ==================

func (m *MockConstraintRepository) PurgeDeletedZones(ctx context.Context, olderThan time.Time) (int64, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	var purged int64
	for zoneID, zone := range m.zones {
		if zone.DeletedAt != nil && zone.DeletedAt.Before(olderThan) {
			delete(m.zones, zoneID)
			purged++
		}
	}
	return purged, nil
}
