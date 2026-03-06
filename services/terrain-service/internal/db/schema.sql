-- Terrain Service Schema
-- Requires PostGIS extension.

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS terrain_layers (
    id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id    UUID        NOT NULL,
    name          TEXT        NOT NULL,
    layer_type    TEXT        NOT NULL CHECK (layer_type IN ('DEM', 'Slope', 'Aspect', 'Hillshade')),
    source_file   TEXT        NOT NULL DEFAULT '',
    bounds        GEOMETRY(POLYGON, 4326) NOT NULL,
    resolution_m  DOUBLE PRECISION NOT NULL CHECK (resolution_m > 0),
    crs           TEXT        NOT NULL DEFAULT 'EPSG:4326',
    min_elevation DOUBLE PRECISION NOT NULL DEFAULT 0,
    max_elevation DOUBLE PRECISION NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for fast project-scoped queries.
CREATE INDEX IF NOT EXISTS idx_terrain_layers_project_id
    ON terrain_layers (project_id);

-- Spatial index on the bounding geometry.
CREATE INDEX IF NOT EXISTS idx_terrain_layers_bounds
    ON terrain_layers USING GIST (bounds);

-- Index for listing layers ordered by creation time.
CREATE INDEX IF NOT EXISTS idx_terrain_layers_created_at
    ON terrain_layers (created_at DESC);

COMMENT ON TABLE terrain_layers IS 'Stores metadata for terrain analysis layers (DEM, Slope, Aspect, Hillshade) associated with solar EPC projects.';
