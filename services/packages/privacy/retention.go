package privacy

import (
	"context"
	"fmt"
	"time"
)

// RetentionPolicy mirrors the `retention_policies` table.
type RetentionPolicy struct {
	EntityKind       string
	KeepActiveFor    *time.Duration // nil → keep while referenced
	KeepAfterDelete  time.Duration
	LegalHold        bool
	Rationale        string
}

// PolicyStore is a read-side for retention policies.
type PolicyStore interface {
	Get(ctx context.Context, entityKind string) (RetentionPolicy, error)
	List(ctx context.Context) ([]RetentionPolicy, error)
}

// Sweeper is the interface each service implements to purge expired records
// under a given policy. Implementations must be idempotent and safe to
// interrupt — the scheduler may kill and restart the job.
type Sweeper interface {
	Kind() string
	Sweep(ctx context.Context, policy RetentionPolicy, now time.Time) (SweepResult, error)
}

// SweepResult summarises a single sweeper run for audit and metrics.
type SweepResult struct {
	EntityKind    string
	Scanned       int
	HardDeleted   int
	Anonymised    int
	SkippedOnHold int  // count of records that would have been swept but for legal hold
	OnHold        bool // true when the entire entity kind was skipped because the policy is under hold
	Err           error
}

// Scheduler runs all registered sweepers on a cadence. The expected cadence
// is daily at 03:00 in each region's local time — quiet hours to minimise
// user impact from long transactions.
type Scheduler struct {
	policies PolicyStore
	sweepers []Sweeper
	clock    Clock
	log      Logger
}

func NewScheduler(p PolicyStore, c Clock, log Logger) *Scheduler {
	if c == nil {
		c = realClock{}
	}
	return &Scheduler{policies: p, clock: c, log: log}
}

func (s *Scheduler) Register(sw Sweeper) {
	s.sweepers = append(s.sweepers, sw)
}

// RunOnce executes every registered sweeper with its current policy. Returns
// the per-sweeper results so the caller (typically a cron job handler) can
// emit metrics and alerts.
func (s *Scheduler) RunOnce(ctx context.Context) ([]SweepResult, error) {
	now := s.clock.Now()
	results := make([]SweepResult, 0, len(s.sweepers))
	for _, sw := range s.sweepers {
		policy, err := s.policies.Get(ctx, sw.Kind())
		if err != nil {
			s.log.Warn("retention.policy_missing", "kind", sw.Kind(), "err", err)
			results = append(results, SweepResult{EntityKind: sw.Kind(), Err: fmt.Errorf("policy: %w", err)})
			continue
		}
		if policy.LegalHold {
			s.log.Info("retention.skip_legal_hold", "kind", sw.Kind())
			results = append(results, SweepResult{EntityKind: sw.Kind(), OnHold: true})
			continue
		}
		res, err := sw.Sweep(ctx, policy, now)
		if err != nil {
			s.log.Error("retention.sweep_failed", "kind", sw.Kind(), "err", err)
			res.Err = err
		}
		results = append(results, res)
	}
	return results, nil
}
