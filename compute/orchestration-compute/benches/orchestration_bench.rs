use criterion::{black_box, criterion_group, criterion_main, Criterion, BenchmarkId};
use orchestration_compute::{
    JobLifecycle, JobStatus, ComputationRequest, IdempotentComputation,
    ComputationContext, ArtifactLifecycle, RetentionPolicy,
};
use std::sync::Arc;

fn bench_job_lifecycle_transitions(c: &mut Criterion) {
    let mut group = c.benchmark_group("job_lifecycle");
    
    group.bench_function("create_job", |b| {
        b.iter(|| {
            let _job = JobLifecycle::new(
                black_box("job_id_123".to_string()),
                black_box("project_42".to_string()),
            );
        });
    });
    
    group.bench_function("transition_to_running", |b| {
        let mut job = JobLifecycle::new("job_id".to_string(), "project".to_string());
        
        b.iter(|| {
            let mut j = job.clone();
            let _ = j.transition_to_running(black_box(1));
        });
    });
    
    group.bench_function("transition_to_succeeded", |b| {
        let mut job = JobLifecycle::new("job_id".to_string(), "project".to_string());
        let _ = job.transition_to_running(1);
        
        b.iter(|| {
            let mut j = job.clone();
            let _ = j.transition_to_succeeded(black_box(Some("output".to_string())));
        });
    });
    
    group.finish();
}

fn bench_computation_context(c: &mut Criterion) {
    let mut group = c.benchmark_group("computation_context");
    
    group.bench_function("create_context", |b| {
        b.iter(|| {
            let _ctx = ComputationContext::new(
                black_box("job_id_123".to_string()),
                black_box("project_42".to_string()),
            );
        });
    });
    
    group.bench_function("record_artifact", |b| {
        let mut ctx = ComputationContext::new("job_id".to_string(), "project".to_string());
        let artifact_path = "s3://bucket/artifact.dat".to_string();
        
        b.iter(|| {
            ctx.record_artifact(
                black_box(artifact_path.clone()),
                black_box(RetentionPolicy::Retained),
            );
        });
    });
    
    group.finish();
}

fn bench_computation_request_fingerprint(c: &mut Criterion) {
    let mut group = c.benchmark_group("computation_request");
    
    for size in [100, 1000, 10000].iter() {
        group.bench_with_input(BenchmarkId::new("compute_fingerprint", size), size, |b, &size| {
            let mut request = ComputationRequest::new(
                "job_id".to_string(),
                "project".to_string(),
            );
            
            // Add variable-sized attributes
            for i in 0..size {
                request = request.with_attribute(
                    format!("attr_{}", i),
                    format!("value_{}", i),
                );
            }
            
            b.iter(|| {
                black_box(request.compute_fingerprint())
            });
        });
    }
    
    group.finish();
}

fn bench_artifact_lifecycle(c: &mut Criterion) {
    let mut group = c.benchmark_group("artifact_lifecycle");
    
    group.bench_function("create_lifecycle", |b| {
        b.iter(|| {
            let _lifecycle = ArtifactLifecycle::new(black_box(RetentionPolicy::AutoDelete(7 * 24 * 60 * 60)));
        });
    });
    
    group.bench_function("is_expired_check", |b| {
        let lifecycle = ArtifactLifecycle::new(RetentionPolicy::AutoDelete(60)); // 60s expiry
        
        b.iter(|| {
            black_box(lifecycle.is_expired())
        });
    });
    
    group.finish();
}

fn bench_retry_backoff_calculation(c: &mut Criterion) {
    let mut group = c.benchmark_group("retry_backoff");
    
    for attempt in [1, 5, 10].iter() {
        group.bench_with_input(BenchmarkId::new("calculate_backoff", attempt), attempt, |b, &attempt| {
            b.iter(|| {
                let mut job = JobLifecycle::new("job_id".to_string(), "project".to_string());
                for _ in 0..*attempt {
                    let _ = job.transition_to_running(*attempt);
                }
                job.should_retry()
            });
        });
    }
    
    group.finish();
}

criterion_group!(
    benches,
    bench_job_lifecycle_transitions,
    bench_computation_context,
    bench_computation_request_fingerprint,
    bench_artifact_lifecycle,
    bench_retry_backoff_calculation
);
criterion_main!(benches);
