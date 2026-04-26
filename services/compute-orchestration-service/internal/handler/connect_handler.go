package handler

import (
	"context"
	"fmt"
	"time"

	"connectrpc.com/connect"
	orchestrationv1 "p9e.in/samavaya/solar3d/gen/orchestration/v1"
	orchestrationv1connect "p9e.in/samavaya/solar3d/gen/orchestration/v1/orchestrationv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/domain"
	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/service"
)

type ConnectHandler struct {
	svc *service.Service
}

var _ orchestrationv1connect.ComputeOrchestrationServiceHandler = (*ConnectHandler)(nil)

func NewConnectHandler(svc *service.Service) *ConnectHandler {
	return &ConnectHandler{svc: svc}
}

func (h *ConnectHandler) SubmitJob(ctx context.Context, req *connect.Request[orchestrationv1.SubmitJobRequest]) (*connect.Response[orchestrationv1.SubmitJobResponse], error) {
	idempotencyKey := req.Header().Get("Idempotency-Key")
	job, err := h.svc.SubmitJob(ctx, req.Msg.ProjectId, toDomainJobType(req.Msg.Type), req.Msg.Priority, req.Msg.MaxAttempts, req.Msg.PayloadJson, idempotencyKey)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	return connect.NewResponse(&orchestrationv1.SubmitJobResponse{Job: toProtoJob(job)}), nil
}

func (h *ConnectHandler) GetJob(ctx context.Context, req *connect.Request[orchestrationv1.GetJobRequest]) (*connect.Response[orchestrationv1.GetJobResponse], error) {
	job, err := h.svc.GetJob(ctx, req.Msg.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}
	return connect.NewResponse(&orchestrationv1.GetJobResponse{Job: toProtoJob(job)}), nil
}

func (h *ConnectHandler) ListJobs(ctx context.Context, req *connect.Request[orchestrationv1.ListJobsRequest]) (*connect.Response[orchestrationv1.ListJobsResponse], error) {
	jobs, err := h.svc.ListJobs(ctx, req.Msg.ProjectId, toDomainJobStatus(req.Msg.StatusFilter), req.Msg.Limit)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	out := make([]*orchestrationv1.Job, 0, len(jobs))
	for i := range jobs {
		j := jobs[i]
		out = append(out, toProtoJob(&j))
	}
	return connect.NewResponse(&orchestrationv1.ListJobsResponse{Jobs: out}), nil
}

func (h *ConnectHandler) RetryJob(ctx context.Context, req *connect.Request[orchestrationv1.RetryJobRequest]) (*connect.Response[orchestrationv1.RetryJobResponse], error) {
	job, err := h.svc.RetryJob(ctx, req.Msg.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}
	return connect.NewResponse(&orchestrationv1.RetryJobResponse{Job: toProtoJob(job)}), nil
}

func (h *ConnectHandler) CancelJob(ctx context.Context, req *connect.Request[orchestrationv1.CancelJobRequest]) (*connect.Response[orchestrationv1.CancelJobResponse], error) {
	job, err := h.svc.CancelJob(ctx, req.Msg.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}
	return connect.NewResponse(&orchestrationv1.CancelJobResponse{Job: toProtoJob(job)}), nil
}

func (h *ConnectHandler) ListDeadLetters(ctx context.Context, req *connect.Request[orchestrationv1.ListDeadLettersRequest]) (*connect.Response[orchestrationv1.ListDeadLettersResponse], error) {
	deadLetters, err := h.svc.ListDeadLetters(ctx, req.Msg.ProjectId, req.Msg.Limit)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	out := make([]*orchestrationv1.DeadLetter, 0, len(deadLetters))
	for i := range deadLetters {
		dl := deadLetters[i]
		out = append(out, toProtoDeadLetter(&dl))
	}
	return connect.NewResponse(&orchestrationv1.ListDeadLettersResponse{DeadLetters: out}), nil
}

func (h *ConnectHandler) GetDeadLetter(ctx context.Context, req *connect.Request[orchestrationv1.GetDeadLetterRequest]) (*connect.Response[orchestrationv1.GetDeadLetterResponse], error) {
	deadLetter, err := h.svc.GetDeadLetter(ctx, req.Msg.JobId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if deadLetter == nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("dead-letter not found for job %s", req.Msg.JobId))
	}
	return connect.NewResponse(&orchestrationv1.GetDeadLetterResponse{DeadLetter: toProtoDeadLetter(deadLetter)}), nil
}

func toProtoDeadLetter(dl *domain.DeadLetter) *orchestrationv1.DeadLetter {
	if dl == nil {
		return &orchestrationv1.DeadLetter{}
	}
	return &orchestrationv1.DeadLetter{
		Id:          dl.ID,
		JobId:       dl.JobID,
		Reason:      dl.Reason,
		PayloadJson: dl.PayloadJSON,
		CreatedAt:   timestamppb.New(dl.CreatedAt),
	}
}

func toProtoJob(job *domain.Job) *orchestrationv1.Job {
	if job == nil {
		return &orchestrationv1.Job{}
	}
	artifacts := make([]*orchestrationv1.Artifact, 0, len(job.Artifacts))
	for _, a := range job.Artifacts {
		artifacts = append(artifacts, &orchestrationv1.Artifact{Kind: a.Kind, Uri: a.URI, Checksum: a.Checksum, SizeBytes: a.SizeBytes})
	}
	return &orchestrationv1.Job{
		Id:           job.ID,
		ProjectId:    job.ProjectID,
		Type:         toProtoJobType(job.Type),
		Status:       toProtoJobStatus(job.Status),
		Priority:     job.Priority,
		Attempts:     job.Attempts,
		MaxAttempts:  job.MaxAttempts,
		PayloadJson:  job.PayloadJSON,
		ErrorMessage: job.ErrorMessage,
		Artifacts:    artifacts,
		CreatedAt:    timestamppb.New(job.CreatedAt),
		StartedAt:    tsOrNil(job.StartedAt),
		CompletedAt:  tsOrNil(job.CompletedAt),
		NextRetryAt:  tsOrNil(job.NextRetryAt),
	}
}

func tsOrNil(t *time.Time) *timestamppb.Timestamp {
	if t == nil {
		return nil
	}
	return timestamppb.New(*t)
}

func toDomainJobType(v orchestrationv1.JobType) domain.JobType {
	switch v {
	case orchestrationv1.JobType_JOB_TYPE_REGENERATE:
		return domain.JobTypeRegenerate
	case orchestrationv1.JobType_JOB_TYPE_IMPORT:
		return domain.JobTypeImport
	case orchestrationv1.JobType_JOB_TYPE_PUBLISH:
		return domain.JobTypePublish
	case orchestrationv1.JobType_JOB_TYPE_SIMULATION:
		return domain.JobTypeSimulation
	case orchestrationv1.JobType_JOB_TYPE_OPTIMIZATION:
		return domain.JobTypeOptimization
	case orchestrationv1.JobType_JOB_TYPE_CUSTOM:
		return domain.JobTypeCustom
	case orchestrationv1.JobType_JOB_TYPE_STRUCTURAL_LOAD_ANALYSIS:
		return domain.JobTypeStructural
	case orchestrationv1.JobType_JOB_TYPE_PROTECTION_STUDY:
		return domain.JobTypeProtection
	case orchestrationv1.JobType_JOB_TYPE_COMMISSIONING:
		return domain.JobTypeCommissioning
	default:
		return domain.JobTypeUnspecified
	}
}

func toProtoJobType(v domain.JobType) orchestrationv1.JobType {
	switch v {
	case domain.JobTypeRegenerate:
		return orchestrationv1.JobType_JOB_TYPE_REGENERATE
	case domain.JobTypeImport:
		return orchestrationv1.JobType_JOB_TYPE_IMPORT
	case domain.JobTypePublish:
		return orchestrationv1.JobType_JOB_TYPE_PUBLISH
	case domain.JobTypeSimulation:
		return orchestrationv1.JobType_JOB_TYPE_SIMULATION
	case domain.JobTypeOptimization:
		return orchestrationv1.JobType_JOB_TYPE_OPTIMIZATION
	case domain.JobTypeCustom:
		return orchestrationv1.JobType_JOB_TYPE_CUSTOM
	case domain.JobTypeStructural:
		return orchestrationv1.JobType_JOB_TYPE_STRUCTURAL_LOAD_ANALYSIS
	case domain.JobTypeProtection:
		return orchestrationv1.JobType_JOB_TYPE_PROTECTION_STUDY
	case domain.JobTypeCommissioning:
		return orchestrationv1.JobType_JOB_TYPE_COMMISSIONING
	default:
		return orchestrationv1.JobType_JOB_TYPE_UNSPECIFIED
	}
}

func toDomainJobStatus(v orchestrationv1.JobStatus) domain.JobStatus {
	switch v {
	case orchestrationv1.JobStatus_JOB_STATUS_QUEUED:
		return domain.JobStatusQueued
	case orchestrationv1.JobStatus_JOB_STATUS_RUNNING:
		return domain.JobStatusRunning
	case orchestrationv1.JobStatus_JOB_STATUS_SUCCEEDED:
		return domain.JobStatusSucceeded
	case orchestrationv1.JobStatus_JOB_STATUS_FAILED:
		return domain.JobStatusFailed
	case orchestrationv1.JobStatus_JOB_STATUS_CANCELED:
		return domain.JobStatusCanceled
	case orchestrationv1.JobStatus_JOB_STATUS_RETRY_PENDING:
		return domain.JobStatusRetryPending
	default:
		return domain.JobStatusUnspecified
	}
}

func toProtoJobStatus(v domain.JobStatus) orchestrationv1.JobStatus {
	switch v {
	case domain.JobStatusQueued:
		return orchestrationv1.JobStatus_JOB_STATUS_QUEUED
	case domain.JobStatusRunning:
		return orchestrationv1.JobStatus_JOB_STATUS_RUNNING
	case domain.JobStatusSucceeded:
		return orchestrationv1.JobStatus_JOB_STATUS_SUCCEEDED
	case domain.JobStatusFailed:
		return orchestrationv1.JobStatus_JOB_STATUS_FAILED
	case domain.JobStatusCanceled:
		return orchestrationv1.JobStatus_JOB_STATUS_CANCELED
	case domain.JobStatusRetryPending:
		return orchestrationv1.JobStatus_JOB_STATUS_RETRY_PENDING
	default:
		return orchestrationv1.JobStatus_JOB_STATUS_UNSPECIFIED
	}
}

func ValidateJobType(t orchestrationv1.JobType) error {
	if t == orchestrationv1.JobType_JOB_TYPE_UNSPECIFIED {
		return fmt.Errorf("job type is required")
	}
	return nil
}
