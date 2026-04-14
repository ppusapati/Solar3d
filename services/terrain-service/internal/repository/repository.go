package repository

import (
	"context"
	"database/sql"
	"fmt"
	"sync"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"

	"solar3d/terrain-service/internal/domain"
)

// Repository handles persistence of terrain layer metadata using PostgreSQL
// with PostGIS extensions. Elevation grid data is cached in memory for
// derived layers (slope, aspect) and uploaded DEMs.
type Repository struct {
	pool      *pgxpool.Pool
	logger    zerolog.Logger
	gridCache sync.Map // map[uuid.UUID]*domain.ElevationGrid
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

	// Clean up cached grid data
	r.gridCache.Delete(id)

	return nil
}

// StoreElevationGrid caches an elevation grid for a given layer.
// This is used for both uploaded DEMs and derived layers (slope, aspect).
func (r *Repository) StoreElevationGrid(ctx context.Context, layerID uuid.UUID, grid *domain.ElevationGrid) error {
	r.gridCache.Store(layerID, grid)
	r.logger.Debug().
		Str("layer_id", layerID.String()).
		Int("width", grid.Width).
		Int("height", grid.Height).
		Msg("elevation grid cached")
	return nil
}

// GetElevationGrid retrieves a cached elevation grid for a given layer.
// Returns nil if no grid is cached.
func (r *Repository) GetElevationGrid(ctx context.Context, layerID uuid.UUID) (*domain.ElevationGrid, error) {
	val, ok := r.gridCache.Load(layerID)
	if !ok {
		return nil, nil
	}
	grid, ok := val.(*domain.ElevationGrid)
	if !ok {
		return nil, fmt.Errorf("invalid grid cache entry for layer %s", layerID)
	}
	return grid, nil
}

// ============================================================
// Copernicus DEM Job Repository Methods
// ============================================================

// CreateCopernicusDEMJob creates a new DEM download job.
func (r *Repository) CreateCopernicusDEMJob(ctx context.Context, job *domain.CopernicusDEMJob) (*domain.CopernicusDEMJob, error) {
	job.ID = uuid.New()

	query := `
		INSERT INTO copernicus_dem_jobs (
			id, terrain_layer_id, project_id, status, source_uri,
			bounds, resolution_m, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4, $5,
			ST_MakeEnvelope($6, $7, $8, $9, 4326),
			$10, NOW(), NOW()
		)
		RETURNING created_at, updated_at`

	err := r.pool.QueryRow(ctx, query,
		job.ID,
		job.TerrainLayerID,
		job.ProjectID,
		job.Status,
		job.SourceURI,
		job.Bounds.MinX,
		job.Bounds.MinY,
		job.Bounds.MaxX,
		job.Bounds.MaxY,
		job.ResolutionM,
	).Scan(&job.CreatedAt, &job.UpdatedAt)

	if err != nil {
		return nil, fmt.Errorf("create copernicus dem job: %w", err)
	}

	return job, nil
}

// GetCopernicusDEMJob retrieves a DEM job by ID.
func (r *Repository) GetCopernicusDEMJob(ctx context.Context, id uuid.UUID) (*domain.CopernicusDEMJob, error) {
	query := `
		SELECT
			id, terrain_layer_id, project_id, status, progress_percent,
			source_uri, ST_XMin(bounds), ST_YMin(bounds), ST_XMax(bounds), ST_YMax(bounds),
			resolution_m, total_tiles_requested, tiles_downloaded, tiles_ingested,
			tiles_failed, error_message, retry_count, max_retries,
			started_at, completed_at, next_retry_at, created_at, updated_at
		FROM copernicus_dem_jobs
		WHERE id = $1`

	var job domain.CopernicusDEMJob
	var status string
	var errorMessage sql.NullString

	err := r.pool.QueryRow(ctx, query, id).Scan(
		&job.ID,
		&job.TerrainLayerID,
		&job.ProjectID,
		&status,
		&job.ProgressPercent,
		&job.SourceURI,
		&job.Bounds.MinX,
		&job.Bounds.MinY,
		&job.Bounds.MaxX,
		&job.Bounds.MaxY,
		&job.ResolutionM,
		&job.TotalTilesRequested,
		&job.TilesDownloaded,
		&job.TilesIngested,
		&job.TilesFailed,
		&errorMessage,
		&job.RetryCount,
		&job.MaxRetries,
		&job.StartedAt,
		&job.CompletedAt,
		&job.NextRetryAt,
		&job.CreatedAt,
		&job.UpdatedAt,
	)

	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("copernicus dem job %s not found", id)
		}
		return nil, fmt.Errorf("get copernicus dem job: %w", err)
	}

	job.Status = domain.CopernicusDEMJobStatus(status)
	if errorMessage.Valid {
		job.ErrorMessage = errorMessage.String
	} else {
		job.ErrorMessage = ""
	}
	return &job, nil
}

// ListPendingDEMJobs retrieves all pending/failed DEM jobs that are ready to process.
func (r *Repository) ListPendingDEMJobs(ctx context.Context) ([]domain.CopernicusDEMJob, error) {
	query := `
		SELECT
			id, terrain_layer_id, project_id, status, progress_percent,
			source_uri, ST_XMin(bounds), ST_YMin(bounds), ST_XMax(bounds), ST_YMax(bounds),
			resolution_m, total_tiles_requested, tiles_downloaded, tiles_ingested,
			tiles_failed, error_message, retry_count, max_retries,
			started_at, completed_at, next_retry_at, created_at, updated_at
		FROM copernicus_dem_jobs
		WHERE (status = 'pending' OR (status = 'failed' AND retry_count < max_retries))
		  AND (next_retry_at IS NULL OR next_retry_at <= NOW())
		ORDER BY created_at ASC
		LIMIT 10`

	rows, err := r.pool.Query(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("list pending dem jobs: %w", err)
	}
	defer rows.Close()

	var jobs []domain.CopernicusDEMJob
	for rows.Next() {
		var job domain.CopernicusDEMJob
		var status string
		var errorMessage sql.NullString

		if err := rows.Scan(
			&job.ID,
			&job.TerrainLayerID,
			&job.ProjectID,
			&status,
			&job.ProgressPercent,
			&job.SourceURI,
			&job.Bounds.MinX,
			&job.Bounds.MinY,
			&job.Bounds.MaxX,
			&job.Bounds.MaxY,
			&job.ResolutionM,
			&job.TotalTilesRequested,
			&job.TilesDownloaded,
			&job.TilesIngested,
			&job.TilesFailed,
			&errorMessage,
			&job.RetryCount,
			&job.MaxRetries,
			&job.StartedAt,
			&job.CompletedAt,
			&job.NextRetryAt,
			&job.CreatedAt,
			&job.UpdatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan dem job row: %w", err)
		}

		job.Status = domain.CopernicusDEMJobStatus(status)
		if errorMessage.Valid {
			job.ErrorMessage = errorMessage.String
		} else {
			job.ErrorMessage = ""
		}
		jobs = append(jobs, job)
	}

	return jobs, rows.Err()
}

// UpdateCopernicusDEMJob updates DEM job progress and status.
func (r *Repository) UpdateCopernicusDEMJob(ctx context.Context, job *domain.CopernicusDEMJob) error {
	query := `
		UPDATE copernicus_dem_jobs
		SET status = $1,
			progress_percent = $2,
			tiles_downloaded = $3,
			tiles_ingested = $4,
			tiles_failed = $5,
			error_message = $6,
			retry_count = $7,
			started_at = COALESCE(started_at, $8),
			completed_at = $9,
			next_retry_at = $10,
			updated_at = NOW()
		WHERE id = $11`

	tag, err := r.pool.Exec(ctx, query,
		job.Status,
		job.ProgressPercent,
		job.TilesDownloaded,
		job.TilesIngested,
		job.TilesFailed,
		job.ErrorMessage,
		job.RetryCount,
		job.StartedAt,
		job.CompletedAt,
		job.NextRetryAt,
		job.ID,
	)

	if err != nil {
		return fmt.Errorf("update copernicus dem job: %w", err)
	}

	if tag.RowsAffected() == 0 {
		return fmt.Errorf("copernicus dem job %s not found", job.ID)
	}

	return nil
}

// ============================================================
// DEM Tile Cache Repository Methods
// ============================================================

// CacheDEMTile stores a downloaded and parsed DEM tile in the cache.
func (r *Repository) CacheDEMTile(ctx context.Context, tile *domain.DEMTileCache) error {
	query := `
		INSERT INTO dem_tile_cache (
			id, project_id, terrain_layer_id, tile_row, tile_col,
			source_uri, bounds, elevation_data, width, height,
			resolution_m, min_elevation, max_elevation, source_timestamp,
			checksum, ingested_at, expires_at
		) VALUES (
			$1, $2, $3, $4, $5,
			$6, ST_MakeEnvelope($7, $8, $9, $10, 4326), $11, $12, $13,
			$14, $15, $16, $17, $18, NOW(), $19
		)
		ON CONFLICT (terrain_layer_id, tile_row, tile_col)
		DO UPDATE SET
			elevation_data = $11,
			min_elevation = $15,
			max_elevation = $16,
			checksum = $18,
			ingested_at = NOW()
		RETURNING ingested_at`

	tile.ID = uuid.New()

	err := r.pool.QueryRow(ctx, query,
		tile.ID,
		tile.ProjectID,
		tile.TerrainLayerID,
		tile.TileRow,
		tile.TileCol,
		tile.SourceURI,
		tile.Bounds.MinX,
		tile.Bounds.MinY,
		tile.Bounds.MaxX,
		tile.Bounds.MaxY,
		tile.ElevationData,
		tile.Width,
		tile.Height,
		tile.ResolutionM,
		tile.MinElevation,
		tile.MaxElevation,
		tile.SourceTimestamp,
		tile.Checksum,
		tile.ExpiresAt,
	).Scan(&tile.IngestedAt)

	if err != nil {
		return fmt.Errorf("cache dem tile: %w", err)
	}

	return nil
}

// GetDEMTilesCovering retrieves all cached DEM tiles that cover the given bounding box.
func (r *Repository) GetDEMTilesCovering(ctx context.Context, layerID uuid.UUID, bounds domain.BoundingBox) ([]domain.DEMTileCache, error) {
	query := `
		SELECT
			id, project_id, terrain_layer_id, tile_row, tile_col, source_uri,
			ST_XMin(bounds), ST_YMin(bounds), ST_XMax(bounds), ST_YMax(bounds),
			elevation_data, width, height, resolution_m,
			min_elevation, max_elevation, source_timestamp, ingested_at, expires_at, checksum
		FROM dem_tile_cache
		WHERE terrain_layer_id = $1
		  AND ST_Intersects(
				bounds,
				ST_MakeEnvelope($2, $3, $4, $5, 4326)
			)
		  AND (expires_at IS NULL OR expires_at > NOW())
		ORDER BY tile_row, tile_col`

	rows, err := r.pool.Query(ctx, query,
		layerID,
		bounds.MinX,
		bounds.MinY,
		bounds.MaxX,
		bounds.MaxY,
	)
	if err != nil {
		return nil, fmt.Errorf("get dem tiles covering: %w", err)
	}
	defer rows.Close()

	var tiles []domain.DEMTileCache
	for rows.Next() {
		var tile domain.DEMTileCache

		if err := rows.Scan(
			&tile.ID,
			&tile.ProjectID,
			&tile.TerrainLayerID,
			&tile.TileRow,
			&tile.TileCol,
			&tile.SourceURI,
			&tile.Bounds.MinX,
			&tile.Bounds.MinY,
			&tile.Bounds.MaxX,
			&tile.Bounds.MaxY,
			&tile.ElevationData,
			&tile.Width,
			&tile.Height,
			&tile.ResolutionM,
			&tile.MinElevation,
			&tile.MaxElevation,
			&tile.SourceTimestamp,
			&tile.IngestedAt,
			&tile.ExpiresAt,
			&tile.Checksum,
		); err != nil {
			return nil, fmt.Errorf("scan dem tile row: %w", err)
		}

		tiles = append(tiles, tile)
	}

	return tiles, rows.Err()
}

// GetDEMMetrics returns monitoring counters for Copernicus DEM ingestion and cache footprint.
// If projectID is nil, metrics are aggregated across all projects.
func (r *Repository) GetDEMMetrics(ctx context.Context, projectID *uuid.UUID) (*domain.DEMMetrics, error) {
	metrics := &domain.DEMMetrics{ProjectID: projectID}

	var pid any
	if projectID == nil {
		pid = nil
	} else {
		pid = *projectID
	}

	statsQuery := `
		SELECT
			COUNT(*)::INT AS tile_count,
			COALESCE(SUM(OCTET_LENGTH(elevation_data)), 0)::BIGINT AS cached_bytes,
			COALESCE(SUM(CASE WHEN expires_at IS NOT NULL AND expires_at <= NOW() THEN 1 ELSE 0 END), 0)::INT AS expired_tile_count
		FROM dem_tile_cache
		WHERE ($1::uuid IS NULL OR project_id = $1)`

	var cachedBytes int64
	if err := r.pool.QueryRow(ctx, statsQuery, pid).Scan(
		&metrics.CachedTileCount,
		&cachedBytes,
		&metrics.ExpiredTileCount,
	); err != nil {
		return nil, fmt.Errorf("query dem cache metrics: %w", err)
	}
	metrics.CachedBytes = cachedBytes

	jobsQuery := `
		SELECT status, COUNT(*)::INT
		FROM copernicus_dem_jobs
		WHERE ($1::uuid IS NULL OR project_id = $1)
		GROUP BY status`

	rows, err := r.pool.Query(ctx, jobsQuery, pid)
	if err != nil {
		if err == sql.ErrNoRows {
			return metrics, nil
		}
		return nil, fmt.Errorf("query dem job metrics: %w", err)
	}
	defer rows.Close()

	for rows.Next() {
		var status string
		var count int
		if err := rows.Scan(&status, &count); err != nil {
			return nil, fmt.Errorf("scan dem job metrics row: %w", err)
		}
		switch status {
		case string(domain.DEMJobStatusPending):
			metrics.PendingJobs = count
		case string(domain.DEMJobStatusDownloading):
			metrics.DownloadingJobs = count
		case string(domain.DEMJobStatusIngesting):
			metrics.IngestingJobs = count
		case string(domain.DEMJobStatusCompleted):
			metrics.CompletedJobs = count
		case string(domain.DEMJobStatusFailed):
			metrics.FailedJobs = count
		}
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate dem job metrics rows: %w", err)
	}

	return metrics, nil
}

