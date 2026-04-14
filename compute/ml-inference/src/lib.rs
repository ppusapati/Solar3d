pub mod feature_pipeline;
pub mod yield_forecasting;
pub mod anomaly_detection;
pub mod degradation_forecasting;
pub mod model_registry;
pub mod pure_registry;
pub mod registry_service;

pub use feature_pipeline::FeaturePipeline;
pub use yield_forecasting::YieldForecaster;
pub use anomaly_detection::AnomalyDetector;
pub use degradation_forecasting::DegradationForecaster;
pub use model_registry::{ModelVersion, FeatureSchema, VersionedPredictionRequest, VersionedPredictionResponse};
pub use registry_service::RegistryService;
pub use pure_registry::{RegistrySnapshot, pure as pure_registry_ops};

// Backward compatibility - ModelRegistry deprecated in favor of RegistryService
#[deprecated(since = "0.2.0", note = "Use RegistryService (pure API) instead of ModelRegistry")]
pub use model_registry::ModelRegistry;
