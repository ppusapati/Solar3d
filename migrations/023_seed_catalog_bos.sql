-- ============================================================================
-- Catalog seed: Balance-of-system (BOS) components — combiner boxes,
-- transformers, PV DC cables, and string fuses. These define the constraints
-- for stringing, voltage-drop calculations, and electrical validation.
-- ============================================================================
--
-- Cable dimensions use a non-standard key set: `cross_section_mm2`,
-- `weight_kg_per_m`, and `jacket_od_mm`. Downstream consumers should check
-- asset.category before attempting to read width/height.
-- ============================================================================

-- Extend asset_category enum to cover the new categories this migration
-- introduces. Postgres ADD VALUE IF NOT EXISTS is idempotent, so re-running
-- this migration is safe.
ALTER TYPE asset_category ADD VALUE IF NOT EXISTS 'combiner';
ALTER TYPE asset_category ADD VALUE IF NOT EXISTS 'fuse';

INSERT INTO assets (
    name, manufacturer, model, category, dimensions, electrical_params
) VALUES

-- ===== Combiner boxes =====
(
    'Shoals Big Lead Assembly 1500V / 400A',
    'Shoals Technologies', 'BLA-1500-400', 'combiner',
    '{"width_mm": 800, "height_mm": 600, "depth_mm": 300, "weight_kg": 48}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 400,
        "max_strings_per_mppt": 16,
        "series_fuse_rating_a": 30
    }'::jsonb
),
(
    'SolarBOS eCombiner 1500V / 200A',
    'SolarBOS', 'eCombiner-1500-200', 'combiner',
    '{"width_mm": 660, "height_mm": 500, "depth_mm": 260, "weight_kg": 32}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 200,
        "max_strings_per_mppt": 12,
        "series_fuse_rating_a": 25
    }'::jsonb
),
(
    'Bentek Power 1500V Gen3 Combiner',
    'Bentek Power', 'Gen3-1500-300', 'combiner',
    '{"width_mm": 760, "height_mm": 560, "depth_mm": 280, "weight_kg": 41}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 300,
        "max_strings_per_mppt": 16,
        "series_fuse_rating_a": 30
    }'::jsonb
),

-- ===== Transformers =====
(
    'Eaton 2.5 MVA pad-mount medium-voltage transformer',
    'Eaton', 'PMT-2500-34.5kV-0.8kV', 'transformer',
    '{"width_mm": 2100, "height_mm": 1850, "depth_mm": 2000, "weight_kg": 5400}'::jsonb,
    '{
        "kva_rating": 2500, "rated_kva": 2500,
        "primary_voltage": 34500, "secondary_voltage": 800,
        "impedance_percent": 5.75
    }'::jsonb
),
(
    'ABB 1.0 MVA pad-mount MV transformer',
    'ABB', 'PMT-1000-12.47kV-0.48kV', 'transformer',
    '{"width_mm": 1800, "height_mm": 1700, "depth_mm": 1700, "weight_kg": 3200}'::jsonb,
    '{
        "kva_rating": 1000, "rated_kva": 1000,
        "primary_voltage": 12470, "secondary_voltage": 480,
        "impedance_percent": 5.75
    }'::jsonb
),
(
    'Siemens 5.0 MVA MV transformer',
    'Siemens', 'PMT-5000-34.5kV-0.8kV', 'transformer',
    '{"width_mm": 2400, "height_mm": 2000, "depth_mm": 2200, "weight_kg": 8800}'::jsonb,
    '{
        "kva_rating": 5000, "rated_kva": 5000,
        "primary_voltage": 34500, "secondary_voltage": 800,
        "impedance_percent": 6.25
    }'::jsonb
),

-- ===== PV DC cables =====
-- dimensions: cross_section_mm2 is the conductor CSA; jacket_od_mm is outer
-- diameter including insulation. weight_kg_per_m is the per-meter mass.
-- electrical_params: max_system_voltage is the rating, max_dc_input_current_a
-- is the current-carrying capacity at 30 °C free-air (IEC 60364-5-52).
(
    'Prysmian H1Z2Z2-K 4 mm² PV cable',
    'Prysmian', 'H1Z2Z2-K-4mm2', 'cable',
    '{"cross_section_mm2": 4, "jacket_od_mm": 5.8, "weight_kg_per_m": 0.060}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 55
    }'::jsonb
),
(
    'Prysmian H1Z2Z2-K 6 mm² PV cable',
    'Prysmian', 'H1Z2Z2-K-6mm2', 'cable',
    '{"cross_section_mm2": 6, "jacket_od_mm": 6.8, "weight_kg_per_m": 0.085}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 70
    }'::jsonb
),
(
    'Prysmian H1Z2Z2-K 10 mm² PV cable',
    'Prysmian', 'H1Z2Z2-K-10mm2', 'cable',
    '{"cross_section_mm2": 10, "jacket_od_mm": 8.0, "weight_kg_per_m": 0.130}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 96
    }'::jsonb
),
(
    'Nexans EnergyFlex 16 mm² PV cable',
    'Nexans', 'EnergyFlex-PV-16mm2', 'cable',
    '{"cross_section_mm2": 16, "jacket_od_mm": 9.6, "weight_kg_per_m": 0.200}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 130
    }'::jsonb
),

-- ===== String fuses =====
-- electrical_params.max_dc_input_current_a is the continuous fuse rating;
-- max_system_voltage is the interrupt rating.
(
    'Mersen HPVS 15A 1500V string fuse',
    'Mersen', 'HP15M15A-1500', 'fuse',
    '{"width_mm": 10.3, "height_mm": 38, "depth_mm": 10.3, "weight_kg": 0.015}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 15,
        "series_fuse_rating_a": 15
    }'::jsonb
),
(
    'Mersen HPVS 20A 1500V string fuse',
    'Mersen', 'HP15M20A-1500', 'fuse',
    '{"width_mm": 10.3, "height_mm": 38, "depth_mm": 10.3, "weight_kg": 0.015}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 20,
        "series_fuse_rating_a": 20
    }'::jsonb
),
(
    'Littelfuse SPF 25A 1500V string fuse',
    'Littelfuse', 'SPF-015-25A', 'fuse',
    '{"width_mm": 10.3, "height_mm": 38, "depth_mm": 10.3, "weight_kg": 0.015}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 25,
        "series_fuse_rating_a": 25
    }'::jsonb
),
(
    'Littelfuse SPF 30A 1500V string fuse',
    'Littelfuse', 'SPF-015-30A', 'fuse',
    '{"width_mm": 10.3, "height_mm": 38, "depth_mm": 10.3, "weight_kg": 0.015}'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_dc_input_current_a": 30,
        "series_fuse_rating_a": 30
    }'::jsonb
)

ON CONFLICT (manufacturer, model) DO UPDATE
    SET name              = EXCLUDED.name,
        category          = EXCLUDED.category,
        dimensions        = EXCLUDED.dimensions,
        electrical_params = EXCLUDED.electrical_params;
