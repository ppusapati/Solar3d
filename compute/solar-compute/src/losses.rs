//! Full Loss Model
//!
//! Implements all major energy loss mechanisms between POA irradiance and
//! delivered AC energy at the point of interconnection. Each function returns
//! a derate factor (0–1) or an absolute loss (W), documented with the
//! standard reference.
//!
//! The losses are designed to be composed multiplicatively:
//! ```text
//! P_ac = P_dc_ideal × soiling × snow × lid × pid × clipping × cable × xfmr × availability
//! ```

use std::f64::consts::PI;

// ========================================================================
// 1. Soiling
// ========================================================================

/// Monthly soiling loss factors. Each element is the fraction of irradiance
/// *remaining* after soiling (1.0 = clean, 0.90 = 10 % soiled). Index 0 =
/// January, 11 = December.
pub type MonthlySoilingProfile = [f64; 12];

/// Default region-keyed soiling profiles. These are conservative feasibility
/// defaults; site-specific soiling studies (IEC 61724-1) should replace them.
pub mod soiling_profiles {
    use super::MonthlySoilingProfile;

    /// Arid / desert (Middle East, North Africa, western US desert).
    /// High soiling in dry months, partial recovery during rare rain.
    pub const ARID: MonthlySoilingProfile = [
        0.97, 0.96, 0.95, 0.93, 0.91, 0.89,
        0.88, 0.87, 0.88, 0.90, 0.93, 0.96,
    ];

    /// Temperate (Europe, eastern US, Japan). Rain keeps panels
    /// relatively clean; winter has lower soiling due to low irradiance.
    pub const TEMPERATE: MonthlySoilingProfile = [
        0.99, 0.99, 0.98, 0.97, 0.96, 0.95,
        0.95, 0.95, 0.96, 0.97, 0.98, 0.99,
    ];

    /// Tropical (India, SE Asia, central Africa). Monsoon cleans panels
    /// mid-year; dry season accumulates dust.
    pub const TROPICAL: MonthlySoilingProfile = [
        0.94, 0.93, 0.92, 0.93, 0.95, 0.97,
        0.98, 0.98, 0.97, 0.96, 0.95, 0.94,
    ];

    /// Snow belt (Nordic, Canada, northern Japan). Snow cover dominates
    /// winter losses; handled separately by the snow model — soiling is
    /// mainly a summer phenomenon.
    pub const SNOW_BELT: MonthlySoilingProfile = [
        0.99, 0.99, 0.99, 0.98, 0.97, 0.96,
        0.95, 0.95, 0.96, 0.97, 0.98, 0.99,
    ];
}

/// Return the soiling derate factor for a given month (1=Jan, 12=Dec).
pub fn soiling_factor(profile: &MonthlySoilingProfile, month: u32) -> f64 {
    let idx = ((month.max(1).min(12)) - 1) as usize;
    profile[idx].clamp(0.0, 1.0)
}

// ========================================================================
// 2. Snow Losses (Marion model)
// ========================================================================

/// Snow coverage loss model based on Marion et al. (2013).
///
/// Reference: Marion, B., Schaefer, R., et al. (2013). "Measured and modeled
/// photovoltaic system energy losses from snow for Colorado and Wisconsin
/// locations". Solar Energy 97, 112-121.
///
/// The model estimates the fraction of the module surface covered by snow
/// as a function of snowfall, ambient temperature, tilt angle, and time
/// since last snowfall.
///
/// # Arguments
/// * `snow_depth_cm` — Fresh snow depth on the ground (cm).
/// * `ambient_temp_c` — Ambient air temperature (°C).
/// * `tilt_deg` — Module tilt from horizontal (degrees).
/// * `hours_since_snowfall` — Hours since the last snowfall event.
///
/// # Returns
/// Fraction of module area covered by snow (0 = clear, 1 = fully covered).
/// Multiply by (1 - coverage) to get the snow derate factor.
pub fn snow_coverage(
    snow_depth_cm: f64,
    ambient_temp_c: f64,
    tilt_deg: f64,
    hours_since_snowfall: f64,
) -> f64 {
    if snow_depth_cm <= 0.0 {
        return 0.0;
    }

    // Initial coverage: 1.0 if snow depth > 2 cm, linear ramp below.
    let initial_coverage = (snow_depth_cm / 2.0).min(1.0);

    // Slide-off rate: steeper tilt → faster clearing. The Marion model
    // uses an empirical exponential decay with tilt-dependent time constant.
    // τ (hours) = 80 / (1 + 0.5 × tan(tilt)) at 0°C; shorter when warmer.
    let tilt_rad = tilt_deg * PI / 180.0;
    let tau_base = 80.0 / (1.0 + 0.5 * tilt_rad.tan().abs());

    // Temperature acceleration: above 0°C, melting speeds clearing.
    // Below -10°C, snow is sticky and persists much longer.
    let temp_factor = if ambient_temp_c > 0.0 {
        (1.0 - ambient_temp_c * 0.15).max(0.1)
    } else {
        (1.0 + ambient_temp_c.abs() * 0.05).min(3.0)
    };

    let tau = tau_base * temp_factor;
    let coverage = initial_coverage * (-hours_since_snowfall / tau).exp();
    coverage.clamp(0.0, 1.0)
}

/// Snow derate factor (1 - coverage). Multiply with DC power to get
/// snow-adjusted output.
pub fn snow_derate(
    snow_depth_cm: f64,
    ambient_temp_c: f64,
    tilt_deg: f64,
    hours_since_snowfall: f64,
) -> f64 {
    1.0 - snow_coverage(snow_depth_cm, ambient_temp_c, tilt_deg, hours_since_snowfall)
}

// ========================================================================
// 3. LID / PID Degradation
// ========================================================================

/// Light-Induced Degradation (LID) for crystalline silicon modules.
///
/// LID occurs in the first ~100 hours of sun exposure due to boron-oxygen
/// complex formation. Modern PERC/TOPCon modules have lower LID due to
/// gallium doping.
///
/// # Arguments
/// * `cell_tech` — Cell technology identifier: "mono_perc", "topcon", "hjt",
///   "poly", "thin_film".
/// * `years_deployed` — Years since initial exposure.
///
/// # Returns
/// Derate factor (0–1). LID stabilises after the first year.
pub fn lid_derate(cell_tech: &str, years_deployed: f64) -> f64 {
    // LID percentages from IEC 61215 and manufacturer guarantees.
    let lid_pct = match cell_tech {
        "poly" => 3.0,
        "mono_perc" => 2.0,
        "perc_plus" => 1.5,
        "topcon" => 0.5,
        "hjt" => 0.3,
        "ibc" => 0.3,
        "thin_film" => 0.5,
        _ => 2.0,
    };

    // LID stabilises after ~1 year. Model as 1 - exponential saturation.
    let fraction = 1.0 - (-years_deployed * 3.0).exp(); // ~95% at 1 year
    1.0 - (lid_pct / 100.0) * fraction
}

/// Potential-Induced Degradation (PID) annual loss factor.
///
/// PID occurs when high system voltage + humidity causes ion migration
/// in the encapsulant, shunting cells. Modern modules with anti-PID
/// coatings and negative-grounded systems largely avoid PID.
///
/// # Arguments
/// * `system_voltage_v` — Maximum system DC voltage (e.g., 1500).
/// * `has_anti_pid` — Whether the module has anti-PID treatment.
/// * `relative_humidity_pct` — Site average annual RH (0–100).
///
/// # Returns
/// Annual PID derate factor (0–1).
pub fn pid_derate(system_voltage_v: f64, has_anti_pid: bool, relative_humidity_pct: f64) -> f64 {
    if has_anti_pid || system_voltage_v < 600.0 {
        return 1.0; // negligible PID risk
    }
    // Empirical: PID risk scales with voltage and humidity.
    // At 1500V, 80% RH, without anti-PID → ~2% annual loss.
    let voltage_factor = (system_voltage_v / 1500.0).min(1.0);
    let humidity_factor = (relative_humidity_pct / 100.0).clamp(0.0, 1.0);
    let pid_pct = 2.0 * voltage_factor * humidity_factor;
    1.0 - pid_pct / 100.0
}

// ========================================================================
// 4. Inverter Clipping
// ========================================================================

/// Compute the clipping loss when DC power exceeds inverter AC capacity.
///
/// When P_dc > P_ac_max, the inverter limits output to P_ac_max and the
/// excess energy is lost ("clipped"). This occurs during high-irradiance
/// hours with high DC/AC ratios.
///
/// # Arguments
/// * `p_dc_w` — Instantaneous DC array power (W).
/// * `p_ac_max_w` — Inverter maximum AC output (W).
///
/// # Returns
/// Clipped power (W). The delivered power is `p_dc_w - clipped`.
pub fn inverter_clipping(p_dc_w: f64, p_ac_max_w: f64) -> f64 {
    if p_dc_w > p_ac_max_w {
        p_dc_w - p_ac_max_w
    } else {
        0.0
    }
}

/// Inverter clipping derate: fraction of DC power that passes through.
pub fn inverter_clipping_derate(p_dc_w: f64, p_ac_max_w: f64) -> f64 {
    if p_dc_w <= 0.0 {
        return 1.0;
    }
    if p_dc_w <= p_ac_max_w {
        return 1.0;
    }
    p_ac_max_w / p_dc_w
}

// ========================================================================
// 5. DC/AC Ratio Optimizer
// ========================================================================

/// Evaluate a DC/AC ratio by computing annualised clipping loss.
///
/// Higher DC/AC ratios increase clipping during peak hours but improve
/// harvest during shoulder hours (morning, evening, cloudy). The optimal
/// ratio balances additional energy capture against clipping losses.
///
/// # Arguments
/// * `hourly_dc_w` — 8760-element array of hourly DC power (W).
/// * `p_ac_max_w` — Inverter AC capacity (W).
///
/// # Returns
/// `(annual_ac_kwh, clipping_loss_kwh, clipping_pct)`.
pub fn evaluate_dc_ac_ratio(hourly_dc_w: &[f64], p_ac_max_w: f64) -> (f64, f64, f64) {
    let mut total_ac_wh = 0.0_f64;
    let mut total_clipped_wh = 0.0_f64;
    let mut total_dc_wh = 0.0_f64;

    for &pdc in hourly_dc_w {
        total_dc_wh += pdc.max(0.0);
        let clipped = inverter_clipping(pdc, p_ac_max_w);
        total_clipped_wh += clipped;
        total_ac_wh += (pdc - clipped).max(0.0);
    }

    let ac_kwh = total_ac_wh / 1000.0;
    let clipped_kwh = total_clipped_wh / 1000.0;
    let clipping_pct = if total_dc_wh > 0.0 {
        total_clipped_wh / total_dc_wh * 100.0
    } else {
        0.0
    };

    (ac_kwh, clipped_kwh, clipping_pct)
}

/// Find the optimal DC/AC ratio from a set of candidates.
///
/// # Arguments
/// * `hourly_poa_wm2` — 8760 hourly POA irradiance values (W/m²).
/// * `dc_nameplate_w` — DC array nameplate (W) at 1000 W/m².
/// * `p_ac_max_w` — Inverter AC capacity (W).
/// * `candidates` — DC/AC ratios to evaluate (e.g., \[1.1, 1.2, 1.3, 1.4, 1.5\]).
///
/// # Returns
/// `(best_ratio, best_ac_kwh, clipping_pct_at_best)`.
pub fn optimize_dc_ac_ratio(
    hourly_poa_wm2: &[f64],
    dc_nameplate_w: f64,
    p_ac_max_w: f64,
    candidates: &[f64],
) -> (f64, f64, f64) {
    let mut best_ratio = 1.0_f64;
    let mut best_ac = 0.0_f64;
    let mut best_clip_pct = 0.0_f64;

    for &ratio in candidates {
        let scaled_dc: Vec<f64> = hourly_poa_wm2
            .iter()
            .map(|&poa| poa / 1000.0 * dc_nameplate_w * ratio)
            .collect();
        let (ac_kwh, _, clip_pct) = evaluate_dc_ac_ratio(&scaled_dc, p_ac_max_w);
        if ac_kwh > best_ac {
            best_ac = ac_kwh;
            best_ratio = ratio;
            best_clip_pct = clip_pct;
        }
    }

    (best_ratio, best_ac, best_clip_pct)
}

// ========================================================================
// 6. Thermal / Cable Losses
// ========================================================================

/// DC cable resistive loss (I²R) as a function of current and cable properties.
///
/// Reference: NEC Chapter 9 Table 8; IEC 60364-5-52.
///
/// # Arguments
/// * `current_a` — DC string current (A).
/// * `cable_length_m` — One-way cable length from array to combiner/inverter (m).
/// * `cable_resistance_ohm_per_km` — Cable resistance (Ω/km) at operating temp.
///   Typical: 4 mm² Cu = 4.61 Ω/km at 20°C, 6 mm² = 3.08, 10 mm² = 1.83.
/// * `ambient_temp_c` — Ambient temperature for resistance correction.
///
/// # Returns
/// Power loss in watts (both legs: supply + return = 2 × length).
pub fn cable_loss_w(
    current_a: f64,
    cable_length_m: f64,
    cable_resistance_ohm_per_km: f64,
    ambient_temp_c: f64,
) -> f64 {
    // Temperature correction: Cu resistance increases ~0.393 %/°C above 20°C.
    let temp_factor = 1.0 + 0.00393 * (ambient_temp_c - 20.0);
    let r_per_m = cable_resistance_ohm_per_km / 1000.0 * temp_factor;
    let total_r = r_per_m * cable_length_m * 2.0; // both legs
    current_a * current_a * total_r
}

/// Cable loss derate factor: 1 - (loss / power).
pub fn cable_loss_derate(
    current_a: f64,
    voltage_v: f64,
    cable_length_m: f64,
    cable_resistance_ohm_per_km: f64,
    ambient_temp_c: f64,
) -> f64 {
    let power = current_a * voltage_v;
    if power <= 0.0 {
        return 1.0;
    }
    let loss = cable_loss_w(current_a, cable_length_m, cable_resistance_ohm_per_km, ambient_temp_c);
    (1.0 - loss / power).max(0.0)
}

// ========================================================================
// 7. Transformer / Transmission Losses
// ========================================================================

/// Medium-voltage transformer losses: iron (no-load) + copper (load-dependent).
///
/// # Arguments
/// * `p_load_w` — Power flowing through the transformer (W).
/// * `kva_rating` — Transformer nameplate rating (kVA).
/// * `no_load_loss_w` — Iron / core loss at zero load (W). Typical: 0.1–0.3 % of rating.
/// * `full_load_loss_w` — Copper loss at full load (W). Typical: 0.5–1.0 % of rating.
///
/// # Returns
/// Transformer loss in watts.
pub fn transformer_loss_w(
    p_load_w: f64,
    kva_rating: f64,
    no_load_loss_w: f64,
    full_load_loss_w: f64,
) -> f64 {
    if kva_rating <= 0.0 {
        return 0.0;
    }
    let loading = (p_load_w / (kva_rating * 1000.0)).min(1.0);
    // Iron loss is constant; copper loss scales with loading²
    no_load_loss_w + full_load_loss_w * loading * loading
}

/// Transformer derate factor.
pub fn transformer_derate(
    p_load_w: f64,
    kva_rating: f64,
    no_load_loss_w: f64,
    full_load_loss_w: f64,
) -> f64 {
    if p_load_w <= 0.0 {
        return 1.0;
    }
    let loss = transformer_loss_w(p_load_w, kva_rating, no_load_loss_w, full_load_loss_w);
    (1.0 - loss / p_load_w).max(0.0)
}

/// AC transmission line loss (simplified resistive model).
///
/// # Arguments
/// * `p_load_w` — Power flowing (W).
/// * `voltage_v` — Transmission voltage (V).
/// * `distance_km` — One-way transmission distance (km).
/// * `resistance_ohm_per_km` — Line resistance (Ω/km per phase).
/// * `phases` — Number of phases (1 or 3).
///
/// # Returns
/// Transmission loss in watts.
pub fn transmission_loss_w(
    p_load_w: f64,
    voltage_v: f64,
    distance_km: f64,
    resistance_ohm_per_km: f64,
    phases: u32,
) -> f64 {
    if voltage_v <= 0.0 || phases == 0 {
        return 0.0;
    }
    let current_per_phase = p_load_w / (voltage_v * phases as f64);
    let r_total = resistance_ohm_per_km * distance_km * 2.0; // both directions
    current_per_phase * current_per_phase * r_total * phases as f64
}

// ========================================================================
// 8. Availability Derating
// ========================================================================

/// Availability derate factor. Accounts for scheduled maintenance,
/// unplanned outages, grid curtailment, and inverter downtime.
///
/// # Arguments
/// * `planned_downtime_hrs_yr` — Annual scheduled maintenance hours.
/// * `unplanned_outage_hrs_yr` — Expected unplanned outage hours.
/// * `grid_curtailment_pct` — Annual energy curtailed by grid operator (%).
///
/// # Returns
/// Availability derate factor (0–1).
pub fn availability_derate(
    planned_downtime_hrs_yr: f64,
    unplanned_outage_hrs_yr: f64,
    grid_curtailment_pct: f64,
) -> f64 {
    let total_hours = 8760.0;
    let uptime = total_hours - planned_downtime_hrs_yr - unplanned_outage_hrs_yr;
    let time_factor = (uptime / total_hours).clamp(0.0, 1.0);
    let curtailment_factor = 1.0 - (grid_curtailment_pct / 100.0).clamp(0.0, 1.0);
    time_factor * curtailment_factor
}

/// Default availability assumptions for utility-scale solar (NREL ATB 2024).
pub fn default_availability() -> f64 {
    // 50 hrs planned maintenance + 70 hrs unplanned + 0.5 % curtailment
    availability_derate(50.0, 70.0, 0.5)
}

// ========================================================================
// Composite Loss Chain
// ========================================================================

/// All loss components as a structured result.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct LossBreakdown {
    pub soiling: f64,
    pub snow: f64,
    pub lid: f64,
    pub pid: f64,
    pub inverter_clipping: f64,
    pub cable: f64,
    pub transformer: f64,
    pub availability: f64,
    /// Product of all factors → total system derate.
    pub total_derate: f64,
}

impl LossBreakdown {
    pub fn compute_total(&mut self) {
        self.total_derate = self.soiling
            * self.snow
            * self.lid
            * self.pid
            * self.inverter_clipping
            * self.cable
            * self.transformer
            * self.availability;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn soiling_january_temperate() {
        let f = soiling_factor(&soiling_profiles::TEMPERATE, 1);
        assert!((f - 0.99).abs() < 0.001);
    }

    #[test]
    fn soiling_clamps_month() {
        assert_eq!(soiling_factor(&soiling_profiles::ARID, 0), soiling_profiles::ARID[0]); // 0→clamped to 1→idx 0
        assert_eq!(soiling_factor(&soiling_profiles::ARID, 13), soiling_profiles::ARID[11]); // 13→clamped to 12→idx 11
    }

    #[test]
    fn snow_no_snow() {
        assert_eq!(snow_coverage(0.0, -5.0, 30.0, 0.0), 0.0);
    }

    #[test]
    fn snow_clears_over_time() {
        let c0 = snow_coverage(5.0, 2.0, 30.0, 0.0);
        let c24 = snow_coverage(5.0, 2.0, 30.0, 24.0);
        let c72 = snow_coverage(5.0, 2.0, 30.0, 72.0);
        assert!(c0 > c24, "should clear: t=0 {c0} > t=24 {c24}");
        assert!(c24 > c72, "should clear: t=24 {c24} > t=72 {c72}");
    }

    #[test]
    fn snow_steeper_tilt_clears_faster() {
        let c_flat = snow_coverage(5.0, 0.0, 10.0, 24.0);
        let c_steep = snow_coverage(5.0, 0.0, 40.0, 24.0);
        assert!(c_steep < c_flat, "steeper should clear faster: steep={c_steep} flat={c_flat}");
    }

    #[test]
    fn lid_topcon_lower_than_poly() {
        let topcon = lid_derate("topcon", 5.0);
        let poly = lid_derate("poly", 5.0);
        assert!(topcon > poly, "TOPCon should have less LID: topcon={topcon} poly={poly}");
    }

    #[test]
    fn pid_with_anti_pid() {
        assert_eq!(pid_derate(1500.0, true, 80.0), 1.0);
    }

    #[test]
    fn clipping_below_limit() {
        assert_eq!(inverter_clipping(90_000.0, 100_000.0), 0.0);
        assert_eq!(inverter_clipping_derate(90_000.0, 100_000.0), 1.0);
    }

    #[test]
    fn clipping_above_limit() {
        let clip = inverter_clipping(120_000.0, 100_000.0);
        assert!((clip - 20_000.0).abs() < 0.01);
        let derate = inverter_clipping_derate(120_000.0, 100_000.0);
        assert!((derate - 100_000.0 / 120_000.0).abs() < 0.001);
    }

    #[test]
    fn cable_loss_increases_with_length() {
        let short = cable_loss_w(15.0, 20.0, 4.61, 25.0);
        let long = cable_loss_w(15.0, 100.0, 4.61, 25.0);
        assert!(long > short);
    }

    #[test]
    fn cable_loss_increases_with_temp() {
        let cold = cable_loss_w(15.0, 50.0, 4.61, 10.0);
        let hot = cable_loss_w(15.0, 50.0, 4.61, 50.0);
        assert!(hot > cold, "hotter should increase resistance");
    }

    #[test]
    fn transformer_iron_plus_copper() {
        // At 50 % load: loss = iron + copper × 0.25
        let loss = transformer_loss_w(500_000.0, 1000.0, 1000.0, 10_000.0);
        let expected = 1000.0 + 10_000.0 * 0.25;
        assert!((loss - expected).abs() < 1.0, "got {loss}, want {expected}");
    }

    #[test]
    fn availability_default() {
        let a = default_availability();
        // 8760 - 120 = 8640 hrs uptime → 98.6 % × (1 - 0.005) ≈ 98.1 %
        assert!(a > 0.97 && a < 0.99, "default availability: got {a}");
    }

    #[test]
    fn dc_ac_ratio_evaluation() {
        // 8760 hours, constant 800 W DC, inverter at 1000 W → no clipping
        let hourly = vec![800.0; 8760];
        let (ac_kwh, clip_kwh, clip_pct) = evaluate_dc_ac_ratio(&hourly, 1000.0);
        assert!((clip_kwh).abs() < 0.01, "no clipping expected");
        assert!((clip_pct).abs() < 0.01);
        assert!((ac_kwh - 800.0 * 8760.0 / 1000.0).abs() < 1.0);
    }

    #[test]
    fn loss_breakdown_total() {
        let mut lb = LossBreakdown {
            soiling: 0.97,
            snow: 0.99,
            lid: 0.98,
            pid: 1.0,
            inverter_clipping: 0.97,
            cable: 0.98,
            transformer: 0.99,
            availability: 0.98,
            total_derate: 0.0,
        };
        lb.compute_total();
        let expected = 0.97 * 0.99 * 0.98 * 1.0 * 0.97 * 0.98 * 0.99 * 0.98;
        assert!((lb.total_derate - expected).abs() < 0.001, "got {}, want {}", lb.total_derate, expected);
    }
}
