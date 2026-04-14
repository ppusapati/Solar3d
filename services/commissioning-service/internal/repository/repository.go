package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/commissioning-service/internal/domain"
)

type Repository struct {
	pool *pgxpool.Pool
}

func New(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

// ── Schema ────────────────────────────────────────────────────────────────

const createSchema = `
CREATE TABLE IF NOT EXISTS commissioning_checklists (
    id          UUID PRIMARY KEY,
    project_id  UUID NOT NULL,
    name        VARCHAR(255) NOT NULL,
    status      INT NOT NULL DEFAULT 1,
    created_by  VARCHAR(255),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS commissioning_checklist_items (
    id           UUID PRIMARY KEY,
    checklist_id UUID NOT NULL REFERENCES commissioning_checklists(id) ON DELETE CASCADE,
    description  TEXT NOT NULL,
    section      INT NOT NULL DEFAULT 0,
    status       INT NOT NULL DEFAULT 1,
    required     BOOLEAN NOT NULL DEFAULT TRUE,
    completed_by VARCHAR(255),
    completed_at TIMESTAMPTZ,
    notes        TEXT,
    sequence     INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS commissioning_signoffs (
    id           UUID PRIMARY KEY,
    checklist_id UUID NOT NULL REFERENCES commissioning_checklists(id) ON DELETE CASCADE,
    signed_by    VARCHAR(255) NOT NULL,
    role         VARCHAR(255) NOT NULL,
    comments     TEXT,
    signed_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS commissioning_handovers (
    id             UUID PRIMARY KEY,
    project_id     UUID NOT NULL,
    checklist_id   UUID NOT NULL REFERENCES commissioning_checklists(id),
    handed_over_by VARCHAR(255) NOT NULL,
    received_by    VARCHAR(255) NOT NULL,
    notes          TEXT,
    artifact_ids   TEXT NOT NULL DEFAULT '[]',
    handover_date  TIMESTAMPTZ NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS commissioning_as_built_artifacts (
    id              UUID PRIMARY KEY,
    project_id      UUID NOT NULL,
    name            VARCHAR(255) NOT NULL,
    artifact_type   INT NOT NULL DEFAULT 0,
    storage_url     TEXT NOT NULL,
    uploaded_by     VARCHAR(255) NOT NULL,
    uploaded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    description     TEXT,
    file_size_bytes BIGINT NOT NULL DEFAULT 0,
    revision        VARCHAR(50)
);
`

func (r *Repository) MigrateSchema(ctx context.Context) error {
	_, err := r.pool.Exec(ctx, createSchema)
	return err
}

// ── Checklist ─────────────────────────────────────────────────────────────

func (r *Repository) CreateChecklist(ctx context.Context, c *domain.CommissioningChecklist) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO commissioning_checklists (id,project_id,name,status,created_by,created_at,updated_at)
         VALUES ($1,$2,$3,$4,$5,$6,$7)`,
		c.ID, c.ProjectID, c.Name, int(c.Status), c.CreatedBy, c.CreatedAt, c.UpdatedAt)
	return err
}

func (r *Repository) GetChecklistByID(ctx context.Context, id uuid.UUID) (*domain.CommissioningChecklist, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT id,project_id,name,status,created_by,created_at,updated_at
         FROM commissioning_checklists WHERE id=$1`, id)
	c, err := scanChecklist(row)
	if err != nil {
		return nil, err
	}

	items, err := r.listItems(ctx, id)
	if err != nil {
		return nil, err
	}
	c.Items = items

	signoffs, err := r.listSignoffs(ctx, id)
	if err != nil {
		return nil, err
	}
	c.Signoffs = signoffs

	return c, nil
}

func (r *Repository) ListChecklistsByProject(ctx context.Context, projectID uuid.UUID) ([]domain.CommissioningChecklist, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id,project_id,name,status,created_by,created_at,updated_at
         FROM commissioning_checklists WHERE project_id=$1 ORDER BY created_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []domain.CommissioningChecklist
	for rows.Next() {
		c, err := scanChecklist(rows)
		if err != nil {
			return nil, err
		}
		result = append(result, *c)
	}
	return result, rows.Err()
}

func (r *Repository) UpdateChecklistStatus(ctx context.Context, id uuid.UUID, status domain.CommissioningStatus) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE commissioning_checklists SET status=$1,updated_at=NOW() WHERE id=$2`,
		int(status), id)
	return err
}

func scanChecklist(row pgx.Row) (*domain.CommissioningChecklist, error) {
	var c domain.CommissioningChecklist
	var status int
	var createdBy *string
	if err := row.Scan(&c.ID, &c.ProjectID, &c.Name, &status, &createdBy, &c.CreatedAt, &c.UpdatedAt); err != nil {
		return nil, fmt.Errorf("scanning checklist: %w", err)
	}
	c.Status = domain.CommissioningStatus(status)
	if createdBy != nil {
		c.CreatedBy = *createdBy
	}
	return &c, nil
}

// ── ChecklistItem ─────────────────────────────────────────────────────────

func (r *Repository) AddItem(ctx context.Context, item *domain.ChecklistItem) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO commissioning_checklist_items
         (id,checklist_id,description,section,status,required,sequence)
         VALUES ($1,$2,$3,$4,$5,$6,$7)`,
		item.ID, item.ChecklistID, item.Description, int(item.Section),
		int(item.Status), item.Required, item.Sequence)
	return err
}

func (r *Repository) UpdateItem(ctx context.Context, item *domain.ChecklistItem) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE commissioning_checklist_items
         SET status=$1,completed_by=$2,completed_at=$3,notes=$4
         WHERE id=$5`,
		int(item.Status), item.CompletedBy, item.CompletedAt, item.Notes, item.ID)
	return err
}

func (r *Repository) GetItemByID(ctx context.Context, id uuid.UUID) (*domain.ChecklistItem, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT id,checklist_id,description,section,status,required,completed_by,completed_at,notes,sequence
         FROM commissioning_checklist_items WHERE id=$1`, id)
	return scanItem(row)
}

func (r *Repository) listItems(ctx context.Context, checklistID uuid.UUID) ([]domain.ChecklistItem, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id,checklist_id,description,section,status,required,completed_by,completed_at,notes,sequence
         FROM commissioning_checklist_items WHERE checklist_id=$1 ORDER BY sequence,id`, checklistID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var items []domain.ChecklistItem
	for rows.Next() {
		item, err := scanItem(rows)
		if err != nil {
			return nil, err
		}
		items = append(items, *item)
	}
	return items, rows.Err()
}

func scanItem(row pgx.Row) (*domain.ChecklistItem, error) {
	var item domain.ChecklistItem
	var section, status int
	var completedBy *string
	if err := row.Scan(
		&item.ID, &item.ChecklistID, &item.Description,
		&section, &status, &item.Required,
		&completedBy, &item.CompletedAt, &item.Notes, &item.Sequence,
	); err != nil {
		return nil, fmt.Errorf("scanning checklist item: %w", err)
	}
	item.Section = domain.ChecklistSection(section)
	item.Status = domain.ChecklistItemStatus(status)
	if completedBy != nil {
		item.CompletedBy = *completedBy
	}
	return &item, nil
}

// ── Signoff ───────────────────────────────────────────────────────────────

func (r *Repository) AddSignoff(ctx context.Context, s *domain.CommissioningSignoff) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO commissioning_signoffs (id,checklist_id,signed_by,role,comments,signed_at)
         VALUES ($1,$2,$3,$4,$5,$6)`,
		s.ID, s.ChecklistID, s.SignedBy, s.Role, s.Comments, s.SignedAt)
	return err
}

func (r *Repository) listSignoffs(ctx context.Context, checklistID uuid.UUID) ([]domain.CommissioningSignoff, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id,checklist_id,signed_by,role,comments,signed_at
         FROM commissioning_signoffs WHERE checklist_id=$1 ORDER BY signed_at`, checklistID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var signoffs []domain.CommissioningSignoff
	for rows.Next() {
		var s domain.CommissioningSignoff
		var comments *string
		if err := rows.Scan(&s.ID, &s.ChecklistID, &s.SignedBy, &s.Role, &comments, &s.SignedAt); err != nil {
			return nil, fmt.Errorf("scanning signoff: %w", err)
		}
		if comments != nil {
			s.Comments = *comments
		}
		signoffs = append(signoffs, s)
	}
	return signoffs, rows.Err()
}

func (r *Repository) ListSignoffsByChecklist(ctx context.Context, checklistID uuid.UUID) ([]domain.CommissioningSignoff, error) {
	return r.listSignoffs(ctx, checklistID)
}

// ── Handover ──────────────────────────────────────────────────────────────

func (r *Repository) CreateHandover(ctx context.Context, h *domain.HandoverRecord) error {
	artJSON, err := json.Marshal(h.ArtifactIDs)
	if err != nil {
		return fmt.Errorf("marshalling artifact ids: %w", err)
	}
	_, err = r.pool.Exec(ctx,
		`INSERT INTO commissioning_handovers
         (id,project_id,checklist_id,handed_over_by,received_by,notes,artifact_ids,handover_date,created_at)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
		h.ID, h.ProjectID, h.ChecklistID, h.HandedOverBy, h.ReceivedBy,
		h.Notes, string(artJSON), h.HandoverDate, h.CreatedAt)
	return err
}

func (r *Repository) GetHandoverByID(ctx context.Context, id uuid.UUID) (*domain.HandoverRecord, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT id,project_id,checklist_id,handed_over_by,received_by,notes,artifact_ids,handover_date,created_at
         FROM commissioning_handovers WHERE id=$1`, id)
	return scanHandover(row)
}

func scanHandover(row pgx.Row) (*domain.HandoverRecord, error) {
	var h domain.HandoverRecord
	var notes *string
	var artifactJSON string
	if err := row.Scan(
		&h.ID, &h.ProjectID, &h.ChecklistID,
		&h.HandedOverBy, &h.ReceivedBy, &notes,
		&artifactJSON, &h.HandoverDate, &h.CreatedAt,
	); err != nil {
		return nil, fmt.Errorf("scanning handover: %w", err)
	}
	if notes != nil {
		h.Notes = *notes
	}
	if err := json.Unmarshal([]byte(artifactJSON), &h.ArtifactIDs); err != nil {
		h.ArtifactIDs = nil
	}
	return &h, nil
}

// ── AsBuiltArtifact ───────────────────────────────────────────────────────

func (r *Repository) RecordAsBuilt(ctx context.Context, a *domain.AsBuiltArtifact) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO commissioning_as_built_artifacts
         (id,project_id,name,artifact_type,storage_url,uploaded_by,uploaded_at,description,file_size_bytes,revision)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
		a.ID, a.ProjectID, a.Name, int(a.ArtifactType), a.StorageURL,
		a.UploadedBy, a.UploadedAt, a.Description, a.FileSizeBytes, a.Revision)
	return err
}

func (r *Repository) ListAsBuiltByProject(ctx context.Context, projectID uuid.UUID) ([]domain.AsBuiltArtifact, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id,project_id,name,artifact_type,storage_url,uploaded_by,uploaded_at,description,file_size_bytes,revision
         FROM commissioning_as_built_artifacts WHERE project_id=$1 ORDER BY uploaded_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var arts []domain.AsBuiltArtifact
	for rows.Next() {
		var a domain.AsBuiltArtifact
		var artType int
		var desc, rev *string
		if err := rows.Scan(
			&a.ID, &a.ProjectID, &a.Name, &artType,
			&a.StorageURL, &a.UploadedBy, &a.UploadedAt,
			&desc, &a.FileSizeBytes, &rev,
		); err != nil {
			return nil, fmt.Errorf("scanning artifact: %w", err)
		}
		a.ArtifactType = domain.AsBuiltArtifactType(artType)
		if desc != nil {
			a.Description = *desc
		}
		if rev != nil {
			a.Revision = *rev
		}
		arts = append(arts, a)
	}
	return arts, rows.Err()
}

// GetAsBuiltByID fetches a single artifact by primary key.
func (r *Repository) GetAsBuiltByID(ctx context.Context, id uuid.UUID) (*domain.AsBuiltArtifact, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT id,project_id,name,artifact_type,storage_url,uploaded_by,uploaded_at,description,file_size_bytes,revision
         FROM commissioning_as_built_artifacts WHERE id=$1`, id)
	var a domain.AsBuiltArtifact
	var artType int
	var desc, rev *string
	if err := row.Scan(
		&a.ID, &a.ProjectID, &a.Name, &artType,
		&a.StorageURL, &a.UploadedBy, &a.UploadedAt,
		&desc, &a.FileSizeBytes, &rev,
	); err != nil {
		return nil, fmt.Errorf("scanning artifact: %w", err)
	}
	a.ArtifactType = domain.AsBuiltArtifactType(artType)
	if desc != nil {
		a.Description = *desc
	}
	if rev != nil {
		a.Revision = *rev
	}
	return &a, nil
}

// ChecklistItemsForChecklist returns all items for the given checklist (used internally).
func (r *Repository) ChecklistItemsForChecklist(ctx context.Context, checklistID uuid.UUID) ([]domain.ChecklistItem, error) {
	return r.listItems(ctx, checklistID)
}

// Convenience: get checklist updated_at / status recompute helper.
func (r *Repository) TouchChecklist(ctx context.Context, id uuid.UUID) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE commissioning_checklists SET updated_at=NOW() WHERE id=$1`, id)
	return err
}

// ListChecklistItemsByChecklist is the exported alias used by the service.
func (r *Repository) ListChecklistItemsByChecklist(ctx context.Context, id uuid.UUID) ([]domain.ChecklistItem, error) {
	return r.listItems(ctx, id)
}

// ListHandoversByProject returns handover records for a project.
func (r *Repository) ListHandoversByProject(ctx context.Context, projectID uuid.UUID) ([]domain.HandoverRecord, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id,project_id,checklist_id,handed_over_by,received_by,notes,artifact_ids,handover_date,created_at
         FROM commissioning_handovers WHERE project_id=$1 ORDER BY created_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []domain.HandoverRecord
	for rows.Next() {
		h, err := scanHandover(rows)
		if err != nil {
			return nil, err
		}
		result = append(result, *h)
	}
	return result, rows.Err()
}

// scanHandover works on both pgx.Row and pgx.Rows via pgx.Row interface.
// Note: pgx.Rows implements pgx.Row, so this is valid.
var _ pgx.Row = (pgx.Rows)(nil)

var _ = time.Now // suppress unused import
