//! Structural Engineering Calculations
//!
//! ASCE 7-22 wind and snow load calculations for PV racking, plus foundation
//! sizing for driven piles, ballast, and helical piers.

use serde::{Deserialize, Serialize};
use std::f64::consts::PI;

// ========================================================================
// 1. Foundation Types
// ========================================================================

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum FoundationType {
    DrivenPile,
    Ballast,
    Helical,
}

/// Foundation design result.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FoundationDesign {
    pub foundation_type: FoundationType,
    pub embedment_depth_m: f64,
    pub pile_diameter_mm: f64,      // for driven/helical
    pub ballast_weight_kg: f64,     // for ballast
    pub spacing_m: f64,             // centre-to-centre
    pub design_load_kn: f64,
    pub safety_factor: f64,
}

/// Design a driven pile foundation.
///
/// # Arguments
/// * `design_load_kn` — Total design load per pile (kN) including wind uplift.
/// * `bearing_capacity_kpa` — Soil allowable bearing capacity (kPa).
/// * `pile_diameter_mm` — Pile diameter (mm).
/// * `safety_factor` — Typically 2.0–3.0.
pub fn design_driven_pile(
    design_load_kn: f64,
    bearing_capacity_kpa: f64,
    pile_diameter_mm: f64,
    safety_factor: f64,
) -> FoundationDesign {
    let pile_area_m2 = PI / 4.0 * (pile_diameter_mm / 1000.0).powi(2);
    // End-bearing capacity = bearing_capacity × area
    // Skin friction is additional but conservatively ignored for driven piles in solar.
    let capacity_per_m = bearing_capacity_kpa * pile_area_m2; // kN per metre
    let required_capacity = design_load_kn * safety_factor;
    let depth = if capacity_per_m > 0.0 {
        (required_capacity / capacity_per_m).max(1.5) // minimum 1.5m
    } else { 3.0 };

    FoundationDesign {
        foundation_type: FoundationType::DrivenPile,
        embedment_depth_m: depth,
        pile_diameter_mm,
        ballast_weight_kg: 0.0,
        spacing_m: 3.0, // typical for single-axis tracker
        design_load_kn,
        safety_factor,
    }
}

/// Design a ballast foundation (no ground penetration).
///
/// # Arguments
/// * `uplift_kn` — Design wind uplift per support point (kN).
/// * `safety_factor` — Typically 1.5 for ballast against uplift.
pub fn design_ballast(uplift_kn: f64, safety_factor: f64) -> FoundationDesign {
    // Weight needed to resist uplift: W = F_uplift × SF / (1 - friction_coeff)
    // Concrete-on-membrane friction ≈ 0.4
    let friction = 0.4;
    let denom = (1.0_f64 - friction).max(0.1);
    let weight_kn = uplift_kn * safety_factor / denom;
    let weight_kg = weight_kn / 9.81 * 1000.0;

    FoundationDesign {
        foundation_type: FoundationType::Ballast,
        embedment_depth_m: 0.0,
        pile_diameter_mm: 0.0,
        ballast_weight_kg: weight_kg,
        spacing_m: 2.0,
        design_load_kn: uplift_kn,
        safety_factor,
    }
}

/// Design a helical pier foundation.
///
/// # Arguments
/// * `design_load_kn` — Total design load per pier (kN).
/// * `torque_correlation_kt` — Torque-to-capacity ratio (kN/Nm). Typical 10.
/// * `install_torque_nm` — Expected installation torque (Nm).
/// * `safety_factor` — Typically 2.0.
pub fn design_helical(
    design_load_kn: f64,
    torque_correlation_kt: f64,
    install_torque_nm: f64,
    safety_factor: f64,
) -> FoundationDesign {
    let capacity = torque_correlation_kt * install_torque_nm;
    let depth = if capacity > 0.0 {
        (design_load_kn * safety_factor / capacity * 3.0).max(2.0) // rough embedment
    } else { 3.0 };

    FoundationDesign {
        foundation_type: FoundationType::Helical,
        embedment_depth_m: depth,
        pile_diameter_mm: 76.0, // standard helical shaft
        ballast_weight_kg: 0.0,
        spacing_m: 3.0,
        design_load_kn,
        safety_factor,
    }
}

// ========================================================================
// 2. ASCE 7-22 Wind Load
// ========================================================================

/// ASCE 7-22 wind load result for a ground-mounted PV array.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WindLoadResult {
    pub basic_wind_speed_mph: f64,
    pub velocity_pressure_psf: f64,
    pub net_pressure_psf: f64,      // design wind pressure on panels
    pub net_pressure_kpa: f64,
    pub uplift_force_kn_per_m2: f64,
    pub total_uplift_kn: f64,       // for the given tributary area
}

/// Compute ASCE 7-22 wind load for ground-mounted PV.
///
/// Simplified per ASCE 7-22 Chapter 29.4 (ground-mounted solar panels).
///
/// # Arguments
/// * `basic_wind_speed_mph` — V (mph) from ASCE 7 wind speed maps (MRI=700 for Risk Cat II).
/// * `exposure_category` — 'B' (suburban), 'C' (open), 'D' (coastal).
/// * `panel_tilt_deg` — Module tilt from horizontal (degrees).
/// * `panel_height_m` — Mean roof/panel height above ground (m).
/// * `tributary_area_m2` — Area per support point (m²).
pub fn asce7_wind_load(
    basic_wind_speed_mph: f64,
    exposure_category: char,
    panel_tilt_deg: f64,
    panel_height_m: f64,
    tributary_area_m2: f64,
) -> WindLoadResult {
    let v = basic_wind_speed_mph;

    // Velocity pressure: qz = 0.00256 × Kz × Kzt × Kd × Ke × V²
    let kz = exposure_kz(exposure_category, panel_height_m);
    let kzt = 1.0;  // topographic factor (flat terrain)
    let kd = 0.85;  // directionality factor for solar panels
    let ke = 1.0;   // ground elevation factor (sea level)

    let qz_psf = 0.00256 * kz * kzt * kd * ke * v * v;

    // Net pressure coefficient for ground-mounted PV per ASCE 7-22 Figure 29.4-7
    // Simplified: Cn depends on tilt. For tilt 0–15°: Cn ≈ ±1.2; 15–30°: ±1.5; >30°: ±2.0
    let cn = if panel_tilt_deg <= 15.0 { 1.2 }
    else if panel_tilt_deg <= 30.0 { 1.5 }
    else { 2.0 };

    let gcpi = 0.18; // internal pressure coefficient (enclosed)
    let net_pressure_psf = qz_psf * (cn + gcpi);
    let net_pressure_kpa = net_pressure_psf * 0.04788; // psf to kPa

    let uplift_kn_per_m2 = net_pressure_kpa;
    let total_uplift_kn = uplift_kn_per_m2 * tributary_area_m2;

    WindLoadResult {
        basic_wind_speed_mph: v,
        velocity_pressure_psf: qz_psf,
        net_pressure_psf,
        net_pressure_kpa,
        uplift_force_kn_per_m2: uplift_kn_per_m2,
        total_uplift_kn,
    }
}

/// ASCE 7-22 velocity pressure exposure coefficient Kz.
fn exposure_kz(category: char, height_m: f64) -> f64 {
    let height_ft = height_m * 3.281;
    let h = height_ft.max(15.0); // minimum 15 ft

    let (alpha, zg) = match category {
        'B' => (7.0, 1200.0),
        'D' => (11.5, 900.0),
        _ => (9.5, 900.0), // 'C' default
    };

    let kz = 2.01 * (h / zg).powf(2.0 / alpha);
    kz.max(0.57) // Table 26.10-1 minimum
}

// ========================================================================
// 3. Snow Load (IBC / ASCE 7-22 Chapter 7)
// ========================================================================

/// Snow load result.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SnowLoadResult {
    pub ground_snow_psf: f64,
    pub flat_roof_snow_psf: f64,
    pub sloped_roof_snow_psf: f64,
    pub sloped_roof_snow_kpa: f64,
    pub total_snow_kn: f64,
}

/// Compute ASCE 7-22 snow load for a tilted PV surface.
///
/// # Arguments
/// * `ground_snow_psf` — pg from ASCE 7 ground snow load maps (psf).
/// * `panel_tilt_deg` — Module tilt (degrees).
/// * `exposure_factor_ce` — Ce: 0.7 (windswept), 0.8 (partial), 1.0 (sheltered).
/// * `thermal_factor_ct` — Ct: 1.0 (heated), 1.1 (unheated), 1.2 (cold).
/// * `importance_factor_is` — Is: 0.8 (low), 1.0 (normal), 1.2 (essential).
/// * `tributary_area_m2` — Area per support point.
pub fn asce7_snow_load(
    ground_snow_psf: f64,
    panel_tilt_deg: f64,
    exposure_factor_ce: f64,
    thermal_factor_ct: f64,
    importance_factor_is: f64,
    tributary_area_m2: f64,
) -> SnowLoadResult {
    // Flat roof snow load: pf = 0.7 × Ce × Ct × Is × pg
    let pf = 0.7 * exposure_factor_ce * thermal_factor_ct * importance_factor_is * ground_snow_psf;

    // Slope reduction factor Cs per ASCE 7-22 §7.4
    // For slippery surfaces (glass = PV modules):
    let cs = if panel_tilt_deg <= 5.0 { 1.0 }
    else if panel_tilt_deg >= 70.0 { 0.0 }
    else { 1.0 - (panel_tilt_deg - 5.0) / 65.0 };

    let ps = pf * cs;
    let ps_kpa = ps * 0.04788;
    let total_kn = ps_kpa * tributary_area_m2;

    SnowLoadResult {
        ground_snow_psf,
        flat_roof_snow_psf: pf,
        sloped_roof_snow_psf: ps,
        sloped_roof_snow_kpa: ps_kpa,
        total_snow_kn: total_kn,
    }
}

// ========================================================================
// 4. Rack/Tracker Structural Selection
// ========================================================================

/// Select racking system based on combined wind + snow + dead loads.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RackSelectionResult {
    pub dead_load_kpa: f64,
    pub wind_load_kpa: f64,
    pub snow_load_kpa: f64,
    pub combined_load_kpa: f64,
    pub recommended_rack: String,
    pub passes_deflection: bool,
}

/// Evaluate rack structural adequacy.
///
/// # Arguments
/// * `dead_load_kpa` — Module + racking weight (kPa).
/// * `wind_load_kpa` — Design wind pressure (kPa).
/// * `snow_load_kpa` — Design snow load (kPa).
/// * `rack_capacity_kpa` — Rack manufacturer's rated load capacity (kPa).
/// * `span_m` — Unsupported span between supports (m).
/// * `max_deflection_ratio` — Allowable deflection ratio (e.g., 1/180).
pub fn evaluate_rack(
    dead_load_kpa: f64,
    wind_load_kpa: f64,
    snow_load_kpa: f64,
    rack_capacity_kpa: f64,
    span_m: f64,
    max_deflection_ratio: f64,
) -> RackSelectionResult {
    // LRFD load combination: 1.2D + 1.6S + 0.5W (gravity controls)
    // or 0.9D + 1.0W (uplift controls)
    let combo_gravity = 1.2 * dead_load_kpa + 1.6 * snow_load_kpa + 0.5 * wind_load_kpa;
    let combo_uplift = (0.9 * dead_load_kpa - 1.0 * wind_load_kpa).abs();
    let combined = combo_gravity.max(combo_uplift);

    let _passes = combined <= rack_capacity_kpa;
    // Simplified deflection check: L/ratio
    let max_defl_mm = span_m * 1000.0 * max_deflection_ratio;
    let estimated_defl_mm = combined * span_m.powi(2) * 1000.0 / (200.0 * rack_capacity_kpa.max(1.0));
    let passes_deflection = estimated_defl_mm <= max_defl_mm;

    let recommended = if combined <= 1.0 {
        "Light-duty fixed tilt (steel C-channel)"
    } else if combined <= 2.5 {
        "Standard ground-mount (W-beam purlins)"
    } else if combined <= 5.0 {
        "Heavy-duty tracker (reinforced torque tube)"
    } else {
        "Custom engineered (PE stamp required)"
    };

    RackSelectionResult {
        dead_load_kpa,
        wind_load_kpa,
        snow_load_kpa,
        combined_load_kpa: combined,
        recommended_rack: recommended.into(),
        passes_deflection,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn driven_pile_depth() {
        let fd = design_driven_pile(5.0, 150.0, 76.0, 2.0);
        assert!(fd.embedment_depth_m >= 1.5, "depth={}", fd.embedment_depth_m);
        assert_eq!(fd.pile_diameter_mm, 76.0);
    }

    #[test]
    fn ballast_weight() {
        let fd = design_ballast(2.0, 1.5);
        assert!(fd.ballast_weight_kg > 0.0, "weight should be positive");
        assert_eq!(fd.embedment_depth_m, 0.0);
    }

    #[test]
    fn wind_load_exposure_c() {
        let wl = asce7_wind_load(115.0, 'C', 25.0, 2.0, 10.0);
        assert!(wl.velocity_pressure_psf > 0.0);
        assert!(wl.net_pressure_kpa > 0.0);
        assert!(wl.total_uplift_kn > 0.0, "uplift={}", wl.total_uplift_kn);
    }

    #[test]
    fn wind_increases_with_speed() {
        let wl_low = asce7_wind_load(90.0, 'C', 25.0, 2.0, 10.0);
        let wl_high = asce7_wind_load(150.0, 'C', 25.0, 2.0, 10.0);
        assert!(wl_high.net_pressure_kpa > wl_low.net_pressure_kpa);
    }

    #[test]
    fn snow_load_reduces_with_tilt() {
        let sl_flat = asce7_snow_load(30.0, 5.0, 1.0, 1.0, 1.0, 10.0);
        let sl_steep = asce7_snow_load(30.0, 40.0, 1.0, 1.0, 1.0, 10.0);
        assert!(sl_steep.sloped_roof_snow_psf < sl_flat.sloped_roof_snow_psf);
    }

    #[test]
    fn rack_selection() {
        let rs = evaluate_rack(0.15, 1.5, 0.5, 3.0, 2.5, 1.0 / 180.0);
        assert!(rs.combined_load_kpa > 0.0);
        assert!(!rs.recommended_rack.is_empty());
    }
}
