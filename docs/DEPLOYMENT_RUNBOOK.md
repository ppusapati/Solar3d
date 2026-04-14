# Solar3D CAD Backbone — Deployment Runbook

This runbook covers the end-to-end procedure for deploying, upgrading, and
rolling back the three CAD backbone services:

- `drawing-revision-service` (port 8091) — stateful, requires PostgreSQL
- `cad-core-service` (port 8092) — stateless, depends on drawing-revision-service
- `api-gateway-service` (port 8090) — edge REST façade, depends on both + project-service

See also:
- [API Reference](API_REFERENCE.md) — full API documentation
- [Troubleshooting Guide](TROUBLESHOOTING.md) — incident response and error codes

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Initial Deployment](#initial-deployment)
4. [Upgrading a Service](#upgrading-a-service)
5. [Rolling Back](#rolling-back)
6. [Scaling](#scaling)
7. [Configuration Reference](#configuration-reference)
8. [Secrets Management](#secrets-management)
9. [Monitoring and Alerting](#monitoring-and-alerting)
10. [Maintenance Procedures](#maintenance-procedures)

---

## Architecture Overview

```
Client / Mobile
      │
      ▼
api-gateway-service :8090      (REST JSON)
      │
      ├── project-service   :8080  (ConnectRPC)
      ├── drawing-revision-service :8091  (ConnectRPC)  ──► PostgreSQL
      └── cad-core-service  :8092  (ConnectRPC)
               │
               └── drawing-revision-service :8091
```

**Dependency order for deployment**: PostgreSQL → drawing-revision-service → cad-core-service → api-gateway-service.

---

## Prerequisites

- `kubectl` ≥ 1.28, configured with a valid kubeconfig for the target cluster
- Docker registry accessible from the cluster (images pre-pushed)
- PostgreSQL 15+ with the `uuid-ossp` extension enabled
- Kubernetes namespace `solar3d` (created by `deploy/k8s/namespace.yaml`)
- Secret `postgres-credentials` in namespace `solar3d` with key `connection-string`

---

## Initial Deployment

### 1. Create the namespace and secrets

```bash
# Namespace
kubectl apply -f deploy/k8s/namespace.yaml

# PostgreSQL secret (replace values)
kubectl create secret generic postgres-credentials \
  --namespace solar3d \
  --from-literal=connection-string="postgres://solar3d:PASSWORD@postgres-host:5432/solar3d?sslmode=require"
```

### 2. Run database migrations

Migrations must be applied before the first service deployment.

```bash
# Apply all SQL migration files in order
for f in migrations/*.sql; do
  echo "Applying $f..."
  psql "$DATABASE_URL" -f "$f"
done
```

Migrations are idempotent (`CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`).

### 3. Use the automated staged rollout

The recommended approach is the staged rollout script which validates each
service before proceeding to the next:

```bash
chmod +x deploy/staged-rollout.sh scripts/smoke-test.sh
./deploy/staged-rollout.sh --image-tag v1.0.0
```

### 4. Manual per-service deployment (alternative)

If you prefer to deploy manually:

```bash
# Stage 1 — drawing-revision-service
kubectl apply -n solar3d -f deploy/k8s/drawing-revision-service.yaml
kubectl rollout status deployment/drawing-revision-service -n solar3d --timeout=180s

# Stage 2 — cad-core-service
kubectl apply -n solar3d -f deploy/k8s/cad-core-service.yaml
kubectl rollout status deployment/cad-core-service -n solar3d --timeout=180s

# Stage 3 — api-gateway-service
kubectl apply -n solar3d -f deploy/k8s/api-gateway-service.yaml
kubectl rollout status deployment/api-gateway-service -n solar3d --timeout=180s
```

### 5. Validate

```bash
./scripts/smoke-test.sh \
  --drawing-url http://<DRAWING_REVISION_IP>:8091 \
  --cad-url     http://<CAD_CORE_IP>:8092 \
  --gateway-url http://<API_GATEWAY_IP>:8090
```

---

## Upgrading a Service

Services are upgraded independently using `kubectl set image` combined with a
rolling update. The K8s manifests are pre-configured with:

- `maxUnavailable: 0` — zero pods taken down before a new one is ready
- `maxSurge: 1` — one extra pod spun up during rollout
- `PodDisruptionBudget` — minimum 1 pod always available

### Upgrade drawing-revision-service

```bash
# 1. If there are new DB migrations, apply them first (migrations are additive).
psql "$DATABASE_URL" -f migrations/00N_new_migration.sql

# 2. Push the new image
docker push solar3d/drawing-revision-service:v1.2.0

# 3. Update image and watch rollout
kubectl set image deployment/drawing-revision-service \
  drawing-revision-service=solar3d/drawing-revision-service:v1.2.0 \
  -n solar3d

kubectl rollout status deployment/drawing-revision-service -n solar3d

# 4. Smoke test
./scripts/smoke-test.sh
```

### Upgrade cad-core-service

```bash
kubectl set image deployment/cad-core-service \
  cad-core-service=solar3d/cad-core-service:v1.2.0 \
  -n solar3d

kubectl rollout status deployment/cad-core-service -n solar3d
```

### Upgrade api-gateway-service

```bash
kubectl set image deployment/api-gateway-service \
  api-gateway-service=solar3d/api-gateway-service:v1.2.0 \
  -n solar3d

kubectl rollout status deployment/api-gateway-service -n solar3d
```

---

## Rolling Back

### Immediate rollback (last working revision)

```bash
# drawing-revision-service
kubectl rollout undo deployment/drawing-revision-service -n solar3d

# cad-core-service
kubectl rollout undo deployment/cad-core-service -n solar3d

# api-gateway-service
kubectl rollout undo deployment/api-gateway-service -n solar3d
```

### Rollback to a specific revision

```bash
# List revision history
kubectl rollout history deployment/drawing-revision-service -n solar3d

# Roll back to revision #3
kubectl rollout undo deployment/drawing-revision-service --to-revision=3 -n solar3d
```

### Database rollback

**Schema migrations are intentionally additive and non-destructive.**
There are no automated down-migrations. If a migration introduced a bug,
deploy a new migration that corrects it rather than reverting.

For catastrophic data loss scenarios, restore from the most recent
PostgreSQL backup and redeploy the previous service image.

---

## Scaling

### Manual scaling

```bash
# Scale drawing-revision-service to 4 replicas
kubectl scale deployment/drawing-revision-service --replicas=4 -n solar3d
```

### Auto-scaling (HPA)

All three services have HPA pre-configured (see `deploy/k8s/*.yaml`):

| Service | Min | Max | CPU target | Memory target |
|---------|-----|-----|------------|---------------|
| drawing-revision-service | 2 | 10 | 70% | 80% |
| cad-core-service | 2 | 10 | 70% | 80% |
| api-gateway-service | 2 | 10 | 70% | 80% |

View current HPA status:

```bash
kubectl get hpa -n solar3d
```

---

## Configuration Reference

All configuration is injected via environment variables:

### drawing-revision-service

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8091` | Listen port |
| `DATABASE_URL` | — | PostgreSQL DSN (required) |
| `LOG_LEVEL` | `info` | `debug`, `info`, `warn`, `error` |
| `INTEGRITY_AUDIT_ENABLED` | `true` | Enables the in-process periodic integrity audit loop |
| `INTEGRITY_AUDIT_INTERVAL` | `5m` | Interval between full audit batches |
| `INTEGRITY_AUDIT_BATCH_SIZE` | `250` | Maximum drawings scanned per audit batch |
| `INTEGRITY_AUDIT_STARTUP_DELAY` | `30s` | Delay before the first audit run after process startup |

### cad-core-service

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8092` | Listen port |
| `DRAWING_REVISION_URL` | `http://127.0.0.1:8091` | Upstream drawing-revision-service |
| `LOG_LEVEL` | `info` | Log verbosity |

### api-gateway-service

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8090` | Listen port |
| `PROJECT_SERVICE_URL` | `http://127.0.0.1:8080` | Upstream project-service |
| `DRAWING_REVISION_URL` | `http://127.0.0.1:8091` | Upstream drawing-revision-service |
| `CAD_CORE_URL` | `http://127.0.0.1:8092` | Upstream cad-core-service |
| `LOG_LEVEL` | `info` | Log verbosity |
| `REQUEST_TIMEOUT_SECONDS` | `15` | Per-request deadline |

---

## Secrets Management

Only `drawing-revision-service` requires a database secret.

```bash
# Create
kubectl create secret generic postgres-credentials \
  --namespace solar3d \
  --from-literal=connection-string="postgres://USER:PASS@HOST:5432/DB?sslmode=require"

# Rotate
kubectl create secret generic postgres-credentials \
  --namespace solar3d \
  --from-literal=connection-string="postgres://USER:NEW_PASS@HOST:5432/DB?sslmode=require" \
  --dry-run=client -o yaml | kubectl apply -f -

# After rotating: trigger a rollout to pick up the new secret
kubectl rollout restart deployment/drawing-revision-service -n solar3d
```

---

## Monitoring and Alerting

All services expose Prometheus metrics scraping annotations on their pods
(`prometheus.io/scrape: "true"`, `prometheus.io/path: "/healthz"`).

### Key metrics to alert on

| Metric | Threshold | Impact |
|--------|-----------|--------|
| Pod restart count > 3 in 5 min | PagerDuty | Service instability |
| `drawing-revision-service` ready replicas < 1 | PagerDuty | Drawing saves blocked |
| CPU utilisation > 90% for 5 min | Warning | Near HPA scale ceiling |
| DB pool exhausted (pgx pool wait > 100ms P99) | Warning | DB bottleneck |
| HTTP 5xx rate > 1% over 5 min | Warning | Service degradation |

### Dashboards

Import `monitoring/grafana-dashboards.yml` into Grafana for pre-built dashboards.

### Health endpoint

All services expose `GET /healthz` returning:
```json
{ "status": "ok" }
```
or HTTP 503 if the service is not ready (e.g. DB disconnected).

---

## Maintenance Procedures

### Restart a service (zero-downtime)

```bash
kubectl rollout restart deployment/drawing-revision-service -n solar3d
```

### Run an integrity audit manually

```bash
cd services/drawing-revision-service
DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode audit --batch-size 250
```

### Repair a drawing safely from immutable revisions

Use `repair-index` when only `drawing_entities` drifted. Use `repair-head` when
`drawings.current_revision_id` or `revision_count` is also wrong.

```bash
cd services/drawing-revision-service

# Verify first
DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode verify --drawing-id <drawing_id>

# Rebuild the mutable entity index from the current authoritative revision
DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode repair-index --drawing-id <drawing_id>

# Rebuild the drawing head pointer and entity index from the latest immutable revision
DATABASE_URL="$DATABASE_URL" go run ./cmd/integrity --mode repair-head --drawing-id <drawing_id>
```

### Drain a node (for node maintenance)

```bash
# PodDisruptionBudgets ensure at least 1 replica stays running
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# After maintenance, uncordon
kubectl uncordon <node-name>
```

### Force-recreate all pods (after secret rotation)

```bash
for dep in drawing-revision-service cad-core-service api-gateway-service; do
  kubectl rollout restart deployment/$dep -n solar3d
  kubectl rollout status deployment/$dep -n solar3d --timeout=120s
done
```

### Check database connection pool

```bash
# Get a pod name
POD=$(kubectl get pods -n solar3d -l app=drawing-revision-service \
  -o jsonpath='{.items[0].metadata.name}')

# Check logs for pool warnings
kubectl logs "$POD" -n solar3d | grep -i "pool\|timeout\|connection"
```
