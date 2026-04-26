# Database Backup & Point-in-Time Recovery (PITR) Runbook

Scope: PostgreSQL clusters backing Solar3D services. Covers scheduled base
backups, continuous WAL archiving, restore procedure, and validation drills.

**Status**: procedure documented — **not yet exercised against production**.
The DR drill referenced in §7 has not been run; mark this runbook as validated
only after a successful drill.

---

## 1. Objectives

| Metric | Target |
|---|---|
| RPO (recovery point objective) | ≤ 5 minutes |
| RTO (recovery time objective) | ≤ 60 minutes |
| Base backup cadence | daily, 02:00 UTC |
| WAL archive cadence | continuous, ≤ 60s lag |
| Backup retention | 30 days base + 30 days WAL |
| Off-site copy | ≥ 2 regions |

## 2. Architecture

```
┌─────────────────┐   streaming replication   ┌──────────────────┐
│ Postgres primary│ ─────────────────────────►│ Postgres standby │
└────────┬────────┘                           └──────────────────┘
         │ archive_command
         ▼
┌─────────────────┐   lifecycle rules         ┌──────────────────┐
│  S3 / blob bucket│ ─────────────────────────►│ Glacier / cold   │
│  (wal + base)   │                           │ archive          │
└─────────────────┘                           └──────────────────┘
```

- **Primary** takes writes; `archive_command` ships every WAL segment to an
  object store as it closes.
- **Standby** replays WAL in real time for HA failover (≠ backup).
- **S3 / blob bucket** holds base backups and WAL archive. Versioning + object
  lock prevent accidental deletion. Bucket is replicated to a second region.
- **Glacier / cold archive** absorbs backups older than 30 days.

## 3. Postgres configuration

Required `postgresql.conf` settings on the primary:

```
# WAL archiving
wal_level = replica
archive_mode = on
archive_command = 'pgbackrest --stanza=solar3d archive-push %p'
archive_timeout = 60s

# Replication (for standby + PITR replay)
max_wal_senders = 10
wal_keep_size = 2GB
hot_standby = on
```

Use **pgBackRest** (recommended) or `pg_basebackup` + WAL-G. The rest of this
runbook assumes pgBackRest.

`pgbackrest.conf`:

```ini
[global]
repo1-path=/var/lib/pgbackrest
repo1-type=s3
repo1-s3-bucket=solar3d-db-backups
repo1-s3-endpoint=s3.amazonaws.com
repo1-s3-region=us-east-1
repo1-retention-full=30
repo1-retention-diff=14

start-fast=y
compress-type=zst
compress-level=3

[solar3d]
pg1-path=/var/lib/postgresql/16/main
pg1-port=5432
pg1-user=postgres
```

## 4. Scheduled operations

### 4.1 Base backup

Daily full backup at 02:00 UTC via systemd timer or cron on the primary:

```bash
# /etc/cron.d/pgbackrest
0 2 * * * postgres pgbackrest --stanza=solar3d --type=full backup
```

Weekly differential (Sundays) to speed up restore:

```bash
0 3 * * 0 postgres pgbackrest --stanza=solar3d --type=diff backup
```

### 4.2 Monitoring

Prometheus exporters (see §0.2 of the roadmap) must alert on:

- `pgbackrest_backup_age_hours > 26` — missed daily backup
- `pg_archiver_failed_count > 0` — WAL archive stuck
- `pg_replication_lag_bytes > 50MB` — standby falling behind

Add these rules to Alertmanager at `HIGH` severity — paging.

### 4.3 Weekly verification (non-destructive)

Every Sunday, restore the latest backup to an isolated verification host and
run smoke queries. Automated via CI:

```bash
pgbackrest --stanza=solar3d --delta restore
pg_ctl -D /var/lib/postgresql/16/verify start
psql -c "SELECT count(*) FROM projects" -c "SELECT max(updated_at) FROM projects"
```

Failure pages the on-call.

## 5. Point-in-Time Recovery

Target scenarios: logical corruption (bad migration, accidental `DELETE`), data
loss from a specific time window.

**Step-by-step on a fresh host:**

1. **Identify the target recovery time.** Prefer a specific timestamp over
   an XID. Check application logs or audit tables to pin the exact moment
   before the bad write.

   ```
   RECOVERY_TARGET=2026-04-15T09:14:30+00:00
   ```

2. **Provision a restore host** with the same Postgres major version as prod.
   Do NOT restore over the live primary — always restore to a sibling.

3. **Stop any running Postgres on the restore host.**

   ```bash
   sudo systemctl stop postgresql
   sudo rm -rf /var/lib/postgresql/16/main/*
   ```

4. **Restore base backup + replay WAL to the target.**

   ```bash
   pgbackrest --stanza=solar3d \
     --type=time --target="$RECOVERY_TARGET" \
     --target-action=promote \
     restore
   ```

5. **Start Postgres and wait for recovery to complete.**

   ```bash
   sudo systemctl start postgresql
   # Watch the log; recovery finishes when "archive recovery complete" appears.
   sudo journalctl -u postgresql -f
   ```

6. **Verify data.** Run the same smoke queries from §4.3 plus domain-specific
   checks (are the deleted rows back? is the broken migration absent?).

7. **Cut over.** If verified, promote the restored host to primary:

   - Update DNS / load balancer to point apps at the restored host.
   - Rebuild a fresh standby from the new primary.
   - Re-seed pgBackRest stanza (`stanza-create --force`).

**Rollback:** if verification fails, destroy the restore host and try a
different recovery target. The live primary is untouched.

## 6. Failure modes and responses

| Symptom | Likely cause | Action |
|---|---|---|
| `archive_command` failing | S3 credentials expired / bucket missing | Check IAM role, re-run `pgbackrest check` |
| Base backup skipped | Disk full on repo host | Expire old backups manually: `pgbackrest expire --stanza=solar3d` |
| Restore halts at WAL gap | WAL segment missing from archive | Fall back to older base backup; accept greater data loss |
| Standby broken after failover | Timeline divergence | `pg_rewind` or rebuild standby from new base backup |

## 7. DR drill (**not yet run**)

The drill validates the full RPO/RTO targets end-to-end. Until completed, §1
numbers are aspirational.

Drill procedure:

1. Pick a past timestamp within the last 24h. Record current row counts.
2. Execute §5 end-to-end on a clean host from S3 only (no local copies).
3. Measure: clock time from §5.3 to §5.6 success — must be ≤ 60 minutes.
4. Confirm row counts match the target timestamp.
5. File drill report in `docs/runbooks/drills/<date>.md`.

Frequency: quarterly. Next drill: **TBD — schedule after production go-live**.

## 8. References

- [pgBackRest documentation](https://pgbackrest.org/)
- [Postgres continuous archiving](https://www.postgresql.org/docs/16/continuous-archiving.html)
- Internal: [DEPLOYMENT_RUNBOOK.md](../DEPLOYMENT_RUNBOOK.md)
- Solar3D roadmap: [§0.6](../ROADMAP_TO_COMPLETE.md) (infrastructure)
  and [§7](../ROADMAP_TO_COMPLETE.md) (DR drill acceptance criteria)
