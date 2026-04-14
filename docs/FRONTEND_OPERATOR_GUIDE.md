# Frontend Operator Guide

## Workflow Execution
1. Select active project in dashboard.
2. Confirm role in top bar:
   - Planner: design/cad/simulate
   - Engineer: electrical/transmission
   - Reviewer: reports review access
   - Approver: approval/commissioning/reports/financial controls
   - Operator: commissioning operations
   - Admin: full access
3. Follow canonical chain:
   - Planning -> Layout Ready -> Electrical Ready -> Transmission Ready -> Review Ready -> Approved -> Commissioning Ready
4. Resolve blockers shown in phase rail before attempting blocked actions.

## Twin Activation
1. Ensure workflow phase is Approved or Commissioning Ready.
2. Confirm checklist is completed/signed and as-built artifacts exist.
3. Activate twin from Commissioning panel.
4. Link asset identities and ingest operational events.
5. Use Lineage Explorer to trace event -> identity -> revision.

## Incident Handling
- If a view/action is blocked, read guard reason tooltip or toast and resolve prerequisites.
- For transition failures, refresh workflow state and verify upstream acceptance evidence.
- For API errors, check gateway and service health endpoints.

## Performance Notes
- Workflow polling slows automatically when browser tab is hidden.
- Returning to visible tab resumes standard refresh cadence.
