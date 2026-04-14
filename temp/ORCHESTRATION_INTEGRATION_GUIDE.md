# Production Orchestration: Integration & Implementation Guide

## Quick Start: Integrating Services with Production Orchestration

### Step 1: Update Database (One-Time)

```bash
# Apply migration 005
psql -U compute-service compute-database < migrations/005_orchestration_production_hardening.sql

# Verify tables exist
psql -c "
  SELECT table_name FROM information_schema.tables
  WHERE table_schema = 'public' AND table_name LIKE 'orchestration_%'
  ORDER BY table_name;
"
```

### Step 2: Initialize Go Service Components

In `services/compute-orchestration-service/internal/orchestration/`:

```go
package main

import (
	"context"
	"database/sql"
	"github.com/solar3d/orchestration"
)

func setupProduction(db *sql.DB) {
	// Initialize components
	idempotencyMgr := orchestration.NewIdempotencyManager(db)
	jobQueue := orchestration.NewPersistentJobQueue(db, 16) // 16 concurrent workers
	auditLog := orchestration.NewAuditLogger(db)
	lineageMgr := orchestration.NewLineageManager(db)

	// Start background recovery and cleanup
	ctx := context.Background()
	jobQueue.Start(ctx)

	// Register job handlers
	registerExecutors(jobQueue)
}

// Example: Register a computation executor
func registerExecutors(queue *orchestration.PersistentJobQueue) {
	// Simulation executor
	simulationExec := NewSimulationExecutor()
	registerExecutor("simulation", simulationExec, queue)

	// Optimization executor
	optimizationExec := NewOptimizationExecutor()
	registerExecutor("optimization", optimizationExec, queue)
}
```

### Step 3: Implement Idempotent Computation in Rust

Example: Simulation Service

```rust
use orchestration_compute::prelude::*;
use async_trait::async_trait;

pub struct SimulationExecutor {
    // fields...
}

#[async_trait]
impl IdempotentComputation for SimulationExecutor {
    fn name(&self) -> &'static str {
        "SimulationExecutor"
    }

    async fn execute(
        &self,
        context: &ComputationContext,
    ) -> OrchestrationResult<ComputationResult> {
        let start = std::time::Instant::now();

        // 1. Validate request fingerprint (determinism check)
        let fingerprint = context.request.fingerprint();
        tracing::info!(
            job_id = %context.job_id,
            trace_id = %context.trace_id,
            fingerprint = %fingerprint,
            "Starting idempotent computation"
        );

        // 2. Perform computation deterministically
        let result_payload = self.run_simulation(&context.request.payload)?;

        // 3. Store artifacts with full lineage
        if let Some(artifact_store) = context.get_artifact_store() {
            let artifact_data = serde_json::to_vec(&result_payload)?;
            let uri = artifact_store.store(
                context.job_id,
                "simulation_result.json",
                artifact_data.clone(),
            ).await?;

            // Track lineage
            context.lineage_tracker().record_output(context.job_id, &uri);
        }

        let elapsed_ms = start.elapsed().as_millis() as u64;

        Ok(ComputationResult {
            job_id: context.job_id,
            trace_id: context.trace_id,
            status: "SUCCESS".to_string(),
            output_payload: result_payload,
            artifacts: vec![], // Populated by caller
            execution_time_ms: elapsed_ms,
            started_at: Utc::now(),
            completed_at: Utc::now(),
        })
    }

    fn is_idempotent(&self) -> bool {
        true // Simulation with same inputs = same outputs
    }
}

impl SimulationExecutor {
    async fn run_simulation(
        &self,
        payload: &serde_json::Value,
    ) -> OrchestrationResult<serde_json::Value> {
        // Deterministic simulation logic
        // Use deterministic_seed for RNG if needed
        Ok(payload.clone()) // Simplified
    }
}
```

### Step 4: Update Service Handler

```go
// In compute-orchestration-service/internal/handler/submit_job.go

func (h *Handler) SubmitJob(ctx context.Context, req *pb.SubmitJobRequest) (*pb.SubmitJobResponse, error) {
	// 1. Extract idempotency key from request or generate
	idempotencyKey := req.GetIdempotencyKey()
	if idempotencyKey == "" {
		idempotencyKey = uuid.New().String()
	}

	// 2. Atomically check-or-create with serializability
	jobID, wasCreated, err := h.IdempotencyMgr.CheckOrCreate(
		ctx,
		req.GetProjectId(),
		idempotencyKey,
		ComputeRequestHash(req), // deterministic hash of full request
	)
	if err != nil {
		return nil, fmt.Errorf("idempotency check failed: %w", err)
	}

	if !wasCreated {
		// Job already exists, return existing state
		return &pb.SubmitJobResponse{
			JobId:   jobID.String(),
			Status:  "ALREADY_PROCESSING",
			Message: "This request was already submitted. Returning existing job.",
		}, nil
	}

	// 3. Queue newly created job
	payload, _ := json.Marshal(req.GetPayload())
	err = h.JobQueue.QueueJob(ctx, jobID, req.GetJobType(), payload)
	if err != nil {
		return nil, fmt.Errorf("failed to queue job: %w", err)
	}

	// 4. Audit the submission
	_ = h.AuditLog.LogAction(ctx, jobID, "SUBMITTED", req.GetActorId(), "USER", map[string]interface{}{
		"job_type": req.GetJobType(),
		"project_id": req.GetProjectId(),
	})

	return &pb.SubmitJobResponse{
		JobId:   jobID.String(),
		Status:  "QUEUED",
		Message: "Job submitted successfully",
	}, nil
}
```

### Step 5: Implement Job Processing Loop

```go
// In compute-orchestration-service/internal/service/job_processor.go

func (s *JobProcessorService) ProcessLoop(ctx context.Context) {
	for {
		select {
		case <-ctx.Done():
			return
		default:
		}

		// 1. Dequeue next job
		job, err := s.JobQueue.DequeueNext(ctx)
		if err != nil {
			tracing.Error("Failed to dequeue job", err)
			continue
		}
		if job == nil {
			// No jobs available, back off briefly
			time.Sleep(100 * time.Millisecond)
			continue
		}

		// 2. Execute with timeout
		executionCtx, cancel := context.WithTimeout(ctx, 1*time.Hour)
		err = s.executeJobWithRetry(executionCtx, job)
		cancel()

		// 3. Handle result
		if err != nil {
			// Classify error and decide on retry
			classification := s.classifyError(err)
			shouldRetry := isRetryable(classification) && job.Attempts < job.MaxAttempts

			if shouldRetry {
				backoff := time.Duration(2) * time.Duration(job.Attempts+1) * time.Second
				_ = s.JobQueue.ReturnToQueue(ctx, job.ID, backoff)
			} else {
				_ = s.JobQueue.MarkJobFailed(ctx, job.ID, err.Error(), classification)
			}
		} else {
			_ = s.JobQueue.MarkJobSucceeded(ctx, job.ID, []byte("{}"))
		}
	}
}

func (s *JobProcessorService) executeJobWithRetry(
	ctx context.Context,
	job *orchestration.JobWithState,
) error {
	// Call appropriate executor based on job type
	executor := s.GetExecutor(job.JobType)
	if executor == nil {
		return fmt.Errorf("unknown executor: %s", job.JobType)
	}

	// Create computation context
	request := &orchestration.ComputationRequest{
		JobId:              job.ID,
		IdempotencyToken:   job.IdempotencyToken, // Set from DB
		TraceId:            job.TraceId,           // Set from DB
		Payload:            job.PayloadJSON,
		TimeoutSeconds:     3600,
	}
	execCtx := orchestration.NewComputationContext(request)

	// Execute with automatic retries
	executor_wrapper := orchestration.NewComputationExecutor(executor)
	result, err := executor_wrapper.ExecuteWithRetries(execCtx)
	if err != nil {
		return err
	}

	// Record artifacts and lineage
	for _, artifact := range result.Artifacts {
		_ = s.LineageMgr.RecordArtifact(ctx, job.ID, artifact)
	}

	return nil
}
```

### Step 6: Connect to Existing Microservices

**For Simulation Service:**
```go
// In services/simulation-service/main.go

// Register to orchestration
func registerWithOrchestration(orchestrationURL string) {
	// SimulationExecutor becomes callable handler
	// Orchestration service can invoke via RPC or gRPC
}
```

**For Optimization Service:**
```go
// In services/optimization-service/main.go

// Similar registration pattern
```

### Step 7: Deploy and Verify

```bash
# 1. Build Rust orchestration-compute crate
cd compute
cargo build --release

# 2. Update Go service
cd services/compute-orchestration-service
go build -o orchestration-service

# 3. Run migrations
psql compute-database < migrations/005_orchestration_production_hardening.sql

# 4. Start service
./orchestration-service

# 5. Run validation tests
./scripts/validate-orchestration-production.sh
```

---

## Configuration Reference

### Environment Variables

```bash
# Database
ORCHESTRATION_DB_HOST=postgres.default
ORCHESTRATION_DB_PORT=5432
ORCHESTRATION_DB_NAME=compute-database
ORCHESTRATION_DB_USER=compute-service
ORCHESTRATION_DB_SSL_MODE=require

# Job Queue
ORCHESTRATION_MAX_CONCURRENT_JOBS=16
ORCHESTRATION_CLEANUP_INTERVAL=5m
ORCHESTRATION_RECOVERY_INTERVAL=1m

# Retries
ORCHESTRATION_MAX_RETRIES=3
ORCHESTRATION_RETRY_BACKOFF_BASE_MS=2000

# Timeouts
ORCHESTRATION_JOB_TIMEOUT_SECONDS=3600
ORCHESTRATION_EXECUTION_TIMEOUT_SECONDS=1800

# Metrics
ORCHESTRATION_METRICS_ENABLED=true
ORCHESTRATION_METRICS_PORT=9090

# Logging
ORCHESTRATION_LOG_LEVEL=info
ORCHESTRATION_LOG_FORMAT=json
```

### Database Connection Pool

```go
db, err := sql.Open("postgres", os.Getenv("ORCHESTRATION_DB_URL"))
if err != nil {
	panic(err)
}

// Configure for production
db.SetMaxOpenConns(50)
db.SetMaxIdleConns(10)
db.SetConnMaxLifetime(5 * time.Minute)
```

---

## Monitoring Integration

### Grafana Dashboard Query Examples

```
# Jobs by status (pie chart)
sum by (status) (orchestration_jobs_total)

# Job success rate (gauge)
(
  sum(rate(orchestration_jobs_total{status="SUCCEEDED"}[5m]))
  /
  sum(rate(orchestration_jobs_total[5m]))
) * 100

# Retry rate by executor (line chart)
sum by (executor) (rate(orchestration_retry_count_total[5m]))

# Artifact retention breakdown (stacked bar)
sum by (retention_policy) (orchestration_artifacts_bytes)

# Dead-letter age distribution (histogram)
orchestration_dead_letter_age_seconds_bucket
```

### Prometheus Scrape Config

```yaml
scrape_configs:
  - job_name: 'compute-orchestration'
    static_configs:
      - targets: ['localhost:9090']
    scrape_interval: 15s
    scrape_timeout: 5s
```

---

## Troubleshooting

### Issue: Jobs stuck in RETRY_PENDING

**Symptom:**
```
SELECT COUNT(*) FROM orchestration_jobs WHERE status = 'RETRY_PENDING';
-- Returns large number
```

**Solution:**
```bash
# Force recovery
psql -c "
  UPDATE orchestration_jobs 
  SET status = 'QUEUED'
  WHERE status = 'RETRY_PENDING' 
    AND next_retry_at < NOW() - INTERVAL '1 hour';
"
```

### Issue: Idempotency conflicts appearing

**Symptom:**
```sql
SELECT COUNT(DISTINCT job_id) FROM orchestration_idempotent_calls
WHERE project_id = 'xyz' AND idempotency_key = 'key-1';
-- Returns > 1 (should be at most 1)
```

**Solution:**
Check for concurrent request races. If found, restart service with connection pool optimization.

### Issue: Artifact cleanup not running

**Symptom:**
```
SELECT COUNT(*) FROM orchestration_job_artifacts
WHERE expires_at < NOW() AND deleted_at IS NULL AND archived_at IS NULL;
-- Returns > 0 (should be 0 if cleanup enabled)
```

**Solution:**
```bash
# Check cleanup routine logs
tail -f /var/log/orchestration/cleanup.log

# Manually trigger cleanup
psql -c "SELECT * FROM orchestration_cleanup_expired_artifacts();"
```

---

## Performance Tuning

### Optimal Index Coverage

```sql
-- Ensure these indexes exist and are used
ANALYZE;
EXPLAIN ANALYZE
  SELECT * FROM orchestration_jobs
  WHERE status IN ('QUEUED', 'RETRY_PENDING')
  ORDER BY priority DESC, created_at ASC
  LIMIT 10;
-- Should show "Index Scan" for idx_orch_jobs_project_status
```

### Connection Pool Tuning

```go
// For 16 concurrent workers + overhead
db.SetMaxOpenConns(32)
db.SetMaxIdleConns(8)

// Monitor pool exhaustion
monitoring.CounterVec("db_pool_exhausted_total").Inc()
```

### Query Performance Optimization

```sql
-- If dequeue query is slow, rebuild indexes
REINDEX INDEX idx_orch_jobs_project_status;
VACUUM ANALYZE orchestration_jobs;
VACUUM ANALYZE orchestration_job_queue;
```

---

## Migration Path from Old Orchestration

If you have existing jobs in the old system:

```sql
-- Export old jobs
SELECT * INTO orchestration_jobs_legacy FROM old_orchestration_jobs;

-- Transform and reimport into new schema
INSERT INTO orchestration_jobs (...)
SELECT 
  id,
  project_id,
  job_type,
  'QUEUED'::text,  -- Reset status for reprocessing
  priority,
  0,  -- Reset attempts
  3,  -- Default max_attempts
  NULL,  -- No old idempotency keys
  payload_json,
  created_at,
  NULL, NULL, NULL
FROM orchestration_jobs_legacy
WHERE status NOT IN ('SUCCEEDED', 'FAILED');

-- Verify counts match
SELECT COUNT(*) FROM orchestration_jobs WHERE status = 'QUEUED';
```

---

## Support & Escalation

- **Orchestration Framework Issues**: Check [GitHub Issues](https://github.com/solar3d/compute-orchestration)
- **Database Performance**: Run `ANALYZE` and check `pg_stat_statements`
- **Circuit Breaker Trips**: Check executor service health and error logs
- **Production Incident**: Follow [RUNBOOK.md](./RUNBOOK_ORCHESTRATION_INCIDENTS.md)
