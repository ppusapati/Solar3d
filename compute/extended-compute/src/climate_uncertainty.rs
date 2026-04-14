use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct TemperatureScenario {
    pub warming_celsius: f64,
    pub probability: f64,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct PrecipitationScenario {
    pub change_percent: f64,
    pub probability: f64,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct ClimateImpact {
    pub soiling_factor_change: f64,
    pub efficiency_factor_change: f64,
    pub module_temperature_increase: f64,
    pub availability_impact_percent: f64,
}

pub struct ClimateUncertaintyModel;

impl ClimateUncertaintyModel {
    pub fn temperature_impact_on_efficiency(
        reference_temp_c: f64,
        reference_efficiency: f64,
        temp_coefficient: f64,
        scenario_temp_change: f64,
    ) -> Result<f64, String> {
        if !reference_temp_c.is_finite() || reference_temp_c < -50.0 || reference_temp_c > 80.0 {
            return Err("reference temperature out of range (-50 to 80C)".to_string());
        }
        if !reference_efficiency.is_finite() || reference_efficiency <= 0.0 || reference_efficiency > 1.0 {
            return Err("efficiency must be 0-1".to_string());
        }
        if !temp_coefficient.is_finite() || temp_coefficient > 0.0 || temp_coefficient < -0.01 {
            return Err("temperature coefficient must be negative, -0.01 to 0".to_string());
        }
        if !scenario_temp_change.is_finite() || scenario_temp_change < -10.0 || scenario_temp_change > 10.0 {
            return Err("temperature change must be -10 to 10C".to_string());
        }

        let new_efficiency =
            reference_efficiency * (1.0 + temp_coefficient * scenario_temp_change);
        Ok(new_efficiency.max(0.0))
    }

    pub fn soiling_impact_from_precipitation(
        baseline_soiling_factor: f64,
        precipitation_change_percent: f64,
    ) -> Result<f64, String> {
        if !baseline_soiling_factor.is_finite() || baseline_soiling_factor < 0.0 || baseline_soiling_factor > 0.3 {
            return Err("baseline soiling factor must be 0-0.3".to_string());
        }
        if !precipitation_change_percent.is_finite()
            || precipitation_change_percent < -100.0
            || precipitation_change_percent > 100.0
        {
            return Err("precipitation change must be -100 to 100%".to_string());
        }

        let precip_factor = (100.0 + precipitation_change_percent) / 100.0;
        let improved_soiling = baseline_soiling_factor * (2.0 - precip_factor.max(0.0));
        Ok(improved_soiling.max(0.0).min(0.3))
    }

    pub fn wind_impact_on_cooling(
        baseline_wind_speed_m_s: f64,
        new_wind_speed_m_s: f64,
    ) -> Result<f64, String> {
        if !baseline_wind_speed_m_s.is_finite() || baseline_wind_speed_m_s < 0.0 {
            return Err("baseline wind speed must be non-negative".to_string());
        }
        if !new_wind_speed_m_s.is_finite() || new_wind_speed_m_s < 0.0 {
            return Err("new wind speed must be non-negative".to_string());
        }

        let wind_ratio = new_wind_speed_m_s / (baseline_wind_speed_m_s + 1.0);
        let cooling_effect = (wind_ratio).sqrt();
        Ok(cooling_effect.min(1.5))
    }

    pub fn aggregate_climate_impact(
        temp_impact: f64,
        soiling_impact: f64,
        wind_impact: f64,
        availability_impact: f64,
    ) -> Result<ClimateImpact, String> {
        if !temp_impact.is_finite() || temp_impact < -0.5 || temp_impact > 0.5 {
            return Err("temperature impact must be -0.5 to 0.5".to_string());
        }
        if !soiling_impact.is_finite() || soiling_impact < -0.2 || soiling_impact > 0.2 {
            return Err("soiling impact must be -0.2 to 0.2".to_string());
        }
        if !wind_impact.is_finite() || wind_impact < 0.0 || wind_impact > 2.0 {
            return Err("wind impact must be 0 to 2.0".to_string());
        }
        if !availability_impact.is_finite() || availability_impact < -50.0 || availability_impact > 50.0 {
            return Err("availability impact must be -50 to 50%".to_string());
        }

        let overall_efficiency_change = temp_impact + soiling_impact;
        let module_temp_increase = -temp_impact * 50.0;

        Ok(ClimateImpact {
            soiling_factor_change: soiling_impact,
            efficiency_factor_change: overall_efficiency_change,
            module_temperature_increase: module_temp_increase,
            availability_impact_percent: availability_impact,
        })
    }

    pub fn expected_impact_under_uncertainty(
        scenarios: &[(f64, f64, f64)],
        probabilities: &[f64],
    ) -> Result<ClimateImpact, String> {
        if scenarios.is_empty() || probabilities.is_empty() {
            return Err("scenarios and probabilities cannot be empty".to_string());
        }
        if scenarios.len() != probabilities.len() {
            return Err("scenarios and probabilities must have same length".to_string());
        }

        let prob_sum: f64 = probabilities.iter().sum();
        if (prob_sum - 1.0).abs() > 0.01 {
            return Err("probabilities must sum to 1.0".to_string());
        }

        let mut expected_temp = 0.0;
        let mut expected_soiling = 0.0;
        let mut expected_wind = 0.0;

        for (i, (temp, soiling, wind)) in scenarios.iter().enumerate() {
            if !temp.is_finite() || !soiling.is_finite() || !wind.is_finite() {
                return Err("scenario values must be finite".to_string());
            }
            expected_temp += temp * probabilities[i];
            expected_soiling += soiling * probabilities[i];
            expected_wind += wind * probabilities[i];
        }

        Self::aggregate_climate_impact(expected_temp, expected_soiling, expected_wind, 0.0)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn temperature_impact_reduces_efficiency() {
        let efficiency = ClimateUncertaintyModel::temperature_impact_on_efficiency(
            25.0, 0.18, -0.004, 5.0,
        )
        .expect("calculation succeeds");

        assert!(efficiency < 0.18 && efficiency > 0.17);
    }

    #[test]
    fn soiling_improves_with_precipitation() {
        let soiling = ClimateUncertaintyModel::soiling_impact_from_precipitation(0.15, 50.0)
            .expect("calculation succeeds");

        assert!(soiling < 0.15);
    }

    #[test]
    fn wind_improves_cooling() {
        let cooling = ClimateUncertaintyModel::wind_impact_on_cooling(2.0, 5.0)
            .expect("calculation succeeds");

        assert!(cooling > 1.0);
    }

    #[test]
    fn aggregate_impact_valid() {
        let impact = ClimateUncertaintyModel::aggregate_climate_impact(-0.05, 0.02, 1.1, 5.0)
            .expect("aggregation succeeds");

        assert!(impact.efficiency_factor_change.is_finite());
        assert!(impact.module_temperature_increase.is_finite());
    }

    #[test]
    fn expected_impact_under_scenarios() {
        let scenarios = vec![(0.5, -0.02, 1.0), (0.2, -0.05, 1.2), (0.1, 0.0, 0.9)];
        let probs = vec![0.3, 0.5, 0.2];

        let expected = ClimateUncertaintyModel::expected_impact_under_uncertainty(&scenarios, &probs)
            .expect("calculation succeeds");

        assert!(expected.efficiency_factor_change.is_finite());
    }
}
