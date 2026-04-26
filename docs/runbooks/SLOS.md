# Solar3D — Service Level Objectives & Error Budgets

Defines user-visible reliability targets and the error budget policy that governs release velocity.

## SLI / SLO table

| Service | SLI | SLO (rolling 28d) | Error budget |
|---|---|---|---|
| api-gateway | Successful RPCs / total (5xx and request-path timeouts count as failure) | **99.9%** | 40 min 19 sec / 28d |
| api-gateway | Request latency p95 on read RPCs | **< 300 ms** | — |
| api-gateway | Request latency p95 on write RPCs | **< 800 ms** | — |
| project-service, layout-service, asset-service | RPC success rate | **99.9%** | 40 min / 28d each |
| compute-service (sim jobs) | Successful job completion | **99.5%** | 3 hr 21 min / 28d |
| compute-service | Job latency p95 (1k-panel layout) | **< 30 s** | — |
| compute-service | Job latency p95 (100k-panel layout) | **< 5 min** | — |
| report-service | Report generation success | **99.5%** | 3 hr 21 min / 28d |
| report-service | Report latency p95 | **< 60 s** | — |
| auth-service | Login success rate (excluding bad-credential 401s) | **99.95%** | 20 min / 28d |
| ingest / upload (object storage) | PUT success rate | **99.9%** | 40 min / 28d |
| Mobile app | Crash-free sessions | **99.5%** | — |
| Web app | Crash-free sessions | **99.9%** | — |

## Measurement

- Per-service Prometheus counters: `solar3d_rpc_requests_total{service, method, status}`.
- Latency: `solar3d_rpc_duration_seconds{service, method}` histogram, query p95 / p99.
- Compute job metrics: `solar3d_compute_jobs_total{kind, status}`, `solar3d_compute_duration_seconds{kind}`.
- Dashboards: `monitoring/grafana-dashboards.yml` → **Solar3D SLO** board.
- Burn-rate alerts (Google SRE multi-window):
  - **Fast burn**: 2% of 28d budget in 1h → page on-call.
  - **Slow burn**: 5% of 28d budget in 6h → ticket to owning team.

## Error budget policy

1. **Budget remaining > 50%** — normal release cadence; feature work continues.
2. **Budget remaining 20–50%** — warning state. New rollouts must be behind flags. Prioritise any quick-win reliability work.
3. **Budget remaining 0–20%** — reliability freeze. Only bug fixes, reliability improvements, and security patches ship until budget recovers above 50% for 7 consecutive days.
4. **Budget exhausted** — immediate freeze on non-reliability releases. Incident review scheduled. Leadership sign-off required to resume feature releases before recovery.

## Reporting

- Weekly: burn summary posted by SRE bot to #solar3d-reliability.
- Monthly: SLO review in engineering ops meeting; adjust targets only with change-log entry and leadership sign-off.
- Quarterly: customer-facing availability report on status page.

## Dependencies

SLOs above assume the following dependency SLAs. Breach of a dependency's SLA does **not** automatically excuse missing Solar3D's SLO — we own the user experience — but does trigger an error-budget review.

- Postgres (managed) — 99.95%
- Object storage — 99.9%
- Stripe — 99.99%
- Outbound email (SES / equivalent) — 99.9%

## Owner

SRE / platform team. Each service owner is accountable for their service's SLO and for responding to burn alerts within the on-call SLA (see `ONCALL.md`).
