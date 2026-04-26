# Solar3D — Incident Response Runbook

Covers declaration, severity, roles, communication, and post-incident review.

## Severity

| Sev | Criteria | Response time | Comms |
|---|---|---|---|
| **SEV1** | Customer-visible outage of core flow (can't log in / can't create layout / simulations all failing); data loss; security breach | Page on-call + engineering manager in 5 min | Status page + customer email within 30 min; updates every 30 min |
| **SEV2** | Degraded experience for many customers (high error rate, significant slowdown, feature broken for a tenant) | Page on-call in 15 min | Status page within 1h; updates every 2h |
| **SEV3** | Single-tenant issue, non-core feature broken, burn alert without user impact | Ticket, next business day | Internal only |
| **SEV4** | Cosmetic, no functional impact | Backlog | None |

## Roles

- **Incident Commander (IC)** — coordinates, makes decisions, is **not** the person doing the fix. Usually the on-call engineer for SEV2+; engineering manager for SEV1.
- **Ops lead** — the engineer executing mitigations.
- **Comms lead** — posts updates to status page, #solar3d-incidents, customer email. Usually the IC for SEV2; separate person for SEV1.
- **Scribe** — captures timeline in the incident channel. Anyone in the room.

## Declaration

1. Anyone can declare: `/incident declare sev=2 title="layout-service 500s"` in Slack.
2. Bot creates:
   - `#inc-YYYYMMDD-<slug>` channel
   - Google Doc timeline from template
   - Status-page incident (private until comms lead promotes)
3. On-call paged via PagerDuty with severity + link.

## During incident

- **First 5 minutes:** assess scope, declare severity, assign roles. Don't start fixing alone — get the scribe/comms in place first.
- **Mitigate before root cause.** Acceptable mitigations (in order of preference):
  1. Rollback the last deploy (`deploy/staged-rollout.sh rollback`).
  2. Feature-flag the affected code path.
  3. Scale up the affected service.
  4. Shed load (429 non-critical endpoints).
  5. Failover (see `DR_DRILL.md` for DB failover).
- **Comms cadence:** SEV1 every 30 min even if "no update"; SEV2 every 2h. Silence is worse than a boring update.
- **End the incident when:** core flows are restored, error budget burn has stopped, no new customer reports in 30 min.

## Post-incident

1. **Within 24h:** IC closes status page, sends "resolved" customer email for SEV1/SEV2.
2. **Within 5 business days:** blameless post-mortem published. Template: `runbooks/POST_MORTEM_TEMPLATE.md`.
3. **Post-mortem review meeting** — action items logged with owners and due dates. Review tracker in weekly engineering ops.
4. **Action item SLA:** critical ones within 2 weeks; others within 1 quarter. Carry-over beyond 2 quarters escalates to leadership.

## Escalation

| From | To | When |
|---|---|---|
| On-call | Secondary on-call | No ack in 15 min, or on-call needs help |
| On-call / IC | Engineering manager | SEV1, security incident, or data loss |
| Engineering manager | VPE + leadership | SEV1 lasting > 1h, any data breach, regulatory impact |
| VPE | Legal + comms | Security breach with customer data exposure, regulatory reporting trigger |

Contacts: maintained in PagerDuty + `runbooks/CONTACTS.md` (not in git; managed via secrets tool).

## Blameless principle

Post-mortems analyse systems, not people. "Engineer X pushed a bad config" is not a root cause — the root cause is that a bad config could be pushed without a check that would have caught it. Every post-mortem asks: *what system change would have prevented this or detected it faster?*

## Owner

SRE / platform team.
