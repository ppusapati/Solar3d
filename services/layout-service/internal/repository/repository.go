package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/layout-service/internal/domain"
)

// Repository provides persistence operations for the layout domain.
type Repository struct {
	pool *pgxpool.Pool
}

// New creates a new Repository backed by the given connection pool.
func New(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

// ---------------------------------------------------------------------------
// Layout CRUD
// ---------------------------------------------------------------------------

// CreateLayout inserts a new layout and returns it with generated fields.
func (r *Repository) CreateLayout(ctx context.Context, layout *domain.Layout) error {
	layout.ID = uuid.New()
	now := time.Now().UTC()
	layout.CreatedAt = now
	layout.UpdatedAt = now

	_, err := r.pool.Exec(ctx, `
		INSERT INTO layouts (id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
		layout.ID, layout.ProjectID, layout.Name,
		layout.TotalPanels, layout.TotalCapacityKW, layout.TileCount,
		layout.CreatedAt, layout.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("create layout: %w", err)
	}
	return nil
}

// GetLayout retrieves a layout by ID.
func (r *Repository) GetLayout(ctx context.Context, id uuid.UUID) (*domain.Layout, error) {
	l := &domain.Layout{}
	err := r.pool.QueryRow(ctx, `
		SELECT id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at
		FROM layouts WHERE id = $1`, id,
	).Scan(&l.ID, &l.ProjectID, &l.Name, &l.TotalPanels, &l.TotalCapacityKW, &l.TileCount, &l.CreatedAt, &l.UpdatedAt)
	if err != nil {
		return nil, fmt.Errorf("get layout: %w", err)
	}
	return l, nil
}

// ListLayoutsByProject returns all layouts belonging to a project.
func (r *Repository) ListLayoutsByProject(ctx context.Context, projectID uuid.UUID) ([]*domain.Layout, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at
		FROM layouts WHERE project_id = $1 ORDER BY created_at DESC`, projectID,
	)
	if err != nil {
		return nil, fmt.Errorf("list layouts: %w", err)
	}
	defer rows.Close()

	var layouts []*domain.Layout
	for rows.Next() {
		l := &domain.Layout{}
		if err := rows.Scan(&l.ID, &l.ProjectID, &l.Name, &l.TotalPanels, &l.TotalCapacityKW, &l.TileCount, &l.CreatedAt, &l.UpdatedAt); err != nil {
			return nil, fmt.Errorf("scan layout: %w", err)
		}
		layouts = append(layouts, l)
	}
	return layouts, rows.Err()
}

// UpdateLayout updates mutable fields on a layout.
func (r *Repository) UpdateLayout(ctx context.Context, layout *domain.Layout) error {
	layout.UpdatedAt = time.Now().UTC()
	_, err := r.pool.Exec(ctx, `
		UPDATE layouts SET name = $2, total_panels = $3, total_capacity_kw = $4, tile_count = $5, updated_at = $6
		WHERE id = $1`,
		layout.ID, layout.Name, layout.TotalPanels, layout.TotalCapacityKW, layout.TileCount, layout.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("update layout: %w", err)
	}
	return nil
}

// DeleteLayout removes a layout and all cascaded children.
func (r *Repository) DeleteLayout(ctx context.Context, id uuid.UUID) error {
	_, err := r.pool.Exec(ctx, `DELETE FROM layouts WHERE id = $1`, id)
	if err != nil {
		return fmt.Errorf("delete layout: %w", err)
	}
	return nil
}

// ---------------------------------------------------------------------------
// Component CRUD
// ---------------------------------------------------------------------------

// CreateComponent inserts a new component placement.
func (r *Repository) CreateComponent(ctx context.Context, c *domain.Component) error {
	c.ID = uuid.New()
	c.CreatedAt = time.Now().UTC()

	posJSON, err := json.Marshal(c.Position)
	if err != nil {
		return fmt.Errorf("marshal position: %w", err)
	}
	rotJSON, err := json.Marshal(c.Rotation)
	if err != nil {
		return fmt.Errorf("marshal rotation: %w", err)
	}

	_, err = r.pool.Exec(ctx, `
		INSERT INTO components (id, layout_id, asset_id, component_type, position, rotation, metadata, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
		c.ID, c.LayoutID, c.AssetID, c.ComponentType, posJSON, rotJSON, c.Metadata, c.CreatedAt,
	)
	if err != nil {
		return fmt.Errorf("create component: %w", err)
	}
	return nil
}

// GetComponent retrieves a component by ID.
func (r *Repository) GetComponent(ctx context.Context, id uuid.UUID) (*domain.Component, error) {
	c := &domain.Component{}
	var posJSON, rotJSON []byte
	err := r.pool.QueryRow(ctx, `
		SELECT id, layout_id, asset_id, component_type, position, rotation, metadata, created_at
		FROM components WHERE id = $1`, id,
	).Scan(&c.ID, &c.LayoutID, &c.AssetID, &c.ComponentType, &posJSON, &rotJSON, &c.Metadata, &c.CreatedAt)
	if err != nil {
		return nil, fmt.Errorf("get component: %w", err)
	}
	if err := json.Unmarshal(posJSON, &c.Position); err != nil {
		return nil, fmt.Errorf("unmarshal component position: %w", err)
	}
	if err := json.Unmarshal(rotJSON, &c.Rotation); err != nil {
		return nil, fmt.Errorf("unmarshal component rotation: %w", err)
	}
	return c, nil
}

// ListComponentsByLayout returns all components belonging to a layout.
func (r *Repository) ListComponentsByLayout(ctx context.Context, layoutID uuid.UUID) ([]*domain.Component, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT id, layout_id, asset_id, component_type, position, rotation, metadata, created_at
		FROM components WHERE layout_id = $1 ORDER BY created_at`, layoutID,
	)
	if err != nil {
		return nil, fmt.Errorf("list components: %w", err)
	}
	defer rows.Close()

	var components []*domain.Component
	for rows.Next() {
		c := &domain.Component{}
		var posJSON, rotJSON []byte
		if err := rows.Scan(&c.ID, &c.LayoutID, &c.AssetID, &c.ComponentType, &posJSON, &rotJSON, &c.Metadata, &c.CreatedAt); err != nil {
			return nil, fmt.Errorf("scan component: %w", err)
		}
		if err := json.Unmarshal(posJSON, &c.Position); err != nil {
			return nil, fmt.Errorf("unmarshal component position: %w", err)
		}
		if err := json.Unmarshal(rotJSON, &c.Rotation); err != nil {
			return nil, fmt.Errorf("unmarshal component rotation: %w", err)
		}
		components = append(components, c)
	}
	return components, rows.Err()
}

// DeleteComponent removes a component by ID.
func (r *Repository) DeleteComponent(ctx context.Context, id uuid.UUID) error {
	_, err := r.pool.Exec(ctx, `DELETE FROM components WHERE id = $1`, id)
	if err != nil {
		return fmt.Errorf("delete component: %w", err)
	}
	return nil
}

// ---------------------------------------------------------------------------
// Tile operations
// ---------------------------------------------------------------------------

// GetTilesByViewport returns tiles whose bounding boxes intersect the viewport.
// Uses PostGIS ST_MakeEnvelope && geometry intersection for efficient spatial queries.
func (r *Repository) GetTilesByViewport(ctx context.Context, layoutID uuid.UUID, vq domain.ViewportQuery) ([]*domain.LayoutTile, error) {
	query := `
		SELECT id, layout_id, min_x, min_y, max_x, max_y, lod_level, panel_count, metadata, created_at
		FROM layout_tiles
		WHERE layout_id = $1
		  AND ST_MakeEnvelope(min_x, min_y, max_x, max_y, 0) &&
		      ST_MakeEnvelope($2, $3, $4, $5, 0)`

	args := []any{layoutID, vq.MinX, vq.MinY, vq.MaxX, vq.MaxY}

	if vq.LODLevel != nil {
		query += ` AND lod_level = $6`
		args = append(args, *vq.LODLevel)
	}

	query += ` ORDER BY min_x, min_y`

	rows, err := r.pool.Query(ctx, query, args...)
	if err != nil {
		return nil, fmt.Errorf("get tiles by viewport: %w", err)
	}
	defer rows.Close()

	var tiles []*domain.LayoutTile
	for rows.Next() {
		t := &domain.LayoutTile{}
		if err := rows.Scan(
			&t.ID, &t.LayoutID,
			&t.BBox.MinX, &t.BBox.MinY, &t.BBox.MaxX, &t.BBox.MaxY,
			&t.LODLevel, &t.PanelCount, &t.Metadata, &t.CreatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan tile: %w", err)
		}
		tiles = append(tiles, t)
	}
	return tiles, rows.Err()
}

// GetPanelsByTile returns all panels belonging to a tile.
func (r *Repository) GetPanelsByTile(ctx context.Context, tileID uuid.UUID) ([]*domain.Panel, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT id, tile_id, string_id, geometry_geojson, tilt, azimuth, elevation, metadata
		FROM panels WHERE tile_id = $1 ORDER BY string_id`, tileID,
	)
	if err != nil {
		return nil, fmt.Errorf("get panels by tile: %w", err)
	}
	defer rows.Close()

	var panels []*domain.Panel
	for rows.Next() {
		p := &domain.Panel{}
		if err := rows.Scan(&p.ID, &p.TileID, &p.StringID, &p.GeometryGeoJSON, &p.Tilt, &p.Azimuth, &p.Elevation, &p.Metadata); err != nil {
			return nil, fmt.Errorf("scan panel: %w", err)
		}
		panels = append(panels, p)
	}
	return panels, rows.Err()
}

// ---------------------------------------------------------------------------
// Bulk insert operations (critical path for 100k-500k panels)
// ---------------------------------------------------------------------------

// BulkInsertTiles inserts tiles using COPY for maximum throughput.
func (r *Repository) BulkInsertTiles(ctx context.Context, tiles []*domain.LayoutTile) error {
	if len(tiles) == 0 {
		return nil
	}

	log.Info().Int("count", len(tiles)).Msg("bulk inserting tiles")

	columns := []string{"id", "layout_id", "min_x", "min_y", "max_x", "max_y", "lod_level", "panel_count", "metadata", "created_at"}

	rows := make([][]any, 0, len(tiles))
	for _, t := range tiles {
		t.ID = uuid.New()
		t.CreatedAt = time.Now().UTC()
		rows = append(rows, []any{
			t.ID, t.LayoutID,
			t.BBox.MinX, t.BBox.MinY, t.BBox.MaxX, t.BBox.MaxY,
			t.LODLevel, t.PanelCount, t.Metadata, t.CreatedAt,
		})
	}

	_, err := r.pool.CopyFrom(ctx, pgx.Identifier{"layout_tiles"}, columns, pgx.CopyFromRows(rows))
	if err != nil {
		return fmt.Errorf("bulk insert tiles: %w", err)
	}

	log.Info().Int("count", len(tiles)).Msg("tiles inserted")
	return nil
}

// BulkInsertPanels inserts panels using COPY for maximum throughput.
// This is the critical path: a 500k-panel project depends on this being fast.
func (r *Repository) BulkInsertPanels(ctx context.Context, panels []*domain.Panel) error {
	if len(panels) == 0 {
		return nil
	}

	log.Info().Int("count", len(panels)).Msg("bulk inserting panels")

	columns := []string{"id", "tile_id", "string_id", "geometry_geojson", "tilt", "azimuth", "elevation", "metadata"}

	// Process in batches of 50,000 to control memory.
	const batchSize = 50_000
	for start := 0; start < len(panels); start += batchSize {
		end := start + batchSize
		if end > len(panels) {
			end = len(panels)
		}
		batch := panels[start:end]

		rows := make([][]any, 0, len(batch))
		for _, p := range batch {
			p.ID = uuid.New()
			rows = append(rows, []any{
				p.ID, p.TileID, p.StringID, p.GeometryGeoJSON,
				p.Tilt, p.Azimuth, p.Elevation, p.Metadata,
			})
		}

		_, err := r.pool.CopyFrom(ctx, pgx.Identifier{"panels"}, columns, pgx.CopyFromRows(rows))
		if err != nil {
			return fmt.Errorf("bulk insert panels batch %d-%d: %w", start, end, err)
		}

		log.Debug().Int("from", start).Int("to", end).Msg("panel batch inserted")
	}

	log.Info().Int("count", len(panels)).Msg("panels inserted")
	return nil
}

// DeleteTilesByLayout removes all tiles (and cascaded panels) for a layout.
func (r *Repository) DeleteTilesByLayout(ctx context.Context, layoutID uuid.UUID) error {
	_, err := r.pool.Exec(ctx, `DELETE FROM layout_tiles WHERE layout_id = $1`, layoutID)
	if err != nil {
		return fmt.Errorf("delete tiles by layout: %w", err)
	}
	return nil
}
