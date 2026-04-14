/// Idempotent computation trait and execution context
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use std::collections::HashMap;

use crate::errors::OrchestrationResult;
use crate::artifact::ArtifactHandle;
use crate::lineage::LineageTracker;

/// Fingerprint of a computation request for deterministic idempotency
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ComputationRequest {
    pub job_id: Uuid,
    pub idempotency_token: Uuid,
    pub trace_id: Uuid,
    pub parent_job_id: Option<Uuid>,
    pub payload: serde_json::Value,
    pub timeout_seconds: u32,
}

impl ComputationRequest {
    pub fn fingerprint(&self) -> String {
        use sha2::{Sha256, Digest};
        use hex::encode;

        let payload_str = serde_json::to_string(&self.payload)
            .unwrap_or_else(|_| String::new());
        
        let input = format!(
            "{}:{}:{}",
            self.job_id, self.idempotency_token, payload_str
        );

        let mut hasher = Sha256::new();
        hasher.update(input.as_bytes());
        encode(hasher.finalize())
    }
}

/// Result of a computation with deterministic outputs
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ComputationResult {
    pub job_id: Uuid,
    pub trace_id: Uuid,
    pub status: String, // "SUCCESS" or "FAILED"
    pub output_payload: serde_json::Value,
    pub artifacts: Vec<ArtifactHandle>,
    pub execution_time_ms: u64,
    pub started_at: DateTime<Utc>,
    pub completed_at: DateTime<Utc>,
}

/// Execution context for computations: provides access to lineage, artifacts, and state
#[derive(Clone)]
pub struct ComputationContext {
    pub job_id: Uuid,
    pub trace_id: Uuid,
    pub request: ComputationRequest,

    // Artifact storage handle
    artifact_store: Option<std::sync::Arc<dyn ArtifactStore>>,

    // Lineage tracker
    lineage: std::sync::Arc<LineageTracker>,

    // Deterministic seed for reproducibility
    pub deterministic_seed: u64,

    // Execution metadata
    pub started_at: DateTime<Utc>,
    pub metadata: HashMap<String, String>,
}

impl ComputationContext {
    pub fn new(request: ComputationRequest) -> Self {
        let now = Utc::now();
        Self {
            job_id: request.job_id,
            trace_id: request.trace_id,
            request,
            artifact_store: None,
            lineage: std::sync::Arc::new(LineageTracker::new()),
            deterministic_seed: 42, // Default: use trace_id as seed if deterministic
            started_at: now,
            metadata: HashMap::new(),
        }
    }

    pub fn with_artifact_store(mut self, store: std::sync::Arc<dyn ArtifactStore>) -> Self {
        self.artifact_store = Some(store);
        self
    }

    pub fn with_deterministic_seed(mut self, seed: u64) -> Self {
        self.deterministic_seed = seed;
        self
    }

    pub fn set_metadata(&mut self, key: impl Into<String>, value: impl Into<String>) {
        self.metadata.insert(key.into(), value.into());
    }

    pub fn get_metadata(&self, key: &str) -> Option<&str> {
        self.metadata.get(key).map(|s| s.as_str())
    }

    pub fn lineage_tracker(&self) -> std::sync::Arc<LineageTracker> {
        self.lineage.clone()
    }

    pub fn get_artifact_store(&self) -> Option<std::sync::Arc<dyn ArtifactStore>> {
        self.artifact_store.clone()
    }

    pub fn elapsed_ms(&self) -> u64 {
        Utc::now()
            .signed_duration_since(self.started_at)
            .num_milliseconds()
            .max(0) as u64
    }
}

/// Trait for artifact storage backends (S3, GCS, local filesystem, etc.)
#[async_trait]
pub trait ArtifactStore: Send + Sync {
    async fn store(
        &self,
        job_id: Uuid,
        artifact_key: &str,
        data: Vec<u8>,
    ) -> OrchestrationResult<String>;

    async fn retrieve(
        &self,
        artifact_uri: &str,
    ) -> OrchestrationResult<Vec<u8>>;

    async fn delete(&self, artifact_uri: &str) -> OrchestrationResult<()>;

    async fn exists(&self, artifact_uri: &str) -> OrchestrationResult<bool>;
}

/// Core trait for deterministic, idempotent computations
///
/// Implementations MUST:
/// 1. Be deterministic: same input yields same output
/// 2. Be idempotent: multiple calls with same token yield same result
/// 3. Track all artifacts with proper lineage
/// 4. Handle failures gracefully and support retries
/// 5. Report execution time and resource usage
#[async_trait]
pub trait IdempotentComputation: Send + Sync {
    /// Unique name for this computation (e.g., "SimulationExecutor")
    fn name(&self) -> &'static str;

    /// Execute the computation deterministically
    async fn execute(
        &self,
        context: &ComputationContext,
    ) -> OrchestrationResult<ComputationResult>;

    /// Verify that previous result is valid for current request
    /// (optional optimization: enable caching across identical requests)
    async fn validate_cached_result(
        &self,
        context: &ComputationContext,
        previous_result: &ComputationResult,
    ) -> OrchestrationResult<bool> {
        // Default: no cross-request caching
        Ok(false)
    }

    /// Check if computation is idempotent (default: true)
    fn is_idempotent(&self) -> bool {
        true
    }
}

/// Executor wrapper with retry logic and failure handling
pub struct ComputationExecutor {
    computation: std::sync::Arc<dyn IdempotentComputation>,
    max_retries: u32,
    retry_backoff_base_ms: u64,
}

impl ComputationExecutor {
    pub fn new(computation: std::sync::Arc<dyn IdempotentComputation>) -> Self {
        Self {
            computation,
            max_retries: 3,
            retry_backoff_base_ms: 2000,
        }
    }

    pub fn with_max_retries(mut self, max: u32) -> Self {
        self.max_retries = max;
        self
    }

    pub fn with_backoff_base(mut self, base_ms: u64) -> Self {
        self.retry_backoff_base_ms = base_ms;
        self
    }

    /// Execute with automatic retries and deterministic backoff
    pub async fn execute_with_retries(
        &self,
        context: &ComputationContext,
    ) -> OrchestrationResult<ComputationResult> {
        let mut attempt = 0;
        let max_attempts = if self.computation.is_idempotent() {
            self.max_retries + 1
        } else {
            1
        };

        loop {
            attempt += 1;

            match self.computation.execute(context).await {
                Ok(result) => {
                    if attempt > 1 {
                        tracing::info!(
                            job_id = %context.job_id,
                            attempt,
                            "Computation succeeded after retries"
                        );
                    }
                    return Ok(result);
                }
                Err(e) if attempt < max_attempts && e.is_retryable() => {
                    let backoff_ms = self.retry_backoff_base_ms * (2_u64.pow((attempt - 1) as u32));
                    tracing::warn!(
                        job_id = %context.job_id,
                        attempt,
                        backoff_ms,
                        error = %e,
                        "Computation failed, retrying with backoff"
                    );
                    tokio::time::sleep(tokio::time::Duration::from_millis(backoff_ms)).await;
                }
                Err(e) => {
                    tracing::error!(
                        job_id = %context.job_id,
                        attempt,
                        error = %e,
                        "Computation failed permanently"
                    );
                    return Err(e);
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_computation_request_fingerprint() {
        let req1 = ComputationRequest {
            job_id: Uuid::nil(),
            idempotency_token: Uuid::nil(),
            trace_id: Uuid::nil(),
            parent_job_id: None,
            payload: serde_json::json!({"key": "value"}),
            timeout_seconds: 3600,
        };

        let req2 = ComputationRequest {
            job_id: Uuid::nil(),
            idempotency_token: Uuid::nil(),
            trace_id: Uuid::nil(),
            parent_job_id: None,
            payload: serde_json::json!({"key": "value"}),
            timeout_seconds: 3600,
        };

        assert_eq!(req1.fingerprint(), req2.fingerprint());
    }

    #[test]
    fn test_computation_context() {
        let req = ComputationRequest {
            job_id: Uuid::new_v4(),
            idempotency_token: Uuid::new_v4(),
            trace_id: Uuid::new_v4(),
            parent_job_id: None,
            payload: serde_json::json!({}),
            timeout_seconds: 3600,
        };

        let ctx = ComputationContext::new(req.clone());
        assert_eq!(ctx.job_id, req.job_id);
        assert_eq!(ctx.trace_id, req.trace_id);
    }
}
