// Stateful registry service wrapper (isolated mutable state)
// This module isolates all Arc<Mutex> usage to this single place
// All computation is delegated to pure_registry module

use crate::model_registry::{ModelVersion, FeatureSchema};
use crate::pure_registry::RegistrySnapshot;
use std::sync::{Arc, Mutex};
use std::collections::HashMap;

/// Thread-safe registry service with isolated state management
/// Clients interact only through immutable snapshots (RegistrySnapshot)
/// All computation is deterministic via pure_registry module
pub struct RegistryService {
    state: Arc<Mutex<RegistryState>>,
}

#[derive(Debug)]
struct RegistryState {
    active_models: HashMap<String, ModelVersion>,
    schemas: HashMap<String, FeatureSchema>,
    fallback_models: HashMap<String, ModelVersion>,
}

impl RegistryService {
    pub fn new() -> Self {
        Self {
            state: Arc::new(Mutex::new(RegistryState {
                active_models: HashMap::new(),
                schemas: HashMap::new(),
                fallback_models: HashMap::new(),
            })),
        }
    }

    /// Register or update active model (with side effects isolated here only)
    pub fn set_active_model(&self, model: ModelVersion) -> Result<(), String> {
        // Validate using pure function first
        pure::validate_model_version(&model)?;
        if !pure::artifact_exists(&model.artifact_path) {
            return Err(format!("artifact not found: {}", model.artifact_path));
        }

        // Only perform state mutation after validation succeeds
        let mut state = self.state.lock().map_err(|e| format!("lock error: {}", e))?;

        // Store previous as fallback (deterministic logic via pure function)
        if let Some(prev) = state.active_models.get(&model.task_type).cloned() {
            state.fallback_models.insert(model.task_type.clone(), prev);
        }

        state.active_models.insert(model.task_type.clone(), model);
        Ok(())
    }

    /// Get current snapshot (immutable copy)
    pub fn snapshot(&self) -> Result<RegistrySnapshot, String> {
        let state = self.state.lock().map_err(|e| format!("lock error: {}", e))?;
        Ok(RegistrySnapshot {
            active_models: state.active_models.clone(),
            schemas: state.schemas.clone(),
            fallback_models: state.fallback_models.clone(),
        })
    }

    /// Lookup model (creates snapshot, uses pure lookup)
    pub fn get_active_model(&self, task_type: &str) -> Result<ModelVersion, String> {
        let snapshot = self.snapshot()?;
        snapshot.get_model(task_type)
    }

    /// Lookup fallback model (creates snapshot, uses pure lookup)
    pub fn get_fallback_model(&self, task_type: &str) -> Result<ModelVersion, String> {
        let snapshot = self.snapshot()?;
        snapshot.get_fallback(task_type)
    }

    /// Register schema
    pub fn register_schema(&self, schema: FeatureSchema) -> Result<(), String> {
        pure::validate_schema(&schema)?;

        let mut state = self.state.lock().map_err(|e| format!("lock error: {}", e))?;
        state.schemas.insert(schema.hash.clone(), schema);
        Ok(())
    }

    /// Get schema
    pub fn get_schema(&self, hash: &str) -> Result<FeatureSchema, String> {
        let snapshot = self.snapshot()?;
        snapshot.get_schema(hash)
    }

    /// Validate features (uses pure function)
    pub fn validate_features(&self, schema_hash: &str, features: &[f64]) -> Result<(), String> {
        let schema = self.get_schema(schema_hash)?;
        pure::validate_features(&schema, features)
    }

    /// Normalize features (uses pure function)
    pub fn normalize_features(&self, schema_hash: &str, features: &[f64]) -> Result<Vec<f64>, String> {
        let schema = self.get_schema(schema_hash)?;
        pure::normalize_features(features, &schema)
    }

    /// Get all active models
    pub fn list_active_models(&self) -> Result<Vec<ModelVersion>, String> {
        let snapshot = self.snapshot()?;
        Ok(snapshot.active_models.values().cloned().collect())
    }

    /// Health check (uses pure batch validation)
    pub fn health_check(&self) -> Result<(), Vec<String>> {
        let snapshot = self.snapshot().map_err(|e| vec![e])?;
        let models: Vec<_> = snapshot.active_models.values().cloned().collect();
        pure::bulk_validate_models(&models)
    }
}

impl Default for RegistryService {
    fn default() -> Self {
        Self::new()
    }
}

impl Clone for RegistryService {
    fn clone(&self) -> Self {
        Self {
            state: Arc::clone(&self.state),
        }
    }
}

// Re-export pure functions for consumer testing
pub use pure::{
    validate_model_version, validate_schema, validate_features, normalize_features,
};

/// Re-export module containing all pure operations
pub mod pure {
    pub use crate::pure_registry::pure::*;
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;
    use tempfile::NamedTempFile;

    fn create_test_model(task_type: &str) -> (NamedTempFile, ModelVersion) {
        let mut file = NamedTempFile::new().unwrap();
        file.write_all(b"test_model").unwrap();
        file.flush().unwrap();

        let model = ModelVersion {
            id: format!("model_{}", task_type),
            task_type: task_type.to_string(),
            version: 1,
            artifact_path: file.path().to_string_lossy().to_string(),
            schema_hash: "schema_h1".to_string(),
            status: "active".to_string(),
            created_at_ms: 1000,
        };

        (file, model)
    }

    #[test]
    fn test_register_and_retrieve_model() {
        let service = RegistryService::new();
        let (_file, model) = create_test_model("yield");

        service.set_active_model(model.clone()).unwrap();
        let retrieved = service.get_active_model("yield").unwrap();

        assert_eq!(retrieved.id, model.id);
        assert_eq!(retrieved.task_type, "yield");
    }

    #[test]
    fn test_fallback_chain() {
        let service = RegistryService::new();
        let (_file1, model_v1) = create_test_model("yield");

        // Register v1
        service.set_active_model(model_v1.clone()).unwrap();

        // Create v2 and register
        let mut file2 = NamedTempFile::new().unwrap();
        file2.write_all(b"model_v2").unwrap();
        file2.flush().unwrap();

        let model_v2 = ModelVersion {
            id: "model_v2".to_string(),
            task_type: "yield".to_string(),
            version: 2,
            artifact_path: file2.path().to_string_lossy().to_string(),
            schema_hash: "schema_h1".to_string(),
            status: "active".to_string(),
            created_at_ms: 2000,
        };

        service.set_active_model(model_v2.clone()).unwrap();

        // ✓ Active should be v2
        assert_eq!(service.get_active_model("yield").unwrap().version, 2);

        // ✓ Fallback should be v1
        assert_eq!(service.get_fallback_model("yield").unwrap().version, 1);
    }

    #[test]
    fn test_register_schema() {
        let service = RegistryService::new();
        let schema = FeatureSchema {
            hash: "h1".to_string(),
            version: 1,
            feature_names: vec!["temp".to_string()],
            feature_dtypes: vec!["f64".to_string()],
            normalization_params: None,
        };

        service.register_schema(schema.clone()).unwrap();
        let retrieved = service.get_schema("h1").unwrap();

        assert_eq!(retrieved.hash, "h1");
    }

    #[test]
    fn test_validate_features_through_service() {
        let service = RegistryService::new();
        let schema = FeatureSchema {
            hash: "h1".to_string(),
            version: 1,
            feature_names: vec!["temp".to_string(), "humidity".to_string()],
            feature_dtypes: vec!["f64".to_string(), "f64".to_string()],
            normalization_params: None,
        };

        service.register_schema(schema).unwrap();
        service.validate_features("h1", &[25.0, 60.0]).unwrap();
        assert!(service.validate_features("h1", &[25.0]).is_err()); // Wrong count
    }

    #[test]
    fn test_snapshot_isolation() {
        let service = RegistryService::new();
        let (_file, model) = create_test_model("yield");

        service.set_active_model(model).unwrap();

        // Get two snapshots - they should be equal but independent
        let snap1 = service.snapshot().unwrap();
        let snap2 = service.snapshot().unwrap();

        assert_eq!(snap1.active_models.len(), snap2.active_models.len());
        // Snapshots are independent copies
        assert_eq!(
            snap1.active_models.get("yield").unwrap().id,
            snap2.active_models.get("yield").unwrap().id
        );
    }

    #[test]
    fn test_concurrent_access() {
        use std::sync::Arc;
        use std::thread;

        let service = Arc::new(RegistryService::new());
        let (_file, model) = create_test_model("yield");

        service.set_active_model(model.clone()).unwrap();

        let mut handles = vec![];

        // Spawn multiple threads performing reads
        for _ in 0..10 {
            let svc = Arc::clone(&service);
            let handle = thread::spawn(move || {
                svc.get_active_model("yield").unwrap().id
            });
            handles.push(handle);
        }

        // All should succeed and return same ID
        for handle in handles {
            assert_eq!(handle.join().unwrap(), "model_yield");
        }
    }

    #[test]
    fn test_health_check() {
        let service = RegistryService::new();
        let (_file, model) = create_test_model("yield");

        service.set_active_model(model).unwrap();
        assert!(service.health_check().is_ok());
    }
}
