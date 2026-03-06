use serde::{Deserialize, Serialize};
use std::f64::consts::PI;

use crate::solar_position::{calculate_sun_position, SolarParams, SunPosition};

const DEG_TO_RAD: f64 = PI / 180.0;

/// Solar irradiance constant (W/m²) at Earth's mean distance from the Sun.
const SOLAR_CONSTANT: f64 = 1361.0;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct IrradianceResult {
    /// Direct normal irradiance (W/m²)
    pub dni: f64,
    /// Diffuse horizontal irradiance (W/m²)
    pub dhi: f64,
    /// Global horizontal irradiance (W/m²)
    pub ghi: f64,
    /// Plane of array irradiance (W/m²)
    pub poa: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnnualYieldResult {
    /// Total annual irradiation on the plane of array (kWh/m²)
    pub annual_poa_kwh_m2: f64,
    /// Total energy yield (kWh)
    pub annual_yield_kwh: f64,
    /// Performance ratio
    pub performance_ratio: f64,
    /// Monthly irradiation values (kWh/m²)
    pub monthly_poa_kwh_m2: [f64; 12],
}

pub struct IrradianceCalculator {
    pub latitude: f64,
    pub longitude: f64,
    pub timezone_offset: f64,
    pub panel_tilt: f64,
    pub panel_azimuth: f64,
    pub panel_efficiency: f64,
    pub system_losses: f64,
}

impl IrradianceCalculator {
    pub fn new(
        latitude: f64,
        longitude: f64,
        timezone_offset: f64,
        panel_tilt: f64,
        panel_azimuth: f64,
        panel_efficiency: f64,
        system_losses: f64,
    ) -> Self {
        Self {
            latitude,
            longitude,
            timezone_offset,
            panel_tilt,
            panel_azimuth,
            panel_efficiency,
            system_losses,
        }
    }

    /// Calculate instantaneous irradiance for a given sun position.
    ///
    /// Uses the simplified clear-sky model based on Hottel (1976) and Liu-Jordan
    /// for beam and diffuse components.
    pub fn calculate_irradiance(&self, sun: &SunPosition) -> IrradianceResult {
        if sun.elevation <= 0.0 {
            return IrradianceResult {
                dni: 0.0,
                dhi: 0.0,
                ghi: 0.0,
                poa: 0.0,
            };
        }

        let zenith_rad = sun.zenith * DEG_TO_RAD;
        let elevation_rad = sun.elevation * DEG_TO_RAD;

        // Air mass (Kasten & Young, 1989)
        let air_mass = 1.0
            / (elevation_rad.sin()
                + 0.50572 * (6.07995 + sun.elevation).powf(-1.6364));

        // Clear sky DNI using simplified Hottel model
        let altitude_km = 0.0; // assume sea level
        let a0 = 0.4237 - 0.00821 * (6.0 - altitude_km).powi(2);
        let a1 = 0.5055 + 0.00595 * (6.5 - altitude_km).powi(2);
        let k = 0.2711 + 0.01858 * (2.5 - altitude_km).powi(2);

        let tau_b = a0 + a1 * (-k * air_mass).exp();
        let dni = SOLAR_CONSTANT * tau_b;

        // Diffuse fraction (Liu-Jordan)
        let tau_d = 0.271 - 0.294 * tau_b;
        let dhi = SOLAR_CONSTANT * tau_d * zenith_rad.cos();

        // Global horizontal
        let ghi = dni * zenith_rad.cos() + dhi;

        // Plane of array irradiance
        let poa = self.calculate_poa(dni, dhi, ghi, sun);

        IrradianceResult {
            dni: dni.max(0.0),
            dhi: dhi.max(0.0),
            ghi: ghi.max(0.0),
            poa: poa.max(0.0),
        }
    }

    /// Calculate plane-of-array irradiance using the isotropic sky model.
    fn calculate_poa(&self, dni: f64, dhi: f64, ghi: f64, sun: &SunPosition) -> f64 {
        let tilt_rad = self.panel_tilt * DEG_TO_RAD;
        let panel_az_rad = self.panel_azimuth * DEG_TO_RAD;
        let sun_az_rad = sun.azimuth * DEG_TO_RAD;
        let sun_el_rad = sun.elevation * DEG_TO_RAD;

        // Angle of incidence on the tilted surface
        let cos_aoi = sun_el_rad.sin() * tilt_rad.cos()
            + sun_el_rad.cos() * tilt_rad.sin() * (sun_az_rad - panel_az_rad).cos();

        // Beam component on tilted surface
        let beam = dni * cos_aoi.max(0.0);

        // Diffuse component (isotropic sky model)
        let diffuse = dhi * (1.0 + tilt_rad.cos()) / 2.0;

        // Ground-reflected component (albedo = 0.2)
        let albedo = 0.2;
        let ground_reflected = ghi * albedo * (1.0 - tilt_rad.cos()) / 2.0;

        beam + diffuse + ground_reflected
    }

    /// Calculate annual energy yield for a system.
    pub fn calculate_annual_yield(
        &self,
        year: i32,
        system_capacity_kw: f64,
        time_step_minutes: u32,
    ) -> AnnualYieldResult {
        use rayon::prelude::*;

        let time_step_hours = time_step_minutes as f64 / 60.0;
        let days_per_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        let monthly_results: Vec<f64> = (0..12u32)
            .into_par_iter()
            .map(|month_idx| {
                let month = month_idx + 1;
                let days = days_per_month[month_idx as usize];
                let mut monthly_poa = 0.0;

                for day in 1..=days {
                    let steps_per_day = (24 * 60) / time_step_minutes;
                    for step in 0..steps_per_day {
                        let hour = (step * time_step_minutes) as f64 / 60.0;
                        let params = SolarParams {
                            latitude: self.latitude,
                            longitude: self.longitude,
                            year,
                            month,
                            day,
                            hour,
                            timezone_offset: self.timezone_offset,
                        };
                        let sun = calculate_sun_position(&params);
                        let irr = self.calculate_irradiance(&sun);
                        monthly_poa += irr.poa * time_step_hours;
                    }
                }

                // Convert Wh/m² to kWh/m²
                monthly_poa / 1000.0
            })
            .collect();

        let annual_poa: f64 = monthly_results.iter().sum();
        let annual_yield = system_capacity_kw * annual_poa * self.panel_efficiency
            * (1.0 - self.system_losses);
        let performance_ratio = if annual_poa > 0.0 {
            annual_yield / (system_capacity_kw * annual_poa)
        } else {
            0.0
        };

        let mut monthly_poa_kwh_m2 = [0.0; 12];
        for (i, val) in monthly_results.iter().enumerate() {
            monthly_poa_kwh_m2[i] = *val;
        }

        AnnualYieldResult {
            annual_poa_kwh_m2: annual_poa,
            annual_yield_kwh: annual_yield,
            performance_ratio,
            monthly_poa_kwh_m2,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_clear_sky_irradiance() {
        let calc = IrradianceCalculator::new(35.0, -120.0, -8.0, 25.0, 180.0, 0.20, 0.14);

        let sun = SunPosition {
            azimuth: 180.0,
            elevation: 70.0,
            zenith: 20.0,
            hour_angle: 0.0,
            declination: 23.0,
        };

        let irr = calc.calculate_irradiance(&sun);
        assert!(irr.dni > 500.0, "DNI should be significant at high elevation");
        assert!(irr.ghi > 500.0, "GHI should be significant");
        assert!(irr.poa > 0.0, "POA should be positive");
    }

    #[test]
    fn test_no_irradiance_at_night() {
        let calc = IrradianceCalculator::new(35.0, -120.0, -8.0, 25.0, 180.0, 0.20, 0.14);

        let sun = SunPosition {
            azimuth: 0.0,
            elevation: -10.0,
            zenith: 100.0,
            hour_angle: 0.0,
            declination: 0.0,
        };

        let irr = calc.calculate_irradiance(&sun);
        assert_eq!(irr.dni, 0.0);
        assert_eq!(irr.ghi, 0.0);
        assert_eq!(irr.poa, 0.0);
    }
}
