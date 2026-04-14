CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS routes (
    id               UUID PRIMARY KEY,
    project_id       UUID NOT NULL,
    route_type       TEXT NOT NULL,
    name             TEXT NOT NULL,
    geometry_geojson TEXT NOT NULL,
    distance_m       DOUBLE PRECISION NOT NULL DEFAULT 0,
    cost_estimate    DOUBLE PRECISION NOT NULL DEFAULT 0,
    metadata         JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_routes_project_id
    ON routes (project_id);

CREATE INDEX IF NOT EXISTS idx_routes_created_at
    ON routes (created_at DESC);

CREATE TABLE IF NOT EXISTS transmission_routes (
    id                       UUID PRIMARY KEY,
    project_id               UUID NOT NULL,
    name                     TEXT NOT NULL,
    voltage_class            TEXT NOT NULL,
    farm_output_geojson      TEXT NOT NULL,
    grid_injection_geojson   TEXT NOT NULL,
    path_geojson             TEXT NOT NULL,
    tower_positions          JSONB NOT NULL DEFAULT '[]'::jsonb,
    distance_m               DOUBLE PRECISION NOT NULL DEFAULT 0,
    conductor_cost           DOUBLE PRECISION NOT NULL DEFAULT 0,
    tower_cost               DOUBLE PRECISION NOT NULL DEFAULT 0,
    row_acquisition_cost     DOUBLE PRECISION NOT NULL DEFAULT 0,
    crossing_premium         DOUBLE PRECISION NOT NULL DEFAULT 0,
    total_cost               DOUBLE PRECISION NOT NULL DEFAULT 0,
    cost_per_km              DOUBLE PRECISION NOT NULL DEFAULT 0,
    segment_explanations     JSONB NOT NULL DEFAULT '[]'::jsonb,
    route_score              JSONB NOT NULL DEFAULT '{}'::jsonb,
    metadata                 JSONB NOT NULL DEFAULT '{}'::jsonb,
    route_summary            TEXT NOT NULL DEFAULT '',
    created_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_transmission_routes_project_id
    ON transmission_routes (project_id);

CREATE INDEX IF NOT EXISTS idx_transmission_routes_created_at
    ON transmission_routes (created_at DESC);