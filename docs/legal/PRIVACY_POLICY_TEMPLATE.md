# Solar3D Privacy Policy — TEMPLATE

> **Template notice.** Engineering-authored starter document reflecting the
> system's actual data-handling behaviour. Must be reviewed and tailored by
> qualified legal counsel before publication.

Effective date: `[DATE]`
Contact: `[PRIVACY_CONTACT_EMAIL]`
Data Protection Officer: `[DPO_NAME_EMAIL]` (as required by GDPR art. 37)

## 1. Who we are

Solar3D is operated by `[LEGAL_ENTITY_NAME]`, a company registered in
`[COUNTRY]` under registration number `[REG_NUMBER]`. Registered office:
`[ADDRESS]`.

For customers in the EU/UK/EEA, we act as a **Data Processor** for
Customer Content uploaded by Tenants, and as a **Data Controller** for
account-related personal data we collect directly (billing, support).

## 2. Data we collect

- **Account data**: name, email, hashed password (Argon2id), role.
- **Billing data**: company name, billing address; payment details are
  processed by Stripe — we store only customer/subscription IDs and
  invoice metadata.
- **Tenant content**: project data, CAD uploads, photos, financial models
  — uploaded by Tenant users. Treated as Customer Content under a DPA.
- **Usage telemetry**: device/browser metadata, IP, access logs, feature
  events. Retention: `[USAGE_RETENTION_DAYS]` days.
- **Support data**: messages and attachments in support tickets.

## 3. Legal bases (GDPR art. 6)

- **Contract performance**: providing the Service to Tenants.
- **Legitimate interests**: security, fraud prevention, product improvement
  (balanced against your rights — see Objection below).
- **Legal obligations**: tax, accounting, regulatory.
- **Consent**: optional marketing communications only; you may withdraw
  any time.

## 4. How we use data

- Provide the Service and authenticate users.
- Bill through Stripe (we do not see or store payment card numbers).
- Secure the platform (intrusion detection, audit logging).
- Respond to support requests.
- Aggregate / anonymise usage for product improvement — never re-linked to
  identifiable users.

## 5. Sharing

We share data with:
- **Infrastructure providers** (cloud hosting, managed Postgres, object
  storage) under data-processing agreements. Listed at `[SUBPROCESSORS_URL]`.
- **Stripe** for payment processing.
- **Email provider** for transactional email (`[SES_PROVIDER]`).
- **Error-tracking / observability** (Sentry, Datadog, or equivalent) —
  with PII minimisation configured.
- **Law enforcement** only when required by law; we notify affected users
  unless prohibited.

## 6. International transfers

Data may be transferred to and processed in `[HOSTING_REGIONS]`. For
EU/EEA/UK personal data, transfers outside the EEA rely on Standard
Contractual Clauses and supplementary measures as described in our DPA.

## 7. Retention

- Active accounts: retained while active.
- Deleted accounts: hard-deleted 30 days after deletion request.
- Audit logs: 7 years (contractual and regulatory).
- Project data under enterprise contracts: 7 years (warranty and defect
  claim horizon).
- DSR records: 2 years from completion (compliance evidence).

See `retention_policies` table in the system for current enforced values.

## 8. Your rights

Under GDPR / CCPA / other applicable law you may:
- **Access** the personal data we hold about you.
- **Rectify** inaccurate data.
- **Erase** data ("right to be forgotten").
- **Port** your data in a machine-readable format.
- **Object** or restrict certain processing.
- **Withdraw consent** for marketing.
- **Lodge a complaint** with a supervisory authority (e.g. your national
  Data Protection Authority in the EU, ICO in the UK, state Attorney General
  in US states with applicable law).

To exercise a right, submit a request at `[DSR_PORTAL_URL]` or email
`[PRIVACY_CONTACT_EMAIL]`. We respond within 30 days (GDPR) or 45 days
(CCPA), whichever applies. We may need to verify your identity.

## 9. Security

We implement administrative, technical, and physical safeguards including
encryption in transit (TLS 1.2+), encryption at rest for all persistent
data, role-based access control, least-privilege IAM, audit logging,
regular third-party penetration testing, and formal incident response.
Details at `[SECURITY_WHITEPAPER_URL]`.

## 10. Children

The Service is not directed to children under 16 and we do not knowingly
collect personal data from them.

## 11. Cookies & similar technologies

We use strictly necessary cookies for authentication and a minimal set of
analytics cookies. Where required, we show a consent banner. See our
Cookie Notice at `[COOKIE_NOTICE_URL]`.

## 12. Changes

We will post material changes here and notify account administrators at
least 30 days before the effective date.

---

*This template reflects the actual data flows implemented in the platform:
Argon2id-hashed passwords, Stripe for payments, multi-tenant architecture
with DPO queue, 30-day account deletion grace period, 7-year project
retention, 2-year DSR record retention, GDPR/CCPA DSR workflow in
`services/packages/privacy`. Counsel must adapt jurisdictional specifics
(state-level US privacy law updates, UK post-Brexit DPA wording, EDPB
guidance) before publication.*
