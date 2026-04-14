ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS route_score JSONB NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE transmission_routes
    ADD COLUMN IF NOT EXISTS metadata JSONB NOT NULL DEFAULT '{}'::jsonb;