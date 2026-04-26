package repository

// LOD400Repository provides read-only cross-table queries needed by the LOD 400
// scoring engine and a write method to persist scored results.
//
// All queries are parameterized and use pgxpool for connection pooling.
// Cross-table reads (layouts, electrical_networks, transmission_routes, components,
// panel_strings, inverter_groups) are permitted because this codebase uses a shared
// monolith Postgres schema — each service owns its domain tables but reads are
// cross-domain where the gate logic requires it.

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"p9e.in/samavaya/solar3d/project-service/internal/domain"
)

// LOD400Repository wraps a pgxpool.Pool for LOD 400 data access.
type LOD400Repository struct {
	pool *pgxpool.Pool
}

// NewLOD400Repository creates a LOD400Repository backed by the given pool.
func NewLOD400Repository(pool *pgxpool.Pool) *LOD400Repository {
	return &LOD400Repository{pool: pool}
}

// LOD400LayoutData is the minimal layout projection needed for LOD 400 scoring.
type LOD400LayoutData struct {
	TotalPanels          int64
	ReviewMetadataStatus string
}

// LOD400NetworkData is the minimal electrical network projection.
type LOD400NetworkData struct {
	NetworkID                  uuid.UUID
	DcAcRatio                  float64
	StringCount                int
	InverterCount              int
	ElectricalFeasibilityScore float64
	ReviewMetadataStatus       string
}

// LOD400TransmissionData is the minimal transmission route projection.
type LOD400TransmissionData struct {
	RouteID               uuid.UUID
	ReviewMetadataStatus  string
	ProtectionDevicesJSON []byte
	FaultIsolationPoints  int
}

// GetLayoutDataForLOD returns the panel count and acceptance status for a layout.
// Returns ErrNotFound when the layout does not exist.
func (r *LOD400Repository) GetLayoutDataForLOD(ctx context.Context, layoutID uuid.UUID) (*LOD400LayoutData, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT total_panels,
		       COALESCE(review_metadata->>'status', 'DRAFT')
		  FROM layouts
		 WHERE id = $1`, layoutID)

	d := &LOD400LayoutData{}
	err := row.Scan(&d.TotalPanels, &d.ReviewMetadataStatus)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("lod400 get layout: %w", err)
	}
	return d, nil
}

// GetComponentTypeCountsForLayout returns a map of component_type -> count for a layout.
// Returns an empty map when no components are placed.
func (r *LOD400Repository) GetComponentTypeCountsForLayout(ctx context.Context, layoutID uuid.UUID) (map[string]int, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT component_type, COUNT(*)::int
		  FROM components
		 WHERE layout_id = $1
		 GROUP BY component_type`, layoutID)
	if err != nil {
		return nil, fmt.Errorf("lod400 get component counts: %w", err)
	}
	defer rows.Close()

	counts := make(map[string]int)
	for rows.Next() {
		var ct string
		var n int
		if err := rows.Scan(&ct, &n); err != nil {
			return nil, fmt.Errorf("lod400 scan component row: %w", err)
		}
		counts[ct] = n
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("lod400 component counts rows: %w", err)
	}
	return counts, nil
}

// GetNetworkDataForLayout returns the most recently created electrical network for a layout.
// Returns nil (not an error) when no network exists.
func (r *LOD400Repository) GetNetworkDataForLayout(ctx context.Context, layoutID uuid.UUID) (*LOD400NetworkData, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id,
		       COALESCE(dc_ac_ratio, 0.0),
		       COALESCE(string_count, 0),
		       COALESCE(inverter_count, 0),
		       COALESCE(electrical_feasibility_score, 0.0),
		       COALESCE(review_metadata->>'status', 'DRAFT')
		  FROM electrical_networks
		 WHERE layout_id = $1
		 ORDER BY created_at DESC
		 LIMIT 1`, layoutID)

	d := &LOD400NetworkData{}
	err := row.Scan(
		&d.NetworkID, &d.DcAcRatio, &d.StringCount, &d.InverterCount,
		&d.ElectricalFeasibilityScore, &d.ReviewMetadataStatus,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil // no network is not an error; caller will emit FAILED check
	}
	if err != nil {
		return nil, fmt.Errorf("lod400 get network: %w", err)
	}
	return d, nil
}

// GetInverterGroupCountForNetwork returns the number of inverter groups assigned to a network.
func (r *LOD400Repository) GetInverterGroupCountForNetwork(ctx context.Context, networkID uuid.UUID) (int, error) {
	var count int
	err := r.pool.QueryRow(ctx,
		`SELECT COUNT(*)::int FROM inverter_groups WHERE network_id = $1`, networkID,
	).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("lod400 inverter group count: %w", err)
	}
	return count, nil
}

// GetAssignedStringCountForNetwork returns the number of panel strings with an assigned
// inverter group in a network.
func (r *LOD400Repository) GetAssignedStringCountForNetwork(ctx context.Context, networkID uuid.UUID) (int, error) {
	var count int
	err := r.pool.QueryRow(ctx,
		`SELECT COUNT(*)::int FROM panel_strings WHERE network_id = $1 AND inverter_group_id IS NOT NULL`,
		networkID,
	).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("lod400 assigned string count: %w", err)
	}
	return count, nil
}

// GetTransmissionRouteForProject returns the most recently created transmission route
// for a project. Returns nil (not an error) when no route exists.
func (r *LOD400Repository) GetTransmissionRouteForProject(ctx context.Context, projectID uuid.UUID) (*LOD400TransmissionData, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id,
		       COALESCE(review_metadata->>'status', 'DRAFT'),
		       COALESCE(protection_devices, '[]'::jsonb),
		       COALESCE(fault_isolation_points, 0)
		  FROM transmission_routes
		 WHERE project_id = $1
		 ORDER BY created_at DESC
		 LIMIT 1`, projectID)

	d := &LOD400TransmissionData{}
	err := row.Scan(
		&d.RouteID,
		&d.ReviewMetadataStatus,
		&d.ProtectionDevicesJSON,
		&d.FaultIsolationPoints,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil // no route is not an error; caller will emit FAILED check
	}
	if err != nil {
		return nil, fmt.Errorf("lod400 get transmission route: %w", err)
	}
	return d, nil
}

// SaveLOD400Result persists a LOD 400 scored result to lod400_checklist_results.
func (r *LOD400Repository) SaveLOD400Result(ctx context.Context, result *domain.LOD400ChecklistResult) error {
	itemsJSON, err := json.Marshal(result.Items)
	if err != nil {
		return fmt.Errorf("lod400 marshal items: %w", err)
	}
	blockersJSON, err := json.Marshal(result.MandatoryBlockers)
	if err != nil {
		return fmt.Errorf("lod400 marshal blockers: %w", err)
	}

	_, err = r.pool.Exec(ctx, `
		INSERT INTO lod400_checklist_results (
			id, project_id, layout_id, electrical_network_id,
			scored_at, is_lod400_ready, aggregate_score,
			mandatory_blockers, checklist_items, scored_by_actor_id
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
		result.ID,
		result.ProjectID,
		result.LayoutID,
		result.ElectricalNetworkID,
		result.ScoredAt,
		result.IsLOD400Ready,
		result.AggregateScore,
		blockersJSON,
		itemsJSON,
		result.ScoredByActorID,
	)
	if err != nil {
		return fmt.Errorf("lod400 save result: %w", err)
	}
	return nil
}

// GetLatestLOD400Result returns the most recent LOD 400 result for a layout.
// Returns ErrNotFound if no result has been scored yet.
func (r *LOD400Repository) GetLatestLOD400Result(ctx context.Context, layoutID uuid.UUID) (*domain.LOD400ChecklistResult, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id, project_id, layout_id, electrical_network_id,
		       scored_at, is_lod400_ready, aggregate_score,
		       mandatory_blockers, checklist_items, scored_by_actor_id
		  FROM lod400_checklist_results
		 WHERE layout_id = $1
		 ORDER BY scored_at DESC
		 LIMIT 1`, layoutID)

	res := &domain.LOD400ChecklistResult{}
	var networkID *uuid.UUID
	var itemsJSON, blockersJSON []byte
	var scoredAt time.Time

	err := row.Scan(
		&res.ID, &res.ProjectID, &res.LayoutID, &networkID,
		&scoredAt, &res.IsLOD400Ready, &res.AggregateScore,
		&blockersJSON, &itemsJSON, &res.ScoredByActorID,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("lod400 get latest result: %w", err)
	}

	res.ScoredAt = scoredAt
	res.ElectricalNetworkID = networkID

	if err := json.Unmarshal(itemsJSON, &res.Items); err != nil {
		return nil, fmt.Errorf("lod400 unmarshal items: %w", err)
	}
	if err := json.Unmarshal(blockersJSON, &res.MandatoryBlockers); err != nil {
		return nil, fmt.Errorf("lod400 unmarshal blockers: %w", err)
	}
	return res, nil
}
