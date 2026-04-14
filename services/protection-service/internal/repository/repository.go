package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/protection-service/internal/domain"
)

type Repository struct {
	pool *pgxpool.Pool
}

func New(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

func (r *Repository) MigrateSchema(ctx context.Context) error {
	_, err := r.pool.Exec(ctx, `
		CREATE TABLE IF NOT EXISTS protection_studies (
			id              UUID PRIMARY KEY,
			project_id      UUID NOT NULL,
			name            TEXT NOT NULL,
			system_voltage_kv DOUBLE PRECISION NOT NULL DEFAULT 0,
			source_impedance_pu DOUBLE PRECISION NOT NULL DEFAULT 0,
			mva_base        DOUBLE PRECISION NOT NULL DEFAULT 100,
			created_at      TIMESTAMPTZ NOT NULL
		);
		CREATE INDEX IF NOT EXISTS idx_protection_studies_project ON protection_studies(project_id);
	`)
	return err
}

func (r *Repository) Create(ctx context.Context, s *domain.ProtectionStudy) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO protection_studies
			(id, project_id, name, system_voltage_kv, source_impedance_pu, mva_base, created_at)
		 VALUES ($1,$2,$3,$4,$5,$6,$7)`,
		s.ID, s.ProjectID, s.Name, s.SystemVoltageKV, s.SourceImpedancePU, s.MVABase, s.CreatedAt,
	)
	return err
}

func (r *Repository) GetByID(ctx context.Context, id uuid.UUID) (*domain.ProtectionStudy, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT id, project_id, name, system_voltage_kv, source_impedance_pu, mva_base, created_at
		   FROM protection_studies WHERE id = $1`, id)
	var s domain.ProtectionStudy
	if err := row.Scan(&s.ID, &s.ProjectID, &s.Name, &s.SystemVoltageKV, &s.SourceImpedancePU, &s.MVABase, &s.CreatedAt); err != nil {
		return nil, fmt.Errorf("study not found: %w", err)
	}
	return &s, nil
}

func (r *Repository) ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.ProtectionStudy, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id, project_id, name, system_voltage_kv, source_impedance_pu, mva_base, created_at
		   FROM protection_studies WHERE project_id = $1 ORDER BY created_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var studies []domain.ProtectionStudy
	for rows.Next() {
		var s domain.ProtectionStudy
		if err := rows.Scan(&s.ID, &s.ProjectID, &s.Name, &s.SystemVoltageKV, &s.SourceImpedancePU, &s.MVABase, &s.CreatedAt); err != nil {
			return nil, err
		}
		studies = append(studies, s)
	}
	return studies, rows.Err()
}

func (r *Repository) Delete(ctx context.Context, id uuid.UUID) error {
	res, err := r.pool.Exec(ctx, `DELETE FROM protection_studies WHERE id = $1`, id)
	if err != nil {
		return err
	}
	if res.RowsAffected() == 0 {
		return fmt.Errorf("study %s not found", id)
	}
	return nil
}
