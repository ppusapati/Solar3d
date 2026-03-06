CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE simulation_status AS ENUM ('pending', 'running', 'completed', 'failed');
CREATE TYPE simulation_type AS ENUM ('irradiance', 'shadow', 'yield');

CREATE TABLE simulations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL,
    layout_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    simulation_type simulation_type NOT NULL,
    status simulation_status NOT NULL DEFAULT 'pending',
    params JSONB NOT NULL DEFAULT '{}',
    result JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE INDEX idx_simulations_project_id ON simulations(project_id);
CREATE INDEX idx_simulations_layout_id ON simulations(layout_id);
CREATE INDEX idx_simulations_status ON simulations(status);
