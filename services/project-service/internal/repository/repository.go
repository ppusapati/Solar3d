package repository

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/solar3d/solar3d/services/project-service/internal/domain"
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
	GetSiteByProjectID(ctx context.Context, projectID uuid.UUID) (*domain.Site, error)
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
			created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
		p.ID, p.Name, p.Description, string(p.Status),
		p.TargetCapacityMW, p.LocationName, p.ClientName, p.Notes,
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
		       created_at, updated_at
		  FROM projects
		 WHERE id = $1`, id)

	p := &domain.Project{}
	var status string
	err := row.Scan(
		&p.ID, &p.Name, &p.Description, &status,
		&p.TargetCapacityMW, &p.LocationName, &p.ClientName, &p.Notes,
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
		   SET name              = $2,
		       description       = $3,
		       status            = $4,
		       target_capacity_mw = $5,
		       location_name     = $6,
		       client_name       = $7,
		       notes             = $8,
		       updated_at        = $9
		 WHERE id = $1`,
		p.ID, p.Name, p.Description, string(p.Status),
		p.TargetCapacityMW, p.LocationName, p.ClientName, p.Notes,
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

	_, err := r.pool.Exec(ctx, `
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
		 WHERE project_id = $1`, projectID)

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
