package privacy

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
)

type memStore struct {
	mu sync.Mutex
	m  map[uuid.UUID]Request
}

func newMemStore() *memStore { return &memStore{m: map[uuid.UUID]Request{}} }
func (s *memStore) Create(_ context.Context, r Request) error {
	s.mu.Lock(); defer s.mu.Unlock()
	s.m[r.ID] = r; return nil
}
func (s *memStore) Get(_ context.Context, id uuid.UUID) (Request, error) {
	s.mu.Lock(); defer s.mu.Unlock()
	r, ok := s.m[id]; if !ok { return Request{}, errors.New("not found") }; return r, nil
}
func (s *memStore) Update(_ context.Context, r Request) error {
	s.mu.Lock(); defer s.mu.Unlock()
	s.m[r.ID] = r; return nil
}
func (s *memStore) ListOpen(_ context.Context) ([]Request, error) { return nil, nil }
func (s *memStore) ListOverdue(_ context.Context, _ time.Time) ([]Request, error) { return nil, nil }

type fakeVerifier struct{ started, passed bool }
func (f *fakeVerifier) Start(_ context.Context, _ Request) error { f.started = true; return nil }
func (f *fakeVerifier) Check(_ context.Context, _ uuid.UUID, _ string) (bool, error) {
	f.passed = true; return true, nil
}

type fakeSink struct{ lastURI string; payload []byte }
func (f *fakeSink) Write(_ context.Context, id uuid.UUID, kind string, p []byte) (string, error) {
	f.payload = p
	f.lastURI = "s3://test/" + id.String() + "/" + kind + ".json"
	return f.lastURI, nil
}

type fakeExtractor struct{ name string; data map[string]any; err error }
func (f *fakeExtractor) Name() string { return f.name }
func (f *fakeExtractor) Extract(_ context.Context, _, _ uuid.UUID) (map[string]any, error) {
	return f.data, f.err
}

type fakeEraser struct{ name string; rep ErasureReport; err error }
func (f *fakeEraser) Name() string { return f.name }
func (f *fakeEraser) Erase(_ context.Context, _, _ uuid.UUID) (ErasureReport, error) {
	return f.rep, f.err
}

type fakeClock struct{ t time.Time }
func (f fakeClock) Now() time.Time { return f.t }

type discardLog struct{}
func (discardLog) Info(string, ...any)  {}
func (discardLog) Warn(string, ...any)  {}
func (discardLog) Error(string, ...any) {}

func TestAccessFlowEndToEnd(t *testing.T) {
	ctx := context.Background()
	store := newMemStore()
	v := &fakeVerifier{}
	sink := &fakeSink{}
	clk := fakeClock{t: time.Date(2026, 4, 1, 0, 0, 0, 0, time.UTC)}
	p := NewProcessor(store, v, sink, discardLog{}, clk)
	p.Register(&fakeExtractor{name: "projects", data: map[string]any{"count": 3}})
	p.Register(&fakeExtractor{name: "layouts",  data: map[string]any{"count": 12}})

	subject := uuid.New()
	id, err := p.Submit(ctx, Request{
		TenantID: uuid.New(),
		SubjectEmail: "u@example.com",
		SubjectUserID: &subject,
		Kind: KindAccess,
	})
	if err != nil { t.Fatal(err) }
	if !v.started { t.Fatal("verifier not started") }
	got, _ := store.Get(ctx, id)
	if got.Status != StatusVerifyingIdentity { t.Fatalf("status %s", got.Status) }
	if !got.DueBy.After(got.ReceivedAt) { t.Fatal("due_by must be after received_at") }

	if err := p.ConfirmIdentity(ctx, id, "code"); err != nil { t.Fatal(err) }
	if err := p.Process(ctx, id); err != nil { t.Fatal(err) }

	got, _ = store.Get(ctx, id)
	if got.Status != StatusCompleted { t.Fatalf("want completed, got %s", got.Status) }
	if got.ExportArtifactURI == "" { t.Fatal("export artifact uri missing") }
	if len(sink.payload) == 0 { t.Fatal("sink payload empty") }
}

func TestErasureCapturesPartialFailure(t *testing.T) {
	ctx := context.Background()
	store := newMemStore()
	v := &fakeVerifier{}
	sink := &fakeSink{}
	clk := fakeClock{t: time.Now().UTC()}
	p := NewProcessor(store, v, sink, discardLog{}, clk)
	p.Register(&fakeEraser{name: "projects", rep: ErasureReport{Service: "projects", Erased: []string{"p1"}}})
	p.Register(&fakeEraser{name: "audit",    err: errors.New("legal hold")})

	subject := uuid.New()
	id, err := p.Submit(ctx, Request{
		TenantID: uuid.New(), SubjectEmail: "u@example.com", SubjectUserID: &subject, Kind: KindErasure,
	})
	if err != nil { t.Fatal(err) }
	if err := p.ConfirmIdentity(ctx, id, "code"); err != nil { t.Fatal(err) }
	_ = p.Process(ctx, id) // may return error; that's fine

	got, _ := store.Get(ctx, id)
	if got.Status != StatusPartiallyCompleted {
		t.Fatalf("want partially_completed, got %s", got.Status)
	}
}

func TestSubmitRejectsMissingFields(t *testing.T) {
	p := NewProcessor(newMemStore(), &fakeVerifier{}, &fakeSink{}, discardLog{}, fakeClock{t: time.Now()})
	_, err := p.Submit(context.Background(), Request{Kind: KindAccess, SubjectEmail: "a@b"})
	if err == nil { t.Fatal("want error for missing tenant") }
}

func TestRectificationParksForDPOReview(t *testing.T) {
	ctx := context.Background()
	store := newMemStore()
	clk := fakeClock{t: time.Date(2026, 4, 1, 0, 0, 0, 0, time.UTC)}
	p := NewProcessor(store, &fakeVerifier{}, &fakeSink{}, discardLog{}, clk)
	subject := uuid.New()
	id, err := p.Submit(ctx, Request{
		TenantID: uuid.New(), SubjectEmail: "u@example.com",
		SubjectUserID: &subject, Kind: KindRectification,
	})
	if err != nil { t.Fatal(err) }
	if err := p.ConfirmIdentity(ctx, id, "code"); err != nil { t.Fatal(err) }
	if err := p.Process(ctx, id); err != nil { t.Fatal(err) }

	got, _ := store.Get(ctx, id)
	if got.Status != StatusAwaitingDPOReview {
		t.Fatalf("rectification must park in awaiting_dpo_review, got %s", got.Status)
	}
	if got.CompletedAt != nil {
		t.Fatal("rectification must not be marked completed before DPO review")
	}

	dpoID := uuid.New()
	if err := p.CompleteManualReview(ctx, id, dpoID, true, ""); err != nil { t.Fatal(err) }
	got, _ = store.Get(ctx, id)
	if got.Status != StatusCompleted { t.Fatalf("want completed after DPO review, got %s", got.Status) }
	if got.ProcessorID == nil || *got.ProcessorID != dpoID {
		t.Fatal("DPO id not recorded")
	}
}

func TestRejectedRequestRecordsReason(t *testing.T) {
	ctx := context.Background()
	store := newMemStore()
	clk := fakeClock{t: time.Now().UTC()}
	p := NewProcessor(store, &fakeVerifier{}, &fakeSink{}, discardLog{}, clk)
	subject := uuid.New()
	id, _ := p.Submit(ctx, Request{
		TenantID: uuid.New(), SubjectEmail: "u@example.com",
		SubjectUserID: &subject, Kind: KindObjection,
	})
	_ = p.ConfirmIdentity(ctx, id, "x")
	_ = p.Process(ctx, id)
	dpo := uuid.New()
	if err := p.CompleteManualReview(ctx, id, dpo, false, "out of scope under contract"); err != nil { t.Fatal(err) }
	got, _ := store.Get(ctx, id)
	if got.Status != StatusRejected { t.Fatalf("want rejected, got %s", got.Status) }
	if got.RejectionReason != "out of scope under contract" { t.Fatal("reason not recorded") }
}
