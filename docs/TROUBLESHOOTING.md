# Solar3D CAD Backbone — Troubleshooting Guide

Use this guide to diagnose and recover from common failures in
`drawing-revision-service`, `cad-core-service`, and `api-gateway-service`.

See also:
- [API Reference](API_REFERENCE.md) — full error code table
- [Deployment Runbook](DEPLOYMENT_RUNBOOK.md) — rollback and scaling procedures

---

## Table of Contents

1. [Error Code Reference](#error-code-reference)
2. [Common Client Errors (4xx)](#common-client-errors-4xx)
3. [Service Errors (5xx)](#service-errors-5xx)
4. [Deployment Issues](#deployment-issues)
5. [Database Issues](#database-issues)
6. [Performance Issues](#performance-issues)
7. [Inter-Service Communication Failures](#inter-service-communication-failures)
8. [Data Consistency Issues](#data-consistency-issues)
9. [Log Reference](#log-reference)

---

## Error Code Reference

### ConnectRPC error codes (drawing-revision-service, cad-core-service)

| Code | HTTP | Meaning | Root Cause |
|------|------|---------|------------|
| `invalid_argument` | 400 | Field validation failed | Missing required field, non-UUID where UUID expected, empty string for required param, invalid JSON in `metadata_json` |
| `not_found` | 404 | Resource does not exist | `drawing_id` or `revision_id` never existed, or the drawing was permanently deleted |
| `already_exists` | 409 | Duplicate command ID | `command_id` was already recorded for this drawing — this is the **idempotency guard triggering** (treat as success if intentional retry) |
| `failed_precondition` | 409 | Stale base revision | `base_revision_id` is no longer the head; another command was committed concurrently — client must re-fetch `GetDrawingState` and retry |
| `internal` | 500 | Unexpected server error | DB unreachable, serialisation error, or unhandled panic — check service logs |

### REST gateway error codes (api-gateway-service)

| HTTP | Meaning | Root Cause |
|------|---------|------------|
| 400 | Bad request | Malformed JSON body, non-UUID in path, missing required JSON field |
| 404 | Not found | Drawing or project not found |
| 409 | Conflict | Stale revision (`failed_precondition` from cad-core) or duplicate command (`already_exists`) |
| 502 | Bad gateway | A downstream service (project-service, drawing-revision-service, cad-core-service) returned an error or timed out |
| 500 | Internal error | Unexpected gateway-level panic or serialisation failure |

---

## Common Client Errors (4xx)

### `invalid_argument` — "drawing_id is required" / "not a valid UUID"

**Cause**: The field was omitted or is not a valid UUID v4.

**Fix**: Ensure all ID fields are lowercase UUID v4 strings (e.g. `"a1b2c3d4-e5f6-7890-abcd-ef1234567890"`).

---

### `invalid_argument` — "author is required"

**Cause**: The `author` field is empty or whitespace-only.

**Fix**: Pass a non-empty string (user email or display name).

---

### `not_found` — drawing / revision

**Cause**: The ID was never created, was created in a different environment, or refers to a deleted resource.

**Diagnosis**:
```bash
# Check the DB directly
psql "$DATABASE_URL" -c "SELECT id, name, status FROM drawings WHERE id = '<drawing_id>';"
```

**Fix**: Verify the correct environment is being targeted. If the resource genuinely doesn't exist, create it.

---

### `already_exists` — duplicate command_id (idempotency)

**Cause**: The client retried the same `command_id` for a drawing where it was already successfully committed.

**Handling**: This is the **expected idempotency behaviour**. The safe response for clients is:
1. Receive `already_exists`
2. Call `GetDrawingState` to retrieve the up-to-date revision
3. Continue without error

**Do not** generate a new `command_id` on retry — that bypasses the idempotency guard.

---

### `failed_precondition` — stale `base_revision_id`

**Cause**: Between the client reading `GetDrawingState` and sending `CommitDrawingCommand`, another user committed a revision, advancing the drawing head.

**Fix (optimistic locking retry)**:
1. Call `GetDrawingState` to get the current head revision ID
2. Re-apply the mutations on the new entity set
3. Retry `CommitDrawingCommand` with the new `base_revision_id`

If conflicts are frequent, consider adding a UI "resolve conflicts" flow.

---

## Service Errors (5xx)

### `internal` — drawing-revision-service

**Likely causes (check logs)**:

| Log message pattern | Diagnosis |
|--------------------|-----------|
| `begin create drawing tx` | DB connection failure at transaction start |
| `insert drawing` | Unique constraint violation (rare; would be `already_exists`) or DB error |
| `commit create drawing tx` | Transient DB serialisation error — safe to retry |
| `lock drawing` | Row lock timeout or deadlock — check concurrent writes to the same drawing |
| `insert drawing revision` | Snapshot serialisation failure or DB error |
| `scan drawing` | DB schema mismatch — check migration state |

**Quick diagnosis**:
```bash
POD=$(kubectl get pods -n solar3d -l app=drawing-revision-service \
  -o jsonpath='{.items[0].metadata.name}')
kubectl logs "$POD" -n solar3d --tail=100
```

---

### `internal` — cad-core-service

| Log message pattern | Diagnosis |
|--------------------|-----------|
| `GetDrawingState` error | Cannot reach drawing-revision-service or drawing not found |
| `CommitDrawingCommand` error | drawing-revision-service returned an error — check its logs |
| `validate` panic | Should not occur; file a bug if seen |

---

### 502 — api-gateway-service

The gateway received an error response or timed out calling a downstream service.

**Diagnosis**:
- Check `downstream` field in `GET /healthz` response
- Check logs: `{"level":"error","downstream":"drawing-revision-service","error":"..."}`

```bash
curl -s http://localhost:8090/healthz | jq .downstream
```

---

## Deployment Issues

### Pod stuck in `CrashLoopBackOff`

```bash
# Get pod name
kubectl get pods -n solar3d -l app=drawing-revision-service

# Check logs from the crashed container
kubectl logs <pod-name> -n solar3d --previous
```

**Common causes**:

| Log output | Fix |
|------------|-----|
| `failed to ping database` | Database is unreachable. Verify `DATABASE_URL` secret and DB firewall rules. |
| `invalid DATABASE_URL` | DSN is malformed. Recreate the `postgres-credentials` secret with a valid DSN. |
| `failed to load configuration` | Required env var is missing. Check the Deployment manifest. |

---

### Rollout stuck (pods not becoming Ready)

```bash
# Describe the deployment for events
kubectl describe deployment drawing-revision-service -n solar3d

# Describe a non-ready pod
kubectl describe pod <pod-name> -n solar3d
```

**Common causes**:

| Symptom | Diagnosis | Fix |
|---------|-----------|-----|
| `Readiness probe failed: HTTP probe failed with statuscode: 503` | Service started but `/healthz` returning 503 (DB unreachable) | Check DB connectivity (see below) |
| `ImagePullBackOff` | Image tag does not exist in registry | Push the correct image tag |
| `OOMKilled` | Pod exceeded memory limit | Increase `resources.limits.memory` in the manifest |
| `Pending` (no scheduling) | Insufficient cluster capacity | Scale the cluster or reduce resource requests |

---

### PodDisruptionBudget blocks rolling update

```bash
kubectl get pdb -n solar3d
kubectl describe pdb drawing-revision-service -n solar3d
```

If `minAvailable: 1` is blocking a rollout because only 1 pod exists, scale up first:
```bash
kubectl scale deployment/drawing-revision-service --replicas=2 -n solar3d
```

---

## Database Issues

### Cannot connect to PostgreSQL

```bash
# Test DNS resolution from inside the cluster
kubectl run dns-test --rm -it --image=busybox --restart=Never -n solar3d \
  -- nslookup postgres-service

# Test TCP connectivity
kubectl run tcp-test --rm -it --image=busybox --restart=Never -n solar3d \
  -- nc -zv postgres-host 5432
```

**Check the secret**:
```bash
kubectl get secret postgres-credentials -n solar3d -o jsonpath='{.data.connection-string}' | base64 -d
```

---

### Migration fails — table already exists

All migrations use `CREATE TABLE IF NOT EXISTS` and `CREATE INDEX IF NOT EXISTS`.
They are safe to re-run. If a migration fails mid-way:

1. Check exactly which statement failed
2. Fix the underlying issue (e.g. permissions, disk space)
3. Re-run the migration — idempotent statements will skip safely

---

### Migration fails — FK violation

The `drawing_entities` table references `drawings(id)` and `drawing_revisions(id)`.
If migrating a database that already has data, ensure migrations are applied in
strict numeric order (`001_`, `002_` … `006_`).

---

### Lock / deadlock on StoreDrawingRevision

The service uses `SELECT … FOR UPDATE` to serialise writes to the same drawing.
Deadlocks should not occur under normal operation (one lock per drawing).

If deadlocks are observed in the DB logs:
1. Check for long-running transactions holding locks (e.g. abandoned connections)
2. Increase `pgxpool.MaxConnIdleTime` if many idle connections are holding locks
3. Look for application-level transaction leaks (mis-handled `defer tx.Rollback`)

---

## Performance Issues

### High latency on StoreDrawingRevision

`StoreDrawingRevision` writes up to three tables in a single transaction:
`drawing_revisions`, `drawings` (UPDATE), and `drawing_entities` (DELETE + INSERT).

**Identify the bottleneck**:
```bash
# Enable slow query logging in PostgreSQL (>100ms)
ALTER SYSTEM SET log_min_duration_statement = '100';
SELECT pg_reload_conf();
```

**Common fixes**:

| Symptom | Fix |
|---------|-----|
| Slow `drawing_entities` INSERT on large entity counts | Ensure index `uq_drawing_entities_drawing_entity` is present |
| High lock wait time | Reduce concurrent writers to the same drawing, or investigate long transactions |
| Bloated `snapshot_json` | Large JSONB columns slow writes — consider chunking entities |

---

### High memory usage in drawing-revision-service

Each `GetDrawingState` call deserialises the entire `snapshot_json` column.
For drawings with thousands of entities, this can be memory-intensive.

**Mitigation**:
- Increase `resources.limits.memory` (default 1Gi)
- Consider implementing entity paging at the DB level for very large drawings

---

## Inter-Service Communication Failures

### cad-core-service cannot reach drawing-revision-service

```bash
# Check env var in the cad-core deployment
kubectl get deployment cad-core-service -n solar3d \
  -o jsonpath='{.spec.template.spec.containers[0].env}' | jq .

# Test connectivity from a cad-core pod
kubectl exec -n solar3d deploy/cad-core-service -- \
  wget -qO- http://drawing-revision-service.solar3d.svc.cluster.local:8091/healthz
```

The `DRAWING_REVISION_URL` in K8s defaults to the cluster-internal service hostname:
`http://drawing-revision-service.solar3d.svc.cluster.local:8091`

---

### api-gateway-service returns 502

```bash
# Check all three downstream health checks
curl -s http://localhost:8090/healthz | jq .

# View relevant gateway logs
kubectl logs -n solar3d deploy/api-gateway-service --tail=50 \
  | grep '"level":"error"'
```

---

## Data Consistency Issues

### Drawing head revision out of sync with drawing_entities table

The `drawing_entities` table is maintained by `StoreDrawingRevision` atomically
within a transaction. If it drifts, a transaction was likely rolled back
mid-flight while the process crashed.

**Diagnose**:
```sql
-- Entity count in drawing_entities vs drawing.entity_count
SELECT d.id, d.entity_count AS header_count, COUNT(de.id) AS actual_count
  FROM drawings d
  LEFT JOIN drawing_entities de ON de.drawing_id = d.id
  GROUP BY d.id
 HAVING d.entity_count <> COUNT(de.id);
```

  **Automated audit**:
  ```bash
  cd services/drawing-revision-service
  DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode audit --batch-size 250
```

  **Fix safely from immutable revisions**:
  ```bash
  cd services/drawing-revision-service

  # Inspect one drawing first
  DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode verify --drawing-id <drawing_id>

  # Rebuild only drawing_entities from the current head snapshot
  DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode repair-index --drawing-id <drawing_id>

  # If current_revision_id or revision_count drifted, rebuild both head pointer and index
  DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode repair-head --drawing-id <drawing_id>
  ```

  The repair commands never synthesize new entity state. They rebuild mutable
  tables strictly from immutable revision snapshots and resolve any open integrity
  findings for that drawing after a successful repair.

---

## Log Reference

All services emit structured JSON logs via `zerolog`.

### drawing-revision-service key log fields

| Field | Values | Meaning |
|-------|--------|---------|
| `component` | `service`, `handler` | Layer emitting the log |
| `drawing_id` | UUID | Drawing being operated on |
| `revision_id` | UUID | Revision just created or read |
| `project_id` | UUID | Owning project |
| `level` | `debug`, `info`, `warn`, `error` | Log severity |
| `error` | string | Error message (error/warn level only) |

### cad-core-service key log fields

| Field | Values | Meaning |
|-------|--------|---------|
| `drawing_id` | UUID | Drawing being operated on |
| `command_id` | UUID | Command being validated/committed |
| `actor` | string | User identity from the command |
| `violations` | int | Number of validation violations found |

### Common log patterns and their meaning

```
{"level":"info","drawing_id":"...","msg":"drawing created"}
  → Normal: CreateDrawing succeeded

{"level":"info","drawing_id":"...","revision_id":"...","entity_count":12,"msg":"revision stored"}
  → Normal: StoreDrawingRevision succeeded

{"level":"error","error":"begin create drawing tx: failed to connect...","msg":"..."}
  → DB connection lost — check PostgreSQL and the postgres-credentials secret

{"level":"warn","drawing_id":"...","msg":"revision head conflict — stale base_revision_id"}
  → Normal optimistic locking: client should retry with updated base revision

{"level":"error","error":"scan drawing: ...","msg":"..."}
  → DB schema mismatch — check that all migrations have been applied (describe the drawings table)
```
