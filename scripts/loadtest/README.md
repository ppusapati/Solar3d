# Solar3D load testing

## Prereqs
- k6 ≥ 0.49 (https://k6.io)
- A dedicated staging environment with seeded test tenant + N test projects
- Bearer token for the test tenant (service account, not a human user)

## Seed fixtures
Run `scripts/loadtest/seed.sh <api-base> <token>` once per staging rebuild. Creates 10 projects, 3 layouts each, returns IDs to stdout — pass them as `TEST_PROJECT_IDS=...` to k6.

## Run baseline
```
k6 run \
  -e API_BASE=https://staging.solar3d.example.com \
  -e TOKEN=$STAGING_TOKEN \
  -e TEST_PROJECT_IDS=<csv> \
  --out experimental-prometheus-rw=http://prom:9090/api/v1/write \
  --tag env=staging \
  scripts/loadtest/k6-baseline.js
```

## Gating in CI
The `thresholds` block in `k6-baseline.js` fails the run if SLOs are not met. CI job treats non-zero exit as a release-blocker when run against the pre-production environment.

## Scenarios
| Scenario | Purpose |
|---|---|
| baseline | 500-VU steady-state mixed read/write. Validates p95 SLOs. |
| write_heavy | 100 VUs creating small layouts. Validates write path + DB headroom. |
| large_layout | 20 VUs posting 100k-panel layouts. Validates compute-service timeout + memory. |
| auth_storm | Burst of bad logins. Validates rate limiter doesn't 500 under pressure. |

## Owner
SRE / platform team. Re-run before every production release.
