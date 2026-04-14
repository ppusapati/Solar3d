-- Production-grade orchestration with idempotency, lineage, audit, and lifecycle management

-- ============================================================================
-- SECTION 1: Enhanced Job State & Persistence
-- ============================================================================

-- Add causation tracking and artifact generation metadata to main job table
ALTER TABLE IF EXISTS orchestration_jobs ADD COLUMN IF NOT EXISTS
    parent_job_id UUID REFERENCES orchestration_jobs(id) ON DELETE SET NULL;

ALTER TABLE IF EXISTS orchestration_jobs ADD COLUMN IF NOT EXISTS
    causation_id UUID DEFAULT gen_random_uuid();

ALTER TABLE IF EXISTS orchestration_jobs ADD COLUMN IF NOT EXISTS
    idempotency_key TEXT;

ALTER TABLE IF EXISTS orchestration_jobs ADD COLUMN IF NOT EXISTS
    trace_id UUID DEFAULT gen_random_uuid();

ALTER TABLE IF EXISTS orchestration_jobs ADD COLUMN IF NOT EXISTS
    execution_timeout_seconds INT DEFAULT 3600;

ALTER TABLE IF EXISTS orchestration_jobs ADD COLUMN IF NOT EXISTS
    on_failure_action TEXT DEFAULT 'FAIL'; -- FAIL, RETRY, SKIP, DEADLETTER

-- UNIQUE constraint for idempotent resubmission within a project
CREATE UNIQUE INDEX IF NOT EXISTS idx_orch_jobs_idempotency_atomic
    ON orchestration_jobs (project_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL AND status NOT IN ('DEAD_LETTERED', 'FAILED');

-- Index for parent-child relationships and lineage queries
CREATE INDEX IF NOT EXISTS idx_orch_jobs_parent_id
    ON orchestration_jobs (parent_job_id)
    WHERE parent_job_id IS NOT NULL;

-- Index for causation chain tracing
CREATE INDEX IF NOT EXISTS idx_orch_jobs_causation_id
    ON orchestration_jobs (causation_id);

-- Index for trace correlation
CREATE INDEX IF NOT EXISTS idx_orch_jobs_trace_id
    ON orchestration_jobs (trace_id);

-- ============================================================================
-- SECTION 2: Persistent Job Queue & Retry State Management
-- ============================================================================

-- Queue for jobs waiting to be retried (no elapsed/sleep-based timers)
CREATE TABLE IF NOT EXISTS orchestration_job_queue (
    id BIGSERIAL PRIMARY KEY,
    job_id UUID NOT NULL UNIQUE REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    queue_type TEXT NOT NULL, -- 'READY', 'RETRY_PENDING', 'BLOCKED', 'DEFERRED'
    priority INT NOT NULL DEFAULT 0,
    scheduled_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    available_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    retry_count INT NOT NULL DEFAULT 0,
    backoff_multiplier REAL NOT NULL DEFAULT 1.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orch_queue_type_available
    ON orchestration_job_queue (queue_type, available_at ASC)
    WHERE queue_type IN ('READY', 'RETRY_PENDING');

CREATE INDEX IF NOT EXISTS idx_orch_queue_priority
    ON orchestration_job_queue (priority DESC, available_at ASC);

-- ============================================================================
-- SECTION 3: Idempotency State & Deduplication
-- ============================================================================

-- Rename existing table and enhance it
CREATE TABLE IF NOT EXISTS orchestration_idempotent_calls (
    id BIGSERIAL PRIMARY KEY,
    project_id TEXT NOT NULL,
    idempotency_key TEXT NOT NULL,
    job_id UUID NOT NULL REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    request_hash TEXT NOT NULL, -- SHA256 of full request payload
    response_payload JSONB DEFAULT NULL, -- cached response for replay
    expires_at TIMESTAMPTZ NOT NULL, -- 24h default for idempotency window
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, idempotency_key)
);

CREATE INDEX IF NOT EXISTS idx_orch_idempotent_project_key
    ON orchestration_idempotent_calls (project_id, idempotency_key);

CREATE INDEX IF NOT EXISTS idx_orch_idempotent_expires_at
    ON orchestration_idempotent_calls (expires_at)
    WHERE expires_at IS NOT NULL;

-- ============================================================================
-- SECTION 4: Audit & Authorization Logging
-- ============================================================================

CREATE TABLE IF NOT EXISTS orchestration_audit_log (
    id BIGSERIAL PRIMARY KEY,
    job_id UUID REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    action TEXT NOT NULL, -- SUBMITTED, STARTED, PROGRESSED, SUCCEEDED, FAILED, RETRIED, DEADLETTERED, CANCELED, DEPENDENCY_FAILED
    actor_id TEXT NOT NULL, -- user/service principal ID
    actor_type TEXT NOT NULL, -- USER, SERVICE, SYSTEM
    details JSONB NOT NULL DEFAULT '{}',
    old_state JSONB, -- state before action
    new_state JSONB, -- state after action
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orch_audit_job_id
    ON orchestration_audit_log (job_id, timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_orch_audit_actor_id
    ON orchestration_audit_log (actor_id, timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_orch_audit_action
    ON orchestration_audit_log (action, timestamp DESC);

-- ============================================================================
-- SECTION 5: Artifact Lifecycle & Retention Policy
-- ============================================================================

-- Extend job artifacts table with lifecycle metadata
ALTER TABLE IF EXISTS orchestration_job_artifacts ADD COLUMN IF NOT EXISTS
    artifact_type TEXT DEFAULT 'TRANSIENT'; -- TRANSIENT, RETAINED, ARCHIVED, PUBLISHED

ALTER TABLE IF EXISTS orchestration_job_artifacts ADD COLUMN IF NOT EXISTS
    retention_policy TEXT DEFAULT 'AUTO_DELETE'; -- AUTO_DELETE, RETAIN, ARCHIVE

ALTER TABLE IF EXISTS orchestration_job_artifacts ADD COLUMN IF NOT EXISTS
    expires_at TIMESTAMPTZ;

ALTER TABLE IF EXISTS orchestration_job_artifacts ADD COLUMN IF NOT EXISTS
    archived_at TIMESTAMPTZ;

ALTER TABLE IF EXISTS orchestration_job_artifacts ADD COLUMN IF NOT EXISTS
    lineage_metadata JSONB DEFAULT '{}'::jsonb; -- { "source_jobs": [...], "purpose": "...", "generation_params": {...} }

CREATE INDEX IF NOT EXISTS idx_orch_artifacts_expires_at
    ON orchestration_job_artifacts (expires_at)
    WHERE expires_at IS NOT NULL AND archived_at IS NULL;

-- ============================================================================
-- SECTION 6: Dead Letter Management with Retention
-- ============================================================================

ALTER TABLE IF EXISTS orchestration_dead_letters ADD COLUMN IF NOT EXISTS
    lineage_breadcrumbs JSONB DEFAULT '{}'; -- trace of job IDs leading to dead letter

ALTER TABLE IF EXISTS orchestration_dead_letters ADD COLUMN IF NOT EXISTS
    classification TEXT DEFAULT 'UNKNOWN'; -- TIMEOUT, MAX_RETRIES, EXEC_ERROR, DATA_ERROR, CIRCUIT_BREAKER

ALTER TABLE IF EXISTS orchestration_dead_letters ADD COLUMN IF NOT EXISTS
    retention_expires_at TIMESTAMPTZ;

ALTER TABLE IF EXISTS orchestration_dead_letters ADD COLUMN IF NOT EXISTS
    alert_sent BOOLEAN DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS idx_orch_dead_letters_created
    ON orchestration_dead_letters (created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orch_dead_letters_retention
    ON orchestration_dead_letters (retention_expires_at)
    WHERE retention_expires_at IS NOT NULL;

-- ============================================================================
-- SECTION 7: Job Dependency & DAG Tracking
-- ============================================================================

CREATE TABLE IF NOT EXISTS orchestration_job_dependencies (
    id BIGSERIAL PRIMARY KEY,
    parent_job_id UUID NOT NULL REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    child_job_id UUID NOT NULL REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    dependency_type TEXT NOT NULL DEFAULT 'SEQUENTIAL', -- SEQUENTIAL, PARALLEL, CONDITIONAL
    condition_expression TEXT, -- optional: JSON expression for conditional deps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (parent_job_id, child_job_id)
);

CREATE INDEX IF NOT EXISTS idx_orch_dep_parent
    ON orchestration_job_dependencies (parent_job_id);

CREATE INDEX IF NOT EXISTS idx_orch_dep_child
    ON orchestration_job_dependencies (child_job_id);

-- ============================================================================
-- SECTION 8: Executor Idempotency Tokens for External Service Calls
-- ============================================================================

CREATE TABLE IF NOT EXISTS orchestration_executor_calls (
    id BIGSERIAL PRIMARY KEY,
    job_attempt_id BIGINT NOT NULL REFERENCES orchestration_job_attempts(id) ON DELETE CASCADE,
    executor_name TEXT NOT NULL, -- e.g., "SimulationExecutor", "OptimizationExecutor"
    idempotency_token UUID NOT NULL,
    request_fingerprint TEXT NOT NULL, -- deterministic hash of request
    response_payload JSONB DEFAULT NULL,
    status TEXT NOT NULL DEFAULT 'PENDING', -- PENDING, SUCCEEDED, FAILED
    error_message TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    UNIQUE (job_attempt_id, idempotency_token)
);

CREATE INDEX IF NOT EXISTS idx_orch_executor_idempotency
    ON orchestration_executor_calls (executor_name, idempotency_token);

CREATE INDEX IF NOT EXISTS idx_orch_executor_pending
    ON orchestration_executor_calls (status, created_at)
    WHERE status = 'PENDING';

-- ============================================================================
-- SECTION 9: Lineage & Data Provenance Tracking
-- ============================================================================

CREATE TABLE IF NOT EXISTS orchestration_data_lineage (
    id BIGSERIAL PRIMARY KEY,
    source_job_id UUID REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    derived_job_id UUID REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    data_flow_type TEXT NOT NULL, -- INPUT, OUTPUT, CONFIG, ARTIFACT
    artifact_id BIGINT REFERENCES orchestration_job_artifacts(id) ON DELETE CASCADE,
    transformation_name TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orch_lineage_source
    ON orchestration_data_lineage (source_job_id);

CREATE INDEX IF NOT EXISTS idx_orch_lineage_derived
    ON orchestration_data_lineage (derived_job_id);

-- ============================================================================
-- SECTION 10: Failure Pattern & Circuit Breaker State
-- ============================================================================

CREATE TABLE IF NOT EXISTS orchestration_circuit_breaker_state (
    id BIGSERIAL PRIMARY KEY,
    executor_name TEXT NOT NULL UNIQUE,
    state TEXT NOT NULL DEFAULT 'CLOSED', -- CLOSED, OPEN, HALF_OPEN
    failure_count INT NOT NULL DEFAULT 0,
    last_failure_at TIMESTAMPTZ,
    open_until TIMESTAMPTZ,
    success_count_since_open INT NOT NULL DEFAULT 0,
    threshold_failures INT NOT NULL DEFAULT 5,
    threshold_successes INT NOT NULL DEFAULT 3,
    timeout_seconds INT NOT NULL DEFAULT 60,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- SECTION 11: Cleanup & Housekeeping Procedures
-- ============================================================================

-- Procedure to expire idempotency windows
CREATE OR REPLACE FUNCTION orchestration_expire_idempotency_keys()
RETURNS TABLE(deleted_count INT) AS $$
DECLARE
    v_count INT;
BEGIN
    DELETE FROM orchestration_idempotent_calls
    WHERE expires_at < NOW();
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN QUERY SELECT v_count::INT;
END;
$$ LANGUAGE plpgsql;

-- Procedure to clean up expired artifacts
CREATE OR REPLACE FUNCTION orchestration_cleanup_expired_artifacts()
RETURNS TABLE(deleted_count INT, freed_bytes BIGINT) AS $$
DECLARE
    v_count INT;
    v_freed_bytes BIGINT;
BEGIN
    SELECT SUM(size_bytes)::BIGINT INTO v_freed_bytes
    FROM orchestration_job_artifacts
    WHERE artifact_type = 'TRANSIENT'
      AND retention_policy = 'AUTO_DELETE'
      AND expires_at IS NOT NULL
      AND expires_at < NOW()
      AND archived_at IS NULL;

    DELETE FROM orchestration_job_artifacts
    WHERE artifact_type = 'TRANSIENT'
      AND retention_policy = 'AUTO_DELETE'
      AND expires_at IS NOT NULL
      AND expires_at < NOW()
      AND archived_at IS NULL;
    
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN QUERY SELECT v_count, COALESCE(v_freed_bytes, 0::BIGINT);
END;
$$ LANGUAGE plpgsql;

-- Procedure to clean up retained dead letters
CREATE OR REPLACE FUNCTION orchestration_cleanup_dead_letters()
RETURNS TABLE(deleted_count INT) AS $$
DECLARE
    v_count INT;
BEGIN
    DELETE FROM orchestration_dead_letters
    WHERE retention_expires_at IS NOT NULL
      AND retention_expires_at < NOW();
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN QUERY SELECT v_count;
END;
$$ LANGUAGE plpgsql;

-- Procedure to recover stale jobs and re-queue them
CREATE OR REPLACE FUNCTION orchestration_recover_stale_jobs(
    p_stale_threshold_minutes INT DEFAULT 30
)
RETURNS TABLE(recovered_count INT) AS $$
DECLARE
    v_count INT;
BEGIN
    -- Find jobs stuck in RETRY_PENDING for too long and move to READY
    UPDATE orchestration_jobs
    SET status = 'QUEUED'
    WHERE status = 'RETRY_PENDING'
      AND next_retry_at < NOW() - (p_stale_threshold_minutes || ' minutes')::INTERVAL;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    
    RETURN QUERY SELECT v_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SECTION 12: Monitoring & Observability Views
-- ============================================================================

CREATE OR REPLACE VIEW orchestration_job_metrics AS
SELECT
    (SELECT COUNT(*) FROM orchestration_jobs WHERE status = 'QUEUED') as queued_count,
    (SELECT COUNT(*) FROM orchestration_jobs WHERE status = 'RUNNING') as running_count,
    (SELECT COUNT(*) FROM orchestration_jobs WHERE status = 'SUCCEEDED') as succeeded_count,
    (SELECT COUNT(*) FROM orchestration_jobs WHERE status = 'FAILED') as failed_count,
    (SELECT COUNT(*) FROM orchestration_jobs WHERE status = 'DEAD_LETTERED') as dead_lettered_count,
    (SELECT COUNT(*) FROM orchestration_dead_letters WHERE alert_sent = FALSE) as unalerted_dead_letters,
    (SELECT COUNT(*) FROM orchestration_job_artifacts WHERE expires_at < NOW() AND archived_at IS NULL) as expired_artifacts_pending_cleanup;

CREATE OR REPLACE VIEW orchestration_lineage_chain AS
SELECT
    j.id,
    j.project_id,
    j.job_type,
    j.status,
    pj.id as parent_job_id,
    pj.job_type as parent_job_type,
    j.causation_id,
    j.trace_id,
    COUNT(DISTINCT dl.id) FILTER (WHERE dl.id IS NOT NULL) as dependent_job_count,
    j.created_at
FROM orchestration_jobs j
LEFT JOIN orchestration_jobs pj ON j.parent_job_id = pj.id
LEFT JOIN orchestration_job_dependencies dl ON j.id = dl.parent_job_id
GROUP BY
    j.id,
    j.project_id,
    j.job_type,
    j.status,
    pj.id,
    pj.job_type,
    j.causation_id,
    j.trace_id,
    j.created_at;

-- ============================================================================
-- SECTION 13: Grants & Permissions (for security)
-- ============================================================================

-- Change ownership if service account differs from migration user
-- GRANT SELECT, INSERT, UPDATE ON orchestration_jobs TO "compute-orchestration-service";
-- GRANT SELECT, INSERT ON orchestration_audit_log TO "compute-orchestration-service";
