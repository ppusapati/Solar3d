//! NEC / IEC Code Compliance Rule Engine
//!
//! Validates PV system designs against electrical code requirements and returns
//! structured violation reports with fix suggestions.

use serde::{Deserialize, Serialize};

/// A single code violation or warning.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Violation {
    pub code: String,          // e.g., "NEC-690.7(A)"
    pub severity: Severity,
    pub message: String,
    pub suggestion: String,
    pub parameter: String,     // the field that violated
    pub actual_value: String,
    pub limit_value: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum Severity {
    Error,   // hard violation — must fix
    Warning, // advisory — should fix
    Info,    // informational
}

/// Input parameters for a full NEC 690/705/706 compliance check.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NECComplianceInput {
    // System-level
    pub system_voltage_dc: f64,      // max DC system voltage
    pub system_voltage_ac: f64,      // AC output voltage
    pub total_dc_kw: f64,
    pub total_ac_kw: f64,

    // String-level
    pub voc_cold_string: f64,        // worst-case string Voc
    pub isc_hot_string: f64,         // worst-case string Isc
    pub max_inverter_input_v: f64,
    pub max_inverter_input_a: f64,

    // Wiring
    pub dc_conductor_ampacity: f64,
    pub dc_ocpd_rating: f64,         // overcurrent protection device
    pub ac_conductor_ampacity: f64,
    pub ac_ocpd_rating: f64,

    // Grounding
    pub has_gfdi: bool,              // ground-fault detection & interruption
    pub has_equipment_ground: bool,
    pub gec_size_mm2: f64,

    // Disconnects
    pub has_dc_disconnect: bool,
    pub has_ac_disconnect: bool,
    pub has_rapid_shutdown: bool,    // NEC 690.12

    // Labeling
    pub has_dc_labels: bool,         // NEC 690.31(G)
    pub has_arc_flash_labels: bool,  // NFPA 70E
}

/// Validate a PV system against NEC 690, 705, and 706.
pub fn validate_nec(input: &NECComplianceInput) -> Vec<Violation> {
    let mut violations = Vec::new();

    // NEC 690.7(A): Maximum system voltage
    if input.voc_cold_string > input.max_inverter_input_v {
        violations.push(Violation {
            code: "NEC-690.7(A)".into(),
            severity: Severity::Error,
            message: format!("String Voc_cold ({:.1}V) exceeds inverter max input ({:.0}V)", input.voc_cold_string, input.max_inverter_input_v),
            suggestion: "Reduce modules per string or select inverter with higher max input voltage".into(),
            parameter: "voc_cold_string".into(),
            actual_value: format!("{:.1}", input.voc_cold_string),
            limit_value: format!("{:.0}", input.max_inverter_input_v),
        });
    }

    // NEC 690.8(A)(1): DC conductor sizing ≥ 125% of Isc
    let required_dc_ampacity = input.isc_hot_string * 1.25;
    if input.dc_conductor_ampacity < required_dc_ampacity {
        violations.push(Violation {
            code: "NEC-690.8(A)(1)".into(),
            severity: Severity::Error,
            message: format!("DC conductor ampacity ({:.0}A) < 125% × Isc ({:.1}A = {:.1}A)", input.dc_conductor_ampacity, input.isc_hot_string, required_dc_ampacity),
            suggestion: "Upsize DC conductors to meet 125% continuous duty requirement".into(),
            parameter: "dc_conductor_ampacity".into(),
            actual_value: format!("{:.0}", input.dc_conductor_ampacity),
            limit_value: format!("{:.1}", required_dc_ampacity),
        });
    }

    // NEC 690.9(A): DC OCPD ≥ 125% × Isc and ≤ conductor ampacity
    let min_ocpd = input.isc_hot_string * 1.25;
    if input.dc_ocpd_rating < min_ocpd {
        violations.push(Violation {
            code: "NEC-690.9(A)".into(),
            severity: Severity::Error,
            message: format!("DC OCPD ({:.0}A) < 125% × Isc ({:.1}A)", input.dc_ocpd_rating, min_ocpd),
            suggestion: "Increase OCPD rating to at least 125% of Isc".into(),
            parameter: "dc_ocpd_rating".into(),
            actual_value: format!("{:.0}", input.dc_ocpd_rating),
            limit_value: format!("{:.1}", min_ocpd),
        });
    }
    if input.dc_ocpd_rating > input.dc_conductor_ampacity {
        violations.push(Violation {
            code: "NEC-240.4".into(),
            severity: Severity::Error,
            message: format!("DC OCPD ({:.0}A) exceeds conductor ampacity ({:.0}A)", input.dc_ocpd_rating, input.dc_conductor_ampacity),
            suggestion: "Upsize conductors or reduce OCPD rating".into(),
            parameter: "dc_ocpd_rating".into(),
            actual_value: format!("{:.0}", input.dc_ocpd_rating),
            limit_value: format!("{:.0}", input.dc_conductor_ampacity),
        });
    }

    // NEC 690.12: Rapid shutdown (required for buildings)
    if !input.has_rapid_shutdown {
        violations.push(Violation {
            code: "NEC-690.12".into(),
            severity: Severity::Warning,
            message: "Rapid shutdown not configured".into(),
            suggestion: "Install module-level rapid shutdown per NEC 690.12(B)(2) or array-level per 690.12(B)(1)".into(),
            parameter: "has_rapid_shutdown".into(),
            actual_value: "false".into(),
            limit_value: "true".into(),
        });
    }

    // NEC 690.41: Ground-fault protection
    if !input.has_gfdi && input.system_voltage_dc > 50.0 {
        violations.push(Violation {
            code: "NEC-690.41".into(),
            severity: Severity::Error,
            message: "Ground-fault detection and interruption (GFDI) required for systems > 50V DC".into(),
            suggestion: "Install GFDI device per NEC 690.41(B)".into(),
            parameter: "has_gfdi".into(),
            actual_value: "false".into(),
            limit_value: "true".into(),
        });
    }

    // NEC 690.47: Equipment grounding
    if !input.has_equipment_ground {
        violations.push(Violation {
            code: "NEC-690.47".into(),
            severity: Severity::Error,
            message: "Equipment grounding conductor required".into(),
            suggestion: "Install EGC per NEC 690.47 and 250.122".into(),
            parameter: "has_equipment_ground".into(),
            actual_value: "false".into(),
            limit_value: "true".into(),
        });
    }

    // NEC 690.13: DC disconnect
    if !input.has_dc_disconnect {
        violations.push(Violation {
            code: "NEC-690.13".into(),
            severity: Severity::Error,
            message: "DC disconnect means required".into(),
            suggestion: "Install DC disconnect switch accessible to first responders".into(),
            parameter: "has_dc_disconnect".into(),
            actual_value: "false".into(),
            limit_value: "true".into(),
        });
    }

    // NEC 690.15: AC disconnect
    if !input.has_ac_disconnect {
        violations.push(Violation {
            code: "NEC-690.15".into(),
            severity: Severity::Error,
            message: "AC disconnect means required".into(),
            suggestion: "Install AC disconnect between inverter and utility interconnection".into(),
            parameter: "has_ac_disconnect".into(),
            actual_value: "false".into(),
            limit_value: "true".into(),
        });
    }

    // NEC 690.31(G): DC labeling
    if !input.has_dc_labels {
        violations.push(Violation {
            code: "NEC-690.31(G)".into(),
            severity: Severity::Warning,
            message: "DC conductor marking/labeling required".into(),
            suggestion: "Label all DC conductors per NEC 690.31(G) at every 3m and at accessible locations".into(),
            parameter: "has_dc_labels".into(),
            actual_value: "false".into(),
            limit_value: "true".into(),
        });
    }

    // NFPA 70E: Arc-flash labels
    if !input.has_arc_flash_labels {
        violations.push(Violation {
            code: "NFPA-70E-130.5(H)".into(),
            severity: Severity::Warning,
            message: "Arc-flash warning labels required on all electrical equipment".into(),
            suggestion: "Install arc-flash labels per NFPA 70E 130.5(H) showing incident energy and PPE category".into(),
            parameter: "has_arc_flash_labels".into(),
            actual_value: "false".into(),
            limit_value: "true".into(),
        });
    }

    // NEC 705.12: Utility interconnection
    if input.total_ac_kw > 0.0 && input.system_voltage_ac > 0.0 {
        let ac_current = input.total_ac_kw * 1000.0 / (3.0_f64.sqrt() * input.system_voltage_ac);
        let required_ac_ampacity = ac_current * 1.25;
        if input.ac_conductor_ampacity < required_ac_ampacity {
            violations.push(Violation {
                code: "NEC-705.12".into(),
                severity: Severity::Error,
                message: format!("AC conductor ampacity ({:.0}A) < 125% of output current ({:.1}A)", input.ac_conductor_ampacity, required_ac_ampacity),
                suggestion: "Upsize AC conductors for continuous duty per NEC 705.12".into(),
                parameter: "ac_conductor_ampacity".into(),
                actual_value: format!("{:.0}", input.ac_conductor_ampacity),
                limit_value: format!("{:.1}", required_ac_ampacity),
            });
        }
    }

    violations
}

/// IEC 60364 compliance check (simplified — key rules for PV installations).
pub fn validate_iec60364(input: &NECComplianceInput) -> Vec<Violation> {
    let mut violations = Vec::new();

    // IEC 60364-7-712: PV system voltage limits
    if input.system_voltage_dc > 1500.0 {
        violations.push(Violation {
            code: "IEC-60364-7-712-512.1.1".into(),
            severity: Severity::Error,
            message: format!("DC system voltage ({:.0}V) exceeds IEC limit of 1500V DC", input.system_voltage_dc),
            suggestion: "Reduce string length to bring system voltage ≤ 1500V DC".into(),
            parameter: "system_voltage_dc".into(),
            actual_value: format!("{:.0}", input.system_voltage_dc),
            limit_value: "1500".into(),
        });
    }

    // IEC 60364-4-43: Cable protection
    if input.dc_ocpd_rating > input.dc_conductor_ampacity {
        violations.push(Violation {
            code: "IEC-60364-4-43-433.1".into(),
            severity: Severity::Error,
            message: "Protective device rating exceeds cable current-carrying capacity".into(),
            suggestion: "Select protective device ≤ cable Iz per IEC 60364-4-43".into(),
            parameter: "dc_ocpd_rating".into(),
            actual_value: format!("{:.0}", input.dc_ocpd_rating),
            limit_value: format!("{:.0}", input.dc_conductor_ampacity),
        });
    }

    // IEC 62548: PV string overcurrent protection
    if input.isc_hot_string > 0.0 {
        let min_fuse = input.isc_hot_string * 1.5;
        let max_fuse = input.isc_hot_string * 2.4;
        if input.dc_ocpd_rating < min_fuse || input.dc_ocpd_rating > max_fuse {
            violations.push(Violation {
                code: "IEC-62548-7.3.3".into(),
                severity: Severity::Warning,
                message: format!("String fuse ({:.0}A) outside IEC 62548 range ({:.1}A – {:.1}A)", input.dc_ocpd_rating, min_fuse, max_fuse),
                suggestion: format!("Select fuse between {:.0}A and {:.0}A per IEC 62548 §7.3.3", min_fuse.ceil(), max_fuse.floor()),
                parameter: "dc_ocpd_rating".into(),
                actual_value: format!("{:.0}", input.dc_ocpd_rating),
                limit_value: format!("{:.1}–{:.1}", min_fuse, max_fuse),
            });
        }
    }

    violations
}

#[cfg(test)]
mod tests {
    use super::*;

    fn compliant_input() -> NECComplianceInput {
        NECComplianceInput {
            system_voltage_dc: 1500.0,
            system_voltage_ac: 800.0,
            total_dc_kw: 1000.0,
            total_ac_kw: 800.0,
            voc_cold_string: 1450.0,
            isc_hot_string: 18.0,
            max_inverter_input_v: 1500.0,
            max_inverter_input_a: 30.0,
            dc_conductor_ampacity: 30.0,
            dc_ocpd_rating: 25.0,
            ac_conductor_ampacity: 1000.0,
            ac_ocpd_rating: 800.0,
            has_gfdi: true,
            has_equipment_ground: true,
            gec_size_mm2: 33.6,
            has_dc_disconnect: true,
            has_ac_disconnect: true,
            has_rapid_shutdown: true,
            has_dc_labels: true,
            has_arc_flash_labels: true,
        }
    }

    #[test]
    fn compliant_system_no_errors() {
        let v = validate_nec(&compliant_input());
        let errors: Vec<_> = v.iter().filter(|v| v.severity == Severity::Error).collect();
        assert!(errors.is_empty(), "should have no errors: {:?}", errors);
    }

    #[test]
    fn overvoltage_detected() {
        let mut input = compliant_input();
        input.voc_cold_string = 1600.0; // exceeds 1500V
        let v = validate_nec(&input);
        assert!(v.iter().any(|v| v.code == "NEC-690.7(A)"));
    }

    #[test]
    fn undersized_conductor_detected() {
        let mut input = compliant_input();
        input.dc_conductor_ampacity = 20.0; // < 125% × 18 = 22.5
        let v = validate_nec(&input);
        assert!(v.iter().any(|v| v.code == "NEC-690.8(A)(1)"));
    }

    #[test]
    fn missing_gfdi_detected() {
        let mut input = compliant_input();
        input.has_gfdi = false;
        let v = validate_nec(&input);
        assert!(v.iter().any(|v| v.code == "NEC-690.41"));
    }

    #[test]
    fn iec_overvoltage() {
        let mut input = compliant_input();
        input.system_voltage_dc = 1600.0;
        let v = validate_iec60364(&input);
        assert!(v.iter().any(|v| v.code.contains("IEC-60364")));
    }
}
