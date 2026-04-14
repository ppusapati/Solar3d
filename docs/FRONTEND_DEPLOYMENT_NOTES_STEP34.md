# Frontend Deployment Notes (Step 34)

## Build and Run
- Install dependencies: `pnpm install`
- Validate: `pnpm run check` and `pnpm run test`
- Build: `pnpm run build`
- Preview: `pnpm run preview`

## Environment
- `VITE_API_BASE_URL`:
  - Empty for local proxy setup
  - Set explicit base URL for staging/production gateway

## Runtime Expectations
- Workflow/phase guards are enforced in UI and navigation.
- Role selection in top bar controls view accessibility for operator personas.
- Commissioning panel includes twin activation and lineage trace tools.

## Rollout Guidance
1. Deploy backend services first (project/workflow/transmission/commissioning/twin).
2. Verify gateway routing for `/api/v1/twins/*`.
3. Deploy frontend build and run smoke checks for phase guards and commissioning flows.
4. Execute operator guide walkthrough for final acceptance.
