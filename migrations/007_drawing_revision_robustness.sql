-- Migration 007: Drawing revision distributed robustness
-- Services: drawing-revision-service, cad-core-service

CREATE TABLE IF NOT EXISTS drawing_command_attempts (
    id                    UUID        PRIMARY KEY,
    drawing_id            UUID        NOT NULL REFERENCES drawings(id) ON DELETE CASCADE,
    command_id            TEXT        NOT NULL,
    actor                 TEXT        NOT NULL,
    summary               TEXT        NOT NULL DEFAULT '',
    base_revision_id      UUID,
    requested_head_version BIGINT     NOT NULL DEFAULT 0,
    observed_head_revision_id UUID,
    observed_head_version BIGINT      NOT NULL DEFAULT 0,
    status                TEXT        NOT NULL
                                      CHECK (status IN ('pending', 'succeeded', 'failed')),
    outcome_code          TEXT        NOT NULL DEFAULT '',
    outcome_message       TEXT        NOT NULL DEFAULT '',
    attempt_hash          TEXT        NOT NULL DEFAULT '',
    revision_id           UUID        REFERENCES drawing_revisions(id),
    expires_at            TIMESTAMPTZ NOT NULL,
    created_at            TIMESTAMPTZ NOT NULL,
    updated_at            TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_drawing_command_attempts_command
    ON drawing_command_attempts (drawing_id, command_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_drawing_command_attempts_status_expires
    ON drawing_command_attempts (status, expires_at);

CREATE TABLE IF NOT EXISTS drawing_conflict_events (
    id                UUID        PRIMARY KEY,
    drawing_id        UUID        NOT NULL REFERENCES drawings(id) ON DELETE CASCADE,
    command_id        TEXT        NOT NULL DEFAULT '',
    actor             TEXT        NOT NULL DEFAULT '',
    summary           TEXT        NOT NULL DEFAULT '',
    base_revision_id  UUID,
    head_revision_id  UUID,
    head_version      BIGINT      NOT NULL DEFAULT 0,
    outcome_code      TEXT        NOT NULL,
    details_json      JSONB       NOT NULL DEFAULT '{}'::jsonb,
    created_at        TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_drawing_conflict_events_drawing_created
    ON drawing_conflict_events (drawing_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_drawing_conflict_events_outcome
    ON drawing_conflict_events (outcome_code, created_at DESC);