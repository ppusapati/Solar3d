-- ML Learning System Schema
-- Supports model versioning, training tracking, feedback collection, and deployment management

-- ============================================================
-- ML Training Samples & Feedback
-- ============================================================

CREATE TABLE ml_prediction_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prediction_id VARCHAR(255) UNIQUE NOT NULL,
    site_id UUID NOT NULL,
    task_type VARCHAR(50) NOT NULL,
    model_version_id VARCHAR(255) NOT NULL,
    input_features JSONB NOT NULL,
    predicted_value DOUBLE PRECISION,
    predicted_lower DOUBLE PRECISION,
    predicted_upper DOUBLE PRECISION,
    confidence DOUBLE PRECISION,
    feature_schema_hash VARCHAR(64) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_prediction_logs_site_task ON ml_prediction_logs(site_id, task_type);
CREATE INDEX idx_prediction_logs_model ON ml_prediction_logs(model_version_id);
CREATE INDEX idx_prediction_logs_created ON ml_prediction_logs(created_at DESC);

CREATE TABLE ml_feedback_labels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prediction_log_id UUID NOT NULL REFERENCES ml_prediction_logs(id) ON DELETE CASCADE,
    actual_label DOUBLE PRECISION NOT NULL,
    label_type VARCHAR(50) NOT NULL,
    submitted_by VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_feedback_labels_prediction ON ml_feedback_labels(prediction_log_id);
CREATE INDEX idx_feedback_labels_created ON ml_feedback_labels(created_at DESC);

-- ============================================================
-- Training Data & Feature Schemas
-- ============================================================

CREATE TABLE ml_feature_schemas (
    id VARCHAR(64) PRIMARY KEY,
    task_type VARCHAR(50) NOT NULL,
    version INT NOT NULL,
    feature_names TEXT[] NOT NULL,
    feature_dtypes TEXT[] NOT NULL,
    normalization_params JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_task_version UNIQUE(task_type, version)
);

CREATE INDEX idx_feature_schemas_task ON ml_feature_schemas(task_type);

CREATE TABLE ml_datasets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    task_type VARCHAR(50) NOT NULL,
    source_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata JSONB
);

CREATE INDEX idx_datasets_task ON ml_datasets(task_type);

CREATE TABLE ml_training_samples (
    id BIGSERIAL PRIMARY KEY,
    dataset_id UUID NOT NULL REFERENCES ml_datasets(id) ON DELETE CASCADE,
    site_id UUID NOT NULL,
    features JSONB NOT NULL,
    label DOUBLE PRECISION NOT NULL,
    split_set VARCHAR(20) NOT NULL,
    sample_date TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_training_samples_dataset_split ON ml_training_samples(dataset_id, split_set);
CREATE INDEX idx_training_samples_site ON ml_training_samples(site_id);
CREATE INDEX idx_training_samples_date ON ml_training_samples(sample_date DESC);

-- ============================================================
-- Training Runs
-- ============================================================

CREATE TABLE ml_training_runs (
    id VARCHAR(64) PRIMARY KEY,
    task_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    dataset_id UUID NOT NULL REFERENCES ml_datasets(id) ON DELETE CASCADE,
    config JSONB NOT NULL,
    hyperparams JSONB NOT NULL,
    metrics JSONB,
    error_message TEXT,
    triggered_by VARCHAR(255),
    commit_hash VARCHAR(64),
    artifact_path VARCHAR(1024),
    artifact_hash VARCHAR(64),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_training_runs_task_status ON ml_training_runs(task_type, status);
CREATE INDEX idx_training_runs_created ON ml_training_runs(created_at DESC);
CREATE INDEX idx_training_runs_dataset ON ml_training_runs(dataset_id);

-- ============================================================
-- Model Versions
-- ============================================================

CREATE TABLE ml_model_versions (
    id VARCHAR(64) PRIMARY KEY,
    task_type VARCHAR(50) NOT NULL,
    training_run_id VARCHAR(64) NOT NULL REFERENCES ml_training_runs(id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL,
    artifact_path VARCHAR(1024) NOT NULL,
    artifact_hash VARCHAR(64) NOT NULL,
    feature_schema_hash VARCHAR(64) NOT NULL REFERENCES ml_feature_schemas(id) ON DELETE RESTRICT,
    metrics JSONB NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    archived_at TIMESTAMPTZ
);

CREATE INDEX idx_model_versions_task_status ON ml_model_versions(task_type, status);
CREATE INDEX idx_model_versions_training_run ON ml_model_versions(training_run_id);
CREATE INDEX idx_model_versions_created ON ml_model_versions(created_at DESC);

-- ============================================================
-- Model Deployments
-- ============================================================

CREATE TABLE ml_deployments (
    id VARCHAR(64) PRIMARY KEY,
    model_version_id VARCHAR(64) NOT NULL REFERENCES ml_model_versions(id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL,
    deployed_by VARCHAR(255) NOT NULL,
    approval_id VARCHAR(255),
    policy JSONB NOT NULL,
    traffic_percent SMALLINT DEFAULT 100,
    canary_started_at TIMESTAMPTZ,
    promoted_to_active_at TIMESTAMPTZ,
    deployed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    rolled_back_at TIMESTAMPTZ,
    rollback_reason TEXT,
    rollback_triggered_by VARCHAR(255),
    notes TEXT
);

CREATE INDEX idx_deployments_model_status ON ml_deployments(model_version_id, status);
CREATE INDEX idx_deployments_deployed ON ml_deployments(deployed_at DESC);

CREATE TABLE ml_active_models (
    id VARCHAR(64) PRIMARY KEY,
    task_type VARCHAR(50) NOT NULL UNIQUE,
    current_model_id VARCHAR(64) NOT NULL REFERENCES ml_model_versions(id) ON DELETE RESTRICT,
    previous_model_id VARCHAR(64) REFERENCES ml_model_versions(id) ON DELETE SET NULL,
    promoted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deployment_id VARCHAR(64) REFERENCES ml_deployments(id) ON DELETE SET NULL
);

CREATE INDEX idx_active_models_task ON ml_active_models(task_type);

-- ============================================================
-- Model Evaluation Runs
-- ============================================================

CREATE TABLE ml_eval_runs (
    id VARCHAR(64) PRIMARY KEY,
    candidate_model_id VARCHAR(64) NOT NULL REFERENCES ml_model_versions(id) ON DELETE CASCADE,
    champion_model_id VARCHAR(64) REFERENCES ml_model_versions(id) ON DELETE SET NULL,
    status VARCHAR(50) NOT NULL,
    dataset_split VARCHAR(20) NOT NULL,
    metrics JSONB,
    candidate_wins BOOLEAN,
    recommendation TEXT,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_eval_runs_candidate ON ml_eval_runs(candidate_model_id);
CREATE INDEX idx_eval_runs_created ON ml_eval_runs(created_at DESC);

-- ============================================================
-- Model Drift & Monitoring
-- ============================================================

CREATE TABLE ml_monitoring_metrics (
    id BIGSERIAL PRIMARY KEY,
    model_version_id VARCHAR(64) NOT NULL REFERENCES ml_model_versions(id) ON DELETE CASCADE,
    metric_type VARCHAR(50) NOT NULL,
    metric_value DOUBLE PRECISION NOT NULL,
    window_start TIMESTAMPTZ NOT NULL,
    window_end TIMESTAMPTZ NOT NULL,
    drift_detected BOOLEAN DEFAULT FALSE,
    alert_sent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_monitoring_metrics_model_time ON ml_monitoring_metrics(model_version_id, window_end DESC);
CREATE INDEX idx_monitoring_metrics_drift ON ml_monitoring_metrics(drift_detected, created_at DESC);

CREATE TABLE ml_feature_drift_stats (
    id BIGSERIAL PRIMARY KEY,
    model_version_id VARCHAR(64) NOT NULL REFERENCES ml_model_versions(id) ON DELETE CASCADE,
    feature_name VARCHAR(255) NOT NULL,
    drift_detector VARCHAR(50) NOT NULL,
    drift_score DOUBLE PRECISION,
    p_value DOUBLE PRECISION,
    drift_detected BOOLEAN,
    window_start TIMESTAMPTZ NOT NULL,
    window_end TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_feature_drift_model_time ON ml_feature_drift_stats(model_version_id, window_end DESC);
CREATE INDEX idx_feature_drift_detected ON ml_feature_drift_stats(drift_detected);

-- ============================================================
-- Audit Trail
-- ============================================================

CREATE TABLE ml_audit_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type VARCHAR(50) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    resource_id VARCHAR(255) NOT NULL,
    actor VARCHAR(255),
    actor_ip VARCHAR(45),
    changes JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_events_resource ON ml_audit_events(resource_type, resource_id);
CREATE INDEX idx_audit_events_created ON ml_audit_events(created_at DESC);
