# CAD Reliability Baseline and Governance

## Scope

This baseline governs CAD revision consistency and conflict recovery across:

- `drawing-revision-service`
- `cad-core-service`
- `cad-annotation-service`
- `cad-layer-block-service`
- `interop-service`
- `plot-sheet-service`
- frontend CAD store retry orchestration

## Phase 0: Reliability SLOs

### SLO-1: Conflict recovery success rate

- Definition: percentage of stale-conflict events that are auto-recovered by refresh + bounded retry.
- Target: >= 99.0% over rolling 7 days.
- Signal:
  - numerator: `cad_conflicts_recovered_total`
  - denominator: `cad_conflicts_total`

### SLO-2: Max recovery latency

- Definition: time from first stale conflict detection to successful completion of the retried operation.
- Target: p95 <= 2500 ms, max <= 5000 ms.
- Signal:
  - `cad_conflict_recovery_latency_ms_last`
  - `cad_conflict_recovery_latency_ms_max`

### SLO-3: Commit success under contention

- Definition: successful committed writes during contention windows where stale or lock-wait conflicts are observed.
- Target: >= 99.5% over rolling 7 days.
- Signal:
  - numerator: successful write commits after retry/refresh
  - denominator: write attempts during windows with `cad_conflicts_total > 0` or lock-wait conflicts

### SLO-4: Integrity drift

- Definition: detected divergence between revision pointer state and indexed entity snapshot.
- Target: 0 unresolved drifts.
- Signal:
  - `cad_integrity_drift_total`
  - drift remediation backlog must remain zero.

## Phase 0: Baseline Telemetry

### Implemented telemetry signals

- Stale conflicts:
  - backend counter: `cad_core_stale_conflicts_total` (in-process snapshot)
  - frontend counter: `cad_conflicts_total`
- Retry attempts:
  - frontend counter: `cad_conflict_retries_total`
- Duplicate command id replays:
  - backend counter: `drawing_revision_duplicate_command_replays_total` (in-process snapshot)
- Lock waits / contention conflicts:
  - backend counter: `drawing_revision_lock_wait_conflicts_total` (in-process snapshot)
- Crashers:
  - backend counter: `cad_internal_errors_total` (in-process snapshots at service handler boundaries)

### Telemetry locations

- frontend CAD conflict telemetry: `frontend/src/lib/core/stores/cad.ts`
- cad-core stale telemetry snapshot: `services/cad-core-service/internal/service/telemetry.go`
- drawing-revision contention telemetry snapshot: `services/drawing-revision-service/internal/repository/telemetry.go`
- service internal-error snapshots:
  - `services/cad-annotation-service/internal/service/telemetry.go`
  - `services/cad-layer-block-service/internal/service/telemetry.go`
  - `services/interop-service/internal/service/telemetry.go`
  - `services/plot-sheet-service/internal/service/telemetry.go`
  - `services/drawing-revision-service/internal/service/telemetry.go`

## Phase 0: Frozen revision/idempotency contract

The revision and idempotency contract is frozen for compatibility and must not change without a versioned migration plan.

### Error code and metadata headers

Canonical constants are defined in `services/shared/cad/cad.go`:

- `ConflictCodeStaleRevision = stale_revision`
- `HeaderErrorCode = x-solar3d-error-code`
- `HeaderBaseRevisionID = x-solar3d-base-revision-id`
- `HeaderHeadRevisionID = x-solar3d-head-revision-id`
- `HeaderRetryAfter = retry-after`
- `DefaultConflictRetryAfterMs = 300`

### Behavior guarantees

- Stale base revision conflicts must return:
  - code: `stale_revision`
  - current head and base revision metadata headers
  - retry-after hint (seconds)
- Duplicate `command_id` in `drawing-revision-service` must be idempotent replay:
  - return the already committed revision for the same drawing + command id.
- Frontend retries only stale conflicts, never generic write failures.

### Regression policy

Any contract change requires:

1. update to this document,
2. service tests proving backward compatibility,
3. rollout note in deployment docs.

## Phase 1: Critical conflict handling status

Implemented:

- Structured stale-conflict details from commit APIs.
- Idempotent replay for duplicate `command_id`.
- Frontend conflict UX states (`refreshing`, `retrying`, `resolved`, `failed`).
- Bounded exponential backoff with jitter for stale conflicts only.

## Phase 2: Distributed robustness status

Implemented:

- Command-attempt tracking persisted in `drawing_command_attempts` with statuses:
  - `pending`
  - `succeeded`
  - `failed`
- TTL cleanup for expired command attempts on write-path entry.
- Typed outcomes:
  - `stale_base`
  - `lock_timeout`
  - `idempotent_duplicate`
  - `committed`
- Conflict audit trail persisted in `drawing_conflict_events` for rejected commits.
- Optimistic head version marker emitted through `x-solar3d-head-version`.

Persistence and code locations:

- migration: `migrations/007_drawing_revision_robustness.sql`
- attempt/audit persistence: `services/drawing-revision-service/internal/repository/repository.go`
- repository outcome contract: `services/drawing-revision-service/internal/repository/outcomes.go`
- response/error header contract: `services/shared/cad/cad.go`
