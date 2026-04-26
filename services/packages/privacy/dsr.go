// Package privacy implements GDPR / CCPA data-subject-request (DSR) workflows:
// access, erasure, rectification, portability, and objection.
//
// The Processor coordinates identity verification, orchestrates per-service
// exports or deletions, records proof-of-compliance, and enforces the
// regulatory deadline (30 days GDPR / 45 days CCPA). Per-service handlers
// plug in via the Extractor and Eraser interfaces so each domain owns the
// mapping from "user X" → concrete rows/objects under its control.
package privacy

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/google/uuid"
)

// Kind identifies the regulatory article invoked by the request.
type Kind string

const (
	KindAccess        Kind = "access"
	KindErasure       Kind = "erasure"
	KindRectification Kind = "rectification"
	KindPortability   Kind = "portability"
	KindObjection     Kind = "objection"
)

// Status tracks processing state. Persisted in `data_subject_requests.status`.
type Status string

const (
	StatusReceived            Status = "received"
	StatusVerifyingIdentity   Status = "verifying_identity"
	StatusInProgress          Status = "in_progress"
	StatusAwaitingDPOReview   Status = "awaiting_dpo_review"
	StatusCompleted           Status = "completed"
	StatusRejected            Status = "rejected"
	StatusPartiallyCompleted  Status = "partially_completed"
)

// Request is a pending or historical data-subject request.
type Request struct {
	ID               uuid.UUID
	TenantID         uuid.UUID
	SubjectEmail     string
	SubjectUserID    *uuid.UUID
	Kind             Kind
	Status           Status
	ReceivedAt       time.Time
	VerifiedAt       *time.Time
	CompletedAt      *time.Time
	DueBy            time.Time
	RequesterIP      string
	Notes            string
	ProcessorID      *uuid.UUID
	ExportArtifactURI string
	RejectionReason  string
}

// Extractor returns the user's data held by a specific service as a
// structured map (which the Processor serialises to JSON for export).
// Implementations must be idempotent — the Processor may retry on failure.
type Extractor interface {
	Name() string
	Extract(ctx context.Context, tenantID, subjectUserID uuid.UUID) (map[string]any, error)
}

// Eraser removes or anonymises the user's data in a specific service.
// Implementations return the list of identifiers that were acted on and
// any identifiers retained under legal hold (see `ErasureReport.Retained`).
type Eraser interface {
	Name() string
	Erase(ctx context.Context, tenantID, subjectUserID uuid.UUID) (ErasureReport, error)
}

// ErasureReport documents what was erased / retained for a single service.
type ErasureReport struct {
	Service       string
	Erased        []string          // identifiers erased
	Anonymised    []string          // identifiers retained with PII scrubbed
	Retained      []string          // identifiers kept (legal hold)
	RetainReason  string            // why retained — shown to subject if asked
	Metadata      map[string]string // service-specific counters, e.g. rows_deleted
}

// Store persists request records for audit. Real impl wraps sqlc queries;
// this interface keeps the package DB-agnostic and testable.
type Store interface {
	Create(ctx context.Context, r Request) error
	Get(ctx context.Context, id uuid.UUID) (Request, error)
	Update(ctx context.Context, r Request) error
	ListOpen(ctx context.Context) ([]Request, error)
	ListOverdue(ctx context.Context, now time.Time) ([]Request, error)
}

// IdentityVerifier confirms that the requester actually owns the subject
// email / account. Typical impl: send a one-time code to the verified email
// on file and wait for the subject to submit it.
type IdentityVerifier interface {
	Start(ctx context.Context, r Request) error
	Check(ctx context.Context, requestID uuid.UUID, proof string) (bool, error)
}

// ArtifactSink receives the assembled export bundle for access/portability
// requests. Typical impl: uploads to a tenant-scoped S3 prefix and returns
// a time-limited signed URL.
type ArtifactSink interface {
	Write(ctx context.Context, requestID uuid.UUID, kind string, payload []byte) (uri string, err error)
}

// Clock abstracts time for deterministic tests.
type Clock interface{ Now() time.Time }
type realClock struct{}
func (realClock) Now() time.Time { return time.Now().UTC() }

// Logger abstracts structured logging without binding to a specific lib.
type Logger interface {
	Info(msg string, kv ...any)
	Warn(msg string, kv ...any)
	Error(msg string, kv ...any)
}

// Processor is the entry point used by the DSR service handler.
type Processor struct {
	store      Store
	verifier   IdentityVerifier
	sink       ArtifactSink
	extractors []Extractor
	erasers    []Eraser
	clock      Clock
	log        Logger
	mu         sync.Mutex
}

// NewProcessor constructs a Processor. Pass nil for clock to use real time.
func NewProcessor(s Store, v IdentityVerifier, sink ArtifactSink, log Logger, c Clock) *Processor {
	if c == nil {
		c = realClock{}
	}
	return &Processor{store: s, verifier: v, sink: sink, clock: c, log: log}
}

// Register wires a service handler. A service may register as Extractor,
// Eraser, or both. Services must be registered before Submit is called.
func (p *Processor) Register(h any) {
	p.mu.Lock()
	defer p.mu.Unlock()
	if e, ok := h.(Extractor); ok {
		p.extractors = append(p.extractors, e)
	}
	if e, ok := h.(Eraser); ok {
		p.erasers = append(p.erasers, e)
	}
}

// Submit accepts a new DSR, persists it, kicks off identity verification,
// and returns the request ID so the caller can poll status.
func (p *Processor) Submit(ctx context.Context, r Request) (uuid.UUID, error) {
	if r.TenantID == uuid.Nil {
		return uuid.Nil, errors.New("privacy: tenant required")
	}
	if r.SubjectEmail == "" {
		return uuid.Nil, errors.New("privacy: subject email required")
	}
	if r.Kind == "" {
		return uuid.Nil, errors.New("privacy: kind required")
	}
	r.ID = uuid.New()
	now := p.clock.Now()
	r.ReceivedAt = now
	r.DueBy = now.Add(regulatoryDeadline(r.Kind))
	r.Status = StatusReceived
	if err := p.store.Create(ctx, r); err != nil {
		return uuid.Nil, fmt.Errorf("persist request: %w", err)
	}
	if err := p.verifier.Start(ctx, r); err != nil {
		p.log.Warn("privacy.verifier.start_failed", "request_id", r.ID, "err", err)
		// Persisting the request is enough — staff can manually re-issue verification.
		return r.ID, nil
	}
	r.Status = StatusVerifyingIdentity
	if err := p.store.Update(ctx, r); err != nil {
		return r.ID, fmt.Errorf("update status: %w", err)
	}
	return r.ID, nil
}

// ConfirmIdentity records successful verification and schedules processing.
func (p *Processor) ConfirmIdentity(ctx context.Context, id uuid.UUID, proof string) error {
	r, err := p.store.Get(ctx, id)
	if err != nil {
		return fmt.Errorf("load request: %w", err)
	}
	if r.Status != StatusVerifyingIdentity {
		return fmt.Errorf("request not in verifying_identity state: %s", r.Status)
	}
	ok, err := p.verifier.Check(ctx, id, proof)
	if err != nil {
		return fmt.Errorf("verify: %w", err)
	}
	if !ok {
		return errors.New("privacy: identity verification failed")
	}
	now := p.clock.Now()
	r.VerifiedAt = &now
	r.Status = StatusInProgress
	return p.store.Update(ctx, r)
}

// Process executes the request (extract or erase). Callers typically invoke
// this from a background worker so the HTTP request that confirmed identity
// can return immediately.
func (p *Processor) Process(ctx context.Context, id uuid.UUID) error {
	r, err := p.store.Get(ctx, id)
	if err != nil {
		return fmt.Errorf("load: %w", err)
	}
	if r.Status != StatusInProgress {
		return fmt.Errorf("request not in progress: %s", r.Status)
	}
	if r.SubjectUserID == nil {
		return errors.New("privacy: subject user id not resolved")
	}
	var procErr error
	now := p.clock.Now()
	switch r.Kind {
	case KindAccess, KindPortability:
		procErr = p.executeExport(ctx, &r)
		r.CompletedAt = &now
		if procErr != nil {
			r.Status = StatusPartiallyCompleted
			r.Notes += "\nError: " + procErr.Error()
		} else {
			r.Status = StatusCompleted
		}
	case KindErasure:
		procErr = p.executeErasure(ctx, &r)
		r.CompletedAt = &now
		if procErr != nil {
			r.Status = StatusPartiallyCompleted
			r.Notes += "\nError: " + procErr.Error()
		} else {
			r.Status = StatusCompleted
		}
	case KindRectification, KindObjection:
		// Rectification and objection cannot be auto-processed — the request
		// is parked in StatusAwaitingDPOReview for the Data Protection Officer
		// to action manually. CompletedAt is left unset so the deadline timer
		// keeps running and overdue alerts continue to fire.
		r.Status = StatusAwaitingDPOReview
		r.Notes += "\nQueued for DPO review at " + now.Format(time.RFC3339)
	default:
		return fmt.Errorf("unsupported kind: %s", r.Kind)
	}
	if err := p.store.Update(ctx, r); err != nil {
		return fmt.Errorf("finalise: %w", err)
	}
	return procErr
}

// CompleteManualReview is called by the DPO admin tool once a rectification
// or objection request has been actioned. Records who handled it and marks
// the request completed (or rejected, with a reason).
func (p *Processor) CompleteManualReview(ctx context.Context, id uuid.UUID, processorID uuid.UUID, accepted bool, rejectionReason string) error {
	r, err := p.store.Get(ctx, id)
	if err != nil {
		return fmt.Errorf("load: %w", err)
	}
	if r.Status != StatusAwaitingDPOReview {
		return fmt.Errorf("request not awaiting review: %s", r.Status)
	}
	now := p.clock.Now()
	r.ProcessorID = &processorID
	r.CompletedAt = &now
	if accepted {
		r.Status = StatusCompleted
	} else {
		r.Status = StatusRejected
		r.RejectionReason = rejectionReason
	}
	return p.store.Update(ctx, r)
}

func (p *Processor) executeExport(ctx context.Context, r *Request) error {
	bundle := map[string]any{
		"request_id":    r.ID.String(),
		"subject_email": r.SubjectEmail,
		"generated_at":  p.clock.Now().UTC().Format(time.RFC3339),
		"services":      map[string]any{},
	}
	services := bundle["services"].(map[string]any)
	var firstErr error
	for _, ex := range p.extractors {
		data, err := ex.Extract(ctx, r.TenantID, *r.SubjectUserID)
		if err != nil {
			p.log.Error("privacy.extract_failed", "service", ex.Name(), "request_id", r.ID, "err", err)
			if firstErr == nil {
				firstErr = err
			}
			services[ex.Name()] = map[string]any{"error": err.Error()}
			continue
		}
		services[ex.Name()] = data
	}
	payload, err := marshalIndent(bundle)
	if err != nil {
		return fmt.Errorf("marshal bundle: %w", err)
	}
	uri, err := p.sink.Write(ctx, r.ID, string(r.Kind), payload)
	if err != nil {
		return fmt.Errorf("sink write: %w", err)
	}
	r.ExportArtifactURI = uri
	return firstErr
}

func (p *Processor) executeErasure(ctx context.Context, r *Request) error {
	reports := make([]ErasureReport, 0, len(p.erasers))
	var firstErr error
	for _, er := range p.erasers {
		rep, err := er.Erase(ctx, r.TenantID, *r.SubjectUserID)
		if err != nil {
			p.log.Error("privacy.erase_failed", "service", er.Name(), "request_id", r.ID, "err", err)
			if firstErr == nil {
				firstErr = err
			}
			reports = append(reports, ErasureReport{Service: er.Name(), RetainReason: err.Error()})
			continue
		}
		reports = append(reports, rep)
	}
	bundle := map[string]any{
		"request_id":   r.ID.String(),
		"completed_at": p.clock.Now().UTC().Format(time.RFC3339),
		"reports":      reports,
	}
	payload, err := marshalIndent(bundle)
	if err != nil {
		return fmt.Errorf("marshal erasure report: %w", err)
	}
	uri, err := p.sink.Write(ctx, r.ID, "erasure_report", payload)
	if err != nil {
		p.log.Warn("privacy.erasure_report_sink_failed", "request_id", r.ID, "err", err)
	} else {
		r.ExportArtifactURI = uri
	}
	return firstErr
}

// regulatoryDeadline returns the response window for a request kind.
// GDPR art. 12: one month (extendable by 2 months for complex requests).
// CCPA §1798.130: 45 days (extendable by 45).
// We pick the tighter of the two so we're compliant regardless of subject jurisdiction.
func regulatoryDeadline(k Kind) time.Duration {
	switch k {
	case KindAccess, KindPortability, KindErasure, KindRectification:
		return 30 * 24 * time.Hour
	case KindObjection:
		return 30 * 24 * time.Hour
	default:
		return 30 * 24 * time.Hour
	}
}
