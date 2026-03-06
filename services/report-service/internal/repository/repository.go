package repository

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/solar3d/solar3d/services/report-service/internal/domain"
)

type ReportRepository struct {
	pool *pgxpool.Pool
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
