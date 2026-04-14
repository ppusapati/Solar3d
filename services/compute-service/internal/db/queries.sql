-- Prediction Logs & Feedback

-- name: LogPrediction :exec
INSERT INTO ml_prediction_logs (
    prediction_id, site_id, task_type, model_version_id, 
    input_features, predicted_value, predicted_lower, predicted_upper, 
    confidence, feature_schema_hash
) VALUES (
    $1, $2, $3, $4, 
    $5::jsonb, $6, $7, $8, 
    $9, $10
);

-- name: GetPredictionLog :one
SELECT id::text, prediction_id, site_id::text, task_type, model_version_id,
       input_features::text, predicted_value, predicted_lower, predicted_upper,
       confidence, feature_schema_hash, created_at
FROM ml_prediction_logs
WHERE prediction_id = $1;

-- name: SubmitFeedback :one
INSERT INTO ml_feedback_labels (
    prediction_log_id, actual_label, label_type, submitted_by, notes
) VALUES (
    $1::uuid, $2, $3, $4, $5
)
RETURNING id::text;

-- ============================================================
-- Training Runs
-- ============================================================

-- name: CreateTrainingRun :exec
INSERT INTO ml_training_runs (
    id, task_type, status, dataset_id, config, hyperparams,
    triggered_by, commit_hash, artifact_path, artifact_hash
) VALUES (
    $1, $2, $3, $4::uuid, $5::jsonb, $6::jsonb,
    $7, $8, $9, $10
);

-- name: GetTrainingRun :one
SELECT id, task_type, status, dataset_id::text, config::text, hyperparams::text,
       metrics::text, error_message, triggered_by, commit_hash,
       artifact_path, artifact_hash, started_at, completed_at, created_at
FROM ml_training_runs
WHERE id = $1;

-- name: UpdateTrainingRunStatus :exec
UPDATE ml_training_runs
SET status = $2, error_message = $3
WHERE id = $1;

-- name: UpdateTrainingRunMetrics :exec
UPDATE ml_training_runs
SET metrics = $2::jsonb, status = $3,
    started_at = COALESCE(started_at, NOW()),
    completed_at = CASE WHEN $3 = 'completed' THEN NOW() ELSE completed_at END
WHERE id = $1;

-- name: UpdateTrainingRunCompleted :exec
UPDATE ml_training_runs
SET status = $2, metrics = $3::jsonb, artifact_path = $4, artifact_hash = $5,
    completed_at = NOW()
WHERE id = $1;

-- name: ListTrainingRuns :many
SELECT id, task_type, status, dataset_id::text, config::text, hyperparams::text,
       metrics::text, error_message, triggered_by, commit_hash,
       artifact_path, artifact_hash, started_at, completed_at, created_at
FROM ml_training_runs
WHERE task_type = $1
ORDER BY created_at DESC
LIMIT $2;

-- ============================================================
-- Model Versions
-- ============================================================

-- name: CreateModelVersion :exec
INSERT INTO ml_model_versions (
    id, task_type, training_run_id, status, artifact_path, artifact_hash,
    feature_schema_hash, metrics, metadata
) VALUES (
    $1, $2, $3, $4, $5, $6,
    $7, $8::jsonb, $9::jsonb
);

-- name: GetModelVersion :one
SELECT id, task_type, training_run_id, status, artifact_path, artifact_hash,
       feature_schema_hash, metrics::text, metadata::text, created_at, archived_at
FROM ml_model_versions
WHERE id = $1;

-- name: UpdateModelVersionStatus :exec
UPDATE ml_model_versions
SET status = $2, archived_at = CASE WHEN $2 = 'archived' THEN NOW() ELSE archived_at END
WHERE id = $1;

-- name: ListModelVersions :many
SELECT id, task_type, training_run_id, status, artifact_path, artifact_hash,
       feature_schema_hash, metrics::text, metadata::text, created_at, archived_at
FROM ml_model_versions
WHERE task_type = $1
  AND ($2::text = '' OR status = $2)
ORDER BY created_at DESC
LIMIT $3;

-- name: GetLatestCandidateModel :one
SELECT id, task_type, training_run_id, status, artifact_path, artifact_hash,
       feature_schema_hash, metrics::text, metadata::text, created_at, archived_at
FROM ml_model_versions
WHERE task_type = $1 AND status = 'candidate'
ORDER BY created_at DESC
LIMIT 1;

-- name: GetChampionModel :one
SELECT m.id, m.task_type, m.training_run_id, m.status, m.artifact_path, 
       m.artifact_hash, m.feature_schema_hash, m.metrics::text, 
       m.metadata::text, m.created_at, m.archived_at
FROM ml_model_versions m
INNER JOIN ml_active_models a ON m.id = a.current_model_id
WHERE a.task_type = $1;

-- ============================================================
-- Deployments
-- ============================================================

-- name: CreateDeployment :exec
INSERT INTO ml_deployments (
    id, model_version_id, status, deployed_by, approval_id, policy, traffic_percent
) VALUES (
    $1, $2, $3, $4, $5, $6::jsonb, $7
);

-- name: GetDeployment :one
SELECT id, model_version_id, status, deployed_by, approval_id, policy::text,
       traffic_percent, canary_started_at, promoted_to_active_at, deployed_at,
       rolled_back_at, rollback_reason, rollback_triggered_by, notes
FROM ml_deployments
WHERE id = $1;

-- name: UpdateDeploymentStatus :exec
UPDATE ml_deployments
SET status = $2,
    promoted_to_active_at = CASE WHEN $2 = 'active' THEN NOW() ELSE promoted_to_active_at END
WHERE id = $1;

-- name: UpdateDeploymentCanary :exec
UPDATE ml_deployments
SET status = $2, canary_started_at = $3, traffic_percent = $4
WHERE id = $1;

-- name: RollbackDeployment :exec
UPDATE ml_deployments
SET status = 'rolled_back', rolled_back_at = NOW(),
    rollback_reason = $2, rollback_triggered_by = $3
WHERE id = $1;

-- ============================================================
-- Active Models
-- ============================================================

-- name: GetActiveModel :one
SELECT id, task_type, current_model_id, previous_model_id, promoted_at, deployment_id
FROM ml_active_models
WHERE task_type = $1;

-- name: SetActiveModel :exec
INSERT INTO ml_active_models (id, task_type, current_model_id, previous_model_id, deployment_id)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (task_type) DO UPDATE SET
    current_model_id = EXCLUDED.current_model_id,
    previous_model_id = EXCLUDED.previous_model_id,
    promoted_at = NOW(),
    deployment_id = EXCLUDED.deployment_id;

-- ============================================================
-- Feature Schemas
-- ============================================================

-- name: GetFeatureSchema :one
SELECT id, task_type, version, feature_names, feature_dtypes, 
       normalization_params::text, created_at
FROM ml_feature_schemas
WHERE id = $1;

-- name: CreateFeatureSchema :exec
INSERT INTO ml_feature_schemas (
    id, task_type, version, feature_names, feature_dtypes, normalization_params
) VALUES (
    $1, $2, $3, $4, $5, $6::jsonb
);

-- ============================================================
-- Evaluation
-- ============================================================

-- name: CreateEvalRun :exec
INSERT INTO ml_eval_runs (
    id, candidate_model_id, champion_model_id, status, dataset_split
) VALUES (
    $1, $2, $3, $4, $5
);

-- name: GetEvalRun :one
SELECT id, candidate_model_id, champion_model_id, status, dataset_split,
       metrics::text, candidate_wins, recommendation, completed_at, created_at
FROM ml_eval_runs
WHERE id = $1;

-- name: UpdateEvalRunResults :exec
UPDATE ml_eval_runs
SET status = $2, metrics = $3::jsonb, candidate_wins = $4,
    recommendation = $5, completed_at = NOW()
WHERE id = $1;

-- ============================================================
-- Monitoring
-- ============================================================

-- name: RecordMonitoringMetric :exec
INSERT INTO ml_monitoring_metrics (
    model_version_id, metric_type, metric_value, window_start, window_end, drift_detected
) VALUES (
    $1, $2, $3, $4, $5, $6
);

-- name: GetRecentMonitoringMetrics :many
SELECT id, model_version_id, metric_type, metric_value, window_start, window_end,
       drift_detected, alert_sent, created_at
FROM ml_monitoring_metrics
WHERE model_version_id = $1
  AND metric_type = $2
  AND window_end > NOW() - INTERVAL '1 hour' * $3
ORDER BY window_end DESC
LIMIT 1000;

-- ============================================================
-- Drift Detection
-- ============================================================

-- name: RecordFeatureDrift :exec
INSERT INTO ml_feature_drift_stats (
    model_version_id, feature_name, drift_detector, drift_score, p_value,
    drift_detected, window_start, window_end
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
);

-- name: GetFeatureDriftStats :many
SELECT id, model_version_id, feature_name, drift_detector, drift_score,
       p_value, drift_detected, window_start, window_end, created_at
FROM ml_feature_drift_stats
WHERE model_version_id = $1
  AND window_start > NOW() - INTERVAL '1 day' * $2
ORDER BY window_end DESC;

-- ============================================================
-- Audit Trail
-- ============================================================

-- name: RecordAuditEvent :exec
INSERT INTO ml_audit_events (
    event_type, resource_type, resource_id, actor, actor_ip, changes
) VALUES (
    $1, $2, $3, $4, $5, $6::jsonb
);

-- name: GetAuditEvents :many
SELECT id::text, event_type, resource_type, resource_id, actor, actor_ip,
       changes::text, created_at
FROM ml_audit_events
WHERE resource_type = $1 AND resource_id = $2
ORDER BY created_at DESC
LIMIT $3;

-- ============================================================
-- Helper Queries
-- ============================================================

-- name: GetTrainingDataset :many
SELECT features::text, label
FROM ml_training_samples
WHERE dataset_id = (
    SELECT ml_training_runs.dataset_id FROM ml_training_runs WHERE ml_training_runs.id = $1
)
AND split_set = $2
ORDER BY created_at;

-- name: CountDatasetSamples :one
SELECT COUNT(*) as count
FROM ml_training_samples
WHERE dataset_id = $1;

-- name: ArchiveOldModels :many
DELETE FROM ml_model_versions
WHERE task_type = $1
  AND status = 'archived'
  AND created_at < NOW() - INTERVAL '1 day' * $2
RETURNING ml_model_versions.id;
