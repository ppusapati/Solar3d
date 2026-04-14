-- 019_twin_service.sql
-- Creates tables for the digital twin service: digital_twins, asset_identities,
-- and sensor_readings (IEC 61724-1 telemetry).
--
-- Telemetry storage: Option A per Pre-Implementation Locked Decision #2.
-- sensor_readings is a regular PostgreSQL table with a composite index on
-- (twin_id, recorded_at DESC).  The DO block below attempts to install
-- TimescaleDB and convert the table to a hypertable; if the extension is
-- unavailable (local dev / PostGIS-only image), the standard table remains
-- intact and queries still work correctly via the B-tree index.
--
-- Rollback strategy:
--   DROP TABLE IF EXISTS sensor_readings;
--   DROP TABLE IF EXISTS asset_identities;
--   DROP TABLE IF EXISTS digital_twins;
--
-- Lock safety:
--   All DDL uses CREATE TABLE IF NOT EXISTS; no column changes to existing tables.
--   New NOT NULL columns use DEFAULT values per zero-downtime migration rules.

-- ============================================================
-- digital_twins
-- ============================================================
CREATE TABLE IF NOT EXISTS digital_twins (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id              UUID NOT NULL,
    layout_id               UUID NOT NULL,
    electrical_network_id   UUID NOT NULL,
    transmission_route_id   UUID NOT NULL,
    approved_revision_id    TEXT NOT NULL DEFAULT '',
    status                  VARCHAR(32) NOT NULL DEFAULT 'provisioning',
    -- operational_state fields stored inline for fast reads
    power_output_kw         DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    availability_percent    DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    active_fault_count      INT NOT NULL DEFAULT 0,
    health_score            DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    last_inspected_at       TIMESTAMPTZ,
    provisioned_by_actor_id TEXT NOT NULL DEFAULT '',
    last_telemetry_at       TIMESTAMPTZ,
    decommissioned_at       TIMESTAMPTZ,
    asset_identity_link_count INT NOT NULL DEFAULT 0,
    metadata_json           TEXT NOT NULL DEFAULT '',
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_digital_twins_project
    ON digital_twins (project_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_digital_twins_status
    ON digital_twins (status)
    WHERE status != 'decommissioned';

-- ============================================================
-- asset_identities
-- ============================================================
CREATE TABLE IF NOT EXISTS asset_identities (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id              UUID NOT NULL,
    twin_id                 UUID NOT NULL REFERENCES digital_twins(id) ON DELETE CASCADE,
    design_asset_id         TEXT NOT NULL,
    design_asset_type       VARCHAR(64) NOT NULL DEFAULT 'unspecified',
    physical_serial_number  TEXT NOT NULL DEFAULT '',
    manufacturer            TEXT NOT NULL DEFAULT '',
    model                   TEXT NOT NULL DEFAULT '',
    installation_date       TIMESTAMPTZ,
    commissioning_reference TEXT NOT NULL DEFAULT '',
    installation_notes      TEXT NOT NULL DEFAULT '',
    linked_by_actor_id      TEXT NOT NULL DEFAULT '',
    linked_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Prevent duplicate design asset links within the same twin
    CONSTRAINT uq_asset_identity_twin_design UNIQUE (twin_id, design_asset_id)
);

CREATE INDEX IF NOT EXISTS idx_asset_identities_twin
    ON asset_identities (twin_id);

CREATE INDEX IF NOT EXISTS idx_asset_identities_project
    ON asset_identities (project_id);

CREATE INDEX IF NOT EXISTS idx_asset_identities_design_asset
    ON asset_identities (design_asset_id);

-- ============================================================
-- sensor_readings
-- ============================================================
CREATE TABLE IF NOT EXISTS sensor_readings (
    id                  UUID NOT NULL DEFAULT gen_random_uuid(),
    twin_id             UUID NOT NULL,
    sensor_id           TEXT NOT NULL DEFAULT '',
    asset_identity_id   TEXT NOT NULL DEFAULT '',
    metric              VARCHAR(64) NOT NULL,
    value               DOUBLE PRECISION NOT NULL,
    unit                TEXT NOT NULL DEFAULT '',
    quality             VARCHAR(16) NOT NULL DEFAULT 'good',
    recorded_at         TIMESTAMPTZ NOT NULL,
    ingested_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY         (id, recorded_at)
);

-- Composite index used by GetLatestReadings and ListReadings
CREATE INDEX IF NOT EXISTS idx_sensor_readings_twin_recorded
    ON sensor_readings (twin_id, metric, recorded_at DESC);

CREATE INDEX IF NOT EXISTS idx_sensor_readings_recorded
    ON sensor_readings (recorded_at DESC);

-- ============================================================
-- TimescaleDB hypertable conversion (best-effort)
-- If the extension is not available this block silently continues
-- with the standard PostgreSQL table, which works correctly.
-- ============================================================
DO $$
BEGIN
    CREATE EXTENSION IF NOT EXISTS timescaledb;
    IF NOT EXISTS (
        SELECT 1 FROM timescaledb_information.hypertables
         WHERE hypertable_name = 'sensor_readings'
    ) THEN
        PERFORM create_hypertable('sensor_readings', 'recorded_at', chunk_time_interval => INTERVAL '7 days');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- TimescaleDB not installed; sensor_readings remains a standard table.
        NULL;
END;
$$;
