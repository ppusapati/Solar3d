#!/bin/bash
# Production Orchestration: Quick Validation & Smoke Tests
# Run this after deployment to verify everything is working

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/orchestration-validation-$(date +%s).log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

pass() {
    echo -e "${GREEN}✓${NC} $*" | tee -a "$LOG_FILE"
    ((PASS++))
}

fail() {
    echo -e "${RED}✗${NC} $*" | tee -a "$LOG_FILE"
    ((FAIL++))
}

warn() {
    echo -e "${YELLOW}⚠${NC} $*" | tee -a "$LOG_FILE"
    ((WARN++))
}

header() {
    echo "" | tee -a "$LOG_FILE"
    echo "=== $* ===" | tee -a "$LOG_FILE"
}

# ============================================================================
# SECTION 1: Database Connectivity & Schema
# ============================================================================

header "1. Database Connectivity & Schema Check"

# Check if psql is available
if ! command -v psql &> /dev/null; then
    fail "psql not found in PATH"
    exit 1
fi
pass "psql available"

# Test database connection
if ! psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1" > /dev/null 2>&1; then
    fail "Cannot connect to database: $DB_NAME"
    exit 1
fi
pass "Database connection successful"

# Verify all required tables exist
TABLES=(
    "orchestration_jobs"
    "orchestration_job_queue"
    "orchestration_idempotent_calls"
    "orchestration_audit_log"
    "orchestration_executor_calls"
    "orchestration_data_lineage"
    "orchestration_job_dependencies"
    "orchestration_circuit_breaker_state"
    "orchestration_dead_letters"
    "orchestration_job_artifacts"
    "orchestration_job_attempts"
)

for table in "${TABLES[@]}"; do
    if psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1 FROM $table LIMIT 1" > /dev/null 2>&1; then
        pass "Table exists: $table"
    else
        fail "Table missing: $table"
    fi
done

# ============================================================================
# SECTION 2: Service Connectivity
# ============================================================================

header "2. Service Connectivity"

# Check orchestration service
if curl -s http://localhost:8080/health | jq . > /dev/null 2>&1; then
    pass "Orchestration service reachable"
else
    fail "Orchestration service unreachable at localhost:8080"
fi

# ============================================================================
# SECTION 3: Idempotency Test
# ============================================================================

header "3. Idempotency Test"

# Generate test data
TEST_PROJECT="test-$(date +%s)"
TEST_IDEM_KEY="test-idem-$(date +%s)"

# Submit first job
RESPONSE1=$(curl -s -X POST http://localhost:8080/api/v1/jobs/submit \
    -H "Content-Type: application/json" \
    -H "Idempotency-Key: $TEST_IDEM_KEY" \
    -d "{\"project_id\": \"$TEST_PROJECT\", \"job_type\": \"test\", \"payload\": {}}" \
    2>/dev/null || echo "{}")

JOB_ID1=$(echo "$RESPONSE1" | jq -r '.job_id // empty' 2>/dev/null || echo "")

if [ -z "$JOB_ID1" ]; then
    fail "Could not parse first job submission response"
else
    pass "First job submitted: $JOB_ID1"
fi

# Submit identical job (should be deduplicated)
RESPONSE2=$(curl -s -X POST http://localhost:8080/api/v1/jobs/submit \
    -H "Content-Type: application/json" \
    -H "Idempotency-Key: $TEST_IDEM_KEY" \
    -d "{\"project_id\": \"$TEST_PROJECT\", \"job_type\": \"test\", \"payload\": {}}" \
    2>/dev/null || echo "{}")

JOB_ID2=$(echo "$RESPONSE2" | jq -r '.job_id // empty' 2>/dev/null || echo "")

if [ -z "$JOB_ID2" ]; then
    fail "Could not parse second job submission response"
elif [ "$JOB_ID1" = "$JOB_ID2" ]; then
    pass "Idempotency working: duplicate key returned same job_id"
    
    # Check database state
    IDEM_COUNT=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
        SELECT COUNT(DISTINCT job_id) FROM orchestration_idempotent_calls
        WHERE project_id = '$TEST_PROJECT' AND idempotency_key = '$TEST_IDEM_KEY'
    " 2>/dev/null || echo "")
    
    if [ "$IDEM_COUNT" = "1" ]; then
        pass "Database state correct: 1 idempotency key for 2 submissions"
    else
        fail "Database state incorrect: expected 1, got $IDEM_COUNT"
    fi
else
    fail "Idempotency broken: duplicate key returned different job_ids ($JOB_ID1 vs $JOB_ID2)"
fi

# ============================================================================
# SECTION 4: Job Queue State
# ============================================================================

header "4. Job Queue State"

# Check queue depth
QUEUE_DEPTH=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
    SELECT COUNT(*) FROM orchestration_jobs
    WHERE status IN ('QUEUED', 'RETRY_PENDING', 'RUNNING')
" 2>/dev/null || echo "0")

log "Jobs in active state: $QUEUE_DEPTH"
if [ "$QUEUE_DEPTH" -gt 0 ]; then
    pass "Jobs detected in queue"
else
    warn "No jobs currently in active state (may be normal if just started)"
fi

# Check for stuck RUNNING jobs
STUCK_RUNNING=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
    SELECT COUNT(*) FROM orchestration_jobs
    WHERE status = 'RUNNING' AND started_at < NOW() - INTERVAL '1 hour'
" 2>/dev/null || echo "0")

if [ "$STUCK_RUNNING" -gt 0 ]; then
    fail "Found $STUCK_RUNNING jobs stuck in RUNNING state > 1 hour"
else
    pass "No jobs stuck in RUNNING state"
fi

# ============================================================================
# SECTION 5: Audit Logging
# ============================================================================

header "5. Audit Logging"

# Check if audit logs exist for recent jobs
AUDIT_COUNT=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
    SELECT COUNT(*) FROM orchestration_audit_log
    WHERE created_at > NOW() - INTERVAL '1 hour'
" 2>/dev/null || echo "0")

if [ "$AUDIT_COUNT" -gt 0 ]; then
    pass "Audit logs being recorded ($AUDIT_COUNT entries in last hour)"
else
    warn "No audit logs found in last hour (may be normal if quiet)"
fi

# ============================================================================
# SECTION 6: Dead-Letter Queue
# ============================================================================

header "6. Dead-Letter Queue"

# Check dead-letter count
DEAD_LETTER_COUNT=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
    SELECT COUNT(*) FROM orchestration_dead_letters
    WHERE created_at > NOW() - INTERVAL '24 hours'
" 2>/dev/null || echo "0")

log "Dead-lettered jobs (24h): $DEAD_LETTER_COUNT"
if [ "$DEAD_LETTER_COUNT" -lt 5 ]; then
    pass "Dead-letter rate nominal"
else
    warn "Elevated dead-letter count: $DEAD_LETTER_COUNT in last 24 hours"
fi

# ============================================================================
# SECTION 7: Artifact Lifecycle
# ============================================================================

header "7. Artifact Lifecycle"

# Check artifact count
ARTIFACT_COUNT=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
    SELECT COUNT(*) FROM orchestration_job_artifacts
" 2>/dev/null || echo "0")

log "Total artifacts in system: $ARTIFACT_COUNT"

# Check for expired artifacts pending cleanup
EXPIRED_COUNT=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
    SELECT COUNT(*) FROM orchestration_job_artifacts
    WHERE expires_at IS NOT NULL
      AND expires_at < NOW()
      AND deleted_at IS NULL
      AND archived_at IS NULL
" 2>/dev/null || echo "0")

if [ "$EXPIRED_COUNT" -eq 0 ]; then
    pass "No expired artifacts pending cleanup"
else
    warn "Found $EXPIRED_COUNT expired artifacts pending cleanup"
fi

# ============================================================================
# SECTION 8: Lineage Integrity
# ============================================================================

header "8. Lineage Integrity"

# Check for cycles
CYCLES=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c "
    WITH RECURSIVE cycle_finder AS (
        SELECT parent_job_id as parent, child_job_id as child, 
               ARRAY[parent_job_id, child_job_id] as path
        FROM orchestration_job_dependencies
        UNION ALL
        SELECT cf.parent, df.child_job_id, path || df.child_job_id
        FROM orchestration_job_dependencies df
        JOIN cycle_finder cf ON df.parent_job_id = cf.child
        WHERE NOT df.child_job_id = ANY(path) AND ARRAY_LENGTH(path, 1) < 10
    )
    SELECT COUNT(*) FROM cycle_finder
    WHERE parent = ANY(path[2:])
" 2>/dev/null || echo "0")

if [ "$CYCLES" -eq 0 ]; then
    pass "No lineage cycles detected"
else
    fail "Found $CYCLES lineage cycles"
fi

# ============================================================================
# SECTION 9: Cleanup Procedures
# ============================================================================

header "9. Cleanup Procedures"

# Check if cleanup procedures exist
for proc in "orchestration_expire_idempotency_keys" \
            "orchestration_cleanup_expired_artifacts" \
            "orchestration_cleanup_dead_letters" \
            "orchestration_recover_stale_jobs"; do
    if psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1 FROM pg_proc WHERE proname = '$proc'" > /dev/null 2>&1; then
        pass "Cleanup procedure exists: $proc"
    else
        fail "Cleanup procedure missing: $proc"
    fi
done

# ============================================================================
# SECTION 10: Monitoring Views
# ============================================================================

header "10. Monitoring Views"

# Check if monitoring views exist
for view in "orchestration_job_metrics" "orchestration_lineage_chain"; do
    if psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1 FROM $view LIMIT 1" > /dev/null 2>&1; then
        pass "Monitoring view exists: $view"
    else
        fail "Monitoring view missing: $view"
    fi
done

# ============================================================================
# SECTION 11: Performance Baselines
# ============================================================================

header "11. Performance Baselines"

# Dequeue performance (measure)
START=$(date +%s%N)
psql -U "$DB_USER" -d "$DB_NAME" -q -c "
    SELECT * FROM orchestration_jobs
    WHERE status IN ('QUEUED', 'RETRY_PENDING')
    ORDER BY priority DESC, created_at ASC
    LIMIT 1
" > /dev/null 2>&1
END=$(date +%s%N)
NANOS=$((END - START))
MILLIS=$((NANOS / 1000000))

log "Query latency: ${MILLIS}ms"
if [ "$MILLIS" -lt 50 ]; then
    pass "Query performance good (${MILLIS}ms)"
else
    warn "Query performance slow (${MILLIS}ms), may need index rebuild"
fi

# ============================================================================
# SECTION 12: Integration Readiness
# ============================================================================

header "12. Integration Readiness"

# Check Rust crate built
if [ -d "./compute/orchestration-compute/target/release" ]; then
    pass "Rust orchestration-compute built"
else
    warn "Rust crate not built. Run: cd compute && cargo build --release"
fi

# Check Go service built
if [ -f "./services/compute-orchestration-service/orchestration-service" ]; then
    pass "Go orchestration service binary exists"
else
    warn "Go service binary not found"
fi

# ============================================================================
# Summary
# ============================================================================

echo "" | tee -a "$LOG_FILE"
echo "================================" | tee -a "$LOG_FILE"
echo "VALIDATION SUMMARY" | tee -a "$LOG_FILE"
echo "================================" | tee -a "$LOG_FILE"
echo -e "${GREEN}✓ PASS: $PASS${NC}" | tee -a "$LOG_FILE"
if [ "$FAIL" -gt 0 ]; then
    echo -e "${RED}✗ FAIL: $FAIL${NC}" | tee -a "$LOG_FILE"
fi
if [ "$WARN" -gt 0 ]; then
    echo -e "${YELLOW}⚠ WARN: $WARN${NC}" | tee -a "$LOG_FILE"
fi
echo "" | tee -a "$LOG_FILE"
echo "Log saved to: $LOG_FILE" | tee -a "$LOG_FILE"

if [ "$FAIL" -gt 0 ]; then
    echo "" | tee -a "$LOG_FILE"
    echo "CRITICAL FAILURES DETECTED. DO NOT PROCEED TO PRODUCTION." | tee -a "$LOG_FILE"
    exit 1
else
    echo "" | tee -a "$LOG_FILE"
    echo "✓ System ready for production!" | tee -a "$LOG_FILE"
    exit 0
fi
