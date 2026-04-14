// Package orchestration — client for submitting long-running jobs
package orchestration

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"connectrpc.com/connect"
	orchestrationv1 "github.com/solar3d/solar3d/gen/orchestration/v1"
	"github.com/solar3d/solar3d/gen/orchestration/v1/orchestrationv1connect"
)

// Client wraps the Connect RPC client for orchestration service.
type Client struct {
	client orchestrationv1connect.ComputeOrchestrationServiceClient
}

// NewClient creates a new orchestration client.
func NewClient(baseURL string) *Client {
	httpClient := &http.Client{Timeout: 30 * time.Second}
	client := orchestrationv1connect.NewComputeOrchestrationServiceClient(httpClient, baseURL)
	return &Client{client: client}
}

// SubmitJob submits a job to the orchestration service with idempotency support.
func (c *Client) SubmitJob(ctx context.Context, projectID, jobType string, maxAttempts int32, payload string, idempotencyKey string) (string, error) {
	req := connect.NewRequest(&orchestrationv1.SubmitJobRequest{
		ProjectId:   projectID,
		Type:        parseJobType(jobType),
		Priority:    50,
		MaxAttempts: maxAttempts,
		PayloadJson: payload,
	})

	// Add idempotency header for RPC-level deduplication
	if idempotencyKey != "" {
		req.Header().Add("Idempotency-Key", idempotencyKey)
	}

	resp, err := c.client.SubmitJob(ctx, req)
	if err != nil {
		return "", fmt.Errorf("failed to submit job: %w", err)
	}

	return resp.Msg.Job.Id, nil
}

// GetJobStatus retrieves the current job status.
func (c *Client) GetJobStatus(ctx context.Context, jobID string) (string, error) {
	req := connect.NewRequest(&orchestrationv1.GetJobRequest{
		Id: jobID,
	})

	resp, err := c.client.GetJob(ctx, req)
	if err != nil {
		return "", fmt.Errorf("failed to get job status: %w", err)
	}

	return resp.Msg.Job.Status.String(), nil
}

// ListDeadLetters retrieves dead-lettered jobs for a project.
func (c *Client) ListDeadLetters(ctx context.Context, projectID string, limit int32) ([]string, error) {
	req := connect.NewRequest(&orchestrationv1.ListDeadLettersRequest{
		ProjectId: projectID,
		Limit:     limit,
	})

	resp, err := c.client.ListDeadLetters(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("failed to list dead letters: %w", err)
	}

	var ids []string
	for _, dl := range resp.Msg.DeadLetters {
		ids = append(ids, dl.JobId)
	}
	return ids, nil
}

// parseJobType maps a string job type name to the corresponding proto enum value.
func parseJobType(s string) orchestrationv1.JobType {
	switch s {
	case "regenerate":
		return orchestrationv1.JobType_JOB_TYPE_REGENERATE
	case "import":
		return orchestrationv1.JobType_JOB_TYPE_IMPORT
	case "publish":
		return orchestrationv1.JobType_JOB_TYPE_PUBLISH
	case "simulation":
		return orchestrationv1.JobType_JOB_TYPE_SIMULATION
	case "optimization":
		return orchestrationv1.JobType_JOB_TYPE_OPTIMIZATION
	case "custom":
		return orchestrationv1.JobType_JOB_TYPE_CUSTOM
	default:
		return orchestrationv1.JobType_JOB_TYPE_UNSPECIFIED
	}
}

