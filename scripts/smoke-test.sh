#!/usr/bin/env bash
# Solar3D Smoke Test Suite
# Usage: ./scripts/smoke-test.sh [--gateway-url URL] [--drawing-url URL] [--cad-url URL]
#
# Environment variables (override via flags):
#   SMOKE_GATEWAY_URL  — api-gateway-service base URL (default: http://localhost:8090)
#   SMOKE_DRAWING_URL  — drawing-revision-service base URL (default: http://localhost:8091)
#   SMOKE_CAD_URL      — cad-core-service base URL (default: http://localhost:8092)
#   SMOKE_PROJECT_URL  — project-service base URL (default: http://localhost:8001)
#
# Exit codes: 0 = all tests passed, 1 = one or more tests failed

set -euo pipefail

# ── defaults ─────────────────────────────────────────────────────────────────
GATEWAY_URL="${SMOKE_GATEWAY_URL:-http://localhost:8090}"
DRAWING_URL="${SMOKE_DRAWING_URL:-http://localhost:8091}"
CAD_URL="${SMOKE_CAD_URL:-http://localhost:8092}"
PROJECT_URL="${SMOKE_PROJECT_URL:-http://localhost:8001}"

# ── argument parsing ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    --gateway-url) GATEWAY_URL="$2"; shift 2 ;;
    --drawing-url) DRAWING_URL="$2"; shift 2 ;;
    --cad-url)     CAD_URL="$2";     shift 2 ;;
    --project-url) PROJECT_URL="$2"; shift 2 ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
done

# ── helpers ───────────────────────────────────────────────────────────────────
PASS=0
FAIL=0
START_TIME=$(date +%s)

pass() { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

check_http() {
  local label="$1" url="$2" expected_status="$3"
  local actual_status
  actual_status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" 2>/dev/null || echo "000")
  if [[ "$actual_status" == "$expected_status" ]]; then
    pass "$label (HTTP $actual_status)"
  else
    fail "$label (want HTTP $expected_status, got HTTP $actual_status)"
  fi
}

check_connect() {
  local label="$1" url="$2" body="$3" expected_status="$4"
  local actual_status
  actual_status=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 10 \
    -X POST "$url" \
    -H "Content-Type: application/json" \
    -d "$body" 2>/dev/null || echo "000")
  if [[ "$actual_status" == "$expected_status" ]]; then
    pass "$label (HTTP $actual_status)"
  else
    fail "$label (want HTTP $expected_status, got HTTP $actual_status)"
  fi
}

connect_response() {
  curl -s --max-time 10 \
    -X POST "$1" \
    -H "Content-Type: application/json" \
    -d "$2" 2>/dev/null
}

# ── section header ─────────────────────────────────────────────────────────────
section() { echo; echo "── $1 ──────────────────────────────────────────"; }

# ═══════════════════════════════════════════════════════════════════════════════
section "Health Checks"
check_http "project-service /healthz"           "$PROJECT_URL/healthz"  "200"
check_http "drawing-revision-service /healthz"  "$DRAWING_URL/healthz"  "200"
check_http "cad-core-service /healthz"           "$CAD_URL/healthz"      "200"
check_http "api-gateway-service /healthz"        "$GATEWAY_URL/healthz"  "200"

# ═══════════════════════════════════════════════════════════════════════════════
section "DrawingRevisionService — CreateDrawing"
PROJECT_ID=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")

# Ensure the project exists before creating a drawing to satisfy FK constraints.
PROJECT_CREATE_PAYLOAD="{\"id\":\"$PROJECT_ID\",\"name\":\"Smoke Test Project\",\"description\":\"Created by smoke-test.sh\",\"target_capacity_mw\":1.0,\"client_name\":\"smoke-test\"}"
PROJECT_CREATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  --max-time 10 \
  -X POST "$PROJECT_URL/api/v1/projects" \
  -H "Content-Type: application/json" \
  -d "$PROJECT_CREATE_PAYLOAD" 2>/dev/null || echo "000")

if [[ "$PROJECT_CREATE_STATUS" == "404" ]]; then
  PROJECT_CREATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 10 \
    -X POST "$PROJECT_URL/projects" \
    -H "Content-Type: application/json" \
    -d "$PROJECT_CREATE_PAYLOAD" 2>/dev/null || echo "000")
fi

if [[ "$PROJECT_CREATE_STATUS" == "200" || "$PROJECT_CREATE_STATUS" == "201" ]]; then
  pass "Project created for drawing FK precondition (HTTP $PROJECT_CREATE_STATUS)"
else
  fail "Project pre-create failed (want HTTP 200/201, got HTTP $PROJECT_CREATE_STATUS)"
fi

CREATE_BODY=$(printf '{"project_id":"%s","name":"Smoke Test Drawing","author":"smoke@example.com"}' "$PROJECT_ID")
CREATE_RESP=$(connect_response \
  "$DRAWING_URL/drawing.v1.DrawingRevisionService/CreateDrawing" \
  "$CREATE_BODY")

DRAWING_ID=$(echo "$CREATE_RESP" | grep -o '"drawingId":"[^"]*"\|"drawing_id":"[^"]*"' | head -1 | cut -d'"' -f4 || true)
REVISION_ID=$(echo "$CREATE_RESP" | grep -o '"revisionId":"[^"]*"\|"revision_id":"[^"]*"' | head -1 | cut -d'"' -f4 || true)

if [[ -n "$DRAWING_ID" && "$DRAWING_ID" != "null" ]]; then
  pass "CreateDrawing returned drawing_id=$DRAWING_ID"
else
  fail "CreateDrawing: no drawing_id in response: $CREATE_RESP"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "DrawingRevisionService — GetDrawing"
if [[ -n "$DRAWING_ID" ]]; then
  check_connect "GetDrawing" \
    "$DRAWING_URL/drawing.v1.DrawingRevisionService/GetDrawing" \
    "{\"drawing_id\":\"$DRAWING_ID\"}" \
    "200"
else
  fail "GetDrawing skipped (no drawing_id)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "DrawingRevisionService — StoreDrawingRevision"
STORE_BODY=$(printf '{"drawing_id":"%s","author":"smoke@example.com","summary":"smoke revision","command_id":"smoke-cmd-001","entities":[]}' "$DRAWING_ID")
if [[ -n "$DRAWING_ID" ]]; then
  STORE_RESP=$(connect_response \
    "$DRAWING_URL/drawing.v1.DrawingRevisionService/StoreDrawingRevision" \
    "$STORE_BODY")
  NEW_REV_ID=$(echo "$STORE_RESP" | grep -o '"revisionId":"[^"]*"\|"revision_id":"[^"]*"' | head -1 | cut -d'"' -f4 || true)
  if [[ -n "$NEW_REV_ID" && "$NEW_REV_ID" != "null" ]]; then
    pass "StoreDrawingRevision returned revision_id=$NEW_REV_ID"
    REVISION_ID="$NEW_REV_ID"
  else
    fail "StoreDrawingRevision: no revision_id in response: $STORE_RESP"
  fi
else
  fail "StoreDrawingRevision skipped (no drawing_id)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "DrawingRevisionService — GetDrawingState"
if [[ -n "$DRAWING_ID" ]]; then
  check_connect "GetDrawingState (head)" \
    "$DRAWING_URL/drawing.v1.DrawingRevisionService/GetDrawingState" \
    "{\"drawing_id\":\"$DRAWING_ID\"}" \
    "200"
else
  fail "GetDrawingState skipped (no drawing_id)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "DrawingRevisionService — ListDrawingRevisions"
if [[ -n "$DRAWING_ID" ]]; then
  check_connect "ListDrawingRevisions" \
    "$DRAWING_URL/drawing.v1.DrawingRevisionService/ListDrawingRevisions" \
    "{\"drawing_id\":\"$DRAWING_ID\",\"page_size\":10}" \
    "200"
else
  fail "ListDrawingRevisions skipped (no drawing_id)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "CadCoreService — ValidateDrawingCommand"
CMD_ID=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")
if [[ -n "$DRAWING_ID" && -n "$REVISION_ID" ]]; then
  VALIDATE_BODY=$(printf '{"command":{"command_id":"%s","drawing_id":"%s","actor":"smoke@example.com","mutations":[]},"base_revision_id":"%s"}' \
    "$CMD_ID" "$DRAWING_ID" "$REVISION_ID")
  check_connect "ValidateDrawingCommand (no mutations)" \
    "$CAD_URL/drawing.v1.CadCoreService/ValidateDrawingCommand" \
    "$VALIDATE_BODY" \
    "200"
else
  fail "ValidateDrawingCommand skipped (no drawing_id or revision_id)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "API Gateway — REST Endpoints"
check_http "GET /healthz" "$GATEWAY_URL/healthz" "200"

if [[ -n "$DRAWING_ID" ]]; then
  check_http "GET /api/v1/workspace/drawings/{id}" \
    "$GATEWAY_URL/api/v1/workspace/drawings/$DRAWING_ID" \
    "200"
else
  fail "GET /api/v1/workspace/drawings/{id} skipped (no drawing_id)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "Error Handling — 404 on Unknown IDs"
FAKE_ID="00000000-0000-0000-0000-000000000000"
check_connect "GetDrawing(unknown) → 404" \
  "$DRAWING_URL/drawing.v1.DrawingRevisionService/GetDrawing" \
  "{\"drawing_id\":\"$FAKE_ID\"}" \
  "404"

# ═══════════════════════════════════════════════════════════════════════════════
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo
echo "══════════════════════════════════════════"
echo "  Smoke tests complete in ${DURATION}s"
echo "  Passed: $PASS   Failed: $FAIL"
echo "══════════════════════════════════════════"

if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
exit 0
