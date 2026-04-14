# Frontend Step 33: Integration Hardening

## Scope
This step hardens frontend integration for workflow execution with role-based view guards, end-to-end workflow guard tests, and polling performance tuning.

## Deliverables
- Role-based guards layered on top of existing phase/blocker guards.
- Guard logic centralized in a single domain helper for consistent behavior.
- E2E-style workflow guard tests covering canonical phase progression and blocked/unauthorized cases.
- Workflow polling tuned by visibility state to reduce background load.

## Reuse Audit
- Reused existing workflow phase/blocker model and shell guard wiring.
- Reused top-bar navigation and view guard plumbing.
- Extended workflow store polling strategy; no new API contracts added.

## Validation
- Frontend check passes (0 errors, only pre-existing warnings outside this step).
- Unit tests pass with new workflow guard coverage.

## Deviation Status
- No Class A/B/C deviation.
