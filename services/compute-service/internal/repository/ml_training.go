package repository

import (
	"context"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
)

// MLTrainingRepository defines the interface for ML training and model management operations
type MLTrainingRepository interface {
	// Feedback collection
	SubmitFeedback(ctx context.Context, feedback *models.MLFeedbackLabel) (string, error)
	GetPredictionLog(ctx context.Context, predictionID string) (*models.MLPredictionLog, error)
	LogPrediction(ctx context.Context, log *models.MLPredictionLog) error

	// Training runs
	CreateTrainingRun(ctx context.Context, run *models.MLTrainingRun) error
	GetTrainingRun(ctx context.Context, trainingRunID string) (*models.MLTrainingRun, error)
	UpdateTrainingRunStatus(ctx context.Context, trainingRunID, status string) error
	UpdateTrainingRunMetrics(ctx context.Context, trainingRunID string, metrics map[string]interface{}) error
	ListTrainingRuns(ctx context.Context, taskType string, limit int) ([]models.MLTrainingRun, error)

	// Model versions
	CreateModelVersion(ctx context.Context, version *models.MLModelVersion) error
	GetModelVersion(ctx context.Context, versionID string) (*models.MLModelVersion, error)
	UpdateModelVersionStatus(ctx context.Context, versionID, status string) error
	ListModelVersions(ctx context.Context, taskType, statusFilter string, limit int) ([]models.MLModelVersion, error)
	GetLatestCandidateModel(ctx context.Context, taskType string) (*models.MLModelVersion, error)
	GetChampionModel(ctx context.Context, taskType string) (*models.MLModelVersion, error)

	// Deployments
	CreateDeployment(ctx context.Context, deployment *models.MLDeployment) error
	GetDeployment(ctx context.Context, deploymentID string) (*models.MLDeployment, error)
	UpdateDeploymentStatus(ctx context.Context, deploymentID, status string) error
	PromoteDeploymentToActive(ctx context.Context, deploymentID string) error

	// Active models registry
	GetActiveModel(ctx context.Context, taskType string) (*models.MLActiveModel, error)
	SetActiveModel(ctx context.Context, taskType string, activeModel *models.MLActiveModel) error

	// Feature schemas
	GetFeatureSchema(ctx context.Context, schemaHash string) (*models.MLFeatureSchema, error)
	CreateFeatureSchema(ctx context.Context, schema *models.MLFeatureSchema) error

	// Evaluation
	CreateEvalRun(ctx context.Context, eval *models.MLEvalRun) error
	GetEvalRun(ctx context.Context, evalID string) (*models.MLEvalRun, error)
	UpdateEvalRunResults(ctx context.Context, evalID string, metrics map[string]interface{}, candidateWins bool, recommendation string) error

	// Monitoring
	RecordMonitoringMetric(ctx context.Context, metric *models.MLMonitoringMetric) error
	GetRecentMonitoringMetrics(ctx context.Context, modelVersionID string, metricType string, limitHours int) ([]models.MLMonitoringMetric, error)

	// Drift detection
	RecordFeatureDrift(ctx context.Context, drift *models.MLFeatureDriftStat) error
	GetFeatureDriftStats(ctx context.Context, modelVersionID string, limitDays int) ([]models.MLFeatureDriftStat, error)

	// Audit
	RecordAuditEvent(ctx context.Context, event *models.MLAuditEvent) error
	GetAuditEvents(ctx context.Context, resourceType, resourceID string, limit int) ([]models.MLAuditEvent, error)

	// Helpers
	GetTrainingDataset(ctx context.Context, trainingRunID string) ([]map[string]interface{}, error)
	ArchiveOldModels(ctx context.Context, taskType string, keepDays int) (int, error)
}

// MockMLTrainingRepository for testing
type MockMLTrainingRepository struct{}

func (m *MockMLTrainingRepository) SubmitFeedback(ctx context.Context, feedback *models.MLFeedbackLabel) (string, error) {
	return "feedback_id", nil
}

func (m *MockMLTrainingRepository) GetPredictionLog(ctx context.Context, predictionID string) (*models.MLPredictionLog, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) LogPrediction(ctx context.Context, log *models.MLPredictionLog) error {
	return nil
}

func (m *MockMLTrainingRepository) CreateTrainingRun(ctx context.Context, run *models.MLTrainingRun) error {
	return nil
}

func (m *MockMLTrainingRepository) GetTrainingRun(ctx context.Context, trainingRunID string) (*models.MLTrainingRun, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) UpdateTrainingRunStatus(ctx context.Context, trainingRunID, status string) error {
	return nil
}

func (m *MockMLTrainingRepository) UpdateTrainingRunMetrics(ctx context.Context, trainingRunID string, metrics map[string]interface{}) error {
	return nil
}

func (m *MockMLTrainingRepository) ListTrainingRuns(ctx context.Context, taskType string, limit int) ([]models.MLTrainingRun, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) CreateModelVersion(ctx context.Context, version *models.MLModelVersion) error {
	return nil
}

func (m *MockMLTrainingRepository) GetModelVersion(ctx context.Context, versionID string) (*models.MLModelVersion, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) UpdateModelVersionStatus(ctx context.Context, versionID, status string) error {
	return nil
}

func (m *MockMLTrainingRepository) ListModelVersions(ctx context.Context, taskType, statusFilter string, limit int) ([]models.MLModelVersion, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) GetLatestCandidateModel(ctx context.Context, taskType string) (*models.MLModelVersion, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) GetChampionModel(ctx context.Context, taskType string) (*models.MLModelVersion, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) CreateDeployment(ctx context.Context, deployment *models.MLDeployment) error {
	return nil
}

func (m *MockMLTrainingRepository) GetDeployment(ctx context.Context, deploymentID string) (*models.MLDeployment, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) UpdateDeploymentStatus(ctx context.Context, deploymentID, status string) error {
	return nil
}

func (m *MockMLTrainingRepository) PromoteDeploymentToActive(ctx context.Context, deploymentID string) error {
	return nil
}

func (m *MockMLTrainingRepository) GetActiveModel(ctx context.Context, taskType string) (*models.MLActiveModel, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) SetActiveModel(ctx context.Context, taskType string, activeModel *models.MLActiveModel) error {
	return nil
}

func (m *MockMLTrainingRepository) GetFeatureSchema(ctx context.Context, schemaHash string) (*models.MLFeatureSchema, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) CreateFeatureSchema(ctx context.Context, schema *models.MLFeatureSchema) error {
	return nil
}

func (m *MockMLTrainingRepository) CreateEvalRun(ctx context.Context, eval *models.MLEvalRun) error {
	return nil
}

func (m *MockMLTrainingRepository) GetEvalRun(ctx context.Context, evalID string) (*models.MLEvalRun, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) UpdateEvalRunResults(ctx context.Context, evalID string, metrics map[string]interface{}, candidateWins bool, recommendation string) error {
	return nil
}

func (m *MockMLTrainingRepository) RecordMonitoringMetric(ctx context.Context, metric *models.MLMonitoringMetric) error {
	return nil
}

func (m *MockMLTrainingRepository) GetRecentMonitoringMetrics(ctx context.Context, modelVersionID string, metricType string, limitHours int) ([]models.MLMonitoringMetric, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) RecordFeatureDrift(ctx context.Context, drift *models.MLFeatureDriftStat) error {
	return nil
}

func (m *MockMLTrainingRepository) GetFeatureDriftStats(ctx context.Context, modelVersionID string, limitDays int) ([]models.MLFeatureDriftStat, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) RecordAuditEvent(ctx context.Context, event *models.MLAuditEvent) error {
	return nil
}

func (m *MockMLTrainingRepository) GetAuditEvents(ctx context.Context, resourceType, resourceID string, limit int) ([]models.MLAuditEvent, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) GetTrainingDataset(ctx context.Context, trainingRunID string) ([]map[string]interface{}, error) {
	return nil, nil
}

func (m *MockMLTrainingRepository) ArchiveOldModels(ctx context.Context, taskType string, keepDays int) (int, error) {
	return 0, nil
}

