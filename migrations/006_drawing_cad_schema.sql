-- Migration 006: Drawing, Revision, and Entity schema for the CAD backbone
-- Depends on: 001 (projects table, uuid-ossp, pgcrypto)
-- Services:   drawing-revision-service, cad-core-service

-- ============================================================
-- Drawings: lightweight metadata + current-head pointer
-- ============================================================

CREATE TABLE IF NOT EXISTS drawings (
    id                  UUID        PRIMARY KEY,
    project_id          UUID        NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name                TEXT        NOT NULL,
    description         TEXT        NOT NULL DEFAULT '',
    metadata_json       JSONB       NOT NULL DEFAULT '{}'::jsonb,
    status              TEXT        NOT NULL DEFAULT 'active'
                                    CHECK (status IN ('active', 'archived')),
    current_revision_id UUID,
    revision_count      INTEGER     NOT NULL DEFAULT 0,
    entity_count        INTEGER     NOT NULL DEFAULT 0,
    contract_json       JSONB       NOT NULL DEFAULT '{}'::jsonb,
    created_at          TIMESTAMPTZ NOT NULL,
    updated_at          TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_drawings_project_updated_at
    ON drawings (project_id, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_drawings_project_status
    ON drawings (project_id, status);

-- ============================================================
-- Drawing Revisions: immutable, append-only snapshots
-- ============================================================

CREATE TABLE IF NOT EXISTS drawing_revisions (
    id                UUID        PRIMARY KEY,
    drawing_id        UUID        NOT NULL REFERENCES drawings(id) ON DELETE CASCADE,
    parent_revision_id UUID,
    author            TEXT        NOT NULL,
    summary           TEXT        NOT NULL,
    command_id        TEXT        NOT NULL DEFAULT '',
    entity_count      INTEGER     NOT NULL DEFAULT 0,
    snapshot_json     JSONB       NOT NULL DEFAULT '[]'::jsonb,
    contract_json     JSONB       NOT NULL DEFAULT '{}'::jsonb,
    committed_at      TIMESTAMPTZ NOT NULL
);

-- Fast head-history walks per drawing
CREATE INDEX IF NOT EXISTS idx_drawing_revisions_drawing_committed
    ON drawing_revisions (drawing_id, committed_at DESC);

-- Idempotent command→revision mapping (empty command_id is excluded)
CREATE UNIQUE INDEX IF NOT EXISTS idx_drawing_revisions_command_id
    ON drawing_revisions (drawing_id, command_id)
    WHERE command_id <> '';

-- ============================================================
-- Drawing Entities: mutable current-head index for entity queries
-- One row per live entity per drawing; replaced atomically on each revision.
-- ============================================================

CREATE TABLE IF NOT EXISTS drawing_entities (
    id            UUID        PRIMARY KEY,
    drawing_id    UUID        NOT NULL REFERENCES drawings(id) ON DELETE CASCADE,
    entity_id     TEXT        NOT NULL,
    entity_type   TEXT        NOT NULL,
    layer_id      TEXT        NOT NULL DEFAULT '',
    layer_name    TEXT        NOT NULL DEFAULT '',
    style_id      TEXT        NOT NULL DEFAULT '',
    revision_id   UUID        NOT NULL REFERENCES drawing_revisions(id),
    body_json     JSONB       NOT NULL,
    metadata_json JSONB       NOT NULL DEFAULT '{}'::jsonb,
    updated_at    TIMESTAMPTZ NOT NULL,
    CONSTRAINT uq_drawing_entities_drawing_entity
        UNIQUE (drawing_id, entity_id)
);

CREATE INDEX IF NOT EXISTS idx_drawing_entities_type
    ON drawing_entities (drawing_id, entity_type);

CREATE INDEX IF NOT EXISTS idx_drawing_entities_layer
    ON drawing_entities (drawing_id, layer_id);

CREATE INDEX IF NOT EXISTS idx_drawing_entities_revision
    ON drawing_entities (revision_id);
