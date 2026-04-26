//go:build integration
// +build integration

package integration_test

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	orchestrationv1 "p9e.in/samavaya/solar3d/gen/orchestration/v1"
	orchestrationv1connect "p9e.in/samavaya/solar3d/gen/orchestration/v1/orchestrationv1connect"

	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/domain"
	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/handler"
	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/repository"
	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/service"
)

// TestEndToEndOrchestration tests the complete lifecycle:
// - Submit a job via connectRPC with Idempotency-Key header
// - Job transitions QUEUED → RUNNING → SUCCEEDED
// - Metrics are incremented
// - Trace logs are emitted
// - Dead-letter inspection API works for failed jobs
func TestEndToEndOrchestration(t *testing.T) {
	ctx := context.Background()

	// Create in-memory repository (faster than Postgres for e2e test)
	repo := repository.NewInMemoryRepository()

	// Create mock executor that always succeeds
	exec := &mockSuccessExecutor{
		artifacts: []domain.Artifact{
			{
				Kind:      "result",
				URI:       "memory://success",
				Checksum:  "abc123",
				SizeBytes: 1024,
			},
		},
	}

	// Create service with 2 workers, large queue
	svc := service.New(repo, exec, 2, 256)
	svc.Start()
	defer svc.Stop()

	// Create handler
	h := handler.NewConnectHandler(svc)

	// Start HTTP server
	mux := http.NewServeMux()
	mux.Handle(orchestrationv1connect.NewComputeOrchestrationServiceHandler(h))

	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("failed to listen: %v", err)
	}
	defer listener.Close()

	addr := listener.Addr().String()
	baseURL := fmt.Sprintf("http://%s", addr)

	// Run server in background
	go func() {
		if err := http.Serve(listener, mux); err != nil && err != http.ErrServerClosed {
			log.Printf("server error: %v", err)
		}
	}()

	// Give server time to start
	time.Sleep(100 * time.Millisecond)

	// Create client
	client := orchestrationv1connect.NewComputeOrchestrationServiceClient(
		&http.Client{Timeout: 5 * time.Second},
		baseURL,
		connect.WithGRPC(),
	)

	t.Run("submit_job_with_idempotency", func(t *testing.T) {
		// Submit first job with Idempotency-Key
		req1 := &orchestrationv1.SubmitJobRequest{
			ProjectId:   "test-project",
			Type:        orchestrationv1.JobType_JOB_TYPE_SIMULATION,
			Priority:    10,
			MaxAttempts: 3,
			PayloadJson: `{"scenario": "test"}`,
		}

		req := connect.NewRequest(req1)
		req.Header().Set("Idempotency-Key", "test-idempotency-key-123")

		resp1, err := client.SubmitJob(ctx, req)
		if err != nil {
			t.Fatalf("submit job failed: %v", err)
		}

		job1 := resp1.Msg.Job
		if job1.Status != orchestrationv1.JobStatus_JOB_STATUS_QUEUED {
			t.Errorf("expected QUEUED status, got %v", job1.Status)
		}
		if job1.ProjectId != "test-project" {
			t.Errorf("expected project_id=test-project, got %s", job1.ProjectId)
		}

		jobID := job1.Id

		// Wait for job to process
		time.Sleep(500 * time.Millisecond)

		// Get job and verify it succeeded
		getResp, err := client.GetJob(ctx, connect.NewRequest(&orchestrationv1.GetJobRequest{Id: jobID}))
		if err != nil {
			t.Fatalf("get job failed: %v", err)
		}

		job2 := getResp.Msg.Job
		if job2.Status != orchestrationv1.JobStatus_JOB_STATUS_SUCCEEDED {
			t.Errorf("expected SUCCEEDED status, got %v (error: %s)", job2.Status, job2.ErrorMessage)
		}
		if len(job2.Artifacts) != 1 {
			t.Errorf("expected 1 artifact, got %d", len(job2.Artifacts))
		}
		if job2.Artifacts[0].Uri != "memory://success" {
			t.Errorf("expected artifact URI=memory://success, got %s", job2.Artifacts[0].Uri)
		}

		// Try submitting same job with same idempotency key - should return same job
		req2 := connect.NewRequest(req1)
		req2.Header().Set("Idempotency-Key", "test-idempotency-key-123")

		resp2, err := client.SubmitJob(ctx, req2)
		if err != nil {
			t.Fatalf("submit duplicate job failed: %v", err)
		}

		job3 := resp2.Msg.Job
		if job3.Id != jobID {
			t.Errorf("expected duplicate to return same job id %s, got %s", jobID, job3.Id)
		}
	})

	t.Run("metrics_incremented", func(t *testing.T) {
		// Submit another job to increment metrics
		req := connect.NewRequest(&orchestrationv1.SubmitJobRequest{
			ProjectId:   "test-project-2",
			Type:        orchestrationv1.JobType_JOB_TYPE_OPTIMIZATION,
			Priority:    5,
			MaxAttempts: 2,
			PayloadJson: `{"method": "pso"}`,
		})
		req.Header().Set("Idempotency-Key", "metrics-test-key")

		resp, err := client.SubmitJob(ctx, req)
		if err != nil {
			t.Fatalf("submit job for metrics failed: %v", err)
		}

		jobID := resp.Msg.Job.Id

		// Wait for processing
		time.Sleep(500 * time.Millisecond)

		// Get metrics
		metrics := svc.SnapshotMetrics()

		if metrics.Submitted < 2 {
			t.Errorf("expected at least 2 submitted, got %d", metrics.Submitted)
		}
		if metrics.Started < 1 {
			t.Errorf("expected at least 1 started, got %d", metrics.Started)
		}
		if metrics.Succeeded < 1 {
			t.Errorf("expected at least 1 succeeded, got %d", metrics.Succeeded)
		}
		if metrics.IdempotentHits < 1 {
			t.Errorf("expected at least 1 idempotent hit, got %d", metrics.IdempotentHits)
		}

		// Verify job state
		getResp, _ := client.GetJob(ctx, connect.NewRequest(&orchestrationv1.GetJobRequest{Id: jobID}))
		if getResp.Msg.Job.Status != orchestrationv1.JobStatus_JOB_STATUS_SUCCEEDED {
			t.Errorf("expected SUCCEEDED, got %v", getResp.Msg.Job.Status)
		}
	})

	t.Run("list_jobs_by_project", func(t *testing.T) {
		// List jobs for test-project
		listResp, err := client.ListJobs(ctx, connect.NewRequest(&orchestrationv1.ListJobsRequest{
			ProjectId: "test-project",
			Limit:     10,
		}))
		if err != nil {
			t.Fatalf("list jobs failed: %v", err)
		}

		if len(listResp.Msg.Jobs) < 1 {
			t.Errorf("expected at least 1 job, got %d", len(listResp.Msg.Jobs))
		}

		for _, job := range listResp.Msg.Jobs {
			if job.ProjectId != "test-project" {
				t.Errorf("expected project_id=test-project, got %s", job.ProjectId)
			}
		}
	})
}

// TestEndToEndFailureAndDeadLetter tests failure and dead-letter recording
func TestEndToEndFailureAndDeadLetter(t *testing.T) {
	ctx := context.Background()

	// Create in-memory repository
	repo := repository.NewInMemoryRepository()

	// Create executor that always fails
	exec := &mockFailureExecutor{
		err: fmt.Errorf("simulated execution failure"),
	}

	// Create service
	svc := service.New(repo, exec, 1, 256)
	svc.Start()
	defer svc.Stop()

	// Create handler
	h := handler.NewConnectHandler(svc)

	// Start HTTP server
	mux := http.NewServeMux()
	mux.Handle(orchestrationv1connect.NewComputeOrchestrationServiceHandler(h))

	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("failed to listen: %v", err)
	}
	defer listener.Close()

	addr := listener.Addr().String()
	baseURL := fmt.Sprintf("http://%s", addr)

	go func() {
		if err := http.Serve(listener, mux); err != nil && err != http.ErrServerClosed {
			log.Printf("server error: %v", err)
		}
	}()

	time.Sleep(100 * time.Millisecond)

	client := orchestrationv1connect.NewComputeOrchestrationServiceClient(
		&http.Client{Timeout: 5 * time.Second},
		baseURL,
		connect.WithGRPC(),
	)

	// Submit job that will fail
	req := connect.NewRequest(&orchestrationv1.SubmitJobRequest{
		ProjectId:   "fail-project",
		Type:        orchestrationv1.JobType_JOB_TYPE_SIMULATION,
		Priority:    1,
		MaxAttempts: 2,
		PayloadJson: `{"test": "failure"}`,
	})
	req.Header().Set("Idempotency-Key", "failure-test-key")

	resp, err := client.SubmitJob(ctx, req)
	if err != nil {
		t.Fatalf("submit job failed: %v", err)
	}

	jobID := resp.Msg.Job.Id

	// Wait for job to fail and exhaust retries
	time.Sleep(2 * time.Second)

	// Verify job is FAILED
	getResp, err := client.GetJob(ctx, connect.NewRequest(&orchestrationv1.GetJobRequest{Id: jobID}))
	if err != nil {
		t.Fatalf("get job failed: %v", err)
	}

	job := getResp.Msg.Job
	if job.Status != orchestrationv1.JobStatus_JOB_STATUS_FAILED {
		t.Errorf("expected FAILED status, got %v", job.Status)
	}

	// Verify metrics show dead_lettered
	metrics := svc.SnapshotMetrics()
	if metrics.DeadLettered < 1 {
		t.Errorf("expected at least 1 dead-lettered, got %d", metrics.DeadLettered)
	}

	// List dead-letters for project
	_, err = client.ListDeadLetters(ctx, connect.NewRequest(&orchestrationv1.ListDeadLettersRequest{
		ProjectId: "fail-project",
		Limit:     10,
	}))
	if err != nil {
		t.Errorf("list dead-letters failed: %v", err)
	}
}

// TestTraceLogging tests structured trace logs
func TestTraceLogging(t *testing.T) {
	var logBuffer bytes.Buffer
	log.SetOutput(&logBuffer)
	defer log.SetOutput(os.Stderr)

	ctx := context.Background()
	repo := repository.NewInMemoryRepository()
	exec := &mockSuccessExecutor{}

	svc := service.New(repo, exec, 1, 256)
	svc.Start()
	defer svc.Stop()

	payload := `{"scenario": "test", "_trace_id": "trace-123"}`
	job, err := svc.SubmitJob(ctx, "trace-proj", domain.JobTypeSimulation, 10, 2, payload, "")
	if err != nil {
		t.Fatalf("submit job failed: %v", err)
	}

	time.Sleep(300 * time.Millisecond)

	logs := logBuffer.String()
	if !strings.Contains(logs, "execute.started") {
		t.Errorf("expected 'execute.started' trace event in logs")
	}
	if !strings.Contains(logs, "execute.succeeded") {
		t.Errorf("expected 'execute.succeeded' trace event in logs")
	}
	if !strings.Contains(logs, "trace-123") {
		t.Errorf("expected trace_id 'trace-123' in logs")
	}

	retrieved, err := svc.GetJob(ctx, job.ID)
	if err != nil {
		t.Fatalf("get job failed: %v", err)
	}

	var payload_obj map[string]interface{}
	if err := json.Unmarshal([]byte(retrieved.PayloadJSON), &payload_obj); err != nil {
		t.Fatalf("failed to unmarshal job payload: %v", err)
	}

	if traceID, ok := payload_obj["_trace_id"].(string); !ok || traceID != "trace-123" {
		t.Errorf("expected trace_id in job payload, got %v", payload_obj["_trace_id"])
	}
}

// mockSuccessExecutor is a test executor that always succeeds
type mockSuccessExecutor struct {
	artifacts []domain.Artifact
}

func (e *mockSuccessExecutor) Execute(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	return e.artifacts, nil
}

// mockFailureExecutor is a test executor that always fails
type mockFailureExecutor struct {
	err error
}

func (e *mockFailureExecutor) Execute(ctx context.Context, job *domain.Job) ([]domain.Artifact, error) {
	return nil, e.err
}

