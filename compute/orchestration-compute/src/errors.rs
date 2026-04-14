/// Error types for orchestration and computation
use thiserror::Error;
use std::fmt;

pub type OrchestrationResult<T> = Result<T, OrchestrationError>;

#[derive(Error, Debug, Clone)]
pub enum OrchestrationError {
    #[error("Idempotency violation: {0}")]
    IdempotencyViolation(String),

    #[error("Job state transition invalid: {0}")]
    InvalidStateTransition(String),

    #[error("Computation failed: {0}")]
    ComputationFailed(String),

    #[error("Artifact not found: {0}")]
    ArtifactNotFound(String),

    #[error("Artifact lifecycle violation: {0}")]
    ArtifactLifecycleViolation(String),

    #[error("Lineage broken: {0}")]
    LineageBroken(String),

    #[error("Timeout exceeded: {0}")]
    TimeoutExceeded(String),

    #[error("Circuit breaker open: {0}")]
    CircuitBreakerOpen(String),

    #[error("Max retries exceeded: {0}")]
    MaxRetriesExceeded(String),

    #[error("Dependency failed: {0}")]
    DependencyFailed(String),

    #[error("Data error: {0}")]
    DataError(String),

    #[error("Configuration error: {0}")]
    ConfigurationError(String),

    #[error("Internal error: {0}")]
    InternalError(String),
}

impl OrchestrationError {
    pub fn classification(&self) -> &'static str {
        match self {
            OrchestrationError::IdempotencyViolation(_) => "IDEMPOTENCY_ERROR",
            OrchestrationError::InvalidStateTransition(_) => "STATE_ERROR",
            OrchestrationError::ComputationFailed(_) => "EXEC_ERROR",
            OrchestrationError::ArtifactNotFound(_) => "DATA_ERROR",
            OrchestrationError::ArtifactLifecycleViolation(_) => "DATA_ERROR",
            OrchestrationError::LineageBroken(_) => "AUDIT_ERROR",
            OrchestrationError::TimeoutExceeded(_) => "TIMEOUT",
            OrchestrationError::CircuitBreakerOpen(_) => "CIRCUIT_BREAKER",
            OrchestrationError::MaxRetriesExceeded(_) => "MAX_RETRIES",
            OrchestrationError::DependencyFailed(_) => "DEPENDENCY_FAILED",
            OrchestrationError::DataError(_) => "DATA_ERROR",
            OrchestrationError::ConfigurationError(_) => "CONFIG_ERROR",
            OrchestrationError::InternalError(_) => "INTERNAL_ERROR",
        }
    }

    pub fn is_retryable(&self) -> bool {
        matches!(
            self,
            OrchestrationError::ComputationFailed(_)
                | OrchestrationError::TimeoutExceeded(_)
                | OrchestrationError::CircuitBreakerOpen(_)
        )
    }

    pub fn with_context<S: Into<String>>(self, context: S) -> Self {
        let context = context.into();
        match self {
            OrchestrationError::ComputationFailed(msg) => {
                OrchestrationError::ComputationFailed(format!("{}: {}", context, msg))
            }
            other => OrchestrationError::InternalError(format!("{}: {:?}", context, other)),
        }
    }
}
