package service

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/domain"
	"p9e.in/samavaya/solar3d/compute-orchestration-service/internal/repository"
)

type Executor interface {
	Execute(ctx context.Context, job *domain.Job) ([]domain.Artifact, error)
}

type MetricsSnapshot struct {
	Submitted      uint64 `json:"submitted"`
	Started        uint64 `json:"started"`
	Succeeded      uint64 `json:"succeeded"`
	Failed         uint64 `json:"failed"`
	Retried        uint64 `json:"retried"`
	DeadLettered   uint64 `json:"dead_lettered"`
	IdempotentHits uint64 `json:"idempotent_hits"`
	InFlight       int64  `json:"in_flight"`
	UptimeSeconds  int64  `json:"uptime_seconds"`
}

type Service struct {
	repo      repository.Store
	executor  Executor
	jobQueue  chan string
	workers   int
	stop      chan struct{}
	wg        sync.WaitGroup
	startOnce sync.Once
	stopOnce  sync.Once
	startedAt time.Time

	submitted      atomic.Uint64
	started        atomic.Uint64
	succeeded      atomic.Uint64
	failed         atomic.Uint64
	retried        atomic.Uint64
	deadLettered   atomic.Uint64
	idempotentHits atomic.Uint64
	inFlight       atomic.Int64
}

func New(repo repository.Store, executor Executor, workers int, queueBuffer int) *Service {
	return &Service{
		repo:      repo,
		executor:  executor,
		jobQueue:  make(chan string, queueBuffer),
		workers:   workers,
		stop:      make(chan struct{}),
		startedAt: time.Now().UTC(),
	}
}

func (s *Service) Start() {
	s.startOnce.Do(func() {
		for i := 0; i < s.workers; i++ {
			s.wg.Add(1)
			go s.workerLoop()
		}
	})
}

func (s *Service) Stop() {
	s.stopOnce.Do(func() {
		close(s.stop)
		s.wg.Wait()
	})
}

func (s *Service) SubmitJob(ctx context.Context, projectID string, jobType domain.JobType, priority int32, maxAttempts int32, payload string, idempotencyKey string) (*domain.Job, error) {
	if projectID == "" {
		return nil, fmt.Errorf("project_id is required")
	}
	if maxAttempts <= 0 {
		maxAttempts = 3
	}

	payloadWithTrace, traceID := ensureTracePayload(payload)
	if strings.TrimSpace(idempotencyKey) != "" {
		existing, err := s.repo.FindByIdempotencyKey(ctx, projectID, idempotencyKey)
		if err != nil {
			return nil, err
		}
		if existing != nil {
			s.idempotentHits.Add(1)
			s.emitTrace(existing.ID, extractTraceID(existing.PayloadJSON), "submit.idempotent_hit", map[string]any{"project_id": projectID})
			return existing, nil
		}
	}

	job := &domain.Job{
		ID:          uuid.NewString(),
		ProjectID:   projectID,
		Type:        jobType,
		Status:      domain.JobStatusQueued,
		Priority:    priority,
		Attempts:    0,
		MaxAttempts: maxAttempts,
		PayloadJSON: payloadWithTrace,
		CreatedAt:   time.Now().UTC(),
	}
	if err := s.repo.CreateJob(ctx, job); err != nil {
		return nil, err
	}
	if strings.TrimSpace(idempotencyKey) != "" {
		if err := s.repo.SaveIdempotencyKey(ctx, projectID, idempotencyKey, job.ID); err != nil {
			return nil, err
		}
	}

	s.submitted.Add(1)
	s.emitTrace(job.ID, traceID, "submit.accepted", map[string]any{"project_id": projectID, "job_type": jobType})

	select {
	case s.jobQueue <- job.ID:
	default:
		return nil, fmt.Errorf("job queue is full")
	}
	return job, nil
}

func (s *Service) GetJob(ctx context.Context, id string) (*domain.Job, error) {
	if id == "" {
		return nil, fmt.Errorf("id is required")
	}
	return s.repo.GetJob(ctx, id)
}

func (s *Service) ListJobs(ctx context.Context, projectID string, status domain.JobStatus, limit int32) ([]domain.Job, error) {
	return s.repo.ListJobs(ctx, projectID, status, limit)
}

func (s *Service) RetryJob(ctx context.Context, id string) (*domain.Job, error) {
	job, err := s.repo.GetJob(ctx, id)
	if err != nil {
		return nil, err
	}
	if job.Status != domain.JobStatusFailed && job.Status != domain.JobStatusCanceled {
		return nil, fmt.Errorf("job %s is not retryable in status %s", id, job.Status)
	}
	job.Status = domain.JobStatusQueued
	job.ErrorMessage = ""
	job.NextRetryAt = nil
	if err := s.repo.UpdateJob(ctx, job); err != nil {
		return nil, err
	}
	s.retried.Add(1)
	s.emitTrace(job.ID, extractTraceID(job.PayloadJSON), "retry.queued", nil)
	select {
	case s.jobQueue <- job.ID:
	default:
		return nil, fmt.Errorf("job queue is full")
	}
	return job, nil
}

func (s *Service) CancelJob(ctx context.Context, id string) (*domain.Job, error) {
	job, err := s.repo.GetJob(ctx, id)
	if err != nil {
		return nil, err
	}
	if job.Status == domain.JobStatusSucceeded || job.Status == domain.JobStatusFailed || job.Status == domain.JobStatusCanceled {
		return nil, fmt.Errorf("job %s cannot be canceled in status %s", id, job.Status)
	}
	now := time.Now().UTC()
	job.Status = domain.JobStatusCanceled
	job.CompletedAt = &now
	job.ErrorMessage = "canceled by user"
	if err := s.repo.UpdateJob(ctx, job); err != nil {
		return nil, err
	}
	s.emitTrace(job.ID, extractTraceID(job.PayloadJSON), "cancel.completed", nil)
	return job, nil
}

func (s *Service) Health(ctx context.Context) error {
	return s.repo.Health(ctx)
}

func (s *Service) SnapshotMetrics() MetricsSnapshot {
	uptime := int64(time.Since(s.startedAt).Seconds())
	if uptime < 0 {
		uptime = 0
	}
	return MetricsSnapshot{
		Submitted:      s.submitted.Load(),
		Started:        s.started.Load(),
		Succeeded:      s.succeeded.Load(),
		Failed:         s.failed.Load(),
		Retried:        s.retried.Load(),
		DeadLettered:   s.deadLettered.Load(),
		IdempotentHits: s.idempotentHits.Load(),
		InFlight:       s.inFlight.Load(),
		UptimeSeconds:  uptime,
	}
}

func (s *Service) ListDeadLetters(ctx context.Context, projectID string, limit int32) ([]domain.DeadLetter, error) {
	return s.repo.ListDeadLetters(ctx, projectID, limit)
}

func (s *Service) GetDeadLetter(ctx context.Context, jobID string) (*domain.DeadLetter, error) {
	return s.repo.GetDeadLetter(ctx, jobID)
}

func (s *Service) workerLoop() {
	defer s.wg.Done()
	for {
		select {
		case <-s.stop:
			return
		case id := <-s.jobQueue:
			s.processJob(id)
		}
	}
}

func (s *Service) processJob(id string) {
	ctx := context.Background()
	job, err := s.repo.GetJob(ctx, id)
	if err != nil {
		return
	}
	if job.Status == domain.JobStatusCanceled {
		return
	}
	if s.executor == nil {
		s.handleFailure(ctx, job, fmt.Errorf("executor is not configured"), nil, nil)
		return
	}

	traceID := extractTraceID(job.PayloadJSON)
	now := time.Now().UTC()
	job.Status = domain.JobStatusRunning
	job.Attempts++
	job.StartedAt = &now
	job.ErrorMessage = ""
	job.NextRetryAt = nil
	_ = s.repo.UpdateJob(ctx, job)
	_ = s.repo.RecordAttempt(ctx, job.ID, job.Attempts, domain.JobStatusRunning, &now, nil, "")

	s.started.Add(1)
	s.inFlight.Add(1)
	s.emitTrace(job.ID, traceID, "execute.started", map[string]any{"attempt": job.Attempts})

	resultArtifacts, execErr := s.executor.Execute(ctx, job)
	finished := time.Now().UTC()
	s.inFlight.Add(-1)

	if execErr != nil {
		s.handleFailure(ctx, job, execErr, &now, &finished)
		return
	}

	job.Status = domain.JobStatusSucceeded
	job.CompletedAt = &finished
	job.Artifacts = resultArtifacts
	if err := s.repo.UpdateJob(ctx, job); err != nil {
		s.handleFailure(ctx, job, err, &now, &finished)
		return
	}
	_ = s.repo.RecordAttempt(ctx, job.ID, job.Attempts, domain.JobStatusSucceeded, &now, &finished, "")

	s.succeeded.Add(1)
	s.emitTrace(job.ID, traceID, "execute.succeeded", map[string]any{"artifacts": len(resultArtifacts)})
}

func (s *Service) handleFailure(ctx context.Context, job *domain.Job, execErr error, startedAt, finishedAt *time.Time) {
	traceID := extractTraceID(job.PayloadJSON)
	errMsg := execErr.Error()

	if job.Attempts >= job.MaxAttempts {
		now := time.Now().UTC()
		job.Status = domain.JobStatusFailed
		job.CompletedAt = &now
		job.ErrorMessage = errMsg
		if err := s.repo.UpdateJob(ctx, job); err != nil {
			log.Printf("event=repo.update_failed job_id=%s err=%v", job.ID, err)
		}
		if startedAt != nil {
			if err := s.repo.RecordAttempt(ctx, job.ID, job.Attempts, domain.JobStatusFailed, startedAt, &now, errMsg); err != nil {
				log.Printf("event=repo.record_attempt_failed job_id=%s err=%v", job.ID, err)
			}
		}
		if err := s.repo.RecordDeadLetter(ctx, job.ID, errMsg, job.PayloadJSON); err != nil {
			log.Printf("event=repo.dead_letter_failed job_id=%s err=%v", job.ID, err)
		}
		s.failed.Add(1)
		s.deadLettered.Add(1)
		s.emitTrace(job.ID, traceID, "execute.dead_lettered", map[string]any{"error": errMsg})
		return
	}

	if startedAt != nil {
		if err := s.repo.RecordAttempt(ctx, job.ID, job.Attempts, domain.JobStatusFailed, startedAt, finishedAt, errMsg); err != nil {
			log.Printf("event=repo.record_attempt_failed job_id=%s err=%v", job.ID, err)
		}
	}

	backoff := time.Duration(job.Attempts*2) * time.Second
	nextRetry := time.Now().UTC().Add(backoff)
	if _, err := s.repo.MarkRetryPending(ctx, job.ID, nextRetry, errMsg); err != nil {
		log.Printf("event=repo.mark_retry_failed job_id=%s err=%v", job.ID, err)
	}
	s.failed.Add(1)
	s.emitTrace(job.ID, traceID, "execute.retry_scheduled", map[string]any{"error": errMsg, "backoff_seconds": int(backoff.Seconds())})

	time.AfterFunc(backoff, func() {
		fresh, err := s.repo.GetJob(context.Background(), job.ID)
		if err != nil {
			return
		}
		if fresh.Status == domain.JobStatusCanceled || fresh.Status == domain.JobStatusSucceeded {
			return
		}
		fresh.Status = domain.JobStatusQueued
		fresh.ErrorMessage = ""
		fresh.NextRetryAt = nil
		_ = s.repo.UpdateJob(context.Background(), fresh)
		select {
		case s.jobQueue <- job.ID:
		default:
		}
	})
}

func ensureTracePayload(payload string) (string, string) {
	obj := make(map[string]any)
	trimmed := strings.TrimSpace(payload)
	if trimmed != "" {
		if err := json.Unmarshal([]byte(trimmed), &obj); err != nil {
			obj = map[string]any{"raw": payload}
		}
	}
	traceID, _ := obj["_trace_id"].(string)
	if strings.TrimSpace(traceID) == "" {
		traceID = uuid.NewString()
		obj["_trace_id"] = traceID
	}
	out, err := json.Marshal(obj)
	if err != nil {
		return payload, traceID
	}
	return string(out), traceID
}

func extractTraceID(payload string) string {
	obj := make(map[string]any)
	if err := json.Unmarshal([]byte(payload), &obj); err != nil {
		return ""
	}
	v, _ := obj["_trace_id"].(string)
	return v
}

func (s *Service) emitTrace(jobID, traceID, event string, fields map[string]any) {
	entry := map[string]any{
		"ts":        time.Now().UTC().Format(time.RFC3339Nano),
		"component": "compute-orchestration",
		"event":     event,
		"job_id":    jobID,
		"trace_id":  traceID,
	}
	for k, v := range fields {
		entry[k] = v
	}
	b, err := json.Marshal(entry)
	if err != nil {
		log.Printf("event=%s job_id=%s trace_id=%s", event, jobID, traceID)
		return
	}
	log.Println(string(b))
}

