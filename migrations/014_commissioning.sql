-- 014_commissioning.sql
-- Creates tables for the commissioning service:
-- checklists, checklist items, signoffs, handover records, and as-built artifacts.

CREATE TABLE IF NOT EXISTS commissioning_checklists (
    id          UUID PRIMARY KEY,
    project_id  UUID NOT NULL,
    name        VARCHAR(255) NOT NULL,
    status      INT NOT NULL DEFAULT 1,
    created_by  VARCHAR(255),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_commissioning_checklists_project
    ON commissioning_checklists(project_id);

CREATE TABLE IF NOT EXISTS commissioning_checklist_items (
    id           UUID PRIMARY KEY,
    checklist_id UUID NOT NULL REFERENCES commissioning_checklists(id) ON DELETE CASCADE,
    description  TEXT NOT NULL,
    section      INT NOT NULL DEFAULT 0,
    status       INT NOT NULL DEFAULT 1,
    required     BOOLEAN NOT NULL DEFAULT TRUE,
    completed_by VARCHAR(255),
    completed_at TIMESTAMPTZ,
    notes        TEXT,
    sequence     INT NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_commissioning_items_checklist
    ON commissioning_checklist_items(checklist_id);

CREATE TABLE IF NOT EXISTS commissioning_signoffs (
    id           UUID PRIMARY KEY,
    checklist_id UUID NOT NULL REFERENCES commissioning_checklists(id) ON DELETE CASCADE,
    signed_by    VARCHAR(255) NOT NULL,
    role         VARCHAR(255) NOT NULL,
    comments     TEXT,
    signed_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_commissioning_signoffs_checklist
    ON commissioning_signoffs(checklist_id);

CREATE TABLE IF NOT EXISTS commissioning_handovers (
    id             UUID PRIMARY KEY,
    project_id     UUID NOT NULL,
    checklist_id   UUID NOT NULL REFERENCES commissioning_checklists(id),
    handed_over_by VARCHAR(255) NOT NULL,
    received_by    VARCHAR(255) NOT NULL,
    notes          TEXT,
    artifact_ids   TEXT NOT NULL DEFAULT '[]',
    handover_date  TIMESTAMPTZ NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_commissioning_handovers_project
    ON commissioning_handovers(project_id);

CREATE TABLE IF NOT EXISTS commissioning_as_built_artifacts (
    id              UUID PRIMARY KEY,
    project_id      UUID NOT NULL,
    name            VARCHAR(255) NOT NULL,
    artifact_type   INT NOT NULL DEFAULT 0,
    storage_url     TEXT NOT NULL,
    uploaded_by     VARCHAR(255) NOT NULL,
    uploaded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    description     TEXT,
    file_size_bytes BIGINT NOT NULL DEFAULT 0,
    revision        VARCHAR(50)
);

CREATE INDEX IF NOT EXISTS idx_commissioning_artifacts_project
    ON commissioning_as_built_artifacts(project_id);
