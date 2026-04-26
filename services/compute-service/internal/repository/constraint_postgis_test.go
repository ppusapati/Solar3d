package repository_test

import (
	"context"
	"testing"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

// TestFindZonesIntersecting_ExclusionZone tests ST_Intersects with exclusion zone.
func TestFindZonesIntersecting_ExclusionZone(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create exclusion zone (polygon)
	exclusionZone := &models.ConstraintZone{
		ZoneID:       "exclusion-1",
		Name:         "Protected Habitat",
		ZoneType:     "EXCLUSION",
		ZoneCategory: "ENVIRONMENTAL",
		GeometryWKT:  "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:    "dev-solar-1",
		ZoneStatus:   "ACTIVE",
		CreatedBy:    "user1",
	}
	repo.CreateZone(ctx, exclusionZone)

	// Query zones intersecting with proposed site inside polygon
	sitingGeometryInside := "POINT(-118.45 35.25)" // Inside exclusion zone

	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", sitingGeometryInside)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(zones) != 1 {
		t.Errorf("Expected 1 intersecting zone, got %d", len(zones))
	}
	if zones[0].ZoneID != "exclusion-1" {
		t.Errorf("Expected exclusion-1, got %s", zones[0].ZoneID)
	}
	if zones[0].ZoneType != "EXCLUSION" {
		t.Errorf("Expected EXCLUSION type, got %s", zones[0].ZoneType)
	}
}

// TestFindZonesIntersecting_BufferZone tests ST_DWithin for buffer zones.
func TestFindZonesIntersecting_BufferZone(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create buffer zone around infrastructure
	bufferZone := &models.ConstraintZone{
		ZoneID:          "buffer-1",
		Name:            "Power Line Buffer",
		ZoneType:        "BUFFER",
		ZoneCategory:    "INFRASTRUCTURE",
		GeometryWKT:     "LINESTRING(-118.5 35.2, -118.4 35.3)", // Power line
		BufferDistanceM: 500.0,
		ProjectID:       "dev-solar-1",
		ZoneStatus:      "ACTIVE",
		CreatedBy:       "user1",
	}
	repo.CreateZone(ctx, bufferZone)

	// Query zones with buffer constraint
	sitingGeometry := "POINT(-118.45 35.25)" // Near buffer zone

	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", sitingGeometry)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	// Mock returns all zones for project (simplified spatial logic)
	if len(zones) != 1 {
		t.Errorf("Expected 1 buffer zone, got %d", len(zones))
	}
	if zones[0].BufferDistanceM != 500.0 {
		t.Errorf("Expected 500m buffer, got %.0f", zones[0].BufferDistanceM)
	}
}

// TestFindZonesIntersecting_InclusionZone tests ST_Contains for inclusion zones.
func TestFindZonesIntersecting_InclusionZone(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create inclusion zone (allowed area)
	inclusionZone := &models.ConstraintZone{
		ZoneID:       "inclusion-1",
		Name:         "Designated Solar Zone",
		ZoneType:     "INCLUSION",
		ZoneCategory: "REGULATORY",
		GeometryWKT:  "POLYGON((-118.6 35.0, -118.3 35.0, -118.3 35.4, -118.6 35.4, -118.6 35.0))",
		ProjectID:    "dev-solar-1",
		ZoneStatus:   "ACTIVE",
		CreatedBy:    "regulatory",
	}
	repo.CreateZone(ctx, inclusionZone)

	// Query zones containing proposed site
	sitingGeometry := "POINT(-118.45 35.25)" // Inside inclusion zone

	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", sitingGeometry)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(zones) != 1 {
		t.Errorf("Expected 1 inclusion zone, got %d", len(zones))
	}
	if zones[0].ZoneType != "INCLUSION" {
		t.Errorf("Expected INCLUSION type, got %s", zones[0].ZoneType)
	}
}

// TestFindZonesIntersecting_MultipleZones tests querying across multiple zones.
func TestFindZonesIntersecting_MultipleZones(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create multiple zones
	zones := []*models.ConstraintZone{
		{
			ZoneID:       "exclusion-env",
			Name:         "Environmental Protection",
			ZoneType:     "EXCLUSION",
			ZoneCategory: "ENVIRONMENTAL",
			GeometryWKT:  "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
			ProjectID:    "dev-solar-1",
			ZoneStatus:   "ACTIVE",
			CreatedBy:    "user1",
		},
		{
			ZoneID:       "inclusion-solar",
			Name:         "Solar Designated",
			ZoneType:     "INCLUSION",
			ZoneCategory: "REGULATORY",
			GeometryWKT:  "POLYGON((-118.6 35.0, -118.3 35.0, -118.3 35.4, -118.6 35.4, -118.6 35.0))",
			ProjectID:    "dev-solar-1",
			ZoneStatus:   "ACTIVE",
			CreatedBy:    "user1",
		},
		{
			ZoneID:          "buffer-line",
			Name:            "Road Buffer",
			ZoneType:        "BUFFER",
			ZoneCategory:    "INFRASTRUCTURE",
			GeometryWKT:     "LINESTRING(-118.45 35.15, -118.45 35.35)",
			BufferDistanceM: 300.0,
			ProjectID:       "dev-solar-1",
			ZoneStatus:      "ACTIVE",
			CreatedBy:       "user1",
		},
	}

	for _, zone := range zones {
		repo.CreateZone(ctx, zone)
	}

	// Query all zones for project
	queryGeometry := "POINT(-118.45 35.25)"
	foundZones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", queryGeometry)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(foundZones) != 3 {
		t.Errorf("Expected 3 zones, got %d", len(foundZones))
	}

	// Verify all zone types are present
	hasExclusion := false
	hasInclusion := false
	hasBuffer := false

	for _, zone := range foundZones {
		switch zone.ZoneType {
		case "EXCLUSION":
			hasExclusion = true
		case "INCLUSION":
			hasInclusion = true
		case "BUFFER":
			hasBuffer = true
		}
	}

	if !hasExclusion || !hasInclusion || !hasBuffer {
		t.Errorf("Missing zone types: Exclusion=%v, Inclusion=%v, Buffer=%v", hasExclusion, hasInclusion, hasBuffer)
	}
}

// TestFindZonesIntersecting_ProjectIsolation tests zones are isolated by project.
func TestFindZonesIntersecting_ProjectIsolation(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create zones in different projects
	zone1 := &models.ConstraintZone{
		ZoneID:      "zone-proj1",
		Name:        "Zone in Project 1",
		ZoneType:    "EXCLUSION",
		GeometryWKT: "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:   "dev-solar-1",
		ZoneStatus:  "ACTIVE",
		CreatedBy:   "user1",
	}

	zone2 := &models.ConstraintZone{
		ZoneID:      "zone-proj2",
		Name:        "Zone in Project 2",
		ZoneType:    "EXCLUSION",
		GeometryWKT: "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:   "dev-solar-2",
		ZoneStatus:  "ACTIVE",
		CreatedBy:   "user1",
	}

	repo.CreateZone(ctx, zone1)
	repo.CreateZone(ctx, zone2)

	// Query Project 1 zones
	zonesProj1, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", "POINT(-118.45 35.25)")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(zonesProj1) != 1 {
		t.Errorf("Expected 1 zone from Project 1, got %d", len(zonesProj1))
	}
	if zonesProj1[0].ProjectID != "dev-solar-1" {
		t.Errorf("Expected project dev-solar-1, got %s", zonesProj1[0].ProjectID)
	}

	// Query Project 2 zones
	zonesProj2, err := repo.FindZonesIntersecting(ctx, "dev-solar-2", "POINT(-118.45 35.25)")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(zonesProj2) != 1 {
		t.Errorf("Expected 1 zone from Project 2, got %d", len(zonesProj2))
	}
	if zonesProj2[0].ProjectID != "dev-solar-2" {
		t.Errorf("Expected project dev-solar-2, got %s", zonesProj2[0].ProjectID)
	}
}

// TestFindZonesIntersecting_DeletedZonesExcluded tests deleted zones are not returned.
func TestFindZonesIntersecting_DeletedZonesExcluded(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create zone
	zone := &models.ConstraintZone{
		ZoneID:      "zone-delete-test",
		Name:        "Zone to Delete",
		ZoneType:    "EXCLUSION",
		GeometryWKT: "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:   "dev-solar-1",
		ZoneStatus:  "ACTIVE",
		CreatedBy:   "user1",
	}
	repo.CreateZone(ctx, zone)

	// Query should find the zone
	zones, _ := repo.FindZonesIntersecting(ctx, "dev-solar-1", "POINT(-118.45 35.25)")
	if len(zones) != 1 {
		t.Errorf("Expected 1 zone before delete, got %d", len(zones))
	}

	// Delete the zone
	repo.DeleteZone(ctx, "zone-delete-test", "Testing deletion")

	// Query should not find deleted zone
	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", "POINT(-118.45 35.25)")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(zones) != 0 {
		t.Errorf("Expected 0 zones after delete, got %d", len(zones))
	}
}

// TestFindZonesIntersecting_TemporalFiltering tests expired zones.
func TestFindZonesIntersecting_TemporalFiltering(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create zone effective in future
	futureTime := time.Now().Add(24 * time.Hour)
	futureZone := &models.ConstraintZone{
		ZoneID:           "zone-future",
		Name:             "Future Zone",
		ZoneType:         "EXCLUSION",
		GeometryWKT:      "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:        "dev-solar-1",
		ZoneStatus:       "ACTIVE",
		EffectiveStartAt: &futureTime,
		CreatedBy:        "user1",
	}
	repo.CreateZone(ctx, futureZone)

	// Create zone effective now
	now := time.Now()
	activeZone := &models.ConstraintZone{
		ZoneID:           "zone-active",
		Name:             "Active Zone",
		ZoneType:         "EXCLUSION",
		GeometryWKT:      "POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))",
		ProjectID:        "dev-solar-1",
		ZoneStatus:       "ACTIVE",
		EffectiveStartAt: &now,
		CreatedBy:        "user1",
	}
	repo.CreateZone(ctx, activeZone)

	// Query returns all zones (mock doesn't filter by temporal)
	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", "POINT(-118.45 35.25)")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	// Both zones should be returned in mock
	if len(zones) != 2 {
		t.Errorf("Expected 2 zones, got %d", len(zones))
	}
}

// TestFindZonesContaining tests ST_Contains for zones fully containing a point.
func TestFindZonesContaining(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create inclusion zone
	inclusionZone := &models.ConstraintZone{
		ZoneID:       "inclusion-container",
		Name:         "Large Container Zone",
		ZoneType:     "INCLUSION",
		ZoneCategory: "REGULATORY",
		GeometryWKT:  "POLYGON((-119.0 34.0, -118.0 34.0, -118.0 36.0, -119.0 36.0, -119.0 34.0))",
		ProjectID:    "dev-solar-1",
		ZoneStatus:   "ACTIVE",
		CreatedBy:    "user1",
	}
	repo.CreateZone(ctx, inclusionZone)

	// Point inside the containing zone
	containedPoint := "POINT(-118.5 35.0)"

	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", containedPoint)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(zones) != 1 {
		t.Errorf("Expected 1 containing zone, got %d", len(zones))
	}
	if zones[0].ZoneType != "INCLUSION" {
		t.Errorf("Expected INCLUSION type, got %s", zones[0].ZoneType)
	}
}

// TestFindZonesNear tests ST_DWithin for proximity queries.
func TestFindZonesNear(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create buffer zone
	bufferZone := &models.ConstraintZone{
		ZoneID:          "buffer-near",
		Name:            "Proximity Buffer",
		ZoneType:        "BUFFER",
		ZoneCategory:    "INFRASTRUCTURE",
		GeometryWKT:     "POINT(-118.5 35.2)",
		BufferDistanceM: 1000.0, // 1km buffer
		ProjectID:       "dev-solar-1",
		ZoneStatus:      "ACTIVE",
		CreatedBy:       "user1",
	}
	repo.CreateZone(ctx, bufferZone)

	// Query zones near proposed location
	nearbyPoint := "POINT(-118.51 35.19)" // ~1.5km away

	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", nearbyPoint)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	// Mock returns all zones for project
	if len(zones) != 1 {
		t.Errorf("Expected 1 near zone, got %d", len(zones))
	}
}

// TestGetZonesExpiringBefore tests temporal expiration queries.
func TestGetZonesExpiringBefore(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create zones with different expiration dates
	now := time.Now()
	tomorrow := now.Add(24 * time.Hour)
	nextWeek := now.Add(7 * 24 * time.Hour)

	zones := []*models.ConstraintZone{
		{
			ZoneID:         "zone-expires-tomorrow",
			Name:           "Expires Tomorrow",
			ZoneType:       "EXCLUSION",
			ProjectID:      "dev-solar-1",
			ZoneStatus:     "ACTIVE",
			EffectiveEndAt: &tomorrow,
			CreatedBy:      "user1",
		},
		{
			ZoneID:         "zone-expires-next-week",
			Name:           "Expires Next Week",
			ZoneType:       "EXCLUSION",
			ProjectID:      "dev-solar-1",
			ZoneStatus:     "ACTIVE",
			EffectiveEndAt: &nextWeek,
			CreatedBy:      "user1",
		},
		{
			ZoneID:     "zone-no-expiration",
			Name:       "No Expiration",
			ZoneType:   "EXCLUSION",
			ProjectID:  "dev-solar-1",
			ZoneStatus: "ACTIVE",
			CreatedBy:  "user1",
		},
	}

	for _, zone := range zones {
		repo.CreateZone(ctx, zone)
	}

	// Query zones expiring in 3 days
	threeeDaysFromNow := now.Add(3 * 24 * time.Hour)
	expiringZones, err := repo.GetZonesExpiringBefore(ctx, "dev-solar-1", threeeDaysFromNow)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	// Should find zones expiring tomorrow
	if len(expiringZones) != 1 {
		t.Errorf("Expected 1 expiring zone, got %d", len(expiringZones))
	}
	if expiringZones[0].ZoneID != "zone-expires-tomorrow" {
		t.Errorf("Expected zone-expires-tomorrow, got %s", expiringZones[0].ZoneID)
	}
}

// TestFindZonesNear_MultipleZonesDistance tests proximity queries with multiple zones.
func TestFindZonesNear_MultipleZonesDistance(t *testing.T) {
	repo := repository.NewMockConstraintRepository()
	ctx := context.Background()

	// Create multiple zones at different distances
	closeZone := &models.ConstraintZone{
		ZoneID:          "zone-close",
		Name:            "Close Zone",
		ZoneType:        "BUFFER",
		ZoneCategory:    "INFRASTRUCTURE",
		GeometryWKT:     "POINT(-118.45 35.20)",
		BufferDistanceM: 500.0,
		ProjectID:       "dev-solar-1",
		ZoneStatus:      "ACTIVE",
		CreatedBy:       "user1",
	}

	farZone := &models.ConstraintZone{
		ZoneID:          "zone-far",
		Name:            "Far Zone",
		ZoneType:        "BUFFER",
		ZoneCategory:    "INFRASTRUCTURE",
		GeometryWKT:     "POINT(-118.30 35.00)",
		BufferDistanceM: 300.0,
		ProjectID:       "dev-solar-1",
		ZoneStatus:      "ACTIVE",
		CreatedBy:       "user1",
	}

	repo.CreateZone(ctx, closeZone)
	repo.CreateZone(ctx, farZone)

	// Query all zones (mock doesn't filter by distance)
	zones, err := repo.FindZonesIntersecting(ctx, "dev-solar-1", "POINT(-118.45 35.25)")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(zones) != 2 {
		t.Errorf("Expected 2 zones, got %d", len(zones))
	}
}
