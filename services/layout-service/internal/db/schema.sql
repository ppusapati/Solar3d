-- Layout Service Schema
-- Requires PostGIS extension for spatial indexing and queries.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ---------------------------------------------------------------------------
-- layouts: top-level entity for a solar farm layout
-- ---------------------------------------------------------------------------
CREATE TABLE layouts (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID        NOT NULL,
    name            TEXT        NOT NULL,
    total_panels    BIGINT      NOT NULL DEFAULT 0,
    total_capacity_kw DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    tile_count      INTEGER     NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_layouts_project_id ON layouts (project_id);

-- ---------------------------------------------------------------------------
-- layout_tiles: spatial tiles for LOD and viewport-based panel retrieval.
-- Bounding box stored as separate columns for direct queries and as a
-- generated geometry column for PostGIS GIST indexing.
-- ---------------------------------------------------------------------------
CREATE TABLE layout_tiles (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    layout_id   UUID        NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    min_x       DOUBLE PRECISION NOT NULL,
    min_y       DOUBLE PRECISION NOT NULL,
    max_x       DOUBLE PRECISION NOT NULL,
    max_y       DOUBLE PRECISION NOT NULL,
    lod_level   INTEGER     NOT NULL DEFAULT 0,
    panel_count INTEGER     NOT NULL DEFAULT 0,
    metadata    JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Generated geometry column for GIST indexing.
    geom        GEOMETRY(Polygon, 0) GENERATED ALWAYS AS (
        ST_MakeEnvelope(min_x, min_y, max_x, max_y, 0)
    ) STORED
);

CREATE INDEX idx_layout_tiles_layout_id ON layout_tiles (layout_id);
CREATE INDEX idx_layout_tiles_geom ON layout_tiles USING GIST (geom);
CREATE INDEX idx_layout_tiles_lod ON layout_tiles (layout_id, lod_level);

-- ---------------------------------------------------------------------------
-- components: placed objects (inverters, transformers, combiner boxes, etc.)
-- ---------------------------------------------------------------------------
CREATE TABLE components (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    layout_id       UUID            NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    asset_id        UUID            NOT NULL,
    component_type  TEXT            NOT NULL,
    position        JSONB           NOT NULL, -- {x, y, z}
    rotation        JSONB           NOT NULL DEFAULT '{"x":0,"y":0,"z":0}', -- Euler angles
    metadata        JSONB,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_components_layout_id ON components (layout_id);
CREATE INDEX idx_components_type ON components (layout_id, component_type);

-- ---------------------------------------------------------------------------
-- panels: individual solar panels within a tile.
-- Designed for bulk COPY insert of 100k-500k rows.
-- ---------------------------------------------------------------------------
CREATE TABLE panels (
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tile_id             UUID            NOT NULL REFERENCES layout_tiles(id) ON DELETE CASCADE,
    string_id           TEXT            NOT NULL, -- Electrical string identifier
    geometry_geojson    JSONB           NOT NULL, -- GeoJSON Polygon of panel footprint
    tilt                DOUBLE PRECISION NOT NULL DEFAULT 0.0,  -- degrees
    azimuth             DOUBLE PRECISION NOT NULL DEFAULT 180.0, -- degrees from north
    elevation           DOUBLE PRECISION NOT NULL DEFAULT 0.0,  -- meters above terrain
    metadata            JSONB
);

CREATE INDEX idx_panels_tile_id ON panels (tile_id);
CREATE INDEX idx_panels_string_id ON panels (tile_id, string_id);

-- ---------------------------------------------------------------------------
-- Utility: function to quickly count panels per layout via tiles.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION layout_panel_count(p_layout_id UUID)
RETURNS BIGINT AS $$
    SELECT COALESCE(SUM(panel_count), 0)
    FROM layout_tiles
    WHERE layout_id = p_layout_id;
$$ LANGUAGE SQL STABLE;
