-- ============================================================================
-- Catalog seed: Single-axis trackers from Nextracker, Array Technologies,
-- PV Hardware — the three manufacturers that own ~70 % of global utility-scale
-- tracker shipments. All specs are at datasheet baseline; site engineering
-- adjusts GCR, stow wind speed, and string length for each project.
-- ============================================================================

INSERT INTO assets (
    name, manufacturer, model, category, dimensions, electrical_params
) VALUES

-- Nextracker NX Horizon — most deployed utility tracker globally
(
    'Nextracker NX Horizon 2P 1500 V',
    'Nextracker', 'NX Horizon 2P', 'tracker',
    '{
        "width_mm": 2340, "height_mm": 120000, "depth_mm": 400, "weight_kg": 4200
    }'::jsonb,
    -- Electrical params for trackers are operational envelope + drive specs.
    -- Voltage fields indicate DC string compatibility; current fields indicate
    -- per-row panel count capacity.
    '{
        "max_system_voltage": 1500,
        "max_strings_per_mppt": 2
    }'::jsonb
),
(
    'Nextracker NX Horizon-XTR terrain-following',
    'Nextracker', 'NX Horizon-XTR', 'tracker',
    '{
        "width_mm": 2340, "height_mm": 110000, "depth_mm": 400, "weight_kg": 4500
    }'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_strings_per_mppt": 2
    }'::jsonb
),

-- Array Technologies DuraTrack — US market leader
(
    'Array Technologies DuraTrack HZ v3',
    'Array Technologies', 'DuraTrack HZ v3', 'tracker',
    '{
        "width_mm": 2340, "height_mm": 115000, "depth_mm": 450, "weight_kg": 4800
    }'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_strings_per_mppt": 2
    }'::jsonb
),
(
    'Array Technologies OmniTrack',
    'Array Technologies', 'OmniTrack', 'tracker',
    '{
        "width_mm": 2340, "height_mm": 108000, "depth_mm": 450, "weight_kg": 4600
    }'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_strings_per_mppt": 2
    }'::jsonb
),

-- PV Hardware Axone — premium independent-row tracker
(
    'PV Hardware Axone Duo',
    'PV Hardware', 'Axone Duo', 'tracker',
    '{
        "width_mm": 2340, "height_mm": 90000, "depth_mm": 380, "weight_kg": 3900
    }'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_strings_per_mppt": 2
    }'::jsonb
),
(
    'PV Hardware Axone Triple',
    'PV Hardware', 'Axone Triple', 'tracker',
    '{
        "width_mm": 2340, "height_mm": 132000, "depth_mm": 380, "weight_kg": 5600
    }'::jsonb,
    '{
        "max_system_voltage": 1500,
        "max_strings_per_mppt": 2
    }'::jsonb
)

ON CONFLICT (manufacturer, model) DO UPDATE
    SET name              = EXCLUDED.name,
        category          = EXCLUDED.category,
        dimensions        = EXCLUDED.dimensions,
        electrical_params = EXCLUDED.electrical_params;
