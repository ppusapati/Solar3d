// Package billing wraps Stripe subscription billing with metered usage.
//
// Responsibilities:
//   * Maintain a local projection of plans, subscriptions, and invoices so
//     that entitlement checks don't round-trip to Stripe on every request.
//   * Aggregate per-tenant usage counters (seats, compute minutes, panels
//     simulated) and report them to Stripe as metered-usage records at
//     regular intervals.
//   * Verify and apply Stripe webhook events idempotently.
//   * Expose an EntitlementChecker that other services call before allowing
//     a quota-governed action.
//
// The package is Stripe-facing but does not import the stripe-go SDK — the
// Gateway interface is small and stable so tests can inject a fake, and
// real impls can use stripe-go or stripe's REST API directly. Keeping the
// boundary thin here makes SDK upgrades and regional re-exports manageable.
package billing

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
)

// Tier identifies the plan bucket.
type Tier string

const (
	TierTrial      Tier = "trial"
	TierStarter    Tier = "starter"
	TierPro        Tier = "pro"
	TierEnterprise Tier = "enterprise"
)

// SubscriptionStatus mirrors Stripe's subscription statuses we care about.
type SubscriptionStatus string

const (
	StatusActive     SubscriptionStatus = "active"
	StatusPastDue    SubscriptionStatus = "past_due"
	StatusCanceled   SubscriptionStatus = "canceled"
	StatusTrialing   SubscriptionStatus = "trialing"
	StatusIncomplete SubscriptionStatus = "incomplete"
)

// Plan is a local projection of billing_plans.
type Plan struct {
	ID                      uuid.UUID
	Tier                    Tier
	StripeProductID         string
	StripePriceID           string
	MonthlyPriceCents       int
	Currency                string
	IncludedSeats           int
	IncludedProjects        int
	IncludedComputeMinutes  int
	IncludedPanelsPerMonth  int
	OverageCentsPerSeat     int
	OverageCentsPerCompute  int
	OverageCentsPerKPanels  int
}

// Subscription is a local projection of billing_subscriptions.
type Subscription struct {
	ID                   uuid.UUID
	TenantID             uuid.UUID
	PlanID               uuid.UUID
	StripeCustomerID     string
	StripeSubscriptionID string
	Status               SubscriptionStatus
	CurrentPeriodStart   time.Time
	CurrentPeriodEnd     time.Time
	CancelAtPeriodEnd    bool
	TrialEndsAt          *time.Time
}

// Usage is a rolling counter for a tenant in a given billing period.
type Usage struct {
	TenantID                 uuid.UUID
	PeriodStart              time.Time
	PeriodEnd                time.Time
	Metric                   string
	Quantity                 int64
	LastReportedQuantity     int64
	LastReportedAt           *time.Time
	StripeSubscriptionItemID string
}

// Gateway abstracts the Stripe-facing calls. Real impl uses stripe-go v78+.
type Gateway interface {
	ReportUsage(ctx context.Context, subscriptionItemID string, quantity int64, timestamp time.Time, idempotencyKey string) error
	VerifyWebhookSignature(payload []byte, signatureHeader, signingSecret string) (eventID, eventType string, data []byte, err error)
}

// Store is the local persistence boundary.
type Store interface {
	PlanByTier(ctx context.Context, t Tier) (Plan, error)
	UpsertSubscription(ctx context.Context, s Subscription) error
	SubscriptionByTenant(ctx context.Context, tenantID uuid.UUID) (Subscription, error)
	IncrementUsage(ctx context.Context, tenantID uuid.UUID, metric string, delta int64, period time.Time) error
	UsageForPeriod(ctx context.Context, tenantID uuid.UUID, period time.Time) ([]Usage, error)
	MarkUsageReported(ctx context.Context, u Usage, reportedAt time.Time) error
	RecordWebhookEvent(ctx context.Context, eventID, eventType string) (bool, error) // returns true if newly inserted
	MarkWebhookProcessed(ctx context.Context, eventID string, processErr error) error
	UpsertInvoice(ctx context.Context, inv InvoiceProjection) error
}

// InvoiceProjection is the subset of Stripe Invoice we store locally.
type InvoiceProjection struct {
	TenantID         uuid.UUID
	StripeInvoiceID  string
	AmountDueCents   int64
	AmountPaidCents  int64
	Currency         string
	Status           string
	HostedInvoiceURL string
	PDFURL           string
	PeriodStart      time.Time
	PeriodEnd        time.Time
	FinalizedAt      *time.Time
	PaidAt           *time.Time
}

// Logger keeps the package log-lib-agnostic.
type Logger interface {
	Info(msg string, kv ...any)
	Warn(msg string, kv ...any)
	Error(msg string, kv ...any)
}

// Service is the entry point used by the billing RPC handler + webhook endpoint.
type Service struct {
	store   Store
	gateway Gateway
	log     Logger
}

func NewService(store Store, gateway Gateway, log Logger) *Service {
	return &Service{store: store, gateway: gateway, log: log}
}

// RecordUsage bumps a metered counter. Safe to call on every panel simulated
// / compute minute used — the counter is aggregated and flushed to Stripe
// by ReportUsage on a cadence (every 15 minutes is typical).
func (s *Service) RecordUsage(ctx context.Context, tenantID uuid.UUID, metric string, delta int64) error {
	if delta <= 0 {
		return nil
	}
	return s.store.IncrementUsage(ctx, tenantID, metric, delta, time.Now().UTC())
}

// ReportUsage flushes accumulated usage to Stripe for the current period.
// Idempotent per (tenant, period, metric, last-reported-quantity) tuple.
func (s *Service) ReportUsage(ctx context.Context, tenantID uuid.UUID) error {
	rows, err := s.store.UsageForPeriod(ctx, tenantID, time.Now().UTC())
	if err != nil {
		return fmt.Errorf("load usage: %w", err)
	}
	for _, u := range rows {
		if u.Quantity <= u.LastReportedQuantity {
			continue
		}
		if u.StripeSubscriptionItemID == "" {
			s.log.Warn("billing.usage_missing_stripe_item", "tenant", tenantID, "metric", u.Metric)
			continue
		}
		// Stripe expects the total for the period, not the delta. Idempotency
		// key keeps duplicates safe if we retry mid-flight.
		idemKey := fmt.Sprintf("usage:%s:%s:%d:%d", tenantID, u.Metric, u.PeriodStart.Unix(), u.Quantity)
		if err := s.gateway.ReportUsage(ctx, u.StripeSubscriptionItemID, u.Quantity, time.Now().UTC(), idemKey); err != nil {
			s.log.Error("billing.report_usage_failed", "tenant", tenantID, "metric", u.Metric, "err", err)
			continue
		}
		now := time.Now().UTC()
		u.LastReportedQuantity = u.Quantity
		u.LastReportedAt = &now
		if err := s.store.MarkUsageReported(ctx, u, now); err != nil {
			s.log.Warn("billing.mark_reported_failed", "tenant", tenantID, "metric", u.Metric, "err", err)
		}
	}
	return nil
}

// HandleWebhook validates the Stripe signature and dispatches the event.
// Idempotent: event IDs are recorded and re-deliveries are no-ops.
func (s *Service) HandleWebhook(ctx context.Context, payload []byte, signatureHeader, signingSecret string) error {
	eventID, eventType, data, err := s.gateway.VerifyWebhookSignature(payload, signatureHeader, signingSecret)
	if err != nil {
		return fmt.Errorf("verify signature: %w", err)
	}
	fresh, err := s.store.RecordWebhookEvent(ctx, eventID, eventType)
	if err != nil {
		return fmt.Errorf("record event: %w", err)
	}
	if !fresh {
		// Duplicate delivery — Stripe retries up to 3 days, we safely absorb.
		return nil
	}
	var procErr error
	switch eventType {
	case "customer.subscription.created", "customer.subscription.updated", "customer.subscription.deleted":
		procErr = s.applySubscriptionEvent(ctx, data)
	case "invoice.finalized", "invoice.paid", "invoice.payment_failed":
		procErr = s.applyInvoiceEvent(ctx, data)
	default:
		// Known event we don't act on — still mark processed.
	}
	if err := s.store.MarkWebhookProcessed(ctx, eventID, procErr); err != nil {
		s.log.Warn("billing.mark_processed_failed", "event_id", eventID, "err", err)
	}
	return procErr
}

// EntitlementChecker exposes quota checks to the rest of the platform.
// Call sites (project service, compute orchestrator, seat management) invoke
// this before allowing an operation that consumes entitlement.
type EntitlementChecker struct {
	store Store
}

func NewEntitlementChecker(store Store) *EntitlementChecker {
	return &EntitlementChecker{store: store}
}

// ErrQuotaExceeded is returned when the tenant has exhausted baseline entitlement
// and the plan does not allow overage for the metric in question.
var ErrQuotaExceeded = errors.New("billing: quota exceeded")

// ErrSubscriptionInactive is returned for past_due or canceled tenants.
var ErrSubscriptionInactive = errors.New("billing: subscription inactive")

// PlanLoader resolves a Plan by its primary key. The Store interface only
// exposes lookup by Tier, but EntitlementChecker needs lookup by the
// specific plan a tenant is on (which may differ from its tier name once
// custom enterprise plans exist). Service handlers wire this with their
// concrete sqlc query.
type PlanLoader interface {
	PlanByID(ctx context.Context, id uuid.UUID) (Plan, error)
}

// allowsSeatOverage returns true when the plan's overage-per-seat price is
// non-zero — the customer accepts overage charges and we should not block
// the action. Trial / Starter plans set overage to 0, which means hard cap.
func allowsSeatOverage(p Plan) bool { return p.OverageCentsPerSeat > 0 }

// CheckSeats returns nil if the tenant is allowed to operate with
// `currentSeats + addSeats` total seats, or an error explaining the block.
// Plans with non-zero seat overage cents always permit the action; plans
// without overage enforce a hard cap at IncludedSeats.
func (e *EntitlementChecker) CheckSeats(ctx context.Context, tenantID uuid.UUID, planLoader PlanLoader, currentSeats, addSeats int) error {
	if addSeats <= 0 {
		return nil
	}
	sub, err := e.store.SubscriptionByTenant(ctx, tenantID)
	if err != nil {
		return fmt.Errorf("load subscription: %w", err)
	}
	if sub.Status != StatusActive && sub.Status != StatusTrialing {
		return ErrSubscriptionInactive
	}
	plan, err := planLoader.PlanByID(ctx, sub.PlanID)
	if err != nil {
		return fmt.Errorf("load plan: %w", err)
	}
	total := currentSeats + addSeats
	if total <= plan.IncludedSeats {
		return nil
	}
	if allowsSeatOverage(plan) {
		return nil
	}
	return fmt.Errorf("%w: %d seats requested, plan %s allows %d without overage",
		ErrQuotaExceeded, total, plan.Tier, plan.IncludedSeats)
}

// stripeSubscriptionPayload is the subset of the Stripe Subscription object
// we need. Decoding the raw JSON keeps this package free of the stripe-go
// SDK dependency while remaining compatible with the live event shape.
type stripeSubscriptionPayload struct {
	Object struct {
		ID                 string `json:"id"`
		Customer           string `json:"customer"`
		Status             string `json:"status"`
		CurrentPeriodStart int64  `json:"current_period_start"`
		CurrentPeriodEnd   int64  `json:"current_period_end"`
		CancelAtPeriodEnd  bool   `json:"cancel_at_period_end"`
		TrialEnd           *int64 `json:"trial_end"`
		Metadata           struct {
			TenantID string `json:"tenant_id"`
			PlanID   string `json:"plan_id"`
		} `json:"metadata"`
		Items struct {
			Data []struct {
				Price struct {
					ID string `json:"id"`
				} `json:"price"`
			} `json:"data"`
		} `json:"items"`
	} `json:"object"`
}

func (s *Service) applySubscriptionEvent(ctx context.Context, raw []byte) error {
	var ev stripeSubscriptionPayload
	if err := json.Unmarshal(raw, &ev); err != nil {
		return fmt.Errorf("decode subscription event: %w", err)
	}
	obj := ev.Object
	if obj.ID == "" || obj.Customer == "" {
		return errors.New("billing: subscription event missing id or customer")
	}
	tenantID, err := uuid.Parse(obj.Metadata.TenantID)
	if err != nil {
		return fmt.Errorf("subscription metadata.tenant_id invalid: %w", err)
	}
	planID, err := uuid.Parse(obj.Metadata.PlanID)
	if err != nil {
		return fmt.Errorf("subscription metadata.plan_id invalid: %w", err)
	}
	sub := Subscription{
		TenantID:             tenantID,
		PlanID:               planID,
		StripeCustomerID:     obj.Customer,
		StripeSubscriptionID: obj.ID,
		Status:               normaliseStatus(obj.Status),
		CurrentPeriodStart:   time.Unix(obj.CurrentPeriodStart, 0).UTC(),
		CurrentPeriodEnd:     time.Unix(obj.CurrentPeriodEnd, 0).UTC(),
		CancelAtPeriodEnd:    obj.CancelAtPeriodEnd,
	}
	if obj.TrialEnd != nil && *obj.TrialEnd > 0 {
		t := time.Unix(*obj.TrialEnd, 0).UTC()
		sub.TrialEndsAt = &t
	}
	if err := s.store.UpsertSubscription(ctx, sub); err != nil {
		return fmt.Errorf("persist subscription: %w", err)
	}
	return nil
}

type stripeInvoicePayload struct {
	Object struct {
		ID               string `json:"id"`
		Customer         string `json:"customer"`
		Currency         string `json:"currency"`
		Status           string `json:"status"`
		AmountDue        int64  `json:"amount_due"`
		AmountPaid       int64  `json:"amount_paid"`
		HostedInvoiceURL string `json:"hosted_invoice_url"`
		InvoicePDF       string `json:"invoice_pdf"`
		PeriodStart      int64  `json:"period_start"`
		PeriodEnd        int64  `json:"period_end"`
		StatusTransitions struct {
			FinalizedAt *int64 `json:"finalized_at"`
			PaidAt      *int64 `json:"paid_at"`
		} `json:"status_transitions"`
		Metadata struct {
			TenantID string `json:"tenant_id"`
		} `json:"metadata"`
	} `json:"object"`
}

func (s *Service) applyInvoiceEvent(ctx context.Context, raw []byte) error {
	var ev stripeInvoicePayload
	if err := json.Unmarshal(raw, &ev); err != nil {
		return fmt.Errorf("decode invoice event: %w", err)
	}
	obj := ev.Object
	if obj.ID == "" {
		return errors.New("billing: invoice event missing id")
	}
	tenantID, err := uuid.Parse(obj.Metadata.TenantID)
	if err != nil {
		return fmt.Errorf("invoice metadata.tenant_id invalid: %w", err)
	}
	inv := InvoiceProjection{
		TenantID:         tenantID,
		StripeInvoiceID:  obj.ID,
		AmountDueCents:   obj.AmountDue,
		AmountPaidCents:  obj.AmountPaid,
		Currency:         obj.Currency,
		Status:           obj.Status,
		HostedInvoiceURL: obj.HostedInvoiceURL,
		PDFURL:           obj.InvoicePDF,
		PeriodStart:      time.Unix(obj.PeriodStart, 0).UTC(),
		PeriodEnd:        time.Unix(obj.PeriodEnd, 0).UTC(),
	}
	if t := obj.StatusTransitions.FinalizedAt; t != nil && *t > 0 {
		v := time.Unix(*t, 0).UTC()
		inv.FinalizedAt = &v
	}
	if t := obj.StatusTransitions.PaidAt; t != nil && *t > 0 {
		v := time.Unix(*t, 0).UTC()
		inv.PaidAt = &v
	}
	if err := s.store.UpsertInvoice(ctx, inv); err != nil {
		return fmt.Errorf("persist invoice: %w", err)
	}
	return nil
}

// normaliseStatus maps Stripe's full status set onto the subset we track.
// Statuses we don't model (e.g. unpaid, paused) are folded onto the closest
// behaviourally equivalent state so downstream entitlement checks still work.
func normaliseStatus(s string) SubscriptionStatus {
	switch s {
	case "active":
		return StatusActive
	case "trialing":
		return StatusTrialing
	case "past_due", "unpaid":
		return StatusPastDue
	case "canceled", "incomplete_expired":
		return StatusCanceled
	case "incomplete":
		return StatusIncomplete
	default:
		return StatusIncomplete
	}
}
