# Solar3D Sub-processors — TEMPLATE

> Maintained by: `[PRIVACY_OWNER]`. Updated at least 30 days before adding
> a new sub-processor. Customers subscribed to updates receive notification
> at `[SUBPROCESSOR_NOTIFY_URL]`.

Last updated: `[DATE]`

| Sub-processor | Purpose | Location | Certifications |
|---|---|---|---|
| `[CLOUD_PROVIDER]` (e.g., AWS / GCP / Azure) | Compute, storage, managed Postgres | `[REGIONS]` | SOC 2, ISO 27001, GDPR SCC |
| Stripe, Inc. | Payment processing | US, EU | PCI-DSS Level 1, SOC 2 |
| `[EMAIL_PROVIDER]` (e.g., Amazon SES, Postmark) | Transactional email | US/EU | SOC 2 |
| `[OBSERVABILITY_PROVIDER]` (e.g., Datadog, Honeycomb) | Logs, metrics, traces | US/EU | SOC 2 |
| `[ERROR_TRACKING]` (e.g., Sentry) | Crash reporting | US/EU | SOC 2 |
| `[SUPPORT_TOOL]` (e.g., Zendesk / Intercom) | Customer support tickets | US/EU | SOC 2 |
| `[CDN_WAF]` (e.g., Cloudflare) | Edge delivery, WAF, DDoS | Global | SOC 2, ISO 27001 |

## Regional data residency

Customers on the `[ENTERPRISE_EU_ADDON]` may elect EU-only residency.
Data residency decisions are enforced at infrastructure level (region
pinning for Postgres, object storage, and compute workloads).

## Change notification

To subscribe to sub-processor change notifications, visit
`[SUBPROCESSOR_NOTIFY_URL]` or email `[PRIVACY_CONTACT_EMAIL]`.
