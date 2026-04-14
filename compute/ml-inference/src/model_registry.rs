// Model registry and loader for the ML inference bridge
// Supports model versioning, hot-reload, and graceful fallback

use std::sync::{Arc, Mutex};
use std::path::Path;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModelVersion {
    pub id: String,
    pub task_type: String,
    pub version: u32,
    pub artifact_path: String,
    pub schema_hash: String,
    pub status: String, // "active", "previous", "archived"
    pub created_at_ms: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FeatureSchema {
    pub hash: String,
    pub version: u32,
    pub feature_names: Vec<String>,
    pub feature_dtypes: Vec<String>,
    pub normalization_params: Option<std::collections::HashMap<String, f64>>,
}

/// ModelRegistry manages active model versions and schemas
pub struct ModelRegistry {
    active_models: Arc<Mutex<std::collections::HashMap<String, ModelVersion>>>,
    schemas: Arc<Mutex<std::collections::HashMap<String, FeatureSchema>>>,
    fallback_models: Arc<Mutex<std::collections::HashMap<String, ModelVersion>>>,
}

impl ModelRegistry {
    pub fn new() -> Self {
        Self {
            active_models: Arc::new(Mutex::new(std::collections::HashMap::new())),
            schemas: Arc::new(Mutex::new(std::collections::HashMap::new())),
            fallback_models: Arc::new(Mutex::new(std::collections::HashMap::new())),
        }
    }

    /// Register or update an active model
    pub fn set_active_model(&self, model: ModelVersion) -> Result<(), String> {
        if model.id.is_empty() || model.task_type.is_empty() {
            return Err("model id and task_type required".to_string());
        }

        // Verify artifact exists
        if !Path::new(&model.artifact_path).exists() {
            return Err(format!("artifact not found: {}", model.artifact_path));
        }

        // Store previous as fallback
        let mut active = self.active_models.lock().unwrap();
        if let Some(prev) = active.get(&model.task_type) {
            let mut fallback = self.fallback_models.lock().unwrap();
            fallback.insert(model.task_type.clone(), prev.clone());
        }

        active.insert(model.task_type.clone(), model);
        Ok(())
    }

    /// Get active model for task type
    pub fn get_active_model(&self, task_type: &str) -> Result<ModelVersion, String> {
        let active = self.active_models.lock().unwrap();
        active
            .get(task_type)
            .cloned()
            .ok_or_else(|| format!("no active model for task: {}", task_type))
    }

    /// Get fallback model (previous version)
    pub fn get_fallback_model(&self, task_type: &str) -> Result<ModelVersion, String> {
        let fallback = self.fallback_models.lock().unwrap();
        fallback
            .get(task_type)
            .cloned()
            .ok_or_else(|| format!("no fallback model for task: {}", task_type))
    }

    /// Register feature schema
    pub fn register_schema(&self, schema: FeatureSchema) -> Result<(), String> {
        if schema.hash.is_empty() {
            return Err("schema hash required".to_string());
        }
        self.schemas.lock().unwrap().insert(schema.hash.clone(), schema);
        Ok(())
    }

    /// Get schema by hash
    pub fn get_schema(&self, hash: &str) -> Result<FeatureSchema, String> {
        self.schemas
            .lock()
            .unwrap()
            .get(hash)
            .cloned()
            .ok_or_else(|| format!("schema not found: {}", hash))
    }

    /// Validate features against schema
    pub fn validate_features(&self, schema_hash: &str, features: &[f64]) -> Result<(), String> {
        let schema = self.get_schema(schema_hash)?;
        
        // Check feature count matches schema
        let expected_count = schema.feature_names.len();
        if features.len() != expected_count {
            return Err(format!(
                "feature count mismatch: expected {}, got {}",
                expected_count,
                features.len()
            ));
        }

        // Validate each feature
        for (i, &value) in features.iter().enumerate() {
            if !value.is_finite() {
                return Err(format!("feature {} is not finite", i));
            }
        }

        Ok(())
    }

    /// List all active model versions
    pub fn list_active_models(&self) -> Vec<ModelVersion> {
        self.active_models
            .lock()
            .unwrap()
            .values()
            .cloned()
            .collect()
    }

    /// Health check: verify all active models have artifacts
    pub fn health_check(&self) -> Result<(), Vec<String>> {
        let active = self.active_models.lock().unwrap();
        let mut errors = Vec::new();

        for model in active.values() {
            if !Path::new(&model.artifact_path).exists() {
                errors.push(format!(
                    "artifact missing for model {}: {}",
                    model.id, model.artifact_path
                ));
            }
        }

        if errors.is_empty() {
            Ok(())
        } else {
            Err(errors)
        }
    }
}

/// Prediction request wrapper with model version info
#[derive(Debug, Serialize, Deserialize)]
pub struct VersionedPredictionRequest {
    pub model_version_id: String,
    pub task_type: String,
    pub schema_hash: String,
    pub features: Vec<f64>,
    pub metadata: Option<std::collections::HashMap<String, String>>,
}

/// Prediction response with model version tracking
#[derive(Debug, Serialize, Deserialize)]
pub struct VersionedPredictionResponse {
    pub prediction_id: Option<String>,
    pub model_version_id: String,
    pub task_type: String,
    pub output: f64,
    pub lower_bound: f64,
    pub upper_bound: f64,
    pub confidence: f64,
    pub generated_at_ms: i64,
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;
    use tempfile::NamedTempFile;

    fn create_test_model() -> (NamedTempFile, ModelVersion) {
        let mut file = NamedTempFile::new().unwrap();
        file.write_all(b"test_model_data").unwrap();
        file.flush().unwrap();

        let model = ModelVersion {
            id: "model_v1".to_string(),
            task_type: "yield".to_string(),
            version: 1,
            artifact_path: file.path().to_string_lossy().to_string(),
            schema_hash: "schema_hash_1".to_string(),
            status: "active".to_string(),
            created_at_ms: 1000,
        };

        (file, model)
    }

    #[test]
    fn test_set_and_get_active_model() {
        let registry = ModelRegistry::new();
        let (_file, model) = create_test_model();

        let result = registry.set_active_model(model.clone());
        assert!(result.is_ok());

        let retrieved = registry.get_active_model("yield").unwrap();
        assert_eq!(retrieved.id, "model_v1");
    }

    #[test]
    fn test_fallback_model() {
        let registry = ModelRegistry::new();
        let (_file1, model1) = create_test_model();
        let (_file2, mut model2) = create_test_model();
        model2.id = "model_v2".to_string();
        model2.version = 2;

        registry.set_active_model(model1).unwrap();
        registry.set_active_model(model2).unwrap();

        let fallback = registry.get_fallback_model("yield").unwrap();
        assert_eq!(fallback.id, "model_v1");
    }

    #[test]
    fn test_schema_validation() {
        let registry = ModelRegistry::new();
        let schema = FeatureSchema {
            hash: "test_hash".to_string(),
            version: 1,
            feature_names: vec!["f1".to_string(), "f2".to_string()],
            feature_dtypes: vec!["f64".to_string(), "f64".to_string()],
            normalization_params: None,
        };

        registry.register_schema(schema).unwrap();
        let retrieved = registry.get_schema("test_hash").unwrap();
        assert_eq!(retrieved.feature_names.len(), 2);
    }

    #[test]
    fn test_feature_validation() {
        let registry = ModelRegistry::new();
        let schema = FeatureSchema {
            hash: "test_hash".to_string(),
            version: 1,
            feature_names: vec!["f1".to_string(), "f2".to_string()],
            feature_dtypes: vec!["f64".to_string(), "f64".to_string()],
            normalization_params: None,
        };

        registry.register_schema(schema).unwrap();

        // Valid features
        let result = registry.validate_features("test_hash", &[1.0, 2.0]);
        assert!(result.is_ok());

        // Invalid count
        let result = registry.validate_features("test_hash", &[1.0]);
        assert!(result.is_err());

        // Invalid value
        let result = registry.validate_features("test_hash", &[f64::NAN, 2.0]);
        assert!(result.is_err());
    }
}
