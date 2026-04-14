use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct TranspositionResult {
    pub poa_irradiance: f64,
    pub aoi: f64,
    pub incidence_modulation: f64,
}

pub struct TranspositionModel;

impl TranspositionModel {
    /// Transponiere using Perez All-Weather model
    pub fn perez_all_weather(
        ghi_w_m2: f64,
        dhi_w_m2: f64,
        _wind_speed_m_s: f64,
        _temperature_c: f64,
        surface_tilt_deg: f64,
        surface_azimuth_deg: f64,
        solar_altitude_deg: f64,
        solar_azimuth_deg: f64,
    ) -> Result<TranspositionResult, String> {
        if !ghi_w_m2.is_finite() || ghi_w_m2 < 0.0 {
            return Err("GHI must be non-negative".to_string());
        }
        if !dhi_w_m2.is_finite() || dhi_w_m2 < 0.0 {
            return Err("DHI must be non-negative".to_string());
        }
        if !surface_tilt_deg.is_finite()
            || surface_tilt_deg < 0.0
            || surface_tilt_deg > 180.0
        {
            return Err("surface tilt must be 0-180 degrees".to_string());
        }
        if !surface_azimuth_deg.is_finite() {
            return Err("surface azimuth must be finite".to_string());
        }
        if !solar_altitude_deg.is_finite()
            || solar_altitude_deg < -90.0
            || solar_altitude_deg > 90.0
        {
            return Err("solar altitude must be -90 to 90 degrees".to_string());
        }

        let dni = if ghi_w_m2 > 0.0 && solar_altitude_deg > 0.0 {
            (ghi_w_m2 - dhi_w_m2) / solar_altitude_deg.to_radians().sin()
        } else {
            0.0
        };

        let aoi = Self::angle_of_incidence(
            surface_tilt_deg,
            surface_azimuth_deg,
            solar_altitude_deg,
            solar_azimuth_deg,
        )?;

        let direct = if aoi < 90.0 {
            dni * aoi.to_radians().cos().max(0.0)
        } else {
            0.0
        };

        let kd = Self::clearness_index(ghi_w_m2, solar_altitude_deg);
        let f1 = Self::perez_f1(kd);
        let _f2 = Self::perez_f2(kd);

        let rb = if aoi.abs() < 90.0 {
            aoi.to_radians().cos() / solar_altitude_deg.to_radians().sin()
        } else {
            0.0
        };

        let diffuse = dhi_w_m2
            * ((1.0 - f1) * ((1.0 + surface_tilt_deg.to_radians().cos()) / 2.0)
                + f1 * (rb.max(0.0)));

        let reflected = Self::isotropic_reflection(ghi_w_m2, surface_tilt_deg);

        let poa = (direct + diffuse + reflected).max(0.0);

        Ok(TranspositionResult {
            poa_irradiance: poa,
            aoi,
            incidence_modulation: aoi.to_radians().cos().max(0.0),
        })
    }

    pub fn angle_of_incidence(
        surface_tilt_deg: f64,
        surface_azimuth_deg: f64,
        solar_altitude_deg: f64,
        solar_azimuth_deg: f64,
    ) -> Result<f64, String> {
        if !surface_tilt_deg.is_finite()
            || surface_tilt_deg < 0.0
            || surface_tilt_deg > 180.0
        {
            return Err("surface tilt must be 0-180 degrees".to_string());
        }
        if !surface_azimuth_deg.is_finite() {
            return Err("surface azimuth must be finite".to_string());
        }
        if !solar_altitude_deg.is_finite()
            || solar_altitude_deg < -90.0
            || solar_altitude_deg > 90.0
        {
            return Err("solar altitude must be -90 to 90 degrees".to_string());
        }
        if !solar_azimuth_deg.is_finite() {
            return Err("solar azimuth must be finite".to_string());
        }

        let tilt_rad = surface_tilt_deg.to_radians();
        let azim_diff_rad = (surface_azimuth_deg - solar_azimuth_deg).to_radians();
        let alt_rad = solar_altitude_deg.to_radians();

        let aoi_rad = (tilt_rad.cos() * alt_rad.sin()
            + tilt_rad.sin() * alt_rad.cos() * azim_diff_rad.cos())
            .acos();

        Ok(aoi_rad.to_degrees().min(180.0))
    }

    pub fn clearness_index(ghi_w_m2: f64, solar_altitude_deg: f64) -> f64 {
        if solar_altitude_deg <= 0.0 {
            return 0.0;
        }

        let _air_mass = 1.0 / (solar_altitude_deg.to_radians().sin() + 0.5057 * (-96.07995 *solar_altitude_deg.to_radians().sin()).exp());
        let extraterrestrial = 1361.0 * (solar_altitude_deg.to_radians().sin()).max(0.0);

        if extraterrestrial > 0.0 {
            (ghi_w_m2 / extraterrestrial).min(1.0)
        } else {
            0.0
        }
    }

    pub fn perez_f1(kd: f64) -> f64 {
        let kd_clamped = kd.max(0.0).min(1.0);
        let f1 = 0.6915 + 0.74 * kd_clamped - 0.64 * kd_clamped.powi(2);
        f1.max(0.0).min(1.0)
    }

    pub fn perez_f2(kd: f64) -> f64 {
        let kd_clamped = kd.max(0.0).min(1.0);
        let f2 = 0.2000 + 0.55 * kd_clamped - 0.313 * kd_clamped.powi(2);
        f2.max(0.0).min(1.0)
    }

    pub fn isotropic_reflection(ghi_w_m2: f64, surface_tilt_deg: f64) -> f64 {
        let ground_reflectance = 0.25;
        ghi_w_m2 * ground_reflectance * ((180.0 - surface_tilt_deg).to_radians().cos() + 1.0) / 2.0
    }

    pub fn model_comparison(
        ghi_w_m2: f64,
        dhi_w_m2: f64,
        surface_tilt_deg: f64,
        solar_altitude_deg: f64,
    ) -> Result<f64, String> {
        let isotropic = Self::isotropic_diffuse(ghi_w_m2, dhi_w_m2, surface_tilt_deg);
        let klucher = Self::klucher_model(ghi_w_m2, dhi_w_m2, surface_tilt_deg, solar_altitude_deg)?;
        
        Ok((isotropic + klucher) / 2.0)
    }

    pub fn isotropic_diffuse(
        _ghi_w_m2: f64,
        dhi_w_m2: f64,
        surface_tilt_deg: f64,
    ) -> f64 {
        dhi_w_m2 * ((1.0 + surface_tilt_deg.to_radians().cos()) / 2.0)
    }

    pub fn klucher_model(
        ghi_w_m2: f64,
        dhi_w_m2: f64,
        surface_tilt_deg: f64,
        solar_altitude_deg: f64,
    ) -> Result<f64, String> {
        if solar_altitude_deg <= 0.0 {
            return Ok(0.0);
        }

        let kd = Self::clearness_index(ghi_w_m2, solar_altitude_deg);
        let f = 1.020 - 0.254 * kd + 0.0123 * solar_altitude_deg.to_radians().sin();

        let tilt_factor = (1.0 + surface_tilt_deg.to_radians().cos()) / 2.0;
        let diffuse = dhi_w_m2 * tilt_factor * f;

        Ok(diffuse.max(0.0))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn angle_of_incidence_normal() {
        let aoi = TranspositionModel::angle_of_incidence(
            0.0, 0.0, 90.0, 0.0,
        )
        .expect("AOI calculation succeeds");

        assert!(aoi < 1.0);
    }

    #[test]
    fn angle_of_incidence_tilted() {
        let aoi = TranspositionModel::angle_of_incidence(
            20.0, 180.0, 45.0, 0.0,
        )
        .expect("AOI calculation succeeds");

        assert!(aoi > 0.0 && aoi < 180.0);
    }

    #[test]
    fn clearness_index_reasonable() {
        let kd = TranspositionModel::clearness_index(800.0, 45.0);
        assert!(kd > 0.0 && kd < 1.0);
    }

    #[test]
    fn perez_f1_bounded() {
        let f1_low = TranspositionModel::perez_f1(0.2);
        let f1_high = TranspositionModel::perez_f1(0.8);

        assert!(f1_low > 0.0 && f1_low < 1.0);
        assert!(f1_high > 0.0 && f1_high < 1.0);
    }

    #[test]
    fn isotropic_reflection_positive() {
        let reflection =
            TranspositionModel::isotropic_reflection(1000.0, 30.0);

        assert!(reflection > 0.0);
    }

    #[test]
    fn transposition_produces_reasonable_poa() {
        let result = TranspositionModel::perez_all_weather(
            800.0, 100.0, 3.0, 25.0, 20.0, 180.0, 60.0, 180.0
        )
        .expect("transposition succeeds");

        assert!(result.poa_irradiance > 0.0);
        assert!(result.aoi > 0.0 && result.aoi < 90.0);
    }
}
