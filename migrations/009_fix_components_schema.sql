-- Migration 009: Fix components position/rotation column types
-- The layout-service repository serializes Position{X,Y,Z} and Rotation{X,Y,Z}
-- as JSONB, but the initial schema used geometry(POINT, 4326) and DOUBLE PRECISION.
-- This migration drops the mismatched columns and adds correct JSONB columns.

-- Drop old spatial index first (references the geometry column)
DROP INDEX IF EXISTS idx_components_position;

-- Replace geometry column with JSONB
ALTER TABLE components DROP COLUMN IF EXISTS position;
ALTER TABLE components ADD COLUMN position JSONB NOT NULL DEFAULT '{"x":0,"y":0,"z":0}'::jsonb;

-- Replace single float rotation with JSONB Euler angles
ALTER TABLE components DROP COLUMN IF EXISTS rotation;
ALTER TABLE components ADD COLUMN rotation JSONB NOT NULL DEFAULT '{"x":0,"y":0,"z":0}'::jsonb;

-- GIN index for future JSONB position queries
CREATE INDEX IF NOT EXISTS idx_components_position_json ON components USING GIN(position);
