-- Phase 1 Sprint 1.2: Constraint Zones (Exclusion/Inclusion/Buffer zone management)
-- Enables landing site conflict analysis against regulatory and environmental constraints

BEGIN;

-- ================== CONSTRAINT ZONES TABLE ==================
CREATE TABLE IF NOT EXISTS constraint_zones (
    id BIGSERIAL PRIMARY KEY,
    zone_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    zone_type VARCHAR(50) NOT NULL CHECK (zone_type IN ('EXCLUSION', 'INCLUSION', 'BUFFER')),
    zone_category VARCHAR(50) NOT NULL CHECK (zone_category IN (
        'GEOLOGICAL', 'ENVIRONMENTAL', 'REGULATORY', 'INFRASTRUCTURE', 'MILITARY', 'PROTECTED'
    )),
    zone_status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE' CHECK (zone_status IN (
        'ACTIVE', 'INACTIVE', 'EXPIRED', 'PENDING'
    )),
    
    -- Geometry storage (PostGIS)
    geometry_wkt TEXT NOT NULL,
    geometry_type VARCHAR(50) NOT NULL CHECK (geometry_type IN (
        'POINT', 'LINESTRING', 'POLYGON', 'MULTIPOLYGON'
    )),
    geometry geography(Geometry, 4326) NOT NULL,
    bbox_min_x FLOAT8,
    bbox_min_y FLOAT8,
    bbox_max_x FLOAT8,
    bbox_max_y FLOAT8,
    
    -- Temporal constraints
    effective_start_at TIMESTAMP WITH TIME ZONE,
    effective_end_at TIMESTAMP WITH TIME ZONE,
    
    -- Source tracking
    source VARCHAR(100),
    source_id VARCHAR(255),
    buffer_distance_m FLOAT4,
    
    -- Metadata
    tags TEXT[],   -- Array of classification tags
    metadata JSONB DEFAULT '{}',
    
    -- Access control
    created_by VARCHAR(255) NOT NULL,
    project_id UUID NOT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    
    -- Audit
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    deleted_reason TEXT
);

-- Indexes for performance
CREATE INDEX idx_constraint_zones_zone_id ON constraint_zones(zone_id);
CREATE INDEX idx_constraint_zones_project_id ON constraint_zones(project_id);
CREATE INDEX idx_constraint_zones_zone_type ON constraint_zones(zone_type);
CREATE INDEX idx_constraint_zones_zone_category ON constraint_zones(zone_category);
CREATE INDEX idx_constraint_zones_zone_status ON constraint_zones(zone_status);
CREATE INDEX idx_constraint_zones_created_by ON constraint_zones(created_by);
CREATE INDEX idx_constraint_zones_effective_dates ON constraint_zones(effective_start_at, effective_end_at);
CREATE INDEX idx_constraint_zones_deleted_at ON constraint_zones(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_constraint_zones_tags ON constraint_zones USING GIN(tags);
CREATE INDEX idx_constraint_zones_metadata ON constraint_zones USING GIN(metadata);

-- Spatial index (GIST) for geographic queries
CREATE INDEX idx_constraint_zones_geometry_gist ON constraint_zones USING GIST(geometry);

-- ================== ZONE HISTORY (Audit Trail) ==================
CREATE TABLE IF NOT EXISTS zone_history (
    id BIGSERIAL PRIMARY KEY,
    zone_id UUID NOT NULL REFERENCES constraint_zones(zone_id) ON DELETE CASCADE,
    change_type VARCHAR(50) NOT NULL CHECK (change_type IN (
        'CREATE', 'UPDATE', 'DELETE', 'STATUS_CHANGE', 'PERMISSION_CHANGE'
    )),
    old_values JSONB,
    new_values JSONB,
    changed_by VARCHAR(255) NOT NULL,
    change_reason TEXT,
    detailed_changes JSONB,
    changed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_zone_history_zone_id ON zone_history(zone_id);
CREATE INDEX idx_zone_history_changed_by ON zone_history(changed_by);
CREATE INDEX idx_zone_history_changed_at ON zone_history(changed_at DESC);
CREATE INDEX idx_zone_history_change_type ON zone_history(change_type);

-- ================== ZONE PERMISSIONS ==================
CREATE TABLE IF NOT EXISTS zone_permissions (
    id BIGSERIAL PRIMARY KEY,
    zone_id UUID NOT NULL REFERENCES constraint_zones(zone_id) ON DELETE CASCADE,
    user_id VARCHAR(255) NOT NULL,
    permission VARCHAR(50) NOT NULL CHECK (permission IN ('VIEW', 'EDIT', 'ADMIN')),
    granted_by VARCHAR(255) NOT NULL,
    granted_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(zone_id, user_id)
);

CREATE INDEX idx_zone_permissions_zone_id ON zone_permissions(zone_id);
CREATE INDEX idx_zone_permissions_user_id ON zone_permissions(user_id);
CREATE INDEX idx_zone_permissions_permission ON zone_permissions(permission);

-- ================== SITING CONFLICTS ==================
CREATE TABLE IF NOT EXISTS siting_conflicts (
    id BIGSERIAL PRIMARY KEY,
    conflict_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    zone_id UUID NOT NULL REFERENCES constraint_zones(zone_id) ON DELETE CASCADE,
    proposed_site_geometry_wkt TEXT NOT NULL,
    proposed_site_geometry geography(Geometry, 4326),
    conflict_severity VARCHAR(50) NOT NULL CHECK (conflict_severity IN (
        'INFO', 'WARNING', 'ERROR', 'BLOCKER'
    )),
    conflict_reason VARCHAR(255) NOT NULL,
    distance_meters FLOAT8 DEFAULT 0,
    overlap_area_sqm FLOAT8 DEFAULT 0,
    mitigation_suggestions TEXT[],
    detected_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_siting_conflicts_zone_id ON siting_conflicts(zone_id);
CREATE INDEX idx_siting_conflicts_severity ON siting_conflicts(conflict_severity);
CREATE INDEX idx_siting_conflicts_detected_at ON siting_conflicts(detected_at DESC);

-- ================== SITING ANALYSIS RECORDS ==================
CREATE TABLE IF NOT EXISTS siting_analyses (
    id BIGSERIAL PRIMARY KEY,
    analysis_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL,
    proposed_site_geometry_wkt TEXT NOT NULL,
    proposed_site_geometry geography(Geometry, 4326),
    proposed_site_bounds_min_x FLOAT8,
    proposed_site_bounds_min_y FLOAT8,
    proposed_site_bounds_max_x FLOAT8,
    proposed_site_bounds_max_y FLOAT8,
    
    -- Risk scoring
    total_conflicts INT DEFAULT 0,
    blocker_count INT DEFAULT 0,
    error_count INT DEFAULT 0,
    warning_count INT DEFAULT 0,
    info_count INT DEFAULT 0,
    overall_risk_percentage FLOAT4,
    is_siteable BOOLEAN,
    siting_recommendation TEXT,
    
    total_zones_checked INT,
    analyzed_by VARCHAR(255),
    analyzed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_siting_analyses_analysis_id ON siting_analyses(analysis_id);
CREATE INDEX idx_siting_analyses_project_id ON siting_analyses(project_id);
CREATE INDEX idx_siting_analyses_analyzed_at ON siting_analyses(analyzed_at DESC);
CREATE INDEX idx_siting_analyses_risk ON siting_analyses(overall_risk_percentage DESC);

-- ================== SITING DECISIONS ==================
CREATE TABLE IF NOT EXISTS siting_decisions (
    id BIGSERIAL PRIMARY KEY,
    decision_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL,
    analysis_id UUID REFERENCES siting_analyses(analysis_id) ON DELETE SET NULL,
    decision VARCHAR(50) NOT NULL CHECK (decision IN ('APPROVED', 'REJECTED', 'DEFER')),
    decision_made_by VARCHAR(255) NOT NULL,
    rationale TEXT,
    approved_zone_exceptions UUID[],  -- Zone IDs where conflicts were waived
    mitigation_plan TEXT,
    decided_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_siting_decisions_decision_id ON siting_decisions(decision_id);
CREATE INDEX idx_siting_decisions_project_id ON siting_decisions(project_id);
CREATE INDEX idx_siting_decisions_decision ON siting_decisions(decision);
CREATE INDEX idx_siting_decisions_decided_at ON siting_decisions(decided_at DESC);

-- ================== ZONE IMPORTS ==================
CREATE TABLE IF NOT EXISTS zone_imports (
    id BIGSERIAL PRIMARY KEY,
    import_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL,
    source VARCHAR(100) NOT NULL,
    total_zones INT NOT NULL,
    success_count INT NOT NULL,
    failure_count INT NOT NULL,
    errors JSONB,
    imported_by_user VARCHAR(255) NOT NULL,
    imported_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_zone_imports_import_id ON zone_imports(import_id);
CREATE INDEX idx_zone_imports_project_id ON zone_imports(project_id);
CREATE INDEX idx_zone_imports_source ON zone_imports(source);
CREATE INDEX idx_zone_imports_imported_at ON zone_imports(imported_at DESC);

-- ================== MATERIALIZED VIEW: Zone Statistics ==================
CREATE MATERIALIZED VIEW IF NOT EXISTS v_zone_statistics AS
SELECT
    project_id,
    COUNT(*) as total_zones,
    COUNT(*) FILTER (WHERE zone_status = 'ACTIVE') as active_zones,
    COUNT(*) FILTER (WHERE zone_status = 'INACTIVE') as inactive_zones,
    COUNT(*) FILTER (WHERE zone_status = 'EXPIRED') as expired_zones,
    COUNT(*) FILTER (WHERE deleted_at IS NULL) as not_deleted,
    MAX(updated_at) as last_modified_at
FROM constraint_zones
GROUP BY project_id;

CREATE INDEX idx_v_zone_statistics_project_id ON v_zone_statistics(project_id);

-- ================== MATERIALIZED VIEW: Conflict Summary ==================
CREATE MATERIALIZED VIEW IF NOT EXISTS v_conflict_summary AS
SELECT
    project_id,
    COUNT(*) as total_conflicts,
    COUNT(*) FILTER (WHERE conflict_severity = 'BLOCKER') as blocker_conflicts,
    COUNT(*) FILTER (WHERE conflict_severity = 'ERROR') as error_conflicts,
    COUNT(*) FILTER (WHERE conflict_severity = 'WARNING') as warning_conflicts,
    COUNT(*) FILTER (WHERE conflict_severity = 'INFO') as info_conflicts
FROM (
    SELECT DISTINCT
        sa.project_id,
        sc.conflict_severity
    FROM siting_conflicts sc
    JOIN siting_analyses sa ON 1=1
) subq
GROUP BY project_id;

-- ================== TRIGGERS: Auto-update updated_at ==================
CREATE OR REPLACE FUNCTION trigger_update_constraint_zones_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER constraint_zones_update_timestamp
BEFORE UPDATE ON constraint_zones
FOR EACH ROW
EXECUTE FUNCTION trigger_update_constraint_zones_updated_at();

-- ================== TRIGGERS: Auto-log zone changes ==================
CREATE OR REPLACE FUNCTION trigger_zone_history()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO zone_history (zone_id, change_type, old_values, new_values, changed_by, changed_at)
        VALUES (
            NEW.zone_id,
            'UPDATE',
            to_jsonb(OLD),
            to_jsonb(NEW),
            COALESCE(current_setting('app.user_id', true), 'system'),
            CURRENT_TIMESTAMP
        );
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO zone_history (zone_id, change_type, old_values, changed_by, change_reason, changed_at)
        VALUES (
            OLD.zone_id,
            'DELETE',
            to_jsonb(OLD),
            COALESCE(current_setting('app.user_id', true), 'system'),
            OLD.deleted_reason,
            CURRENT_TIMESTAMP
        );
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO zone_history (zone_id, change_type, new_values, changed_by, changed_at)
        VALUES (
            NEW.zone_id,
            'CREATE',
            to_jsonb(NEW),
            COALESCE(current_setting('app.user_id', true), 'system'),
            CURRENT_TIMESTAMP
        );
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER constraint_zones_history
AFTER INSERT OR UPDATE OR DELETE ON constraint_zones
FOR EACH ROW
EXECUTE FUNCTION trigger_zone_history();

-- ================== FUNCTION: Check siting conflicts ==================
CREATE OR REPLACE FUNCTION check_siting_against_zones(
    p_site_geometry geography,
    p_project_id UUID,
    p_zone_types TEXT[] DEFAULT NULL
)
RETURNS TABLE(
    zone_id UUID,
    zone_name VARCHAR,
    zone_type VARCHAR,
    zone_category VARCHAR,
    conflict_severity VARCHAR,
    distance_meters FLOAT8,
    overlap_area_sqm FLOAT8
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        cz.zone_id,
        cz.name,
        cz.zone_type,
        cz.zone_category,
        CASE
            WHEN ST_Contains(cz.geometry, p_site_geometry) THEN 'CONTAINED'
            WHEN ST_Intersects(cz.geometry, p_site_geometry) THEN 'INTERSECTS'
            WHEN ST_DWithin(cz.geometry, p_site_geometry, 1000) THEN 'NEAR'
            ELSE 'CLEAR'
        END::VARCHAR,
        ST_Distance(cz.geometry, p_site_geometry)::FLOAT8,
        ST_Area(ST_Intersection(cz.geometry::geometry, p_site_geometry::geometry))::FLOAT8
    FROM constraint_zones cz
    WHERE cz.project_id = p_project_id
        AND cz.zone_status = 'ACTIVE'
        AND (cz.effective_start_at IS NULL OR cz.effective_start_at <= CURRENT_TIMESTAMP)
        AND (cz.effective_end_at IS NULL OR cz.effective_end_at >= CURRENT_TIMESTAMP)
        AND (p_zone_types IS NULL OR cz.zone_type = ANY(p_zone_types))
        AND ST_DWithin(cz.geometry, p_site_geometry, 5000)  -- 5km search radius
    ORDER BY ST_Distance(cz.geometry, p_site_geometry) ASC;
END;
$$ LANGUAGE plpgsql;

-- ================== FUNCTION: Calculate zone coverage area ==================
CREATE OR REPLACE FUNCTION calculate_zone_coverage_area(p_project_id UUID)
RETURNS FLOAT8 AS $$
SELECT COALESCE(SUM(ST_Area(geometry::geography))::FLOAT8, 0)
FROM constraint_zones
WHERE project_id = p_project_id
    AND deleted_at IS NULL
    AND zone_status = 'ACTIVE';
$$ LANGUAGE SQL;

COMMIT;
