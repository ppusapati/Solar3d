package handler

import (
	"errors"
	"fmt"
	"testing"

	connect "connectrpc.com/connect"

	"solar3d/cad-core-service/internal/service"
)

func TestToConnectError_StaleConflictIncludesMetadata(t *testing.T) {
	err := service.NewStaleRevisionConflict("base-rev", "head-rev")
	err.OutcomeCode = service.OutcomeStaleBase
	err.AttemptID = "attempt-1"
	err.HeadVersion = 8
	translated := toConnectError(err)

	var connectErr *connect.Error
	if !errors.As(translated, &connectErr) {
		t.Fatalf("expected connect.Error, got %T", translated)
	}
	if connectErr.Code() != connect.CodeFailedPrecondition {
		t.Fatalf("expected failed_precondition, got %s", connectErr.Code())
	}
	if got := connectErr.Meta().Get("x-solar3d-error-code"); got != service.ConflictCodeStaleRevision {
		t.Fatalf("expected stale error code header, got %q", got)
	}
	if got := connectErr.Meta().Get(service.HeaderOutcomeCode); got != service.OutcomeStaleBase {
		t.Fatalf("expected stale outcome header, got %q", got)
	}
	if got := connectErr.Meta().Get(service.HeaderAttemptID); got != "attempt-1" {
		t.Fatalf("expected attempt id header, got %q", got)
	}
	if got := connectErr.Meta().Get(service.HeaderHeadVersion); got != "8" {
		t.Fatalf("expected head version header, got %q", got)
	}
	if got := connectErr.Meta().Get("x-solar3d-base-revision-id"); got != "base-rev" {
		t.Fatalf("expected base revision header, got %q", got)
	}
	if got := connectErr.Meta().Get("x-solar3d-head-revision-id"); got != "head-rev" {
		t.Fatalf("expected head revision header, got %q", got)
	}
	if got := connectErr.Meta().Get("retry-after"); got == "" {
		t.Fatal("expected retry-after header to be set")
	}
}

func TestToConnectError_GenericConflictHasNoStructuredHeaders(t *testing.T) {
	err := fmt.Errorf("%w: conflict", service.ErrConflict)
	translated := toConnectError(err)

	var connectErr *connect.Error
	if !errors.As(translated, &connectErr) {
		t.Fatalf("expected connect.Error, got %T", translated)
	}
	if connectErr.Code() != connect.CodeFailedPrecondition {
		t.Fatalf("expected failed_precondition, got %s", connectErr.Code())
	}
	if got := connectErr.Meta().Get("x-solar3d-error-code"); got != "" {
		t.Fatalf("expected no structured code header, got %q", got)
	}
}

