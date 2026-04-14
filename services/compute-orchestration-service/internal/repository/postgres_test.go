package repository

import (
	"context"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"solar3d/compute-orchestration-service/internal/domain"
)

func TestPostgresRepositoryIntegration(t *testing.T) {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		t.Skip("DATABASE_URL is not set")
	}

	ctx := context.Background()
	if err := ensureSchema(ctx, dsn); err != nil {
		t.Fatalf("ensure schema: %v", err)
	}

	repo, err := NewPostgresRepository(ctx, dsn)
	if err != nil {
		t.Fatalf("new postgres repository: %v", err)
	}
	defer repo.Close()

	jobID := uuid.NewString()
	projectID := "itest-orch"
	now := time.Now().UTC()
	job := &domain.Job{
		ID:          jobID,
		ProjectID:   projectID,
		Type:        domain.JobTypeSimulation,
		Status:      domain.JobStatusQueued,
		Priority:    7,
		Attempts:    0,
		MaxAttempts: 3,
		PayloadJSON: `{"force_fail": false}`,
		CreatedAt:   now,
	}

	if err := repo.CreateJob(ctx, job); err != nil {
		t.Fatalf("create job: %v", err)
	}
	t.Cleanup(func() {
		cleanupJobs(ctx, dsn, projectID)
	})

	got, err := repo.GetJob(ctx, jobID)
	if err != nil {
		t.Fatalf("get job after create: %v", err)
	}
	if got.ID != jobID || got.ProjectID != projectID || got.Status != domain.JobStatusQueued {
		t.Fatalf("unexpected created job state: %+v", got)
	}

	start := time.Now().UTC()
	finish := start.Add(250 * time.Millisecond)
	job.Status = domain.JobStatusSucceeded
	job.StartedAt = &start
	job.CompletedAt = &finish
	job.Artifacts = []domain.Artifact{{
		Kind:      "result",
		URI:       "s3://bucket/out.json",
		Checksum:  "sha256:abc123",
		SizeBytes: 128,
	}}
	if err := repo.UpdateJob(ctx, job); err != nil {
		t.Fatalf("update job: %v", err)
	}

	got, err = repo.GetJob(ctx, jobID)
	if err != nil {
		t.Fatalf("get job after update: %v", err)
	}
	if got.Status != domain.JobStatusSucceeded || len(got.Artifacts) != 1 {
		t.Fatalf("unexpected updated job state: %+v", got)
	}

	list, err := repo.ListJobs(ctx, projectID, domain.JobStatusSucceeded, 50)
	if err != nil {
		t.Fatalf("list jobs: %v", err)
	}
	if len(list) < 1 {
		t.Fatalf("expected at least one job in list")
	}

	retryAt := time.Now().UTC().Add(1 * time.Minute)
	retried, err := repo.MarkRetryPending(ctx, jobID, retryAt, "retry test")
	if err != nil {
		t.Fatalf("mark retry pending: %v", err)
	}
	if retried.Status != domain.JobStatusRetryPending {
		t.Fatalf("expected retry_pending status, got %s", retried.Status)
	}

	if err := repo.RecordAttempt(ctx, jobID, 1, domain.JobStatusFailed, &start, &finish, "attempt failed"); err != nil {
		t.Fatalf("record attempt: %v", err)
	}
}

func ensureSchema(ctx context.Context, dsn string) error {
	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		return err
	}
	defer pool.Close()

	migrationNames := []string{"002_compute_orchestration.sql", "003_orchestration_idempotency_deadletter.sql"}
	for _, migrationName := range migrationNames {
		paths := []string{
			filepath.Join("..", "..", "..", "migrations", migrationName),
			filepath.Join("..", "..", "..", "..", "migrations", migrationName),
		}

		var sqlBytes []byte
		for _, p := range paths {
			sqlBytes, err = os.ReadFile(p)
			if err == nil {
				break
			}
		}
		if len(sqlBytes) == 0 {
			return err
		}
		if _, err = pool.Exec(ctx, string(sqlBytes)); err != nil {
			return err
		}
	}
	return nil
}

func cleanupJobs(ctx context.Context, dsn, projectID string) {
	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		return
	}
	defer pool.Close()
	_, _ = pool.Exec(ctx, `DELETE FROM orchestration_jobs WHERE project_id = $1`, projectID)
}

