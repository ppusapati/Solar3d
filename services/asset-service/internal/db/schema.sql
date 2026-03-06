CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE asset_category AS ENUM ('panel', 'inverter', 'transformer', 'tracker', 'cable', 'mounting', 'meter', 'other');

CREATE TABLE assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    manufacturer VARCHAR(255) NOT NULL DEFAULT '',
    model VARCHAR(255) NOT NULL DEFAULT '',
    category asset_category NOT NULL,
    dimensions JSONB NOT NULL DEFAULT '{}',
    electrical_params JSONB NOT NULL DEFAULT '{}',
    model_3d_path VARCHAR(1024) NOT NULL DEFAULT '',
    datasheet_path VARCHAR(1024) NOT NULL DEFAULT '',
    metadata JSONB
);

CREATE INDEX idx_assets_category ON assets(category);
CREATE INDEX idx_assets_manufacturer ON assets(manufacturer);
CREATE INDEX idx_assets_name_trgm ON assets USING gin (name gin_trgm_ops);
