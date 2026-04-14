package service

import (
	"context"
	"crypto/sha256"
	"fmt"
	"io"
	"math"
	"time"

	"solar3d/compute-service/internal/models"
	"solar3d/compute-service/internal/repository"

	"github.com/google/uuid"
)

// ConstraintZoneService implements business logic for zone management.
type ConstraintZoneService struct {
	repo repository.ConstraintRepository
}

// NewConstraintZoneService creates a new zone service.
func NewConstraintZoneService(repo repository.ConstraintRepository) *ConstraintZoneService {
	return &ConstraintZoneService{
		repo: repo,
	}
}

// CreateZone creates a new constraint zone with validation.
func (s *ConstraintZoneService) CreateZone(ctx context.Context, zone *models.ConstraintZone) (*models.ConstraintZone, error) {
	// Validation
	if zone.Name == "" {
		return nil, fmt.Errorf("zone name is required")
	}
	if zone.ZoneType == "" {
		return nil, fmt.Errorf("zone type is required")
	}
	if zone.GeometryWKT == "" {
		return nil, fmt.Errorf("geometry is required")
	}
	if zone.ProjectID == "" {
		return nil, fmt.Errorf("project_id is required")
	}
	if zone.CreatedBy == "" {
		return nil, fmt.Errorf("created_by is required")
	}

	// Validate zone type
	validTypes := map[string]bool{"EXCLUSION": true, "INCLUSION": true, "BUFFER": true}
	if !validTypes[zone.ZoneType] {
		return nil, fmt.Errorf("invalid zone type: %s", zone.ZoneType)
	}

	// Validate category
	validCategories := map[string]bool{
		"GEOLOGICAL": true, "ENVIRONMENTAL": true, "REGULATORY": true,
		"INFRASTRUCTURE": true, "MILITARY": true, "PROTECTED": true,
	}
	if !validCategories[zone.ZoneCategory] {
		return nil, fmt.Errorf("invalid zone category: %s", zone.ZoneCategory)
	}

	// Set defaults
	if zone.ZoneStatus == "" {
		zone.ZoneStatus = "ACTIVE"
	}
	if zone.EffectiveStartAt == nil {
		now := time.Now()
		zone.EffectiveStartAt = &now

		// Generate UUID
		if zone.ZoneID == "" {
			zone.ZoneID = uuid.New().String()
		}
	}

	// Create zone
	if err := s.repo.CreateZone(ctx, zone); err != nil {
		return nil, fmt.Errorf("failed to create zone: %w", err)
	}

	// Log creation in history
	s.repo.AddZoneHistory(ctx, &models.ZoneHistory{
		ZoneID:       zone.ZoneID,
		ChangeType:   "CREATE",
		NewValues:    map[string]string{"zone_type": zone.ZoneType, "zone_category": zone.ZoneCategory},
		ChangedBy:    zone.CreatedBy,
		ChangeReason: "Zone creation",
		ChangedAt:    time.Now(),
	})

	return zone, nil
}

// UpdateZone updates an existing zone.
func (s *ConstraintZoneService) UpdateZone(ctx context.Context, zone *models.ConstraintZone) (*models.ConstraintZone, error) {
	// Verify zone exists
	existing, err := s.repo.GetZone(ctx, zone.ZoneID)
	if err != nil {
		return nil, fmt.Errorf("zone not found: %w", err)
	}

	// Check permission (simplified - real would check actual permissions)
	if zone.CreatedBy != existing.CreatedBy && zone.CreatedBy != "admin" {
		return nil, fmt.Errorf("permission denied: only zone creator or admin can update")
	}

	// Update
	if err := s.repo.UpdateZone(ctx, zone); err != nil {
		return nil, fmt.Errorf("failed to update zone: %w", err)
	}

	// Log update in history
	s.repo.AddZoneHistory(ctx, &models.ZoneHistory{
		ZoneID:       zone.ZoneID,
		ChangeType:   "UPDATE",
		OldValues:    map[string]string{"zone_status": existing.ZoneStatus},
		NewValues:    map[string]string{"zone_status": zone.ZoneStatus},
		ChangedBy:    zone.CreatedBy,
		ChangeReason: "Zone update",
		ChangedAt:    time.Now(),
	})

	return zone, nil
}

// DeleteZone soft-deletes a zone (marks as deleted but retains for audit).
func (s *ConstraintZoneService) DeleteZone(ctx context.Context, zoneID string, userID string, reason string) error {
	zone, err := s.repo.GetZone(ctx, zoneID)
	if err != nil {
		return fmt.Errorf("zone not found: %w", err)
	}

	// Check permission
	if userID != zone.CreatedBy && userID != "admin" {
		return fmt.Errorf("permission denied: only zone creator or admin can delete")
	}

	// Soft delete
	now := time.Now()
	zone.DeletedAt = &now
	zone.DeletedReason = reason

	if err := s.repo.DeleteZone(ctx, zoneID, reason); err != nil {
		return fmt.Errorf("failed to delete zone: %w", err)
	}

	// Log deletion
	s.repo.AddZoneHistory(ctx, &models.ZoneHistory{
		ZoneID:       zoneID,
		ChangeType:   "DELETE",
		ChangedBy:    userID,
		ChangeReason: reason,
		ChangedAt:    time.Now(),
	})

	return nil
}

// ListZones retrieves zones with filtering.
func (s *ConstraintZoneService) ListZones(ctx context.Context, projectID string, zoneType string, limit int32, offset int32) ([]*models.ConstraintZone, int64, error) {
	filter := &models.ZoneQueryFilter{
		ProjectID:  projectID,
		ZoneType:   zoneType,
		ZoneStatus: "ACTIVE",
		Limit:      limit,
		Offset:     offset,
	}

	zones, total, err := s.repo.ListZones(ctx, filter)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to list zones: %w", err)
	}

	return zones, total, nil
}

// CheckSitingConflicts analyzes conflicts between a proposed site and constraint zones.
func (s *ConstraintZoneService) CheckSitingConflicts(ctx context.Context, req *models.SitingConflictAnalysisRequest) (*models.RiskScore, []*models.SitingConflict, error) {
	// Validate request
	if req.ProjectID == "" {
		return nil, nil, fmt.Errorf("project_id is required")
	}
	if req.ProposedSiteGeometryWKT == "" {
		return nil, nil, fmt.Errorf("proposed site geometry is required")
	}

	// Find relevant zones
	zones, err := s.repo.FindZonesIntersecting(ctx, req.ProjectID, req.ProposedSiteGeometryWKT)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to query zones: %w", err)
	}

	// Check each zone for conflicts
	var conflicts []*models.SitingConflict
	conflictCount := map[string]int32{
		"INFO": 0, "WARNING": 0, "ERROR": 0, "BLOCKER": 0,
	}

	for _, zone := range zones {
		conflict := s.analyzeZoneConflict(zone, req)
		if conflict != nil {
			conflicts = append(conflicts, conflict)
			conflictCount[conflict.ConflictSeverity]++
		}
	}

	// Calculate risk score
	riskScore := &models.RiskScore{
		TotalConflicts:        int32(len(conflicts)),
		BlockerCount:          conflictCount["BLOCKER"],
		ErrorCount:            conflictCount["ERROR"],
		WarningCount:          conflictCount["WARNING"],
		InfoCount:             conflictCount["INFO"],
		IsSiteable:            conflictCount["BLOCKER"] == 0 && conflictCount["ERROR"] == 0,
		OverallRiskPercentage: s.calculateRiskPercentage(conflictCount),
		SitingRecommendation:  s.generateSitingRecommendation(conflictCount),
	}

	return riskScore, conflicts, nil
}

// analyzeZoneConflict checks a single zone for conflicts.
func (s *ConstraintZoneService) analyzeZoneConflict(zone *models.ConstraintZone, req *models.SitingConflictAnalysisRequest) *models.SitingConflict {
	// Check temporal constraints
	if zone.EffectiveEndAt != nil && zone.EffectiveEndAt.Before(time.Now()) {
		if !req.IncludeExpiredZones {
			return nil
		}
	}

	// Determine conflict severity based on zone type
	var severity string
	var reason string

	switch zone.ZoneType {
	case "EXCLUSION":
		severity = "BLOCKER"
		reason = fmt.Sprintf("Site overlaps exclusion zone (%s)", zone.ZoneCategory)
	case "INCLUSION":
		severity = "ERROR"
		reason = fmt.Sprintf("Site outside required inclusion zone (%s)", zone.ZoneCategory)
	case "BUFFER":
		severity = "WARNING"
		reason = fmt.Sprintf("Site too close to %s buffer zone (distance: %.0fm)", zone.ZoneCategory, zone.BufferDistanceM)
	}

	conflict := &models.SitingConflict{
		ConflictID:            fmt.Sprintf("conflict-%d", time.Now().UnixNano()),
		ZoneID:                zone.ZoneID,
		ProposedSiteGeometry:  req.ProposedSiteGeometryWKT,
		ConflictSeverity:      severity,
		ConflictReason:        reason,
		MitigationSuggestions: s.generateMitigationSuggestions(zone),
		DetectedAt:            time.Now(),
	}

	return conflict
}

// generateMitigationSuggestions provides remediation options.
func (s *ConstraintZoneService) generateMitigationSuggestions(zone *models.ConstraintZone) []string {
	suggestions := []string{}

	switch zone.ZoneType {
	case "EXCLUSION":
		suggestions = append(suggestions, "Relocate site outside exclusion zone")
		suggestions = append(suggestions, "Request variance from regulatory authority")
	case "INCLUSION":
		suggestions = append(suggestions, "Place site within required inclusion zone")
		suggestions = append(suggestions, "Apply for alternative compliance path")
	case "BUFFER":
		suggestions = append(suggestions, fmt.Sprintf("Maintain at least %.0fm distance from zone", zone.BufferDistanceM))
		suggestions = append(suggestions, "Install mitigation infrastructure (shielding, etc.)")
	}

	return suggestions
}

// calculateRiskPercentage computes overall risk score.
func (s *ConstraintZoneService) calculateRiskPercentage(conflictCount map[string]int32) float32 {
	// Weighted scoring: BLOCKER=100, ERROR=75, WARNING=25, INFO=5
	score := float32(0)
	score += float32(conflictCount["BLOCKER"]) * 100.0
	score += float32(conflictCount["ERROR"]) * 75.0
	score += float32(conflictCount["WARNING"]) * 25.0
	score += float32(conflictCount["INFO"]) * 5.0

	// Normalize to 0-100 range
	totalWeight := float32((conflictCount["BLOCKER"] + conflictCount["ERROR"] + conflictCount["WARNING"] + conflictCount["INFO"]))
	if totalWeight == 0 {
		return 0
	}

	percentile := (score / (totalWeight * 100.0)) * 100.0
	if percentile > 100 {
		percentile = 100
	}

	return percentile
}

// generateSitingRecommendation produces human-readable assessment.
func (s *ConstraintZoneService) generateSitingRecommendation(conflictCount map[string]int32) string {
	if conflictCount["BLOCKER"] > 0 {
		return fmt.Sprintf("CRITICAL: Site cannot be placed due to %d blocker conflicts. Relocation required.", conflictCount["BLOCKER"])
	}

	if conflictCount["ERROR"] > 0 {
		return fmt.Sprintf("NOT RECOMMENDED: %d conflicts found. Extensive mitigation required.", conflictCount["ERROR"])
	}

	if conflictCount["WARNING"] > 0 {
		return fmt.Sprintf("CONDITIONAL: %d warnings present but site may be viable with mitigation.", conflictCount["WARNING"])
	}

	if conflictCount["INFO"] > 0 {
		return fmt.Sprintf("APPROVED: Site meets all constraints. %d informational notes apply.", conflictCount["INFO"])
	}

	return "APPROVED: No conflicts detected. Site is clear for development."
}

// GetZoneStatistics retrieves zone stats for a project.
func (s *ConstraintZoneService) GetZoneStatistics(ctx context.Context, projectID string) (*models.ConstraintZoneStats, error) {
	stats, err := s.repo.GetZoneStats(ctx, projectID)
	if err != nil {
		return nil, fmt.Errorf("failed to get zone statistics: %w", err)
	}
	return stats, nil
}

// ImportZones performs bulk import of constraint zones.
func (s *ConstraintZoneService) ImportZones(ctx context.Context, zones []models.ConstraintZone, projectID string, userID string, source string) (*models.ZoneImportResult, error) {
	importReq := &models.ZoneImportRequest{
		ProjectID:      projectID,
		Source:         source,
		Zones:          zones,
		ImportedByUser: userID,
		ImportedAt:     time.Now(),
	}

	result, err := s.repo.ImportZones(ctx, importReq)
	if err != nil {
		return nil, fmt.Errorf("failed to import zones: %w", err)
	}

	return result, nil
}

// GetZoneHistory retrieves audit trail for a zone.
func (s *ConstraintZoneService) GetZoneHistory(ctx context.Context, zoneID string, limit int32) ([]*models.ZoneHistory, error) {
	history, err := s.repo.GetZoneHistory(ctx, zoneID, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to get zone history: %w", err)
	}
	return history, nil
}

// PurgeExpiredZones removes zones that have exceeded their effective dates.
func (s *ConstraintZoneService) PurgeExpiredZones(ctx context.Context, projectID string) (int32, error) {
	// Get zones expiring before now
	zones, err := s.repo.GetZonesExpiringBefore(ctx, projectID, time.Now())
	if err != nil {
		return 0, fmt.Errorf("failed to get expiring zones: %w", err)
	}

	// Mark as expired
	for _, zone := range zones {
		zone.ZoneStatus = "EXPIRED"
		s.repo.UpdateZone(ctx, zone)
	}

	return int32(len(zones)), nil
}

// CalculateZoneCoverageHash computes hash for deduplication.
func CalculateZoneCoverageHash(geometry string) string {
	h := sha256.New()
	io.WriteString(h, geometry)
	return fmt.Sprintf("%x", h.Sum(nil))
}

// DistanceHaversine calculates great-circle distance between two points (in meters).
func DistanceHaversine(lat1, lon1, lat2, lon2 float64) float64 {
	const R = 6371000 // Earth radius in meters
	toRad := math.Pi / 180

	dlat := (lat2 - lat1) * toRad
	dlon := (lon2 - lon1) * toRad

	a := math.Sin(dlat/2)*math.Sin(dlat/2) +
		math.Cos(lat1*toRad)*math.Cos(lat2*toRad)*
			math.Sin(dlon/2)*math.Sin(dlon/2)

	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))
	return R * c
}
