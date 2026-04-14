package repository

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/twin-service/internal/domain"
)

// ErrNotFound is returned when the requested entity does not exist.
var ErrNotFound = errors.New("not found")

// TwinRepository defines persistence operations for the twin service.
type TwinRepository interface {
	CreateTwin(ctx context.Context, t *domain.DigitalTwin) error
	GetTwinByID(ctx context.Context, id uuid.UUID) (*domain.DigitalTwin, error)
	ListTwinsByProject(ctx context.Context, projectID uuid.UUID) ([]*domain.DigitalTwin, error)
	UpdateTwin(ctx context.Context, t *domain.DigitalTwin) error

	CreateAssetIdentity(ctx context.Context, a *domain.AssetIdentity) error
	GetAssetIdentityByID(ctx context.Context, id uuid.UUID) (*domain.AssetIdentity, error)
	ListAssetIdentitiesByTwin(ctx context.Context, twinID uuid.UUID) ([]*domain.AssetIdentity, error)

	InsertReadingsBatch(ctx context.Context, readings []*domain.SensorReading) error
	GetLatestReadingsByTwin(ctx context.Context, twinID uuid.UUID, limit int) ([]*domain.SensorReading, error)
}

// PgRepository implements TwinRepository using a pgx connection pool.
type PgRepository struct {
	pool *pgxpool.Pool
}

// NewPgRepository creates a new PgRepository backed by the given pool.
func NewPgRepository(pool *pgxpool.Pool) *PgRepository {
	return &PgRepository{pool: pool}
}

// CreateTwin inserts a new digital twin row.
func (r *PgRepository) CreateTwin(ctx context.Context, t *domain.DigitalTwin) error {
	if t.ID == uuid.Nil {
		t.ID = uuid.New()
	}
	now := time.Now().UTC()
	t.CreatedAt = now
	t.UpdatedAt = now

	_, err := r.pool.Exec(ctx, `
		INSERT INTO digital_twins (
			id, project_id, layout_id, electrical_network_id, transmission_route_id,
			status, power_output_kw, availability_pct, active_fault_count, health_score,
			created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)`,
		t.ID, t.ProjectID, t.LayoutID, t.ElectricalNetworkID, t.TransmissionRouteID,
		string(t.Status),
		t.Operational.PowerOutputKW, t.Operational.AvailabilityPct,
		t.Operational.ActiveFaultCount, t.Operational.HealthScore,
		t.CreatedAt, t.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert digital twin: %w", err)
	}
	return nil
}

// GetTwinByID retrieves a single digital twin by its primary key.
func (r *PgRepository) GetTwinByID(ctx context.Context, id uuid.UUID) (*domain.DigitalTwin, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id, project_id, layout_id, electrical_network_id, transmission_route_id,
		       status, power_output_kw, availability_pct, active_fault_count, health_score,
		       created_at, updated_at
		  FROM digital_twins
		 WHERE id = $1`, id)

	t := &domain.DigitalTwin{}
	err := row.Scan(
		&t.ID, &t.ProjectID, &t.LayoutID, &t.ElectricalNetworkID, &t.TransmissionRouteID,
		&t.Status,
		&t.Operational.PowerOutputKW, &t.Operational.AvailabilityPct,
		&t.Operational.ActiveFaultCount, &t.Operational.HealthScore,
		&t.CreatedAt, &t.UpdatedAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("scan digital twin: %w", err)
	}
	return t, nil
}

// ListTwinsByProject retrieves all twins associated with a project.
func (r *PgRepository) ListTwinsByProject(ctx context.Context, projectID uuid.UUID) ([]*domain.DigitalTwin, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT id, project_id, layout_id, electrical_network_id, transmission_route_id,
		       status, power_output_kw, availability_pct, active_fault_count, health_score,
		       created_at, updated_at
		  FROM digital_twins
		 WHERE project_id = $1
		 ORDER BY created_at ASC`, projectID)
	if err != nil {
		return nil, fmt.Errorf("query twins by project: %w", err)
	}
	defer rows.Close()

	var twins []*domain.DigitalTwin
	for rows.Next() {
		t := &domain.DigitalTwin{}
		if err := rows.Scan(
			&t.ID, &t.ProjectID, &t.LayoutID, &t.ElectricalNetworkID, &t.TransmissionRouteID,
			&t.Status,
			&t.Operational.PowerOutputKW, &t.Operational.AvailabilityPct,
			&t.Operational.ActiveFaultCount, &t.Operational.HealthScore,
			&t.CreatedAt, &t.UpdatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan digital twin row: %w", err)
		}
		twins = append(twins, t)
	}
	return twins, rows.Err()
}

// UpdateTwin writes updated operational state and status for a twin.
func (r *PgRepository) UpdateTwin(ctx context.Context, t *domain.DigitalTwin) error {
	t.UpdatedAt = time.Now().UTC()
	tag, err := r.pool.Exec(ctx, `
		UPDATE digital_twins
		   SET status             = $2,
		       power_output_kw   = $3,
		       availability_pct  = $4,
		       active_fault_count = $5,
		       health_score       = $6,
		       updated_at         = $7
		 WHERE id = $1`,
		t.ID, string(t.Status),
		t.Operational.PowerOutputKW, t.Operational.AvailabilityPct,
		t.Operational.ActiveFaultCount, t.Operational.HealthScore,
		t.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("update digital twin: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrNotFound
	}
	return nil
}

// CreateAssetIdentity inserts a new asset-identity link.
func (r *PgRepository) CreateAssetIdentity(ctx context.Context, a *domain.AssetIdentity) error {
	if a.ID == uuid.Nil {
		a.ID = uuid.New()
	}
	now := time.Now().UTC()
	a.CreatedAt = now
	a.UpdatedAt = now

	_, err := r.pool.Exec(ctx, `
		INSERT INTO asset_identities (
			id, twin_id, design_asset_id, design_asset_type,
			physical_serial_number, commissioning_ref,
			created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
		a.ID, a.TwinID, a.DesignAssetID, string(a.DesignAssetType),
		a.PhysicalSerialNumber, a.CommissioningRef,
		a.CreatedAt, a.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert asset identity: %w", err)
	}
	return nil
}

// GetAssetIdentityByID retrieves a single asset identity by primary key.
func (r *PgRepository) GetAssetIdentityByID(ctx context.Context, id uuid.UUID) (*domain.AssetIdentity, error) {
	row := r.pool.QueryRow(ctx, `
		SELECT id, twin_id, design_asset_id, design_asset_type,
		       physical_serial_number, commissioning_ref,
		       created_at, updated_at
		  FROM asset_identities
		 WHERE id = $1`, id)

	a := &domain.AssetIdentity{}
	err := row.Scan(
		&a.ID, &a.TwinID, &a.DesignAssetID, &a.DesignAssetType,
		&a.PhysicalSerialNumber, &a.CommissioningRef,
		&a.CreatedAt, &a.UpdatedAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("scan asset identity: %w", err)
	}
	return a, nil
}

// ListAssetIdentitiesByTwin returns all asset identities linked to a twin.
func (r *PgRepository) ListAssetIdentitiesByTwin(ctx context.Context, twinID uuid.UUID) ([]*domain.AssetIdentity, error) {
	rows, err := r.pool.Query(ctx, `
		SELECT id, twin_id, design_asset_id, design_asset_type,
		       physical_serial_number, commissioning_ref,
		       created_at, updated_at
		  FROM asset_identities
		 WHERE twin_id = $1
		 ORDER BY created_at ASC`, twinID)
	if err != nil {
		return nil, fmt.Errorf("query asset identities by twin: %w", err)
	}
	defer rows.Close()

	var identities []*domain.AssetIdentity
	for rows.Next() {
		a := &domain.AssetIdentity{}
		if err := rows.Scan(
			&a.ID, &a.TwinID, &a.DesignAssetID, &a.DesignAssetType,
			&a.PhysicalSerialNumber, &a.CommissioningRef,
			&a.CreatedAt, &a.UpdatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan asset identity row: %w", err)
		}
		identities = append(identities, a)
	}
	return identities, rows.Err()
}

// InsertReadingsBatch writes a batch of sensor readings in a single transaction.
func (r *PgRepository) InsertReadingsBatch(ctx context.Context, readings []*domain.SensorReading) error {
	if len(readings) == 0 {
		return nil
	}
	tx, err := r.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin transaction: %w", err)
	}
	defer func() { _ = tx.Rollback(ctx) }()

	now := time.Now().UTC()
	for _, rd := range readings {
		if rd.ID == uuid.Nil {
			rd.ID = uuid.New()
		}
		rd.IngestedAt = now
		_, err := tx.Exec(ctx, `
			INSERT INTO sensor_readings (
				id, twin_id, sensor_id, asset_identity_id,
				metric, value, unit, quality,
				recorded_at, ingested_at
			) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
			ON CONFLICT (id, recorded_at) DO NOTHING`,
			rd.ID, rd.TwinID, rd.SensorID, rd.AssetIdentityID,
			string(rd.Metric), rd.Value, rd.Unit, string(rd.Quality),
			rd.RecordedAt, rd.IngestedAt,
		)
		if err != nil {
			return fmt.Errorf("insert sensor reading: %w", err)
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("commit sensor readings: %w", err)
	}
	return nil
}

// GetLatestReadingsByTwin retrieves the most recent sensor readings for a twin.
func (r *PgRepository) GetLatestReadingsByTwin(ctx context.Context, twinID uuid.UUID, limit int) ([]*domain.SensorReading, error) {
	if limit <= 0 || limit > 1000 {
		limit = 100
	}
	rows, err := r.pool.Query(ctx, `
		SELECT id, twin_id, sensor_id, asset_identity_id,
		       metric, value, unit, quality,
		       recorded_at, ingested_at
		  FROM sensor_readings
		 WHERE twin_id = $1
		 ORDER BY recorded_at DESC
		 LIMIT $2`, twinID, limit)
	if err != nil {
		return nil, fmt.Errorf("query latest readings: %w", err)
	}
	defer rows.Close()

	var readings []*domain.SensorReading
	for rows.Next() {
		rd := &domain.SensorReading{}
		if err := rows.Scan(
			&rd.ID, &rd.TwinID, &rd.SensorID, &rd.AssetIdentityID,
			&rd.Metric, &rd.Value, &rd.Unit, &rd.Quality,
			&rd.RecordedAt, &rd.IngestedAt,
		); err != nil {
			return nil, fmt.Errorf("scan sensor reading row: %w", err)
		}
		readings = append(readings, rd)
	}
	return readings, rows.Err()
}
