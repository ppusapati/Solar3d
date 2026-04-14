CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS transmission_routes (
    id                     UUID PRIMARY KEY,
    project_id             UUID NOT NULL,
    name                   TEXT NOT NULL,
    voltage_class          TEXT NOT NULL,
    farm_output_geojson    TEXT NOT NULL,
    grid_injection_geojson TEXT NOT NULL,
    path_geojson           TEXT NOT NULL,
    tower_positions        JSONB NOT NULL DEFAULT '[]'::jsonb,
    distance_m             DOUBLE PRECISION NOT NULL DEFAULT 0,
    conductor_cost         DOUBLE PRECISION NOT NULL DEFAULT 0,
    tower_cost             DOUBLE PRECISION NOT NULL DEFAULT 0,
    row_acquisition_cost   DOUBLE PRECISION NOT NULL DEFAULT 0,
    crossing_premium       DOUBLE PRECISION NOT NULL DEFAULT 0,
    total_cost             DOUBLE PRECISION NOT NULL DEFAULT 0,
    cost_per_km            DOUBLE PRECISION NOT NULL DEFAULT 0,
    segment_explanations   JSONB NOT NULL DEFAULT '[]'::jsonb,
    route_score            JSONB NOT NULL DEFAULT '{}'::jsonb,
    approval_status        TEXT NOT NULL DEFAULT 'draft',
    engineering_reviewed_at TIMESTAMPTZ,
    engineering_reviewed_by TEXT NOT NULL DEFAULT '',
    approved_at            TIMESTAMPTZ,
    approved_by            TEXT NOT NULL DEFAULT '',
    governance_events      JSONB NOT NULL DEFAULT '[]'::jsonb,
    metadata               JSONB NOT NULL DEFAULT '{}'::jsonb,
    route_summary          TEXT NOT NULL DEFAULT '',
    created_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS route_score JSONB NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS approval_status TEXT NOT NULL DEFAULT 'draft';

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS engineering_reviewed_at TIMESTAMPTZ;

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS engineering_reviewed_by TEXT NOT NULL DEFAULT '';

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ;

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS approved_by TEXT NOT NULL DEFAULT '';

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS governance_events JSONB NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS metadata JSONB NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS idx_transmission_routes_project_id
    ON transmission_routes (project_id);

CREATE INDEX IF NOT EXISTS idx_transmission_routes_created_at
    ON transmission_routes (created_at DESC);