-- Add dimensions JSONB column to assets table
-- The asset-service repository serializes Dimensions as JSONB but the initial schema
-- only had individual width_mm, height_mm, depth_mm, weight_kg columns.
ALTER TABLE assets ADD COLUMN IF NOT EXISTS dimensions JSONB;
