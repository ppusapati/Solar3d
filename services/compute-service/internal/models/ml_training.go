package models

import (
	"database/sql"
	"time"
)

// ML Model Version
type MLModelVersion struct {
	ID                string
	TaskType          string
	TrainingRunID     string
	Status            string // "candidate", "champion", "archived", "failed"
	ArtifactPath      string
	ArtifactHash      string
	FeatureSchemaHash string
	Metrics           map[string]interface{}
	Metadata          map[string]interface{}
	CreatedAt         time.Time
	ArchivedAt        sql.NullTime
}

// Training Run
type MLTrainingRun struct {
	ID           string
	TaskType     string
	Status       string // "queued", "running", "completed", "failed"
	DatasetID    string
	Config       map[string]interface{}
	Hyperparams  map[string]interface{}
	Metrics      map[string]interface{}
	ErrorMessage string
	TriggeredBy  string
	CommitHash   string
	ArtifactPath string
	ArtifactHash string
	StartedAt    sql.NullTime
	CompletedAt  sql.NullTime
	CreatedAt    time.Time
}

// Prediction Log
type MLPredictionLog struct {
	ID                string
	PredictionID      string
	SiteID            string
	TaskType          string
	ModelVersionID    string
	InputFeatures     map[string]interface{}
	PredictedValue    float64
	PredictedLower    sql.NullFloat64
	PredictedUpper    sql.NullFloat64
	Confidence        sql.NullFloat64
	FeatureSchemaHash string
	CreatedAt         time.Time
}

// Feedback Label
type MLFeedbackLabel struct {
	ID              string
	PredictionLogID string
	ActualLabel     float64
	LabelType       string // "manual", "system", "inferred"
	SubmittedBy     string
	Notes           string
	CreatedAt       time.Time
}

// Deployment
type MLDeployment struct {
	ID                  string
	ModelVersionID      string
	Status              string // "deploying", "canary", "active", "failed", "rolled_back"
	DeployedBy          string
	ApprovalID          string
	Policy              map[string]interface{}
	TrafficPercent      int
	CanaryStartedAt     sql.NullTime
	PromotedToActiveAt  sql.NullTime
	DeployedAt          time.Time
	RolledBackAt        sql.NullTime
	RollbackReason      string
	RollbackTriggeredBy string
	Notes               string
}

// Active Model
type MLActiveModel struct {
	ID              string
	TaskType        string
	CurrentModelID  string
	PreviousModelID sql.NullString
	PromotedAt      time.Time
	DeploymentID    sql.NullString
}

// Feature Schema
type MLFeatureSchema struct {
	ID                  string
	TaskType            string
	Version             int
	FeatureNames        []string
	FeatureDtypes       []string
	NormalizationParams map[string]interface{}
	CreatedAt           time.Time
}

// Model Evaluation
type MLEvalRun struct {
	ID               string
	CandidateModelID string
	ChampionModelID  sql.NullString
	Status           string // "running", "completed"
	DatasetSplit     string // "validation", "test"
	Metrics          map[string]interface{}
	CandidateWins    sql.NullBool
	Recommendation   string
	CompletedAt      sql.NullTime
	CreatedAt        time.Time
}

// Monitoring Metrics
type MLMonitoringMetric struct {
	ID             int64
	ModelVersionID string
	MetricType     string // "prediction_count", "mae", "rmse", "coverage"
	MetricValue    float64
	WindowStart    time.Time
	WindowEnd      time.Time
	DriftDetected  bool
	AlertSent      bool
	CreatedAt      time.Time
}

// Feature Drift Stats
type MLFeatureDriftStat struct {
	ID             int64
	ModelVersionID string
	FeatureName    string
	DriftDetector  string // "ks_test", "wasserstein", "psi"
	DriftScore     sql.NullFloat64
	PValue         sql.NullFloat64
	DriftDetected  sql.NullBool
	WindowStart    time.Time
	WindowEnd      time.Time
	CreatedAt      time.Time
}

// Audit Event
type MLAuditEvent struct {
	ID           string
	EventType    string
	ResourceType string
	ResourceID   string
	Actor        string
	ActorIP      string
	Changes      map[string]interface{}
	CreatedAt    time.Time
}

// Request/Response Models

type SubmitFeedbackRequest struct {
	PredictionID string
	SiteID       string
	TaskType     string
	ActualLabel  float64
	Notes        string
	SubmittedBy  string
}

type SubmitFeedbackResponse struct {
	FeedbackID string
	Accepted   bool
	Message    string
}

type StartTrainingRequest struct {
	TaskType    string
	Config      map[string]interface{}
	Hyperparams map[string]string
	TriggeredBy string
	CommitHash  string
}

type StartTrainingResponse struct {
	TrainingRunID string
	Status        string
	QueuedAtMs    int64
}

type GetTrainingStatusRequest struct {
	TrainingRunID string
}

type TrainingMetrics struct {
	TrainLoss         float64
	ValidationLoss    float64
	TestLoss          float64
	TestMAE           float64
	TestRMSE          float64
	TestCoverageLower float64
	TestCoverageUpper float64
	CustomMetrics     map[string]float64
}

type GetTrainingStatusResponse struct {
	TrainingRunID      string
	Status             string
	Metrics            *TrainingMetrics
	ErrorMessage       string
	StartedAtMs        int64
	CompletedAtMs      int64
	ModelVersionID     string
	CompletionProgress float64
}

type EvaluateModelRequest struct {
	ModelVersionID string
	Dataset        string
	VersusModelID  string
}

type ModelEvaluation struct {
	ModelVersionID string
	VersusModelID  string
	MetricName     string
	BaselineValue  float64
	CandidateValue float64
	ImprovementPct float64
	MeetsThreshold bool
}

type EvaluateModelResponse struct {
	Evaluations    []ModelEvaluation
	CandidateWins  bool
	Recommendation string
}

type ModelVersionInfo struct {
	VersionID     string
	TaskType      string
	Status        string
	CreatedAtMs   int64
	DeployedAtMs  int64
	Metrics       *TrainingMetrics
	ArtifactPath  string
	ArtifactHash  string
	SchemaHash    string
	TrainingRunID string
	CommitHash    string
	Metadata      map[string]string
}

type GetModelVersionsRequest struct {
	TaskType     string
	Limit        int
	StatusFilter string
}

type GetModelVersionsResponse struct {
	Versions []ModelVersionInfo
}

type DeploymentPolicy struct {
	MinImprovementPercent float64
	RequireManualApproval bool
	CanaryTrafficPercent  float64
	RollbackThresholdMins int
	AlertThresholds       []string
}

type DeployModelVersionRequest struct {
	ModelVersionID string
	Policy         DeploymentPolicy
	DeployedBy     string
	ApprovalID     string
	Notes          string
}

type DeployModelVersionResponse struct {
	DeploymentID string
	Status       string
	DeployedAtMs int64
	Message      string
}

type GetActiveModelVersionRequest struct {
	TaskType string
}

type GetActiveModelVersionResponse struct {
	ActiveVersion   ModelVersionInfo
	PreviousVersion *ModelVersionInfo
}

type RollbackModelVersionRequest struct {
	TaskType     string
	Reason       string
	RolledBackBy string
}

type RollbackModelVersionResponse struct {
	ActiveVersionID string
	RolledBackAtMs  int64
	Message         string
}

