use serde::{Deserialize, Serialize};
use ndarray::Array2;

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct WeatherFeatures {
    pub temperature_c: f64,
    pub irradiance_w_m2: f64,
    pub humidity_percent: f64,
    pub pressure_mb: f64,
    pub wind_speed_m_s: f64,
}

impl WeatherFeatures {
    pub fn validate(&self) -> Result<(), String> {
        if !self.temperature_c.is_finite() {
            return Err("temperature must be finite".to_string());
        }
        if !self.irradiance_w_m2.is_finite() || self.irradiance_w_m2 < 0.0 {
            return Err("irradiance must be non-negative and finite".to_string());
        }
        if !(0.0..=100.0).contains(&self.humidity_percent) {
            return Err("humidity must be 0-100%".to_string());
        }
        if !self.pressure_mb.is_finite() || self.pressure_mb < 800.0 || self.pressure_mb > 1100.0 {
            return Err("pressure out of realistic range (800-1100 mb)".to_string());
        }
        if !self.wind_speed_m_s.is_finite() || self.wind_speed_m_s < 0.0 {
            return Err("wind speed must be non-negative and finite".to_string());
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct SolarFeatures {
    pub solar_altitude_deg: f64,
    pub solar_azimuth_deg: f64,
    pub air_mass: f64,
    pub clearness_index: f64,
}

impl SolarFeatures {
    pub fn validate(&self) -> Result<(), String> {
        if !self.solar_altitude_deg.is_finite() || self.solar_altitude_deg < -90.0 || self.solar_altitude_deg > 90.0 {
            return Err("solar altitude must be -90 to 90 degrees".to_string());
        }
        if !self.solar_azimuth_deg.is_finite() {
            return Err("solar azimuth must be finite".to_string());
        }
        if !self.air_mass.is_finite() || self.air_mass < 0.0 {
            return Err("air mass must be non-negative".to_string());
        }
        if !self.clearness_index.is_finite() || self.clearness_index < 0.0 || self.clearness_index > 1.0 {
            return Err("clearness index must be 0-1".to_string());
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TimeFeatures {
    pub hour_of_day: u32,
    pub day_of_year: u32,
    pub month: u32,
    pub is_weekend: bool,
}

impl TimeFeatures {
    pub fn validate(&self) -> Result<(), String> {
        if self.hour_of_day >= 24 {
            return Err("hour must be 0-23".to_string());
        }
        if self.day_of_year == 0 || self.day_of_year > 366 {
            return Err("day of year must be 1-366".to_string());
        }
        if self.month == 0 || self.month > 12 {
            return Err("month must be 1-12".to_string());
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FeatureVector {
    pub features: Vec<f64>,
    pub feature_names: Vec<String>,
}

pub struct FeaturePipeline {
    weather_norm_mean: Option<WeatherNormalization>,
}

#[derive(Debug, Clone)]
struct WeatherNormalization {
    temp_mean: f64,
    temp_std: f64,
    irrad_mean: f64,
    irrad_std: f64,
    humidity_mean: f64,
    humidity_std: f64,
    pressure_mean: f64,
    pressure_std: f64,
    wind_mean: f64,
    wind_std: f64,
}

impl FeaturePipeline {
    pub fn new() -> Self {
        Self {
            weather_norm_mean: None,
        }
    }

    pub fn fit_normalization(&mut self, samples: &[WeatherFeatures]) -> Result<(), String> {
        if samples.is_empty() {
            return Err("cannot fit normalization on empty samples".to_string());
        }

        for sample in samples {
            sample.validate()?;
        }

        let mut temp_sum = 0.0;
        let mut irrad_sum = 0.0;
        let mut humidity_sum = 0.0;
        let mut pressure_sum = 0.0;
        let mut wind_sum = 0.0;

        for sample in samples {
            temp_sum += sample.temperature_c;
            irrad_sum += sample.irradiance_w_m2;
            humidity_sum += sample.humidity_percent;
            pressure_sum += sample.pressure_mb;
            wind_sum += sample.wind_speed_m_s;
        }

        let n = samples.len() as f64;
        let temp_mean = temp_sum / n;
        let irrad_mean = irrad_sum / n;
        let humidity_mean = humidity_sum / n;
        let pressure_mean = pressure_sum / n;
        let wind_mean = wind_sum / n;

        let mut temp_var = 0.0;
        let mut irrad_var = 0.0;
        let mut humidity_var = 0.0;
        let mut pressure_var = 0.0;
        let mut wind_var = 0.0;

        for sample in samples {
            temp_var += (sample.temperature_c - temp_mean).powi(2);
            irrad_var += (sample.irradiance_w_m2 - irrad_mean).powi(2);
            humidity_var += (sample.humidity_percent - humidity_mean).powi(2);
            pressure_var += (sample.pressure_mb - pressure_mean).powi(2);
            wind_var += (sample.wind_speed_m_s - wind_mean).powi(2);
        }

        self.weather_norm_mean = Some(WeatherNormalization {
            temp_mean,
            temp_std: (temp_var / n).sqrt().max(1e-6),
            irrad_mean,
            irrad_std: (irrad_var / n).sqrt().max(1e-6),
            humidity_mean,
            humidity_std: (humidity_var / n).sqrt().max(1e-6),
            pressure_mean,
            pressure_std: (pressure_var / n).sqrt().max(1e-6),
            wind_mean,
            wind_std: (wind_var / n).sqrt().max(1e-6),
        });

        Ok(())
    }

    pub fn extract_features(
        &self,
        weather: WeatherFeatures,
        solar: SolarFeatures,
        time: TimeFeatures,
    ) -> Result<FeatureVector, String> {
        weather.validate()?;
        solar.validate()?;
        time.validate()?;

        let mut features = Vec::new();
        let mut feature_names = Vec::new();

        features.push(weather.temperature_c);
        feature_names.push("temperature_c".to_string());

        features.push(weather.irradiance_w_m2);
        feature_names.push("irradiance_w_m2".to_string());

        features.push(weather.humidity_percent);
        feature_names.push("humidity_percent".to_string());

        features.push(weather.pressure_mb);
        feature_names.push("pressure_mb".to_string());

        features.push(weather.wind_speed_m_s);
        feature_names.push("wind_speed_m_s".to_string());

        features.push(solar.solar_altitude_deg);
        feature_names.push("solar_altitude_deg".to_string());

        features.push(solar.solar_azimuth_deg);
        feature_names.push("solar_azimuth_deg".to_string());

        features.push(solar.air_mass);
        feature_names.push("air_mass".to_string());

        features.push(solar.clearness_index);
        feature_names.push("clearness_index".to_string());

        features.push(time.hour_of_day as f64);
        feature_names.push("hour_of_day".to_string());

        features.push(time.day_of_year as f64);
        feature_names.push("day_of_year".to_string());

        features.push(time.month as f64);
        feature_names.push("month".to_string());

        features.push(if time.is_weekend { 1.0 } else { 0.0 });
        feature_names.push("is_weekend".to_string());

        features.push((time.hour_of_day as f64).sin());
        feature_names.push("hour_sin".to_string());

        features.push((time.hour_of_day as f64).cos());
        feature_names.push("hour_cos".to_string());

        features.push((time.day_of_year as f64 * std::f64::consts::TAU / 365.0).sin());
        feature_names.push("day_sin".to_string());

        features.push((time.day_of_year as f64 * std::f64::consts::TAU / 365.0).cos());
        feature_names.push("day_cos".to_string());

        let normalized = if let Some(norm) = &self.weather_norm_mean {
            let temp_norm = (weather.temperature_c - norm.temp_mean) / norm.temp_std;
            let irrad_norm = (weather.irradiance_w_m2 - norm.irrad_mean) / norm.irrad_std;
            let humidity_norm = (weather.humidity_percent - norm.humidity_mean) / norm.humidity_std;
            let pressure_norm = (weather.pressure_mb - norm.pressure_mean) / norm.pressure_std;
            let wind_norm = (weather.wind_speed_m_s - norm.wind_mean) / norm.wind_std;

            vec![
                temp_norm,
                irrad_norm,
                humidity_norm,
                pressure_norm,
                wind_norm,
            ]
        } else {
            vec![
                weather.temperature_c / 50.0,
                weather.irradiance_w_m2 / 1000.0,
                weather.humidity_percent / 100.0,
                weather.pressure_mb / 1000.0,
                weather.wind_speed_m_s / 20.0,
            ]
        };

        features.extend(normalized);
        feature_names.extend(vec![
            "temp_norm".to_string(),
            "irrad_norm".to_string(),
            "humidity_norm".to_string(),
            "pressure_norm".to_string(),
            "wind_norm".to_string(),
        ]);

        Ok(FeatureVector {
            features,
            feature_names,
        })
    }

    pub fn to_array(&self, fv: &FeatureVector) -> Array2<f32> {
        let features: Vec<f32> = fv.features.iter().map(|&f| f as f32).collect();
        Array2::from_shape_vec((1, features.len()), features).unwrap()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_weather() -> WeatherFeatures {
        WeatherFeatures {
            temperature_c: 25.0,
            irradiance_w_m2: 800.0,
            humidity_percent: 60.0,
            pressure_mb: 1013.0,
            wind_speed_m_s: 3.5,
        }
    }

    fn sample_solar() -> SolarFeatures {
        SolarFeatures {
            solar_altitude_deg: 45.0,
            solar_azimuth_deg: 180.0,
            air_mass: 1.5,
            clearness_index: 0.75,
        }
    }

    fn sample_time() -> TimeFeatures {
        TimeFeatures {
            hour_of_day: 12,
            day_of_year: 180,
            month: 6,
            is_weekend: false,
        }
    }

    #[test]
    fn weather_features_validates() {
        let mut w = sample_weather();
        assert!(w.validate().is_ok());

        w.temperature_c = f64::NAN;
        assert!(w.validate().is_err());

        w.temperature_c = 25.0;
        w.irradiance_w_m2 = -1.0;
        assert!(w.validate().is_err());

        w.irradiance_w_m2 = 800.0;
        w.humidity_percent = 150.0;
        assert!(w.validate().is_err());
    }

    #[test]
    fn solar_features_validates() {
        let mut s = sample_solar();
        assert!(s.validate().is_ok());

        s.solar_altitude_deg = 100.0;
        assert!(s.validate().is_err());

        s.solar_altitude_deg = 45.0;
        s.air_mass = -0.5;
        assert!(s.validate().is_err());
    }

    #[test]
    fn time_features_validates() {
        let mut t = sample_time();
        assert!(t.validate().is_ok());

        t.hour_of_day = 25;
        assert!(t.validate().is_err());

        t.hour_of_day = 12;
        t.day_of_year = 0;
        assert!(t.validate().is_err());
    }

    #[test]
    fn feature_extraction_produces_consistent_output() {
        let mut pipeline = FeaturePipeline::new();
        let samples = vec![sample_weather(); 10];
        assert!(pipeline.fit_normalization(&samples).is_ok());

        let fv = pipeline
            .extract_features(sample_weather(), sample_solar(), sample_time())
            .expect("extraction succeeds");

        assert_eq!(fv.features.len(), fv.feature_names.len());
        assert!(fv.features.len() > 15);
        assert!(fv.features.iter().all(|f| f.is_finite()));
    }

    #[test]
    fn normalization_improves_scale() {
        let mut pipeline = FeaturePipeline::new();
        let samples = vec![
            WeatherFeatures {
                temperature_c: 10.0,
                irradiance_w_m2: 200.0,
                humidity_percent: 40.0,
                pressure_mb: 1010.0,
                wind_speed_m_s: 2.0,
            },
            WeatherFeatures {
                temperature_c: 30.0,
                irradiance_w_m2: 900.0,
                humidity_percent: 80.0,
                pressure_mb: 1016.0,
                wind_speed_m_s: 5.0,
            },
        ];
        assert!(pipeline.fit_normalization(&samples).is_ok());

        let fv = pipeline
            .extract_features(sample_weather(), sample_solar(), sample_time())
            .expect("extraction succeeds");

        let normalized_values: Vec<f64> = fv.features[15..].to_vec();
        for val in normalized_values {
            assert!(val.abs() < 10.0, "normalized value too large: {}", val);
        }
    }
}
