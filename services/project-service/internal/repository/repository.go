package repository

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/project-service/internal/domain"
)

// ErrNotFound is returned when the requested entity does not exist.
var ErrNotFound = errors.New("not found")

// ProjectRepository defines persistence operations for projects and sites.
type ProjectRepository interface {
	CreateProject(ctx context.Context, p *domain.Project) error
	GetProject(ctx context.Context, id uuid.UUID) (*domain.Project, error)
	ListProjects(ctx context.Context, limit, offset int) ([]*domain.Project, error)
	UpdateProject(ctx context.Context, p *domain.Project) error
	DeleteProject(ctx context.Context, id uuid.UUID) error

	CreateSite(ctx context.Context, s *domain.Site) error
	UpsertSiteBoundary(ctx context.Context, s *domain.Site) error
	GetSiteByProjectID(ctx context.Context, projectID uuid.UUID) (*domain.Site, error)
	UpsertConstraintZones(ctx context.Context, siteID uuid.UUID, zones []domain.ConstraintZone) error
	GetConstraintZonesBySite(ctx context.Context, siteID uuid.UUID) ([]domain.ConstraintZone, error)
	DeleteConstraintZonesBySite(ctx context.Context, siteID uuid.UUID) error
}

// PgRepository implements ProjectRepository using a pgx connection pool.
type PgRepository struct {
	pool *pgxpool.Pool
}

// NewPgRepository creates a new PgRepository backed by the given pool.
func NewPgRepository(pool *pgxpool.Pool) *PgRepository {
	return &PgRepository{pool: pool}
}

// CreateProject inserts a new project row.
func (r *PgRepository) CreateProject(ctx context.Context, p *domain.Project) error {
	if p.ID == uuid.Nil {
		p.ID = uuid.New()
	}
	now := time.Now().UTC()
	p.CreatedAt = now
	p.UpdatedAt = now

	_, err := r.pool.Exec(ctx, `
		INSERT INTO projects (
			id, name, description, status,
			target_capacity_mw, location_name, client_name, notes,
			initial_latitude, initial_longitude,
			created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)`,
		p.ID, p.Name, p.Description, string(p.Status),
		p.TargetCapacityMW, p.LocationName, p.ClientName, p.Notes,
		p.InitialLatitude, p.InitialLongitude,
		p.CreatedAt, p.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert project: %w", err)
	}
	return nil
}

// GetProject retrieves a single project by ID.
func (r *PgRepository) GetProject(ctx context.Context, id uuid.UUID) (*domain.Project, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id, name, description, status,
		       target_capacity_mw, location_name, client_name, notes,
		       COALESCE(initial_latitude, 0), COALESCE(initial_longitude, 0),
		       created_at, updated_at
		  FROM projects
		 WHERE id = $1`, id)

	p := &domain.Project{}
	var status string
	err := row.Scan(
		&p.ID, &p.Name, &p.Description, &status,
		&p.TargetCapacityMW, &p.LocationName, &p.ClientName, &p.Notes,
		&p.InitialLatitude, &p.InitialLongitude,
		&p.CreatedAt, &p.UpdatedAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("get project: %w", err)
	}
	p.Status = domain.ProjectStatus(status)
	return p, nil
}

// ListProjects returns a paginated slice of projects ordered by creation time descending.
func (r *PgRepository) ListProjects(ctx context.Context, limit, offset int) ([]*domain.Project, error) {
	if limit <= 0 {
		limit = 50
	}
	if limit > 200 {
		limit = 200
	}

	rows, err := r.pool.Query(ctx, `
		SELECT id, name, description, status,
		       target_capacity_mw, location_name, client_name, notes,
		       COALESCE(initial_latitude, 0), COALESCE(initial_longitude, 0),
		       created_at, updated_at
		  FROM projects
		 ORDER BY created_at DESC
		 LIMIT $1 OFFSET $2`, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("list projects: %w", err)
	}
	defer rows.Close()

	var projects []*domain.Project
	for rows.Next() {
		p := &domain.Project{}
		var status string
		if err := rows.Scan(
			&p.ID, &p.Name, &p.Description, &status,
			&p.TargetCapacityMW, &p.LocationName, &p.ClientName, &p.Notes,
			&p.InitialLatitude, &p.InitialLongitude,
			&p.CreatedAt, &p.UpdatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan project row: %w", err)
		}
		p.Status = domain.ProjectStatus(status)
		projects = append(projects, p)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate project rows: %w", err)
	}
	return projects, nil
}

// UpdateProject updates a project's mutable fields by ID.
func (r *PgRepository) UpdateProject(ctx context.Context, p *domain.Project) error {
	p.UpdatedAt = time.Now().UTC()

	tag, err := r.pool.Exec(ctx, `
		UPDATE projects
		   SET name               = $2,
		       description        = $3,
		       status             = $4,
		       target_capacity_mw = $5,
		       location_name      = $6,
		       client_name        = $7,
		       notes              = $8,
		       initial_latitude   = $9,
		       initial_longitude  = $10,
		       updated_at         = $11
		 WHERE id = $1`,
		p.ID, p.Name, p.Description, string(p.Status),
		p.TargetCapacityMW, p.LocationName, p.ClientName, p.Notes,
		p.InitialLatitude, p.InitialLongitude,
		p.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("update project: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// DeleteProject removes a project by ID.
func (r *PgRepository) DeleteProject(ctx context.Context, id uuid.UUID) error {
	tag, err := r.pool.Exec(ctx, `DELETE FROM projects WHERE id = $1`, id)
	if err != nil {
		return fmt.Errorf("delete project: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// CreateSite inserts a new site row, storing the boundary via PostGIS ST_GeomFromGeoJSON.
func (r *PgRepository) CreateSite(ctx context.Context, s *domain.Site) error {
	if s.ID == uuid.Nil {
		s.ID = uuid.New()
	}
	s.CreatedAt = time.Now().UTC()

	tx, err := r.pool.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return fmt.Errorf("begin site tx: %w", err)
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	// Serialize site writes per project to avoid concurrent create requests
	// producing multiple rows for the same project.
	if _, err := tx.Exec(ctx, `SELECT id FROM projects WHERE id = $1 FOR UPDATE`, s.ProjectID); err != nil {
		return fmt.Errorf("lock project for site upsert: %w", err)
	}

	if _, err := tx.Exec(ctx, `DELETE FROM sites WHERE project_id = $1`, s.ProjectID); err != nil {
		return fmt.Errorf("delete existing site: %w", err)
	}

	_, err = tx.Exec(ctx, `
		INSERT INTO sites (
			id, project_id, name, boundary,
			area_sqm, latitude, longitude, timezone, created_at
		) VALUES (
			$1, $2, $3, ST_GeomFromGeoJSON($4),
			$5, $6, $7, $8, $9
		)`,
		s.ID, s.ProjectID, s.Name, s.BoundaryGeoJSON,
		s.AreaSqm, s.Latitude, s.Longitude, s.Timezone, s.CreatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert site: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("commit site tx: %w", err)
	}
	return nil
}

// UpsertSiteBoundary replaces the current site boundary for a project and derives
// area and centroid from the imported GeoJSON polygon.
func (r *PgRepository) UpsertSiteBoundary(ctx context.Context, s *domain.Site) error {
	if s.ID == uuid.Nil {
		s.ID = uuid.New()
	}
	s.CreatedAt = time.Now().UTC()

	tx, err := r.pool.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return fmt.Errorf("begin site boundary tx: %w", err)
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	if _, err := tx.Exec(ctx, `SELECT id FROM projects WHERE id = $1 FOR UPDATE`, s.ProjectID); err != nil {
		return fmt.Errorf("lock project for site boundary import: %w", err)
	}

	if _, err := tx.Exec(ctx, `DELETE FROM sites WHERE project_id = $1`, s.ProjectID); err != nil {
		return fmt.Errorf("delete existing site before boundary import: %w", err)
	}

	boundaryExpr := `ST_SetSRID(ST_GeomFromGeoJSON($4), 4326)`
	_, err = tx.Exec(ctx, `
		INSERT INTO sites (
			id, project_id, name, boundary,
			area_sqm, latitude, longitude, timezone, created_at
		) VALUES (
			$1, $2, $3, `+boundaryExpr+`,
			ST_Area(`+boundaryExpr+`::geography),
			ST_Y(ST_Centroid(`+boundaryExpr+`)),
			ST_X(ST_Centroid(`+boundaryExpr+`)),
			$5, $6
		)`,
		s.ID, s.ProjectID, s.Name, s.BoundaryGeoJSON, s.Timezone, s.CreatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert imported site boundary: %w", err)
	}

	row := tx.QueryRow(ctx, `
		SELECT area_sqm, latitude, longitude
		FROM sites
		WHERE id = $1`, s.ID)
	if err := row.Scan(&s.AreaSqm, &s.Latitude, &s.Longitude); err != nil {
		return fmt.Errorf("reload imported site boundary: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("commit site boundary tx: %w", err)
	}
	return nil
}

// GetSiteByProjectID retrieves the site associated with a project, returning
// the boundary as GeoJSON via PostGIS ST_AsGeoJSON.
func (r *PgRepository) GetSiteByProjectID(ctx context.Context, projectID uuid.UUID) (*domain.Site, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id, project_id, name,
		       ST_AsGeoJSON(boundary) AS boundary_geojson,
		       area_sqm, latitude, longitude, timezone, created_at
		  FROM sites
		 WHERE project_id = $1
		 ORDER BY created_at DESC
		 LIMIT 1`, projectID)

	s := &domain.Site{}
	err := row.Scan(
		&s.ID, &s.ProjectID, &s.Name,
		&s.BoundaryGeoJSON,
		&s.AreaSqm, &s.Latitude, &s.Longitude, &s.Timezone, &s.CreatedAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("get site by project id: %w", err)
	}
	return s, nil
}

// UpsertConstraintZones inserts or updates constraint zones for a site
func (r *PgRepository) UpsertConstraintZones(ctx context.Context, siteID uuid.UUID, zones []domain.ConstraintZone) error {
	if len(zones) == 0 {
		return nil
	}

	// Batch insert with conflict handling
	batch := pgx.Batch{}
	for _, zone := range zones {
		zone.ID = uuid.New()
		zone.SiteID = siteID

		batch.Queue(`
			INSERT INTO constraint_zones (
				id, site_id, zone_name, zone_type, geometry, area_sqm,
				severity_level, notes, source, created_at, updated_at
			)
			VALUES (
				$1, $2, $3, $4,
				ST_SetSRID(ST_GeomFromGeoJSON($5), 4326),
				$6, $7, $8, $9, NOW(), NOW()
			)
			ON CONFLICT (id) DO NOTHING
		`,
			zone.ID, zone.SiteID, zone.Name, zone.ZoneType,
			zone.BoundaryGeoJSON, zone.AreaSqm, zone.SeverityLevel,
			zone.Notes, zone.Source,
		)
	}

	results := r.pool.SendBatch(ctx, &batch)
	defer results.Close()

	for i := 0; i < batch.Len(); i++ {
		_, err := results.Exec()
		if err != nil {
			return fmt.Errorf("upsert constraint zone %d: %w", i, err)
		}
	}

	// Update site constraint zone count
	if _, err := r.pool.Exec(ctx, `
		UPDATE sites
		SET constraint_zone_count = (
			SELECT COUNT(*) FROM constraint_zones WHERE site_id = $1
		)
		WHERE id = $1
	`, siteID); err != nil {
		return fmt.Errorf("update zone count: %w", err)
	}

	return nil
}

// GetConstraintZonesBySite retrieves all constraint zones for a site
func (r *PgRepository) GetConstraintZonesBySite(ctx context.Context, siteID uuid.UUID) ([]domain.ConstraintZone, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT id, site_id, zone_name, zone_type, ST_AsGeoJSON(geometry) AS boundary_geojson,
		       area_sqm, severity_level, notes, source, created_at
		  FROM constraint_zones
		 WHERE site_id = $1
		 ORDER BY severity_level DESC, created_at ASC
	`, siteID)
	if err != nil {
		return nil, fmt.Errorf("query constraint zones: %w", err)
	}
	defer rows.Close()

	var zones []domain.ConstraintZone
	for rows.Next() {
		zone := domain.ConstraintZone{}
		err := rows.Scan(
			&zone.ID, &zone.SiteID, &zone.Name, &zone.ZoneType,
			&zone.BoundaryGeoJSON, &zone.AreaSqm, &zone.SeverityLevel,
			&zone.Notes, &zone.Source, &zone.CreatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("scan constraint zone: %w", err)
		}
		zones = append(zones, zone)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("rows error: %w", err)
	}

	return zones, nil
}

// DeleteConstraintZonesBySite removes all constraint zones for a site
func (r *PgRepository) DeleteConstraintZonesBySite(ctx context.Context, siteID uuid.UUID) error {
	result, err := r.pool.Exec(ctx, `DELETE FROM constraint_zones WHERE site_id = $1`, siteID)
	if err != nil {
		return fmt.Errorf("delete constraint zones: %w", err)
	}

	// Update site zone count
	if _, err := r.pool.Exec(ctx, `
		UPDATE sites
		SET constraint_zone_count = 0
		WHERE id = $1
	`, siteID); err != nil {
		return fmt.Errorf("update zone count: %w", err)
	}

	_ = result
	return nil
}
