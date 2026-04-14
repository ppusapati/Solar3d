-- 018_lod400_checklist.sql
-- Creates the lod400_checklist_results table for persisting scored LOD 400 results.
-- Also seeds the asset library with protection device catalog entries per IEC 60255.
--
-- Required by Step 16: LOD 400 checklist model and scoring service.
-- Also satisfies Pre-Implementation Locked Decision #3 (protection device asset seed).
-- Note: Locked Decision specified migration 016 for this seed; 016 was consumed by
--       workflow_state columns, so the seed is placed here per the deviation policy
--       (Class A local containment — same phase, no contract change).
--
-- Rollback strategy:
--   DROP TABLE IF EXISTS lod400_checklist_results;
--   DELETE FROM assets WHERE category IN ('protection_relay', 'circuit_breaker', 'fuse_disconnect');
--
-- Lock safety: CREATE TABLE IF NOT EXISTS avoids conflicts on re-run.
--              INSERT rows are idempotent through WHERE NOT EXISTS guards.

-- ============================================================
-- LOD 400 Checklist Results
-- ============================================================
-- Stores the output of each LOD 400 scoring run. Multiple runs per
-- layout are allowed; the most recent result is the authoritative gate.
CREATE TABLE IF NOT EXISTS lod400_checklist_results (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id            UUID NOT NULL,
    layout_id             UUID NOT NULL,
    electrical_network_id UUID,
    scored_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_lod400_ready       BOOLEAN NOT NULL DEFAULT FALSE,
    aggregate_score       DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    mandatory_blockers    JSONB NOT NULL DEFAULT '[]'::jsonb,
    checklist_items       JSONB NOT NULL DEFAULT '[]'::jsonb,
    scored_by_actor_id    VARCHAR(255) NOT NULL DEFAULT ''
);

CREATE INDEX IF NOT EXISTS idx_lod400_results_project
    ON lod400_checklist_results (project_id);

CREATE INDEX IF NOT EXISTS idx_lod400_results_layout
    ON lod400_checklist_results (layout_id, scored_at DESC);

-- ============================================================
-- Protection Device Asset Catalog (IEC 60255 class designations)
-- ============================================================
-- Categories: protection_relay, circuit_breaker, fuse_disconnect
-- Per IMPLEMENTATION_PLAN.md Locked Decision #3.

-- PROTECTION_RELAY — IEC 60255 compliant feeder and differential relays.
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'Feeder Protection Relay', 'Schneider Electric', 'MiCOM P14N', 'protection_relay',
       200, 177, 250, 3.5,
       '{"widthMm":200,"heightMm":177,"depthMm":250}'::jsonb,
       '{"standard":"IEC 60255","functionCodes":["50","51","50N","51N"],"voltageRangeV":[100,250],"currentRangeA":[1,5]}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'MiCOM P14N' AND category = 'protection_relay');

INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'Differential Protection Relay', 'ABB', 'RED670', 'protection_relay',
       483, 266, 286, 15.0,
       '{"widthMm":483,"heightMm":266,"depthMm":286}'::jsonb,
       '{"standard":"IEC 60255","functionCodes":["87T","87L","21","67N"],"voltageRangeV":[100,250],"currentRangeA":[1,5]}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'RED670' AND category = 'protection_relay');

INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'Distance Protection Relay', 'Siemens', 'SIPROTEC 7SA87', 'protection_relay',
       483, 266, 280, 12.5,
       '{"widthMm":483,"heightMm":266,"depthMm":280}'::jsonb,
       '{"standard":"IEC 60255","functionCodes":["21","21N","67","67N","85"],"voltageRangeV":[100,250],"currentRangeA":[1,5]}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'SIPROTEC 7SA87' AND category = 'protection_relay');

-- CIRCUIT_BREAKER — IEC 60255 protection coordination grade.
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'LV Circuit Breaker 630A', 'Eaton', 'IZM91-630A', 'circuit_breaker',
       140, 270, 103, 4.2,
       '{"widthMm":140,"heightMm":270,"depthMm":103}'::jsonb,
       '{"standard":"IEC 60947-2","ratedCurrentA":630,"breakingCapacityKA":50,"voltageV":690,"poles":3}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'IZM91-630A' AND category = 'circuit_breaker');

INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'MV Circuit Breaker 1250A', 'ABB', 'VD4-12-1250', 'circuit_breaker',
       450, 800, 450, 48.0,
       '{"widthMm":450,"heightMm":800,"depthMm":450}'::jsonb,
       '{"standard":"IEC 62271-100","ratedCurrentA":1250,"breakingCapacityKA":25,"voltageKV":12,"poles":3}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'VD4-12-1250' AND category = 'circuit_breaker');

INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'MV Circuit Breaker 2500A', 'Schneider Electric', 'NM8N-2500', 'circuit_breaker',
       550, 900, 500, 65.0,
       '{"widthMm":550,"heightMm":900,"depthMm":500}'::jsonb,
       '{"standard":"IEC 62271-100","ratedCurrentA":2500,"breakingCapacityKA":40,"voltageKV":12,"poles":3}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'NM8N-2500' AND category = 'circuit_breaker');

-- FUSE_DISCONNECT — IEC 60255 fault isolation rated.
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'HV Fuse Disconnect 100A', 'Schneider Electric', 'DFN-12-100', 'fuse_disconnect',
       180, 350, 120, 2.8,
       '{"widthMm":180,"heightMm":350,"depthMm":120}'::jsonb,
       '{"standard":"IEC 60282-1","ratedCurrentA":100,"voltageKV":12,"breakingCapacityKA":16,"fusedType":"HRC"}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'DFN-12-100' AND category = 'fuse_disconnect');

INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'HV Fuse Disconnect 200A', 'ABB', 'OFAF-200', 'fuse_disconnect',
       200, 400, 130, 3.5,
       '{"widthMm":200,"heightMm":400,"depthMm":130}'::jsonb,
       '{"standard":"IEC 60282-1","ratedCurrentA":200,"voltageKV":12,"breakingCapacityKA":25,"fusedType":"HRC"}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'OFAF-200' AND category = 'fuse_disconnect');

INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params)
SELECT 'DC Disconnect Switch 800V', 'Mersen', 'GP-PV-800V', 'fuse_disconnect',
       160, 200, 80, 1.2,
       '{"widthMm":160,"heightMm":200,"depthMm":80}'::jsonb,
       '{"standard":"IEC 60947-3","ratedCurrentA":32,"voltageV":800,"applicationDC":true,"ipRating":"IP65"}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM assets WHERE model = 'GP-PV-800V' AND category = 'fuse_disconnect');
