CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE electrical_networks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL,
    layout_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    total_dc_capacity_kw DOUBLE PRECISION NOT NULL DEFAULT 0,
    total_ac_capacity_kw DOUBLE PRECISION NOT NULL DEFAULT 0,
    dc_ac_ratio DOUBLE PRECISION NOT NULL DEFAULT 0,
    string_count INTEGER NOT NULL DEFAULT 0,
    inverter_count INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_electrical_networks_project_id ON electrical_networks(project_id);

CREATE TABLE panel_strings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    network_id UUID NOT NULL REFERENCES electrical_networks(id) ON DELETE CASCADE,
    inverter_group_id UUID NOT NULL,
    panel_ids JSONB NOT NULL DEFAULT '[]',
    panel_count INTEGER NOT NULL DEFAULT 0,
    voltage DOUBLE PRECISION NOT NULL DEFAULT 0,
    current DOUBLE PRECISION NOT NULL DEFAULT 0,
    power_w DOUBLE PRECISION NOT NULL DEFAULT 0
);

CREATE INDEX idx_panel_strings_network_id ON panel_strings(network_id);
CREATE INDEX idx_panel_strings_inverter_group_id ON panel_strings(inverter_group_id);

CREATE TABLE inverter_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    network_id UUID NOT NULL REFERENCES electrical_networks(id) ON DELETE CASCADE,
    inverter_asset_id UUID NOT NULL,
    string_ids JSONB NOT NULL DEFAULT '[]',
    dc_input_kw DOUBLE PRECISION NOT NULL DEFAULT 0,
    ac_output_kw DOUBLE PRECISION NOT NULL DEFAULT 0,
    dc_ac_ratio DOUBLE PRECISION NOT NULL DEFAULT 0,
    position JSONB NOT NULL DEFAULT '[0,0]'
);

CREATE INDEX idx_inverter_groups_network_id ON inverter_groups(network_id);
