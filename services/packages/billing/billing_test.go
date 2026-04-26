package billing

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
)

type fakeStore struct {
	mu             sync.Mutex
	usage          map[string]*Usage
	events         map[string]bool
	subscriptions  map[uuid.UUID]Subscription
	plansByID      map[uuid.UUID]Plan
	plansByTier    map[Tier]Plan
	invoices       map[string]InvoiceProjection
	upserts        int
	invoiceUpserts int
}

func newFakeStore() *fakeStore {
	return &fakeStore{
		usage:         map[string]*Usage{},
		events:        map[string]bool{},
		subscriptions: map[uuid.UUID]Subscription{},
		plansByID:     map[uuid.UUID]Plan{},
		plansByTier:   map[Tier]Plan{},
		invoices:      map[string]InvoiceProjection{},
	}
}

func (f *fakeStore) PlanByTier(_ context.Context, t Tier) (Plan, error) {
	f.mu.Lock(); defer f.mu.Unlock()
	if p, ok := f.plansByTier[t]; ok {
		return p, nil
	}
	return Plan{}, nil
}
func (f *fakeStore) PlanByID(_ context.Context, id uuid.UUID) (Plan, error) {
	f.mu.Lock(); defer f.mu.Unlock()
	if p, ok := f.plansByID[id]; ok {
		return p, nil
	}
	return Plan{}, errors.New("plan not found")
}
func (f *fakeStore) UpsertSubscription(_ context.Context, s Subscription) error {
	f.mu.Lock(); defer f.mu.Unlock()
	if s.TenantID == uuid.Nil {
		return errors.New("tenant required")
	}
	f.subscriptions[s.TenantID] = s
	f.upserts++
	return nil
}
func (f *fakeStore) SubscriptionByTenant(_ context.Context, tenantID uuid.UUID) (Subscription, error) {
	f.mu.Lock(); defer f.mu.Unlock()
	if s, ok := f.subscriptions[tenantID]; ok {
		return s, nil
	}
	return Subscription{Status: StatusActive}, nil
}
func (f *fakeStore) IncrementUsage(_ context.Context, tenantID uuid.UUID, metric string, delta int64, _ time.Time) error {
	f.mu.Lock(); defer f.mu.Unlock()
	key := tenantID.String() + "|" + metric
	if f.usage[key] == nil {
		f.usage[key] = &Usage{TenantID: tenantID, Metric: metric, PeriodStart: time.Now().UTC().Truncate(24 * time.Hour), StripeSubscriptionItemID: "si_" + metric}
	}
	f.usage[key].Quantity += delta
	return nil
}
func (f *fakeStore) UsageForPeriod(_ context.Context, tenantID uuid.UUID, _ time.Time) ([]Usage, error) {
	f.mu.Lock(); defer f.mu.Unlock()
	out := []Usage{}
	for _, u := range f.usage {
		if u.TenantID == tenantID {
			out = append(out, *u)
		}
	}
	return out, nil
}
func (f *fakeStore) MarkUsageReported(_ context.Context, u Usage, reportedAt time.Time) error {
	f.mu.Lock(); defer f.mu.Unlock()
	key := u.TenantID.String() + "|" + u.Metric
	if existing := f.usage[key]; existing != nil {
		existing.LastReportedQuantity = u.Quantity
		existing.LastReportedAt = &reportedAt
	}
	return nil
}
func (f *fakeStore) RecordWebhookEvent(_ context.Context, eventID, _ string) (bool, error) {
	f.mu.Lock(); defer f.mu.Unlock()
	if f.events[eventID] {
		return false, nil
	}
	f.events[eventID] = true
	return true, nil
}
func (f *fakeStore) MarkWebhookProcessed(_ context.Context, _ string, _ error) error { return nil }
func (f *fakeStore) UpsertInvoice(_ context.Context, inv InvoiceProjection) error {
	f.mu.Lock(); defer f.mu.Unlock()
	f.invoices[inv.StripeInvoiceID] = inv
	f.invoiceUpserts++
	return nil
}

type fakeGateway struct {
	reports int
	failUntil int
	verifyErr error
	eventID, eventType string
}

func (g *fakeGateway) ReportUsage(_ context.Context, _ string, _ int64, _ time.Time, _ string) error {
	g.reports++
	if g.reports <= g.failUntil {
		return errors.New("stripe unavailable")
	}
	return nil
}
func (g *fakeGateway) VerifyWebhookSignature(payload []byte, _ string, _ string) (string, string, []byte, error) {
	if g.verifyErr != nil {
		return "", "", nil, g.verifyErr
	}
	return g.eventID, g.eventType, payload, nil
}

type discardLog struct{}
func (discardLog) Info(string, ...any)  {}
func (discardLog) Warn(string, ...any)  {}
func (discardLog) Error(string, ...any) {}

func TestRecordAndReportUsage(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	gw := &fakeGateway{}
	svc := NewService(store, gw, discardLog{})
	tenant := uuid.New()

	for i := 0; i < 100; i++ {
		if err := svc.RecordUsage(ctx, tenant, "panels_simulated", 500); err != nil {
			t.Fatal(err)
		}
	}
	if err := svc.ReportUsage(ctx, tenant); err != nil { t.Fatal(err) }
	if gw.reports != 1 { t.Fatalf("want 1 report, got %d", gw.reports) }

	// Reporting again with no delta must be a no-op.
	if err := svc.ReportUsage(ctx, tenant); err != nil { t.Fatal(err) }
	if gw.reports != 1 { t.Fatalf("want no extra report, got %d", gw.reports) }

	// More usage → another report.
	_ = svc.RecordUsage(ctx, tenant, "panels_simulated", 1000)
	if err := svc.ReportUsage(ctx, tenant); err != nil { t.Fatal(err) }
	if gw.reports != 2 { t.Fatalf("want 2 reports, got %d", gw.reports) }
}

func TestWebhookIdempotency(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	tenantID := uuid.New()
	payload := []byte(`{"object":{"id":"in_1","customer":"cus_1","status":"paid","metadata":{"tenant_id":"` + tenantID.String() + `"}}}`)
	gw := &fakeGateway{eventID: "evt_1", eventType: "invoice.paid"}
	svc := NewService(store, gw, discardLog{})

	if err := svc.HandleWebhook(ctx, payload, "sig", "whsec"); err != nil {
		t.Fatal(err)
	}
	if store.invoiceUpserts != 1 {
		t.Fatalf("want 1 invoice upsert, got %d", store.invoiceUpserts)
	}
	// Duplicate delivery is a no-op (no error, no re-process).
	if err := svc.HandleWebhook(ctx, payload, "sig", "whsec"); err != nil {
		t.Fatal(err)
	}
	if store.invoiceUpserts != 1 {
		t.Fatalf("duplicate delivery must not re-upsert; got %d", store.invoiceUpserts)
	}
}

func TestWebhookSignatureFailure(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	gw := &fakeGateway{verifyErr: errors.New("bad signature")}
	svc := NewService(store, gw, discardLog{})
	if err := svc.HandleWebhook(ctx, []byte("{}"), "sig", "whsec"); err == nil {
		t.Fatal("want signature error")
	}
}

func TestApplySubscriptionEventPersists(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	tenantID := uuid.New()
	planID := uuid.New()
	payload := []byte(`{
		"object": {
			"id": "sub_123",
			"customer": "cus_123",
			"status": "active",
			"current_period_start": 1700000000,
			"current_period_end": 1702592000,
			"cancel_at_period_end": false,
			"metadata": {"tenant_id": "` + tenantID.String() + `", "plan_id": "` + planID.String() + `"}
		}
	}`)
	gw := &fakeGateway{eventID: "evt_sub_1", eventType: "customer.subscription.updated"}
	svc := NewService(store, gw, discardLog{})
	if err := svc.HandleWebhook(ctx, payload, "sig", "whsec"); err != nil {
		t.Fatal(err)
	}
	gw.eventID = "evt_sub_1" // gateway stub returns same payload as data
	// Verify subscription was upserted with correct fields
	sub, err := store.SubscriptionByTenant(ctx, tenantID)
	if err != nil {
		t.Fatal(err)
	}
	if sub.StripeSubscriptionID != "sub_123" {
		t.Fatalf("want sub_123, got %s", sub.StripeSubscriptionID)
	}
	if sub.Status != StatusActive {
		t.Fatalf("want active, got %s", sub.Status)
	}
	if sub.PlanID != planID {
		t.Fatalf("plan id mismatch")
	}
}

func TestApplyInvoiceEventPersists(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	tenantID := uuid.New()
	payload := []byte(`{
		"object": {
			"id": "in_456",
			"customer": "cus_456",
			"currency": "usd",
			"status": "paid",
			"amount_due": 12000,
			"amount_paid": 12000,
			"period_start": 1700000000,
			"period_end": 1702592000,
			"hosted_invoice_url": "https://stripe.example/invoice/in_456",
			"invoice_pdf": "https://stripe.example/invoice/in_456.pdf",
			"status_transitions": {"finalized_at": 1700000100, "paid_at": 1700000200},
			"metadata": {"tenant_id": "` + tenantID.String() + `"}
		}
	}`)
	gw := &fakeGateway{eventID: "evt_inv_1", eventType: "invoice.paid"}
	svc := NewService(store, gw, discardLog{})
	if err := svc.HandleWebhook(ctx, payload, "sig", "whsec"); err != nil {
		t.Fatal(err)
	}
	inv, ok := store.invoices["in_456"]
	if !ok {
		t.Fatal("invoice not persisted")
	}
	if inv.AmountPaidCents != 12000 || inv.Currency != "usd" || inv.Status != "paid" {
		t.Fatalf("invoice fields wrong: %+v", inv)
	}
	if inv.PaidAt == nil {
		t.Fatal("paid_at not set")
	}
}

type planLoaderStub struct{ p Plan; err error }
func (l planLoaderStub) PlanByID(_ context.Context, _ uuid.UUID) (Plan, error) { return l.p, l.err }

func TestCheckSeatsEnforcesIncludedQuota(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	tenantID := uuid.New()
	planID := uuid.New()
	store.subscriptions[tenantID] = Subscription{TenantID: tenantID, PlanID: planID, Status: StatusActive}
	loader := planLoaderStub{p: Plan{Tier: TierStarter, IncludedSeats: 5, OverageCentsPerSeat: 0}}
	checker := NewEntitlementChecker(store)
	if err := checker.CheckSeats(ctx, tenantID, loader, 4, 1); err != nil {
		t.Fatalf("5 seats should be allowed: %v", err)
	}
	if err := checker.CheckSeats(ctx, tenantID, loader, 5, 1); err == nil {
		t.Fatal("6 seats on starter (no overage) should be blocked")
	} else if !errors.Is(err, ErrQuotaExceeded) {
		t.Fatalf("want ErrQuotaExceeded, got %v", err)
	}
}

func TestCheckSeatsAllowsOverageOnEnterprise(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	tenantID := uuid.New()
	planID := uuid.New()
	store.subscriptions[tenantID] = Subscription{TenantID: tenantID, PlanID: planID, Status: StatusActive}
	loader := planLoaderStub{p: Plan{Tier: TierEnterprise, IncludedSeats: 10, OverageCentsPerSeat: 2500}}
	checker := NewEntitlementChecker(store)
	if err := checker.CheckSeats(ctx, tenantID, loader, 10, 50); err != nil {
		t.Fatalf("overage-enabled plan should permit growth: %v", err)
	}
}

func TestCheckSeatsBlocksInactiveSubscription(t *testing.T) {
	ctx := context.Background()
	store := newFakeStore()
	tenantID := uuid.New()
	store.subscriptions[tenantID] = Subscription{TenantID: tenantID, Status: StatusPastDue}
	loader := planLoaderStub{p: Plan{IncludedSeats: 100}}
	checker := NewEntitlementChecker(store)
	if err := checker.CheckSeats(ctx, tenantID, loader, 1, 1); !errors.Is(err, ErrSubscriptionInactive) {
		t.Fatalf("want ErrSubscriptionInactive, got %v", err)
	}
}
