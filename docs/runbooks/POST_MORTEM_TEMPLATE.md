# Post-Mortem: &lt;short title&gt;

**Date:** YYYY-MM-DD
**Severity:** SEV1 / SEV2 / SEV3
**Incident commander:** @name
**Authors:** @names
**Status:** Draft / Published

## Summary

Two sentences. What was affected, for how long, what did customers see.

## Impact

- Customers affected: N (tenants) / N (users)
- Duration: HH:MM to HH:MM UTC (X minutes)
- Error budget consumed: X% of 28-day budget
- Revenue impact (if quantifiable): $X
- Data loss: none / &lt;scope&gt;

## Timeline (UTC)

| Time | Event |
|---|---|
| HH:MM | First alert |
| HH:MM | On-call ack |
| HH:MM | Incident declared SEV? |
| HH:MM | Mitigation started |
| HH:MM | User impact ended |
| HH:MM | Fully resolved |

## Root cause

Plain-English explanation of the technical cause. Avoid "human error" — describe the *system* that allowed the human action to have this outcome.

## Contributing factors

- Monitoring gaps that delayed detection
- Tooling gaps that delayed mitigation
- Process gaps (missing runbook, unclear ownership)

## What went well

Keep this section honest and full. Good responses happen because people practised — identify what to repeat.

## What went wrong

- Detection slow because …
- Mitigation required manual step that could have been automated
- Runbook missing for this scenario

## Action items

| ID | Action | Owner | Severity | Due |
|---|---|---|---|---|
| AI-1 | Add alert on metric X | @name | Critical | YYYY-MM-DD |
| AI-2 | Document procedure Y in runbook | @name | Medium | YYYY-MM-DD |
| AI-3 | Add integration test for regression | @name | High | YYYY-MM-DD |

Critical items: due within 2 weeks. Others within a quarter.

## Lessons

One or two paragraphs. What did we learn as an organisation? How does this change how we build or operate?

---

*This post-mortem is blameless. It analyses systems, not individuals.*
