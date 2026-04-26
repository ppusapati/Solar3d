package repository

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
)

// PgConstraintRepository is the production PostGIS-backed implementation of
// ConstraintRepository. It uses ST_Intersects / ST_Contains / ST_DWithin over
// the `geography(Geometry, 4326)` column populated from each zone's WKT.
//
// Geometry is materialised by the writer (CreateZone / UpdateZone) using
// `ST_GeogFromText`, so spatial queries do not need to re-parse WKT on read.
type PgConstraintRepository struct {
	pool *pgxpool.Pool
}

// NewPgConstraintRepository wires the repo to a pgx pool.
func NewPgConstraintRepository(pool *pgxpool.Pool) *PgConstraintRepository {
	return &PgConstraintRepository{pool: pool}
}

var _ ConstraintRepository = (*PgConstraintRepository)(nil)

// ErrZoneNotFound is returned when a zone lookup misses.
var ErrZoneNotFound = errors.New("constraint zone not found")

// ================== Zone CRUD ==================

func (r *PgConstraintRepository) CreateZone(ctx context.Context, z *models.ConstraintZone) error {
	if z.ZoneID == "" {
		// Let Postgres assign a UUID via DEFAULT gen_random_uuid().
	}
	metadataJSON, err := encodeMetadata(z.Metadata)
	if err != nil {
		return fmt.Errorf("encode metadata: %w", err)
	}
	const q = `
INSERT INTO constraint_zones (
  zone_id, name, description, zone_type, zone_category, zone_status,
  geometry_wkt, geometry_type, geometry,
  bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y,
  effective_start_at, effective_end_at,
  source, source_id, buffer_distance_m,
  tags, metadata, created_by, project_id, is_public
) VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2,$3,$4,$5,$6,
  $7,$8, ST_GeogFromText($9),
  $10,$11,$12,$13,
  $14,$15,
  $16,$17,$18,
  $19,$20::jsonb,$21,$22::uuid,$23
) RETURNING id, zone_id, created_at, updated_at`
	wktForGeog := wrapWKTSrid(z.GeometryWKT)
	row := r.pool.QueryRow(ctx, q,
		z.ZoneID, z.Name, z.Description, z.ZoneType, z.ZoneCategory, defaultStatus(z.ZoneStatus),
		z.GeometryWKT, z.GeometryType, wktForGeog,
		z.BBoxMinX, z.BBoxMinY, z.BBoxMaxX, z.BBoxMaxY,
		z.EffectiveStartAt, z.EffectiveEndAt,
		z.Source, z.SourceID, z.BufferDistanceM,
		z.Tags, metadataJSON, z.CreatedBy, z.ProjectID, z.IsPublic,
	)
	if err := row.Scan(&z.ID, &z.ZoneID, &z.CreatedAt, &z.UpdatedAt); err != nil {
		return fmt.Errorf("insert constraint_zone: %w", err)
	}
	return nil
}

func (r *PgConstraintRepository) GetZone(ctx context.Context, zoneID string) (*models.ConstraintZone, error) {
	const q = `
SELECT id, zone_id, name, description, zone_type, zone_category, zone_status,
       geometry_wkt, geometry_type,
       bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y,
       effective_start_at, effective_end_at,
       source, source_id, buffer_distance_m,
       tags, metadata, created_by, project_id, is_public,
       created_at, updated_at, deleted_at, deleted_reason
  FROM constraint_zones
 WHERE zone_id = $1::uuid AND deleted_at IS NULL`
	row := r.pool.QueryRow(ctx, q, zoneID)
	z, err := scanZone(row)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrZoneNotFound
		}
		return nil, fmt.Errorf("get zone: %w", err)
	}
	return z, nil
}

func (r *PgConstraintRepository) UpdateZone(ctx context.Context, z *models.ConstraintZone) error {
	metadataJSON, err := encodeMetadata(z.Metadata)
	if err != nil {
		return fmt.Errorf("encode metadata: %w", err)
	}
	const q = `
UPDATE constraint_zones SET
  name=$2, description=$3, zone_type=$4, zone_category=$5, zone_status=$6,
  geometry_wkt=$7, geometry_type=$8, geometry=ST_GeogFromText($9),
  bbox_min_x=$10, bbox_min_y=$11, bbox_max_x=$12, bbox_max_y=$13,
  effective_start_at=$14, effective_end_at=$15,
  source=$16, source_id=$17, buffer_distance_m=$18,
  tags=$19, metadata=$20::jsonb, is_public=$21,
  updated_at=NOW()
 WHERE zone_id=$1::uuid AND deleted_at IS NULL`
	tag, err := r.pool.Exec(ctx, q,
		z.ZoneID, z.Name, z.Description, z.ZoneType, z.ZoneCategory, z.ZoneStatus,
		z.GeometryWKT, z.GeometryType, wrapWKTSrid(z.GeometryWKT),
		z.BBoxMinX, z.BBoxMinY, z.BBoxMaxX, z.BBoxMaxY,
		z.EffectiveStartAt, z.EffectiveEndAt,
		z.Source, z.SourceID, z.BufferDistanceM,
		z.Tags, metadataJSON, z.IsPublic,
	)
	if err != nil {
		return fmt.Errorf("update zone: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrZoneNotFound
	}
	return nil
}

func (r *PgConstraintRepository) DeleteZone(ctx context.Context, zoneID string, reason string) error {
	const q = `
UPDATE constraint_zones
   SET deleted_at = NOW(), deleted_reason = $2, updated_at = NOW()
 WHERE zone_id = $1::uuid AND deleted_at IS NULL`
	tag, err := r.pool.Exec(ctx, q, zoneID, reason)
	if err != nil {
		return fmt.Errorf("delete zone: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrZoneNotFound
	}
	return nil
}

func (r *PgConstraintRepository) ListZones(ctx context.Context, f *models.ZoneQueryFilter) ([]*models.ConstraintZone, int64, error) {
	if f == nil {
		f = &models.ZoneQueryFilter{}
	}
	args := []any{}
	clauses := []string{"deleted_at IS NULL"}
	add := func(cond string, val any) {
		args = append(args, val)
		clauses = append(clauses, fmt.Sprintf(cond, len(args)))
	}
	if f.ProjectID != "" {
		add("project_id = $%d::uuid", f.ProjectID)
	}
	if f.ZoneType != "" {
		add("zone_type = $%d", f.ZoneType)
	}
	if f.ZoneCategory != "" {
		add("zone_category = $%d", f.ZoneCategory)
	}
	if f.ZoneStatus != "" {
		add("zone_status = $%d", f.ZoneStatus)
	}
	if f.SearchQuery != "" {
		add("(name ILIKE $%d OR description ILIKE $%d)", "%"+f.SearchQuery+"%")
		// Re-use the last placeholder for the second match.
		clauses[len(clauses)-1] = strings.Replace(clauses[len(clauses)-1],
			fmt.Sprintf("$%d OR description ILIKE $%d", len(args), len(args)),
			fmt.Sprintf("$%d OR description ILIKE $%d", len(args), len(args)), 1)
	}
	limit := f.Limit
	if limit <= 0 || limit > 1000 {
		limit = 100
	}
	offset := f.Offset
	if offset < 0 {
		offset = 0
	}

	where := strings.Join(clauses, " AND ")
	countQ := "SELECT COUNT(*) FROM constraint_zones WHERE " + where
	var total int64
	if err := r.pool.QueryRow(ctx, countQ, args...).Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count zones: %w", err)
	}

	args = append(args, limit, offset)
	listQ := `
SELECT id, zone_id, name, description, zone_type, zone_category, zone_status,
       geometry_wkt, geometry_type,
       bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y,
       effective_start_at, effective_end_at,
       source, source_id, buffer_distance_m,
       tags, metadata, created_by, project_id, is_public,
       created_at, updated_at, deleted_at, deleted_reason
  FROM constraint_zones
 WHERE ` + where + fmt.Sprintf(" ORDER BY created_at DESC LIMIT $%d OFFSET $%d", len(args)-1, len(args))

	rows, err := r.pool.Query(ctx, listQ, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("list zones: %w", err)
	}
	defer rows.Close()

	out := []*models.ConstraintZone{}
	for rows.Next() {
		z, scanErr := scanZone(rows)
		if scanErr != nil {
			return nil, 0, fmt.Errorf("scan zone: %w", scanErr)
		}
		out = append(out, z)
	}
	return out, total, rows.Err()
}

// ================== Spatial Queries ==================

func (r *PgConstraintRepository) FindZonesIntersecting(ctx context.Context, projectID, geometryWKT string) ([]*models.ConstraintZone, error) {
	const q = `
SELECT id, zone_id, name, description, zone_type, zone_category, zone_status,
       geometry_wkt, geometry_type,
       bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y,
       effective_start_at, effective_end_at,
       source, source_id, buffer_distance_m,
       tags, metadata, created_by, project_id, is_public,
       created_at, updated_at, deleted_at, deleted_reason
  FROM constraint_zones
 WHERE project_id = $1::uuid
   AND deleted_at IS NULL
   AND ST_Intersects(geometry, ST_GeogFromText($2))`
	return r.queryZones(ctx, q, projectID, wrapWKTSrid(geometryWKT))
}

func (r *PgConstraintRepository) FindZonesContaining(ctx context.Context, projectID, geometryWKT string) ([]*models.ConstraintZone, error) {
	const q = `
SELECT id, zone_id, name, description, zone_type, zone_category, zone_status,
       geometry_wkt, geometry_type,
       bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y,
       effective_start_at, effective_end_at,
       source, source_id, buffer_distance_m,
       tags, metadata, created_by, project_id, is_public,
       created_at, updated_at, deleted_at, deleted_reason
  FROM constraint_zones
 WHERE project_id = $1::uuid
   AND deleted_at IS NULL
   AND ST_Contains(geometry::geometry, ST_GeomFromText($2, 4326))`
	return r.queryZones(ctx, q, projectID, geometryWKT)
}

func (r *PgConstraintRepository) FindZonesNear(ctx context.Context, projectID string, lat, lon float64, radiusM float32) ([]*models.ConstraintZone, error) {
	const q = `
SELECT id, zone_id, name, description, zone_type, zone_category, zone_status,
       geometry_wkt, geometry_type,
       bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y,
       effective_start_at, effective_end_at,
       source, source_id, buffer_distance_m,
       tags, metadata, created_by, project_id, is_public,
       created_at, updated_at, deleted_at, deleted_reason
  FROM constraint_zones
 WHERE project_id = $1::uuid
   AND deleted_at IS NULL
   AND ST_DWithin(geometry, ST_MakePoint($3, $2)::geography, $4)`
	return r.queryZones(ctx, q, projectID, lat, lon, radiusM)
}

// ================== History ==================

func (r *PgConstraintRepository) AddZoneHistory(ctx context.Context, h *models.ZoneHistory) error {
	oldJSON, _ := json.Marshal(h.OldValues)
	newJSON, _ := json.Marshal(h.NewValues)
	const q = `
INSERT INTO zone_history (zone_id, change_type, old_values, new_values, changed_by, change_reason, detailed_changes)
VALUES ($1::uuid, $2, $3::jsonb, $4::jsonb, $5, $6, $7)
RETURNING id, changed_at`
	if err := r.pool.QueryRow(ctx, q, h.ZoneID, h.ChangeType, oldJSON, newJSON, h.ChangedBy, h.ChangeReason, h.DetailedChanges).
		Scan(&h.ID, &h.ChangedAt); err != nil {
		return fmt.Errorf("insert zone history: %w", err)
	}
	return nil
}

func (r *PgConstraintRepository) GetZoneHistory(ctx context.Context, zoneID string, limit int32) ([]*models.ZoneHistory, error) {
	if limit <= 0 || limit > 500 {
		limit = 100
	}
	const q = `
SELECT id, zone_id, change_type, old_values, new_values, changed_by, change_reason, detailed_changes, changed_at
  FROM zone_history
 WHERE zone_id = $1::uuid
 ORDER BY changed_at DESC
 LIMIT $2`
	rows, err := r.pool.Query(ctx, q, zoneID, limit)
	if err != nil {
		return nil, fmt.Errorf("get zone history: %w", err)
	}
	defer rows.Close()
	out := []*models.ZoneHistory{}
	for rows.Next() {
		var h models.ZoneHistory
		var oldRaw, newRaw []byte
		if err := rows.Scan(&h.ID, &h.ZoneID, &h.ChangeType, &oldRaw, &newRaw, &h.ChangedBy, &h.ChangeReason, &h.DetailedChanges, &h.ChangedAt); err != nil {
			return nil, fmt.Errorf("scan history: %w", err)
		}
		h.OldValues = decodeStringMap(oldRaw)
		h.NewValues = decodeStringMap(newRaw)
		out = append(out, &h)
	}
	return out, rows.Err()
}

// ================== Permissions ==================

func (r *PgConstraintRepository) AddPermission(ctx context.Context, p *models.ZonePermission) error {
	const q = `
INSERT INTO zone_permissions (zone_id, user_id, permission_level, granted_by, granted_at)
VALUES ($1::uuid, $2, $3, $4, COALESCE($5, NOW()))
RETURNING id`
	var grantedAt any
	if !p.GrantedAt.IsZero() {
		grantedAt = p.GrantedAt
	}
	if err := r.pool.QueryRow(ctx, q, p.ZoneID, p.UserID, p.Permission, p.GrantedBy, grantedAt).Scan(&p.ID); err != nil {
		return fmt.Errorf("insert permission: %w", err)
	}
	return nil
}

func (r *PgConstraintRepository) GetPermissions(ctx context.Context, zoneID string) ([]*models.ZonePermission, error) {
	const q = `
SELECT id, zone_id, user_id, permission_level, granted_by, granted_at
  FROM zone_permissions
 WHERE zone_id = $1::uuid`
	rows, err := r.pool.Query(ctx, q, zoneID)
	if err != nil {
		return nil, fmt.Errorf("get permissions: %w", err)
	}
	defer rows.Close()
	out := []*models.ZonePermission{}
	for rows.Next() {
		var p models.ZonePermission
		if err := rows.Scan(&p.ID, &p.ZoneID, &p.UserID, &p.Permission, &p.GrantedBy, &p.GrantedAt); err != nil {
			return nil, fmt.Errorf("scan permission: %w", err)
		}
		out = append(out, &p)
	}
	return out, rows.Err()
}

func (r *PgConstraintRepository) CheckPermission(ctx context.Context, zoneID, userID string) (string, error) {
	const q = `
SELECT permission_level
  FROM zone_permissions
 WHERE zone_id = $1::uuid AND user_id = $2
 LIMIT 1`
	var lvl string
	if err := r.pool.QueryRow(ctx, q, zoneID, userID).Scan(&lvl); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", fmt.Errorf("no permission found for user %s on zone %s", userID, zoneID)
		}
		return "", fmt.Errorf("check permission: %w", err)
	}
	return lvl, nil
}

// ================== Siting Analysis ==================

func (r *PgConstraintRepository) CreateSitingAnalysis(ctx context.Context, a *models.SitingAnalysis) error {
	const q = `
INSERT INTO siting_analyses (
  analysis_id, project_id, proposed_site_geometry_wkt, proposed_site_geometry,
  proposed_site_bounds_min_x, proposed_site_bounds_min_y,
  proposed_site_bounds_max_x, proposed_site_bounds_max_y,
  total_conflicts, blocker_count, error_count, warning_count, info_count,
  overall_risk_percentage, is_siteable, siting_recommendation,
  total_zones_checked, analyzed_by
) VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid, $3, ST_GeogFromText($4),
  $5, $6, $7, $8,
  $9, $10, $11, $12, $13,
  $14, $15, $16,
  $17, $18
) RETURNING analysis_id, analyzed_at`
	if err := r.pool.QueryRow(ctx, q,
		a.AnalysisID, a.ProjectID, a.ProposedSiteGeometry, wrapWKTSrid(a.ProposedSiteGeometry),
		a.ProposedSiteBounds.MinX, a.ProposedSiteBounds.MinY,
		a.ProposedSiteBounds.MaxX, a.ProposedSiteBounds.MaxY,
		a.RiskScore.TotalConflicts, a.RiskScore.BlockerCount, a.RiskScore.ErrorCount,
		a.RiskScore.WarningCount, a.RiskScore.InfoCount,
		a.RiskScore.OverallRiskPercentage, a.RiskScore.IsSiteable, a.RiskScore.SitingRecommendation,
		a.TotalZonesChecked, a.AnalyzedBy,
	).Scan(&a.AnalysisID, &a.AnalyzedAt); err != nil {
		return fmt.Errorf("insert siting analysis: %w", err)
	}
	return nil
}

func (r *PgConstraintRepository) GetSitingAnalysis(ctx context.Context, analysisID string) (*models.SitingAnalysis, error) {
	const q = `
SELECT analysis_id, project_id, proposed_site_geometry_wkt,
       proposed_site_bounds_min_x, proposed_site_bounds_min_y,
       proposed_site_bounds_max_x, proposed_site_bounds_max_y,
       total_conflicts, blocker_count, error_count, warning_count, info_count,
       overall_risk_percentage, is_siteable, siting_recommendation,
       total_zones_checked, analyzed_by, analyzed_at
  FROM siting_analyses
 WHERE analysis_id = $1::uuid`
	var a models.SitingAnalysis
	err := r.pool.QueryRow(ctx, q, analysisID).Scan(
		&a.AnalysisID, &a.ProjectID, &a.ProposedSiteGeometry,
		&a.ProposedSiteBounds.MinX, &a.ProposedSiteBounds.MinY,
		&a.ProposedSiteBounds.MaxX, &a.ProposedSiteBounds.MaxY,
		&a.RiskScore.TotalConflicts, &a.RiskScore.BlockerCount, &a.RiskScore.ErrorCount,
		&a.RiskScore.WarningCount, &a.RiskScore.InfoCount,
		&a.RiskScore.OverallRiskPercentage, &a.RiskScore.IsSiteable, &a.RiskScore.SitingRecommendation,
		&a.TotalZonesChecked, &a.AnalyzedBy, &a.AnalyzedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, fmt.Errorf("siting analysis not found: %s", analysisID)
		}
		return nil, fmt.Errorf("get siting analysis: %w", err)
	}
	return &a, nil
}

// AddSitingConflict inserts a conflict and links it to its parent analysis via
// the join table (migration 017). The link uses sequence ordering so callers
// see conflicts in detection order on replay.
func (r *PgConstraintRepository) AddSitingConflict(ctx context.Context, c *models.SitingConflict) error {
	tx, err := r.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin: %w", err)
	}
	defer func() { _ = tx.Rollback(ctx) }()

	const insertConflict = `
INSERT INTO siting_conflicts (
  conflict_id, zone_id, proposed_site_geometry_wkt, proposed_site_geometry,
  conflict_severity, conflict_reason, distance_meters, overlap_area_sqm, mitigation_suggestions
) VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid, $3, ST_GeogFromText($4),
  $5, $6, $7, $8, $9
) RETURNING id, conflict_id, detected_at`
	if err := tx.QueryRow(ctx, insertConflict,
		c.ConflictID, c.ZoneID, c.ProposedSiteGeometry, wrapWKTSrid(c.ProposedSiteGeometry),
		c.ConflictSeverity, c.ConflictReason, c.DistanceMeters, c.OverlapAreaSqm, c.MitigationSuggestions,
	).Scan(&c.ID, &c.ConflictID, &c.DetectedAt); err != nil {
		return fmt.Errorf("insert conflict: %w", err)
	}

	if c.AnalysisID != "" {
		const linkSQL = `
INSERT INTO siting_analysis_conflicts (analysis_id, conflict_id, sequence)
VALUES ($1::uuid, $2::uuid, COALESCE(
  (SELECT MAX(sequence)+1 FROM siting_analysis_conflicts WHERE analysis_id = $1::uuid),
  0
))
ON CONFLICT DO NOTHING`
		if _, err := tx.Exec(ctx, linkSQL, c.AnalysisID, c.ConflictID); err != nil {
			return fmt.Errorf("link conflict to analysis: %w", err)
		}
	}
	return tx.Commit(ctx)
}

func (r *PgConstraintRepository) GetConflictsForAnalysis(ctx context.Context, analysisID string) ([]*models.SitingConflict, error) {
	const q = `
SELECT c.id, c.conflict_id, c.zone_id, c.proposed_site_geometry_wkt,
       c.conflict_severity, c.conflict_reason, c.distance_meters,
       c.overlap_area_sqm, c.mitigation_suggestions, c.detected_at
  FROM siting_analysis_conflicts l
  JOIN siting_conflicts c ON c.conflict_id = l.conflict_id
 WHERE l.analysis_id = $1::uuid
 ORDER BY l.sequence ASC`
	rows, err := r.pool.Query(ctx, q, analysisID)
	if err != nil {
		return nil, fmt.Errorf("get conflicts for analysis: %w", err)
	}
	defer rows.Close()
	out := []*models.SitingConflict{}
	for rows.Next() {
		var c models.SitingConflict
		if err := rows.Scan(&c.ID, &c.ConflictID, &c.ZoneID, &c.ProposedSiteGeometry,
			&c.ConflictSeverity, &c.ConflictReason, &c.DistanceMeters,
			&c.OverlapAreaSqm, &c.MitigationSuggestions, &c.DetectedAt); err != nil {
			return nil, fmt.Errorf("scan conflict: %w", err)
		}
		c.AnalysisID = analysisID
		out = append(out, &c)
	}
	return out, rows.Err()
}

// ================== Statistics ==================

func (r *PgConstraintRepository) GetZoneStats(ctx context.Context, projectID string) (*models.ConstraintZoneStats, error) {
	const q = `
SELECT zone_type, zone_category, zone_status, COUNT(*), MAX(updated_at)
  FROM constraint_zones
 WHERE project_id = $1::uuid AND deleted_at IS NULL
 GROUP BY zone_type, zone_category, zone_status`
	rows, err := r.pool.Query(ctx, q, projectID)
	if err != nil {
		return nil, fmt.Errorf("zone stats: %w", err)
	}
	defer rows.Close()
	stats := &models.ConstraintZoneStats{
		ProjectID:  projectID,
		ByType:     map[string]int32{},
		ByCategory: map[string]int32{},
	}
	var lastModified time.Time
	for rows.Next() {
		var ztype, zcat, zstatus string
		var cnt int32
		var lm time.Time
		if err := rows.Scan(&ztype, &zcat, &zstatus, &cnt, &lm); err != nil {
			return nil, fmt.Errorf("scan stats row: %w", err)
		}
		stats.TotalZones += cnt
		stats.ByType[ztype] += cnt
		stats.ByCategory[zcat] += cnt
		switch zstatus {
		case "ACTIVE":
			stats.ActiveZones += cnt
		case "INACTIVE":
			stats.InactiveZones += cnt
		case "EXPIRED":
			stats.ExpiredZones += cnt
		}
		if lm.After(lastModified) {
			lastModified = lm
		}
	}
	stats.LastZoneModifiedAt = lastModified
	return stats, rows.Err()
}

func (r *PgConstraintRepository) GetZonesExpiringBefore(ctx context.Context, projectID string, before time.Time) ([]*models.ConstraintZone, error) {
	const q = `
SELECT id, zone_id, name, description, zone_type, zone_category, zone_status,
       geometry_wkt, geometry_type,
       bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y,
       effective_start_at, effective_end_at,
       source, source_id, buffer_distance_m,
       tags, metadata, created_by, project_id, is_public,
       created_at, updated_at, deleted_at, deleted_reason
  FROM constraint_zones
 WHERE project_id = $1::uuid
   AND deleted_at IS NULL
   AND effective_end_at IS NOT NULL
   AND effective_end_at < $2`
	return r.queryZones(ctx, q, projectID, before)
}

// ================== Bulk ==================

func (r *PgConstraintRepository) ImportZones(ctx context.Context, req *models.ZoneImportRequest) (*models.ZoneImportResult, error) {
	result := &models.ZoneImportResult{
		ProjectID:  req.ProjectID,
		TotalZones: int32(len(req.Zones)),
		ImportedAt: time.Now().UTC(),
	}
	for i := range req.Zones {
		z := &req.Zones[i]
		z.ProjectID = req.ProjectID
		if err := r.CreateZone(ctx, z); err != nil {
			result.FailureCount++
			result.Errors = append(result.Errors, models.ZoneImportError{
				ZoneName: z.Name,
				Error:    err.Error(),
			})
			continue
		}
		result.SuccessCount++
	}
	return result, nil
}

// ================== Cleanup ==================

func (r *PgConstraintRepository) PurgeDeletedZones(ctx context.Context, olderThan time.Time) (int64, error) {
	const q = `DELETE FROM constraint_zones WHERE deleted_at IS NOT NULL AND deleted_at < $1`
	tag, err := r.pool.Exec(ctx, q, olderThan)
	if err != nil {
		return 0, fmt.Errorf("purge: %w", err)
	}
	return tag.RowsAffected(), nil
}

// ================== helpers ==================

// rowScanner abstracts pgx.Row and pgx.Rows so scanZone is reusable.
type rowScanner interface {
	Scan(dest ...any) error
}

func scanZone(s rowScanner) (*models.ConstraintZone, error) {
	var z models.ConstraintZone
	var metadataRaw []byte
	if err := s.Scan(
		&z.ID, &z.ZoneID, &z.Name, &z.Description, &z.ZoneType, &z.ZoneCategory, &z.ZoneStatus,
		&z.GeometryWKT, &z.GeometryType,
		&z.BBoxMinX, &z.BBoxMinY, &z.BBoxMaxX, &z.BBoxMaxY,
		&z.EffectiveStartAt, &z.EffectiveEndAt,
		&z.Source, &z.SourceID, &z.BufferDistanceM,
		&z.Tags, &metadataRaw, &z.CreatedBy, &z.ProjectID, &z.IsPublic,
		&z.CreatedAt, &z.UpdatedAt, &z.DeletedAt, &z.DeletedReason,
	); err != nil {
		return nil, err
	}
	z.Metadata = decodeStringMap(metadataRaw)
	return &z, nil
}

func (r *PgConstraintRepository) queryZones(ctx context.Context, q string, args ...any) ([]*models.ConstraintZone, error) {
	rows, err := r.pool.Query(ctx, q, args...)
	if err != nil {
		return nil, fmt.Errorf("query zones: %w", err)
	}
	defer rows.Close()
	out := []*models.ConstraintZone{}
	for rows.Next() {
		z, err := scanZone(rows)
		if err != nil {
			return nil, fmt.Errorf("scan zone: %w", err)
		}
		out = append(out, z)
	}
	return out, rows.Err()
}

func encodeMetadata(m map[string]string) ([]byte, error) {
	if m == nil {
		return []byte(`{}`), nil
	}
	return json.Marshal(m)
}

func decodeStringMap(raw []byte) map[string]string {
	if len(raw) == 0 {
		return map[string]string{}
	}
	var out map[string]string
	if err := json.Unmarshal(raw, &out); err != nil {
		return map[string]string{}
	}
	if out == nil {
		return map[string]string{}
	}
	return out
}

func defaultStatus(s string) string {
	if s == "" {
		return "ACTIVE"
	}
	return s
}

// wrapWKTSrid prepends `SRID=4326;` if the caller hasn't already, so
// ST_GeogFromText / ST_GeomFromText interpret the geometry as WGS84.
func wrapWKTSrid(wkt string) string {
	if wkt == "" {
		return wkt
	}
	if strings.HasPrefix(strings.TrimSpace(wkt), "SRID=") {
		return wkt
	}
	return "SRID=4326;" + wkt
}
