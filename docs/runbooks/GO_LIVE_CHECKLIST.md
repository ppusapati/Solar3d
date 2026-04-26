# Solar3D — Production Go-Live Checklist

Gating checklist. Every item must be **signed off by name and date** before
first paying customer. Any "no" answer is a go/no-go discussion, not a
warning.

## Security

- [ ] External pentest against staging completed; all critical / high findings remediated or documented with acceptance rationale. Report stored at `[TRUST_URL]`. *Owner:* Security eng. *Signed off:*
- [ ] `cargo audit`, `govulncheck`, `npm audit --omit=dev`, Snyk (or equivalent) clean on main branch. *Owner:* Platform. *Signed off:*
- [ ] All external endpoints on HTTPS with HSTS preload; TLS 1.2+ enforced. *Owner:* Platform. *Signed off:*
- [ ] Secrets in secret manager only; no secrets in env files, git, or CI logs. *Owner:* Platform. *Signed off:*
- [ ] Break-glass admin access audited and alerted. *Owner:* SRE. *Signed off:*
- [ ] Threat model (`runbooks/THREAT_MODEL.md`) reviewed in the last 90 days. *Owner:* Security. *Signed off:*
- [ ] Tenant isolation verified in pentest scope (not just internal review). *Owner:* Security. *Signed off:*

## Reliability

- [ ] SLOs defined per service (`runbooks/SLOS.md`). *Owner:* SRE. *Signed off:*
- [ ] Burn-rate alerts wired and tested (fire a test alert; page the right person). *Owner:* SRE. *Signed off:*
- [ ] Load test passed at 500 VUs sustained 15 min (`scripts/loadtest/k6-baseline.js`). Results archived. *Owner:* SRE. *Signed off:*
- [ ] Large-layout test passed (100k panels < 5 min p95). *Owner:* SRE. *Signed off:*
- [ ] Chaos-test experiments run at least once each (`deploy/chaos/`). *Owner:* SRE. *Signed off:*
- [ ] DR drill passed in the last 90 days — RTO < 1h, RPO < 15min (`runbooks/DR_DRILL.md`). *Owner:* SRE. *Signed off:*
- [ ] Backups verified by restore test (not just backup creation). *Owner:* SRE. *Signed off:*
- [ ] Autoscaling HPA limits set and tested. *Owner:* SRE. *Signed off:*
- [ ] Database slow-query log reviewed; no query > 500ms on top-10 endpoints. *Owner:* Platform. *Signed off:*

## Operational readiness

- [ ] On-call rotation staffed with ≥ 3 engineers (`runbooks/ONCALL.md`). *Owner:* Eng manager. *Signed off:*
- [ ] Incident process rehearsed (tabletop in last 60 days, `runbooks/INCIDENT_RESPONSE.md`). *Owner:* Eng manager. *Signed off:*
- [ ] Status page configured; DNS + automation verified. *Owner:* SRE. *Signed off:*
- [ ] All runbooks up to date: `ONCALL`, `INCIDENT_RESPONSE`, `DR_DRILL`, `DEPLOYMENT_RUNBOOK`, `POST_MORTEM_TEMPLATE`. *Owner:* SRE. *Signed off:*
- [ ] Monitoring dashboards exist for every service; link from service README. *Owner:* Platform. *Signed off:*

## Data & compliance

- [ ] GDPR/CCPA DSR workflow tested end-to-end (`services/packages/privacy`). Access + erasure tested with real data. *Owner:* DPO. *Signed off:*
- [ ] Retention policies applied (`migrations/024_data_retention.sql`); daily sweeper scheduled. *Owner:* Platform. *Signed off:*
- [ ] Audit log tamper-evidence (append-only, 7-year retention) verified. *Owner:* Security. *Signed off:*
- [ ] Data-residency guarantees documented and enforced at infrastructure level. *Owner:* Platform + Legal. *Signed off:*
- [ ] DPO appointed (if required by jurisdiction) and contact published. *Owner:* Legal. *Signed off:*

## Billing

- [ ] Stripe account in production mode (not test). *Owner:* Finance. *Signed off:*
- [ ] Tax registration complete in operating jurisdictions. *Owner:* Finance. *Signed off:*
- [ ] Invoice template reviewed by Finance and Legal. *Owner:* Finance. *Signed off:*
- [ ] Webhook signature verification tested against real Stripe events (`services/packages/billing`). *Owner:* Platform. *Signed off:*
- [ ] Metered usage reporting tested with synthetic load. *Owner:* Platform. *Signed off:*
- [ ] Dunning / past-due flow tested (failed payment → warning → access degradation → cancel). *Owner:* Platform + Finance. *Signed off:*

## Legal

- [ ] Terms of Service published, counsel-reviewed (`legal/TERMS_OF_SERVICE_TEMPLATE.md` → final). *Owner:* Legal. *Signed off:*
- [ ] Privacy Policy published, counsel-reviewed. *Owner:* Legal. *Signed off:*
- [ ] DPA available for customer signature (`legal/DPA_TEMPLATE.md` → final). *Owner:* Legal. *Signed off:*
- [ ] Sub-processor list published and notification channel live. *Owner:* Legal. *Signed off:*
- [ ] Cookie banner (where required) live and correctly gating non-essential cookies. *Owner:* Web. *Signed off:*
- [ ] Accessibility statement published (WCAG 2.1 AA conformance claim backed by audit). *Owner:* Frontend. *Signed off:*

## Product readiness

- [ ] All P0 bugs closed. *Owner:* PM. *Signed off:*
- [ ] Known-issue list published in help centre. *Owner:* PM. *Signed off:*
- [ ] Customer onboarding flow usability-tested with ≥ 5 target users. *Owner:* PM. *Signed off:*
- [ ] In-product help/docs aligned with shipped behaviour. *Owner:* PM + Docs. *Signed off:*
- [ ] Support playbook + ticket routing configured. *Owner:* Support. *Signed off:*
- [ ] Mobile app approved in iOS App Store and Google Play. *Owner:* Mobile. *Signed off:*

## Launch

- [ ] Comms plan approved (announcement email, blog, socials). *Owner:* Marketing. *Signed off:*
- [ ] Launch-day on-call schedule published. *Owner:* SRE. *Signed off:*
- [ ] Rollback plan for launch-day issues documented and rehearsed. *Owner:* SRE. *Signed off:*
- [ ] Post-launch review scheduled within 2 weeks. *Owner:* Eng manager. *Signed off:*

---

**Final go / no-go decision:** `[DATE]` — `[DECIDER_ROLE_AND_NAME]` — Go / No-Go
