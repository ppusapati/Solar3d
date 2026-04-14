use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct YieldForecast {
    pub predicted_yield_kwh: f64,
    pub confidence_lower: f64,
    pub confidence_upper: f64,
    pub expected_value: f64,
    pub variance: f64,
}

impl YieldForecast {
    pub fn validate(&self) -> Result<(), String> {
        if !self.predicted_yield_kwh.is_finite() || self.predicted_yield_kwh < 0.0 {
            return Err("predicted yield must be non-negative".to_string());
        }
        if !self.confidence_lower.is_finite() || self.confidence_lower < 0.0 {
            return Err("confidence lower must be non-negative".to_string());
        }
        if !self.confidence_upper.is_finite() || self.confidence_upper < 0.0 {
            return Err("confidence upper must be non-negative".to_string());
        }
        if self.confidence_lower > self.predicted_yield_kwh {
            return Err("confidence lower exceeds prediction".to_string());
        }
        if self.confidence_upper < self.predicted_yield_kwh {
            return Err("confidence upper below prediction".to_string());
        }
        if !self.variance.is_finite() || self.variance < 0.0 {
            return Err("variance must be non-negative".to_string());
        }
        Ok(())
    }
}

pub struct YieldForecaster {
    model_mean_multiplier: f64,
    model_variance_weight: f64,
}

impl YieldForecaster {
    pub fn new() -> Self {
        Self {
            model_mean_multiplier: 1.0,
            model_variance_weight: 0.15,
        }
    }

    pub fn with_calibration(model_mean_multiplier: f64, model_variance_weight: f64) -> Result<Self, String> {
        if !model_mean_multiplier.is_finite() || model_mean_multiplier <= 0.0 {
            return Err("model mean multiplier must be positive".to_string());
        }
        if !model_variance_weight.is_finite() || model_variance_weight < 0.0 || model_variance_weight > 1.0 {
            return Err("model variance weight must be 0-1".to_string());
        }
        Ok(Self {
            model_mean_multiplier,
            model_variance_weight,
        })
    }

    pub fn forecast(&self, model_output: f64, uncertainty_estimate: f64) -> Result<YieldForecast, String> {
        if !model_output.is_finite() || model_output < 0.0 {
            return Err("model output must be non-negative".to_string());
        }
        if !uncertainty_estimate.is_finite() || uncertainty_estimate < 0.0 {
            return Err("uncertainty estimate must be non-negative".to_string());
        }

        let predicted_yield = model_output * self.model_mean_multiplier;
        let variance = (uncertainty_estimate * self.model_variance_weight).powi(2);
        let std_dev = variance.sqrt();

        let confidence_lower = (predicted_yield - 1.96 * std_dev).max(0.0);
        let confidence_upper = predicted_yield + 1.96 * std_dev;

        let forecast = YieldForecast {
            predicted_yield_kwh: predicted_yield,
            confidence_lower,
            confidence_upper,
            expected_value: predicted_yield,
            variance,
        };

        forecast.validate()?;
        Ok(forecast)
    }

    pub fn ensemble_forecast(&self, outputs: &[f64], uncertainties: &[f64]) -> Result<YieldForecast, String> {
        if outputs.is_empty() || uncertainties.is_empty() {
            return Err("outputs and uncertainties cannot be empty".to_string());
        }
        if outputs.len() != uncertainties.len() {
            return Err("outputs and uncertainties must have same length".to_string());
        }

        let mean_output = outputs.iter().sum::<f64>() / outputs.len() as f64;
        let mean_uncertainty = uncertainties.iter().sum::<f64>() / uncertainties.len() as f64;

        let mut model_variance = 0.0;
        for &out in outputs {
            model_variance += (out - mean_output).powi(2);
        }
        model_variance /= outputs.len() as f64;

        let combined_uncertainty = (model_variance + mean_uncertainty.powi(2)).sqrt();

        self.forecast(mean_output, combined_uncertainty)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn yield_forecast_validates() {
        let mut forecast = YieldForecast {
            predicted_yield_kwh: 100.0,
            confidence_lower: 80.0,
            confidence_upper: 120.0,
            expected_value: 100.0,
            variance: 100.0,
        };
        assert!(forecast.validate().is_ok());

        forecast.predicted_yield_kwh = -1.0;
        assert!(forecast.validate().is_err());

        forecast.predicted_yield_kwh = 100.0;
        forecast.confidence_lower = 110.0;
        assert!(forecast.validate().is_err());
    }

    #[test]
    fn forecaster_generates_valid_forecast() {
        let forecaster = YieldForecaster::new();

        let forecast = forecaster.forecast(1000.0, 150.0).expect("forecast succeeds");

        assert!(forecast.predicted_yield_kwh > 0.0);
        assert!(forecast.confidence_lower >= 0.0);
        assert!(forecast.confidence_upper > forecast.predicted_yield_kwh);
        assert!(forecast.variance >= 0.0);
    }

    #[test]
    fn forecaster_respects_calibration() {
        let forecaster = YieldForecaster::with_calibration(0.95, 0.20).expect("calibration valid");

        let forecast = forecaster.forecast(1000.0, 100.0).expect("forecast succeeds");

        assert!((forecast.predicted_yield_kwh - 950.0).abs() < 1.0);
    }

    #[test]
    fn ensemble_forecast_averages_models() {
        let forecaster = YieldForecaster::new();

        let outputs = vec![950.0, 1000.0, 1050.0];
        let uncertainties = vec![100.0, 120.0, 110.0];

        let forecast = forecaster
            .ensemble_forecast(&outputs, &uncertainties)
            .expect("ensemble succeeds");

        assert!(forecast.predicted_yield_kwh > 999.0 && forecast.predicted_yield_kwh < 1001.0);
    }

    #[test]
    fn forecast_confidence_intervals_are_symmetric() {
        let forecaster = YieldForecaster::new();

        let forecast = forecaster.forecast(1000.0, 100.0).expect("forecast succeeds");

        let lower_margin = forecast.predicted_yield_kwh - forecast.confidence_lower;
        let upper_margin = forecast.confidence_upper - forecast.predicted_yield_kwh;

        assert!((lower_margin - upper_margin).abs() < 1.0);
    }
}
