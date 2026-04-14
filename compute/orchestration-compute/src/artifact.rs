/// Artifact lifecycle management: storage, retention, lineage
use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc, Duration};
use std::collections::HashMap;

use crate::errors::{OrchestrationError, OrchestrationResult};

/// Artifact type classification
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ArtifactType {
    Transient,   // Compute intermediate, auto-delete after retention
    Retained,    // Kept for reproducibility or audit
    Archived,    // Long-term storage (e.g., cold storage)
    Published,   // Part of published output (versioned, queryable)
}

impl ArtifactType {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::Transient => "TRANSIENT",
            Self::Retained => "RETAINED",
            Self::Archived => "ARCHIVED",
            Self::Published => "PUBLISHED",
        }
    }
}

/// Retention policy for artifacts
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum RetentionPolicy {
    AutoDelete,     // Delete after timeout
    Retain,         // Keep indefinitely
    Archive,        // Move to cold storage after timeout
    ArchiveThenDelete, // Archive then eventually delete
}

impl RetentionPolicy {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::AutoDelete => "AUTO_DELETE",
            Self::Retain => "RETAIN",
            Self::Archive => "ARCHIVE",
            Self::ArchiveThenDelete => "ARCHIVE_THEN_DELETE",
        }
    }

    pub fn default_retention_days(&self) -> Option<i64> {
        match self {
            Self::AutoDelete => Some(7),               // 7 days default
            Self::Retain => None,                       // Forever
            Self::Archive => Some(90),                  // Archive after 90 days
            Self::ArchiveThenDelete => Some(365 * 2),  // 2 years then delete
        }
    }
}

/// Artifact metadata and lifecycle state
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArtifactMetadata {
    pub artifact_key: String,
    pub artifact_uri: String,
    pub size_bytes: u64,
    pub checksum: String, // SHA256 for integrity verification
    pub artifact_type: ArtifactType,
    pub retention_policy: RetentionPolicy,

    // Lifecycle tracking
    pub created_at: DateTime<Utc>,
    pub expires_at: Option<DateTime<Utc>>,
    pub archived_at: Option<DateTime<Utc>>,
    pub deleted_at: Option<DateTime<Utc>>,

    // Lineage
    pub source_job_id: Uuid,
    pub source_jobs: Vec<Uuid>,
    pub generation_params: HashMap<String, String>,

    // Purpose/context
    pub purpose: String,
    pub content_type: String,
}

impl ArtifactMetadata {
    pub fn new(
        artifact_key: impl Into<String>,
        artifact_uri: impl Into<String>,
        source_job_id: Uuid,
        checksum: impl Into<String>,
        size_bytes: u64,
    ) -> Self {
        Self {
            artifact_key: artifact_key.into(),
            artifact_uri: artifact_uri.into(),
            size_bytes,
            checksum: checksum.into(),
            artifact_type: ArtifactType::Transient,
            retention_policy: RetentionPolicy::AutoDelete,
            created_at: Utc::now(),
            expires_at: None,
            archived_at: None,
            deleted_at: None,
            source_job_id,
            source_jobs: vec![source_job_id],
            generation_params: HashMap::new(),
            purpose: String::new(),
            content_type: "application/octet-stream".to_string(),
        }
    }

    pub fn with_type(mut self, artifact_type: ArtifactType) -> Self {
        self.artifact_type = artifact_type;
        self
    }

    pub fn with_retention(mut self, policy: RetentionPolicy) -> Self {
        self.retention_policy = policy;
        self.expires_at = policy.default_retention_days().map(|days| {
            Utc::now() + Duration::days(days)
        });
        self
    }

    pub fn with_purpose(mut self, purpose: impl Into<String>) -> Self {
        self.purpose = purpose.into();
        self
    }

    pub fn with_content_type(mut self, content_type: impl Into<String>) -> Self {
        self.content_type = content_type.into();
        self
    }

    pub fn with_generation_params(mut self, params: HashMap<String, String>) -> Self {
        self.generation_params = params;
        self
    }

    pub fn with_source_jobs(mut self, jobs: Vec<Uuid>) -> Self {
        self.source_jobs = jobs;
        self
    }

    pub fn is_expired(&self) -> bool {
        if let Some(expires) = self.expires_at {
            Utc::now() > expires
        } else {
            false
        }
    }

    pub fn is_deleted(&self) -> bool {
        self.deleted_at.is_some()
    }

    pub fn mark_archived(&mut self) -> OrchestrationResult<()> {
        if self.archived_at.is_some() {
            return Err(OrchestrationError::ArtifactLifecycleViolation(
                "Artifact already archived".to_string(),
            ));
        }
        if self.deleted_at.is_some() {
            return Err(OrchestrationError::ArtifactLifecycleViolation(
                "Cannot archive deleted artifact".to_string(),
            ));
        }
        self.archived_at = Some(Utc::now());
        Ok(())
    }

    pub fn mark_deleted(&mut self) -> OrchestrationResult<()> {
        if self.deleted_at.is_some() {
            return Err(OrchestrationError::ArtifactLifecycleViolation(
                "Artifact already deleted".to_string(),
            ));
        }
        self.deleted_at = Some(Utc::now());
        Ok(())
    }
}

/// Handle to an artifact, allowing safe access and lifecycle management
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArtifactHandle {
    pub metadata: ArtifactMetadata,
}

impl ArtifactHandle {
    pub fn new(metadata: ArtifactMetadata) -> Self {
        Self { metadata }
    }

    pub fn uri(&self) -> &str {
        &self.metadata.artifact_uri
    }

    pub fn is_ready_for_cleanup(&self) -> bool {
        match self.metadata.retention_policy {
            RetentionPolicy::AutoDelete => self.metadata.is_expired() && !self.metadata.is_deleted(),
            RetentionPolicy::ArchiveThenDelete => {
                // Ready for deletion if archived and archive period expired
                if let Some(archived_at) = self.metadata.archived_at {
                    let archive_retention = Duration::days(365 * 2); // 2 years in archive
                    let now = Utc::now();
                    now.signed_duration_since(archived_at) > archive_retention
                } else {
                    false
                }
            }
            _ => false,
        }
    }

    pub fn is_ready_for_archive(&self) -> bool {
        match self.metadata.retention_policy {
            RetentionPolicy::Archive | RetentionPolicy::ArchiveThenDelete => {
                self.metadata.is_expired()
                    && self.metadata.archived_at.is_none()
                    && !self.metadata.is_deleted()
            }
            _ => false,
        }
    }
}

/// Artifact lifecycle manager
pub struct ArtifactLifecycle {
    artifacts: std::sync::Arc<parking_lot::RwLock<Vec<ArtifactMetadata>>>,
}

impl ArtifactLifecycle {
    pub fn new() -> Self {
        Self {
            artifacts: std::sync::Arc::new(parking_lot::RwLock::new(Vec::new())),
        }
    }

    pub fn register(&self, metadata: ArtifactMetadata) -> OrchestrationResult<ArtifactHandle> {
        let mut artifacts = self.artifacts.write();
        artifacts.push(metadata.clone());
        Ok(ArtifactHandle::new(metadata))
    }

    pub fn get(&self, artifact_uri: &str) -> Option<ArtifactHandle> {
        let artifacts = self.artifacts.read();
        artifacts
            .iter()
            .find(|a| a.artifact_uri == artifact_uri)
            .map(|a| ArtifactHandle::new(a.clone()))
    }

    pub fn list_for_cleanup(&self) -> Vec<ArtifactHandle> {
        let artifacts = self.artifacts.read();
        artifacts
            .iter()
            .filter(|a| ArtifactHandle::new((*a).clone()).is_ready_for_cleanup())
            .map(|a| ArtifactHandle::new((*a).clone()))
            .collect()
    }

    pub fn list_for_archive(&self) -> Vec<ArtifactHandle> {
        let artifacts = self.artifacts.read();
        artifacts
            .iter()
            .filter(|a| ArtifactHandle::new((*a).clone()).is_ready_for_archive())
            .map(|a| ArtifactHandle::new((*a).clone()))
            .collect()
    }

    pub fn list_by_job(&self, job_id: Uuid) -> Vec<ArtifactHandle> {
        let artifacts = self.artifacts.read();
        artifacts
            .iter()
            .filter(|a| a.source_job_id == job_id)
            .map(|a| ArtifactHandle::new(a.clone()))
            .collect()
    }

    pub fn mark_archived(&self, artifact_uri: &str) -> OrchestrationResult<()> {
        let mut artifacts = self.artifacts.write();
        let artifact = artifacts
            .iter_mut()
            .find(|a| a.artifact_uri == artifact_uri)
            .ok_or_else(|| {
                OrchestrationError::ArtifactNotFound(artifact_uri.to_string())
            })?;
        artifact.mark_archived()
    }

    pub fn mark_deleted(&self, artifact_uri: &str) -> OrchestrationResult<()> {
        let mut artifacts = self.artifacts.write();
        let artifact = artifacts
            .iter_mut()
            .find(|a| a.artifact_uri == artifact_uri)
            .ok_or_else(|| {
                OrchestrationError::ArtifactNotFound(artifact_uri.to_string())
            })?;
        artifact.mark_deleted()
    }

    pub fn total_size_bytes(&self) -> u64 {
        let artifacts = self.artifacts.read();
        artifacts.iter().map(|a| a.size_bytes).sum()
    }

    pub fn artifacts_by_retention_policy(&self, policy: RetentionPolicy) -> Vec<ArtifactHandle> {
        let artifacts = self.artifacts.read();
        artifacts
            .iter()
            .filter(|a| a.retention_policy == policy)
            .map(|a| ArtifactHandle::new(a.clone()))
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_artifact_lifecycle() {
        let job_id = Uuid::new_v4();
        let metadata = ArtifactMetadata::new(
            "test-artifact",
            "s3://bucket/artifact",
            job_id,
            "abc123def456",
            1024,
        )
        .with_type(ArtifactType::Transient)
        .with_retention(RetentionPolicy::AutoDelete);

        assert!(!metadata.is_expired()); // Just created
        assert!(!metadata.is_deleted());
    }

    #[test]
    fn test_artifact_lifecycle_transitions() {
        let job_id = Uuid::new_v4();
        let mut metadata = ArtifactMetadata::new(
            "test",
            "s3://bucket/artifact",
            job_id,
            "hash",
            1024,
        );

        metadata.mark_archived().unwrap();
        assert!(metadata.archived_at.is_some());

        // Cannot mark deleted after archived (should allow archive -> delete flow)
        metadata.mark_deleted().unwrap();
        assert!(metadata.is_deleted());
    }

    #[test]
    fn test_artifact_cleanup_readiness() {
        let job_id = Uuid::new_v4();
        let handle = ArtifactHandle::new(
            ArtifactMetadata::new("test", "s3://test", job_id, "hash", 1024)
                .with_type(ArtifactType::Transient)
                .with_retention(RetentionPolicy::AutoDelete),
        );

        // Just created, not ready for cleanup
        assert!(!handle.is_ready_for_cleanup());
    }
}
