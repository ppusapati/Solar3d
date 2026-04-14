use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// A dense, named feature vector for ML inference and scoring pipelines.
///
/// Values are always `f64` after normalisation; the `names` slice is parallel to
/// `values` and is used for schema validation at service boundaries.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct FeatureVector {
    /// Ordered feature names (must be unique, non-empty).
    pub names: Vec<String>,
    /// Corresponding feature values (same length as `names`).
    pub values: Vec<f64>,
}

impl FeatureVector {
    /// Construct from parallel name/value slices.
    pub fn new(names: Vec<String>, values: Vec<f64>) -> Result<Self, String> {
        if names.is_empty() {
            return Err("feature vector must have at least one feature".to_string());
        }
        if names.len() != values.len() {
            return Err(format!(
                "names length {} does not match values length {}",
                names.len(),
                values.len()
            ));
        }
        // Validate uniqueness
        let mut seen = std::collections::HashSet::new();
        for name in &names {
            if name.is_empty() {
                return Err("feature name must not be empty".to_string());
            }
            if !seen.insert(name.as_str()) {
                return Err(format!("duplicate feature name: {}", name));
            }
        }
        // Validate values
        for (i, &v) in values.iter().enumerate() {
            if !v.is_finite() {
                return Err(format!("feature '{}' has non-finite value", names[i]));
            }
        }

        Ok(Self { names, values })
    }

    /// Construct from a `HashMap<String, f64>`, sorting by name for deterministic ordering.
    pub fn from_map(map: HashMap<String, f64>) -> Result<Self, String> {
        let mut entries: Vec<(String, f64)> = map.into_iter().collect();
        entries.sort_by(|a, b| a.0.cmp(&b.0));
        let names = entries.iter().map(|(k, _)| k.clone()).collect();
        let values = entries.iter().map(|(_, v)| *v).collect();
        Self::new(names, values)
    }

    /// Number of features.
    pub fn len(&self) -> usize {
        self.values.len()
    }

    /// True iff empty (constructors prevent this, but useful for callers).
    pub fn is_empty(&self) -> bool {
        self.values.is_empty()
    }

    /// Lookup a feature value by name.  O(n) linear scan — suitable for small vectors.
    pub fn get(&self, name: &str) -> Option<f64> {
        self.names
            .iter()
            .position(|n| n == name)
            .map(|i| self.values[i])
    }

    /// Return a normalised copy using min-max scaling over this vector's own range.
    /// If min == max for a feature the normalised value is 0.0.
    pub fn min_max_normalized(&self) -> Self {
        let min = self.values.iter().cloned().fold(f64::INFINITY, f64::min);
        let max = self.values.iter().cloned().fold(f64::NEG_INFINITY, f64::max);
        let range = max - min;
        let values = self.values.iter().map(|&v| {
            if range.abs() <= f64::EPSILON { 0.0 } else { (v - min) / range }
        }).collect();
        Self { names: self.names.clone(), values }
    }

    /// Dot product with another vector of the same dimension.
    pub fn dot(&self, other: &FeatureVector) -> Result<f64, String> {
        if self.len() != other.len() {
            return Err(format!(
                "dimension mismatch: {} vs {}",
                self.len(),
                other.len()
            ));
        }
        Ok(self.values.iter().zip(other.values.iter()).map(|(a, b)| a * b).sum())
    }

    /// Euclidean distance to another vector.
    pub fn euclidean_distance(&self, other: &FeatureVector) -> Result<f64, String> {
        if self.len() != other.len() {
            return Err(format!(
                "dimension mismatch: {} vs {}",
                self.len(),
                other.len()
            ));
        }
        let sum_sq: f64 = self.values.iter()
            .zip(other.values.iter())
            .map(|(a, b)| (a - b).powi(2))
            .sum();
        Ok(sum_sq.sqrt())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rejects_mismatched_lengths() {
        let err = FeatureVector::new(vec!["a".to_string()], vec![1.0, 2.0]).unwrap_err();
        assert!(err.contains("length"));
    }

    #[test]
    fn rejects_duplicate_names() {
        let err = FeatureVector::new(
            vec!["a".to_string(), "a".to_string()],
            vec![1.0, 2.0],
        )
        .unwrap_err();
        assert!(err.contains("duplicate"));
    }

    #[test]
    fn rejects_non_finite_values() {
        let err = FeatureVector::new(
            vec!["a".to_string()],
            vec![f64::NAN],
        )
        .unwrap_err();
        assert!(err.contains("non-finite"));
    }

    #[test]
    fn from_map_is_deterministic() {
        let mut m = HashMap::new();
        m.insert("b".to_string(), 2.0);
        m.insert("a".to_string(), 1.0);
        let fv = FeatureVector::from_map(m).unwrap();
        assert_eq!(fv.names, vec!["a", "b"]);
        assert_eq!(fv.values, vec![1.0, 2.0]);
    }

    #[test]
    fn get_returns_correct_value() {
        let fv = FeatureVector::new(
            vec!["irradiance".to_string(), "temperature".to_string()],
            vec![800.0, 25.0],
        )
        .unwrap();
        assert_eq!(fv.get("temperature"), Some(25.0));
        assert_eq!(fv.get("humidity"), None);
    }

    #[test]
    fn min_max_normalization_maps_to_unit_range() {
        let fv = FeatureVector::new(
            vec!["a".to_string(), "b".to_string(), "c".to_string()],
            vec![0.0, 50.0, 100.0],
        )
        .unwrap();
        let norm = fv.min_max_normalized();
        assert!((norm.values[0] - 0.0).abs() < 1e-10);
        assert!((norm.values[1] - 0.5).abs() < 1e-10);
        assert!((norm.values[2] - 1.0).abs() < 1e-10);
    }

    #[test]
    fn euclidean_distance_correct() {
        let a = FeatureVector::new(vec!["x".to_string(), "y".to_string()], vec![0.0, 0.0]).unwrap();
        let b = FeatureVector::new(vec!["x".to_string(), "y".to_string()], vec![3.0, 4.0]).unwrap();
        let d = a.euclidean_distance(&b).unwrap();
        assert!((d - 5.0).abs() < 1e-10);
    }
}
