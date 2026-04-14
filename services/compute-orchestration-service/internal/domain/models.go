package domain

import "time"

type JobType string

const (
	JobTypeUnspecified   JobType = "UNSPECIFIED"
	JobTypeRegenerate    JobType = "REGENERATE"
	JobTypeImport        JobType = "IMPORT"
	JobTypePublish       JobType = "PUBLISH"
	JobTypeSimulation    JobType = "SIMULATION"
	JobTypeOptimization  JobType = "OPTIMIZATION"
	JobTypeCustom        JobType = "CUSTOM"
	JobTypeStructural    JobType = "STRUCTURAL_LOAD_ANALYSIS"
	JobTypeProtection    JobType = "PROTECTION_STUDY"
	JobTypeCommissioning JobType = "COMMISSIONING"
)

type JobStatus string

const (
	JobStatusUnspecified  JobStatus = "UNSPECIFIED"
	JobStatusQueued       JobStatus = "QUEUED"
	JobStatusRunning      JobStatus = "RUNNING"
	JobStatusSucceeded    JobStatus = "SUCCEEDED"
	JobStatusFailed       JobStatus = "FAILED"
	JobStatusCanceled     JobStatus = "CANCELED"
	JobStatusRetryPending JobStatus = "RETRY_PENDING"
)

type Artifact struct {
	Kind      string
	URI       string
	Checksum  string
	SizeBytes int64
}

type Job struct {
	ID           string
	ProjectID    string
	Type         JobType
	Status       JobStatus
	Priority     int32
	Attempts     int32
	MaxAttempts  int32
	PayloadJSON  string
	ErrorMessage string
	Artifacts    []Artifact
	CreatedAt    time.Time
	StartedAt    *time.Time
	CompletedAt  *time.Time
	NextRetryAt  *time.Time
}

type DeadLetter struct {
	ID          string
	JobID       string
	Reason      string
	PayloadJSON string
	CreatedAt   time.Time
}
