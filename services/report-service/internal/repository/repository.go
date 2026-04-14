package repository

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/report-service/internal/domain"
)

// ErrNoLOD400Assessment is returned by GetLatestLOD400ReadyStatus when no LOD 400
// assessment has been scored for the requested layout.
var ErrNoLOD400Assessment = errors.New("no LOD 400 assessment found for layout")

type ReportRepository struct {
	pool *pgxpool.Pool
}

// StoreContent writes report content to the local filesystem at the given path.
// In a production deployment this would write to S3/MinIO via the configured
// object storage client.
func (r *ReportRepository) StoreContent(ctx context.Context, path string, content []byte) error {
	dir := filepath.Dir(path)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return fmt.Errorf("creating report directory %s: %w", dir, err)
	}
	if err := os.WriteFile(path, content, 0o644); err != nil {
		return fmt.Errorf("writing report content to %s: %w", path, err)
	}
	return nil
}

func NewReportRepository(pool *pgxpool.Pool) *ReportRepository {
	return &ReportRepository{pool: pool}
}

func (r *ReportRepository) Create(ctx context.Context, report *domain.Report) error {
	query := `
		INSERT INTO reports (id, project_id, name, report_type, format, file_path, status, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`

	_, err := r.pool.Exec(ctx, query,
		report.ID, report.ProjectID, report.Name, report.ReportType,
		report.Format, report.FilePath, report.Status, report.CreatedAt,
	)
	if err != nil {
		return fmt.Errorf("inserting report: %w", err)
	}
	return nil
}

func (r *ReportRepository) GetByID(ctx context.Context, id uuid.UUID) (*domain.Report, error) {
	query := `
		SELECT id, project_id, name, report_type, format, file_path, status, created_at, completed_at
		FROM reports WHERE id = $1`

	var report domain.Report
	err := r.pool.QueryRow(ctx, query, id).Scan(
		&report.ID, &report.ProjectID, &report.Name, &report.ReportType,
		&report.Format, &report.FilePath, &report.Status,
		&report.CreatedAt, &report.CompletedAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, fmt.Errorf("report not found: %s", id)
		}
		return nil, fmt.Errorf("querying report: %w", err)
	}
	return &report, nil
}

func (r *ReportRepository) ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.Report, error) {
	query := `
		SELECT id, project_id, name, report_type, format, file_path, status, created_at, completed_at
		FROM reports WHERE project_id = $1 ORDER BY created_at DESC`

	rows, err := r.pool.Query(ctx, query, projectID)
	if err != nil {
		return nil, fmt.Errorf("querying reports: %w", err)
	}
	defer rows.Close()

	var reports []domain.Report
	for rows.Next() {
		var report domain.Report
		if err := rows.Scan(
			&report.ID, &report.ProjectID, &report.Name, &report.ReportType,
			&report.Format, &report.FilePath, &report.Status,
			&report.CreatedAt, &report.CompletedAt,
		); err != nil {
			return nil, fmt.Errorf("scanning report: %w", err)
		}
		reports = append(reports, report)
	}
	return reports, nil
}

func (r *ReportRepository) UpdateStatus(ctx context.Context, id uuid.UUID, status domain.ReportStatus, filePath string) error {
	query := `UPDATE reports SET status = $2, file_path = $3 WHERE id = $1`
	if status == domain.ReportStatusCompleted {
		query = `UPDATE reports SET status = $2, file_path = $3, completed_at = NOW() WHERE id = $1`
	}
	tag, err := r.pool.Exec(ctx, query, id, status, filePath)
	if err != nil {
		return fmt.Errorf("updating report status: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("report not found: %s", id)
	}
	return nil
}

func (r *ReportRepository) Delete(ctx context.Context, id uuid.UUID) error {
	query := `DELETE FROM reports WHERE id = $1`
	tag, err := r.pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("deleting report: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("report not found: %s", id)
	}
	return nil
}

// GetLatestLOD400ReadyStatus returns the is_lod400_ready flag for the most recent
// LOD 400 assessment of the given layout.
// Returns ErrNoLOD400Assessment when no assessment has been scored yet.
// Returns (false, nil) when an assessment exists but is not ready.
func (r *ReportRepository) GetLatestLOD400ReadyStatus(ctx context.Context, layoutID uuid.UUID) (bool, error) {
	const q = `SELECT is_lod400_ready FROM lod400_checklist_results
	           WHERE layout_id = $1 ORDER BY scored_at DESC LIMIT 1`
	var ready bool
	if err := r.pool.QueryRow(ctx, q, layoutID).Scan(&ready); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, ErrNoLOD400Assessment
		}
		return false, fmt.Errorf("querying LOD 400 status for layout %s: %w", layoutID, err)
	}
	return ready, nil
}
