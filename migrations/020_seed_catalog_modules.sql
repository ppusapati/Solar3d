-- ============================================================================
-- Catalog seed: Tier-1 PV modules — top 20 across Trina, Jinko, LONGi, JA,
-- Canadian Solar + assorted premium.
-- ============================================================================
--
-- Values sourced from each manufacturer's public datasheet (2024 editions where
-- available). Fields populated into the `electrical_params` and `dimensions`
-- JSONB columns match the asset-service domain shape — see
-- services/asset-service/internal/domain/models.go.
--
-- Idempotent: safe to re-run. The unique index below is added once; thereafter
-- INSERT … ON CONFLICT DO UPDATE refreshes values when a datasheet changes.
-- ============================================================================

-- ---- Prerequisite: enforce uniqueness on (manufacturer, model) ------------
CREATE UNIQUE INDEX IF NOT EXISTS uq_assets_manufacturer_model
  ON assets (manufacturer, model);

-- ---- Modules --------------------------------------------------------------
-- Keep rows sorted by (manufacturer, rated power desc) for easier review in
-- future migrations.

INSERT INTO assets (
    name, manufacturer, model, category, dimensions, electrical_params
) VALUES

-- Trina Solar — 3 modules
(
    'Trina Vertex+ TSM-NEG19RC.20 605 W',
    'Trina Solar', 'TSM-NEG19RC.20', 'panel',
    '{
        "width_mm": 2384, "height_mm": 1134, "depth_mm": 33, "weight_kg": 32.6,
        "cell_count": 144, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 605, "voc_v": 41.7, "isc_a": 18.35,
        "vmp_v": 35.1, "imp_a": 17.23,
        "efficiency_percent": 22.38,
        "temp_coeff_pmax": -0.30, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.048,
        "noct_c": 43, "bifacial_factor": 0.80,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 144, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Trina Vertex TSM-DE21 580 W',
    'Trina Solar', 'TSM-DE21-580', 'panel',
    '{
        "width_mm": 2279, "height_mm": 1134, "depth_mm": 35, "weight_kg": 31.8,
        "cell_count": 144, "cell_technology": "mono_perc",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 580, "voc_v": 52.8, "isc_a": 13.94,
        "vmp_v": 43.3, "imp_a": 13.40,
        "efficiency_percent": 22.50,
        "temp_coeff_pmax": -0.34, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.040,
        "noct_c": 43, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 144, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Trina Vertex S+ TSM-NEG9R.28 430 W',
    'Trina Solar', 'TSM-NEG9R.28', 'panel',
    '{
        "width_mm": 1762, "height_mm": 1134, "depth_mm": 30, "weight_kg": 21.5,
        "cell_count": 108, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 430, "voc_v": 39.4, "isc_a": 13.80,
        "vmp_v": 33.2, "imp_a": 12.96,
        "efficiency_percent": 22.00,
        "temp_coeff_pmax": -0.30, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.040,
        "noct_c": 43, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),

-- Jinko Solar — 3 modules
(
    'Jinko Tiger Neo 78HL4-V 620 W',
    'JinkoSolar', 'JKM620N-78HL4-V', 'panel',
    '{
        "width_mm": 2465, "height_mm": 1134, "depth_mm": 35, "weight_kg": 33.5,
        "cell_count": 156, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 620, "voc_v": 45.6, "isc_a": 17.26,
        "vmp_v": 38.0, "imp_a": 16.32,
        "efficiency_percent": 22.18,
        "temp_coeff_pmax": -0.29, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 45, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 156, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Jinko Tiger Neo N-type 72HL4-BDV 580 W',
    'JinkoSolar', 'JKM580N-72HL4-BDV', 'panel',
    '{
        "width_mm": 2278, "height_mm": 1134, "depth_mm": 30, "weight_kg": 32.2,
        "cell_count": 144, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 580, "voc_v": 52.40, "isc_a": 14.02,
        "vmp_v": 42.80, "imp_a": 13.55,
        "efficiency_percent": 22.46,
        "temp_coeff_pmax": -0.29, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 45, "bifacial_factor": 0.80,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 144, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Jinko Tiger Neo 54HL4R-V 445 W',
    'JinkoSolar', 'JKM445N-54HL4R-V', 'panel',
    '{
        "width_mm": 1762, "height_mm": 1134, "depth_mm": 30, "weight_kg": 21.2,
        "cell_count": 108, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 445, "voc_v": 41.0, "isc_a": 13.84,
        "vmp_v": 34.20, "imp_a": 13.01,
        "efficiency_percent": 22.26,
        "temp_coeff_pmax": -0.29, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 45, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),

-- LONGi Solar — 3 modules
(
    'LONGi Hi-MO 7 LR5-72HGD 585 W',
    'LONGi', 'LR5-72HGD-585M', 'panel',
    '{
        "width_mm": 2278, "height_mm": 1134, "depth_mm": 35, "weight_kg": 31.4,
        "cell_count": 144, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 585, "voc_v": 52.30, "isc_a": 14.20,
        "vmp_v": 43.80, "imp_a": 13.36,
        "efficiency_percent": 22.65,
        "temp_coeff_pmax": -0.29, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 45, "bifacial_factor": 0.80,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 144, "cells_in_parallel": 1
    }'::jsonb
),
(
    'LONGi Hi-MO 6 LR5-72HPH 555 W',
    'LONGi', 'LR5-72HPH-555M', 'panel',
    '{
        "width_mm": 2278, "height_mm": 1134, "depth_mm": 35, "weight_kg": 32.0,
        "cell_count": 144, "cell_technology": "mono_perc",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 555, "voc_v": 51.30, "isc_a": 13.87,
        "vmp_v": 42.50, "imp_a": 13.06,
        "efficiency_percent": 21.50,
        "temp_coeff_pmax": -0.34, "temp_coeff_voc": -0.26, "temp_coeff_isc": 0.050,
        "noct_c": 45, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 144, "cells_in_parallel": 1
    }'::jsonb
),
(
    'LONGi Hi-MO X6 LR5-54HTH 430 W',
    'LONGi', 'LR5-54HTH-430M', 'panel',
    '{
        "width_mm": 1722, "height_mm": 1134, "depth_mm": 30, "weight_kg": 21.5,
        "cell_count": 108, "cell_technology": "topcon",
        "frame_type": "black_anodized", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 430, "voc_v": 39.50, "isc_a": 13.85,
        "vmp_v": 33.0, "imp_a": 13.03,
        "efficiency_percent": 22.00,
        "temp_coeff_pmax": -0.29, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 45, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),

-- JA Solar — 3 modules
(
    'JA Solar DeepBlue 4.0X JAM72D40 615 W',
    'JA Solar', 'JAM72D40-615/MB', 'panel',
    '{
        "width_mm": 2333, "height_mm": 1134, "depth_mm": 30, "weight_kg": 32.5,
        "cell_count": 144, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 615, "voc_v": 41.97, "isc_a": 18.67,
        "vmp_v": 35.27, "imp_a": 17.44,
        "efficiency_percent": 22.23,
        "temp_coeff_pmax": -0.29, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.044,
        "noct_c": 45, "bifacial_factor": 0.70,
        "max_system_voltage": 1500, "series_fuse_rating_a": 30,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 144, "cells_in_parallel": 1
    }'::jsonb
),
(
    'JA Solar DeepBlue 3.0 JAM72D30 545 W',
    'JA Solar', 'JAM72D30-545/MB', 'panel',
    '{
        "width_mm": 2279, "height_mm": 1134, "depth_mm": 30, "weight_kg": 31.5,
        "cell_count": 144, "cell_technology": "mono_perc",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 545, "voc_v": 49.85, "isc_a": 13.92,
        "vmp_v": 41.40, "imp_a": 13.17,
        "efficiency_percent": 21.10,
        "temp_coeff_pmax": -0.35, "temp_coeff_voc": -0.26, "temp_coeff_isc": 0.045,
        "noct_c": 45, "bifacial_factor": 0.70,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 144, "cells_in_parallel": 1
    }'::jsonb
),
(
    'JA Solar DeepBlue 4.0 JAM54D40 440 W',
    'JA Solar', 'JAM54D40-440/MB', 'panel',
    '{
        "width_mm": 1722, "height_mm": 1134, "depth_mm": 30, "weight_kg": 21.5,
        "cell_count": 108, "cell_technology": "topcon",
        "frame_type": "black_anodized", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 440, "voc_v": 39.50, "isc_a": 14.10,
        "vmp_v": 33.10, "imp_a": 13.30,
        "efficiency_percent": 22.53,
        "temp_coeff_pmax": -0.29, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 45, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),

-- Canadian Solar — 3 modules
(
    'Canadian Solar TOPBiHiKu7 CS7N-TB 700 W',
    'Canadian Solar', 'CS7N-700TB-AG', 'panel',
    '{
        "width_mm": 2384, "height_mm": 1303, "depth_mm": 35, "weight_kg": 38.9,
        "cell_count": 132, "cell_technology": "topcon",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 700, "voc_v": 41.70, "isc_a": 21.18,
        "vmp_v": 34.80, "imp_a": 20.12,
        "efficiency_percent": 22.55,
        "temp_coeff_pmax": -0.30, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 41, "bifacial_factor": 0.80,
        "max_system_voltage": 1500, "series_fuse_rating_a": 30,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 132, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Canadian Solar HiKu7 CS7L-590MS 590 W',
    'Canadian Solar', 'CS7L-590MS', 'panel',
    '{
        "width_mm": 2384, "height_mm": 1096, "depth_mm": 35, "weight_kg": 31.9,
        "cell_count": 132, "cell_technology": "mono_perc",
        "frame_type": "anodized_aluminum", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 590, "voc_v": 41.7, "isc_a": 18.30,
        "vmp_v": 34.3, "imp_a": 17.20,
        "efficiency_percent": 22.58,
        "temp_coeff_pmax": -0.34, "temp_coeff_voc": -0.26, "temp_coeff_isc": 0.050,
        "noct_c": 41, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 132, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Canadian Solar TOPHiKu6 CS6R-T 440 W',
    'Canadian Solar', 'CS6R-440T', 'panel',
    '{
        "width_mm": 1722, "height_mm": 1134, "depth_mm": 30, "weight_kg": 21.3,
        "cell_count": 108, "cell_technology": "topcon",
        "frame_type": "black_anodized", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 440, "voc_v": 39.80, "isc_a": 14.00,
        "vmp_v": 33.40, "imp_a": 13.17,
        "efficiency_percent": 22.53,
        "temp_coeff_pmax": -0.30, "temp_coeff_voc": -0.25, "temp_coeff_isc": 0.045,
        "noct_c": 41, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),

-- Premium / specialty — 5 additional
(
    'REC Alpha Pure-R 420 W',
    'REC', 'REC420AA Pure-R', 'panel',
    '{
        "width_mm": 1730, "height_mm": 1118, "depth_mm": 30, "weight_kg": 19.5,
        "cell_count": 108, "cell_technology": "hjt",
        "frame_type": "black_anodized", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 420, "voc_v": 45.4, "isc_a": 11.52,
        "vmp_v": 38.3, "imp_a": 10.97,
        "efficiency_percent": 21.72,
        "temp_coeff_pmax": -0.26, "temp_coeff_voc": -0.24, "temp_coeff_isc": 0.040,
        "noct_c": 44, "bifacial_factor": 0,
        "max_system_voltage": 1000, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),
(
    'SunPower Maxeon 6 440 W',
    'SunPower', 'SPR-MAX6-440', 'panel',
    '{
        "width_mm": 1812, "height_mm": 1046, "depth_mm": 40, "weight_kg": 21.0,
        "cell_count": 66, "cell_technology": "ibc",
        "frame_type": "black_anodized", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 440, "voc_v": 75.6, "isc_a": 7.32,
        "vmp_v": 62.9, "imp_a": 7.00,
        "efficiency_percent": 22.80,
        "temp_coeff_pmax": -0.27, "temp_coeff_voc": -0.24, "temp_coeff_isc": 0.050,
        "noct_c": 45, "bifacial_factor": 0,
        "max_system_voltage": 1000, "series_fuse_rating_a": 20,
        "nominal_power_tolerance_pct": 5,
        "cells_in_series": 66, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Panasonic EverVolt HK Black 410 W',
    'Panasonic', 'EVPV410H', 'panel',
    '{
        "width_mm": 1765, "height_mm": 1048, "depth_mm": 35, "weight_kg": 21.5,
        "cell_count": 108, "cell_technology": "hjt",
        "frame_type": "black_anodized", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 410, "voc_v": 39.04, "isc_a": 13.56,
        "vmp_v": 32.75, "imp_a": 12.52,
        "efficiency_percent": 22.15,
        "temp_coeff_pmax": -0.24, "temp_coeff_voc": -0.22, "temp_coeff_isc": 0.040,
        "noct_c": 44, "bifacial_factor": 0,
        "max_system_voltage": 1000, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 5,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),
(
    'Q Cells Q.TRON BLK M-G2+ 430 W',
    'Hanwha Q CELLS', 'Q.TRON-BLK-M-G2+-430', 'panel',
    '{
        "width_mm": 1722, "height_mm": 1134, "depth_mm": 30, "weight_kg": 21.0,
        "cell_count": 108, "cell_technology": "topcon",
        "frame_type": "black_anodized", "mounting_hole_count": 8
    }'::jsonb,
    '{
        "rated_power_w": 430, "voc_v": 38.82, "isc_a": 13.79,
        "vmp_v": 32.87, "imp_a": 13.08,
        "efficiency_percent": 22.02,
        "temp_coeff_pmax": -0.30, "temp_coeff_voc": -0.24, "temp_coeff_isc": 0.040,
        "noct_c": 43, "bifacial_factor": 0,
        "max_system_voltage": 1000, "series_fuse_rating_a": 25,
        "nominal_power_tolerance_pct": 3,
        "cells_in_series": 108, "cells_in_parallel": 1
    }'::jsonb
),
(
    'First Solar Series 7 TR1 550 W',
    'First Solar', 'FS-7550A', 'panel',
    '{
        "width_mm": 2388, "height_mm": 1232, "depth_mm": 8, "weight_kg": 38.0,
        "cell_count": 216, "cell_technology": "thin_film",
        "frame_type": "frameless", "mounting_hole_count": 0
    }'::jsonb,
    '{
        "rated_power_w": 550, "voc_v": 220.7, "isc_a": 3.17,
        "vmp_v": 186.6, "imp_a": 2.95,
        "efficiency_percent": 18.70,
        "temp_coeff_pmax": -0.32, "temp_coeff_voc": -0.28, "temp_coeff_isc": 0.040,
        "noct_c": 44, "bifacial_factor": 0,
        "max_system_voltage": 1500, "series_fuse_rating_a": 5,
        "nominal_power_tolerance_pct": 5,
        "cells_in_series": 216, "cells_in_parallel": 1
    }'::jsonb
)

ON CONFLICT (manufacturer, model) DO UPDATE
    SET name              = EXCLUDED.name,
        category          = EXCLUDED.category,
        dimensions        = EXCLUDED.dimensions,
        electrical_params = EXCLUDED.electrical_params;
