# Orchestration Incident Response Runbook

## Emergency Contacts

| Role | Contact | Escalation |
|------|---------|-----------|
| Primary On-Call | Page via PagerDuty | Slack #orchestration-oncall |
| Secondary | Backup Engineer | Manager + Tech Lead |
| Escalation | Platform Lead | VP Engineering |

---

## Incident Classification

| Severity | SLO | Response | Examples |
|----------|-----|----------|----------|
| **SEV0** | 5min | Page all hands | All jobs stuck (deadlock), data corruption |
| **SEV1** | 15min | Page oncall | 50%+ job failure rate, complete executor down |
| **SEV2** | 1hour | Create ticket | Elevated failure rate, artifact cleanup failing |
| **SEV3** | Next business day | Slack thread | Single job failure, idempotency edge case |

---

## Common Incidents & Resolution

### INC-001: Jobs Stuck in QUEUED (No Progress)

**Symptoms:**
```
- Queue length increasing indefinitely
- No jobs transitioning to RUNNING
- Alert: orchestration_queue_depth > 1000 for 5min
```

**Immediate Actions:**
```bash
# 1. Check if service is running
ps aux | grep orchestration-service
# If not: systemctl start compute-orchestration-service

# 2. Check database connectivity
psql -U compute-service -c "SELECT 1;"
# If fails: Check network, firewall, DB credentials

# 3. Inspect queue state
psql -c "
  SELECT status, COUNT(*) FROM orchestration_jobs
  GROUP BY status;
"

# 4. Check for processing locks
psql -c "
  SELECT * FROM pg_locks
  WHERE relation::regclass::text LIKE '%orchestration%';
"
```

**Root Cause Analysis:**
```bash
# Check recent errors
tail -100 /var/log/orchestration/service.log | grep -i error

# Monitor active queries
psql -c "
  SELECT pid, query, query_start
  FROM pg_stat_activity
  WHERE query LIKE '%orchestration%' AND query_start < NOW() - INTERVAL '1 minute';
"

# If stuck query found, kill it cautiously
SELECT pg_terminate_backend(pid);
```

**Resolution:**
- If queue size growing: Increase worker count or add nodes
- If database slow: Run `VACUUM ANALYZE` on orchestration tables
- If stuck transaction: Force service restart → automatic recovery

---

### INC-002: Dead-Letter Accumulation (High Failure Rate)

**Symptoms:**
```
- Alert: dead_letters_per_min{} > 10
- Alert: orchestration_jobs_total{status="DEAD_LETTERED"} increasing
- Customer reports: "My jobs keep failing"
```

**Immediate Actions:**
```bash
# 1. Assess scale
psql -c "
  SELECT classification, COUNT(*) as count
  FROM orchestration_dead_letters
  WHERE created_at > NOW() - INTERVAL '1 hour'
  GROUP BY classification
  ORDER BY count DESC;
"

# 2. Check recent failures
psql -c "
  SELECT job_id, reason, created_at
  FROM orchestration_dead_letters
  WHERE created_at > NOW() - INTERVAL '5 minutes'
  LIMIT 20;
"

# 3. Check if executor service is healthy
curl -s http://simulation-service:8080/health | jq .
curl -s http://optimization-service:8080/health | jq .
```

**Root Cause Analysis:**
```bash
# If classified as EXEC_ERROR
# → Executor service crash or misconfiguration
# Action: Restart executor, check logs

# If classified as TIMEOUT
# → Jobs too complex or service under CPU pressure
# Action: Check resource utilization, increase timeout or parallelize

# If classified as DATA_ERROR
# → Malformed input payloads
# Action: Review recent request patterns, find bad submitter

# Get sample job to reproduce
psql -c "
  SELECT job_id, payload_json FROM orchestration_jobs
  WHERE id IN (SELECT job_id FROM orchestration_dead_letters 
               WHERE created_at > NOW() - INTERVAL '5 minutes'
               LIMIT 1);
" | jq . > /tmp/dead_job.json

# Manual retry (if safe)
curl -X POST http://orchestration:8080/api/v1/jobs/retry \
  -d @/tmp/dead_job.json
```

**Resolution:**
- Fix underlying executor or input validation
- Move stuck jobs to retry queue: `UPDATE orchestration_jobs SET status='QUEUED' WHERE status='DEAD_LETTERED' AND <issue_fixed>`
- Alert customer if data loss occurred

---

### INC-003: Artifact Cleanup Failing (Disk Space)

**Symptoms:**
```
- Alert: orchestration_artifacts_bytes > 500GB
- Alert: Storage /var/lib/artifacts 95% full
- No new artifacts can be written
```

**Immediate Actions:**
```bash
# 1. Trigger emergency cleanup
SELECT * FROM orchestration_cleanup_expired_artifacts();
# Result: (deleted_count INT, freed_bytes BIGINT)

# 2. Check artifact store disk usage
df -h /var/lib/artifacts

# 3. Query expired but not cleaned artifact
psql -c "
  SELECT artifact_key, size_bytes, expires_at
  FROM orchestration_job_artifacts
  WHERE expires_at < NOW() AND deleted_at IS NULL
  ORDER BY size_bytes DESC
  LIMIT 20;
"
```

**Root Cause Analysis:**
```bash
# 1. Is cleanup job running?
systemctl status orchestration-cleanup-timer
# If inactive: systemctl enable orchestration-cleanup-timer

# 2. Are there permission issues?
ls -la /var/lib/artifacts/
# Should be writable by postgres user

# 3. Check for orphaned artifacts (not in DB but on disk)
find /var/lib/artifacts -type f -mtime +7 -ls | wc -l
```

**Resolution:**
- Re-enable cleanup if disabled
- Fix permission issues if found
- Manual cleanup if urgent: `rm /var/lib/artifacts/*.{old,expired}`
- Add more disk capacity for future load

---

### INC-004: Idempotency Key Hash Collisions

**Symptoms:**
```
- Alert: idempotency_key_collisions_total > 0
- Applications report: "Got same result for different requests"
```

**Immediate Actions:**
```bash
# 1. Analyze collision
psql -c "
  SELECT idempotency_key, COUNT(DISTINCT job_id) as job_count
  FROM orchestration_idempotent_calls
  GROUP BY idempotency_key
  HAVING COUNT(DISTINCT job_id) > 1;
"

# 2. Fetch colliding jobs
psql -c "
  SELECT job_id, request_hash, response_payload
  FROM orchestration_idempotent_calls
  WHERE idempotency_key = '<COLLIDING_KEY>'
  ORDER BY created_at;
"

# 3. Compare request hashes
# If hashes identical → Determinism issue in request hashing
# If hashes different → Hash algorithm collision (very rare)
```

**Root Cause Analysis:**
```bash
# Check hash implementation
grep -n "ComputeRequestHash" services/compute-orchestration-service/internal/handler/*.go

# Verify non-deterministic fields aren't included
# (timestamps, UUIDs without @hash tag, etc.)
```

**Resolution:**
- Fix hash computation to exclude non-deterministic fields
- Invalidate affected idempotency keys
- Re-submit clients manually
- Add test case to prevent regression

---

### INC-005: Service Restart During High Load (Recovery)

**Symptoms:**
```
- Service crashes or is redeployed mid-job execution
- Recovery takes longer than expected
- Some jobs appear to be restarted even though they succeeded
```

**Immediate Actions:**
```bash
# 1. Monitor recovery progress
tail -f /var/log/orchestration/recovery.log

# 2. Check jobs recovered from RUNNING state
psql -c "
  SELECT status, COUNT(*) FROM orchestration_jobs
  WHERE status IN ('RUNNING', 'RETRY_PENDING', 'QUEUED')
  GROUP BY status;
"

# 3. Verify no duplicate executions
psql -c "
  SELECT job_id, COUNT(*) as attempt_count
  FROM orchestration_job_attempts
  WHERE status = 'SUCCEEDED'
  GROUP BY job_id
  HAVING COUNT(*) > 1;
"
```

**Root Cause Analysis:**
```bash
# Check for orphaned locks or zombie processes
ps aux | grep orchestration
# If zombies exist: kill them

# Check if recovery procedure completed
psql -c "
  SELECT created_at, category, message FROM orchestration_recovery_log
  ORDER BY created_at DESC
  LIMIT 50;
"
```

**Resolution:**
- Recovery is automatic; just verify completion
- If jobs were duplicated, manually reconcile results
- Consider graceful shutdown hooks for future deployments

---

### INC-006: Circuit Breaker Open (Executor Unavailable)

**Symptoms:**
```
- Alert: circuit_breaker_state{executor="SimulationExecutor"} == OPEN
- All simulation jobs start failing
- But executor service logs show no errors
```

**Immediate Actions:**
```bash
# 1. Check circuit breaker state
psql -c "
  SELECT executor_name, state, failure_count, open_until
  FROM orchestration_circuit_breaker_state
  WHERE state != 'CLOSED';
"

# 2. Verify executor is actually healthy
curl -s http://simulation-service:8080/health | jq .
# If response is 200 OK → Executor is healthy

# 3. Force circuit breaker reset
psql -c "
  UPDATE orchestration_circuit_breaker_state
  SET state = 'HALF_OPEN', failure_count = 0
  WHERE executor_name = 'SimulationExecutor';
"

# 4. Retry failed jobs
# OR wait for circuit breaker to auto-recover (check timeout)
```

**Root Cause Analysis:**
```bash
# Check recent failures
psql -c "
  SELECT executor_name, COUNT(*) FROM orchestration_executor_calls
  WHERE status = 'FAILED' AND created_at > NOW() - INTERVAL '10 minutes'
  GROUP BY executor_name;
"

# If no recent failures, circuit breaker may have stale state
# Check if executor responded to last request
curl -v http://simulation-service:8080/compute -d '{}' 2>&1 | head -20
```

**Resolution:**
- Reset circuit breaker after fixing executor
- Implement exponential backoff before forcing reset
- Consider increasing failure threshold if false-positive

---

### INC-007: Lineage Corruption (Cycle Detected)

**Symptoms:**
```
- Error in logs: "LineageBroken: Circular dependency detected"
- Alert: orchestration_lineage_violations > 0
```

**Immediate Actions:**
```bash
# 1. Find the cycle
psql -c "
  WITH RECURSIVE cycle_finder AS (
    SELECT parent_id, child_id, ARRAY[parent_id, child_id] as path
    FROM orchestration_job_dependencies
    UNION ALL
    SELECT df.parent_id, df.child_id, path || df.child_id
    FROM orchestration_job_dependencies df
    JOIN cycle_finder cf ON df.parent_id = cf.child_id
    WHERE NOT df.child_id = ANY(path)
      AND ARRAY_LENGTH(path, 1) < 10  -- Prevent infinite recursion
  )
  SELECT path FROM cycle_finder
  WHERE path[1] = ANY(path[2:]);
"

# 2. Identify the bad dependency
# (Usually the most recent one in the cycle)
psql -c "
  SELECT parent_job_id, child_job_id, created_at
  FROM orchestration_job_dependencies
  WHERE (parent_job_id, child_job_id) IN (
    -- Results from query above
  )
  ORDER BY created_at DESC;
"
```

**Root Cause Analysis:**
```bash
# Check if this was user error or application bug
SELECT job_type, actor_id FROM orchestration_audit_log
WHERE job_id IN (<jobs_in_cycle>)
AND action = 'DEPENDENCY_ADDED'
ORDER BY timestamp;
```

**Resolution:**
- Delete the offending dependency (usually the latest one)
- Audit-log the remediation
- Implement DAG validator in application before recording deps

---

## Operational Procedures

### Weekly: Backup Verification

```bash
#!/bin/bash
# Weekly backup check

DATE=$(date +%Y-%m-%d)
BACKUP_FILE="/backups/orchestration-$DATE.sql.gz"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "FAIL: Backup file $BACKUP_FILE missing"
  exit 1
fi

# Verify backup integrity
gunzip -t "$BACKUP_FILE"
if [ $? -ne 0 ]; then
  echo "FAIL: Backup corrupted"
  exit 1
fi

echo "PASS: Backup verified"
```

### Monthly: Idempotency Window Cleanup

```bash
# This runs automatically, but manually verify:
SELECT COUNT(*) FROM orchestration_idempotent_calls;
# Then run:
SELECT * FROM orchestration_expire_idempotency_keys();
# Verify count decreased
```

### Quarterly: Performance Reindex

```bash
# Reindex hot tables
REINDEX INDEX idx_orch_jobs_project_status;
REINDEX INDEX idx_orch_queue_type_available;
REINDEX INDEX idx_orch_audit_job_id;

# Full vacuum
VACUUM ANALYZE orchestration_jobs;
VACUUM ANALYZE orchestration_job_queue;
VACUUM ANALYZE orchestration_audit_log;

# Check index sizes
SELECT schemaname, tablename, indexname,
       pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_indexes
WHERE schemaname = 'public' AND tablename LIKE 'orchestration_%'
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Annual: Disaster Recovery Drill

```bash
# 1. Create test database
createdb orchestration-test

# 2. Restore latest backup
gunzip < /backups/orchestration-latest.sql.gz | psql orchestration-test

# 3. Verify data integrity
psql orchestration-test -c "
  SELECT 
    (SELECT COUNT(*) FROM orchestration_jobs) as job_count,
    (SELECT COUNT(*) FROM orchestration_audit_log) as audit_count,
    (SELECT COUNT(*) FROM orchestration_dead_letters) as dead_letters;
"

# 4. Run consistency checks
./scripts/validate-orchestration-consistency.sh orchestration-test

# 5. Clean up
dropdb orchestration-test
```

---

## Post-Incident Review Template

```markdown
# PIR: [Incident Title]

## Incident Summary
- **Date & Time**: [YYYY-MM-DD HH:MM UTC]
- **Duration**: [Minutes]
- **Severity**: [SEV0-3]
- **Affected Services**: [...]
- **Customer Impact**: [Brief description]

## Timeline
- **HH:MM UTC**: Alert firing
- **HH:MM UTC**: Incident started
- **HH:MM UTC**: Mitigation applied
- **HH:MM UTC**: Service restored
- **HH:MM UTC**: Root cause identified

## Root Cause
[Detailed technical analysis]

## Impact Assessment
- [ ] Data loss
- [ ] Duplicated executions
- [ ] Customer-visible downtime
- [ ] Hidden bugs introduced

## Remediation
- [ ] Immediate fix deployed
- [ ] Monitoring improved
- [ ] SOP updated
- [ ] Follow-up ticket filed

## Prevention
[How do we prevent this in future?]

## Action Items
- [ ] ...
- [ ] ...
```

---

## Escalation Matrix

```
Severity 0 (All Hands):
├─ Page everyone in #orchestration-oncall
├─ Create war room (Zoom)
├─ Establish incident commander
└─ Post updates every 5 minutes to Slack

Severity 1 (Critical):
├─ Page on-call engineer
├─ Notify team lead
├─ Create Slack thread
└─ Updates every 10 minutes

Severity 2 (Major):
├─ Create ticket in Jira
├─ Post to #orchestration-incidents
└─ Include in next team sync

Severity 3 (Minor):
├─ Add to backlog
└─ Include in next retro
```

---

## Support Channels

- **Slack**: #orchestration-incidents, #orchestration-oncall
- **PagerDuty**: [Escalation Policy URL]
- **Documentation**: [Wiki URL]
- **GitHub Issues**: [Repo URL]
