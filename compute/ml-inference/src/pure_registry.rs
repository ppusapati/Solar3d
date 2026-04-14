// Pure functional model registry operations (deterministic, no side effects, reusable)
// All operations are pure transformations over immutable data structures
// Shared state management is isolated to registry_state.rs

use crate::model_registry::{ModelVersion, FeatureSchema};
use std::collections::HashMap;
use std::path::Path;

/// Pure operations for model registry without shared state
/// All functions are deterministic and composable
pub mod pure {
    use super::*;

    /// Validate model version data (pure)
    pub fn validate_model_version(model: &ModelVersion) -> Result<(), String> {
        if model.id.is_empty() {
            return Err("model id is required".to_string());
        }
        if model.task_type.is_empty() {
            return Err("task_type is required".to_string());
        }
        if model.schema_hash.is_empty() {
            return Err("schema_hash is required".to_string());
        }
        if model.artifact_path.is_empty() {
            return Err("artifact_path is required".to_string());
        }
        if model.version == 0 {
            return Err("version must be > 0".to_string());
        }
        Ok(())
    }

    /// Check if artifact file exists (pure I/O check, no state mutation)
    pub fn artifact_exists(path: &str) -> bool {
        Path::new(path).exists()
    }

    /// Validate feature schema (pure)
    pub fn validate_schema(schema: &FeatureSchema) -> Result<(), String> {
        if schema.hash.is_empty() {
            return Err("schema hash is required".to_string());
        }
        if schema.feature_names.is_empty() {
            return Err("schema must have at least one feature".to_string());
        }
        if schema.feature_names.len() != schema.feature_dtypes.len() {
            return Err("feature_names and feature_dtypes length mismatch".to_string());
        }
        Ok(())
    }

    /// Validate feature vector against schema (pure)
    pub fn validate_features(schema: &FeatureSchema, features: &[f64]) -> Result<(), String> {
        let expected_count = schema.feature_names.len();
        if features.len() != expected_count {
            return Err(format!(
                "feature count mismatch: expected {}, got {}",
                expected_count,
                features.len()
            ));
        }

        for (i, &value) in features.iter().enumerate() {
            if !value.is_finite() {
                return Err(format!("feature {} is not finite", i));
            }
        }

        Ok(())
    }

    /// Normalize features using schema params (pure)
    pub fn normalize_features(
        features: &[f64],
        schema: &FeatureSchema,
    ) -> Result<Vec<f64>, String> {
        validate_features(schema, features)?;

        let params = match &schema.normalization_params {
            Some(p) => p,
            None => return Ok(features.to_vec()), // No normalization needed
        };

        let mut normalized = Vec::with_capacity(features.len());
        for (i, &value) in features.iter().enumerate() {
            let feature_name = &schema.feature_names[i];

            // Extract normalization parameters with safe defaults
            let mean = params.get(&format!("{}_mean", feature_name)).copied().unwrap_or(0.0);
            let std = params.get(&format!("{}_std", feature_name)).copied().unwrap_or(1.0);

            // Z-score normalization: (x - mean) / std
            let normalized_value = if std > 1e-10 {
                (value - mean) / std
            } else {
                value - mean
            };

            normalized.push(normalized_value);
        }

        Ok(normalized)
    }

    /// Select active model from candidates (pure, deterministic)
    pub fn select_active_model<'a>(
        models: &'a HashMap<String, ModelVersion>,
        task_type: &str,
    ) -> Result<&'a ModelVersion, String> {
        models
            .get(task_type)
            .ok_or_else(|| format!("no active model for task: {}", task_type))
    }

    /// Generate fallback chain (pure transformation)
    pub fn create_fallback_entry(
        active_models: &HashMap<String, ModelVersion>,
        new_model: &ModelVersion,
    ) -> Option<ModelVersion> {
        active_models.get(&new_model.task_type).cloned()
    }

    /// Health check on model state (pure, read-only)
    pub fn validate_model_state(model: &ModelVersion) -> Result<(), String> {
        validate_model_version(model)?;
        if !artifact_exists(&model.artifact_path) {
            return Err(format!(
                "artifact missing for model {}: {}",
                model.id, model.artifact_path
            ));
        }
        Ok(())
    }

    /// Batch health check (pure, read-only)
    pub fn bulk_validate_models(models: &[ModelVersion]) -> Result<(), Vec<String>> {
        let errors: Vec<String> = models
            .iter()
            .filter_map(|model| validate_model_state(model).err())
            .collect();

        if errors.is_empty() {
            Ok(())
        } else {
            Err(errors)
        }
    }
}

/// Registry snapshot (immutable view)
#[derive(Debug, Clone)]
pub struct RegistrySnapshot {
    pub active_models: HashMap<String, ModelVersion>,
    pub schemas: HashMap<String, FeatureSchema>,
    pub fallback_models: HashMap<String, ModelVersion>,
}

impl RegistrySnapshot {
    pub fn new() -> Self {
        Self {
            active_models: HashMap::new(),
            schemas: HashMap::new(),
            fallback_models: HashMap::new(),
        }
    }

    /// Immutable lookup (pure)
    pub fn get_model(&self, task_type: &str) -> Result<ModelVersion, String> {
        self.active_models
            .get(task_type)
            .cloned()
            .ok_or_else(|| format!("no active model for task: {}", task_type))
    }

    /// Immutable schema lookup (pure)
    pub fn get_schema(&self, hash: &str) -> Result<FeatureSchema, String> {
        self.schemas
            .get(hash)
            .cloned()
            .ok_or_else(|| format!("schema not found: {}", hash))
    }

    /// Immutable fallback lookup (pure)
    pub fn get_fallback(&self, task_type: &str) -> Result<ModelVersion, String> {
        self.fallback_models
            .get(task_type)
            .cloned()
            .ok_or_else(|| format!("no fallback model for task: {}", task_type))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_model_version_deterministic() {
        let valid_model = ModelVersion {
            id: "m1".to_string(),
            task_type: "yield".to_string(),
            version: 1,
            artifact_path: "/tmp/model".to_string(),
            schema_hash: "sh1".to_string(),
            status: "active".to_string(),
            created_at_ms: 1000,
        };

        // Multiple calls should always succeed (deterministic)
        for _ in 0..10 {
            assert!(pure::validate_model_version(&valid_model).is_ok());
        }
    }

    #[test]
    fn test_validate_features_deterministic() {
        let schema = FeatureSchema {
            hash: "h1".to_string(),
            version: 1,
            feature_names: vec!["temp".to_string(), "humidity".to_string()],
            feature_dtypes: vec!["f64".to_string(), "f64".to_string()],
            normalization_params: None,
        };

        let features = vec![25.5, 60.0];

        // Multiple calls should always succeed (deterministic)
        for _ in 0..10 {
            assert!(pure::validate_features(&schema, &features).is_ok());
        }
    }

    #[test]
    fn test_normalize_features_deterministic() {
        let mut params = HashMap::new();
        params.insert("temp_mean".to_string(), 20.0);
        params.insert("temp_std".to_string(), 5.0);
        params.insert("humidity_mean".to_string(), 50.0);
        params.insert("humidity_std".to_string(), 10.0);

        let schema = FeatureSchema {
            hash: "h1".to_string(),
            version: 1,
            feature_names: vec!["temp".to_string(), "humidity".to_string()],
            feature_dtypes: vec!["f64".to_string(), "f64".to_string()],
            normalization_params: Some(params),
        };

        let features = vec![25.0, 60.0];
        let result1 = pure::normalize_features(&features, &schema).unwrap();
        let result2 = pure::normalize_features(&features, &schema).unwrap();

        // Deterministic: same input always produces same output
        assert_eq!(result1, result2);
        // Check normalization math: (25 - 20) / 5 = 1.0, (60 - 50) / 10 = 1.0
        assert!((result1[0] - 1.0).abs() < 1e-6);
        assert!((result1[1] - 1.0).abs() < 1e-6);
    }

    #[test]
    fn test_snapshot_immutability() {
        let mut snapshot = RegistrySnapshot::new();
        let model = ModelVersion {
            id: "m1".to_string(),
            task_type: "yield".to_string(),
            version: 1,
            artifact_path: "/tmp/model".to_string(),
            schema_hash: "sh1".to_string(),
            status: "active".to_string(),
            created_at_ms: 1000,
        };

        snapshot.active_models.insert("yield".to_string(), model.clone());

        // Multiple lookups return same result
        let lookup1 = snapshot.get_model("yield").unwrap();
        let lookup2 = snapshot.get_model("yield").unwrap();
        assert_eq!(lookup1.id, lookup2.id);
    }
}
