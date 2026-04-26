# Solar3D Data Processing Addendum — TEMPLATE

> **Template notice.** Engineering-authored starter. Qualified legal counsel
> must finalise jurisdictional clauses, SCC module selection, and any
> customer-specific amendments before execution.

This Data Processing Addendum ("DPA") forms part of the Master Subscription
Agreement or equivalent agreement ("Agreement") between Customer and
`[LEGAL_ENTITY_NAME]` ("Solar3D") and applies to Solar3D's processing of
personal data on behalf of Customer.

## 1. Definitions

Capitalised terms not defined here have the meaning in the Agreement or in
applicable Data Protection Law (GDPR, UK GDPR, CCPA/CPRA, LGPD, etc.).

- **Processor / Sub-processor**: as defined in GDPR art. 4.
- **Personal Data**: Customer Content that is personal data of Data
  Subjects (Customer's users, end-users, or invitees).
- **Data Subject Request (DSR)**: exercise of a right listed in §6.

## 2. Subject matter, duration, nature, purpose

- **Subject matter**: processing required to provide the Service.
- **Duration**: for the term of the Agreement, plus the retention periods
  described in the Privacy Policy and §5 below.
- **Nature**: storage, computation, transmission, and backup of Customer
  Content.
- **Purpose**: to deliver the Service as specified in the Agreement.
- **Categories of Data Subjects**: Customer's employees, contractors,
  invitees, and end-users of Customer's projects.
- **Categories of Personal Data**: identification data (name, email),
  account credentials, access logs, and any personal data Customer chooses
  to upload into its tenant.

## 3. Roles

Customer is the **Controller**. Solar3D is the **Processor**. Where
Customer acts as a Processor for its own customer ("Business"), Solar3D
acts as a **Sub-processor**.

## 4. Solar3D obligations

Solar3D will:
- Process Personal Data only on documented instructions from Customer,
  including as configured in the Service and this DPA.
- Ensure persons authorised to process Personal Data are bound by
  confidentiality.
- Implement the technical and organisational measures described in
  **Annex II**.
- Assist Customer in responding to DSRs (see §6).
- Notify Customer without undue delay after becoming aware of a Personal
  Data Breach, and in no case later than 48 hours (or as required by law).
- On expiry of the Agreement, delete or return Personal Data at Customer's
  choice, subject to retention required by law.
- Make available information necessary to demonstrate compliance and
  submit to audits subject to §8.

## 5. Retention & deletion

Upon termination or expiry of the Agreement:
- Customer may export Customer Content for 30 days.
- After 30 days, Solar3D will delete Customer Content per the retention
  policy, except where retention is required by law (e.g., financial
  records for 7 years).
- DSR records are retained for 2 years as compliance evidence.

## 6. Data Subject Requests

Solar3D provides in-product tools and an API for Customer to process
Access, Rectification, Erasure, Portability, and Objection requests. Where
a request is made directly to Solar3D, Solar3D will forward it to Customer
without response unless otherwise instructed. Solar3D will assist Customer
to meet its statutory deadlines (30 days GDPR / 45 days CCPA).

## 7. Sub-processors

Solar3D uses the sub-processors listed at `[SUBPROCESSORS_URL]`, which is
maintained and updated at least 30 days before the addition of a new
sub-processor. Customer may object to a new sub-processor on reasonable
data-protection grounds; if the parties cannot resolve the objection,
Customer may terminate the portion of the Service that relies on the
sub-processor for a pro-rated refund.

## 8. Audits

On reasonable request and subject to confidentiality obligations, Solar3D
will make available to Customer:
- Current SOC 2 Type II report (or equivalent).
- The latest penetration test summary.
- Relevant certifications (ISO 27001, as applicable).

Customer may conduct a supervised on-site audit no more frequently than
annually, at Customer's expense, on 30 days' notice, unless the audit is
compelled by a supervisory authority.

## 9. International transfers

Where Personal Data is transferred outside the EEA / UK / Switzerland, the
parties rely on:
- **EU SCCs** (2021/914) — Module `[TWO_OR_THREE]` with Annexes at **Annex III**.
- **UK IDTA** or UK addendum to the EU SCCs.
- **Swiss FDPIC-compliant** adaptations as required.
- Supplementary measures consistent with EDPB Recommendations 01/2020.

## 10. Liability & precedence

- The liability cap in the Agreement applies to this DPA.
- In case of conflict between this DPA and the Agreement regarding data
  protection, this DPA prevails.

---

## Annex I — Description of processing

- Nature: see §2.
- Purpose: see §2.
- Categories of Data Subjects: see §2.
- Categories of Personal Data: see §2.
- Sensitive data: none expected; Customer must not upload special-category
  data without a written agreement amending this DPA.
- Frequency: continuous for the term.
- Retention: see §5.
- Sub-processors: see `[SUBPROCESSORS_URL]`.

## Annex II — Technical and organisational measures

| Control area | Measure |
|---|---|
| Encryption in transit | TLS 1.2+ everywhere; HSTS with preload |
| Encryption at rest | AES-256 on Postgres, object storage, backups |
| Access control | SSO/OIDC for staff; least-privilege IAM; break-glass with audit |
| Authentication | Argon2id password hashing; MFA for staff |
| Network segmentation | Service-per-namespace; mTLS between services; egress policy |
| Vulnerability management | `govulncheck` / `cargo audit` in CI; monthly patching |
| Pentesting | Annual external engagement; re-test after major changes |
| Logging & monitoring | Centralised audit log (7y retention); SIEM alerts |
| Incident response | Documented runbooks; 48h notification SLA |
| Backups | Daily snapshots; 30-day PITR; cross-region replication |
| DR | Quarterly drills; RTO 1h / RPO 15min |
| Personnel | Background checks (as permitted); annual security training |
| Sub-processor diligence | Documented vendor review; contractual data-protection flow-down |
| Data minimisation | Tenant-scoped storage; no cross-tenant joins |
| DSR tooling | In-product export/delete flows; DPO queue for manual review |

## Annex III — SCCs (completed with Customer details)

`[TO_BE_COMPLETED_PER_CUSTOMER]`

---

*This template reflects the actual technical and organisational measures
implemented in the platform. Counsel must finalise SCC annexes, UK/CH
adaptations, consumer-protection carve-outs, and liability language.*
