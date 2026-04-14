-- Migration 008: Drawing integrity audit and repair persistence
-- Services: drawing-revision-service

CREATE TABLE IF NOT EXISTS drawing_integrity_audit_runs (
    id               UUID        PRIMARY KEY,
    checked_drawings INTEGER     NOT NULL DEFAULT 0,
    findings_count   INTEGER     NOT NULL DEFAULT 0,
    repaired_count   INTEGER     NOT NULL DEFAULT 0,
    status           TEXT        NOT NULL
                                   CHECK (status IN ('running', 'completed', 'failed')),
    error_message    TEXT        NOT NULL DEFAULT '',
    started_at       TIMESTAMPTZ NOT NULL,
    finished_at      TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS drawing_integrity_findings (
    id                   UUID        PRIMARY KEY,
    audit_run_id         UUID        REFERENCES drawing_integrity_audit_runs(id) ON DELETE SET NULL,
    drawing_id           UUID        NOT NULL REFERENCES drawings(id) ON DELETE CASCADE,
    issue_key            TEXT        NOT NULL,
    issue_code           TEXT        NOT NULL,
    severity             TEXT        NOT NULL DEFAULT 'error'
                                      CHECK (severity IN ('warning', 'error')),
    current_revision_id  UUID,
    expected_revision_id UUID,
    expected_count       INTEGER     NOT NULL DEFAULT 0,
    actual_count         INTEGER     NOT NULL DEFAULT 0,
    details_json         JSONB       NOT NULL DEFAULT '{}'::jsonb,
    status               TEXT        NOT NULL DEFAULT 'open'
                                      CHECK (status IN ('open', 'resolved')),
    first_detected_at    TIMESTAMPTZ NOT NULL,
    last_detected_at     TIMESTAMPTZ NOT NULL,
    resolved_at          TIMESTAMPTZ
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_drawing_integrity_findings_open_key
    ON drawing_integrity_findings (issue_key)
    WHERE status = 'open';

CREATE INDEX IF NOT EXISTS idx_drawing_integrity_findings_drawing_status
    ON drawing_integrity_findings (drawing_id, status, last_detected_at DESC);

CREATE INDEX IF NOT EXISTS idx_drawing_integrity_findings_issue_status
    ON drawing_integrity_findings (issue_code, status, last_detected_at DESC);