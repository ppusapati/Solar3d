# Solar3D — Disaster Recovery Drill

## Objectives

- **RPO (data loss tolerance):** 15 minutes
- **RTO (downtime tolerance):** 1 hour
- **Scope:** Postgres restore from PITR, object storage failover to secondary region, reconfiguration of services to the restored DB.

## Pre-requisites

- Managed Postgres with PITR enabled, retention ≥ 30 days.
- Object storage cross-region replication enabled to secondary region.
- Infrastructure-as-code (Terraform) capable of standing up a new cluster in the secondary region in under 30 min.
- Runbook tested quarterly; results logged in `drills/<yyyy>-<qN>.md`.

## Drill scenarios

### Scenario A — Logical corruption (accidental bulk delete)

**Trigger (simulated):** engineer drops a tenant's projects via a bad query.

1. **Stop the bleed** — revoke the role that executed the bad query, disable the affected tenant's writes via feature flag.
2. **Identify the restore point** — inspect audit log, pick a timestamp just before the bad query.
3. **Provision restore instance** — spin up a new Postgres instance from PITR at that timestamp. This is a *read-only side-by-side*, not a replacement for primary.
4. **Reconcile** — script extracts the affected tenant's rows from the restore instance, compares with current primary, re-inserts missing rows inside a transaction.
5. **Re-enable writes** for the tenant.
6. **Validate** — tenant QA or smoke test; confirm project list restored.

### Scenario B — Primary region outage

**Trigger (simulated):** disable the primary region in network config.

1. **Declare SEV1** (`INCIDENT_RESPONSE.md`).
2. **Failover DB** to the secondary-region replica — manual promotion via managed-DB console or `scripts/failover-db.sh`.
3. **Update DNS** — flip `api.solar3d.example.com` to secondary-region gateway (TTL 60s).
4. **Scale up secondary region** — Terraform apply with `region=secondary` variables; wait for all services healthy.
5. **Reconfigure object storage** — services point at secondary-region bucket (env var already baked into secondary-region config).
6. **Verify** — run smoke tests from `scripts/smoke.sh --env=dr`.
7. **Announce restoration** on status page.

## Recording

Each drill must log:
- Start and end wall-clock times (RTO measurement).
- Actual data-loss window (RPO measurement) — compute from last committed txn in restored state vs. simulated incident time.
- Any deviation from runbook.
- Action items for runbook improvements.

## Cadence

- **Quarterly** full drill (Scenario B).
- **Monthly** tabletop (walkthrough without executing, catches stale contact info, expired creds, renamed resources).
- **Annually** full game-day including customer comms dry run.

## Success criteria

- Last drill **RTO < 1h**? _(yes/no — fill during drill)_
- Last drill **RPO < 15 min**? _(yes/no — fill during drill)_
- All runbook steps executed without access gap or unknown dependency? _(yes/no — fill during drill)_

If any answer is "no", the drill is a learning event but not a pass. File action items with 30-day SLA.

## Owner

SRE / platform team. DR drill pass is a gating check for production readiness — see `GO_LIVE_CHECKLIST.md`.
