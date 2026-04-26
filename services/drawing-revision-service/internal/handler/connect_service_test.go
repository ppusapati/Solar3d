package handler

import (
	"errors"
	"testing"

	connect "connectrpc.com/connect"

	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/service"
)

func TestToConnectError_TypedStaleConflictHeaders(t *testing.T) {
	err := &service.ConflictError{
		OutcomeCode:    service.OutcomeStaleBase,
		AttemptID:      "attempt-123",
		BaseRevisionID: "base-rev",
		HeadRevisionID: "head-rev",
		HeadVersion:    9,
		Message:        "base revision is stale",
	}
	translated := toConnectError(err)

	var connectErr *connect.Error
	if !errors.As(translated, &connectErr) {
		t.Fatalf("expected connect.Error, got %T", translated)
	}
	if connectErr.Code() != connect.CodeFailedPrecondition {
		t.Fatalf("expected failed_precondition, got %s", connectErr.Code())
	}
	if got := connectErr.Meta().Get(service.HeaderOutcomeCode); got != service.OutcomeStaleBase {
		t.Fatalf("expected stale_base outcome header, got %q", got)
	}
	if got := connectErr.Meta().Get(service.HeaderAttemptID); got != "attempt-123" {
		t.Fatalf("expected attempt header, got %q", got)
	}
	if got := connectErr.Meta().Get(service.HeaderHeadVersion); got != "9" {
		t.Fatalf("expected head version 9, got %q", got)
	}
	if got := connectErr.Meta().Get(service.HeaderErrorCode); got != service.ConflictCodeStaleRevision {
		t.Fatalf("expected stale revision code, got %q", got)
	}
}

func TestToConnectError_LockTimeoutUsesAborted(t *testing.T) {
	err := &service.ConflictError{OutcomeCode: service.OutcomeLockTimeout, AttemptID: "attempt-1", HeadVersion: 4, Message: "lock timeout"}
	translated := toConnectError(err)

	var connectErr *connect.Error
	if !errors.As(translated, &connectErr) {
		t.Fatalf("expected connect.Error, got %T", translated)
	}
	if connectErr.Code() != connect.CodeAborted {
		t.Fatalf("expected aborted, got %s", connectErr.Code())
	}
}

