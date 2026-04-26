# Solar3D — On-Call Runbook

## Rotation

- **Primary rotation**: weekly, Monday 09:00 handoff, minimum 3 engineers in the rotation (no lone on-call).
- **Secondary rotation**: weekly, same cadence, offset by one week so primary ≠ secondary.
- **Engineering manager rotation**: monthly; on call for SEV1 and escalations only.
- **Handoff**: 15-min sync at Monday 09:00 in `#solar3d-oncall`. Outgoing covers: open incidents, noisy alerts, in-flight mitigations.

## Compensation

- Weeknight pages (after 18:00, before 09:00): 1h comp time per page + 0.5h buffer.
- Weekend pages: 2h comp time per page.
- Tracked via HR system; manager approves.

## Expectations

- **Ack time**: 5 min (primary), 15 min (secondary).
- **Response time**: mitigation underway within 15 min for SEV1, 30 min for SEV2.
- **During shift**: no releases Friday after 15:00 or before a long weekend. Keep phone charged, laptop accessible, VPN working. Travel requires swap.
- **Outside shift**: not expected to respond. If pulled in for context, that's a signal we need better runbooks — file a ticket.

## Toolkit (must work before shift starts)

- VPN access confirmed
- PagerDuty app installed + test alert ack'd
- kubectl + cluster access verified (`kubectl get pods -n solar3d-prod`)
- Grafana + Prometheus bookmarked
- Access to logs aggregator
- Stripe, S3 console access
- `deploy/staged-rollout.sh` runnable locally
- DB read replica access (never prod primary for ad-hoc queries)

## Common scenarios — one-page playbooks

### "500s from service X"
1. Grafana → service dashboard → correlate with last deploy.
2. If deploy < 2h ago: `deploy/staged-rollout.sh rollback <service>`.
3. If not deploy-related: check DB connections, downstream service health, disk on nodes.
4. If tenant-specific: check tenant quota, look for runaway query.

### "Latency spike"
1. Check p99 vs p50 — if only p99 spiked, long-tail (GC, cold start).
2. Check pod CPU/memory. Scale up.
3. Check DB slow-query log.
4. Check compute job queue depth (backpressure propagates).

### "Compute jobs failing"
1. Check Rust crate version match between orchestrator and worker pods.
2. Check object storage reachability from workers.
3. Check worker memory — 100k-panel layouts can spike. Evict + scale.

### "Login failures"
1. Check auth-service logs for key rotation or JWT lib errors.
2. Check Argon2 latency (param tuning can accidentally make login slow enough to time out).
3. Check rate limiter — attacker-triggered block can affect legit users from same egress IP.

### "Status page lying"
1. Status page is manual — comms lead promotes it. If you're on-call alone at 3am and the page is still green: promote it yourself via the status page admin UI. Conservative wins.

## Noisy alerts

Any alert that pages > 3 times in 2 weeks without actionable intervention is a bug in the alert. File a ticket to tune thresholds or add context. On-call should not be hazing.

## Owner

SRE / platform team. On-call satisfaction is a leading indicator of reliability debt — surveyed quarterly.
