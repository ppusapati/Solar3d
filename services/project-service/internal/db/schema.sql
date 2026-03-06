-- Enable PostGIS extension (idempotent).
CREATE EXTENSION IF NOT EXISTS postgis;

-- projects stores solar EPC project metadata.
CREATE TABLE IF NOT EXISTS projects (
    id                  UUID        PRIMARY KEY,
    name                TEXT        NOT NULL,
    description         TEXT        NOT NULL DEFAULT '',
    status              TEXT        NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft','design','simulation','review','approved','archived')),
    target_capacity_mw  DOUBLE PRECISION NOT NULL DEFAULT 0,
    location_name       TEXT        NOT NULL DEFAULT '',
    client_name         TEXT        NOT NULL DEFAULT '',
    notes               TEXT        NOT NULL DEFAULT '',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_projects_status     ON projects (status);
CREATE INDEX IF NOT EXISTS idx_projects_created_at ON projects (created_at DESC);

-- sites stores physical site boundaries linked to a project.
CREATE TABLE IF NOT EXISTS sites (
    id          UUID            PRIMARY KEY,
    project_id  UUID            NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name        TEXT            NOT NULL,
    boundary    GEOMETRY(Geometry, 4326),
    area_sqm    DOUBLE PRECISION NOT NULL DEFAULT 0,
    latitude    DOUBLE PRECISION NOT NULL DEFAULT 0,
    longitude   DOUBLE PRECISION NOT NULL DEFAULT 0,
    timezone    TEXT            NOT NULL DEFAULT 'UTC',
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_sites_project_id ON sites (project_id);
CREATE INDEX IF NOT EXISTS idx_sites_boundary   ON sites USING GIST (boundary);
