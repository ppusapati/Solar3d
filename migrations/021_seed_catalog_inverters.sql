-- ============================================================================
-- Catalog seed: Tier-1 inverters — SMA, Sungrow, SolarEdge, Huawei, plus
-- Fronius, Enphase, Fimer for geographic coverage. Mix of string + central
-- classes spanning residential (3 kW) to utility (300 kW).
-- ============================================================================
--
-- Values from each manufacturer's public datasheet (2024 editions).
-- Idempotent: uq_assets_manufacturer_model is created by 020_seed_catalog_modules.sql
-- so this file only runs the INSERT … ON CONFLICT DO UPDATE.
-- ============================================================================

INSERT INTO assets (
    name, manufacturer, model, category, dimensions, electrical_params
) VALUES

-- Sungrow — 2 inverters (utility string + residential hybrid)
(
    'Sungrow SG250HX 250 kW utility string',
    'Sungrow', 'SG250HX', 'inverter',
    '{"width_mm": 1051, "height_mm": 733, "depth_mm": 428, "weight_kg": 95}'::jsonb,
    '{
        "max_dc_input_kw": 275, "rated_ac_output_kw": 250, "max_ac_output_kw": 275,
        "max_input_voltage": 1500,
        "mppt_range_min_v": 500, "mppt_range_max_v": 1500,
        "mppt_count": 12, "max_strings_per_mppt": 2,
        "euro_efficiency": 0.989, "cec_efficiency": 0.988, "max_efficiency": 0.990,
        "startup_voltage": 540,
        "max_dc_input_current_a": 600, "max_output_current_a": 300,
        "rated_ac_output_w": 250000,
        "ac_phase_count": 3, "ac_frequency_hz": 50, "nominal_ac_voltage": 800,
        "night_consumption_w": 1.5,
        "operating_temp_min_c": -30, "operating_temp_max_c": 60,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),
(
    'Sungrow SH10RT 10 kW residential hybrid',
    'Sungrow', 'SH10RT', 'inverter',
    '{"width_mm": 480, "height_mm": 570, "depth_mm": 195, "weight_kg": 27.0}'::jsonb,
    '{
        "max_dc_input_kw": 15, "rated_ac_output_kw": 10, "max_ac_output_kw": 11,
        "max_input_voltage": 1000,
        "mppt_range_min_v": 200, "mppt_range_max_v": 1000,
        "mppt_count": 2, "max_strings_per_mppt": 1,
        "euro_efficiency": 0.976, "max_efficiency": 0.983,
        "startup_voltage": 180,
        "max_dc_input_current_a": 30, "max_output_current_a": 16,
        "rated_ac_output_w": 10000,
        "ac_phase_count": 3, "ac_frequency_hz": 50, "nominal_ac_voltage": 400,
        "night_consumption_w": 3,
        "operating_temp_min_c": -25, "operating_temp_max_c": 60,
        "topology": "transformer_less", "grid_type": "hybrid"
    }'::jsonb
),

-- SMA — 2 inverters
(
    'SMA Sunny Highpower PEAK3 150 kW',
    'SMA', 'SHP 150-20', 'inverter',
    '{"width_mm": 740, "height_mm": 750, "depth_mm": 400, "weight_kg": 84}'::jsonb,
    '{
        "max_dc_input_kw": 180, "rated_ac_output_kw": 150, "max_ac_output_kw": 150,
        "max_input_voltage": 1000,
        "mppt_range_min_v": 500, "mppt_range_max_v": 950,
        "mppt_count": 1, "max_strings_per_mppt": 14,
        "euro_efficiency": 0.982, "max_efficiency": 0.985,
        "startup_voltage": 500,
        "max_dc_input_current_a": 320, "max_output_current_a": 225,
        "rated_ac_output_w": 150000,
        "ac_phase_count": 3, "ac_frequency_hz": 50, "nominal_ac_voltage": 400,
        "night_consumption_w": 2,
        "operating_temp_min_c": -25, "operating_temp_max_c": 62,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),
(
    'SMA Sunny Boy 7.7-US residential',
    'SMA', 'SB7.7-1SP-US-41', 'inverter',
    '{"width_mm": 498, "height_mm": 531, "depth_mm": 181, "weight_kg": 26}'::jsonb,
    '{
        "max_dc_input_kw": 11.55, "rated_ac_output_kw": 7.7, "max_ac_output_kw": 7.7,
        "max_input_voltage": 600,
        "mppt_range_min_v": 100, "mppt_range_max_v": 550,
        "mppt_count": 3, "max_strings_per_mppt": 1,
        "euro_efficiency": 0.970, "cec_efficiency": 0.973, "max_efficiency": 0.975,
        "startup_voltage": 80,
        "max_dc_input_current_a": 20, "max_output_current_a": 32,
        "rated_ac_output_w": 7700,
        "ac_phase_count": 1, "ac_frequency_hz": 60, "nominal_ac_voltage": 240,
        "night_consumption_w": 1,
        "operating_temp_min_c": -40, "operating_temp_max_c": 60,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),

-- SolarEdge — 2 inverters (residential + C&I)
(
    'SolarEdge SE100K 100 kW C&I',
    'SolarEdge', 'SE100KUS', 'inverter',
    '{"width_mm": 770, "height_mm": 846, "depth_mm": 308, "weight_kg": 89}'::jsonb,
    '{
        "max_dc_input_kw": 135, "rated_ac_output_kw": 100, "max_ac_output_kw": 100,
        "max_input_voltage": 1500,
        "mppt_range_min_v": 850, "mppt_range_max_v": 1300,
        "mppt_count": 1, "max_strings_per_mppt": 12,
        "euro_efficiency": 0.988, "cec_efficiency": 0.988, "max_efficiency": 0.990,
        "startup_voltage": 850,
        "max_dc_input_current_a": 150, "max_output_current_a": 121,
        "rated_ac_output_w": 100000,
        "ac_phase_count": 3, "ac_frequency_hz": 60, "nominal_ac_voltage": 480,
        "night_consumption_w": 3,
        "operating_temp_min_c": -25, "operating_temp_max_c": 60,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),
(
    'SolarEdge SE11400H-US 11.4 kW residential HD-Wave',
    'SolarEdge', 'SE11400H-US000NNC2', 'inverter',
    '{"width_mm": 450, "height_mm": 370, "depth_mm": 174, "weight_kg": 21.8}'::jsonb,
    '{
        "max_dc_input_kw": 17.1, "rated_ac_output_kw": 11.4, "max_ac_output_kw": 11.4,
        "max_input_voltage": 480,
        "mppt_range_min_v": 300, "mppt_range_max_v": 480,
        "mppt_count": 1, "max_strings_per_mppt": 6,
        "euro_efficiency": 0.989, "cec_efficiency": 0.990, "max_efficiency": 0.995,
        "startup_voltage": 300,
        "max_dc_input_current_a": 40, "max_output_current_a": 47.5,
        "rated_ac_output_w": 11400,
        "ac_phase_count": 1, "ac_frequency_hz": 60, "nominal_ac_voltage": 240,
        "night_consumption_w": 2.5,
        "operating_temp_min_c": -40, "operating_temp_max_c": 60,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),

-- Huawei — 2 inverters
(
    'Huawei SUN2000-215KTL-H3 215 kW utility',
    'Huawei', 'SUN2000-215KTL-H3', 'inverter',
    '{"width_mm": 1048, "height_mm": 732, "depth_mm": 321, "weight_kg": 94}'::jsonb,
    '{
        "max_dc_input_kw": 280, "rated_ac_output_kw": 215, "max_ac_output_kw": 236,
        "max_input_voltage": 1500,
        "mppt_range_min_v": 500, "mppt_range_max_v": 1500,
        "mppt_count": 12, "max_strings_per_mppt": 2,
        "euro_efficiency": 0.989, "max_efficiency": 0.992,
        "startup_voltage": 500,
        "max_dc_input_current_a": 624, "max_output_current_a": 288,
        "rated_ac_output_w": 215000,
        "ac_phase_count": 3, "ac_frequency_hz": 50, "nominal_ac_voltage": 800,
        "night_consumption_w": 1.5,
        "operating_temp_min_c": -30, "operating_temp_max_c": 60,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),
(
    'Huawei SUN2000-100KTL-M1 100 kW C&I',
    'Huawei', 'SUN2000-100KTL-M1', 'inverter',
    '{"width_mm": 1035, "height_mm": 700, "depth_mm": 365, "weight_kg": 90}'::jsonb,
    '{
        "max_dc_input_kw": 130, "rated_ac_output_kw": 100, "max_ac_output_kw": 110,
        "max_input_voltage": 1100,
        "mppt_range_min_v": 200, "mppt_range_max_v": 1000,
        "mppt_count": 10, "max_strings_per_mppt": 2,
        "euro_efficiency": 0.987, "max_efficiency": 0.989,
        "startup_voltage": 200,
        "max_dc_input_current_a": 260, "max_output_current_a": 160,
        "rated_ac_output_w": 100000,
        "ac_phase_count": 3, "ac_frequency_hz": 50, "nominal_ac_voltage": 400,
        "night_consumption_w": 1.5,
        "operating_temp_min_c": -25, "operating_temp_max_c": 60,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),

-- Fronius, Enphase, Fimer — geographic + residential coverage
(
    'Fronius Tauro ECO 99-3-D 99 kW',
    'Fronius', 'Tauro ECO 99-3-D', 'inverter',
    '{"width_mm": 970, "height_mm": 1312, "depth_mm": 526, "weight_kg": 90}'::jsonb,
    '{
        "max_dc_input_kw": 150, "rated_ac_output_kw": 99, "max_ac_output_kw": 99,
        "max_input_voltage": 1000,
        "mppt_range_min_v": 580, "mppt_range_max_v": 950,
        "mppt_count": 3, "max_strings_per_mppt": 8,
        "euro_efficiency": 0.985, "max_efficiency": 0.989,
        "startup_voltage": 500,
        "max_dc_input_current_a": 240, "max_output_current_a": 143,
        "rated_ac_output_w": 99000,
        "ac_phase_count": 3, "ac_frequency_hz": 50, "nominal_ac_voltage": 400,
        "night_consumption_w": 10,
        "operating_temp_min_c": -25, "operating_temp_max_c": 65,
        "topology": "transformer_less", "grid_type": "grid_tied"
    }'::jsonb
),
(
    'Enphase IQ8M microinverter',
    'Enphase', 'IQ8M-72-2-US', 'inverter',
    '{"width_mm": 212, "height_mm": 175, "depth_mm": 30, "weight_kg": 1.1}'::jsonb,
    '{
        "max_dc_input_kw": 0.4, "rated_ac_output_kw": 0.33, "max_ac_output_kw": 0.33,
        "max_input_voltage": 60,
        "mppt_range_min_v": 27, "mppt_range_max_v": 48,
        "mppt_count": 1, "max_strings_per_mppt": 1,
        "cec_efficiency": 0.970, "max_efficiency": 0.974,
        "startup_voltage": 22,
        "max_dc_input_current_a": 10.5, "max_output_current_a": 1.38,
        "rated_ac_output_w": 330,
        "ac_phase_count": 1, "ac_frequency_hz": 60, "nominal_ac_voltage": 240,
        "night_consumption_w": 0.05,
        "operating_temp_min_c": -40, "operating_temp_max_c": 65,
        "topology": "hf_transformer", "grid_type": "grid_tied"
    }'::jsonb
)

ON CONFLICT (manufacturer, model) DO UPDATE
    SET name              = EXCLUDED.name,
        category          = EXCLUDED.category,
        dimensions        = EXCLUDED.dimensions,
        electrical_params = EXCLUDED.electrical_params;
