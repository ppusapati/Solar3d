//! Mismatch and Partial Shading Model (String Level)
//!
//! When modules in a series string receive non-uniform irradiance, the string
//! current is limited by the weakest module. This model estimates the power
//! loss from such mismatch, accounting for bypass diode activation.
//!
//! Reference: Picault, D. et al. (2010), Solar Energy 84, 1301-1309.

/// Compute string-level mismatch power loss.
///
/// # Arguments
/// * `irradiances` — Per-module POA irradiance (W/m²) for each module in string.
/// * `bypass_diode_groups` — Cells per bypass diode group (e.g., 24 for 72-cell
///   with 3 diodes). 0 = no bypass diodes.
/// * `cells_per_module` — Total cells per module.
///
/// # Returns
/// `(loss, active_bypasses)` where `loss` is fractional power loss (0–1) and
/// `active_bypasses` is number of bypass diode groups activated.
pub fn string_mismatch_loss(
    irradiances: &[f64],
    bypass_diode_groups: u32,
    cells_per_module: u32,
) -> (f64, u32) {
    let n = irradiances.len();
    if n == 0 {
        return (0.0, 0);
    }

    let max_irr = irradiances.iter().cloned().fold(0.0_f64, f64::max);
    if max_irr <= 0.0 {
        return (1.0, 0);
    }

    // Normalise to [0, 1]
    let normalised: Vec<f64> = irradiances.iter().map(|g| (g / max_irr).max(0.0)).collect();

    // Without bypass diodes: current limited by weakest module
    if bypass_diode_groups == 0 || cells_per_module == 0 {
        let weakest = normalised.iter().cloned().fold(f64::INFINITY, f64::min);
        return (1.0 - weakest, 0);
    }

    let mut sorted = normalised.clone();
    sorted.sort_by(|a, b| a.partial_cmp(b).unwrap_or(std::cmp::Ordering::Equal));

    let bypass_threshold = 0.70;
    let groups_per_module = (cells_per_module / bypass_diode_groups).max(1);
    let median_irr = sorted[n / 2];

    let total_ideal = n as f64;
    let mut total_actual = 0.0_f64;
    let mut active_bypass_count = 0_u32;

    for &module_irr in &normalised {
        if module_irr >= median_irr * bypass_threshold {
            total_actual += module_irr;
        } else {
            // Module partially bypassed
            let mut bypassed = 0_u32;
            for _ in 0..groups_per_module {
                if module_irr < median_irr * bypass_threshold {
                    bypassed += 1;
                }
            }
            active_bypass_count += bypassed;
            let active_fraction =
                (groups_per_module - bypassed) as f64 / groups_per_module as f64;
            total_actual += module_irr * active_fraction;
        }
    }

    let loss = if total_ideal > 0.0 {
        (1.0 - total_actual / total_ideal).max(0.0)
    } else {
        1.0
    };

    (loss, active_bypass_count)
}

/// Generate per-module irradiance array for a uniform shading scenario.
///
/// # Arguments
/// * `total_modules` — Number of modules in string.
/// * `shaded_modules` — Number of shaded modules (counted from index 0).
/// * `shading_fraction` — Fraction of irradiance blocked on shaded modules (0–1).
/// * `unshaded_irradiance` — POA irradiance on unshaded modules (W/m²).
pub fn shading_to_irradiances(
    total_modules: usize,
    shaded_modules: usize,
    shading_fraction: f64,
    unshaded_irradiance: f64,
) -> Vec<f64> {
    (0..total_modules)
        .map(|i| {
            if i < shaded_modules {
                unshaded_irradiance * (1.0 - shading_fraction).max(0.0)
            } else {
                unshaded_irradiance
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn no_mismatch_uniform_irradiance() {
        let irr = vec![1000.0; 24];
        let (loss, bypassed) = string_mismatch_loss(&irr, 24, 72);
        assert!(loss < 0.001, "uniform irradiance should have no loss: got {loss}");
        assert_eq!(bypassed, 0);
    }

    #[test]
    fn full_shade_one_module_no_bypass() {
        let mut irr = vec![1000.0; 12];
        irr[0] = 0.0; // one module fully shaded
        let (loss, _) = string_mismatch_loss(&irr, 0, 0);
        assert!((loss - 1.0).abs() < 0.001, "full shade without bypass → 100% loss: got {loss}");
    }

    #[test]
    fn partial_shade_with_bypass() {
        let mut irr = vec![1000.0; 24];
        irr[0] = 200.0; // one module heavily shaded
        let (loss, bypassed) = string_mismatch_loss(&irr, 24, 72);
        assert!(loss > 0.0, "should have some loss");
        assert!(loss < 0.5, "bypass diodes should limit loss: got {loss}");
        assert!(bypassed > 0, "bypass diodes should activate");
    }

    #[test]
    fn shading_helper() {
        let irr = shading_to_irradiances(10, 3, 0.5, 1000.0);
        assert_eq!(irr.len(), 10);
        assert_eq!(irr[0], 500.0);
        assert_eq!(irr[2], 500.0);
        assert_eq!(irr[3], 1000.0);
        assert_eq!(irr[9], 1000.0);
    }

    #[test]
    fn empty_string() {
        let (loss, _) = string_mismatch_loss(&[], 24, 72);
        assert_eq!(loss, 0.0);
    }

    #[test]
    fn all_dark() {
        let irr = vec![0.0; 10];
        let (loss, _) = string_mismatch_loss(&irr, 24, 72);
        assert!((loss - 1.0).abs() < 0.001);
    }
}
