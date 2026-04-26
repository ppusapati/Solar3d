//! Spectral Correction Models
//!
//! Spectral mismatch modifies module output relative to the AM1.5G reference
//! spectrum based on atmospheric conditions (air mass, precipitable water).

use std::f64::consts::PI;

const DEG_TO_RAD: f64 = PI / 180.0;

/// Sandia spectral polynomial coefficients for common module types.
/// M = a0 + a1·AM + a2·AM² + a3·AM³ + a4·AM⁴
pub const SPECTRAL_MONO_SI: [f64; 5] = [0.918093, 0.086257, -0.024459, 0.002816, -0.000126];
pub const SPECTRAL_CDTE: [f64; 5] = [0.853900, 0.124600, -0.038200, 0.004900, -0.000220];
pub const SPECTRAL_CIS: [f64; 5] = [0.852700, 0.133100, -0.040600, 0.005200, -0.000230];

/// Sandia spectral mismatch modifier (King et al., 2004, SAND2004-3535, eq. 3).
///
/// # Arguments
/// * `air_mass` — Absolute (pressure-corrected) air mass.
/// * `coeffs` — Polynomial coefficients \[a0..a4\] from Sandia database.
///
/// # Returns
/// Spectral modifier M (dimensionless, typically 0.85–1.05).
pub fn spectral_sandia(air_mass: f64, coeffs: &[f64; 5]) -> f64 {
    if air_mass <= 0.0 {
        return 1.0;
    }
    let am = air_mass;
    coeffs[0] + coeffs[1] * am + coeffs[2] * am * am
        + coeffs[3] * am * am * am + coeffs[4] * am * am * am * am
}

/// First Solar CdTe spectral correction using air mass and precipitable water.
///
/// Reference: Lee, M., Panchula, A.F. (2016), IEEE PVSC.
///
/// # Arguments
/// * `air_mass` — Absolute air mass (≥1).
/// * `pw_cm` — Total column precipitable water (cm), typically 0.5–5.0.
/// * `series7` — true for Series 7 (TR1), false for Series 6 / generic CdTe.
///
/// # Returns
/// Spectral correction factor (typically 0.90–1.10).
pub fn spectral_first_solar(air_mass: f64, pw_cm: f64, series7: bool) -> f64 {
    if air_mass <= 0.0 {
        return 1.0;
    }
    let b: [f64; 6] = if series7 {
        [0.9468, 0.06476, -0.01280, 0.006092, -0.0007120, -0.003640]
    } else {
        [0.9392, 0.06945, -0.01400, 0.007260, -0.0008630, -0.004080]
    };
    b[0] + b[1] * air_mass + b[2] * air_mass * air_mass
        + b[3] * pw_cm + b[4] * pw_cm * pw_cm + b[5] * air_mass * pw_cm
}

/// Compute absolute air mass from solar zenith angle and site altitude
/// using Kasten & Young (1989).
///
/// Reference: Applied Optics 28(22), 4735-4738.
///
/// # Arguments
/// * `solar_zenith_deg` — Apparent solar zenith (degrees).
/// * `altitude_m` — Site altitude above sea level (m).
///
/// # Returns
/// Absolute (pressure-corrected) air mass. Returns 0 when sun is below horizon.
pub fn air_mass(solar_zenith_deg: f64, altitude_m: f64) -> f64 {
    if solar_zenith_deg >= 90.0 {
        return 0.0;
    }
    let cos_z = (solar_zenith_deg * DEG_TO_RAD).cos();
    let rel_am = 1.0 / (cos_z + 0.50572 * (96.07995 - solar_zenith_deg).powf(-1.6364));
    let pressure_ratio = (-altitude_m / 8434.5_f64).exp();
    rel_am * pressure_ratio
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn air_mass_at_zenith() {
        let am = air_mass(0.0, 0.0);
        assert!((am - 1.0).abs() < 0.01, "AM at zenith: got {am}");
    }

    #[test]
    fn air_mass_at_60() {
        let am = air_mass(60.0, 0.0);
        // At 60°: AM ≈ 2.0
        assert!(am > 1.9 && am < 2.1, "AM at 60°: got {am}");
    }

    #[test]
    fn air_mass_below_horizon() {
        assert_eq!(air_mass(95.0, 0.0), 0.0);
    }

    #[test]
    fn air_mass_altitude_reduces() {
        let am_sea = air_mass(30.0, 0.0);
        let am_high = air_mass(30.0, 2000.0);
        assert!(am_high < am_sea, "altitude should reduce AM: sea={am_sea}, 2000m={am_high}");
    }

    #[test]
    fn spectral_sandia_at_am1() {
        let m = spectral_sandia(1.0, &SPECTRAL_MONO_SI);
        // At AM=1.0: close to 1.0
        assert!(m > 0.95 && m < 1.05, "mono-Si at AM1: got {m}");
    }

    #[test]
    fn spectral_first_solar_at_am1_5() {
        let m = spectral_first_solar(1.5, 2.0, false);
        assert!(m > 0.90 && m < 1.10, "FS CdTe at AM1.5: got {m}");
    }
}
