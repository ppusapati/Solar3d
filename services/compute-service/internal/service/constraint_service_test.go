package service_test

import (
	"context"
	"testing"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
	"p9e.in/samavaya/solar3d/compute-service/internal/service"
)

// TestConstraintService_CreateZone_Valid tests successful zone creation.
func TestConstraintService_CreateZone_Valid(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()
	zone := &models.ConstraintZone{
		Name:         "Protected Habitat North",
		Description:  "Environmentally sensitive area",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		GeometryWKT:  "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		GeometryType: "POLYGON",
		CreatedBy:    "user1",
		ProjectID:    "proj1",
	}

	created, err := svc.CreateZone(ctx, zone)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if created.ZoneID == "" {
		t.Error("Expected zone_id to be set")
	}
	if created.Name != "Protected Habitat North" {
		t.Errorf("Expected name 'Protected Habitat North', got %s", created.Name)
	}
	if created.ZoneStatus != "ACTIVE" {
		t.Errorf("Expected status ACTIVE, got %s", created.ZoneStatus)
	}
}

// TestConstraintService_CreateZone_MissingName tests validation of required fields.
func TestConstraintService_CreateZone_MissingName(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()
	zone := &models.ConstraintZone{
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		GeometryWKT:  "POINT(-118.5 35.2)",
		CreatedBy:    "user1",
		ProjectID:    "proj1",
	}

	_, err := svc.CreateZone(ctx, zone)
	if err == nil {
		t.Error("Expected error for missing name")
	}
}

// TestConstraintService_CreateZone_InvalidZoneType tests zone type validation.
func TestConstraintService_CreateZone_InvalidZoneType(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()
	zone := &models.ConstraintZone{
		Name:         "Test Zone",
		ZoneType:     "INVALID_TYPE",
		ZoneCategory: "ENVIRONMENTAL",
		GeometryWKT:  "POINT(-118.5 35.2)",
		CreatedBy:    "user1",
		ProjectID:    "proj1",
	}

	_, err := svc.CreateZone(ctx, zone)
	if err == nil {
		t.Error("Expected error for invalid zone type")
	}
}

// TestConstraintService_CreateZone_InvalidCategory tests category validation.
func TestConstraintService_CreateZone_InvalidCategory(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()
	zone := &models.ConstraintZone{
		Name:         "Test Zone",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "INVALID_CATEGORY",
		GeometryWKT:  "POINT(-118.5 35.2)",
		CreatedBy:    "user1",
		ProjectID:    "proj1",
	}

	_, err := svc.CreateZone(ctx, zone)
	if err == nil {
		t.Error("Expected error for invalid category")
	}
}

// TestConstraintService_UpdateZone tests zone updates.
func TestConstraintService_UpdateZone(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	// Create initial zone
	zone := &models.ConstraintZone{
		ZoneID:       "zone-123",
		Name:         "Original Name",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		GeometryWKT:  "POINT(-118.5 35.2)",
		CreatedBy:    "user1",
		ProjectID:    "proj1",
	}
	repo.CreateZone(ctx, zone)

	// Update zone
	zone.Name = "Updated Name"
	zone.ZoneStatus = "INACTIVE"
	updated, err := svc.UpdateZone(ctx, zone)

	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
	if updated.Name != "Updated Name" {
		t.Errorf("Expected name 'Updated Name', got %s", updated.Name)
	}
	if updated.ZoneStatus != "INACTIVE" {
		t.Errorf("Expected status INACTIVE, got %s", updated.ZoneStatus)
	}
}

// TestConstraintService_DeleteZone tests soft deletion.
func TestConstraintService_DeleteZone(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	// Create zone
	zone := &models.ConstraintZone{
		ZoneID:       "zone-123",
		Name:         "Test Zone",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		GeometryWKT:  "POINT(-118.5 35.2)",
		CreatedBy:    "user1",
		ProjectID:    "proj1",
	}
	repo.CreateZone(ctx, zone)

	// Delete
	err := svc.DeleteZone(ctx, "zone-123", "user1", "test deletion")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
}

// TestConstraintService_CheckSitingConflicts_Exclusion tests exclusion zone conflict detection.
func TestConstraintService_CheckSitingConflicts_Exclusion(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	// Create exclusion zone
	zone := &models.ConstraintZone{
		ZoneID:       "zone-123",
		Name:         "Protected Area",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		GeometryWKT:  "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:    "proj1",
		ZoneStatus:   "ACTIVE",
	}
	repo.CreateZone(ctx, zone)

	// Check proposed site inside exclusion zone
	req := &models.SitingConflictAnalysisRequest{
		ProjectID:               "proj1",
		ProposedSiteGeometryWKT: "POINT(-118.45 35.25)",
		ProposedGeometryType:    "POINT",
		IncludeBufferZones:      false,
		IncludeExpiredZones:     false,
	}

	riskScore, conflicts, err := svc.CheckSitingConflicts(ctx, req)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if riskScore.TotalConflicts == 0 {
		t.Error("Expected conflicts to be detected")
	}
	if len(conflicts) > 0 && conflicts[0].ConflictSeverity != "BLOCKER" {
		t.Errorf("Expected BLOCKER severity for site in exclusion zone, got %s", conflicts[0].ConflictSeverity)
	}
}

// TestConstraintService_CheckSitingConflicts_NoConflicts tests clear siting site.
func TestConstraintService_CheckSitingConflicts_NoConflicts(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	// Create exclusion zone
	zone := &models.ConstraintZone{
		ZoneID:      "zone-123",
		Name:        "Protected Area",
		ZoneType:    "EXCLUSION",
		GeometryWKT: "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:   "proj2",
		ZoneStatus:  "ACTIVE",
	}
	repo.CreateZone(ctx, zone)

	// Check proposed site far from zones
	req := &models.SitingConflictAnalysisRequest{
		ProjectID:               "proj1",
		ProposedSiteGeometryWKT: "POINT(-118.0 35.0)",
		ProposedGeometryType:    "POINT",
	}

	riskScore, conflicts, err := svc.CheckSitingConflicts(ctx, req)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if riskScore.IsSiteable != true {
		t.Error("Expected site to be siteable when no conflicts")
	}
	if len(conflicts) > 0 {
		t.Errorf("Expected no conflicts, got %d", len(conflicts))
	}
}

// TestConstraintService_GetZoneStatistics tests statistics calculation.
func TestConstraintService_GetZoneStatistics(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	// Create multiple zones
	zone1 := &models.ConstraintZone{
		ZoneID:       "zone-1",
		Name:         "Zone 1",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		ProjectID:    "proj1",
		ZoneStatus:   "ACTIVE",
		CreatedBy:    "user1",
	}
	repo.CreateZone(ctx, zone1)

	zone2 := &models.ConstraintZone{
		ZoneID:       "zone-2",
		Name:         "Zone 2",
		ZoneType:     "BUFFER",
		ZoneCategory: "GEOLOGICAL",
		ProjectID:    "proj1",
		ZoneStatus:   "INACTIVE",
		CreatedBy:    "user1",
	}
	repo.CreateZone(ctx, zone2)

	stats, err := svc.GetZoneStatistics(ctx, "proj1")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if stats.TotalZones != 2 {
		t.Errorf("Expected 2 total zones, got %d", stats.TotalZones)
	}
	if stats.ActiveZones != 1 {
		t.Errorf("Expected 1 active zone, got %d", stats.ActiveZones)
	}
	if stats.InactiveZones != 1 {
		t.Errorf("Expected 1 inactive zone, got %d", stats.InactiveZones)
	}
	if stats.ByType["EXCLUSION"] != 1 {
		t.Error("Expected 1 EXCLUSION zone")
	}
}

// TestConstraintService_ImportZones tests bulk import.
func TestConstraintService_ImportZones(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	zones := []models.ConstraintZone{
		{
			ZoneID:       "zone-1",
			Name:         "Zone 1",
			ZoneType:     "EXCLUSION",
			ZoneCategory: "ENVIRONMENTAL",
			CreatedBy:    "user1",
		},
		{
			ZoneID:       "zone-2",
			Name:         "Zone 2",
			ZoneType:     "BUFFER",
			ZoneCategory: "GEOLOGICAL",
			CreatedBy:    "user1",
		},
	}

	result, err := svc.ImportZones(ctx, zones, "proj1", "user1", "import-source")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if result.TotalZones != 2 {
		t.Errorf("Expected 2 zones imported, got %d", result.TotalZones)
	}
	if result.SuccessCount != 2 {
		t.Errorf("Expected 2 successful, got %d", result.SuccessCount)
	}
}

// TestConstraintService_GetZoneHistory tests audit trail retrieval.
func TestConstraintService_GetZoneHistory(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	zone := &models.ConstraintZone{
		ZoneID:       "zone-123",
		Name:         "Test Zone",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		CreatedBy:    "user1",
		ProjectID:    "proj1",
	}
	repo.CreateZone(ctx, zone)

	// Add history entries
	repo.AddZoneHistory(ctx, &models.ZoneHistory{
		ZoneID:     "zone-123",
		ChangeType: "CREATE",
		ChangedBy:  "user1",
		ChangedAt:  time.Now(),
	})

	repo.AddZoneHistory(ctx, &models.ZoneHistory{
		ZoneID:     "zone-123",
		ChangeType: "UPDATE",
		ChangedBy:  "user1",
		ChangedAt:  time.Now(),
	})

	history, err := svc.GetZoneHistory(ctx, "zone-123", 10)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(history) != 2 {
		t.Errorf("Expected 2 history entries, got %d", len(history))
	}
}

// TestConstraintService_PurgeExpiredZones tests expiration handling.
func TestConstraintService_PurgeExpiredZones(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	pastTime := time.Now().Add(-24 * time.Hour)
	zone := &models.ConstraintZone{
		ZoneID:         "zone-123",
		Name:           "Expired Zone",
		ZoneType:       "EXCLUSION",
		ZoneCategory:   "ENVIRONMENTAL",
		ProjectID:      "proj1",
		ZoneStatus:     "ACTIVE",
		EffectiveEndAt: &pastTime,
		CreatedBy:      "user1",
	}
	repo.CreateZone(ctx, zone)

	purged, err := svc.PurgeExpiredZones(ctx, "proj1")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if purged != 1 {
		t.Errorf("Expected 1 zone purged, got %d", purged)
	}
}

// TestConstraintService_ListZones tests zone filtering and pagination.
func TestConstraintService_ListZones(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	svc := service.NewConstraintZoneService(repo)

	ctx := context.Background()

	// Create zones
	for i := 1; i <= 5; i++ {
		zone := &models.ConstraintZone{
			ZoneID:       "zone-" + string(rune('0'+byte(i))),
			Name:         "Zone " + string(rune(i)),
			ZoneStatus:   "ACTIVE",
			ZoneType:     "EXCLUSION",
			ZoneCategory: "ENVIRONMENTAL",
			ProjectID:    "proj1",
			CreatedBy:    "user1",
		}
		repo.CreateZone(ctx, zone)
	}

	zones, total, err := svc.ListZones(ctx, "proj1", "", 10, 0)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if int(total) != 5 {
		t.Errorf("Expected 5 total zones, got %d", total)
	}
	if len(zones) != 5 {
		t.Errorf("Expected 5 zones returned, got %d", len(zones))
	}
}
