-- Compute Orchestration persistence schema (jobs, retries, artifact outputs)

CREATE TABLE IF NOT EXISTS orchestration_jobs (
    id UUID PRIMARY KEY,
    project_id TEXT NOT NULL,
    job_type TEXT NOT NULL,
    status TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 0,
    attempts INTEGER NOT NULL DEFAULT 0,
    max_attempts INTEGER NOT NULL DEFAULT 3,
    payload_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    error_message TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    next_retry_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_orch_jobs_project_status
    ON orchestration_jobs (project_id, status, priority DESC, created_at ASC);

CREATE INDEX IF NOT EXISTS idx_orch_jobs_retry
    ON orchestration_jobs (status, next_retry_at)
    WHERE status = 'RETRY_PENDING';

CREATE TABLE IF NOT EXISTS orchestration_job_artifacts (
    id BIGSERIAL PRIMARY KEY,
    job_id UUID NOT NULL REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    kind TEXT NOT NULL,
    uri TEXT NOT NULL,
    checksum TEXT,
    size_bytes BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orch_artifacts_job_id
    ON orchestration_job_artifacts (job_id);

CREATE TABLE IF NOT EXISTS orchestration_job_attempts (
    id BIGSERIAL PRIMARY KEY,
    job_id UUID NOT NULL REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    attempt_no INTEGER NOT NULL,
    status TEXT NOT NULL,
    started_at TIMESTAMPTZ,
    finished_at TIMESTAMPTZ,
    error_message TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (job_id, attempt_no)
);

CREATE INDEX IF NOT EXISTS idx_orch_attempts_job_id
    ON orchestration_job_attempts (job_id, attempt_no);
