package service

import (
	"context"
	"testing"

	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/domain"
	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/repository"
)

func TestServiceInMemory(t *testing.T) {
	repo := repository.NewInMemoryRepository()
	svc := New(repo, &stubExecutor{}, 1, 16)
	svc.Start()
	defer svc.Stop()

	// Test SubmitJob
	job, err := svc.SubmitJob(context.Background(), "proj-1", domain.JobTypeSimulation, 10, 3, `{"test": true}`, "idem-1")
	if err != nil {
		t.Fatalf("SubmitJob failed: %v", err)
	}
	if job.ID == "" || job.ProjectID != "proj-1" || job.Status != domain.JobStatusQueued {
		t.Errorf("SubmitJob returned invalid job: %+v", job)
	}

	// Test GetJob
	retrieved, err := svc.GetJob(context.Background(), job.ID)
	if err != nil {
		t.Fatalf("GetJob failed: %v", err)
	}
	if retrieved.ID != job.ID {
		t.Errorf("GetJob returned wrong job")
	}

	// Test ListJobs
	jobs, err := svc.ListJobs(context.Background(), "proj-1", "", 100)
	if err != nil {
		t.Fatalf("ListJobs failed: %v", err)
	}
	if len(jobs) < 1 {
		t.Errorf("ListJobs returned no jobs, expected at least 1")
	}

	// Test idempotency key returns same job
	again, err := svc.SubmitJob(context.Background(), "proj-1", domain.JobTypeSimulation, 10, 3, `{"test": true}`, "idem-1")
	if err != nil {
		t.Fatalf("SubmitJob idempotent call failed: %v", err)
	}
	if again.ID != job.ID {
		t.Fatalf("expected idempotent call to return same job id %s, got %s", job.ID, again.ID)
	}
}

type stubExecutor struct{}

func (s *stubExecutor) Execute(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	_ = ctx
	return []domain.Artifact{{Kind: "result", URI: "memory://ok", Checksum: "sha256:test", SizeBytes: int64(len(job.PayloadJSON))}}, nil
}

