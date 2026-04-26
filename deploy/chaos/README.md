# Solar3D chaos experiments

Manifests target **staging only** — `solar3d-staging` namespace. They must never be applied to production without a game-day declared in `#solar3d-incidents` and an IC on standby.

## Experiments

| File | What it does | Pass criteria |
|---|---|---|
| `network-partition-db.yaml` | Cuts project-service off from Postgres primary for 5 min | Writes fail fast with 503; reads from replica continue; circuit breaker opens; recovery < 30s after partition heals |
| `pod-kill-compute.yaml` | Kills one compute worker every 2 min for 30 min | Job success rate > 99%; no stuck jobs in queue |
| `cpu-stress-gateway.yaml` | 95% CPU on one gateway pod for 10 min | HPA scales out; p95 latency recovers in 3 min |
| `io-latency-object-storage.yaml` | 500ms latency on 50% of object-storage reads for report-service | Reports still succeed; slow-storage metric fires |

## Running

```
kubectl apply -f deploy/chaos/<experiment>.yaml
# observe dashboards + alerts
kubectl delete -f deploy/chaos/<experiment>.yaml   # cleanup when done or auto-expires on `duration`
```

## Game-day cadence

Monthly, rotating through the experiment list. Results captured in `drills/<yyyy>-<month>-chaos.md`:
- Observed vs expected behaviour
- Dashboards / alerts that fired
- Any customer-visible impact (there should be none on staging — but measure)
- Action items for gaps

## Owner

SRE / platform team.
