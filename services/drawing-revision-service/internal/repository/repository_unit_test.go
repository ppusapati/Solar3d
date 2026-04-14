package repository

import (
	"errors"
	"testing"

	"github.com/jackc/pgx/v5/pgconn"
)

func TestIsStaleBase(t *testing.T) {
	if !isStaleBase("base-rev", 0, "head-rev", 4) {
		t.Fatal("expected stale when base revision differs")
	}
	if !isStaleBase("", 5, "head-rev", 4) {
		t.Fatal("expected stale when requested head version differs")
	}
	if isStaleBase("head-rev", 4, "head-rev", 4) {
		t.Fatal("did not expect stale when revision and version match")
	}
}

func TestClassifyWriteError_LockTimeoutReturnsTypedConflict(t *testing.T) {
	err := classifyWriteError("lock drawing", &pgconn.PgError{Code: "55P03", Message: "lock not available"}, "attempt-1")
	var conflictErr *ConflictError
	if !errors.As(err, &conflictErr) {
		t.Fatalf("expected ConflictError, got %T", err)
	}
	if conflictErr.OutcomeCode != OutcomeLockTimeout {
		t.Fatalf("expected lock_timeout, got %q", conflictErr.OutcomeCode)
	}
	if conflictErr.AttemptID != "attempt-1" {
		t.Fatalf("expected attempt id, got %q", conflictErr.AttemptID)
	}
}

