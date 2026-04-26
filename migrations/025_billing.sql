-- 025_billing.sql
-- Billing tables. Solar3D bills per tenant with:
--   * a plan (fixed monthly subscription with baseline entitlements),
--   * metered overages (panels simulated, compute minutes, seats over plan).
--
-- Stripe is the source of truth for money; these tables are our local
-- projection so we can enforce entitlements inline without an external call
-- on every request and survive short Stripe outages.
BEGIN;

CREATE TYPE billing_plan_tier AS ENUM ('trial','starter','pro','enterprise');
CREATE TYPE billing_status    AS ENUM ('active','past_due','canceled','trialing','incomplete');

CREATE TABLE billing_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tier billing_plan_tier NOT NULL UNIQUE,
  stripe_product_id TEXT NOT NULL,
  stripe_price_id   TEXT NOT NULL,
  monthly_price_cents INT NOT NULL,
  currency TEXT NOT NULL DEFAULT 'USD',
  -- baseline entitlements — overage metered separately
  included_seats       INT NOT NULL,
  included_projects    INT NOT NULL,
  included_compute_min INT NOT NULL,
  included_panels_mo   INT NOT NULL,
  overage_cents_per_seat      INT NOT NULL DEFAULT 0,
  overage_cents_per_compute   INT NOT NULL DEFAULT 0,
  overage_cents_per_kpanel    INT NOT NULL DEFAULT 0, -- per 1000 panels
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE billing_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL UNIQUE,
  plan_id UUID NOT NULL REFERENCES billing_plans(id),
  stripe_customer_id TEXT NOT NULL,
  stripe_subscription_id TEXT NOT NULL,
  status billing_status NOT NULL,
  current_period_start TIMESTAMPTZ NOT NULL,
  current_period_end   TIMESTAMPTZ NOT NULL,
  cancel_at_period_end BOOLEAN NOT NULL DEFAULT FALSE,
  trial_ends_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_subs_status ON billing_subscriptions(status);

CREATE TABLE billing_usage (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL,
  period_start DATE NOT NULL,
  period_end   DATE NOT NULL,
  metric TEXT NOT NULL,             -- 'seats','compute_minutes','panels_simulated'
  quantity BIGINT NOT NULL DEFAULT 0,
  last_reported_quantity BIGINT NOT NULL DEFAULT 0,
  last_reported_at TIMESTAMPTZ,
  stripe_subscription_item_id TEXT, -- where we report the metered value
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (tenant_id, period_start, metric)
);
CREATE INDEX idx_usage_tenant_period ON billing_usage(tenant_id, period_start);

CREATE TABLE billing_invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL,
  stripe_invoice_id TEXT NOT NULL UNIQUE,
  amount_due_cents BIGINT NOT NULL,
  amount_paid_cents BIGINT NOT NULL DEFAULT 0,
  currency TEXT NOT NULL,
  status TEXT NOT NULL,
  hosted_invoice_url TEXT,
  pdf_url TEXT,
  period_start TIMESTAMPTZ NOT NULL,
  period_end   TIMESTAMPTZ NOT NULL,
  finalized_at TIMESTAMPTZ,
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Idempotency for Stripe webhooks — event IDs are unique per account.
CREATE TABLE billing_webhook_events (
  stripe_event_id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  error TEXT
);

COMMIT;
