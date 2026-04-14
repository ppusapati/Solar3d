use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum AnomalyType {
    SensorFault,
    PerformanceDegradation,
    InverterIssue,
    StreetMalfunction,
    WeatherEvent,
    Normal,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct AnomalyScore {
    pub score: f64,
    pub anomaly_type: AnomalyType,
    pub confidence: f64,
}

impl AnomalyScore {
    pub fn validate(&self) -> Result<(), String> {
        if !self.score.is_finite() || self.score < 0.0 || self.score > 1.0 {
            return Err("anomaly score must be 0-1".to_string());
        }
        if !self.confidence.is_finite() || self.confidence < 0.0 || self.confidence > 1.0 {
            return Err("confidence must be 0-1".to_string());
        }
        Ok(())
    }
}

pub struct AnomalyDetector {
    performance_threshold: f64,
    sensor_fault_threshold: f64,
    confidence_threshold: f64,
}

impl AnomalyDetector {
    pub fn new() -> Self {
        Self {
            performance_threshold: 0.85,
            sensor_fault_threshold: 0.70,
            confidence_threshold: 0.75,
        }
    }

    pub fn with_thresholds(
        performance_threshold: f64,
        sensor_fault_threshold: f64,
        confidence_threshold: f64,
    ) -> Result<Self, String> {
        if !(0.0..=1.0).contains(&performance_threshold) {
            return Err("performance_threshold must be 0-1".to_string());
        }
        if !(0.0..=1.0).contains(&sensor_fault_threshold) {
            return Err("sensor_fault_threshold must be 0-1".to_string());
        }
        if !(0.0..=1.0).contains(&confidence_threshold) {
            return Err("confidence_threshold must be 0-1".to_string());
        }

        Ok(Self {
            performance_threshold,
            sensor_fault_threshold,
            confidence_threshold,
        })
    }

    pub fn detect(
        &self,
        expected_yield: f64,
        actual_yield: f64,
        model_prediction: f64,
        sensor_variance: f64,
    ) -> Result<AnomalyScore, String> {
        if !expected_yield.is_finite() || expected_yield < 0.0 {
            return Err("expected yield must be non-negative".to_string());
        }
        if !actual_yield.is_finite() || actual_yield < 0.0 {
            return Err("actual yield must be non-negative".to_string());
        }
        if !model_prediction.is_finite() || model_prediction < 0.0 {
            return Err("model prediction must be non-negative".to_string());
        }
        if !sensor_variance.is_finite() || sensor_variance < 0.0 {
            return Err("sensor variance must be non-negative".to_string());
        }

        if expected_yield < 1e-6 {
            return Ok(AnomalyScore {
                score: 0.0,
                anomaly_type: AnomalyType::Normal,
                confidence: 1.0,
            });
        }

        let performance_ratio = actual_yield / expected_yield;
        let prediction_error = (actual_yield - model_prediction).abs() / (model_prediction.max(1.0));

        let mut anomaly_score = 0.0;
        let mut anomaly_type = AnomalyType::Normal;

        if prediction_error > 0.4 {
            anomaly_score = prediction_error.min(1.0);
            anomaly_type = if sensor_variance > 0.3 {
                AnomalyType::SensorFault
            } else {
                AnomalyType::PerformanceDegradation
            };
        } else if performance_ratio < 0.7 {
            anomaly_score = (1.0 - performance_ratio).min(1.0);
            anomaly_type = AnomalyType::PerformanceDegradation;
        } else if performance_ratio < self.performance_threshold {
            anomaly_score = ((self.performance_threshold - performance_ratio) / 0.2).min(1.0);
            anomaly_type = AnomalyType::PerformanceDegradation;
        }

        let confidence = if anomaly_score > self.sensor_fault_threshold {
            0.9
        } else if anomaly_score > 0.3 {
            0.7
        } else {
            0.95
        };

        let result = AnomalyScore {
            score: anomaly_score,
            anomaly_type,
            confidence,
        };

        result.validate()?;
        Ok(result)
    }

    pub fn detect_sensor_fault(&self, readings: &[f64]) -> Result<AnomalyScore, String> {
        if readings.len() < 2 {
            return Err("need at least 2 readings".to_string());
        }

        for &reading in readings {
            if !reading.is_finite() {
                return Err("readings must be finite".to_string());
            }
        }

        let mut sorted = readings.to_vec();
        sorted.sort_by(|a, b| a.partial_cmp(b).unwrap_or(std::cmp::Ordering::Equal));

        let q1_idx = readings.len() / 4;
        let q3_idx = (3 * readings.len()) / 4;

        let q1 = sorted[q1_idx];
        let q3 = sorted[q3_idx.min(readings.len() - 1)];
        let iqr = (q3 - q1).abs().max(1e-6);

        let lower_bound = q1 - 1.0 * iqr;
        let upper_bound = q3 + 1.0 * iqr;

        let mut outlier_count = 0;
        for &reading in readings {
            if reading < lower_bound || reading > upper_bound {
                outlier_count += 1;
            }
        }

        let outlier_fraction = outlier_count as f64 / readings.len() as f64;
        let fault_score = (outlier_fraction * 1.5).min(1.0);

        let anomaly_type = if fault_score > 0.3 {
            AnomalyType::SensorFault
        } else {
            AnomalyType::Normal
        };

        let result = AnomalyScore {
            score: fault_score,
            anomaly_type,
            confidence: (1.0 - outlier_fraction * 0.5).max(0.5),
        };

        result.validate()?;
        Ok(result)
    }

    pub fn is_anomalous(&self, score: &AnomalyScore) -> bool {
        score.score > 0.5 && score.confidence > self.confidence_threshold
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn anomaly_score_validates() {
        let mut score = AnomalyScore {
            score: 0.5,
            anomaly_type: AnomalyType::Normal,
            confidence: 0.8,
        };
        assert!(score.validate().is_ok());

        score.score = 1.5;
        assert!(score.validate().is_err());

        score.score = 0.5;
        score.confidence = -0.1;
        assert!(score.validate().is_err());
    }

    #[test]
    fn detector_identifies_performance_degradation() {
        let detector = AnomalyDetector::new();

        let score = detector
            .detect(1000.0, 700.0, 950.0, 0.1)
            .expect("detection succeeds");

        assert!(score.score > 0.0);
        assert!(detector.is_anomalous(&score));
        assert_eq!(score.anomaly_type, AnomalyType::PerformanceDegradation);
    }

    #[test]
    fn detector_identifies_sensor_fault() {
        let detector = AnomalyDetector::new();

        let score = detector
            .detect(1000.0, 1050.0, 950.0, 0.5)
            .expect("detection succeeds");

        if score.score > 0.3 {
            assert_eq!(score.anomaly_type, AnomalyType::SensorFault);
        }
    }

    #[test]
    fn detector_identifies_normal_operation() {
        let detector = AnomalyDetector::new();

        let score = detector
            .detect(1000.0, 950.0, 960.0, 0.05)
            .expect("detection succeeds");

        assert!(!detector.is_anomalous(&score));
        assert_eq!(score.anomaly_type, AnomalyType::Normal);
    }

    #[test]
    fn sensor_fault_detection_identifies_outliers() {
        let detector = AnomalyDetector::new();

        let readings = vec![100.0, 102.0, 101.0, 99.0, 500.0];
        let score = detector.detect_sensor_fault(&readings).expect("detection succeeds");

        assert!(score.score > 0.2);
        assert_eq!(score.anomaly_type, AnomalyType::SensorFault);
    }

    #[test]
    fn sensor_fault_detection_passes_clean_readings() {
        let detector = AnomalyDetector::new();

        let readings = vec![100.0, 100.1, 100.05, 100.15, 100.2];
        let score = detector
            .detect_sensor_fault(&readings)
            .expect("detection succeeds");

        assert!(score.score < 0.2);
    }

    #[test]
    fn detector_returns_zero_yield_as_normal() {
        let detector = AnomalyDetector::new();

        let score = detector
            .detect(0.0, 0.0, 0.0, 0.0)
            .expect("detection succeeds");

        assert_eq!(score.anomaly_type, AnomalyType::Normal);
        assert_eq!(score.score, 0.0);
    }
}
