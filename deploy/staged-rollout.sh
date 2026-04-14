#!/usr/bin/env bash
# Solar3D CAD Backbone — Staged Rollout Validation
#
# Deploys the three CAD backbone services in dependency order and validates
# each stage before proceeding.  On failure the script stops and prints
# remediation hints.
#
# Prerequisites: kubectl in PATH, correct kubeconfig context active.
#
# Usage:
#   ./deploy/staged-rollout.sh [--namespace solar3d] [--image-tag v1.2.3]
#                              [--skip-migrations] [--dry-run]
#                              [--canary-percent 10] [--progressive-steps 25,50,100]
#                              [--acceptance-script ./scripts/cad-acceptance-gate.sh]
#
# Environment variables:
#   KUBECONFIG       — path to kubeconfig (kubectl default applies if unset)
#   ROLLOUT_TIMEOUT  — seconds to wait for rollout (default: 180)
#   SMOKE_TESTS      — path to smoke-test.sh (default: ./scripts/smoke-test.sh)
#   ENABLE_PHASE6_GATES — run canary/progressive acceptance gates (default: true)

set -euo pipefail

# ── defaults ──────────────────────────────────────────────────────────────────
NAMESPACE="${NAMESPACE:-solar3d}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
ROLLOUT_TIMEOUT="${ROLLOUT_TIMEOUT:-180}"
SKIP_MIGRATIONS="${SKIP_MIGRATIONS:-false}"
DRY_RUN="${DRY_RUN:-false}"
SMOKE_TESTS="${SMOKE_TESTS:-./scripts/smoke-test.sh}"
ENABLE_PHASE6_GATES="${ENABLE_PHASE6_GATES:-true}"
CANARY_PERCENT="${CANARY_PERCENT:-10}"
PROGRESSIVE_STEPS="${PROGRESSIVE_STEPS:-25,50,100}"
ACCEPTANCE_SCRIPT="${ACCEPTANCE_SCRIPT:-./scripts/cad-acceptance-gate.sh}"
K8S_DIR="$(dirname "$0")/k8s"

# ── argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    --namespace)       NAMESPACE="$2";       shift 2 ;;
    --image-tag)       IMAGE_TAG="$2";       shift 2 ;;
    --timeout)         ROLLOUT_TIMEOUT="$2"; shift 2 ;;
    --skip-migrations) SKIP_MIGRATIONS=true; shift   ;;
    --dry-run)         DRY_RUN=true;         shift   ;;
    --canary-percent)  CANARY_PERCENT="$2"; shift 2 ;;
    --progressive-steps) PROGRESSIVE_STEPS="$2"; shift 2 ;;
    --acceptance-script) ACCEPTANCE_SCRIPT="$2"; shift 2 ;;
    --disable-phase6-gates) ENABLE_PHASE6_GATES=false; shift ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
done

# ── helpers ───────────────────────────────────────────────────────────────────
STEP=0
ERRORS=0

step() {
  STEP=$((STEP+1))
  echo
  echo "═══════════════════════════════════════════════════════════════"
  echo "  Step $STEP: $1"
  echo "═══════════════════════════════════════════════════════════════"
}

info()  { echo "  ℹ  $1"; }
pass()  { echo "  ✓  $1"; }
error() { echo "  ✗  $1"; ERRORS=$((ERRORS+1)); }
abort() { echo; echo "ABORT: $1"; echo "See docs/TROUBLESHOOTING.md for remediation steps."; exit 1; }

is_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

rollback_phase6() {
  local reason="$1"
  error "$reason"
  info "Rollback gate triggered; undoing CAD deployments"
  if [[ "$DRY_RUN" == "true" ]]; then
    info "[dry-run] kubectl rollout undo deployment/drawing-revision-service -n $NAMESPACE"
    info "[dry-run] kubectl rollout undo deployment/cad-core-service -n $NAMESPACE"
    return 1
  fi
  kubectl rollout undo deployment/drawing-revision-service -n "$NAMESPACE" || true
  kubectl rollout undo deployment/cad-core-service -n "$NAMESPACE" || true
  kubectl rollout status deployment/drawing-revision-service -n "$NAMESPACE" --timeout="${ROLLOUT_TIMEOUT}s" || true
  kubectl rollout status deployment/cad-core-service -n "$NAMESPACE" --timeout="${ROLLOUT_TIMEOUT}s" || true
  return 1
}

set_rollout_flags() {
  local stage="$1"
  local percent="$2"
  info "Applying rollout flags stage=$stage cohort=${percent}%"
  if [[ "$DRY_RUN" == "true" ]]; then
    info "[dry-run] kubectl set env deployment/drawing-revision-service CAD_PHASE6_VERIFICATION_ENABLED=true CAD_ROLLOUT_STAGE=$stage CAD_ROLLOUT_COHORT_PERCENT=$percent -n $NAMESPACE"
    info "[dry-run] kubectl set env deployment/cad-core-service CAD_PHASE6_VERIFICATION_ENABLED=true CAD_ROLLOUT_STAGE=$stage CAD_ROLLOUT_COHORT_PERCENT=$percent -n $NAMESPACE"
    return 0
  fi
  kubectl set env deployment/drawing-revision-service \
    CAD_PHASE6_VERIFICATION_ENABLED=true \
    CAD_ROLLOUT_STAGE="$stage" \
    CAD_ROLLOUT_COHORT_PERCENT="$percent" \
    -n "$NAMESPACE"
  kubectl set env deployment/cad-core-service \
    CAD_PHASE6_VERIFICATION_ENABLED=true \
    CAD_ROLLOUT_STAGE="$stage" \
    CAD_ROLLOUT_COHORT_PERCENT="$percent" \
    -n "$NAMESPACE"
}

run_acceptance_gate() {
  local stage="$1"
  local percent="$2"
  if [[ "$ENABLE_PHASE6_GATES" != "true" ]]; then
    info "Phase 6 acceptance gates disabled"
    return 0
  fi
  if [[ "$DRY_RUN" == "true" ]]; then
    info "[dry-run] skipping acceptance gate ($stage ${percent}%)"
    return 0
  fi
  if [[ ! -f "$ACCEPTANCE_SCRIPT" ]]; then
    rollback_phase6 "Acceptance script missing: $ACCEPTANCE_SCRIPT"
    return 1
  fi
  info "Running acceptance gate: $stage (${percent}%)"
  if ! CAD_ROLLOUT_STAGE="$stage" CAD_ROLLOUT_PERCENT="$percent" "$ACCEPTANCE_SCRIPT"; then
    rollback_phase6 "Acceptance gate failed at $stage (${percent}%)"
    return 1
  fi
  pass "Acceptance gate passed for $stage (${percent}%)"
}

kubectl_apply() {
  local file="$1"
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [dry-run] kubectl apply -n $NAMESPACE -f $file"
    kubectl apply -n "$NAMESPACE" --dry-run=client -f "$file"
  else
    kubectl apply -n "$NAMESPACE" -f "$file"
  fi
}

wait_rollout() {
  local deployment="$1"
  info "Waiting for $deployment rollout (timeout: ${ROLLOUT_TIMEOUT}s)…"
  if [[ "$DRY_RUN" == "true" ]]; then
    info "[dry-run] skipping rollout wait"
    return 0
  fi
  if ! kubectl rollout status "deployment/$deployment" \
       -n "$NAMESPACE" \
       --timeout="${ROLLOUT_TIMEOUT}s"; then
    error "Rollout of $deployment timed out or failed"
    kubectl describe "deployment/$deployment" -n "$NAMESPACE" || true
    kubectl get pods -l "app=$deployment" -n "$NAMESPACE" || true
    return 1
  fi
  pass "$deployment rollout complete"
}

health_check() {
  local service="$1" port="$2"
  if [[ "$DRY_RUN" == "true" ]]; then
    info "[dry-run] skipping health check for $service"
    return 0
  fi
  info "Health-checking $service on port $port…"
  local pod
  pod=$(kubectl get pods -n "$NAMESPACE" -l "app=$service" \
        --field-selector=status.phase=Running \
        -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
  if [[ -z "$pod" ]]; then
    error "No running pod found for $service"
    return 1
  fi
  local http_status
  http_status=$(kubectl exec -n "$NAMESPACE" "$pod" -- \
    wget -qO- --server-response "http://localhost:$port/healthz" 2>&1 | \
    awk '/HTTP\//{print $2}' | tail -1 || echo "000")
  if [[ "$http_status" == "200" ]]; then
    pass "$service /healthz → 200"
  else
    error "$service /healthz returned $http_status (pod: $pod)"
    return 1
  fi
}

# ── preflight ─────────────────────────────────────────────────────────────────
step "Preflight checks"

if ! command -v kubectl &>/dev/null; then
  abort "kubectl not found in PATH"
fi

CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null || echo "unknown")
info "kubectl context: $CURRENT_CONTEXT"

CLUSTER=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}' 2>/dev/null || echo "unknown")
info "Cluster: $CLUSTER"

if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
  info "Namespace $NAMESPACE does not exist — creating"
  kubectl_apply "$K8S_DIR/namespace.yaml"
else
  pass "Namespace $NAMESPACE exists"
fi

if ! is_integer "$CANARY_PERCENT" || [[ "$CANARY_PERCENT" -lt 1 || "$CANARY_PERCENT" -gt 100 ]]; then
  abort "--canary-percent must be an integer between 1 and 100"
fi

IFS=',' read -r -a PROGRESSIVE_ARRAY <<< "$PROGRESSIVE_STEPS"
if [[ ${#PROGRESSIVE_ARRAY[@]} -eq 0 ]]; then
  abort "--progressive-steps requires a comma-separated list, e.g. 25,50,100"
fi
for pct in "${PROGRESSIVE_ARRAY[@]}"; do
  trimmed=$(echo "$pct" | tr -d '[:space:]')
  if ! is_integer "$trimmed" || [[ "$trimmed" -lt 1 || "$trimmed" -gt 100 ]]; then
    abort "Invalid progressive step percentage: $pct"
  fi
done

# ── stage 0: migrations ───────────────────────────────────────────────────────
if [[ "$SKIP_MIGRATIONS" == "false" ]]; then
  step "Database migrations"
  info "Applying migrations job…"
  # Check for an existing migration Job; delete if present so we can re-apply.
  if kubectl get job solar3d-migrate -n "$NAMESPACE" &>/dev/null; then
    info "Previous migration job found — deleting before re-run"
    if [[ "$DRY_RUN" != "true" ]]; then
      kubectl delete job solar3d-migrate -n "$NAMESPACE" --wait=true
    fi
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    info "[dry-run] kubectl apply migration job"
  else
    # Inline Job spec — runs flyway/psql migrations from the migrations/ directory.
    kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: solar3d-migrate
  namespace: $NAMESPACE
  labels:
    app: solar3d-migrate
spec:
  backoffLimit: 3
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: migrate
          image: postgres:16-alpine
          command:
            - /bin/sh
            - -c
            - |
              set -e
              for f in \$(ls /migrations/*.sql | sort); do
                echo "Applying \$f..."
                psql "\$DATABASE_URL" -f "\$f"
              done
              echo "All migrations applied."
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: connection-string
          volumeMounts:
            - name: migrations
              mountPath: /migrations
      volumes:
        - name: migrations
          configMap:
            name: solar3d-migrations
EOF
    info "Waiting for migration job to complete (up to 120s)…"
    if ! kubectl wait job/solar3d-migrate -n "$NAMESPACE" \
         --for=condition=complete --timeout=120s; then
      kubectl logs job/solar3d-migrate -n "$NAMESPACE" || true
      abort "Database migration job failed — check logs above"
    fi
    pass "Database migrations complete"
  fi
fi

# ── stage 1: drawing-revision-service ─────────────────────────────────────────
step "Stage 1: drawing-revision-service (stateful, requires DB)"

# Patch image tag if not 'latest'.
if [[ "$IMAGE_TAG" != "latest" ]]; then
  info "Setting image tag to $IMAGE_TAG"
  if [[ "$DRY_RUN" != "true" ]]; then
    kubectl set image "deployment/drawing-revision-service" \
      "drawing-revision-service=solar3d/drawing-revision-service:$IMAGE_TAG" \
      -n "$NAMESPACE" 2>/dev/null || true
  fi
fi

kubectl_apply "$K8S_DIR/drawing-revision-service.yaml"
wait_rollout "drawing-revision-service" || abort "drawing-revision-service rollout failed"
health_check "drawing-revision-service" "8091" || abort "drawing-revision-service health check failed"

EXISTING_REPLICAS=$(kubectl get deployment drawing-revision-service \
  -n "$NAMESPACE" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
if [[ "$DRY_RUN" != "true" && "$EXISTING_REPLICAS" -lt 2 ]]; then
  error "drawing-revision-service ready replicas: want >=2, got $EXISTING_REPLICAS"
else
  pass "drawing-revision-service ready replicas: $EXISTING_REPLICAS"
fi

# ── stage 2: cad-core-service ────────────────────────────────────────────────
step "Stage 2: cad-core-service (stateless, depends on drawing-revision-service)"

if [[ "$IMAGE_TAG" != "latest" ]]; then
  if [[ "$DRY_RUN" != "true" ]]; then
    kubectl set image "deployment/cad-core-service" \
      "cad-core-service=solar3d/cad-core-service:$IMAGE_TAG" \
      -n "$NAMESPACE" 2>/dev/null || true
  fi
fi

kubectl_apply "$K8S_DIR/cad-core-service.yaml"
wait_rollout "cad-core-service" || abort "cad-core-service rollout failed"
health_check "cad-core-service" "8092" || abort "cad-core-service health check failed"

# ── phase 6: canary + progressive gates ──────────────────────────────────────
step "Phase 6: Canary + progressive feature-flag rollout"

set_rollout_flags "canary" "$CANARY_PERCENT"
wait_rollout "drawing-revision-service" || rollback_phase6 "drawing-revision-service canary rollout failed" || abort "rollback failed"
wait_rollout "cad-core-service" || rollback_phase6 "cad-core-service canary rollout failed" || abort "rollback failed"
run_acceptance_gate "canary" "$CANARY_PERCENT" || abort "phase 6 canary gate failed"

for pct in "${PROGRESSIVE_ARRAY[@]}"; do
  pct=$(echo "$pct" | tr -d '[:space:]')
  set_rollout_flags "progressive" "$pct"
  wait_rollout "drawing-revision-service" || rollback_phase6 "drawing-revision-service progressive rollout failed at ${pct}%" || abort "rollback failed"
  wait_rollout "cad-core-service" || rollback_phase6 "cad-core-service progressive rollout failed at ${pct}%" || abort "rollback failed"
  run_acceptance_gate "progressive" "$pct" || abort "phase 6 progressive gate failed at ${pct}%"
done

set_rollout_flags "stable" "100"
wait_rollout "drawing-revision-service" || rollback_phase6 "drawing-revision-service stable rollout failed" || abort "rollback failed"
wait_rollout "cad-core-service" || rollback_phase6 "cad-core-service stable rollout failed" || abort "rollback failed"
pass "Phase 6 rollout gates complete"

# ── stage 3: api-gateway-service ─────────────────────────────────────────────
step "Stage 3: api-gateway-service (edge, depends on project-service + cad-core-service)"

if [[ "$IMAGE_TAG" != "latest" ]]; then
  if [[ "$DRY_RUN" != "true" ]]; then
    kubectl set image "deployment/api-gateway-service" \
      "api-gateway-service=solar3d/api-gateway-service:$IMAGE_TAG" \
      -n "$NAMESPACE" 2>/dev/null || true
  fi
fi

kubectl_apply "$K8S_DIR/api-gateway-service.yaml"
wait_rollout "api-gateway-service" || abort "api-gateway-service rollout failed"
health_check "api-gateway-service" "8090" || abort "api-gateway-service health check failed"

# ── stage 4: post-rollout smoke tests ────────────────────────────────────────
step "Stage 4: Post-rollout smoke tests"

if [[ "$DRY_RUN" == "true" ]]; then
  info "[dry-run] skipping smoke tests"
elif [[ -x "$SMOKE_TESTS" ]]; then
  # Resolve service endpoints from K8s services.
  GW_IP=$(kubectl get service api-gateway-service -n "$NAMESPACE" \
    -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "localhost")
  DRW_IP=$(kubectl get service drawing-revision-service -n "$NAMESPACE" \
    -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "localhost")
  CAD_IP=$(kubectl get service cad-core-service -n "$NAMESPACE" \
    -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "localhost")

  SMOKE_GATEWAY_URL="http://$GW_IP:8090" \
  SMOKE_DRAWING_URL="http://$DRW_IP:8091" \
  SMOKE_CAD_URL="http://$CAD_IP:8092" \
    "$SMOKE_TESTS" || abort "Smoke tests failed — review output above"
  pass "All smoke tests passed"
else
  info "Smoke test script not found at $SMOKE_TESTS — skipping"
fi

# ── summary ───────────────────────────────────────────────────────────────────
echo
echo "═══════════════════════════════════════════════════════════════"
if [[ $ERRORS -eq 0 ]]; then
  echo "  ✓ Staged rollout complete — all $STEP stages passed"
else
  echo "  ✗ Staged rollout finished with $ERRORS error(s)"
fi
echo "═══════════════════════════════════════════════════════════════"

if [[ $ERRORS -gt 0 ]]; then
  echo "  See docs/TROUBLESHOOTING.md for remediation steps."
  exit 1
fi
exit 0
