-- Solar EPC Platform - Initial Schema
-- Requires PostgreSQL 16+ with PostGIS 3.4+

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- Projects & Sites
-- ============================================================

CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'draft',
    target_capacity_mw DOUBLE PRECISION,
    location_name VARCHAR(255),
    client_name VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE sites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    boundary geometry(POLYGON, 4326) NOT NULL,
    area_sqm DOUBLE PRECISION,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    timezone VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sites_project_id ON sites(project_id);
CREATE INDEX idx_sites_boundary ON sites USING GIST(boundary);

-- ============================================================
-- Terrain Layers
-- ============================================================

CREATE TABLE terrain_layers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    layer_type VARCHAR(50) NOT NULL,
    source_file VARCHAR(1024),
    bounds geometry(POLYGON, 4326),
    resolution_m DOUBLE PRECISION,
    crs VARCHAR(50) DEFAULT 'EPSG:4326',
    min_elevation DOUBLE PRECISION,
    max_elevation DOUBLE PRECISION,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_terrain_layers_project_id ON terrain_layers(project_id);
CREATE INDEX idx_terrain_layers_bounds ON terrain_layers USING GIST(bounds);

-- ============================================================
-- Layouts
-- ============================================================

CREATE TABLE layouts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    total_panels INTEGER DEFAULT 0,
    total_capacity_kw DOUBLE PRECISION DEFAULT 0,
    tile_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_layouts_project_id ON layouts(project_id);

-- ============================================================
-- Layout Tiles (Spatial Partitioning)
-- ============================================================

CREATE TABLE layout_tiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    layout_id UUID NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    tile_bbox geometry(POLYGON, 4326) NOT NULL,
    lod_level INTEGER NOT NULL DEFAULT 0,
    panel_count INTEGER DEFAULT 0,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_layout_tiles_layout_id ON layout_tiles(layout_id);
CREATE INDEX idx_layout_tiles_geom ON layout_tiles USING GIST(tile_bbox);

-- ============================================================
-- Components (placed infrastructure)
-- ============================================================

CREATE TABLE components (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    layout_id UUID NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    asset_id UUID,
    component_type VARCHAR(50) NOT NULL,
    position geometry(POINT, 4326) NOT NULL,
    rotation DOUBLE PRECISION DEFAULT 0,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_components_layout_id ON components(layout_id);
CREATE INDEX idx_components_position ON components USING GIST(position);

-- ============================================================
-- Panels
-- ============================================================

CREATE TABLE panels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tile_id UUID NOT NULL REFERENCES layout_tiles(id) ON DELETE CASCADE,
    string_id UUID,
    geometry geometry(POLYGON, 4326) NOT NULL,
    tilt DOUBLE PRECISION NOT NULL DEFAULT 0,
    azimuth DOUBLE PRECISION NOT NULL DEFAULT 180,
    elevation DOUBLE PRECISION DEFAULT 0,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_panels_tile_id ON panels(tile_id);
CREATE INDEX idx_panels_string_id ON panels(string_id);
CREATE INDEX idx_panels_geom ON panels USING GIST(geometry);

-- ============================================================
-- Electrical Networks
-- ============================================================

CREATE TABLE electrical_networks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    layout_id UUID NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    total_dc_capacity_kw DOUBLE PRECISION DEFAULT 0,
    total_ac_capacity_kw DOUBLE PRECISION DEFAULT 0,
    dc_ac_ratio DOUBLE PRECISION DEFAULT 0,
    string_count INTEGER DEFAULT 0,
    inverter_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_electrical_networks_project_id ON electrical_networks(project_id);

-- ============================================================
-- Panel Strings
-- ============================================================

CREATE TABLE panel_strings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    network_id UUID NOT NULL REFERENCES electrical_networks(id) ON DELETE CASCADE,
    inverter_group_id UUID,
    panel_count INTEGER DEFAULT 0,
    string_voltage DOUBLE PRECISION DEFAULT 0,
    string_current DOUBLE PRECISION DEFAULT 0,
    string_power_w DOUBLE PRECISION DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_panel_strings_network_id ON panel_strings(network_id);

-- ============================================================
-- Inverter Groups
-- ============================================================

CREATE TABLE inverter_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    network_id UUID NOT NULL REFERENCES electrical_networks(id) ON DELETE CASCADE,
    inverter_asset_id UUID,
    dc_input_kw DOUBLE PRECISION DEFAULT 0,
    ac_output_kw DOUBLE PRECISION DEFAULT 0,
    dc_ac_ratio DOUBLE PRECISION DEFAULT 0,
    position geometry(POINT, 4326),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_inverter_groups_network_id ON inverter_groups(network_id);

-- ============================================================
-- Cable Routes
-- ============================================================

CREATE TABLE cable_routes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    route_type VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    geometry geometry(LINESTRING, 4326) NOT NULL,
    distance_m DOUBLE PRECISION DEFAULT 0,
    cost_estimate DOUBLE PRECISION DEFAULT 0,
    cable_type VARCHAR(100),
    cable_size_mm2 DOUBLE PRECISION,
    voltage_drop_percent DOUBLE PRECISION,
    max_slope_percent DOUBLE PRECISION,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_cable_routes_project_id ON cable_routes(project_id);
CREATE INDEX idx_cable_routes_geom ON cable_routes USING GIST(geometry);

-- ============================================================
-- Simulations
-- ============================================================

CREATE TABLE simulations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    layout_id UUID NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    simulation_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    params JSONB,
    result JSONB,
    result_file_path VARCHAR(1024),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE INDEX idx_simulations_project_id ON simulations(project_id);

-- ============================================================
-- Reports
-- ============================================================

CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    format VARCHAR(20) NOT NULL,
    file_path VARCHAR(1024),
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE INDEX idx_reports_project_id ON reports(project_id);

-- ============================================================
-- Assets (component catalog)
-- ============================================================

CREATE TABLE assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    manufacturer VARCHAR(255),
    model VARCHAR(255),
    category VARCHAR(50) NOT NULL,
    width_mm DOUBLE PRECISION,
    height_mm DOUBLE PRECISION,
    depth_mm DOUBLE PRECISION,
    weight_kg DOUBLE PRECISION,
    electrical_params JSONB,
    model_3d_path VARCHAR(1024),
    datasheet_path VARCHAR(1024),
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_assets_category ON assets(category);

-- ============================================================
-- Updated At Trigger
-- ============================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_projects_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_layouts_updated_at
    BEFORE UPDATE ON layouts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assets_updated_at
    BEFORE UPDATE ON assets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
