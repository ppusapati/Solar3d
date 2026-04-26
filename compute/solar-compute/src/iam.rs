//! Incidence Angle Modifier (IAM) Models
//!
//! IAM quantifies the optical loss from non-normal incidence. At θ=0, IAM=1.
//! As incidence angle increases, more light is reflected off the glass,
//! reducing effective irradiance.

use std::f64::consts::PI;

const DEG_TO_RAD: f64 = PI / 180.0;

/// Default ASHRAE IAM coefficient for flat glass.
pub const ASHRAE_DEFAULT_B: f64 = 0.05;
/// Default Martin-Ruiz angular loss coefficient for standard glass.
pub const MARTIN_RUIZ_DEFAULT_AR: f64 = 0.159;

/// ASHRAE transmittance model (Souka & Safwat, 1966; Duffie & Beckman eq. 5.4.1).
///
/// # Arguments
/// * `theta_deg` — Angle of incidence (degrees, 0–90).
/// * `b` — ASHRAE IAM coefficient. Typical: 0.05 for glass, 0.02 for AR-coated.
///
/// # Returns
/// IAM in \[0, 1\]. Returns 0 for θ ≥ 90°.
pub fn iam_ashrae(theta_deg: f64, b: f64) -> f64 {
    if theta_deg >= 90.0 || theta_deg < 0.0 {
        return 0.0;
    }
    if theta_deg < 0.1 {
        return 1.0;
    }
    let cos_theta = (theta_deg * DEG_TO_RAD).cos();
    if cos_theta <= 0.0 {
        return 0.0;
    }
    let result = 1.0 - b * (1.0 / cos_theta - 1.0);
    result.max(0.0)
}

/// Martin & Ruiz (2001) physical IAM model.
///
/// Reference: Solar Energy Materials & Solar Cells 70, 25-38.
///
/// # Arguments
/// * `theta_deg` — Angle of incidence (degrees, 0–90).
/// * `ar` — Angular losses coefficient. Typical: 0.159 (clean glass),
///   0.12 (AR-coated), 0.169 (textured).
///
/// # Returns
/// IAM in \[0, 1\]. Returns 0 for θ ≥ 90°.
pub fn iam_martin_ruiz(theta_deg: f64, ar: f64) -> f64 {
    if theta_deg >= 90.0 || theta_deg < 0.0 {
        return 0.0;
    }
    if theta_deg < 0.1 {
        return 1.0;
    }
    let cos_theta = (theta_deg * DEG_TO_RAD).cos();
    let numerator = 1.0 - (-cos_theta / ar).exp();
    let denominator = 1.0 - (-1.0 / ar).exp();
    if denominator == 0.0 {
        return 1.0;
    }
    (numerator / denominator).max(0.0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ashrae_normal_incidence() {
        assert!((iam_ashrae(0.0, 0.05) - 1.0).abs() < 0.001);
    }

    #[test]
    fn ashrae_60_degrees() {
        let cos60 = (60.0_f64 * DEG_TO_RAD).cos();
        let expected = 1.0 - 0.05 * (1.0 / cos60 - 1.0);
        let got = iam_ashrae(60.0, 0.05);
        assert!((got - expected).abs() < 0.001, "got {got}, want {expected}");
    }

    #[test]
    fn ashrae_90_degrees() {
        assert_eq!(iam_ashrae(90.0, 0.05), 0.0);
    }

    #[test]
    fn ashrae_monotonic() {
        let mut prev = 1.0_f64;
        for theta in (10..=85).step_by(5) {
            let v = iam_ashrae(theta as f64, 0.05);
            assert!(v < prev, "not monotonic at θ={theta}: {v} >= {prev}");
            prev = v;
        }
    }

    #[test]
    fn martin_ruiz_normal() {
        assert!((iam_martin_ruiz(0.0, 0.159) - 1.0).abs() < 0.001);
    }

    #[test]
    fn martin_ruiz_90() {
        assert_eq!(iam_martin_ruiz(90.0, 0.159), 0.0);
    }

    #[test]
    fn martin_ruiz_ar_coating_helps() {
        let coated = iam_martin_ruiz(60.0, 0.12);
        let standard = iam_martin_ruiz(60.0, 0.159);
        assert!(coated > standard, "AR coating should help: coated={coated}, standard={standard}");
    }
}
