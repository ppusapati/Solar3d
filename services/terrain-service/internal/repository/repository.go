package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"

	"github.com/solar3d/solar3d/services/terrain-service/internal/domain"
)

// Repository handles persistence of terrain layer metadata using PostgreSQL
// with PostGIS extensions.
type Repository struct {
	pool   *pgxpool.Pool
	logger zerolog.Logger
}

// New creates a new Repository backed by the given connection pool.
func New(pool *pgxpool.Pool, logger zerolog.Logger) *Repository {
	return &Repository{
		pool:   pool,
		logger: logger.With().Str("component", "repository").Logger(),
	}
}

// CreateTerrainLayer inserts a new terrain layer record and returns the
// persisted entity with its generated ID and timestamp.
func (r *Repository) CreateTerrainLayer(ctx context.Context, layer *domain.TerrainLayer) (*domain.TerrainLayer, error) {
	layer.ID = uuid.New()

	query := `
		INSERT INTO terrain_layers (
			id, project_id, name, layer_type, source_file,
			bounds, resolution_m, crs,
			min_elevation, max_elevation
		) VALUES (
			$1, $2, $3, $4, $5,
			ST_MakeEnvelope($6, $7, $8, $9, 4326),
			$10, $11, $12, $13
		)
		RETURNING created_at`

	err := r.pool.QueryRow(ctx, query,
		layer.ID,
		layer.ProjectID,
		layer.Name,
		string(layer.LayerType),
		layer.SourceFile,
		layer.Bounds.MinX,
		layer.Bounds.MinY,
		layer.Bounds.MaxX,
		layer.Bounds.MaxY,
		layer.ResolutionM,
		layer.CRS,
		layer.MinElevation,
		layer.MaxElevation,
	).Scan(&layer.CreatedAt)
	if err != nil {
		return nil, fmt.Errorf("insert terrain layer: %w", err)
	}

	r.logger.Info().
		Str("layer_id", layer.ID.String()).
		Str("project_id", layer.ProjectID.String()).
		Msg("terrain layer created")

	return layer, nil
}

// GetTerrainLayer retrieves a single terrain layer by its ID.
func (r *Repository) GetTerrainLayer(ctx context.Context, id uuid.UUID) (*domain.TerrainLayer, error) {
	query := `
		SELECT
			id, project_id, name, layer_type, source_file,
			ST_XMin(bounds), ST_YMin(bounds), ST_XMax(bounds), ST_YMax(bounds),
			resolution_m, crs, min_elevation, max_elevation, created_at
		FROM terrain_layers
		WHERE id = $1`

	var layer domain.TerrainLayer
	var layerType string

	err := r.pool.QueryRow(ctx, query, id).Scan(
		&layer.ID,
		&layer.ProjectID,
		&layer.Name,
		&layerType,
		&layer.SourceFile,
		&layer.Bounds.MinX,
		&layer.Bounds.MinY,
		&layer.Bounds.MaxX,
		&layer.Bounds.MaxY,
		&layer.ResolutionM,
		&layer.CRS,
		&layer.MinElevation,
		&layer.MaxElevation,
		&layer.CreatedAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("terrain layer %s not found", id)
		}
		return nil, fmt.Errorf("get terrain layer: %w", err)
	}

	layer.LayerType = domain.LayerType(layerType)
	return &layer, nil
}

// ListTerrainLayers returns all terrain layers for a given project, ordered by
// creation time descending.
func (r *Repository) ListTerrainLayers(ctx context.Context, projectID uuid.UUID) ([]domain.TerrainLayer, error) {
	query := `
		SELECT
			id, project_id, name, layer_type, source_file,
			ST_XMin(bounds), ST_YMin(bounds), ST_XMax(bounds), ST_YMax(bounds),
			resolution_m, crs, min_elevation, max_elevation, created_at
		FROM terrain_layers
		WHERE project_id = $1
		ORDER BY created_at DESC`

	rows, err := r.pool.Query(ctx, query, projectID)
	if err != nil {
		return nil, fmt.Errorf("list terrain layers: %w", err)
	}
	defer rows.Close()

	var layers []domain.TerrainLayer
	for rows.Next() {
		var layer domain.TerrainLayer
		var layerType string

		if err := rows.Scan(
			&layer.ID,
			&layer.ProjectID,
			&layer.Name,
			&layerType,
			&layer.SourceFile,
			&layer.Bounds.MinX,
			&layer.Bounds.MinY,
			&layer.Bounds.MaxX,
			&layer.Bounds.MaxY,
			&layer.ResolutionM,
			&layer.CRS,
			&layer.MinElevation,
			&layer.MaxElevation,
			&layer.CreatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan terrain layer row: %w", err)
		}

		layer.LayerType = domain.LayerType(layerType)
		layers = append(layers, layer)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate terrain layers: %w", err)
	}

	return layers, nil
}

// DeleteTerrainLayer removes a terrain layer by ID. Returns an error if the
// layer does not exist.
func (r *Repository) DeleteTerrainLayer(ctx context.Context, id uuid.UUID) error {
	query := `DELETE FROM terrain_layers WHERE id = $1`

	tag, err := r.pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("delete terrain layer: %w", err)
	}

	if tag.RowsAffected() == 0 {
		return fmt.Errorf("terrain layer %s not found", id)
	}

	r.logger.Info().
		Str("layer_id", id.String()).
		Msg("terrain layer deleted")

	return nil
}
