/// Data lineage and provenance tracking
use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use std::collections::HashMap;

use crate::errors::OrchestrationResult;

/// Type of data flow between jobs
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum DataFlow {
    Input,          // Data consumed by job
    Output,         // Data produced by job
    Config,         // Configuration used by job
    Artifact,       // Artifact reference
    Dependency,     // Job dependency (not data, but control flow)
}

impl DataFlow {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::Input => "INPUT",
            Self::Output => "OUTPUT",
            Self::Config => "CONFIG",
            Self::Artifact => "ARTIFACT",
            Self::Dependency => "DEPENDENCY",
        }
    }
}

/// Single lineage event
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LineageEvent {
    pub source_job_id: Uuid,
    pub target_job_id: Option<Uuid>, // None for terminal artifacts
    pub data_flow: DataFlow,
    pub artifact_uri: Option<String>,
    pub transformation_name: Option<String>,
    pub metadata: HashMap<String, String>,
    pub timestamp: DateTime<Utc>,
}

impl LineageEvent {
    pub fn new(
        source_job_id: Uuid,
        data_flow: DataFlow,
    ) -> Self {
        Self {
            source_job_id,
            target_job_id: None,
            data_flow,
            artifact_uri: None,
            transformation_name: None,
            metadata: HashMap::new(),
            timestamp: Utc::now(),
        }
    }

    pub fn with_target(mut self, target_job_id: Uuid) -> Self {
        self.target_job_id = Some(target_job_id);
        self
    }

    pub fn with_artifact(mut self, uri: impl Into<String>) -> Self {
        self.artifact_uri = Some(uri.into());
        self
    }

    pub fn with_transformation(mut self, name: impl Into<String>) -> Self {
        self.transformation_name = Some(name.into());
        self
    }

    pub fn with_metadata(mut self, key: impl Into<String>, value: impl Into<String>) -> Self {
        self.metadata.insert(key.into(), value.into());
        self
    }
}

/// Lineage tracking
#[derive(Debug, Clone)]
pub struct LineageTracker {
    events: std::sync::Arc<parking_lot::RwLock<Vec<LineageEvent>>>,
}

impl LineageTracker {
    pub fn new() -> Self {
        Self {
            events: std::sync::Arc::new(parking_lot::RwLock::new(Vec::new())),
        }
    }

    pub fn record(&self, event: LineageEvent) {
        let mut events = self.events.write();
        events.push(event);
    }

    pub fn record_input(&self, job_id: Uuid, source_data: impl Into<String>) {
        let event = LineageEvent::new(job_id, DataFlow::Input)
            .with_artifact(source_data);
        self.record(event);
    }

    pub fn record_output(&self, job_id: Uuid, artifact_uri: impl Into<String>) {
        let event = LineageEvent::new(job_id, DataFlow::Output)
            .with_artifact(artifact_uri);
        self.record(event);
    }

    pub fn record_config(&self, job_id: Uuid, config_key: impl Into<String>) {
        let event = LineageEvent::new(job_id, DataFlow::Config)
            .with_artifact(config_key);
        self.record(event);
    }

    pub fn record_dependency(&self, source_job: Uuid, target_job: Uuid) {
        let event = LineageEvent::new(source_job, DataFlow::Dependency)
            .with_target(target_job);
        self.record(event);
    }

    pub fn record_transformation(
        &self,
        source_job: Uuid,
        target_job: Uuid,
        transformation_name: impl Into<String>,
        artifact_uri: impl Into<String>,
    ) {
        let event = LineageEvent::new(source_job, DataFlow::Output)
            .with_target(target_job)
            .with_transformation(transformation_name)
            .with_artifact(artifact_uri);
        self.record(event);
    }

    pub fn get_events(&self) -> Vec<LineageEvent> {
        self.events.read().clone()
    }

    pub fn get_upstream(&self, job_id: Uuid) -> Vec<Uuid> {
        let events = self.events.read();
        events
            .iter()
            .filter(|e| e.target_job_id == Some(job_id))
            .map(|e| e.source_job_id)
            .collect()
    }

    pub fn get_downstream(&self, job_id: Uuid) -> Vec<Uuid> {
        let events = self.events.read();
        events
            .iter()
            .filter(|e| e.source_job_id == job_id && e.target_job_id.is_some())
            .filter_map(|e| e.target_job_id)
            .collect()
    }

    pub fn get_artifacts_produced(&self, job_id: Uuid) -> Vec<String> {
        let events = self.events.read();
        events
            .iter()
            .filter(|e| e.source_job_id == job_id && e.data_flow == DataFlow::Output)
            .filter_map(|e| e.artifact_uri.clone())
            .collect()
    }

    pub fn get_full_lineage_chain(&self, job_id: Uuid) -> Vec<Vec<Uuid>> {
        // BFS to find all upstream job chains
        let mut chains: Vec<Vec<Uuid>> = Vec::new();
        let mut queue: Vec<(Uuid, Vec<Uuid>)> = vec![(job_id, vec![job_id])];

        while let Some((current_job, chain)) = queue.pop() {
            let upstream = self.get_upstream(current_job);
            if upstream.is_empty() {
                chains.push(chain);
            } else {
                for parent_job in upstream {
                    if !chain.contains(&parent_job) {
                        let mut new_chain = chain.clone();
                        new_chain.push(parent_job);
                        queue.push((parent_job, new_chain));
                    }
                }
            }
        }

        chains
    }

    pub fn validate_lineage_integrity(&self, job_id: Uuid) -> OrchestrationResult<()> {
        let events = self.events.read();

        // Check that all upstream jobs are referenced in events
        let upstream_jobs: Vec<Uuid> = events
            .iter()
            .filter(|e| e.target_job_id == Some(job_id))
            .map(|e| e.source_job_id)
            .collect();

        // Check for cycles (simplified: if job appears in its own upstream chain, it's a cycle)
        for upstream_job in upstream_jobs {
            if self.get_upstream(upstream_job).contains(&job_id) {
                return Err(crate::errors::OrchestrationError::LineageBroken(
                    format!("Circular dependency detected: {} -> {}", job_id, upstream_job),
                ));
            }
        }

        Ok(())
    }

    pub fn export_as_json(&self) -> serde_json::Value {
        let events = self.events.read();
        serde_json::to_value(events.clone()).unwrap_or_else(|_| serde_json::json!({}))
    }
}

impl Default for LineageTracker {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_lineage_tracking() {
        let tracker = LineageTracker::new();
        let job1 = Uuid::new_v4();
        let job2 = Uuid::new_v4();

        tracker.record_dependency(job1, job2);

        let upstream = tracker.get_upstream(job2);
        assert_eq!(upstream, vec![job1]);

        let downstream = tracker.get_downstream(job1);
        assert_eq!(downstream, vec![job2]);
    }

    #[test]
    fn test_lineage_chain() {
        let tracker = LineageTracker::new();
        let job1 = Uuid::new_v4();
        let job2 = Uuid::new_v4();
        let job3 = Uuid::new_v4();

        tracker.record_dependency(job1, job2);
        tracker.record_dependency(job2, job3);

        let chains = tracker.get_full_lineage_chain(job3);
        assert!(!chains.is_empty());
        // Should find chain: job3 -> job2 -> job1
    }

    #[test]
    fn test_artifact_production_tracking() {
        let tracker = LineageTracker::new();
        let job_id = Uuid::new_v4();

        tracker.record_output(job_id, "s3://bucket/output");
        tracker.record_output(job_id, "s3://bucket/output2");

        let artifacts = tracker.get_artifacts_produced(job_id);
        assert_eq!(artifacts.len(), 2);
    }
}
