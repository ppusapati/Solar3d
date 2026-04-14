CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS drawings (
    id UUID PRIMARY KEY,
    project_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    status TEXT NOT NULL CHECK (status IN ('active', 'archived')),
    current_revision_id UUID,
    revision_count INTEGER NOT NULL DEFAULT 0,
    entity_count INTEGER NOT NULL DEFAULT 0,
    contract_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_drawings_project_updated_at
    ON drawings (project_id, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_drawings_status
    ON drawings (status);

CREATE TABLE IF NOT EXISTS drawing_revisions (
    id UUID PRIMARY KEY,
    drawing_id UUID NOT NULL REFERENCES drawings(id) ON DELETE CASCADE,
    parent_revision_id UUID,
    author TEXT NOT NULL,
    summary TEXT NOT NULL,
    command_id TEXT NOT NULL DEFAULT '',
    entity_count INTEGER NOT NULL DEFAULT 0,
    snapshot_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    contract_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    committed_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_drawing_revisions_drawing_committed_at
    ON drawing_revisions (drawing_id, committed_at DESC);

CREATE UNIQUE INDEX IF NOT EXISTS idx_drawing_revisions_drawing_command_id
    ON drawing_revisions (drawing_id, command_id)
    WHERE command_id <> '';

-- Current-head entity index: one row per live entity per drawing.
-- Replaced atomically on each StoreDrawingRevision call.
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
    CONSTRAINT uq_drawing_entities_drawing_entity UNIQUE (drawing_id, entity_id)
);

CREATE INDEX IF NOT EXISTS idx_drawing_entities_type
    ON drawing_entities (drawing_id, entity_type);

CREATE INDEX IF NOT EXISTS idx_drawing_entities_layer
    ON drawing_entities (drawing_id, layer_id);

CREATE INDEX IF NOT EXISTS idx_drawing_entities_revision
    ON drawing_entities (revision_id);