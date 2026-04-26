//! Bifacial Irradiance Model
//!
//! Estimates rear-side irradiance from ground-reflected light using a
//! simplified infinite-row view factor model (Marion et al., 2017).

use std::f64::consts::PI;

const DEG_TO_RAD: f64 = PI / 180.0;

/// Compute rear-side irradiance for a bifacial module from ground reflection.
///
/// Reference: Marion, B. et al. (2017), IEEE PVSC, 1537-1542.
///
/// # Arguments
/// * `ghi_wm2` — Global horizontal irradiance on the ground (W/m²).
/// * `albedo` — Ground reflectance (0–1). Typical: grass=0.2, snow=0.7.
/// * `tilt_deg` — Module tilt from horizontal (degrees).
/// * `module_height_m` — Clearance height of lower edge above ground (m).
/// * `pitch_m` — Row-to-row pitch (m).
/// * `module_width_m` — Module width along the tilted plane (m).
///
/// # Returns
/// Rear-side irradiance in W/m² (before applying bifaciality factor).
pub fn rear_irradiance(
    ghi_wm2: f64,
    albedo: f64,
    tilt_deg: f64,
    module_height_m: f64,
    pitch_m: f64,
    module_width_m: f64,
) -> f64 {
    if ghi_wm2 <= 0.0 || albedo <= 0.0 {
        return 0.0;
    }

    let tilt_rad = tilt_deg * DEG_TO_RAD;
    let gcr = (module_width_m * tilt_rad.cos()) / pitch_m;
    let gcr = gcr.clamp(0.01, 1.0);

    let f_illuminated = 1.0 - gcr;
    let ground_reflected = ghi_wm2 * albedo * f_illuminated;

    // View factor: (1 - cos(tilt)) / 2 with height correction
    let vf_base = (1.0 - tilt_rad.cos()) / 2.0;
    let height_ratio = module_height_m / module_width_m.max(0.1);
    let height_correction = 1.0 + (height_ratio.min(1.0)) * 0.5;
    let vf_rear = (vf_base * height_correction).min(1.0).max(0.05);

    ground_reflected * vf_rear
}

/// Compute total effective POA irradiance for a bifacial module.
///
/// # Arguments
/// * `poa_front_wm2` — Front-surface plane-of-array irradiance (W/m²).
/// * `rear_irradiance_wm2` — Rear-side irradiance from [`rear_irradiance`] (W/m²).
/// * `bifaciality` — Module bifaciality factor (0–1), from datasheet.
pub fn effective_irradiance(
    poa_front_wm2: f64,
    rear_irradiance_wm2: f64,
    bifaciality: f64,
) -> f64 {
    if bifaciality <= 0.0 {
        return poa_front_wm2;
    }
    poa_front_wm2 + rear_irradiance_wm2 * bifaciality
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn zero_ghi_returns_zero() {
        assert_eq!(rear_irradiance(0.0, 0.3, 25.0, 1.0, 5.0, 2.0), 0.0);
    }

    #[test]
    fn zero_albedo_returns_zero() {
        assert_eq!(rear_irradiance(1000.0, 0.0, 25.0, 1.0, 5.0, 2.0), 0.0);
    }

    #[test]
    fn higher_albedo_more_rear() {
        let low = rear_irradiance(1000.0, 0.2, 25.0, 1.0, 5.0, 2.0);
        let high = rear_irradiance(1000.0, 0.6, 25.0, 1.0, 5.0, 2.0);
        assert!(high > low, "snow albedo should give more rear: low={low}, high={high}");
    }

    #[test]
    fn bifacial_adds_rear_contribution() {
        let front = 800.0;
        let rear = 100.0;
        let eff = effective_irradiance(front, rear, 0.80);
        assert!((eff - 880.0).abs() < 0.01, "got {eff}");
    }

    #[test]
    fn monofacial_ignores_rear() {
        let eff = effective_irradiance(800.0, 100.0, 0.0);
        assert_eq!(eff, 800.0);
    }
}
