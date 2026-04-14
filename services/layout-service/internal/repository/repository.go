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

	"solar3d/layout-service/internal/domain"
)

// CandidatePanelArtifact represents one frozen panel geometry row from the
// candidate artifact graph tables.
type CandidatePanelArtifact struct {
	Geometry json.RawMessage
	Tilt     float64
	Azimuth  float64
	PowerKW  float64
	StringID string
	Metadata json.RawMessage
}

// CandidateImportPayload is the data required to materialize a selected
// candidate artifact graph into layout tiles/panels.
type CandidateImportPayload struct {
	CandidateID           uuid.UUID
	ProjectID             uuid.UUID
	ArtifactGraphLayoutID uuid.UUID
	SelectionReason       string
	Panels                []CandidatePanelArtifact
}

func stringIDToUUID(value string) uuid.UUID {
	if value == "" {
		return uuid.New()
	}
	if parsed, err := uuid.Parse(value); err == nil {
		return parsed
	}
	return uuid.NewSHA1(uuid.NameSpaceOID, []byte(value))
}

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
		INSERT INTO layouts (id, project_id, name, total_panels, total_capacity_kw, tile_count, candidate_id, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
		layout.ID, layout.ProjectID, layout.Name,
		layout.TotalPanels, layout.TotalCapacityKW, layout.TileCount, layout.CandidateID,
		layout.CreatedAt, layout.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("create layout: %w", err)
	}
	return nil
}

// GetLayout retrieves a layout by ID, including its review_metadata if present.
func (r *Repository) GetLayout(ctx context.Context, id uuid.UUID) (*domain.Layout, error) {
	l := &domain.Layout{}
	var metaJSON []byte
	var candidateID *uuid.UUID
	err := r.pool.QueryRow(ctx, `
		SELECT id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at, candidate_id,
		       COALESCE(review_metadata, '{"status":"DRAFT"}'::jsonb)
		FROM layouts WHERE id = $1`, id,
	).Scan(&l.ID, &l.ProjectID, &l.Name, &l.TotalPanels, &l.TotalCapacityKW, &l.TileCount, &l.CreatedAt, &l.UpdatedAt, &candidateID, &metaJSON)
	if err != nil {
		return nil, fmt.Errorf("get layout: %w", err)
	}
	l.CandidateID = candidateID
	if len(metaJSON) > 0 {
		l.ReviewMetadata = &domain.ReviewMetadata{}
		if err := json.Unmarshal(metaJSON, l.ReviewMetadata); err != nil {
			return nil, fmt.Errorf("unmarshal review_metadata: %w", err)
		}
	}
	return l, nil
}

// ListLayoutsByProject returns all layouts belonging to a project.
func (r *Repository) ListLayoutsByProject(ctx context.Context, projectID uuid.UUID) ([]*domain.Layout, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT id, project_id, name, total_panels, total_capacity_kw, tile_count, created_at, updated_at, candidate_id,
		       COALESCE(review_metadata, '{"status":"DRAFT"}'::jsonb)
		FROM layouts WHERE project_id = $1 ORDER BY created_at DESC`, projectID,
	)
	if err != nil {
		return nil, fmt.Errorf("list layouts: %w", err)
	}
	defer rows.Close()

	var layouts []*domain.Layout
	for rows.Next() {
		l := &domain.Layout{}
		var metaJSON []byte
		var candidateID *uuid.UUID
		if err := rows.Scan(&l.ID, &l.ProjectID, &l.Name, &l.TotalPanels, &l.TotalCapacityKW, &l.TileCount, &l.CreatedAt, &l.UpdatedAt, &candidateID, &metaJSON); err != nil {
			return nil, fmt.Errorf("scan layout: %w", err)
		}
		l.CandidateID = candidateID
		if len(metaJSON) > 0 {
			l.ReviewMetadata = &domain.ReviewMetadata{}
			if err := json.Unmarshal(metaJSON, l.ReviewMetadata); err != nil {
				return nil, fmt.Errorf("unmarshal review_metadata: %w", err)
			}
		}
		layouts = append(layouts, l)
	}
	return layouts, rows.Err()
}

// UpdateLayout updates mutable fields on a layout.
func (r *Repository) UpdateLayout(ctx context.Context, layout *domain.Layout) error {
	layout.UpdatedAt = time.Now().UTC()
	_, err := r.pool.Exec(ctx, `
		UPDATE layouts SET name = $2, total_panels = $3, total_capacity_kw = $4, tile_count = $5, candidate_id = $6, updated_at = $7
		WHERE id = $1`,
		layout.ID, layout.Name, layout.TotalPanels, layout.TotalCapacityKW, layout.TileCount, layout.CandidateID, layout.UpdatedAt,
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

// UpdateLayoutReviewMetadata persists the acceptance workflow state for a layout.
// Uses a narrow UPDATE to avoid overwriting unrelated fields.
func (r *Repository) UpdateLayoutReviewMetadata(ctx context.Context, layoutID uuid.UUID, metadata *domain.ReviewMetadata) error {
	metaJSON, err := json.Marshal(metadata)
	if err != nil {
		return fmt.Errorf("marshal review_metadata: %w", err)
	}
	_, err = r.pool.Exec(ctx,
		`UPDATE layouts SET review_metadata = $2, updated_at = NOW() WHERE id = $1`,
		layoutID, metaJSON,
	)
	if err != nil {
		return fmt.Errorf("update layout review_metadata: %w", err)
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

// MoveComponent updates position and rotation for an existing component.
func (r *Repository) MoveComponent(ctx context.Context, id uuid.UUID, position domain.Position, rotation domain.Position) error {
	posJSON, err := json.Marshal(position)
	if err != nil {
		return fmt.Errorf("marshal position: %w", err)
	}
	rotJSON, err := json.Marshal(rotation)
	if err != nil {
		return fmt.Errorf("marshal rotation: %w", err)
	}

	cmd, err := r.pool.Exec(ctx, `
		UPDATE components
		SET position = $2, rotation = $3
		WHERE id = $1`,
		id, posJSON, rotJSON,
	)
	if err != nil {
		return fmt.Errorf("move component: %w", err)
	}
	if cmd.RowsAffected() == 0 {
		return fmt.Errorf("move component: component not found")
	}
	return nil
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
		SELECT
			id,
			layout_id,
			ST_XMin(tile_bbox) AS min_x,
			ST_YMin(tile_bbox) AS min_y,
			ST_XMax(tile_bbox) AS max_x,
			ST_YMax(tile_bbox) AS max_y,
			lod_level,
			panel_count,
			metadata,
			created_at
		FROM layout_tiles
		WHERE layout_id = $1
		  AND tile_bbox && ST_MakeEnvelope($2, $3, $4, $5, 4326)`

	args := []any{layoutID, vq.MinX, vq.MinY, vq.MaxX, vq.MaxY}

	if vq.LODLevel != nil {
		query += ` AND lod_level = $6`
		args = append(args, *vq.LODLevel)
	}

	query += ` ORDER BY ST_XMin(tile_bbox), ST_YMin(tile_bbox)`

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
		SELECT id, tile_id, string_id::text, ST_AsGeoJSON(geometry), tilt, azimuth, elevation, metadata
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

	batch := &pgx.Batch{}
	for _, t := range tiles {
		if t.ID == uuid.Nil {
			t.ID = uuid.New()
		}
		t.CreatedAt = time.Now().UTC()
		batch.Queue(`
			INSERT INTO layout_tiles (id, layout_id, tile_bbox, lod_level, panel_count, metadata, created_at)
			VALUES ($1, $2, ST_MakeEnvelope($3, $4, $5, $6, 4326), $7, $8, $9, $10)
		`,
			t.ID,
			t.LayoutID,
			t.BBox.MinX,
			t.BBox.MinY,
			t.BBox.MaxX,
			t.BBox.MaxY,
			t.LODLevel,
			t.PanelCount,
			t.Metadata,
			t.CreatedAt,
		)
	}

	results := r.pool.SendBatch(ctx, batch)
	defer results.Close()
	for i := 0; i < len(tiles); i++ {
		if _, err := results.Exec(); err != nil {
			return fmt.Errorf("bulk insert tiles: %w", err)
		}
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

	// Process in batches of 10,000 to control memory and transaction size.
	const batchSize = 10_000
	for start := 0; start < len(panels); start += batchSize {
		end := start + batchSize
		if end > len(panels) {
			end = len(panels)
		}
		batch := panels[start:end]

		pgBatch := &pgx.Batch{}
		for _, p := range batch {
			p.ID = uuid.New()
			pgBatch.Queue(`
				INSERT INTO panels (id, tile_id, string_id, geometry, tilt, azimuth, elevation, metadata)
				VALUES ($1, $2, $3, ST_SetSRID(ST_GeomFromGeoJSON($4), 4326), $5, $6, $7, $8)
			`,
				p.ID,
				p.TileID,
				stringIDToUUID(p.StringID),
				string(p.GeometryGeoJSON),
				p.Tilt,
				p.Azimuth,
				p.Elevation,
				p.Metadata,
			)
		}

		results := r.pool.SendBatch(ctx, pgBatch)
		for i := 0; i < len(batch); i++ {
			if _, err := results.Exec(); err != nil {
				_ = results.Close()
				return fmt.Errorf("bulk insert panels batch %d-%d: %w", start, end, err)
			}
		}
		if err := results.Close(); err != nil {
			return fmt.Errorf("close panel batch %d-%d: %w", start, end, err)
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

// GetCandidateImportPayload loads one selected candidate and all panel artifacts
// needed to materialize it into the layout-service tables.
func (r *Repository) GetCandidateImportPayload(ctx context.Context, candidateID uuid.UUID) (*CandidateImportPayload, error) {
	payload := &CandidateImportPayload{}
	err := r.pool.QueryRow(ctx, `
		SELECT c.candidate_id, c.project_id, c.artifact_graph_layout_id,
		       COALESCE(cl.final_selection_reason, c.selection_reasoning)
		FROM ml_artifacts.ml_candidates c
		LEFT JOIN ml_artifacts.candidate_lineage cl ON cl.layout_id = c.artifact_graph_layout_id
		WHERE c.candidate_id = $1`, candidateID,
	).Scan(&payload.CandidateID, &payload.ProjectID, &payload.ArtifactGraphLayoutID, &payload.SelectionReason)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, domain.ErrCandidateNotFound
		}
		return nil, fmt.Errorf("get candidate payload: %w", err)
	}

	rows, err := r.pool.Query(ctx, `
		SELECT geometry, tilt_degrees::float8, azimuth_degrees::float8, mpp_capacity_kw::float8,
		       COALESCE(string_id::text, ''), COALESCE(precision_metadata, '{}'::jsonb)
		FROM ml_artifacts.solar_panels
		WHERE layout_id = $1
		ORDER BY panel_id`, payload.ArtifactGraphLayoutID)
	if err != nil {
		return nil, fmt.Errorf("query candidate panels: %w", err)
	}
	defer rows.Close()

	for rows.Next() {
		var p CandidatePanelArtifact
		if err := rows.Scan(&p.Geometry, &p.Tilt, &p.Azimuth, &p.PowerKW, &p.StringID, &p.Metadata); err != nil {
			return nil, fmt.Errorf("scan candidate panel: %w", err)
		}
		payload.Panels = append(payload.Panels, p)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate candidate panels: %w", err)
	}

	if len(payload.Panels) == 0 {
		return nil, domain.ErrCandidateEmpty
	}

	return payload, nil
}
