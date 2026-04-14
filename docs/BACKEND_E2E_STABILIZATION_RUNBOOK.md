# Backend E2E Stabilization Runbook (Step 25)

This runbook documents the verification flow for backend phase stabilization:

PLANNING -> LAYOUT_READY -> ELECTRICAL_READY -> TRANSMISSION_READY -> REVIEW_READY -> APPROVED -> COMMISSIONING_READY

The commissioning handoff must contain all twin provisioning linkages:
- review_approved_layout_id
- electrical_analysis_id
- transmission_route_id
- asset_identity_mappings[]

## Preconditions

- Go workspace builds successfully.
- Project service workflow tests are up to date.
- Twin service tests are up to date.

## Validation Commands

Run from repository root on Windows PowerShell:

```powershell
cd services/project-service
go test ./... -count=3
go build ./...

cd ../twin-service
go test ./... -count=3
go build ./...
```

## Expected Outcome

- All tests pass across repeated runs (`-count=3`) to demonstrate stable pass behavior.
- Project-service E2E test `TestWorkflowService_EndToEnd_BoundaryToCommissioning_TwinProvisioningHandoff` passes.
- Handoff payload assertions verify complete commissioning linkage for twin provisioning.

## Incident Handling

If any transition fails:

1. Capture transition error and active blocker reasons.
2. Verify IncidentReason persistence in workflow state.
3. Re-run only failing package with verbose output:

```powershell
go test ./internal/service -run EndToEnd -count=1 -v
```

4. Apply local (Class A) fixes in the same step if no contract boundary is changed.
5. If contract boundary is changed, classify and log deviation before proceeding.
