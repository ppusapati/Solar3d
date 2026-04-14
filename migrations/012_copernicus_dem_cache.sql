-- Copernicus DEM Download & Caching System
-- Enables persistent storage of elevation data to avoid repeated online calls

-- ============================================================
-- DEM Tile Cache (stores actual raster elevation data)
-- ============================================================

CREATE TABLE IF NOT EXISTS dem_tile_cache (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    terrain_layer_id UUID NOT NULL REFERENCES terrain_layers(id) ON DELETE CASCADE,
    
    -- Tile identification
    tile_row INTEGER NOT NULL,
    tile_col INTEGER NOT NULL,
    source_uri TEXT NOT NULL,  -- copernicus://dem/geotiff?... or other source
    
    -- Tile bounds (EPSG:4326)
    bounds geometry(POLYGON, 4326) NOT NULL,
    
    -- Elevation data
    elevation_data BYTEA NOT NULL,  -- Compressed raster data (GeoTIFF)
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    resolution_m DOUBLE PRECISION NOT NULL,
    
    -- Min/max cache
    min_elevation DOUBLE PRECISION,
    max_elevation DOUBLE PRECISION,
    
    -- Metadata
    source_timestamp TIMESTAMPTZ,  -- When the source GeoTIFF was generated
    ingested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,  -- For cache invalidation (NULL = never)
    
    -- Tracking
    checksum VARCHAR(64),  -- SHA256 of the GeoTIFF
    
    CONSTRAINT unique_tile_per_layer UNIQUE(terrain_layer_id, tile_row, tile_col)
);

CREATE INDEX idx_dem_cache_project_id ON dem_tile_cache(project_id);
CREATE INDEX idx_dem_cache_layer_id ON dem_tile_cache(terrain_layer_id);
CREATE INDEX idx_dem_cache_bounds ON dem_tile_cache USING GIST(bounds);
CREATE INDEX idx_dem_cache_expires_at ON dem_tile_cache(expires_at) WHERE expires_at IS NOT NULL;

-- ============================================================
-- Copernicus DEM Download Jobs
-- ============================================================

CREATE TABLE IF NOT EXISTS copernicus_dem_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Reference to the terrain layer this job is fulfilling
    terrain_layer_id UUID NOT NULL REFERENCES terrain_layers(id) ON DELETE CASCADE,
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    
    -- Job state
    status VARCHAR(50) NOT NULL DEFAULT 'pending',  -- pending, downloading, ingesting, completed, failed
    progress_percent INTEGER DEFAULT 0,
    
    -- Source details
    source_uri TEXT NOT NULL,  -- copernicus://dem/geotiff?bbox=min_x,min_y,max_x,max_y&resolution_m=30
    bounds geometry(POLYGON, 4326) NOT NULL,
    resolution_m DOUBLE PRECISION NOT NULL,
    
    -- Download details
    total_tiles_requested INTEGER DEFAULT 0,
    tiles_downloaded INTEGER DEFAULT 0,
    tiles_ingested INTEGER DEFAULT 0,
    tiles_failed INTEGER DEFAULT 0,
    
    -- Error tracking
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    
    -- Timing
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    next_retry_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_dem_jobs_layer_id ON copernicus_dem_jobs(terrain_layer_id);
CREATE INDEX idx_dem_jobs_project_id ON copernicus_dem_jobs(project_id);
CREATE INDEX idx_dem_jobs_status ON copernicus_dem_jobs(status);
CREATE INDEX idx_dem_jobs_next_retry ON copernicus_dem_jobs(next_retry_at) WHERE status = 'pending' AND retry_count < max_retries;

-- ============================================================
-- Copernicus DEM File Manifest
-- (tracks which GeoTIFF files have been downloaded to avoid re-fetching)
-- ============================================================

CREATE TABLE IF NOT EXISTS copernicus_dem_manifest (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- File identification
    copernicus_filename VARCHAR(255) NOT NULL UNIQUE,  -- e.g., Copernicus_DSM_10_N45_00_E008_00_DEM.tif
    source_url TEXT NOT NULL,  -- Full download URL
    
    -- Coverage bounds (EPSG:4326)
    bounds geometry(POLYGON, 4326) NOT NULL,
    
    -- File details
    file_size_bytes BIGINT,
    checksum VARCHAR(64),  -- SHA256
    
    -- Status
    status VARCHAR(50) NOT NULL DEFAULT 'pending',  -- pending, downloading, cached, failed
    local_cache_path VARCHAR(1024),  -- Path in local cache storage
    
    -- Timing
    downloaded_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_dem_manifest_status ON copernicus_dem_manifest(status);
CREATE INDEX idx_dem_manifest_bounds ON copernicus_dem_manifest USING GIST(bounds);
CREATE INDEX idx_dem_manifest_filename ON copernicus_dem_manifest(copernicus_filename);

-- ============================================================
-- Copernicus Source Coverage Index
-- (spatial index of available Copernicus DEM coverage)
-- ============================================================

CREATE TABLE IF NOT EXISTS copernicus_coverage_index (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Tile identification (aligned to Copernicus 1 arc-second tiles)
    latitude_tile DOUBLE PRECISION NOT NULL,      -- N45, N44, etc.
    longitude_tile DOUBLE PRECISION NOT NULL,     -- E008, E009, etc.
    
    -- Coverage bounds
    bounds geometry(POLYGON, 4326) NOT NULL,
    
    -- Metadata
    source_version VARCHAR(50) NOT NULL,  -- e.g., "DSM_10" for 10m resolution
    available BOOLEAN DEFAULT true,
    last_checked_at TIMESTAMPTZ,
    
    CONSTRAINT unique_copernicus_tile UNIQUE(latitude_tile, longitude_tile, source_version)
);

CREATE INDEX idx_copernicus_coverage_bounds ON copernicus_coverage_index USING GIST(bounds);
CREATE INDEX idx_copernicus_coverage_version ON copernicus_coverage_index(source_version);

-- ============================================================
-- Updated At Trigger for DEM Jobs
-- ============================================================

CREATE OR REPLACE FUNCTION update_dem_job_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_copernicus_dem_jobs_updated_at
    BEFORE UPDATE ON copernicus_dem_jobs
    FOR EACH ROW EXECUTE FUNCTION update_dem_job_updated_at();
