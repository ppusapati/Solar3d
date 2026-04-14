-- Add initial GPS coordinates to projects
-- Captured at project creation time (browser geolocation) so the map
-- can fly to the site before any polygon is drawn.

ALTER TABLE projects
    ADD COLUMN IF NOT EXISTS initial_latitude  DOUBLE PRECISION,
    ADD COLUMN IF NOT EXISTS initial_longitude DOUBLE PRECISION;
