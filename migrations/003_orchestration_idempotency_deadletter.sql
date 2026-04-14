-- Orchestration idempotency and dead-letter persistence

CREATE TABLE IF NOT EXISTS orchestration_idempotency_keys (
    id BIGSERIAL PRIMARY KEY,
    project_id TEXT NOT NULL,
    idempotency_key TEXT NOT NULL,
    job_id UUID NOT NULL REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, idempotency_key)
);

CREATE INDEX IF NOT EXISTS idx_orch_idempotency_project_key
    ON orchestration_idempotency_keys (project_id, idempotency_key);

CREATE TABLE IF NOT EXISTS orchestration_dead_letters (
    id BIGSERIAL PRIMARY KEY,
    job_id UUID NOT NULL REFERENCES orchestration_jobs(id) ON DELETE CASCADE,
    reason TEXT NOT NULL,
    payload_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orch_dead_letters_job_id
    ON orchestration_dead_letters (job_id);
