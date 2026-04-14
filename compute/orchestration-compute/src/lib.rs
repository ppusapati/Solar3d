/// Idempotent computation framework for deterministic, resilient job execution.
///
/// Key principles:
/// 1. Determinism: Same input always produces same output (same attempt yield same result)
/// 2. Idempotency: Multiple executions with same idempotency token produce identical outcome
/// 3. Artifact safety: All outputs tracked with lineage and retention metadata
/// 4. Lineage tracking: Full audit trail of job dependencies and data flow

mod job_state;
mod computation;
mod artifact;
mod lineage;
mod errors;

#[cfg(test)]
mod determinism_tests;

pub use job_state::{JobState, JobStatus, JobPhase, JobLifecycle};
pub use computation::{
    IdempotentComputation, ComputationContext, ComputationResult, ComputationRequest,
};
pub use artifact::{ArtifactHandle, ArtifactLifecycle, ArtifactMetadata, RetentionPolicy};
pub use lineage::{LineageTracker, DataFlow, LineageEvent};
pub use errors::{OrchestrationError, OrchestrationResult};

pub mod prelude {
    pub use crate::{
        IdempotentComputation, ComputationContext, ComputationResult, ComputationRequest,
        ArtifactHandle, ArtifactLifecycle, ArtifactMetadata, RetentionPolicy,
        LineageTracker, DataFlow, LineageEvent,
        JobState, JobStatus, JobPhase, JobLifecycle,
        OrchestrationError, OrchestrationResult,
    };
}
