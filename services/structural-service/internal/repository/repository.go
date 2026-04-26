package repository

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"p9e.in/samavaya/solar3d/structural-service/internal/domain"
)

type Repository struct {
	pool *pgxpool.Pool
}

func New(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

const createSchema = `
CREATE TABLE IF NOT EXISTS structural_designs (
    id               UUID PRIMARY KEY,
    project_id       UUID NOT NULL,
    name             VARCHAR(255) NOT NULL,
    review_state     INT NOT NULL DEFAULT 1,
    reviewed_by      VARCHAR(255),
    review_notes     TEXT,
    dead_load_kn     DOUBLE PRECISION NOT NULL DEFAULT 0,
    wind_load_kn     DOUBLE PRECISION NOT NULL DEFAULT 0,
    seismic_load_kn  DOUBLE PRECISION NOT NULL DEFAULT 0,
    governing_load_kn DOUBLE PRECISION NOT NULL DEFAULT 0,
    foundation_json  TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
`

func (r *Repository) MigrateSchema(ctx context.Context) error {
	_, err := r.pool.Exec(ctx, createSchema)
	return err
}

func (r *Repository) Create(ctx context.Context, d *domain.StructuralDesign) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO structural_designs (id,project_id,name,review_state,created_at,updated_at)
         VALUES ($1,$2,$3,$4,$5,$6)`,
		d.ID, d.ProjectID, d.Name, int(d.ReviewState), d.CreatedAt, d.UpdatedAt)
	return err
}

func (r *Repository) GetByID(ctx context.Context, id uuid.UUID) (*domain.StructuralDesign, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT id,project_id,name,review_state,reviewed_by,review_notes,
                dead_load_kn,wind_load_kn,seismic_load_kn,governing_load_kn,
                foundation_json,created_at,updated_at
         FROM structural_designs WHERE id=$1`, id)
	return scanDesign(row)
}

func (r *Repository) ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.StructuralDesign, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id,project_id,name,review_state,reviewed_by,review_notes,
                dead_load_kn,wind_load_kn,seismic_load_kn,governing_load_kn,
                foundation_json,created_at,updated_at
         FROM structural_designs WHERE project_id=$1 ORDER BY created_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var designs []domain.StructuralDesign
	for rows.Next() {
		d, err := scanDesign(rows)
		if err != nil {
			return nil, err
		}
		designs = append(designs, *d)
	}
	return designs, rows.Err()
}

func (r *Repository) Update(ctx context.Context, d *domain.StructuralDesign) error {
	foundationJSON := []byte("null")
	if d.Foundation != nil {
		var err error
		foundationJSON, err = json.Marshal(d.Foundation)
		if err != nil {
			return fmt.Errorf("marshaling foundation: %w", err)
		}
	}

	_, err := r.pool.Exec(ctx,
		`UPDATE structural_designs SET
            review_state=$2, reviewed_by=$3, review_notes=$4,
            dead_load_kn=$5, wind_load_kn=$6, seismic_load_kn=$7, governing_load_kn=$8,
            foundation_json=$9, updated_at=NOW()
         WHERE id=$1`,
		d.ID, int(d.ReviewState), d.ReviewedBy, d.ReviewNotes,
		d.DeadLoadKN, d.WindLoadKN, d.SeismicLoadKN, d.GoverningLoadKN,
		string(foundationJSON))
	return err
}

func (r *Repository) Delete(ctx context.Context, id uuid.UUID) error {
	_, err := r.pool.Exec(ctx, `DELETE FROM structural_designs WHERE id=$1`, id)
	return err
}

type scannable interface {
	Scan(dest ...any) error
}

func scanDesign(row scannable) (*domain.StructuralDesign, error) {
	var d domain.StructuralDesign
	var reviewState int
	var reviewedBy, reviewNotes *string
	var foundationJSON *string

	err := row.Scan(
		&d.ID, &d.ProjectID, &d.Name,
		&reviewState, &reviewedBy, &reviewNotes,
		&d.DeadLoadKN, &d.WindLoadKN, &d.SeismicLoadKN, &d.GoverningLoadKN,
		&foundationJSON, &d.CreatedAt, &d.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}
	d.ReviewState = domain.ReviewState(reviewState)
	if reviewedBy != nil {
		d.ReviewedBy = *reviewedBy
	}
	if reviewNotes != nil {
		d.ReviewNotes = *reviewNotes
	}
	if foundationJSON != nil && *foundationJSON != "null" {
		var f domain.FoundationResult
		if err := json.Unmarshal([]byte(*foundationJSON), &f); err == nil {
			d.Foundation = &f
		}
	}
	return &d, nil
}
