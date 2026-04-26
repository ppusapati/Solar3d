package service

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"math/rand"
	"sync"
	"time"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

type inMemoryMLRepo struct {
	*repository.MockMLTrainingRepository

	mu             sync.RWMutex
	predictionLogs map[string]*models.MLPredictionLog
	feedbacks      map[string]*models.MLFeedbackLabel
	trainingRuns   map[string]*models.MLTrainingRun
	modelVersions  map[string]*models.MLModelVersion
	deployments    map[string]*models.MLDeployment
	activeModels   map[string]*models.MLActiveModel
	auditEvents    []*models.MLAuditEvent
}

func newInMemoryMLRepo() *inMemoryMLRepo {
	return &inMemoryMLRepo{
		MockMLTrainingRepository: &repository.MockMLTrainingRepository{},
		predictionLogs:           make(map[string]*models.MLPredictionLog),
		feedbacks:                make(map[string]*models.MLFeedbackLabel),
		trainingRuns:             make(map[string]*models.MLTrainingRun),
		modelVersions:            make(map[string]*models.MLModelVersion),
		deployments:              make(map[string]*models.MLDeployment),
		activeModels:             make(map[string]*models.MLActiveModel),
		auditEvents:              make([]*models.MLAuditEvent, 0, 128),
	}
}

func (r *inMemoryMLRepo) GetPredictionLog(ctx context.Context, predictionID string) (*models.MLPredictionLog, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	log, ok := r.predictionLogs[predictionID]
	if !ok {
		return nil, nil
	}
	cp := *log
	return &cp, nil
}

func (r *inMemoryMLRepo) SubmitFeedback(ctx context.Context, feedback *models.MLFeedbackLabel) (string, error) {
	if feedback == nil {
		return "", errors.New("feedback is nil")
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	r.feedbacks[feedback.ID] = feedback
	return feedback.ID, nil
}

func (r *inMemoryMLRepo) CreateTrainingRun(ctx context.Context, run *models.MLTrainingRun) error {
	if run == nil {
		return errors.New("training run is nil")
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	cp := *run
	r.trainingRuns[run.ID] = &cp
	return nil
}

func (r *inMemoryMLRepo) GetTrainingRun(ctx context.Context, trainingRunID string) (*models.MLTrainingRun, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	run, ok := r.trainingRuns[trainingRunID]
	if !ok {
		return nil, nil
	}
	cp := *run
	return &cp, nil
}

func (r *inMemoryMLRepo) UpdateTrainingRunStatus(ctx context.Context, trainingRunID, status string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	run, ok := r.trainingRuns[trainingRunID]
	if !ok {
		return fmt.Errorf("training run not found: %s", trainingRunID)
	}
	run.Status = status
	now := time.Now()
	if status == StatusRunning {
		run.StartedAt = sql.NullTime{Time: now, Valid: true}
	}
	if status == StatusComplete || status == StatusFailed {
		run.CompletedAt = sql.NullTime{Time: now, Valid: true}
	}
	return nil
}

func (r *inMemoryMLRepo) UpdateTrainingRunMetrics(ctx context.Context, trainingRunID string, metrics map[string]interface{}) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	run, ok := r.trainingRuns[trainingRunID]
	if !ok {
		return fmt.Errorf("training run not found: %s", trainingRunID)
	}
	run.Metrics = metrics
	return nil
}

func (r *inMemoryMLRepo) CreateModelVersion(ctx context.Context, version *models.MLModelVersion) error {
	if version == nil {
		return errors.New("model version is nil")
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	cp := *version
	r.modelVersions[version.ID] = &cp
	return nil
}

func (r *inMemoryMLRepo) GetModelVersion(ctx context.Context, versionID string) (*models.MLModelVersion, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	mv, ok := r.modelVersions[versionID]
	if !ok {
		return nil, nil
	}
	cp := *mv
	return &cp, nil
}

func (r *inMemoryMLRepo) GetChampionModel(ctx context.Context, taskType string) (*models.MLModelVersion, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for _, mv := range r.modelVersions {
		if mv.TaskType == taskType && mv.Status == ModelStatusChampion {
			cp := *mv
			return &cp, nil
		}
	}
	return nil, nil
}

func (r *inMemoryMLRepo) CreateEvalRun(ctx context.Context, eval *models.MLEvalRun) error {
	if eval == nil {
		return errors.New("eval run is nil")
	}
	return nil
}

func (r *inMemoryMLRepo) CreateDeployment(ctx context.Context, deployment *models.MLDeployment) error {
	if deployment == nil {
		return errors.New("deployment is nil")
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	cp := *deployment
	r.deployments[deployment.ID] = &cp
	return nil
}

func (r *inMemoryMLRepo) GetActiveModel(ctx context.Context, taskType string) (*models.MLActiveModel, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	am, ok := r.activeModels[taskType]
	if !ok {
		return nil, nil
	}
	cp := *am
	return &cp, nil
}

func (r *inMemoryMLRepo) SetActiveModel(ctx context.Context, taskType string, activeModel *models.MLActiveModel) error {
	if activeModel == nil {
		return errors.New("active model is nil")
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	cp := *activeModel
	r.activeModels[taskType] = &cp
	return nil
}

func (r *inMemoryMLRepo) ListModelVersions(ctx context.Context, taskType, statusFilter string, limit int) ([]models.MLModelVersion, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	out := make([]models.MLModelVersion, 0, limit)
	for _, mv := range r.modelVersions {
		if mv.TaskType != taskType {
			continue
		}
		if statusFilter != "" && mv.Status != statusFilter {
			continue
		}
		out = append(out, *mv)
		if limit > 0 && len(out) >= limit {
			break
		}
	}
	return out, nil
}

func (r *inMemoryMLRepo) RecordAuditEvent(ctx context.Context, event *models.MLAuditEvent) error {
	if event == nil {
		return errors.New("audit event is nil")
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	r.auditEvents = append(r.auditEvents, event)
	return nil
}

func (r *inMemoryMLRepo) seedPredictionLogs(taskType string, count int) {
	r.mu.Lock()
	defer r.mu.Unlock()
	for i := 0; i < count; i++ {
		pid := fmt.Sprintf("pred_%d", i)
		r.predictionLogs[pid] = &models.MLPredictionLog{
			ID:           fmt.Sprintf("log_%d", i),
			PredictionID: pid,
			SiteID:       "site_a",
			TaskType:     taskType,
			CreatedAt:    time.Now(),
		}
	}
}

type flakyRepo struct {
	*repository.MockMLTrainingRepository
	base      *inMemoryMLRepo
	seededRng *rand.Rand
	mu        sync.Mutex
	rate      map[string]float64
}

func newFlakyRepo(seed int64) *flakyRepo {
	return &flakyRepo{
		MockMLTrainingRepository: &repository.MockMLTrainingRepository{},
		base:                     newInMemoryMLRepo(),
		seededRng:                rand.New(rand.NewSource(seed)),
		rate:                     make(map[string]float64),
	}
}

func (f *flakyRepo) setFailureRate(operation string, rate float64) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.rate[operation] = rate
}

func (f *flakyRepo) shouldFail(operation string) bool {
	f.mu.Lock()
	defer f.mu.Unlock()
	r, ok := f.rate[operation]
	if !ok || r <= 0 {
		return false
	}
	if r >= 1 {
		return true
	}
	return f.seededRng.Float64() < r
}

func (f *flakyRepo) GetPredictionLog(ctx context.Context, predictionID string) (*models.MLPredictionLog, error) {
	if f.shouldFail("GetPredictionLog") {
		return nil, errors.New("simulated prediction-log outage")
	}
	return f.base.GetPredictionLog(ctx, predictionID)
}

func (f *flakyRepo) SubmitFeedback(ctx context.Context, feedback *models.MLFeedbackLabel) (string, error) {
	if f.shouldFail("SubmitFeedback") {
		return "", errors.New("simulated feedback write failure")
	}
	return f.base.SubmitFeedback(ctx, feedback)
}

func (f *flakyRepo) CreateTrainingRun(ctx context.Context, run *models.MLTrainingRun) error {
	if f.shouldFail("CreateTrainingRun") {
		return errors.New("simulated training run create failure")
	}
	return f.base.CreateTrainingRun(ctx, run)
}

func (f *flakyRepo) GetTrainingRun(ctx context.Context, trainingRunID string) (*models.MLTrainingRun, error) {
	if f.shouldFail("GetTrainingRun") {
		return nil, errors.New("simulated training status read failure")
	}
	return f.base.GetTrainingRun(ctx, trainingRunID)
}

func (f *flakyRepo) GetModelVersion(ctx context.Context, versionID string) (*models.MLModelVersion, error) {
	if f.shouldFail("GetModelVersion") {
		return nil, errors.New("simulated artifact/model registry outage")
	}
	return f.base.GetModelVersion(ctx, versionID)
}

func (f *flakyRepo) GetChampionModel(ctx context.Context, taskType string) (*models.MLModelVersion, error) {
	if f.shouldFail("GetChampionModel") {
		return nil, errors.New("simulated champion lookup failure")
	}
	return f.base.GetChampionModel(ctx, taskType)
}

func (f *flakyRepo) CreateEvalRun(ctx context.Context, eval *models.MLEvalRun) error {
	if f.shouldFail("CreateEvalRun") {
		return errors.New("simulated eval creation failure")
	}
	return f.base.CreateEvalRun(ctx, eval)
}

func (f *flakyRepo) CreateDeployment(ctx context.Context, deployment *models.MLDeployment) error {
	if f.shouldFail("CreateDeployment") {
		return errors.New("simulated deployment write failure")
	}
	return f.base.CreateDeployment(ctx, deployment)
}

func (f *flakyRepo) GetActiveModel(ctx context.Context, taskType string) (*models.MLActiveModel, error) {
	if f.shouldFail("GetActiveModel") {
		return nil, errors.New("simulated active-model read failure")
	}
	return f.base.GetActiveModel(ctx, taskType)
}

func (f *flakyRepo) SetActiveModel(ctx context.Context, taskType string, activeModel *models.MLActiveModel) error {
	if f.shouldFail("SetActiveModel") {
		return errors.New("simulated active-model write failure")
	}
	return f.base.SetActiveModel(ctx, taskType, activeModel)
}

func (f *flakyRepo) ListModelVersions(ctx context.Context, taskType, statusFilter string, limit int) ([]models.MLModelVersion, error) {
	if f.shouldFail("ListModelVersions") {
		return nil, errors.New("simulated list models failure")
	}
	return f.base.ListModelVersions(ctx, taskType, statusFilter, limit)
}

func (f *flakyRepo) RecordAuditEvent(ctx context.Context, event *models.MLAuditEvent) error {
	if f.shouldFail("RecordAuditEvent") {
		return errors.New("simulated audit write failure")
	}
	return f.base.RecordAuditEvent(ctx, event)
}

func (f *flakyRepo) LogPrediction(ctx context.Context, log *models.MLPredictionLog) error {
	if f.shouldFail("LogPrediction") {
		return errors.New("simulated prediction log write failure")
	}
	if log == nil {
		return errors.New("prediction log is nil")
	}
	f.base.mu.Lock()
	defer f.base.mu.Unlock()
	cp := *log
	f.base.predictionLogs[log.PredictionID] = &cp
	return nil
}

func nullableString(v string) sql.NullString {
	if v == "" {
		return sql.NullString{}
	}
	return sql.NullString{String: v, Valid: true}
}
