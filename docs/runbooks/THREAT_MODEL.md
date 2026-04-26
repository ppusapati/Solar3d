# Solar3D — Threat Model

Framework: **STRIDE** (Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege).
Scope: all 28 backend services, web frontend, mobile app, Rust compute crates, Postgres, object storage.
Format: one row per asset/entry-point, threat category, mitigation, residual risk, owner.

This document is the baseline for external pentest engagement. Update after every architecture-affecting change (new service, new data store, new auth flow).

---

## 1. Assets & Trust Boundaries

| Asset | Sensitivity | Trust boundary |
|---|---|---|
| User credentials (Argon2 hashes) | Critical | Tenant DB schema, never leaves auth-service |
| Session tokens (JWT) | Critical | Signed with per-env private key; verified at gateway |
| Project geometry / layouts | Confidential (customer IP) | Tenant-scoped; RLS-enforced |
| PVsyst / CAD uploads | Confidential | Object storage (S3) with tenant-prefixed keys |
| Financial models | Confidential | Tenant DB + tenant S3 prefix |
| Construction photos (GPS-tagged) | Confidential (site info) | S3, presigned URLs, 15-min expiry |
| Billing data (Stripe customer IDs) | Confidential | Billing service only |
| Compute node credentials (Rust crates ↔ services) | Internal | mTLS within cluster VPC |

Boundaries:
1. **Internet → Gateway** — all external traffic
2. **Gateway → Services** — authenticated, tenant-scoped
3. **Services → DB** — per-service role, least-privilege
4. **Services → Rust compute** — mTLS, short-lived tokens
5. **Services → Object storage** — scoped IAM role
6. **Services → ERP (outbound)** — signed webhooks

---

## 2. Entry Points

| # | Entry point | Protocol | Auth |
|---|---|---|---|
| E1 | `api.solar3d.example.com/*` (gateway) | HTTPS / ConnectRPC | JWT |
| E2 | `solar3d://` deep links (mobile) | URI handler | Session resume |
| E3 | Presigned upload URLs | S3 PUT | Time-limited signature |
| E4 | ERP webhook (inbound) | HTTPS | HMAC-signed |
| E5 | Stripe webhook (inbound) | HTTPS | Stripe signature |
| E6 | Deep-link email clicks | HTTPS → redirect | One-time token |

---

## 3. STRIDE per entry point

### E1 — Gateway (ConnectRPC/HTTPS)

| Threat | Category | Mitigation | Residual |
|---|---|---|---|
| Forged JWT | Spoofing | Asymmetric signing (ES256), key rotation every 90d | Low |
| SQL injection via RPC field | Tampering | sqlc (parameterised queries everywhere); Zod/Go validation at boundary | Low |
| Replay of stolen JWT | Spoofing | Short TTL (15 min) + refresh token rotation; jti blacklist on logout | Medium |
| Credential stuffing on `/auth/login` | Spoofing | Rate limit 5 attempts/5 min per email+IP; exponential backoff; CAPTCHA after 3 | Low |
| Cross-tenant data read | Info disclosure | Tenant ID scoped from JWT, enforced in RLS + service layer (defense-in-depth) | Low |
| Mass scraping (project list) | DoS | Per-tenant request quota; 429 with Retry-After | Medium |
| DDoS | DoS | Cloudflare / WAF upstream; autoscaling | Medium |
| Privilege escalation via role tampering | Elevation | Role derived from JWT claims (server-signed); not accepted from request body | Low |

### E2 — Mobile deep links (`solar3d://`)

| Threat | Category | Mitigation | Residual |
|---|---|---|---|
| Malicious app claims `solar3d://` scheme | Spoofing | Use Universal Links / App Links (domain-verified) in addition to custom scheme | Medium |
| Deep link with crafted payload → RCE in app | Tampering | `parseDeepLink` whitelists path sections + validates UUIDs; no eval / no raw HTML | Low |
| Session token in URL | Info disclosure | Never include tokens in deep-link URIs; use one-time exchange codes | Low |

### E3 — Presigned upload URLs

| Threat | Category | Mitigation | Residual |
|---|---|---|---|
| URL shared, uploaded by third party | Tampering | 15-min expiry; bound to SHA-256 of content (when possible); bound to tenant prefix | Medium |
| Overwrite of existing object | Tampering | S3 object versioning; presigned URL scoped to a new key, not existing | Low |
| Malware upload | Tampering | Virus scan (ClamAV) on upload events; quarantine bucket before promotion | Medium |

### E4 — ERP webhook (inbound)

| Threat | Category | Mitigation | Residual |
|---|---|---|---|
| Forged webhook | Spoofing | HMAC-SHA256 signature, per-tenant shared secret, constant-time compare | Low |
| Replay | Tampering | Nonce + 5-minute window; `replayed_at` check | Low |

### E5 — Stripe webhook

| Threat | Category | Mitigation | Residual |
|---|---|---|---|
| Forged event | Spoofing | `Stripe-Signature` verification via `stripe.Webhook.constructEvent` | Low |
| Duplicate delivery | Tampering | Idempotency key = Stripe event ID; DB unique constraint | Low |

### E6 — Email one-time links

| Threat | Category | Mitigation | Residual |
|---|---|---|---|
| Token reuse / brute force | Spoofing | 128-bit random token, one-time use, 24-hour expiry | Low |
| Token leak via referer | Info disclosure | `Referrer-Policy: no-referrer`; consume token server-side then redirect | Low |

---

## 4. Service-level risks

### Auth service
- Password storage: Argon2id, memory=64MB, iterations=3, parallelism=4. Rotation of hashing params tracked in `auth.password_hash_version`.
- Session revocation: signed tokens + server-side revocation list for the current + previous key epoch.

### Compute orchestration / Rust crates
- Input validation at RPC boundary (panel count cap 200k per layout, polygon vertex cap 10k).
- Compute workloads run in ephemeral containers with read-only root fs; no outbound internet except to object storage.
- Worker-side timeout (default 10 min) with SIGKILL backstop.

### Object storage
- Per-tenant prefix; IAM role scoped by prefix.
- No public buckets. All reads/writes via presigned URLs.
- Versioning + MFA-delete on production buckets.

### Postgres
- Row-level security on every tenant-scoped table (see migration 00X).
- `pgaudit` enabled for DDL + role grants.
- PITR enabled; 30-day retention; DR drill procedure in `DR_DRILL.md`.

### Mobile app
- Secure storage for refresh tokens via `flutter_secure_storage` (Keychain / Keystore).
- Certificate pinning on API base URL (production builds only).
- Jailbreak / root detection with UX gate (warn, not hard block, so legitimate power users aren't blocked).

### Web frontend
- CSP: `default-src 'self'; connect-src 'self' api.solar3d.example.com; img-src 'self' data: https:; style-src 'self' 'unsafe-inline'` (unsafe-inline to be removed when CSS-in-JS migration completes).
- `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`.
- `X-Frame-Options: DENY`; `X-Content-Type-Options: nosniff`.
- Tokens in `Authorization` header only, never in cookies exposed to JS. If using cookies, `Secure; HttpOnly; SameSite=Strict`.

---

## 5. Known un-mitigated residuals (for pentest focus)

1. **Cross-tenant enumeration** via project IDs — UUIDs reduce but do not eliminate. Rate-limit `GET /project/<id>` with NOT_FOUND response time padded to constant to avoid oracle.
2. **Supply-chain** on Rust crates — `cargo audit` + `cargo deny` in CI; no action on transitive trust beyond that.
3. **Prompt-injection if/when AI features expand** — no LLM-in-the-loop features exposed to untrusted input today. Re-evaluate before adding.

---

## 6. External pentest — scope

To be engaged **before** production go-live. Scope:
- Full web + mobile + API surface against staging (prod-equivalent).
- Auth/session, tenant isolation, file upload, deep-link handling, billing webhooks.
- Excludes: DoS testing against shared infra (requires separate arrangement); source-code review (provide on request for grey-box).

Deliverables expected: executive summary, per-finding CVSS, remediation guidance, retest after fixes.

**Owner:** Security engineering
**Cadence:** Annual full engagement; targeted re-scope after any major auth or data-model change.
