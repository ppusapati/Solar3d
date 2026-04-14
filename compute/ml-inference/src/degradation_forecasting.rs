use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct DegradationForecast {
    pub current_degradation_percent: f64,
    pub annual_degradation_rate: f64,
    pub projected_degradation_5yr: f64,
    pub projected_degradation_10yr: f64,
    pub confidence_interval: f64,
}

impl DegradationForecast {
    pub fn validate(&self) -> Result<(), String> {
        if !self.current_degradation_percent.is_finite() || self.current_degradation_percent < 0.0 || self.current_degradation_percent > 100.0 {
            return Err("current degradation must be 0-100%".to_string());
        }
        if !self.annual_degradation_rate.is_finite() || self.annual_degradation_rate < 0.0 || self.annual_degradation_rate > 10.0 {
            return Err("annual degradation must be 0-10%".to_string());
        }
        if !self.projected_degradation_5yr.is_finite() || self.projected_degradation_5yr < 0.0 {
            return Err("projected 5yr degradation must be non-negative".to_string());
        }
        if !self.projected_degradation_10yr.is_finite() || self.projected_degradation_10yr < 0.0 {
            return Err("projected 10yr degradation must be non-negative".to_string());
        }
        if !self.confidence_interval.is_finite() || self.confidence_interval < 0.0 || self.confidence_interval > 100.0 {
            return Err("confidence interval must be 0-100%".to_string());
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct AnnualCapacityData {
    pub year: u32,
    pub capacity_factor: f64,
}

pub struct DegradationForecaster {
    base_degradation_rate: f64,
    temperature_coefficient: f64,
    soiling_factor: f64,
}

impl DegradationForecaster {
    pub fn new() -> Self {
        Self {
            base_degradation_rate: 0.8,
            temperature_coefficient: 0.05,
            soiling_factor: 0.1,
        }
    }

    pub fn with_parameters(
        base_degradation_rate: f64,
        temperature_coefficient: f64,
        soiling_factor: f64,
    ) -> Result<Self, String> {
        if !base_degradation_rate.is_finite() || base_degradation_rate < 0.0 || base_degradation_rate > 5.0 {
            return Err("base degradation rate must be 0-5%".to_string());
        }
        if !temperature_coefficient.is_finite() || temperature_coefficient < 0.0 || temperature_coefficient > 1.0 {
            return Err("temperature coefficient must be 0-1".to_string());
        }
        if !soiling_factor.is_finite() || soiling_factor < 0.0 || soiling_factor > 1.0 {
            return Err("soiling factor must be 0-1".to_string());
        }

        Ok(Self {
            base_degradation_rate,
            temperature_coefficient,
            soiling_factor,
        })
    }

    pub fn forecast_linear(
        &self,
        current_degradation: f64,
        annual_rate: f64,
        years: u32,
    ) -> Result<DegradationForecast, String> {
        if !current_degradation.is_finite() || current_degradation < 0.0 || current_degradation > 100.0 {
            return Err("current degradation must be 0-100%".to_string());
        }
        if !annual_rate.is_finite() || annual_rate < 0.0 || annual_rate > 10.0 {
            return Err("annual rate must be 0-10%".to_string());
        }

        let projected_degradation_5yr = (current_degradation + annual_rate * 5.0).min(100.0);
        let projected_degradation_10yr = (current_degradation + annual_rate * 10.0).min(100.0);

        let forecast = DegradationForecast {
            current_degradation_percent: current_degradation,
            annual_degradation_rate: annual_rate,
            projected_degradation_5yr,
            projected_degradation_10yr,
            confidence_interval: 95.0 - (years as f64) * 3.0,
        };

        forecast.validate()?;
        Ok(forecast)
    }

    pub fn forecast_from_history(
        &self,
        historical_data: &[AnnualCapacityData],
        temperature_avg: f64,
        soiling_conditions: f64,
    ) -> Result<DegradationForecast, String> {
        if historical_data.len() < 2 {
            return Err("need at least 2 historical data points".to_string());
        }

        for data in historical_data {
            if !data.capacity_factor.is_finite() || data.capacity_factor < 0.0 || data.capacity_factor > 1.0 {
                return Err("capacity factor must be 0-1".to_string());
            }
        }

        if !temperature_avg.is_finite() {
            return Err("temperature average must be finite".to_string());
        }
        if !soiling_conditions.is_finite() || soiling_conditions < 0.0 || soiling_conditions > 1.0 {
            return Err("soiling conditions must be 0-1".to_string());
        }

        let mut total_degradation = 0.0;
        for i in 1..historical_data.len() {
            let year_diff = (historical_data[i].year - historical_data[i - 1].year) as f64;
            if year_diff > 0.0 {
                let cf_change = (historical_data[i].capacity_factor - historical_data[i - 1].capacity_factor).abs();
                total_degradation += cf_change / year_diff;
            }
        }

        let avg_degradation = total_degradation / (historical_data.len() - 1) as f64 * 100.0;

        let adjusted_rate = self.base_degradation_rate
            + avg_degradation
            + temperature_avg * self.temperature_coefficient
            + soiling_conditions * self.soiling_factor;

        let current_cf = historical_data.last().unwrap().capacity_factor;
        let current_degradation = (1.0 - current_cf) * 100.0;

        self.forecast_linear(current_degradation, adjusted_rate, 10)
    }

    pub fn estimate_remaining_useful_life(
        &self,
        current_degradation: f64,
        annual_rate: f64,
        end_of_life_threshold: f64,
    ) -> Result<f64, String> {
        if !current_degradation.is_finite() || current_degradation < 0.0 || current_degradation > 100.0 {
            return Err("current degradation must be 0-100%".to_string());
        }
        if !annual_rate.is_finite() || annual_rate < 0.0 {
            return Err("annual rate must be non-negative".to_string());
        }
        if !end_of_life_threshold.is_finite()
            || end_of_life_threshold < 0.0
            || end_of_life_threshold > 100.0
        {
            return Err("end of life threshold must be 0-100%".to_string());
        }

        if annual_rate < 1e-6 {
            return Ok(f64::INFINITY);
        }

        if current_degradation >= end_of_life_threshold {
            return Ok(0.0);
        }

        let remaining_life = (end_of_life_threshold - current_degradation) / annual_rate;
        Ok(remaining_life.max(0.0))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn degradation_forecast_validates() {
        let mut forecast = DegradationForecast {
            current_degradation_percent: 5.0,
            annual_degradation_rate: 0.8,
            projected_degradation_5yr: 9.0,
            projected_degradation_10yr: 13.0,
            confidence_interval: 85.0,
        };
        assert!(forecast.validate().is_ok());

        forecast.current_degradation_percent = 150.0;
        assert!(forecast.validate().is_err());

        forecast.current_degradation_percent = 5.0;
        forecast.annual_degradation_rate = 15.0;
        assert!(forecast.validate().is_err());
    }

    #[test]
    fn linear_forecast_projects_correctly() {
        let forecaster = DegradationForecaster::new();

        let forecast = forecaster
            .forecast_linear(5.0, 0.8, 10)
            .expect("forecast succeeds");

        assert!((forecast.projected_degradation_5yr - 9.0).abs() < 0.1);
        assert!((forecast.projected_degradation_10yr - 13.0).abs() < 0.1);
    }

    #[test]
    fn forecast_caps_at_100_percent() {
        let forecaster = DegradationForecaster::new();

        let forecast = forecaster
            .forecast_linear(95.0, 2.0, 10)
            .expect("forecast succeeds");

        assert!(forecast.projected_degradation_5yr <= 100.0);
        assert!(forecast.projected_degradation_10yr <= 100.0);
    }

    #[test]
    fn forecast_from_history_detects_trend() {
        let forecaster = DegradationForecaster::new();

        let historical = vec![
            AnnualCapacityData {
                year: 2020,
                capacity_factor: 0.95,
            },
            AnnualCapacityData {
                year: 2021,
                capacity_factor: 0.94,
            },
            AnnualCapacityData {
                year: 2022,
                capacity_factor: 0.93,
            },
        ];

        let forecast = forecaster
            .forecast_from_history(&historical, 25.0, 0.3)
            .expect("forecast succeeds");

        assert!(forecast.current_degradation_percent > 0.0);
        assert!(forecast.annual_degradation_rate > 0.0);
    }

    #[test]
    fn remaining_useful_life_is_positive() {
        let forecaster = DegradationForecaster::new();

        let rul = forecaster
            .estimate_remaining_useful_life(10.0, 0.8, 80.0)
            .expect("estimation succeeds");

        assert!(rul > 0.0);
        assert!(rul < 1000.0);
    }

    #[test]
    fn remaining_useful_life_is_zero_when_degraded() {
        let forecaster = DegradationForecaster::new();

        let rul = forecaster
            .estimate_remaining_useful_life(85.0, 0.8, 80.0)
            .expect("estimation succeeds");

        assert_eq!(rul, 0.0);
    }

    #[test]
    fn remaining_useful_life_is_infinite_with_zero_rate() {
        let forecaster = DegradationForecaster::new();

        let rul = forecaster
            .estimate_remaining_useful_life(10.0, 0.0, 80.0)
            .expect("estimation succeeds");

        assert!(rul.is_infinite());
    }
}
