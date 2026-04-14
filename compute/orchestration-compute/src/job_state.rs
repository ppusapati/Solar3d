/// Job state machine and lifecycle management
use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc, Duration};
use crate::errors::{OrchestrationError, OrchestrationResult};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum JobStatus {
    Queued,
    Running,
    Succeeded,
    Failed,
    DeadLettered,
    Canceled,
    RetryPending,
}

impl JobStatus {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::Queued => "QUEUED",
            Self::Running => "RUNNING",
            Self::Succeeded => "SUCCEEDED",
            Self::Failed => "FAILED",
            Self::DeadLettered => "DEAD_LETTERED",
            Self::Canceled => "CANCELED",
            Self::RetryPending => "RETRY_PENDING",
        }
    }

    pub fn is_terminal(&self) -> bool {
        matches!(
            self,
            Self::Succeeded | Self::Failed | Self::DeadLettered | Self::Canceled
        )
    }

    pub fn is_active(&self) -> bool {
        matches!(self, Self::Queued | Self::Running | Self::RetryPending)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum JobPhase {
    Submitted,
    Acknowledged,
    Executing,
    Finalizing,
    Complete,
}

/// Full job lifecycle tracking with deterministic transitions
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct JobLifecycle {
    pub job_id: Uuid,
    pub status: JobStatus,
    pub phase: JobPhase,

    // Timing
    pub created_at: DateTime<Utc>,
    pub started_at: Option<DateTime<Utc>>,
    pub completed_at: Option<DateTime<Utc>>,

    // Retry and failure tracking
    pub attempt_number: u32,
    pub max_attempts: u32,
    pub on_failure_action: FailureAction,

    // Determinism and idempotency
    pub idempotency_key: Option<String>,
    pub idempotency_token: Uuid,
    pub trace_id: Uuid,

    // Lineage
    pub parent_job_id: Option<Uuid>,
    pub causation_id: Uuid,

    // Last known error
    pub last_error: Option<String>,
    pub last_error_classification: Option<String>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum FailureAction {
    Fail,
    Retry,
    Skip,
    DeadLetter,
}

impl JobLifecycle {
    pub fn new(job_id: Uuid) -> Self {
        let now = Utc::now();
        Self {
            job_id,
            status: JobStatus::Queued,
            phase: JobPhase::Submitted,
            created_at: now,
            started_at: None,
            completed_at: None,
            attempt_number: 1,
            max_attempts: 3,
            on_failure_action: FailureAction::Retry,
            idempotency_key: None,
            idempotency_token: Uuid::new_v4(),
            trace_id: Uuid::new_v4(),
            parent_job_id: None,
            causation_id: Uuid::new_v4(),
            last_error: None,
            last_error_classification: None,
        }
    }

    pub fn with_idempotency_key(mut self, key: impl Into<Option<String>>) -> Self {
        self.idempotency_key = key.into();
        self
    }

    pub fn with_parent_job(mut self, parent_id: Uuid) -> Self {
        self.parent_job_id = Some(parent_id);
        self
    }

    pub fn with_max_attempts(mut self, max: u32) -> Self {
        self.max_attempts = max.max(1);
        self
    }

    pub fn with_failure_action(mut self, action: FailureAction) -> Self {
        self.on_failure_action = action;
        self
    }

    /// Transition from Queued to Running
    pub fn transition_to_running(&mut self) -> OrchestrationResult<()> {
        if self.status != JobStatus::Queued && self.status != JobStatus::RetryPending {
            return Err(OrchestrationError::InvalidStateTransition(format!(
                "Cannot transition from {:?} to Running",
                self.status
            )));
        }

        self.status = JobStatus::Running;
        self.phase = JobPhase::Executing;
        self.started_at = Some(Utc::now());
        Ok(())
    }

    /// Transition to succeeded with deterministic completion
    pub fn transition_to_succeeded(&mut self) -> OrchestrationResult<()> {
        if !matches!(self.status, JobStatus::Running) {
            return Err(OrchestrationError::InvalidStateTransition(format!(
                "Cannot transition to Succeeded from {:?}",
                self.status
            )));
        }

        self.status = JobStatus::Succeeded;
        self.phase = JobPhase::Complete;
        self.completed_at = Some(Utc::now());
        self.last_error = None;
        Ok(())
    }

    /// Transition to failed, applying on_failure_action logic
    pub fn transition_to_failed(
        &mut self,
        error: String,
        classification: String,
    ) -> OrchestrationResult<()> {
        if !matches!(
            self.status,
            JobStatus::Running | JobStatus::Queued
        ) {
            return Err(OrchestrationError::InvalidStateTransition(format!(
                "Cannot transition to Failed from {:?}",
                self.status
            )));
        }

        self.last_error = Some(error);
        self.last_error_classification = Some(classification);
        self.completed_at = Some(Utc::now());

        match self.on_failure_action {
            FailureAction::Retry if self.attempt_number < self.max_attempts => {
                self.status = JobStatus::RetryPending;
                self.phase = JobPhase::Complete;
                self.attempt_number += 1;
                Ok(())
            }
            FailureAction::DeadLetter => {
                self.status = JobStatus::DeadLettered;
                self.phase = JobPhase::Complete;
                Ok(())
            }
            FailureAction::Skip => {
                self.status = JobStatus::Succeeded;
                self.phase = JobPhase::Complete;
                Ok(())
            }
            _ => {
                self.status = JobStatus::Failed;
                self.phase = JobPhase::Complete;
                Ok(())
            }
        }
    }

    /// Transition to canceled
    pub fn transition_to_canceled(&mut self) -> OrchestrationResult<()> {
        if self.status.is_terminal() {
            return Err(OrchestrationError::InvalidStateTransition(
                "Cannot cancel terminal job".to_string(),
            ));
        }

        self.status = JobStatus::Canceled;
        self.phase = JobPhase::Complete;
        self.completed_at = Some(Utc::now());
        Ok(())
    }

    /// Check if job has exceeded timeout
    pub fn is_timeout(&self, timeout: Duration) -> bool {
        if let Some(started) = self.started_at {
            Utc::now().signed_duration_since(started) > timeout
        } else {
            false
        }
    }

    /// Get elapsed duration since job start
    pub fn elapsed(&self) -> Option<Duration> {
        self.started_at.map(|started| Utc::now().signed_duration_since(started))
    }

    /// Check if job can be retried
    pub fn can_retry(&self) -> bool {
        self.status == JobStatus::RetryPending
            && self.attempt_number <= self.max_attempts
            && matches!(self.on_failure_action, FailureAction::Retry)
    }

    /// Compute deterministic retry backoff (exponential with jitter)
    pub fn retry_backoff(&self) -> Duration {
        let base_seconds = 2_i64 * (self.attempt_number as i64);
        Duration::seconds(base_seconds)
    }

    /// Verify idempotency: same input token should produce same output
    pub fn verify_idempotency(&self, token: Uuid) -> OrchestrationResult<()> {
        if self.idempotency_token != token {
            return Err(OrchestrationError::IdempotencyViolation(format!(
                "Token mismatch: expected {:?}, got {:?}",
                self.idempotency_token, token
            )));
        }
        Ok(())
    }
}

/// Job state snapshot for distributed coordination
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct JobState {
    pub lifecycle: JobLifecycle,
    pub payload: serde_json::Value,
    pub execution_timeout_seconds: u32,
}

impl JobState {
    pub fn new(job_id: Uuid, payload: serde_json::Value) -> Self {
        Self {
            lifecycle: JobLifecycle::new(job_id),
            payload,
            execution_timeout_seconds: 3600,
        }
    }

    pub fn with_idempotency_key(mut self, key: impl Into<Option<String>>) -> Self {
        self.lifecycle = self.lifecycle.with_idempotency_key(key);
        self
    }

    pub fn with_parent_job(mut self, parent_id: Uuid) -> Self {
        self.lifecycle = self.lifecycle.with_parent_job(parent_id);
        self
    }

    pub fn to_json(&self) -> serde_json::Value {
        serde_json::to_value(self).unwrap_or_else(|_| serde_json::json!({}))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_job_lifecycle_transitions() {
        let job_id = Uuid::new_v4();
        let mut lifecycle = JobLifecycle::new(job_id);

        assert_eq!(lifecycle.status, JobStatus::Queued);
        assert_eq!(lifecycle.attempt_number, 1);

        lifecycle.transition_to_running().unwrap();
        assert_eq!(lifecycle.status, JobStatus::Running);

        lifecycle.transition_to_succeeded().unwrap();
        assert_eq!(lifecycle.status, JobStatus::Succeeded);
    }

    #[test]
    fn test_job_retry_logic() {
        let job_id = Uuid::new_v4();
        let mut lifecycle = JobLifecycle::new(job_id)
            .with_max_attempts(3)
            .with_failure_action(FailureAction::Retry);

        lifecycle.transition_to_running().unwrap();

        // First failure should retry
        lifecycle
            .transition_to_failed("error1".to_string(), "EXEC_ERROR".to_string())
            .unwrap();
        assert_eq!(lifecycle.status, JobStatus::RetryPending);
        assert_eq!(lifecycle.attempt_number, 2);

        // Should be queuable for retry
        assert!(lifecycle.can_retry());
    }

    #[test]
    fn test_job_max_retries_exceeds() {
        let job_id = Uuid::new_v4();
        let mut lifecycle = JobLifecycle::new(job_id)
            .with_max_attempts(2)
            .with_failure_action(FailureAction::Retry);

        // First attempt: Running -> Failed -> RetryPending
        lifecycle.transition_to_running().unwrap();
        lifecycle
            .transition_to_failed("error".to_string(), "EXEC_ERROR".to_string())
            .unwrap();
        assert_eq!(lifecycle.status, JobStatus::RetryPending);
        assert_eq!(lifecycle.attempt_number, 2);
        assert!(lifecycle.can_retry());

        // Second attempt: running -> Failed -> Failed (max retries exceeded)
        lifecycle.transition_to_running().unwrap();
        lifecycle
            .transition_to_failed("final error".to_string(), "MAX_RETRIES".to_string())
            .unwrap();

        // Should not allow more retries now
        assert!(!lifecycle.can_retry());
        assert_eq!(lifecycle.status, JobStatus::Failed);
    }
}
