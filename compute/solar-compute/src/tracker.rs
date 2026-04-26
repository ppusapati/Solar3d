//! Tracker Geometry and Backtracking
//!
//! Single-axis and dual-axis tracker angle computation, plus backtracking
//! to avoid inter-row shading.

use std::f64::consts::PI;

const DEG_TO_RAD: f64 = PI / 180.0;
const RAD_TO_DEG: f64 = 180.0 / PI;

/// Compute ideal rotation angle for a horizontal single-axis tracker (N-S axis).
///
/// Reference: Lorenzo, E. (2011), Solar Energy 85, 1428-1437, eq. 7.
///
/// # Arguments
/// * `solar_zenith_deg` — Solar zenith (degrees from vertical).
/// * `solar_azimuth_deg` — Solar azimuth (degrees, 0=N, 90=E, 180=S).
/// * `axis_azimuth_deg` — Tracker axis azimuth (typically 0 or 180 for N-S).
/// * `max_rotation_deg` — Mechanical rotation limit (degrees), typically ±60.
///
/// # Returns
/// Rotation angle in degrees (positive = east-facing morning rotation).
pub fn single_axis_angle(
    solar_zenith_deg: f64,
    solar_azimuth_deg: f64,
    axis_azimuth_deg: f64,
    max_rotation_deg: f64,
) -> f64 {
    if solar_zenith_deg >= 90.0 {
        return 0.0;
    }
    let zen = solar_zenith_deg * DEG_TO_RAD;
    let az = solar_azimuth_deg * DEG_TO_RAD;
    let ax = axis_azimuth_deg * DEG_TO_RAD;

    let rotation = ((az - ax).sin() * zen.sin()).atan2(zen.cos());
    let rot_deg = rotation * RAD_TO_DEG;
    rot_deg.clamp(-max_rotation_deg, max_rotation_deg)
}

/// Compute backtracked angle to avoid inter-row shading.
///
/// Reference: Lorenzo, E., Narvarte, L., Muñoz, J. (2011), Progress in
/// Photovoltaics 19, 747-753.
///
/// # Arguments
/// * `ideal_rot_deg` — Ideal tracker angle from [`single_axis_angle`].
/// * `solar_zenith_deg` — Solar zenith (degrees).
/// * `solar_azimuth_deg` — Solar azimuth (degrees).
/// * `axis_azimuth_deg` — Tracker axis azimuth (degrees).
/// * `gcr` — Ground coverage ratio = collector_width / pitch (0–1).
///
/// # Returns
/// Backtracked rotation angle (degrees). Returns ideal angle when no
/// shading occurs.
pub fn backtrack(
    ideal_rot_deg: f64,
    solar_zenith_deg: f64,
    solar_azimuth_deg: f64,
    axis_azimuth_deg: f64,
    gcr: f64,
) -> f64 {
    if gcr <= 0.0 || gcr >= 1.0 || solar_zenith_deg >= 90.0 {
        return ideal_rot_deg;
    }

    let zen = solar_zenith_deg * DEG_TO_RAD;
    let az = solar_azimuth_deg * DEG_TO_RAD;
    let ax = axis_azimuth_deg * DEG_TO_RAD;
    let ideal_rad = ideal_rot_deg * DEG_TO_RAD;

    let proj_angle = ((az - ax).sin() * zen.sin()).atan2(zen.cos());
    let cos_proj = proj_angle.cos().abs();

    if cos_proj <= 0.001 {
        return ideal_rot_deg;
    }

    let ratio = gcr / cos_proj;
    if ratio >= 1.0 {
        return 0.0; // fully backtrack to horizontal
    }

    // Check if ideal angle causes shading
    let shadow_ratio = gcr * ideal_rad.cos().abs() / cos_proj;
    if shadow_ratio <= 1.0 {
        return ideal_rot_deg;
    }

    let bt_deg = ratio.acos() * RAD_TO_DEG;
    if ideal_rot_deg < 0.0 { -bt_deg } else { bt_deg }
}

/// Compute tilt and azimuth for a dual-axis tracker (always perpendicular to sun).
///
/// # Arguments
/// * `solar_zenith_deg` — Solar zenith (degrees).
/// * `solar_azimuth_deg` — Solar azimuth (degrees, 0=N).
/// * `max_tilt_deg` — Mechanical tilt limit (degrees from horizontal).
///
/// # Returns
/// (tilt_deg, azimuth_deg) for the tracker surface.
pub fn dual_axis_angles(
    solar_zenith_deg: f64,
    solar_azimuth_deg: f64,
    max_tilt_deg: f64,
) -> (f64, f64) {
    if solar_zenith_deg >= 90.0 {
        return (0.0, 180.0); // stow flat facing south
    }
    let tilt = solar_zenith_deg.min(max_tilt_deg);
    (tilt, solar_azimuth_deg)
}

/// Compute plane-of-array irradiance using the isotropic sky model
/// (Liu & Jordan, 1963).
///
/// # Arguments
/// * `ghi_wm2` — Global horizontal irradiance (W/m²).
/// * `dni_wm2` — Direct normal irradiance (W/m²).
/// * `dhi_wm2` — Diffuse horizontal irradiance (W/m²).
/// * `solar_zenith_deg` — Solar zenith (degrees).
/// * `solar_azimuth_deg` — Solar azimuth (degrees, 0=N).
/// * `surface_tilt_deg` — Surface tilt from horizontal (degrees).
/// * `surface_azimuth_deg` — Surface azimuth (degrees, 0=N, 180=S).
/// * `albedo` — Ground reflectance (0–1).
///
/// # Returns
/// Total POA irradiance (W/m²): beam + sky diffuse + ground-reflected.
pub fn poa_irradiance(
    ghi_wm2: f64,
    dni_wm2: f64,
    dhi_wm2: f64,
    solar_zenith_deg: f64,
    solar_azimuth_deg: f64,
    surface_tilt_deg: f64,
    surface_azimuth_deg: f64,
    albedo: f64,
) -> f64 {
    if solar_zenith_deg >= 90.0 || ghi_wm2 <= 0.0 {
        return 0.0;
    }
    let tilt = surface_tilt_deg * DEG_TO_RAD;
    let s_az = surface_azimuth_deg * DEG_TO_RAD;
    let zen = solar_zenith_deg * DEG_TO_RAD;
    let sol_az = solar_azimuth_deg * DEG_TO_RAD;

    // Angle of incidence
    let cos_aoi = zen.cos() * tilt.cos()
        + zen.sin() * tilt.sin() * (sol_az - s_az).cos();

    let beam = if cos_aoi > 0.0 { dni_wm2 * cos_aoi } else { 0.0 };
    let diffuse = dhi_wm2 * (1.0 + tilt.cos()) / 2.0;
    let ground = ghi_wm2 * albedo * (1.0 - tilt.cos()) / 2.0;

    beam + diffuse + ground
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn single_axis_stows_at_night() {
        assert_eq!(single_axis_angle(95.0, 180.0, 0.0, 60.0), 0.0);
    }

    #[test]
    fn single_axis_clamps_to_max() {
        // Low sun angle should hit the mechanical limit
        let angle = single_axis_angle(80.0, 90.0, 0.0, 45.0);
        assert!(angle.abs() <= 45.0, "angle {angle} exceeds ±45°");
    }

    #[test]
    fn dual_axis_stows_at_night() {
        let (tilt, _) = dual_axis_angles(95.0, 180.0, 80.0);
        assert_eq!(tilt, 0.0);
    }

    #[test]
    fn dual_axis_follows_sun() {
        let (tilt, az) = dual_axis_angles(30.0, 150.0, 80.0);
        assert!((tilt - 30.0).abs() < 0.01);
        assert!((az - 150.0).abs() < 0.01);
    }

    #[test]
    fn poa_at_normal_incidence() {
        // Surface tilted to match zenith, azimuth aligned → cos(AOI) ≈ 1
        let poa = poa_irradiance(1000.0, 800.0, 200.0, 30.0, 180.0, 30.0, 180.0, 0.2);
        // Beam = 800 × cos(0) = 800
        // Diffuse = 200 × (1+cos30)/2 ≈ 200×0.933 = 186.6
        // Ground = 1000 × 0.2 × (1-cos30)/2 ≈ 200×0.067 = 13.4
        assert!(poa > 950.0 && poa < 1050.0, "POA at near-normal: got {poa}");
    }

    #[test]
    fn poa_zero_at_night() {
        assert_eq!(poa_irradiance(0.0, 0.0, 0.0, 95.0, 180.0, 30.0, 180.0, 0.2), 0.0);
    }
}
