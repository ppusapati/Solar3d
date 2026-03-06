CREATE TABLE IF NOT EXISTS assets (
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

CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
