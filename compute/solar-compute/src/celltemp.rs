//! Cell Temperature Models
//!
//! Cell temperature (T_c) is the primary driver of PV module electrical
//! performance after irradiance. These models estimate T_c from meteorological
//! conditions and module thermal properties.

use serde::{Deserialize, Serialize};

/// Sandia thermal parameter set (King et al., 2004, SAND2004-3535 Table 4).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SandiaThermalParams {
    /// Wind-independent heat transfer coefficient.
    pub a: f64,
    /// Wind-dependent heat transfer coefficient.
    pub b: f64,
    /// Cell-to-back-surface temperature difference (°C).
    pub delta_t: f64,
}

/// Glass/cell/glass modules (standard crystalline Si).
pub const SANDIA_GLASS_CELL: SandiaThermalParams = SandiaThermalParams {
    a: -3.47,
    b: -0.0594,
    delta_t: 3.0,
};

/// Glass/cell/polymer back-sheet modules.
pub const SANDIA_GLASS_POLYMER: SandiaThermalParams = SandiaThermalParams {
    a: -3.56,
    b: -0.0750,
    delta_t: 3.0,
};

/// Polymer/thin-film/steel substrate modules.
pub const SANDIA_THIN_FILM_STEEL: SandiaThermalParams = SandiaThermalParams {
    a: -3.58,
    b: -0.1130,
    delta_t: 0.0,
};

/// Sandia cell temperature model (King et al., 2004).
///
/// Reference: SAND2004-3535, Photovoltaic Array Performance Model.
///
/// # Arguments
/// * `poa_wm2` — Plane-of-array irradiance (W/m²).
/// * `ambient_c` — Ambient air temperature (°C).
/// * `wind_ms` — Wind speed at module height (m/s).
/// * `params` — Empirical thermal coefficients.
///
/// # Returns
/// Cell temperature in °C.
pub fn cell_temp_sandia(
    poa_wm2: f64,
    ambient_c: f64,
    wind_ms: f64,
    params: &SandiaThermalParams,
) -> f64 {
    if poa_wm2 <= 0.0 {
        return ambient_c;
    }
    let e_ref = 1000.0_f64;
    let t_back = poa_wm2 * (params.a + params.b * wind_ms).exp() + ambient_c;
    t_back + poa_wm2 / e_ref * params.delta_t
}

/// Faiman cell temperature model (Faiman, 2008).
///
/// Reference: Progress in Photovoltaics 16(4), 307-315.
///
/// # Arguments
/// * `poa_wm2` — Plane-of-array irradiance (W/m²).
/// * `ambient_c` — Ambient air temperature (°C).
/// * `wind_ms` — Wind speed (m/s).
/// * `u0` — Combined radiative + convective heat loss factor (W/m²·K). Default: 25.0.
/// * `u1` — Wind-dependent convective heat loss factor (W/m²·K/(m/s)). Default: 6.84.
pub fn cell_temp_faiman(poa_wm2: f64, ambient_c: f64, wind_ms: f64, u0: f64, u1: f64) -> f64 {
    if poa_wm2 <= 0.0 {
        return ambient_c;
    }
    ambient_c + poa_wm2 / (u0 + u1 * wind_ms)
}

/// Default Faiman U0 (W/m²·K).
pub const FAIMAN_DEFAULT_U0: f64 = 25.0;
/// Default Faiman U1 (W/m²·K/(m/s)).
pub const FAIMAN_DEFAULT_U1: f64 = 6.84;

/// NOCT cell temperature model (IEC 61215-2:2021 §5.9).
///
/// NOCT conditions: 800 W/m², 20 °C ambient, 1 m/s wind.
///
/// # Arguments
/// * `poa_wm2` — Plane-of-array irradiance (W/m²).
/// * `ambient_c` — Ambient air temperature (°C).
/// * `noct_c` — NOCT from datasheet (°C), typically 43–48.
pub fn cell_temp_noct(poa_wm2: f64, ambient_c: f64, noct_c: f64) -> f64 {
    if poa_wm2 <= 0.0 {
        return ambient_c;
    }
    ambient_c + (noct_c - 20.0) * (poa_wm2 / 800.0)
}

/// Adjust STC-rated power for cell temperature using the temperature
/// coefficient of Pmax (γ, %/°C).
///
/// # Arguments
/// * `p_stc_w` — Rated power at STC (W).
/// * `cell_temp_c` — Computed cell temperature (°C).
/// * `gamma_pct_per_c` — Temperature coefficient (%/°C), typically negative.
///
/// # Returns
/// Temperature-adjusted power in watts.
pub fn adjust_power_for_temperature(p_stc_w: f64, cell_temp_c: f64, gamma_pct_per_c: f64) -> f64 {
    let stc_temp = 25.0_f64;
    p_stc_w * (1.0 + (gamma_pct_per_c / 100.0) * (cell_temp_c - stc_temp))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn noct_at_noct_conditions() {
        // At 800 W/m², 20°C → Tc should equal NOCT
        let tc = cell_temp_noct(800.0, 20.0, 45.0);
        assert!((tc - 45.0).abs() < 0.01, "got {tc}");
    }

    #[test]
    fn noct_at_stc() {
        let tc = cell_temp_noct(1000.0, 25.0, 45.0);
        let expected = 25.0 + 25.0 * 1.25;
        assert!((tc - expected).abs() < 0.01, "got {tc}, want {expected}");
    }

    #[test]
    fn noct_zero_irradiance() {
        assert_eq!(cell_temp_noct(0.0, 15.0, 45.0), 15.0);
    }

    #[test]
    fn sandia_wind_reduces_temp() {
        let p = &SANDIA_GLASS_POLYMER;
        let tc_low = cell_temp_sandia(1000.0, 25.0, 1.0, p);
        let tc_high = cell_temp_sandia(1000.0, 25.0, 10.0, p);
        assert!(tc_high < tc_low, "wind should reduce cell temp: low={tc_low} high={tc_high}");
    }

    #[test]
    fn sandia_zero_irradiance() {
        assert_eq!(cell_temp_sandia(0.0, 20.0, 5.0, &SANDIA_GLASS_CELL), 20.0);
    }

    #[test]
    fn faiman_formula() {
        let tc = cell_temp_faiman(1000.0, 25.0, 1.0, FAIMAN_DEFAULT_U0, FAIMAN_DEFAULT_U1);
        let expected = 25.0 + 1000.0 / (25.0 + 6.84);
        assert!((tc - expected).abs() < 0.01, "got {tc}, want {expected}");
    }

    #[test]
    fn power_adjustment_at_stc() {
        let p = adjust_power_for_temperature(400.0, 25.0, -0.35);
        assert!((p - 400.0).abs() < 0.01);
    }

    #[test]
    fn power_adjustment_hot() {
        let p = adjust_power_for_temperature(400.0, 50.0, -0.35);
        let expected = 400.0 * (1.0 + (-0.35 / 100.0) * 25.0);
        assert!((p - expected).abs() < 0.01, "got {p}, want {expected}");
    }

    #[test]
    fn power_adjustment_cold_increases() {
        let p = adjust_power_for_temperature(400.0, 10.0, -0.35);
        assert!(p > 400.0, "cold should increase power: got {p}");
    }
}
