#!/usr/bin/env bash
# Phase 6 CAD acceptance gate.
# Enforces three mandatory checks:
# 1) no CAD geometry crashers,
# 2) conflict recovery success meets SLO,
# 3) no unresolved integrity drift.

set -euo pipefail

STAGE="${CAD_ROLLOUT_STAGE:-unknown}"
PERCENT="${CAD_ROLLOUT_PERCENT:-0}"
MIN_CONFLICT_RECOVERY="${CAD_MIN_CONFLICT_RECOVERY:-99.0}"
MAX_UNRESOLVED_DRIFT="${CAD_MAX_UNRESOLVED_DRIFT:-0}"
METRICS_FILE="${CAD_ACCEPTANCE_METRICS_FILE:-}"
INTEGRITY_BATCH_SIZE="${CAD_INTEGRITY_BATCH_SIZE:-250}"
SKIP_GEOMETRY_TESTS="${CAD_SKIP_GEOMETRY_TESTS:-false}"
SKIP_INTEGRITY_AUDIT="${CAD_SKIP_INTEGRITY_AUDIT:-false}"

section() {
  echo
  echo "== $1 =="
}

fail() {
  echo "[FAIL] $1"
  exit 1
}

pass() {
  echo "[PASS] $1"
}

lookup_metric() {
  local key="$1"
  if [[ -z "$METRICS_FILE" || ! -f "$METRICS_FILE" ]]; then
    return 1
  fi
  local line
  line=$(grep -E "^${key}=" "$METRICS_FILE" | tail -n 1 || true)
  if [[ -z "$line" ]]; then
    return 1
  fi
  echo "${line#*=}"
}

numeric_ge() {
  local lhs="$1"
  local rhs="$2"
  awk -v a="$lhs" -v b="$rhs" 'BEGIN { exit !(a+0 >= b+0) }'
}

numeric_le() {
  local lhs="$1"
  local rhs="$2"
  awk -v a="$lhs" -v b="$rhs" 'BEGIN { exit !(a+0 <= b+0) }'
}

echo "Running CAD acceptance gate for stage=${STAGE}, cohort=${PERCENT}%"

section "Geometry safety gate"
if [[ "$SKIP_GEOMETRY_TESTS" == "true" ]]; then
  echo "Skipping geometry gate tests due to CAD_SKIP_GEOMETRY_TESTS=true"
else
  (cd services/cad-core-service && go test ./internal/service ./internal/handler -count=1)
  (cd services/cad-annotation-service && go test ./internal/service -count=1)
  pass "CAD geometry and service safety tests passed"
fi

section "Conflict recovery SLO gate"
conflict_recovery="${CAD_CONFLICT_RECOVERY_SUCCESS_RATE:-}"
if [[ -z "$conflict_recovery" ]]; then
  conflict_recovery="$(lookup_metric conflict_recovery_success_rate || true)"
fi
if [[ -z "$conflict_recovery" ]]; then
  fail "Conflict recovery metric unavailable. Set CAD_CONFLICT_RECOVERY_SUCCESS_RATE or provide CAD_ACCEPTANCE_METRICS_FILE"
fi
if ! numeric_ge "$conflict_recovery" "$MIN_CONFLICT_RECOVERY"; then
  fail "Conflict recovery SLO not met: observed=${conflict_recovery}, required>=${MIN_CONFLICT_RECOVERY}"
fi
pass "Conflict recovery SLO met: ${conflict_recovery} >= ${MIN_CONFLICT_RECOVERY}"

section "Integrity drift gate"
unresolved_drift="${CAD_UNRESOLVED_INTEGRITY_DRIFT:-}"
if [[ "$SKIP_INTEGRITY_AUDIT" != "true" && -z "$unresolved_drift" && -n "${DATABASE_URL:-}" ]]; then
  audit_output="$(go run ./services/drawing-revision-service/cmd/integrity --mode audit --batch-size "$INTEGRITY_BATCH_SIZE")"
  unresolved_drift="$(printf '%s' "$audit_output" | grep -c '"issue_code"' || true)"
  echo "Integrity audit findings detected: ${unresolved_drift}"
fi
if [[ -z "$unresolved_drift" ]]; then
  unresolved_drift="$(lookup_metric unresolved_integrity_drift || true)"
fi
if [[ -z "$unresolved_drift" ]]; then
  fail "Unresolved integrity drift metric unavailable. Set CAD_UNRESOLVED_INTEGRITY_DRIFT, provide DATABASE_URL, or provide CAD_ACCEPTANCE_METRICS_FILE"
fi
if ! numeric_le "$unresolved_drift" "$MAX_UNRESOLVED_DRIFT"; then
  fail "Integrity drift gate failed: unresolved=${unresolved_drift}, allowed<=${MAX_UNRESOLVED_DRIFT}"
fi
pass "Integrity drift gate met: unresolved=${unresolved_drift}"

echo
pass "CAD acceptance gate passed for stage=${STAGE} cohort=${PERCENT}%"
