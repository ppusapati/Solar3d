package repository

import (
	"context"
	"fmt"
	"sort"
	"sync"
	"time"

	"solar3d/compute-orchestration-service/internal/domain"
)

// Store defines persistence behavior for orchestration jobs.
type Store interface {
	CreateJob(ctx context.Context, job *domain.Job) error
	UpdateJob(ctx context.Context, job *domain.Job) error
	GetJob(ctx context.Context, id string) (*domain.Job, error)
	ListJobs(ctx context.Context, projectID string, status domain.JobStatus, limit int32) ([]domain.Job, error)
	FindByIdempotencyKey(ctx context.Context, projectID, idempotencyKey string) (*domain.Job, error)
	SaveIdempotencyKey(ctx context.Context, projectID, idempotencyKey, jobID string) error
	MarkRetryPending(ctx context.Context, id string, nextRetry time.Time, errMsg string) (*domain.Job, error)
	RecordAttempt(ctx context.Context, jobID string, attemptNo int32, status domain.JobStatus, startedAt, finishedAt *time.Time, errMsg string) error
	RecordDeadLetter(ctx context.Context, jobID, reason, payloadJSON string) error
	ListDeadLetters(ctx context.Context, projectID string, limit int32) ([]domain.DeadLetter, error)
	GetDeadLetter(ctx context.Context, jobID string) (*domain.DeadLetter, error)
	Health(ctx context.Context) error
}

type InMemoryRepository struct {
	mu              sync.RWMutex
	jobs            map[string]*domain.Job
	idempotencyToID map[string]string
}

func NewInMemoryRepository() *InMemoryRepository {
	return &InMemoryRepository{
		jobs:            make(map[string]*domain.Job),
		idempotencyToID: make(map[string]string),
	}
}

var _ Store = (*InMemoryRepository)(nil)

func (r *InMemoryRepository) CreateJob(ctx context.Context, job *domain.Job) error {
	_ = ctx
	r.mu.Lock()
	defer r.mu.Unlock()
	if _, exists := r.jobs[job.ID]; exists {
		return fmt.Errorf("job %s already exists", job.ID)
	}
	cp := *job
	r.jobs[job.ID] = &cp
	return nil
}

func (r *InMemoryRepository) UpdateJob(ctx context.Context, job *domain.Job) error {
	_ = ctx
	r.mu.Lock()
	defer r.mu.Unlock()
	if _, exists := r.jobs[job.ID]; !exists {
		return fmt.Errorf("job %s not found", job.ID)
	}
	cp := *job
	r.jobs[job.ID] = &cp
	return nil
}

func (r *InMemoryRepository) GetJob(ctx context.Context, id string) (*domain.Job, error) {
	_ = ctx
	r.mu.RLock()
	defer r.mu.RUnlock()
	job, ok := r.jobs[id]
	if !ok {
		return nil, fmt.Errorf("job %s not found", id)
	}
	cp := *job
	if len(job.Artifacts) > 0 {
		cp.Artifacts = append([]domain.Artifact(nil), job.Artifacts...)
	}
	return &cp, nil
}

func (r *InMemoryRepository) ListJobs(ctx context.Context, projectID string, status domain.JobStatus, limit int32) ([]domain.Job, error) {
	_ = ctx
	r.mu.RLock()
	defer r.mu.RUnlock()
	jobs := make([]domain.Job, 0)
	for _, j := range r.jobs {
		if projectID != "" && j.ProjectID != projectID {
			continue
		}
		if status != "" && status != domain.JobStatusUnspecified && j.Status != status {
			continue
		}
		cp := *j
		if len(j.Artifacts) > 0 {
			cp.Artifacts = append([]domain.Artifact(nil), j.Artifacts...)
		}
		jobs = append(jobs, cp)
	}
	sort.Slice(jobs, func(i, j int) bool {
		if jobs[i].Priority != jobs[j].Priority {
			return jobs[i].Priority > jobs[j].Priority
		}
		return jobs[i].CreatedAt.Before(jobs[j].CreatedAt)
	})
	if limit > 0 && int(limit) < len(jobs) {
		jobs = jobs[:limit]
	}
	return jobs, nil
}

func (r *InMemoryRepository) FindByIdempotencyKey(ctx context.Context, projectID, idempotencyKey string) (*domain.Job, error) {
	_ = ctx
	if projectID == "" || idempotencyKey == "" {
		return nil, nil
	}
	r.mu.RLock()
	defer r.mu.RUnlock()
	jobID, ok := r.idempotencyToID[projectID+"|"+idempotencyKey]
	if !ok {
		return nil, nil
	}
	job, ok := r.jobs[jobID]
	if !ok {
		return nil, nil
	}
	cp := *job
	if len(job.Artifacts) > 0 {
		cp.Artifacts = append([]domain.Artifact(nil), job.Artifacts...)
	}
	return &cp, nil
}

func (r *InMemoryRepository) SaveIdempotencyKey(ctx context.Context, projectID, idempotencyKey, jobID string) error {
	_ = ctx
	if projectID == "" || idempotencyKey == "" || jobID == "" {
		return nil
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	r.idempotencyToID[projectID+"|"+idempotencyKey] = jobID
	return nil
}

func (r *InMemoryRepository) MarkRetryPending(ctx context.Context, id string, nextRetry time.Time, errMsg string) (*domain.Job, error) {
	_ = ctx
	r.mu.Lock()
	defer r.mu.Unlock()
	job, ok := r.jobs[id]
	if !ok {
		return nil, fmt.Errorf("job %s not found", id)
	}
	job.Status = domain.JobStatusRetryPending
	job.ErrorMessage = errMsg
	job.NextRetryAt = &nextRetry
	cp := *job
	return &cp, nil
}

func (r *InMemoryRepository) RecordAttempt(ctx context.Context, jobID string, attemptNo int32, status domain.JobStatus, startedAt, finishedAt *time.Time, errMsg string) error {
	_ = ctx
	_ = jobID
	_ = attemptNo
	_ = status
	_ = startedAt
	_ = finishedAt
	_ = errMsg
	return nil
}

func (r *InMemoryRepository) RecordDeadLetter(ctx context.Context, jobID, reason, payloadJSON string) error {
	_ = ctx
	_ = jobID
	_ = reason
	_ = payloadJSON
	return nil
}

func (r *InMemoryRepository) ListDeadLetters(ctx context.Context, projectID string, limit int32) ([]domain.DeadLetter, error) {
	_ = ctx
	_ = projectID
	_ = limit
	return []domain.DeadLetter{}, nil
}

func (r *InMemoryRepository) GetDeadLetter(ctx context.Context, jobID string) (*domain.DeadLetter, error) {
	_ = ctx
	_ = jobID
	return nil, nil
}

func (r *InMemoryRepository) Health(ctx context.Context) error {
	_ = ctx
	return nil
}

