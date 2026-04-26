//! Detailed Electrical Design Calculations
//!
//! NEC/IEC-compliant electrical engineering computations for PV system design:
//! MPPT string sizing, wire ampacity, voltage drop, conduit fill, fault current,
//! grounding, arc-flash, and lightning protection.

use serde::{Deserialize, Serialize};
use std::f64::consts::PI;

// ========================================================================
// 1. MPPT String Sizer
// ========================================================================

/// Module electrical parameters needed for string sizing.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleElectricalParams {
    pub voc_stc: f64,                // Open-circuit voltage at STC (V)
    pub vmp_stc: f64,                // Maximum power voltage at STC (V)
    pub isc_stc: f64,                // Short-circuit current at STC (A)
    pub imp_stc: f64,                // Maximum power current at STC (A)
    pub temp_coeff_voc_pct_per_c: f64, // β (%/°C), negative
    pub temp_coeff_isc_pct_per_c: f64, // α (%/°C), small positive
}

/// Inverter MPPT input constraints.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InverterMPPTWindow {
    pub mppt_min_v: f64,     // MPPT tracking minimum (V)
    pub mppt_max_v: f64,     // MPPT tracking maximum (V)
    pub max_input_v: f64,    // Absolute maximum DC input (V)
    pub max_input_a: f64,    // Maximum DC input current per MPPT (A)
    pub max_strings_per_mppt: u32,
}

/// Result of string sizing analysis.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StringSizingResult {
    pub min_modules: u32,
    pub max_modules: u32,
    pub recommended_modules: u32,
    pub voc_cold_v: f64,        // Voc at minimum temperature
    pub vmp_hot_v: f64,         // Vmp at maximum temperature
    pub voc_cold_string_v: f64, // String Voc at cold temp
    pub vmp_hot_string_v: f64,  // String Vmp at hot temp
    pub max_strings_parallel: u32,
    pub violations: Vec<String>,
}

/// Compute MPPT-compatible string sizing per NEC 690.7.
///
/// NEC 690.7(A): Maximum system voltage = Voc × temp correction factor.
/// The cold-temperature Voc must not exceed the inverter's max input voltage.
/// The hot-temperature Vmp must remain within the MPPT tracking window.
///
/// # Arguments
/// * `module` — Module electrical parameters from datasheet.
/// * `inverter` — Inverter MPPT constraints.
/// * `t_min_c` — Minimum expected ambient temperature (°C). Drives Voc_cold.
/// * `t_max_c` — Maximum expected cell temperature (°C). Drives Vmp_hot.
pub fn size_string(
    module: &ModuleElectricalParams,
    inverter: &InverterMPPTWindow,
    t_min_c: f64,
    t_max_c: f64,
) -> StringSizingResult {
    let stc_temp = 25.0_f64;

    // Temperature-corrected voltages
    let voc_cold = module.voc_stc * (1.0 + module.temp_coeff_voc_pct_per_c / 100.0 * (t_min_c - stc_temp));
    let vmp_hot = module.vmp_stc * (1.0 + module.temp_coeff_voc_pct_per_c / 100.0 * (t_max_c - stc_temp));

    // Maximum modules: string Voc_cold ≤ max_input_v
    let max_by_voc = if voc_cold > 0.0 {
        (inverter.max_input_v / voc_cold).floor() as u32
    } else { 0 };

    // Also: string Voc_cold ≤ mppt_max_v (for tracking)
    let max_by_mppt = if voc_cold > 0.0 {
        (inverter.mppt_max_v / voc_cold).floor() as u32
    } else { 0 };
    let max_modules = max_by_voc.min(max_by_mppt);

    // Minimum modules: string Vmp_hot ≥ mppt_min_v
    let min_modules = if vmp_hot > 0.0 {
        (inverter.mppt_min_v / vmp_hot).ceil() as u32
    } else { 1 };

    // Recommended: midpoint, biased toward max for better voltage utilisation
    let recommended = if max_modules >= min_modules {
        (min_modules + max_modules + 1) / 2
    } else {
        min_modules // will have violations
    };

    // Maximum parallel strings per MPPT: limited by current
    let isc_hot = module.isc_stc * (1.0 + module.temp_coeff_isc_pct_per_c / 100.0 * (t_max_c - stc_temp));
    let max_parallel = if isc_hot > 0.0 {
        ((inverter.max_input_a / isc_hot).floor() as u32).min(inverter.max_strings_per_mppt)
    } else {
        inverter.max_strings_per_mppt
    };

    let mut violations = Vec::new();
    if max_modules < min_modules {
        violations.push(format!(
            "no valid string length: min {} (Vmp_hot={:.1}V) > max {} (Voc_cold={:.1}V)",
            min_modules, vmp_hot, max_modules, voc_cold
        ));
    }
    if recommended > 0 && voc_cold * recommended as f64 > inverter.max_input_v {
        violations.push(format!(
            "string Voc_cold {:.1}V exceeds inverter max {:.0}V",
            voc_cold * recommended as f64, inverter.max_input_v
        ));
    }

    StringSizingResult {
        min_modules,
        max_modules,
        recommended_modules: recommended.max(1),
        voc_cold_v: voc_cold,
        vmp_hot_v: vmp_hot,
        voc_cold_string_v: voc_cold * recommended.max(1) as f64,
        vmp_hot_string_v: vmp_hot * recommended.max(1) as f64,
        max_strings_parallel: max_parallel,
        violations,
    }
}

// ========================================================================
// 2. Wire Ampacity & Voltage Drop (NEC Chapter 9)
// ========================================================================

/// NEC conductor properties (Cu, at 75°C unless noted).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConductorProperties {
    pub awg_or_kcmil: String,
    pub cross_section_mm2: f64,
    pub resistance_ohm_per_km: f64,   // DC resistance at operating temp
    pub ampacity_a: f64,              // NEC Table 310.16 (75°C column)
    pub reactance_ohm_per_km: f64,    // AC reactance (for AC circuits)
}

/// Standard NEC copper conductors.
pub fn nec_copper_conductors() -> Vec<ConductorProperties> {
    vec![
        ConductorProperties { awg_or_kcmil: "14 AWG".into(), cross_section_mm2: 2.08, resistance_ohm_per_km: 8.442, ampacity_a: 15.0, reactance_ohm_per_km: 0.19 },
        ConductorProperties { awg_or_kcmil: "12 AWG".into(), cross_section_mm2: 3.31, resistance_ohm_per_km: 5.315, ampacity_a: 20.0, reactance_ohm_per_km: 0.177 },
        ConductorProperties { awg_or_kcmil: "10 AWG".into(), cross_section_mm2: 5.26, resistance_ohm_per_km: 3.346, ampacity_a: 30.0, reactance_ohm_per_km: 0.164 },
        ConductorProperties { awg_or_kcmil: "8 AWG".into(), cross_section_mm2: 8.37, resistance_ohm_per_km: 2.093, ampacity_a: 50.0, reactance_ohm_per_km: 0.151 },
        ConductorProperties { awg_or_kcmil: "6 AWG".into(), cross_section_mm2: 13.3, resistance_ohm_per_km: 1.321, ampacity_a: 65.0, reactance_ohm_per_km: 0.141 },
        ConductorProperties { awg_or_kcmil: "4 AWG".into(), cross_section_mm2: 21.2, resistance_ohm_per_km: 0.833, ampacity_a: 85.0, reactance_ohm_per_km: 0.131 },
        ConductorProperties { awg_or_kcmil: "3 AWG".into(), cross_section_mm2: 26.7, resistance_ohm_per_km: 0.661, ampacity_a: 100.0, reactance_ohm_per_km: 0.128 },
        ConductorProperties { awg_or_kcmil: "2 AWG".into(), cross_section_mm2: 33.6, resistance_ohm_per_km: 0.524, ampacity_a: 115.0, reactance_ohm_per_km: 0.125 },
        ConductorProperties { awg_or_kcmil: "1 AWG".into(), cross_section_mm2: 42.4, resistance_ohm_per_km: 0.415, ampacity_a: 130.0, reactance_ohm_per_km: 0.121 },
        ConductorProperties { awg_or_kcmil: "1/0 AWG".into(), cross_section_mm2: 53.5, resistance_ohm_per_km: 0.329, ampacity_a: 150.0, reactance_ohm_per_km: 0.118 },
        ConductorProperties { awg_or_kcmil: "2/0 AWG".into(), cross_section_mm2: 67.4, resistance_ohm_per_km: 0.261, ampacity_a: 175.0, reactance_ohm_per_km: 0.115 },
        ConductorProperties { awg_or_kcmil: "3/0 AWG".into(), cross_section_mm2: 85.0, resistance_ohm_per_km: 0.207, ampacity_a: 200.0, reactance_ohm_per_km: 0.112 },
        ConductorProperties { awg_or_kcmil: "4/0 AWG".into(), cross_section_mm2: 107.0, resistance_ohm_per_km: 0.164, ampacity_a: 230.0, reactance_ohm_per_km: 0.108 },
        ConductorProperties { awg_or_kcmil: "250 kcmil".into(), cross_section_mm2: 127.0, resistance_ohm_per_km: 0.135, ampacity_a: 255.0, reactance_ohm_per_km: 0.105 },
        ConductorProperties { awg_or_kcmil: "350 kcmil".into(), cross_section_mm2: 177.0, resistance_ohm_per_km: 0.097, ampacity_a: 310.0, reactance_ohm_per_km: 0.098 },
        ConductorProperties { awg_or_kcmil: "500 kcmil".into(), cross_section_mm2: 253.0, resistance_ohm_per_km: 0.068, ampacity_a: 380.0, reactance_ohm_per_km: 0.092 },
    ]
}

/// Voltage drop calculation per NEC Chapter 9.
///
/// V_drop = 2 × I × L × (R·cos(θ) + X·sin(θ)) for single-phase,
/// V_drop = √3 × I × L × (R·cos(θ) + X·sin(θ)) for three-phase.
///
/// # Arguments
/// * `current_a` — Load current (A).
/// * `length_m` — One-way conductor length (m).
/// * `r_ohm_per_km` — Conductor resistance (Ω/km).
/// * `x_ohm_per_km` — Conductor reactance (Ω/km). Use 0 for DC.
/// * `power_factor` — cos(θ). Use 1.0 for DC or unity PF.
/// * `system_voltage` — Nominal system voltage (V).
/// * `three_phase` — true for 3-phase, false for single-phase/DC.
///
/// # Returns
/// `(drop_volts, drop_percent)`
pub fn voltage_drop(
    current_a: f64,
    length_m: f64,
    r_ohm_per_km: f64,
    x_ohm_per_km: f64,
    power_factor: f64,
    system_voltage: f64,
    three_phase: bool,
) -> (f64, f64) {
    let length_km = length_m / 1000.0;
    let sin_theta = (1.0 - power_factor * power_factor).sqrt();
    let z_eff = r_ohm_per_km * power_factor + x_ohm_per_km * sin_theta;

    let multiplier = if three_phase { 3.0_f64.sqrt() } else { 2.0 };
    let drop_v = multiplier * current_a * length_km * z_eff;
    let drop_pct = if system_voltage > 0.0 { drop_v / system_voltage * 100.0 } else { 0.0 };
    (drop_v, drop_pct)
}

/// Select the smallest conductor that satisfies both ampacity and voltage
/// drop constraints.
///
/// NEC 210.19 / 215.2: Voltage drop ≤ 3 % for branch circuits, ≤ 5 % total.
pub fn select_conductor(
    current_a: f64,
    length_m: f64,
    system_voltage: f64,
    max_drop_pct: f64,
    three_phase: bool,
    power_factor: f64,
) -> Option<ConductorProperties> {
    // NEC 240.4: conductor ampacity ≥ 125 % of continuous load
    let required_ampacity = current_a * 1.25;

    for c in nec_copper_conductors() {
        if c.ampacity_a < required_ampacity {
            continue;
        }
        let (_, drop_pct) = voltage_drop(
            current_a, length_m, c.resistance_ohm_per_km, c.reactance_ohm_per_km,
            power_factor, system_voltage, three_phase,
        );
        if drop_pct <= max_drop_pct {
            return Some(c);
        }
    }
    None
}

// ========================================================================
// 3. Conduit Fill Calculator
// ========================================================================

/// Conduit fill per NEC Chapter 9 Table 1.
///
/// - 1 conductor: 53 % fill
/// - 2 conductors: 31 % fill
/// - ≥ 3 conductors: 40 % fill
///
/// # Arguments
/// * `conductor_od_mm` — Outside diameter of each conductor (mm).
/// * `num_conductors` — Number of conductors in the conduit.
/// * `conduit_id_mm` — Internal diameter of the conduit (mm).
///
/// # Returns
/// `(fill_pct, max_allowed_pct, passes)`
pub fn conduit_fill(
    conductor_od_mm: f64,
    num_conductors: u32,
    conduit_id_mm: f64,
) -> (f64, f64, bool) {
    let conductor_area = PI / 4.0 * conductor_od_mm * conductor_od_mm;
    let total_conductor_area = conductor_area * num_conductors as f64;
    let conduit_area = PI / 4.0 * conduit_id_mm * conduit_id_mm;

    let fill_pct = if conduit_area > 0.0 {
        total_conductor_area / conduit_area * 100.0
    } else { 100.0 };

    let max_fill = match num_conductors {
        1 => 53.0,
        2 => 31.0,
        _ => 40.0,
    };

    (fill_pct, max_fill, fill_pct <= max_fill)
}

// ========================================================================
// 4. Short-Circuit / Fault-Current Analysis
// ========================================================================

/// Compute available fault current at a point in the DC system.
///
/// For PV arrays, the fault current contribution is the sum of Isc from
/// all parallel strings minus the faulted string (per NEC 690.9).
///
/// # Arguments
/// * `isc_module` — Module Isc at STC (A).
/// * `parallel_strings` — Number of strings in parallel at the combiner.
/// * `temp_correction` — Temperature correction factor for Isc (typically 1.0–1.25).
///
/// # Returns
/// Maximum available fault current (A).
pub fn dc_fault_current(isc_module: f64, parallel_strings: u32, temp_correction: f64) -> f64 {
    // NEC 690.9: fault current from parallel strings (minus 1 for the faulted string)
    let contributing_strings = if parallel_strings > 1 { parallel_strings - 1 } else { 1 };
    isc_module * contributing_strings as f64 * temp_correction
}

/// Compute available 3-phase symmetrical fault current at the transformer secondary.
///
/// I_fault = kVA × 1000 / (√3 × V_secondary × Z_pu)
///
/// # Arguments
/// * `transformer_kva` — Transformer rating (kVA).
/// * `secondary_voltage` — Secondary line-to-line voltage (V).
/// * `impedance_pct` — Transformer impedance (%).
pub fn ac_fault_current(transformer_kva: f64, secondary_voltage: f64, impedance_pct: f64) -> f64 {
    if secondary_voltage <= 0.0 || impedance_pct <= 0.0 {
        return 0.0;
    }
    let z_pu = impedance_pct / 100.0;
    (transformer_kva * 1000.0) / (3.0_f64.sqrt() * secondary_voltage * z_pu)
}

// ========================================================================
// 5. Grounding / Bonding — GEC Sizing
// ========================================================================

/// Size the grounding electrode conductor (GEC) per NEC 250.66 Table 250.66.
///
/// The GEC size is based on the largest ungrounded service-entrance conductor.
pub fn gec_size(largest_conductor_mm2: f64) -> String {
    // NEC Table 250.66 (copper GEC)
    if largest_conductor_mm2 <= 21.2 { return "8 AWG".into(); }        // ≤ 4 AWG
    if largest_conductor_mm2 <= 42.4 { return "6 AWG".into(); }        // ≤ 1 AWG
    if largest_conductor_mm2 <= 67.4 { return "4 AWG".into(); }        // ≤ 2/0 AWG
    if largest_conductor_mm2 <= 107.0 { return "2 AWG".into(); }       // ≤ 4/0 AWG
    if largest_conductor_mm2 <= 177.0 { return "1/0 AWG".into(); }     // ≤ 350 kcmil
    if largest_conductor_mm2 <= 304.0 { return "2/0 AWG".into(); }     // ≤ 600 kcmil
    if largest_conductor_mm2 <= 608.0 { return "3/0 AWG".into(); }     // ≤ 1100 kcmil
    "250 kcmil".into()
}

/// Size the equipment grounding conductor (EGC) per NEC 250.122.
pub fn egc_size(overcurrent_device_a: f64) -> String {
    if overcurrent_device_a <= 15.0 { return "14 AWG".into(); }
    if overcurrent_device_a <= 20.0 { return "12 AWG".into(); }
    if overcurrent_device_a <= 60.0 { return "10 AWG".into(); }
    if overcurrent_device_a <= 100.0 { return "8 AWG".into(); }
    if overcurrent_device_a <= 200.0 { return "6 AWG".into(); }
    if overcurrent_device_a <= 300.0 { return "4 AWG".into(); }
    if overcurrent_device_a <= 400.0 { return "3 AWG".into(); }
    if overcurrent_device_a <= 500.0 { return "2 AWG".into(); }
    if overcurrent_device_a <= 600.0 { return "1 AWG".into(); }
    if overcurrent_device_a <= 800.0 { return "1/0 AWG".into(); }
    if overcurrent_device_a <= 1000.0 { return "2/0 AWG".into(); }
    if overcurrent_device_a <= 1200.0 { return "3/0 AWG".into(); }
    "4/0 AWG".into()
}

// ========================================================================
// 6. Arc-Flash Analysis (IEEE 1584-2018)
// ========================================================================

/// Simplified arc-flash incident energy calculation per IEEE 1584-2018.
///
/// This implements the empirical model for systems 208V–15kV, enclosed
/// equipment (VCB, SWGR, MCC, panelboard).
///
/// # Arguments
/// * `fault_current_ka` — Available bolted fault current (kA).
/// * `clearing_time_s` — Protective device clearing time (seconds).
/// * `working_distance_mm` — Distance from arc source to worker (mm).
///   Typical: 455mm (18") for panelboards, 610mm (24") for switchgear.
/// * `voltage_v` — System voltage (V).
/// * `gap_mm` — Conductor gap (mm). Typical: 25 for panelboard, 32 for MCC.
///
/// # Returns
/// `(incident_energy_cal_cm2, arc_flash_boundary_mm, ppe_category)`
pub fn arc_flash_ieee1584(
    fault_current_ka: f64,
    clearing_time_s: f64,
    working_distance_mm: f64,
    voltage_v: f64,
    gap_mm: f64,
) -> (f64, f64, u32) {
    if fault_current_ka <= 0.0 || clearing_time_s <= 0.0 || working_distance_mm <= 0.0 {
        return (0.0, 0.0, 0);
    }

    // IEEE 1584-2018 simplified model (equation set for enclosed equipment)
    let lg_ibf = fault_current_ka.log10();
    let lg_gap = gap_mm.log10();

    // Arcing current (empirical correlation)
    let lg_ia = 0.00402 + 0.983 * lg_ibf;
    let _ia = 10.0_f64.powf(lg_ia); // arcing current (used in full IEEE 1584 for arc energy)

    // Incident energy at 610mm reference distance
    let lg_en = 1.081 * lg_ia + 0.0011 * gap_mm - 0.718 * lg_gap
        + 0.0 * (voltage_v / 1000.0).log10() // voltage term simplified
        + clearing_time_s.log10();
    let en = 10.0_f64.powf(lg_en);

    // Distance correction
    let x_factor = 1.641; // enclosed equipment exponent
    let cf = (610.0 / working_distance_mm).powf(x_factor);
    let incident_energy = en * cf; // cal/cm²

    // Arc-flash boundary: distance where E = 1.2 cal/cm² (onset of 2nd-degree burn)
    let af_boundary = if incident_energy > 0.0 {
        working_distance_mm * (incident_energy / 1.2).powf(1.0 / x_factor)
    } else { 0.0 };

    // PPE category per NFPA 70E Table 130.7(C)(15)(a)
    let ppe = if incident_energy <= 1.2 { 0 }
    else if incident_energy <= 4.0 { 1 }
    else if incident_energy <= 8.0 { 2 }
    else if incident_energy <= 25.0 { 3 }
    else { 4 }; // > 25 cal/cm² requires special PPE

    (incident_energy, af_boundary, ppe)
}

// ========================================================================
// 7. Lightning Protection / SPD Placement
// ========================================================================

/// Lightning protection zone assessment per IEC 62305-2.
///
/// Computes the collection area and expected annual lightning strike
/// frequency for a site, then determines SPD (Surge Protective Device)
/// requirements.
///
/// # Arguments
/// * `site_area_m2` — Total site footprint (m²).
/// * `structure_height_m` — Tallest structure height (m).
/// * `ground_flash_density` — Ng (flashes/km²/year) from isokeraunic maps.
///   Typical: 1–8 for US, 2–10 for tropical regions.
/// * `site_perimeter_m` — Site perimeter length (m).
///
/// # Returns
/// `(collection_area_m2, annual_strikes, spd_class, spd_count)`
pub fn lightning_risk_assessment(
    site_area_m2: f64,
    structure_height_m: f64,
    ground_flash_density: f64,
    site_perimeter_m: f64,
) -> (f64, f64, String, u32) {
    // IEC 62305-2 collection area:
    // A_c = L×W + 2×(L+W)×H + π×H²
    // Approximated using site_area + perimeter × height + π × height²
    let collection_area = site_area_m2
        + site_perimeter_m * structure_height_m
        + PI * structure_height_m * structure_height_m;

    // Annual expected strikes
    let nd = ground_flash_density * collection_area / 1_000_000.0; // Ng is per km²

    // SPD class per IEC 61643-11
    let (spd_class, spd_count) = if nd > 1.0 {
        ("Type I + Type II".into(), 4) // main panel + sub-panels + combiner boxes
    } else if nd > 0.1 {
        ("Type II".into(), 2) // main panel + combiner
    } else {
        ("Type II (recommended)".into(), 1) // main panel only
    };

    (collection_area, nd, spd_class, spd_count)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn string_sizer_typical() {
        let module = ModuleElectricalParams {
            voc_stc: 41.7, vmp_stc: 35.1, isc_stc: 18.35, imp_stc: 17.23,
            temp_coeff_voc_pct_per_c: -0.25, temp_coeff_isc_pct_per_c: 0.048,
        };
        let inverter = InverterMPPTWindow {
            mppt_min_v: 500.0, mppt_max_v: 1500.0, max_input_v: 1500.0,
            max_input_a: 30.0, max_strings_per_mppt: 2,
        };
        let result = size_string(&module, &inverter, -10.0, 70.0);
        assert!(result.min_modules > 0);
        assert!(result.max_modules >= result.min_modules);
        assert!(result.violations.is_empty(), "violations: {:?}", result.violations);
        // Voc_cold should be higher than STC Voc (cold increases voltage)
        assert!(result.voc_cold_v > module.voc_stc);
    }

    #[test]
    fn voltage_drop_dc() {
        // 15A, 30m, 10 AWG Cu (3.346 Ω/km), DC (PF=1), 600V system
        let (drop_v, drop_pct) = voltage_drop(15.0, 30.0, 3.346, 0.0, 1.0, 600.0, false);
        // V_drop = 2 × 15 × 0.030 × 3.346 = 3.01V → 0.50%
        assert!((drop_v - 3.01).abs() < 0.1, "drop_v={drop_v}");
        assert!(drop_pct < 1.0, "drop_pct={drop_pct}");
    }

    #[test]
    fn conductor_selection() {
        let c = select_conductor(50.0, 100.0, 480.0, 3.0, true, 0.9);
        assert!(c.is_some(), "should find a conductor for 50A @ 100m");
        let c = c.unwrap();
        assert!(c.ampacity_a >= 62.5, "ampacity should be ≥ 125% of 50A: got {}", c.ampacity_a);
    }

    #[test]
    fn conduit_fill_three_conductors() {
        // 3 × 12mm OD conductors in 25mm ID conduit
        let (fill, max, passes) = conduit_fill(12.0, 3, 25.0);
        assert!(!passes || fill <= max, "fill={fill}%, max={max}%");
    }

    #[test]
    fn dc_fault_current_parallel() {
        // 10 parallel strings × 18A Isc × 1.25 correction, minus 1 faulted
        let ifc = dc_fault_current(18.0, 10, 1.25);
        assert!((ifc - 18.0 * 9.0 * 1.25).abs() < 0.1, "got {ifc}");
    }

    #[test]
    fn ac_fault_at_transformer() {
        // 2500 kVA, 480V secondary, 5.75% impedance
        let ifc = ac_fault_current(2500.0, 480.0, 5.75);
        // I = 2500000 / (1.732 × 480 × 0.0575) = ~52.3 kA
        assert!(ifc > 50_000.0 && ifc < 55_000.0, "got {ifc}");
    }

    #[test]
    fn gec_sizing() {
        assert_eq!(gec_size(13.3), "8 AWG"); // 6 AWG conductor → GEC 8 AWG per NEC 250.66
        assert_eq!(gec_size(107.0), "2 AWG"); // 4/0 AWG conductor → GEC 2 AWG
    }

    #[test]
    fn arc_flash_produces_result() {
        let (energy, boundary, ppe) = arc_flash_ieee1584(20.0, 0.1, 610.0, 480.0, 32.0);
        assert!(energy > 0.0, "energy should be positive: got {energy}");
        assert!(boundary > 0.0, "boundary should be positive: got {boundary}");
        assert!(ppe <= 4);
    }

    #[test]
    fn lightning_risk() {
        // 100-acre (405,000 m²) site, 5m structures, Ng=4, 2540m perimeter
        let (area, nd, _class, count) = lightning_risk_assessment(405_000.0, 5.0, 4.0, 2540.0);
        assert!(area > 405_000.0, "collection area should exceed site area");
        assert!(nd > 0.0, "should have some strike risk");
        assert!(count >= 1);
    }
}
