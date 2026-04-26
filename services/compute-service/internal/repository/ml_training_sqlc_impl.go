package repository

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"

	computeDb "p9e.in/samavaya/solar3d/compute-service/internal/db"
	"p9e.in/samavaya/solar3d/compute-service/internal/models"
)

type SQLCMLTrainingRepository struct {
	pool    *pgxpool.Pool
	queries *computeDb.Queries
}

func NewSQLCMLTrainingRepository(pool *pgxpool.Pool) *SQLCMLTrainingRepository {
	return &SQLCMLTrainingRepository{
		pool:    pool,
		queries: computeDb.New(pool),
	}
}

func (r *SQLCMLTrainingRepository) SubmitFeedback(ctx context.Context, feedback *models.MLFeedbackLabel) (string, error) {
	predictionLogID, err := parseUUID(feedback.PredictionLogID)
	if err != nil {
		return "", fmt.Errorf("invalid prediction log id: %w", err)
	}

	return r.queries.SubmitFeedback(ctx, computeDb.SubmitFeedbackParams{
		Column1:     predictionLogID,
		ActualLabel: feedback.ActualLabel,
		LabelType:   feedback.LabelType,
		SubmittedBy: nilIfEmpty(feedback.SubmittedBy),
		Notes:       nilIfEmpty(feedback.Notes),
	})
}

func (r *SQLCMLTrainingRepository) GetPredictionLog(ctx context.Context, predictionID string) (*models.MLPredictionLog, error) {
	row, err := r.queries.GetPredictionLog(ctx, predictionID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}

	inputFeatures, err := parseJSONObject(row.InputFeatures)
	if err != nil {
		return nil, fmt.Errorf("parse prediction input features: %w", err)
	}

	return &models.MLPredictionLog{
		ID:                row.ID,
		PredictionID:      row.PredictionID,
		SiteID:            row.SiteID,
		TaskType:          row.TaskType,
		ModelVersionID:    row.ModelVersionID,
		InputFeatures:     inputFeatures,
		PredictedValue:    derefFloat(row.PredictedValue),
		PredictedLower:    toNullFloat64(row.PredictedLower),
		PredictedUpper:    toNullFloat64(row.PredictedUpper),
		Confidence:        toNullFloat64(row.Confidence),
		FeatureSchemaHash: row.FeatureSchemaHash,
		CreatedAt:         row.CreatedAt.Time,
	}, nil
}

func (r *SQLCMLTrainingRepository) LogPrediction(ctx context.Context, logEntry *models.MLPredictionLog) error {
	siteID, err := parseUUID(logEntry.SiteID)
	if err != nil {
		return fmt.Errorf("invalid site id: %w", err)
	}
	inputFeatures, err := marshalJSON(logEntry.InputFeatures)
	if err != nil {
		return err
	}

	return r.queries.LogPrediction(ctx, computeDb.LogPredictionParams{
		PredictionID:      logEntry.PredictionID,
		SiteID:            siteID,
		TaskType:          logEntry.TaskType,
		ModelVersionID:    logEntry.ModelVersionID,
		Column5:           inputFeatures,
		PredictedValue:    floatPointer(logEntry.PredictedValue),
		PredictedLower:    nullFloatPointer(logEntry.PredictedLower),
		PredictedUpper:    nullFloatPointer(logEntry.PredictedUpper),
		Confidence:        nullFloatPointer(logEntry.Confidence),
		FeatureSchemaHash: logEntry.FeatureSchemaHash,
	})
}

func (r *SQLCMLTrainingRepository) CreateTrainingRun(ctx context.Context, run *models.MLTrainingRun) error {
	datasetID, err := r.ensureDatasetID(ctx, run)
	if err != nil {
		return err
	}
	configJSON, err := marshalJSON(run.Config)
	if err != nil {
		return err
	}
	hyperparamsJSON, err := marshalJSON(run.Hyperparams)
	if err != nil {
		return err
	}

	return r.queries.CreateTrainingRun(ctx, computeDb.CreateTrainingRunParams{
		ID:           run.ID,
		TaskType:     run.TaskType,
		Status:       run.Status,
		Column4:      datasetID,
		Column5:      configJSON,
		Column6:      hyperparamsJSON,
		TriggeredBy:  nilIfEmpty(run.TriggeredBy),
		CommitHash:   nilIfEmpty(run.CommitHash),
		ArtifactPath: nilIfEmpty(run.ArtifactPath),
		ArtifactHash: nilIfEmpty(run.ArtifactHash),
	})
}

func (r *SQLCMLTrainingRepository) GetTrainingRun(ctx context.Context, trainingRunID string) (*models.MLTrainingRun, error) {
	row, err := r.queries.GetTrainingRun(ctx, trainingRunID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return trainingRunFromGetRow(row)
}

func (r *SQLCMLTrainingRepository) UpdateTrainingRunStatus(ctx context.Context, trainingRunID, status string) error {
	return r.queries.UpdateTrainingRunStatus(ctx, computeDb.UpdateTrainingRunStatusParams{ID: trainingRunID, Status: status, ErrorMessage: nil})
}

func (r *SQLCMLTrainingRepository) UpdateTrainingRunMetrics(ctx context.Context, trainingRunID string, metrics map[string]interface{}) error {
	metricsJSON, err := marshalJSON(metrics)
	if err != nil {
		return err
	}
	return r.queries.UpdateTrainingRunMetrics(ctx, computeDb.UpdateTrainingRunMetricsParams{ID: trainingRunID, Column2: metricsJSON, Status: "running"})
}

func (r *SQLCMLTrainingRepository) ListTrainingRuns(ctx context.Context, taskType string, limit int) ([]models.MLTrainingRun, error) {
	rows, err := r.queries.ListTrainingRuns(ctx, computeDb.ListTrainingRunsParams{TaskType: taskType, Limit: int32(limit)})
	if err != nil {
		return nil, err
	}
	runs := make([]models.MLTrainingRun, 0, len(rows))
	for _, row := range rows {
		run, err := trainingRunFromListRow(row)
		if err != nil {
			return nil, err
		}
		runs = append(runs, *run)
	}
	return runs, nil
}

func (r *SQLCMLTrainingRepository) CreateModelVersion(ctx context.Context, version *models.MLModelVersion) error {
	metricsJSON, err := marshalJSON(version.Metrics)
	if err != nil {
		return err
	}
	metadataJSON, err := marshalJSON(version.Metadata)
	if err != nil {
		return err
	}
	return r.queries.CreateModelVersion(ctx, computeDb.CreateModelVersionParams{
		ID:                version.ID,
		TaskType:          version.TaskType,
		TrainingRunID:     version.TrainingRunID,
		Status:            version.Status,
		ArtifactPath:      version.ArtifactPath,
		ArtifactHash:      version.ArtifactHash,
		FeatureSchemaHash: version.FeatureSchemaHash,
		Column8:           metricsJSON,
		Column9:           metadataJSON,
	})
}

func (r *SQLCMLTrainingRepository) GetModelVersion(ctx context.Context, versionID string) (*models.MLModelVersion, error) {
	row, err := r.queries.GetModelVersion(ctx, versionID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return modelVersionFromRow(row.ID, row.TaskType, row.TrainingRunID, row.Status, row.ArtifactPath, row.ArtifactHash, row.FeatureSchemaHash, row.Metrics, row.Metadata, row.CreatedAt, row.ArchivedAt)
}

func (r *SQLCMLTrainingRepository) UpdateModelVersionStatus(ctx context.Context, versionID, status string) error {
	return r.queries.UpdateModelVersionStatus(ctx, computeDb.UpdateModelVersionStatusParams{ID: versionID, Status: status})
}

func (r *SQLCMLTrainingRepository) ListModelVersions(ctx context.Context, taskType, statusFilter string, limit int) ([]models.MLModelVersion, error) {
	rows, err := r.queries.ListModelVersions(ctx, computeDb.ListModelVersionsParams{TaskType: taskType, Column2: statusFilter, Limit: int32(limit)})
	if err != nil {
		return nil, err
	}
	versions := make([]models.MLModelVersion, 0, len(rows))
	for _, row := range rows {
		version, err := modelVersionFromRow(row.ID, row.TaskType, row.TrainingRunID, row.Status, row.ArtifactPath, row.ArtifactHash, row.FeatureSchemaHash, row.Metrics, row.Metadata, row.CreatedAt, row.ArchivedAt)
		if err != nil {
			return nil, err
		}
		versions = append(versions, *version)
	}
	return versions, nil
}

func (r *SQLCMLTrainingRepository) GetLatestCandidateModel(ctx context.Context, taskType string) (*models.MLModelVersion, error) {
	row, err := r.queries.GetLatestCandidateModel(ctx, taskType)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return modelVersionFromRow(row.ID, row.TaskType, row.TrainingRunID, row.Status, row.ArtifactPath, row.ArtifactHash, row.FeatureSchemaHash, row.Metrics, row.Metadata, row.CreatedAt, row.ArchivedAt)
}

func (r *SQLCMLTrainingRepository) GetChampionModel(ctx context.Context, taskType string) (*models.MLModelVersion, error) {
	row, err := r.queries.GetChampionModel(ctx, taskType)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return modelVersionFromRow(row.ID, row.TaskType, row.TrainingRunID, row.Status, row.ArtifactPath, row.ArtifactHash, row.FeatureSchemaHash, row.MMetrics, row.MMetadata, row.CreatedAt, row.ArchivedAt)
}

func (r *SQLCMLTrainingRepository) CreateDeployment(ctx context.Context, deployment *models.MLDeployment) error {
	policyJSON, err := marshalJSON(deployment.Policy)
	if err != nil {
		return err
	}
	trafficPercent := int16(deployment.TrafficPercent)
	return r.queries.CreateDeployment(ctx, computeDb.CreateDeploymentParams{
		ID:             deployment.ID,
		ModelVersionID: deployment.ModelVersionID,
		Status:         deployment.Status,
		DeployedBy:     deployment.DeployedBy,
		ApprovalID:     nilIfEmpty(deployment.ApprovalID),
		Column6:        policyJSON,
		TrafficPercent: &trafficPercent,
	})
}

func (r *SQLCMLTrainingRepository) GetDeployment(ctx context.Context, deploymentID string) (*models.MLDeployment, error) {
	row, err := r.queries.GetDeployment(ctx, deploymentID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	policy, err := parseJSONObject(row.Policy)
	if err != nil {
		return nil, fmt.Errorf("parse deployment policy: %w", err)
	}
	return &models.MLDeployment{
		ID:                  row.ID,
		ModelVersionID:      row.ModelVersionID,
		Status:              row.Status,
		DeployedBy:          row.DeployedBy,
		ApprovalID:          derefString(row.ApprovalID),
		Policy:              policy,
		TrafficPercent:      int(derefInt16(row.TrafficPercent)),
		CanaryStartedAt:     toNullTime(row.CanaryStartedAt),
		PromotedToActiveAt:  toNullTime(row.PromotedToActiveAt),
		DeployedAt:          row.DeployedAt.Time,
		RolledBackAt:        toNullTime(row.RolledBackAt),
		RollbackReason:      derefString(row.RollbackReason),
		RollbackTriggeredBy: derefString(row.RollbackTriggeredBy),
		Notes:               derefString(row.Notes),
	}, nil
}

func (r *SQLCMLTrainingRepository) UpdateDeploymentStatus(ctx context.Context, deploymentID, status string) error {
	return r.queries.UpdateDeploymentStatus(ctx, computeDb.UpdateDeploymentStatusParams{ID: deploymentID, Status: status})
}

func (r *SQLCMLTrainingRepository) PromoteDeploymentToActive(ctx context.Context, deploymentID string) error {
	return r.UpdateDeploymentStatus(ctx, deploymentID, "active")
}

func (r *SQLCMLTrainingRepository) GetActiveModel(ctx context.Context, taskType string) (*models.MLActiveModel, error) {
	row, err := r.queries.GetActiveModel(ctx, taskType)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return &models.MLActiveModel{
		ID:              row.ID,
		TaskType:        row.TaskType,
		CurrentModelID:  row.CurrentModelID,
		PreviousModelID: toNullString(row.PreviousModelID),
		PromotedAt:      row.PromotedAt.Time,
		DeploymentID:    toNullString(row.DeploymentID),
	}, nil
}

func (r *SQLCMLTrainingRepository) SetActiveModel(ctx context.Context, taskType string, activeModel *models.MLActiveModel) error {
	return r.queries.SetActiveModel(ctx, computeDb.SetActiveModelParams{
		ID:              activeModel.ID,
		TaskType:        taskType,
		CurrentModelID:  activeModel.CurrentModelID,
		PreviousModelID: nullableString(activeModel.PreviousModelID),
		DeploymentID:    nullableString(activeModel.DeploymentID),
	})
}

func (r *SQLCMLTrainingRepository) GetFeatureSchema(ctx context.Context, schemaHash string) (*models.MLFeatureSchema, error) {
	row, err := r.queries.GetFeatureSchema(ctx, schemaHash)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	normalizationParams, err := parseJSONObject(row.NormalizationParams)
	if err != nil {
		return nil, err
	}
	return &models.MLFeatureSchema{
		ID:                  row.ID,
		TaskType:            row.TaskType,
		Version:             int(row.Version),
		FeatureNames:        row.FeatureNames,
		FeatureDtypes:       row.FeatureDtypes,
		NormalizationParams: normalizationParams,
		CreatedAt:           row.CreatedAt.Time,
	}, nil
}

func (r *SQLCMLTrainingRepository) CreateFeatureSchema(ctx context.Context, schema *models.MLFeatureSchema) error {
	normalizationJSON, err := marshalJSON(schema.NormalizationParams)
	if err != nil {
		return err
	}
	return r.queries.CreateFeatureSchema(ctx, computeDb.CreateFeatureSchemaParams{
		ID:            schema.ID,
		TaskType:      schema.TaskType,
		Version:       int32(schema.Version),
		FeatureNames:  schema.FeatureNames,
		FeatureDtypes: schema.FeatureDtypes,
		Column6:       normalizationJSON,
	})
}

func (r *SQLCMLTrainingRepository) CreateEvalRun(ctx context.Context, eval *models.MLEvalRun) error {
	return r.queries.CreateEvalRun(ctx, computeDb.CreateEvalRunParams{
		ID:               eval.ID,
		CandidateModelID: eval.CandidateModelID,
		ChampionModelID:  nullableString(eval.ChampionModelID),
		Status:           eval.Status,
		DatasetSplit:     eval.DatasetSplit,
	})
}

func (r *SQLCMLTrainingRepository) GetEvalRun(ctx context.Context, evalID string) (*models.MLEvalRun, error) {
	row, err := r.queries.GetEvalRun(ctx, evalID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	metrics, err := parseJSONObject(row.Metrics)
	if err != nil {
		return nil, err
	}
	return &models.MLEvalRun{
		ID:               row.ID,
		CandidateModelID: row.CandidateModelID,
		ChampionModelID:  toNullString(row.ChampionModelID),
		Status:           row.Status,
		DatasetSplit:     row.DatasetSplit,
		Metrics:          metrics,
		CandidateWins:    toNullBool(row.CandidateWins),
		Recommendation:   derefString(row.Recommendation),
		CompletedAt:      toNullTime(row.CompletedAt),
		CreatedAt:        row.CreatedAt.Time,
	}, nil
}

func (r *SQLCMLTrainingRepository) UpdateEvalRunResults(ctx context.Context, evalID string, metrics map[string]interface{}, candidateWins bool, recommendation string) error {
	metricsJSON, err := marshalJSON(metrics)
	if err != nil {
		return err
	}
	return r.queries.UpdateEvalRunResults(ctx, computeDb.UpdateEvalRunResultsParams{
		ID:             evalID,
		Status:         "completed",
		Column3:        metricsJSON,
		CandidateWins:  &candidateWins,
		Recommendation: nilIfEmpty(recommendation),
	})
}

func (r *SQLCMLTrainingRepository) RecordMonitoringMetric(ctx context.Context, metric *models.MLMonitoringMetric) error {
	driftDetected := metric.DriftDetected
	return r.queries.RecordMonitoringMetric(ctx, computeDb.RecordMonitoringMetricParams{
		ModelVersionID: metric.ModelVersionID,
		MetricType:     metric.MetricType,
		MetricValue:    metric.MetricValue,
		WindowStart:    pgtype.Timestamptz{Time: metric.WindowStart, Valid: true},
		WindowEnd:      pgtype.Timestamptz{Time: metric.WindowEnd, Valid: true},
		DriftDetected:  &driftDetected,
	})
}

func (r *SQLCMLTrainingRepository) GetRecentMonitoringMetrics(ctx context.Context, modelVersionID string, metricType string, limitHours int) ([]models.MLMonitoringMetric, error) {
	rows, err := r.queries.GetRecentMonitoringMetrics(ctx, computeDb.GetRecentMonitoringMetricsParams{ModelVersionID: modelVersionID, MetricType: metricType, Column3: limitHours})
	if err != nil {
		return nil, err
	}
	metrics := make([]models.MLMonitoringMetric, 0, len(rows))
	for _, row := range rows {
		metrics = append(metrics, models.MLMonitoringMetric{
			ID:             row.ID,
			ModelVersionID: row.ModelVersionID,
			MetricType:     row.MetricType,
			MetricValue:    row.MetricValue,
			WindowStart:    row.WindowStart.Time,
			WindowEnd:      row.WindowEnd.Time,
			DriftDetected:  derefBool(row.DriftDetected),
			AlertSent:      derefBool(row.AlertSent),
			CreatedAt:      row.CreatedAt.Time,
		})
	}
	return metrics, nil
}

func (r *SQLCMLTrainingRepository) RecordFeatureDrift(ctx context.Context, drift *models.MLFeatureDriftStat) error {
	return r.queries.RecordFeatureDrift(ctx, computeDb.RecordFeatureDriftParams{
		ModelVersionID: drift.ModelVersionID,
		FeatureName:    drift.FeatureName,
		DriftDetector:  drift.DriftDetector,
		DriftScore:     nullFloatPointer(drift.DriftScore),
		PValue:         nullFloatPointer(drift.PValue),
		DriftDetected:  nullBoolPointer(drift.DriftDetected),
		WindowStart:    pgtype.Timestamptz{Time: drift.WindowStart, Valid: true},
		WindowEnd:      pgtype.Timestamptz{Time: drift.WindowEnd, Valid: true},
	})
}

func (r *SQLCMLTrainingRepository) GetFeatureDriftStats(ctx context.Context, modelVersionID string, limitDays int) ([]models.MLFeatureDriftStat, error) {
	rows, err := r.queries.GetFeatureDriftStats(ctx, computeDb.GetFeatureDriftStatsParams{ModelVersionID: modelVersionID, Column2: limitDays})
	if err != nil {
		return nil, err
	}
	stats := make([]models.MLFeatureDriftStat, 0, len(rows))
	for _, row := range rows {
		stats = append(stats, models.MLFeatureDriftStat{
			ID:             row.ID,
			ModelVersionID: row.ModelVersionID,
			FeatureName:    row.FeatureName,
			DriftDetector:  row.DriftDetector,
			DriftScore:     toNullFloat64(row.DriftScore),
			PValue:         toNullFloat64(row.PValue),
			DriftDetected:  toNullBool(row.DriftDetected),
			WindowStart:    row.WindowStart.Time,
			WindowEnd:      row.WindowEnd.Time,
			CreatedAt:      row.CreatedAt.Time,
		})
	}
	return stats, nil
}

func (r *SQLCMLTrainingRepository) RecordAuditEvent(ctx context.Context, event *models.MLAuditEvent) error {
	changesJSON, err := marshalJSON(event.Changes)
	if err != nil {
		return err
	}
	return r.queries.RecordAuditEvent(ctx, computeDb.RecordAuditEventParams{
		EventType:    event.EventType,
		ResourceType: event.ResourceType,
		ResourceID:   event.ResourceID,
		Actor:        nilIfEmpty(event.Actor),
		ActorIp:      nilIfEmpty(event.ActorIP),
		Column6:      changesJSON,
	})
}

func (r *SQLCMLTrainingRepository) GetAuditEvents(ctx context.Context, resourceType, resourceID string, limit int) ([]models.MLAuditEvent, error) {
	rows, err := r.queries.GetAuditEvents(ctx, computeDb.GetAuditEventsParams{ResourceType: resourceType, ResourceID: resourceID, Limit: int32(limit)})
	if err != nil {
		return nil, err
	}
	events := make([]models.MLAuditEvent, 0, len(rows))
	for _, row := range rows {
		changes, err := parseJSONObject(row.Changes)
		if err != nil {
			return nil, err
		}
		events = append(events, models.MLAuditEvent{
			ID:           row.ID,
			EventType:    row.EventType,
			ResourceType: row.ResourceType,
			ResourceID:   row.ResourceID,
			Actor:        derefString(row.Actor),
			ActorIP:      derefString(row.ActorIp),
			Changes:      changes,
			CreatedAt:    row.CreatedAt.Time,
		})
	}
	return events, nil
}

func (r *SQLCMLTrainingRepository) GetTrainingDataset(ctx context.Context, trainingRunID string) ([]map[string]interface{}, error) {
	rows, err := r.queries.GetTrainingDataset(ctx, computeDb.GetTrainingDatasetParams{ID: trainingRunID, SplitSet: "train"})
	if err != nil {
		return nil, err
	}
	dataset := make([]map[string]interface{}, 0, len(rows))
	for _, row := range rows {
		features, err := parseJSONObject(row.Features)
		if err != nil {
			return nil, err
		}
		features["label"] = row.Label
		dataset = append(dataset, features)
	}
	return dataset, nil
}

func (r *SQLCMLTrainingRepository) ArchiveOldModels(ctx context.Context, taskType string, keepDays int) (int, error) {
	rows, err := r.queries.ArchiveOldModels(ctx, computeDb.ArchiveOldModelsParams{TaskType: taskType, Column2: keepDays})
	if err != nil {
		return 0, err
	}
	return len(rows), nil
}

func (r *SQLCMLTrainingRepository) ensureDatasetID(ctx context.Context, run *models.MLTrainingRun) (pgtype.UUID, error) {
	if strings.TrimSpace(run.DatasetID) != "" {
		return parseUUID(run.DatasetID)
	}
	metadataJSON, err := marshalJSON(map[string]any{
		"auto_created":    true,
		"training_run_id": run.ID,
		"task_type":       run.TaskType,
	})
	if err != nil {
		return pgtype.UUID{}, err
	}
	var datasetID string
	query := `
		INSERT INTO ml_datasets (name, task_type, source_type, metadata)
		VALUES ($1, $2, $3, $4::jsonb)
		RETURNING id::text`
	if err := r.pool.QueryRow(ctx, query, fmt.Sprintf("auto-%s-%s", run.TaskType, run.ID), run.TaskType, "feedbacks", metadataJSON).Scan(&datasetID); err != nil {
		return pgtype.UUID{}, fmt.Errorf("create training dataset: %w", err)
	}
	run.DatasetID = datasetID
	return parseUUID(datasetID)
}

func trainingRunFromGetRow(row computeDb.GetTrainingRunRow) (*models.MLTrainingRun, error) {
	config, err := parseJSONObject(row.Config)
	if err != nil {
		return nil, err
	}
	hyperparams, err := parseJSONObject(row.Hyperparams)
	if err != nil {
		return nil, err
	}
	metrics, err := parseJSONObject(row.Metrics)
	if err != nil {
		return nil, err
	}
	return &models.MLTrainingRun{
		ID:           row.ID,
		TaskType:     row.TaskType,
		Status:       row.Status,
		DatasetID:    row.DatasetID,
		Config:       config,
		Hyperparams:  hyperparams,
		Metrics:      metrics,
		ErrorMessage: derefString(row.ErrorMessage),
		TriggeredBy:  derefString(row.TriggeredBy),
		CommitHash:   derefString(row.CommitHash),
		ArtifactPath: derefString(row.ArtifactPath),
		ArtifactHash: derefString(row.ArtifactHash),
		StartedAt:    toNullTime(row.StartedAt),
		CompletedAt:  toNullTime(row.CompletedAt),
		CreatedAt:    row.CreatedAt.Time,
	}, nil
}

func trainingRunFromListRow(row computeDb.ListTrainingRunsRow) (*models.MLTrainingRun, error) {
	config, err := parseJSONObject(row.Config)
	if err != nil {
		return nil, err
	}
	hyperparams, err := parseJSONObject(row.Hyperparams)
	if err != nil {
		return nil, err
	}
	metrics, err := parseJSONObject(row.Metrics)
	if err != nil {
		return nil, err
	}
	return &models.MLTrainingRun{
		ID:           row.ID,
		TaskType:     row.TaskType,
		Status:       row.Status,
		DatasetID:    row.DatasetID,
		Config:       config,
		Hyperparams:  hyperparams,
		Metrics:      metrics,
		ErrorMessage: derefString(row.ErrorMessage),
		TriggeredBy:  derefString(row.TriggeredBy),
		CommitHash:   derefString(row.CommitHash),
		ArtifactPath: derefString(row.ArtifactPath),
		ArtifactHash: derefString(row.ArtifactHash),
		StartedAt:    toNullTime(row.StartedAt),
		CompletedAt:  toNullTime(row.CompletedAt),
		CreatedAt:    row.CreatedAt.Time,
	}, nil
}

func modelVersionFromRow(id, taskType, trainingRunID, status, artifactPath, artifactHash, featureSchemaHash, metricsRaw, metadataRaw string, createdAt, archivedAt pgtype.Timestamptz) (*models.MLModelVersion, error) {
	metrics, err := parseJSONObject(metricsRaw)
	if err != nil {
		return nil, err
	}
	metadata, err := parseJSONObject(metadataRaw)
	if err != nil {
		return nil, err
	}
	return &models.MLModelVersion{
		ID:                id,
		TaskType:          taskType,
		TrainingRunID:     trainingRunID,
		Status:            status,
		ArtifactPath:      artifactPath,
		ArtifactHash:      artifactHash,
		FeatureSchemaHash: featureSchemaHash,
		Metrics:           metrics,
		Metadata:          metadata,
		CreatedAt:         createdAt.Time,
		ArchivedAt:        toNullTime(archivedAt),
	}, nil
}

func parseUUID(value string) (pgtype.UUID, error) {
	var parsed pgtype.UUID
	if err := parsed.Scan(value); err != nil {
		return pgtype.UUID{}, err
	}
	return parsed, nil
}

func parseJSONObject(raw string) (map[string]interface{}, error) {
	trimmed := strings.TrimSpace(raw)
	if trimmed == "" || trimmed == "null" {
		return map[string]interface{}{}, nil
	}
	var result map[string]interface{}
	if err := json.Unmarshal([]byte(trimmed), &result); err != nil {
		return nil, err
	}
	if result == nil {
		return map[string]interface{}{}, nil
	}
	return result, nil
}

func marshalJSON(value any) ([]byte, error) {
	if value == nil {
		return []byte("{}"), nil
	}
	encoded, err := json.Marshal(value)
	if err != nil {
		return nil, fmt.Errorf("marshal json: %w", err)
	}
	return encoded, nil
}

func nilIfEmpty(value string) *string {
	trimmed := strings.TrimSpace(value)
	if trimmed == "" {
		return nil
	}
	return &trimmed
}

func derefString(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}

func nullableString(value sql.NullString) *string {
	if !value.Valid {
		return nil
	}
	return &value.String
}

func toNullString(value *string) sql.NullString {
	if value == nil {
		return sql.NullString{}
	}
	return sql.NullString{String: *value, Valid: true}
}

func toNullTime(value pgtype.Timestamptz) sql.NullTime {
	if !value.Valid {
		return sql.NullTime{}
	}
	return sql.NullTime{Time: value.Time, Valid: true}
}

func toNullFloat64(value *float64) sql.NullFloat64 {
	if value == nil {
		return sql.NullFloat64{}
	}
	return sql.NullFloat64{Float64: *value, Valid: true}
}

func nullFloatPointer(value sql.NullFloat64) *float64 {
	if !value.Valid {
		return nil
	}
	return &value.Float64
}

func nullBoolPointer(value sql.NullBool) *bool {
	if !value.Valid {
		return nil
	}
	return &value.Bool
}

func toNullBool(value *bool) sql.NullBool {
	if value == nil {
		return sql.NullBool{}
	}
	return sql.NullBool{Bool: *value, Valid: true}
}

func floatPointer(value float64) *float64 {
	return &value
}

func derefFloat(value *float64) float64 {
	if value == nil {
		return 0
	}
	return *value
}

func derefBool(value *bool) bool {
	if value == nil {
		return false
	}
	return *value
}

func derefInt16(value *int16) int16 {
	if value == nil {
		return 0
	}
	return *value
}

