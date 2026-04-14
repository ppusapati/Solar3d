-- ML Learning System Schema
-- Supports model versioning, training tracking, feedback collection, and deployment management

-- ============================================================
-- ML Training Samples & Feedback
-- ============================================================

CREATE TABLE ml_prediction_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prediction_id VARCHAR(255) UNIQUE NOT NULL,
    site_id UUID NOT NULL,
    task_type VARCHAR(50) NOT NULL,  -- "yield", "anomaly", "degradation"
    model_version_id VARCHAR(255) NOT NULL,
    input_features JSONB NOT NULL,
    predicted_value DOUBLE PRECISION,
    predicted_lower DOUBLE PRECISION,
    predicted_upper DOUBLE PRECISION,
    confidence DOUBLE PRECISION,
    feature_schema_hash VARCHAR(64) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_sites FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE
);

CREATE INDEX idx_prediction_logs_site_task ON ml_prediction_logs(site_id, task_type);
CREATE INDEX idx_prediction_logs_model ON ml_prediction_logs(model_version_id);
CREATE INDEX idx_prediction_logs_created ON ml_prediction_logs(created_at DESC);

CREATE TABLE ml_feedback_labels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prediction_log_id UUID NOT NULL,
    actual_label DOUBLE PRECISION NOT NULL,
    label_type VARCHAR(50) NOT NULL,  -- "manual", "system", "inferred"
    submitted_by VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_prediction_logs FOREIGN KEY (prediction_log_id) REFERENCES ml_prediction_logs(id) ON DELETE CASCADE
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
    normalization_params JSONB,  -- means, stds, min, max for each feature
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_task_version UNIQUE(task_type, version)
);

CREATE INDEX idx_feature_schemas_task ON ml_feature_schemas(task_type);

CREATE TABLE ml_datasets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    task_type VARCHAR(50) NOT NULL,
    source_type VARCHAR(50) NOT NULL,  -- "feedbacks", "synthetic", "production_samples"
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata JSONB
);

CREATE INDEX idx_datasets_task ON ml_datasets(task_type);

CREATE TABLE ml_training_samples (
    id BIGSERIAL PRIMARY KEY,
    dataset_id UUID NOT NULL,
    site_id UUID NOT NULL,
    features JSONB NOT NULL,
    label DOUBLE PRECISION NOT NULL,
    split_set VARCHAR(20) NOT NULL,  -- "train", "validation", "test"
    sample_date TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_datasets FOREIGN KEY (dataset_id) REFERENCES ml_datasets(id) ON DELETE CASCADE,
    CONSTRAINT fk_sites_samples FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE
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
    status VARCHAR(50) NOT NULL,  -- "queued", "running", "completed", "failed"
    dataset_id UUID NOT NULL,
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
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_datasets_runs FOREIGN KEY (dataset_id) REFERENCES ml_datasets(id) ON DELETE CASCADE
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
    training_run_id VARCHAR(64) NOT NULL,
    status VARCHAR(50) NOT NULL,  -- "candidate", "champion", "archived", "failed"
    artifact_path VARCHAR(1024) NOT NULL,
    artifact_hash VARCHAR(64) NOT NULL,
    feature_schema_hash VARCHAR(64) NOT NULL,
    metrics JSONB NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    archived_at TIMESTAMPTZ,
    CONSTRAINT fk_training_runs FOREIGN KEY (training_run_id) REFERENCES ml_training_runs(id) ON DELETE CASCADE,
    CONSTRAINT fk_feature_schemas FOREIGN KEY (feature_schema_hash) REFERENCES ml_feature_schemas(id) ON DELETE RESTRICT
);

CREATE INDEX idx_model_versions_task_status ON ml_model_versions(task_type, status);
CREATE INDEX idx_model_versions_training_run ON ml_model_versions(training_run_id);
CREATE INDEX idx_model_versions_created ON ml_model_versions(created_at DESC);

-- ============================================================
-- Model Deployments
-- ============================================================

CREATE TABLE ml_deployments (
    id VARCHAR(64) PRIMARY KEY,
    model_version_id VARCHAR(64) NOT NULL,
    status VARCHAR(50) NOT NULL,  -- "deploying", "canary", "active", "failed", "rolled_back"
    deployed_by VARCHAR(255) NOT NULL,
    approval_id VARCHAR(255),
    policy JSONB NOT NULL,
    traffic_percent SMALLINT DEFAULT 100,  -- 1-100 for canary
    canary_started_at TIMESTAMPTZ,
    promoted_to_active_at TIMESTAMPTZ,
    deployed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    rolled_back_at TIMESTAMPTZ,
    rollback_reason TEXT,
    rollback_triggered_by VARCHAR(255),
    notes TEXT,
    CONSTRAINT fk_model_versions FOREIGN KEY (model_version_id) REFERENCES ml_model_versions(id) ON DELETE CASCADE
);

CREATE INDEX idx_deployments_model_status ON ml_deployments(model_version_id, status);
CREATE INDEX idx_deployments_deployed ON ml_deployments(deployed_at DESC);

CREATE TABLE ml_active_models (
    id VARCHAR(64) PRIMARY KEY,
    task_type VARCHAR(50) NOT NULL UNIQUE,
    current_model_id VARCHAR(64) NOT NULL,
    previous_model_id VARCHAR(64),
    promoted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deployment_id VARCHAR(64),
    CONSTRAINT fk_current_model FOREIGN KEY (current_model_id) REFERENCES ml_model_versions(id) ON DELETE RESTRICT,
    CONSTRAINT fk_previous_model FOREIGN KEY (previous_model_id) REFERENCES ml_model_versions(id) ON DELETE SET NULL,
    CONSTRAINT fk_deployment FOREIGN KEY (deployment_id) REFERENCES ml_deployments(id) ON DELETE SET NULL
);

CREATE INDEX idx_active_models_task ON ml_active_models(task_type);

-- ============================================================
-- Model Evaluation Runs
-- ============================================================

CREATE TABLE ml_eval_runs (
    id VARCHAR(64) PRIMARY KEY,
    candidate_model_id VARCHAR(64) NOT NULL,
    champion_model_id VARCHAR(64),
    status VARCHAR(50) NOT NULL,  -- "running", "completed"
    dataset_split VARCHAR(20) NOT NULL,  -- "validation", "test"
    metrics JSONB,
    candidate_wins BOOLEAN,
    recommendation TEXT,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_candidate FOREIGN KEY (candidate_model_id) REFERENCES ml_model_versions(id) ON DELETE CASCADE,
    CONSTRAINT fk_champion FOREIGN KEY (champion_model_id) REFERENCES ml_model_versions(id) ON DELETE SET NULL
);

CREATE INDEX idx_eval_runs_candidate ON ml_eval_runs(candidate_model_id);
CREATE INDEX idx_eval_runs_created ON ml_eval_runs(created_at DESC);

-- ============================================================
-- Model Drift & Monitoring
-- ============================================================

CREATE TABLE ml_monitoring_metrics (
    id BIGSERIAL PRIMARY KEY,
    model_version_id VARCHAR(64) NOT NULL,
    metric_type VARCHAR(50) NOT NULL,  -- "prediction_count", "mae", "rmse", "coverage"
    metric_value DOUBLE PRECISION NOT NULL,
    window_start TIMESTAMPTZ NOT NULL,
    window_end TIMESTAMPTZ NOT NULL,
    drift_detected BOOLEAN DEFAULT FALSE,
    alert_sent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_model_monitoring FOREIGN KEY (model_version_id) REFERENCES ml_model_versions(id) ON DELETE CASCADE
);

CREATE INDEX idx_monitoring_metrics_model_time ON ml_monitoring_metrics(model_version_id, window_end DESC);
CREATE INDEX idx_monitoring_metrics_drift ON ml_monitoring_metrics(drift_detected, created_at DESC);

CREATE TABLE ml_feature_drift_stats (
    id BIGSERIAL PRIMARY KEY,
    model_version_id VARCHAR(64) NOT NULL,
    feature_name VARCHAR(255) NOT NULL,
    drift_detector VARCHAR(50) NOT NULL,  -- "ks_test", "wasserstein", "psi"
    drift_score DOUBLE PRECISION,
    p_value DOUBLE PRECISION,
    drift_detected BOOLEAN,
    window_start TIMESTAMPTZ NOT NULL,
    window_end TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_model_drift FOREIGN KEY (model_version_id) REFERENCES ml_model_versions(id) ON DELETE CASCADE
);

CREATE INDEX idx_feature_drift_model_time ON ml_feature_drift_stats(model_version_id, window_end DESC);
CREATE INDEX idx_feature_drift_detected ON ml_feature_drift_stats(drift_detected);

-- ============================================================
-- Audit Trail
-- ============================================================

CREATE TABLE ml_audit_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type VARCHAR(50) NOT NULL,  -- "training_start", "training_complete", "deployment", "rollback", etc.
    resource_type VARCHAR(50) NOT NULL,
    resource_id VARCHAR(255) NOT NULL,
    actor VARCHAR(255),
    actor_ip VARCHAR(45),
    changes JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_events_resource ON ml_audit_events(resource_type, resource_id, created_at DESC);
CREATE INDEX idx_audit_events_type ON ml_audit_events(event_type, created_at DESC);

-- ============================================================
-- Lifecycle Policies & Retention
-- ============================================================

CREATE TABLE ml_config (
    key VARCHAR(255) PRIMARY KEY,
    value JSONB NOT NULL,
    version INT NOT NULL DEFAULT 1,
    updated_by VARCHAR(255),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Initial config entries:
-- ml_retraining_policy: {"cadence": "weekly", "min_samples": 1000, "min_improvement_pct": 2}
-- ml_deployment_policy: {"auto_promote": false, "manual_approval": true, "canary_pct": 10}
-- ml_retention_policy: {"keep_archived_days": 90, "keep_feedback_days": 365}

INSERT INTO ml_config VALUES 
  ('ml_retraining_policy', '{"cadence": "weekly", "min_samples": 1000, "min_improvement_pct": 2.0}'::jsonb, 1, 'system', NOW()),
  ('ml_deployment_policy', '{"auto_promote": false, "manual_approval": true, "canary_pct": 10}'::jsonb, 1, 'system', NOW()),
  ('ml_retention_policy', '{"keep_archived_days": 90, "keep_feedback_days": 365}'::jsonb, 1, 'system', NOW())
ON CONFLICT (key) DO NOTHING;

-- ============================================================
-- Utility functions for common queries
-- ============================================================

CREATE OR REPLACE FUNCTION get_latest_candidate_model(p_task_type VARCHAR)
RETURNS VARCHAR AS $$
  SELECT id FROM ml_model_versions
  WHERE task_type = p_task_type AND status = 'candidate'
  ORDER BY created_at DESC
  LIMIT 1;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_active_model(p_task_type VARCHAR)
RETURNS VARCHAR AS $$
  SELECT current_model_id FROM ml_active_models
  WHERE task_type = p_task_type;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION record_ml_audit(
  p_event_type VARCHAR,
  p_resource_type VARCHAR,
  p_resource_id VARCHAR,
  p_actor VARCHAR,
  p_changes JSONB
) RETURNS UUID AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO ml_audit_events (event_type, resource_type, resource_id, actor, changes)
  VALUES (p_event_type, p_resource_type, p_resource_id, p_actor, p_changes)
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$ LANGUAGE plpgsql;
