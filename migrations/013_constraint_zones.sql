-- Migration 013: Add constraint zones for land intake and routing constraints
-- Tracks environmental and physical constraints (wetlands, floodplains, setbacks, exclusion zones)
-- Supports routing service pathfinding with spatial penalties

-- Create constraint_zone_type enum
CREATE TYPE constraint_zone_type AS ENUM (
  'wetland',           -- Jurisdictional wetlands (cannot build)
  'floodplain',        -- 100-year floodplain (avoid if possible)
  'setback',           -- Building setback from sensitive areas (apply penalty)
  'exclusion',         -- Total exclusion zones (must avoid)
  'high_voltage',      -- High voltage transmission line corridors (apply penalty)
  'habitat',           -- Critical habitat areas (apply penalty)
  'archeological'      -- Archeological sites (apply penalty)
);

-- Create main constraint zones table
CREATE TABLE constraint_zones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  site_id UUID NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
  zone_name VARCHAR(255) NOT NULL,
  zone_type constraint_zone_type NOT NULL,
  geometry GEOMETRY('POLYGON', 4326) NOT NULL,
  area_sqm DECIMAL(15, 2) NOT NULL DEFAULT 0,  -- Derived from ST_Area
  severity_level SMALLINT NOT NULL DEFAULT 1,  -- 1-5: routing penalty multiplier
  notes TEXT,
  source VARCHAR(255),  -- KML import source or manual entry
  imported_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_constraint_zones_site_id ON constraint_zones(site_id);
CREATE INDEX idx_constraint_zones_type ON constraint_zones(zone_type);
CREATE INDEX idx_constraint_zones_geometry ON constraint_zones USING GIST(geometry);
CREATE INDEX idx_constraint_zones_severity ON constraint_zones(severity_level);

-- Create audit view for constraint zone changes
CREATE TABLE IF NOT EXISTS constraint_zones_audit (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  constraint_zone_id UUID NOT NULL REFERENCES constraint_zones(id) ON DELETE CASCADE,
  action VARCHAR(10) NOT NULL,  -- 'INSERT', 'UPDATE', 'DELETE'
  old_values JSONB,
  new_values JSONB,
  changed_by VARCHAR(255),
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_constraint_zones_audit_zone_id ON constraint_zones_audit(constraint_zone_id);
CREATE INDEX idx_constraint_zones_audit_action ON constraint_zones_audit(action);

-- Update sites table to add constraint zone count tracking
ALTER TABLE sites ADD COLUMN IF NOT EXISTS constraint_zone_count INTEGER DEFAULT 0;

-- Partitioning hint: may want to partition by site_id for very large deployments with thousands of zones
-- CREATE TABLE constraint_zones_p0 PARTITION OF constraint_zones FOR VALUES IN (siteid1, siteid2, ...);
