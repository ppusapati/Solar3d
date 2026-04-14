# Frontend Step 32: Twin Activation and Lineage Explorer

## Scope
This step adds twin activation UX from approved/as-built context and a lineage explorer that traces operational events back to design revision artifacts.

## Reuse Audit
- Reused existing commissioning workspace and checklist/as-built flows in Commissioning panel.
- Reused workflow phase and transition history from workflow store.
- Reused backend twin-service HTTP contracts as implemented in twin-service handler routes.
- Added a thin frontend twin API wrapper and lineage domain helper; no contract/proto changes.

## Delivered UI
- Twin activation gate tied to:
  - workflow phase Approved or Commissioning Ready
  - completed/signed checklist
  - at least one as-built artifact
  - no active workflow blockers
- Twin state display and refresh action.
- Asset identity linkage from selected as-built revision to physical serial.
- Operational event ingest controls (telemetry batch of one).
- Lineage explorer trail:
  - workflow transition evidence
  - operational event
  - asset identity mapping
  - design revision artifact

## Verification
- Frontend typecheck/check passes with no new errors.
- Unit tests include lineage trail helper behavior.

## Deviation Status
- No Class A/B/C deviation recorded.
