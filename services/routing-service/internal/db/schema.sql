CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE route_type AS ENUM ('cable', 'road', 'fence');

CREATE TABLE routes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL,
    route_type route_type NOT NULL,
    name VARCHAR(255) NOT NULL,
    geometry_geojson JSONB NOT NULL,
    distance_m DOUBLE PRECISION NOT NULL DEFAULT 0,
    cost_estimate DOUBLE PRECISION NOT NULL DEFAULT 0,
    metadata JSONB
);

CREATE INDEX idx_routes_project_id ON routes(project_id);
CREATE INDEX idx_routes_type ON routes(route_type);
