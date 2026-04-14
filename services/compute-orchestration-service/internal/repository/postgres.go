package repository

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/compute-orchestration-service/internal/db"
	"solar3d/compute-orchestration-service/internal/domain"
)

type PostgresRepository struct {
	pool *pgxpool.Pool
	q    *db.Queries
}

var _ Store = (*PostgresRepository)(nil)

func NewPostgresRepository(ctx context.Context, databaseURL string) (*PostgresRepository, error) {
	pool, err := pgxpool.New(ctx, databaseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to connect postgres: %w", err)
	}
	if err := pool.Ping(ctx); err != nil {
		pool.Close()
		return nil, fmt.Errorf("failed to ping postgres: %w", err)
	}
	return &PostgresRepository{pool: pool, q: db.New(pool)}, nil
}

func (r *PostgresRepository) Close() {
	if r.pool != nil {
		r.pool.Close()
	}
}

func (r *PostgresRepository) CreateJob(ctx context.Context, job *domain.Job) error {
	jobID, err := parseUUID(job.ID)
	if err != nil {
		return err
	}

	err = r.q.CreateJob(ctx, db.CreateJobParams{
		Column1:      jobID,
		ProjectID:    job.ProjectID,
		JobType:      string(job.Type),
		Status:       string(job.Status),
		Priority:     job.Priority,
		Attempts:     job.Attempts,
		MaxAttempts:  job.MaxAttempts,
		Column8:      []byte(normalizePayload(job.PayloadJSON)),
		ErrorMessage: toNullableString(job.ErrorMessage),
		CreatedAt:    toPGTimestamp(&job.CreatedAt),
		StartedAt:    toPGTimestamp(job.StartedAt),
		CompletedAt:  toPGTimestamp(job.CompletedAt),
		NextRetryAt:  toPGTimestamp(job.NextRetryAt),
	})
	if err != nil {
		return fmt.Errorf("create job failed: %w", err)
	}
	return nil
}

func (r *PostgresRepository) UpdateJob(ctx context.Context, job *domain.Job) error {
	jobID, err := parseUUID(job.ID)
	if err != nil {
		return err
	}

	tx, err := r.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin tx failed: %w", err)
	}
	defer tx.Rollback(ctx)
	qtx := r.q.WithTx(tx)

	err = qtx.UpdateJob(ctx, db.UpdateJobParams{
		Column1:      jobID,
		ProjectID:    job.ProjectID,
		JobType:      string(job.Type),
		Status:       string(job.Status),
		Priority:     job.Priority,
		Attempts:     job.Attempts,
		MaxAttempts:  job.MaxAttempts,
		Column8:      []byte(normalizePayload(job.PayloadJSON)),
		ErrorMessage: toNullableString(job.ErrorMessage),
		StartedAt:    toPGTimestamp(job.StartedAt),
		CompletedAt:  toPGTimestamp(job.CompletedAt),
		NextRetryAt:  toPGTimestamp(job.NextRetryAt),
	})
	if err != nil {
		return fmt.Errorf("update job failed: %w", err)
	}

	err = qtx.DeleteArtifactsByJobID(ctx, jobID)
	if err != nil {
		return fmt.Errorf("delete artifacts failed: %w", err)
	}

	for _, a := range job.Artifacts {
		err = qtx.InsertArtifact(ctx, db.InsertArtifactParams{
			Column1:   jobID,
			Kind:      a.Kind,
			Uri:       a.URI,
			Checksum:  toNullableString(a.Checksum),
			SizeBytes: a.SizeBytes,
		})
		if err != nil {
			return fmt.Errorf("insert artifact failed: %w", err)
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("commit tx failed: %w", err)
	}
	return nil
}

func (r *PostgresRepository) GetJob(ctx context.Context, id string) (*domain.Job, error) {
	jobID, err := parseUUID(id)
	if err != nil {
		return nil, err
	}

	row, err := r.q.GetJob(ctx, jobID)
	if err != nil {
		return nil, fmt.Errorf("get job failed: %w", err)
	}

	j := mapDBRowToJob(row)
	artifacts, err := r.getArtifacts(ctx, jobID)
	if err != nil {
		return nil, err
	}
	j.Artifacts = artifacts
	return j, nil
}

func (r *PostgresRepository) ListJobs(ctx context.Context, projectID string, status domain.JobStatus, limit int32) ([]domain.Job, error) {
	if limit <= 0 {
		limit = 100
	}
	filterStatus := ""
	if status != "" && status != domain.JobStatusUnspecified {
		filterStatus = string(status)
	}

	rows, err := r.q.ListJobs(ctx, db.ListJobsParams{
		Column1: projectID,
		Column2: filterStatus,
		Limit:   limit,
	})
	if err != nil {
		return nil, fmt.Errorf("list jobs failed: %w", err)
	}

	jobs := make([]domain.Job, 0, len(rows))
	for _, row := range rows {
		job := mapDBListRowToJob(row)
		jobID, err := parseUUID(job.ID)
		if err != nil {
			return nil, fmt.Errorf("invalid job id from db: %w", err)
		}
		artifacts, err := r.getArtifacts(ctx, jobID)
		if err != nil {
			return nil, err
		}
		job.Artifacts = artifacts
		jobs = append(jobs, *job)
	}
	return jobs, nil
}

func (r *PostgresRepository) FindByIdempotencyKey(ctx context.Context, projectID, idempotencyKey string) (*domain.Job, error) {
	if strings.TrimSpace(projectID) == "" || strings.TrimSpace(idempotencyKey) == "" {
		return nil, nil
	}
	jobID, err := r.q.GetIdempotencyJobID(ctx, db.GetIdempotencyJobIDParams{
		ProjectID:      projectID,
		IdempotencyKey: idempotencyKey,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("find idempotency key failed: %w", err)
	}
	return r.GetJob(ctx, jobID)
}

func (r *PostgresRepository) SaveIdempotencyKey(ctx context.Context, projectID, idempotencyKey, jobID string) error {
	if strings.TrimSpace(projectID) == "" || strings.TrimSpace(idempotencyKey) == "" || strings.TrimSpace(jobID) == "" {
		return nil
	}
	parsedID, err := parseUUID(jobID)
	if err != nil {
		return err
	}
	err = r.q.InsertIdempotencyKey(ctx, db.InsertIdempotencyKeyParams{
		ProjectID:      projectID,
		IdempotencyKey: idempotencyKey,
		Column3:        parsedID,
	})
	if err != nil {
		return fmt.Errorf("save idempotency key failed: %w", err)
	}
	return nil
}

func (r *PostgresRepository) MarkRetryPending(ctx context.Context, id string, nextRetry time.Time, errMsg string) (*domain.Job, error) {
	jobID, err := parseUUID(id)
	if err != nil {
		return nil, err
	}

	err = r.q.MarkRetryPending(ctx, db.MarkRetryPendingParams{
		Column1:      jobID,
		Status:       string(domain.JobStatusRetryPending),
		ErrorMessage: toNullableString(errMsg),
		NextRetryAt:  toPGTimestamp(&nextRetry),
	})
	if err != nil {
		return nil, fmt.Errorf("mark retry pending failed: %w", err)
	}
	return r.GetJob(ctx, id)
}

func (r *PostgresRepository) RecordAttempt(ctx context.Context, jobID string, attemptNo int32, status domain.JobStatus, startedAt, finishedAt *time.Time, errMsg string) error {
	parsedID, err := parseUUID(jobID)
	if err != nil {
		return err
	}

	err = r.q.UpsertAttempt(ctx, db.UpsertAttemptParams{
		Column1:      parsedID,
		AttemptNo:    attemptNo,
		Status:       string(status),
		StartedAt:    toPGTimestamp(startedAt),
		FinishedAt:   toPGTimestamp(finishedAt),
		ErrorMessage: toNullableString(errMsg),
	})
	if err != nil {
		return fmt.Errorf("record attempt failed: %w", err)
	}
	return nil
}

func (r *PostgresRepository) RecordDeadLetter(ctx context.Context, jobID, reason, payloadJSON string) error {
	parsedID, err := parseUUID(jobID)
	if err != nil {
		return err
	}
	err = r.q.InsertDeadLetter(ctx, db.InsertDeadLetterParams{
		Column1: parsedID,
		Reason:  reason,
		Column3: []byte(normalizePayload(payloadJSON)),
	})
	if err != nil {
		return fmt.Errorf("record dead-letter failed: %w", err)
	}
	return nil
}

func (r *PostgresRepository) Health(ctx context.Context) error {
	return r.pool.Ping(ctx)
}

func (r *PostgresRepository) ListDeadLetters(ctx context.Context, projectID string, limit int32) ([]domain.DeadLetter, error) {
	rows, err := r.q.ListDeadLetters(ctx, db.ListDeadLettersParams{ProjectID: projectID, Limit: limit})
	if err != nil {
		return nil, fmt.Errorf("list dead-letters failed: %w", err)
	}
	out := make([]domain.DeadLetter, 0, len(rows))
	for _, row := range rows {
		createdAt := row.CreatedAt.Time
		if !row.CreatedAt.Valid {
			createdAt = time.Now().UTC()
		}
		out = append(out, domain.DeadLetter{
			ID:          row.ID,
			JobID:       row.JobID,
			Reason:      row.Reason,
			PayloadJSON: row.PayloadJson,
			CreatedAt:   createdAt,
		})
	}
	return out, nil
}

func (r *PostgresRepository) GetDeadLetter(ctx context.Context, jobID string) (*domain.DeadLetter, error) {
	jobUUID, err := parseUUID(jobID)
	if err != nil {
		return nil, fmt.Errorf("invalid job id: %w", err)
	}
	row, err := r.q.GetDeadLetter(ctx, jobUUID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get dead-letter failed: %w", err)
	}
	createdAt := row.CreatedAt.Time
	if !row.CreatedAt.Valid {
		createdAt = time.Now().UTC()
	}
	return &domain.DeadLetter{
		ID:          row.ID,
		JobID:       row.JobID,
		Reason:      row.Reason,
		PayloadJSON: row.PayloadJson,
		CreatedAt:   createdAt,
	}, nil
}

func (r *PostgresRepository) getArtifacts(ctx context.Context, jobID pgtype.UUID) ([]domain.Artifact, error) {
	rows, err := r.q.GetArtifactsByJobID(ctx, jobID)
	if err != nil {
		return nil, fmt.Errorf("get artifacts failed: %w", err)
	}

	out := make([]domain.Artifact, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Artifact{
			Kind:      row.Kind,
			URI:       row.Uri,
			Checksum:  fromNullableString(row.Checksum),
			SizeBytes: row.SizeBytes,
		})
	}
	return out, nil
}

func toNullableString(v string) *string {
	if strings.TrimSpace(v) == "" {
		return nil
	}
	out := v
	return &out
}

func normalizePayload(payload string) string {
	p := strings.TrimSpace(payload)
	if p == "" {
		return `{}`
	}
	if json.Valid([]byte(p)) {
		return p
	}
	wrapped, _ := json.Marshal(map[string]string{"raw": payload})
	return string(wrapped)
}

func parseUUID(id string) (pgtype.UUID, error) {
	parsed, err := uuid.Parse(id)
	if err != nil {
		return pgtype.UUID{}, fmt.Errorf("invalid job id %q: %w", id, err)
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func toPGTimestamp(t *time.Time) pgtype.Timestamptz {
	if t == nil {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func fromPGTimestamp(ts pgtype.Timestamptz) *time.Time {
	if !ts.Valid {
		return nil
	}
	t := ts.Time.UTC()
	return &t
}

func fromNullableString(v *string) string {
	if v == nil {
		return ""
	}
	return *v
}

func mapDBRowToJob(row db.GetJobRow) *domain.Job {
	return &domain.Job{
		ID:           row.ID,
		ProjectID:    row.ProjectID,
		Type:         domain.JobType(row.JobType),
		Status:       domain.JobStatus(row.Status),
		Priority:     row.Priority,
		Attempts:     row.Attempts,
		MaxAttempts:  row.MaxAttempts,
		PayloadJSON:  row.PayloadJson,
		ErrorMessage: fromNullableString(row.ErrorMessage),
		CreatedAt:    row.CreatedAt.Time.UTC(),
		StartedAt:    fromPGTimestamp(row.StartedAt),
		CompletedAt:  fromPGTimestamp(row.CompletedAt),
		NextRetryAt:  fromPGTimestamp(row.NextRetryAt),
	}
}

func mapDBListRowToJob(row db.ListJobsRow) *domain.Job {
	return &domain.Job{
		ID:           row.ID,
		ProjectID:    row.ProjectID,
		Type:         domain.JobType(row.JobType),
		Status:       domain.JobStatus(row.Status),
		Priority:     row.Priority,
		Attempts:     row.Attempts,
		MaxAttempts:  row.MaxAttempts,
		PayloadJSON:  row.PayloadJson,
		ErrorMessage: fromNullableString(row.ErrorMessage),
		CreatedAt:    row.CreatedAt.Time.UTC(),
		StartedAt:    fromPGTimestamp(row.StartedAt),
		CompletedAt:  fromPGTimestamp(row.CompletedAt),
		NextRetryAt:  fromPGTimestamp(row.NextRetryAt),
	}
}

