-- Migration 015: KML Ingestion Schema
-- Purpose: Add tables for KML/KMZ upload tracking and imported geometry storage

-- ============================================================================
-- KML Upload Jobs Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS kml_upload_jobs (
    id BIGSERIAL PRIMARY KEY,
    upload_job_id UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    
    -- File metadata
    file_name VARCHAR(255) NOT NULL,
    file_size_bytes BIGINT NOT NULL,
    file_hash VARCHAR(64), -- SHA256 of file for deduplication
    
    -- CRS information
    source_crs_epsg INT DEFAULT 4326, -- Detected CRS from KML
    target_crs_epsg INT DEFAULT 4326, -- Where geometries are normalized to
    
    -- Job tracking
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING', -- PENDING, PROCESSING, COMPLETED, FAILED
    features_total INT DEFAULT 0, -- Total features in file
    features_processed INT DEFAULT 0, -- Features successfully parsed
    geometries_imported INT DEFAULT 0, -- Geometries stored to DB
    
    -- Error tracking
    error_message TEXT,
    parse_errors JSONB, -- Array of parsing errors with details
    
    -- Timestamps
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    
    -- Metadata for traceability
    project_id UUID, -- Optional project association
    user_id UUID, -- User who uploaded file
    tags JSONB DEFAULT '{}', -- Additional metadata tags
    
    -- Indexes
    CONSTRAINT kml_upload_jobs_status_check CHECK (
        status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED')
    )
);

CREATE INDEX idx_kml_upload_jobs_status ON kml_upload_jobs(status);
CREATE INDEX idx_kml_upload_jobs_project_id ON kml_upload_jobs(project_id);
CREATE INDEX idx_kml_upload_jobs_created_at ON kml_upload_jobs(created_at DESC);
CREATE INDEX idx_kml_upload_jobs_file_hash ON kml_upload_jobs(file_hash) WHERE file_hash IS NOT NULL;

-- ============================================================================
-- Imported Geometries Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS imported_geometries (
    id BIGSERIAL PRIMARY KEY,
    geometry_id UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    
    -- Association
    upload_job_id UUID NOT NULL REFERENCES kml_upload_jobs(upload_job_id) ON DELETE CASCADE,
    
    -- Feature metadata from KML
    feature_name VARCHAR(255),
    feature_description TEXT,
    feature_properties JSONB, -- All KML properties as key-value pairs
    
    -- Geometry information
    geometry_type VARCHAR(50) NOT NULL, -- POINT, LINESTRING, POLYGON, MULTIPOLYGON
    geometry_source_crs INT DEFAULT 4326, -- Original CRS from KML
    
    -- PostGIS geometry column (always normalized to 4326/WGS84)
    geometry geography(Geometry, 4326) NOT NULL,
    
    -- Bounding box for quick spatial queries
    bbox_min_x DOUBLE PRECISION NOT NULL,
    bbox_min_y DOUBLE PRECISION NOT NULL,
    bbox_max_x DOUBLE PRECISION NOT NULL,
    bbox_max_y DOUBLE PRECISION NOT NULL,
    
    -- Geometry validation metadata
    geometry_hash VARCHAR(64), -- SHA256 of geometry for deduplication
    is_valid BOOLEAN DEFAULT TRUE,
    validation_errors TEXT,
    
    -- Timestamps
    imported_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Soft delete for logical deletion without data loss
    deleted_at TIMESTAMP
);

CREATE INDEX idx_imported_geometries_upload_job_id ON imported_geometries(upload_job_id);
CREATE INDEX idx_imported_geometries_geometry_type ON imported_geometries(geometry_type);
CREATE INDEX idx_imported_geometries_geometry_gist ON imported_geometries USING GIST(geometry);
CREATE INDEX idx_imported_geometries_bbox ON imported_geometries(bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y);
CREATE INDEX idx_imported_geometries_imported_at ON imported_geometries(imported_at DESC);
CREATE INDEX idx_imported_geometries_geometry_hash ON imported_geometries(geometry_hash) WHERE geometry_hash IS NOT NULL;
CREATE INDEX idx_imported_geometries_not_deleted ON imported_geometries(deleted_at) WHERE deleted_at IS NULL;

-- ============================================================================
-- Geometry Collections Table (for organizing imported geometries)
-- ============================================================================
CREATE TABLE IF NOT EXISTS geometry_collections (
    id BIGSERIAL PRIMARY KEY,
    collection_id UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    
    -- Metadata
    name VARCHAR(255) NOT NULL,
    description TEXT,
    
    -- Association
    project_id UUID,
    created_by UUID,
    
    -- Timestamps
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_geometry_collections_project_id ON geometry_collections(project_id);
CREATE INDEX idx_geometry_collections_created_at ON geometry_collections(created_at DESC);

-- ============================================================================
-- Junction table: Geometries to Collections
-- ============================================================================
CREATE TABLE IF NOT EXISTS geometry_collection_items (
    id BIGSERIAL PRIMARY KEY,
    collection_id UUID NOT NULL REFERENCES geometry_collections(collection_id) ON DELETE CASCADE,
    geometry_id UUID NOT NULL REFERENCES imported_geometries(geometry_id) ON DELETE CASCADE,
    
    -- Sort order for UI rendering
    sort_order INT DEFAULT 0,
    
    -- Timestamps
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(collection_id, geometry_id)
);

CREATE INDEX idx_geometry_collection_items_collection_id ON geometry_collection_items(collection_id);
CREATE INDEX idx_geometry_collection_items_geometry_id ON geometry_collection_items(geometry_id);

-- ============================================================================
-- Audit Log for KML Operations
-- ============================================================================
CREATE TABLE IF NOT EXISTS kml_audit_log (
    id BIGSERIAL PRIMARY KEY,
    
    -- Operation details
    operation VARCHAR(50) NOT NULL, -- UPLOAD, PARSE, IMPORT, DELETE, etc.
    upload_job_id UUID,
    geometry_id UUID,
    
    -- Change tracking
    old_values JSONB,
    new_values JSONB,
    
    -- User and timestamp
    user_id UUID,
    performed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Details
    status VARCHAR(50), -- SUCCESS, FAILED
    error_message TEXT
);

CREATE INDEX idx_kml_audit_log_upload_job_id ON kml_audit_log(upload_job_id);
CREATE INDEX idx_kml_audit_log_operation ON kml_audit_log(operation);
CREATE INDEX idx_kml_audit_log_performed_at ON kml_audit_log(performed_at DESC);

-- ============================================================================
-- Helper view: Recent successful imports
-- ============================================================================
CREATE VIEW v_recent_successful_imports AS
SELECT 
    j.upload_job_id,
    j.file_name,
    j.source_crs_epsg,
    COUNT(g.id) as geometry_count,
    j.created_at,
    j.completed_at
FROM kml_upload_jobs j
LEFT JOIN imported_geometries g ON g.upload_job_id = j.upload_job_id AND g.deleted_at IS NULL
WHERE j.status = 'COMPLETED'
GROUP BY j.id, j.upload_job_id, j.file_name, j.source_crs_epsg, j.created_at, j.completed_at
ORDER BY j.completed_at DESC;

-- ============================================================================
-- Drop statements (for rollback, commented out by default)
-- ============================================================================
-- DROP VIEW IF EXISTS v_recent_successful_imports;
-- DROP TABLE IF EXISTS kml_audit_log;
-- DROP TABLE IF EXISTS geometry_collection_items;
-- DROP TABLE IF EXISTS geometry_collections;
-- DROP TABLE IF EXISTS imported_geometries;
-- DROP TABLE IF EXISTS kml_upload_jobs;
