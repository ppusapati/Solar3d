package handler

import (
	"errors"
	"fmt"
	"testing"

	connect "connectrpc.com/connect"

	"solar3d/cad-layer-block-service/internal/service"
)

func TestToConnectError_ConflictMetadataHeaders(t *testing.T) {
	err := &service.ConflictError{
		Code:           service.ConflictCodeStaleRevision,
		Message:        "base revision is stale",
		BaseRevisionID: "base-rev",
		HeadRevisionID: "head-rev",
		RetryAfterMs:   300,
	}
	translated := toConnectError(err)

	var connectErr *connect.Error
	if !errors.As(translated, &connectErr) {
		t.Fatalf("expected connect.Error, got %T", translated)
	}
	if connectErr.Code() != connect.CodeFailedPrecondition {
		t.Fatalf("expected failed_precondition, got %s", connectErr.Code())
	}
	if got := connectErr.Meta().Get("x-solar3d-error-code"); got != service.ConflictCodeStaleRevision {
		t.Fatalf("expected stale conflict header, got %q", got)
	}
	if got := connectErr.Meta().Get("x-solar3d-base-revision-id"); got != "base-rev" {
		t.Fatalf("expected base revision header, got %q", got)
	}
	if got := connectErr.Meta().Get("x-solar3d-head-revision-id"); got != "head-rev" {
		t.Fatalf("expected head revision header, got %q", got)
	}
	if got := connectErr.Meta().Get("retry-after"); got == "" {
		t.Fatal("expected retry-after header")
	}
}

func TestToConnectError_GenericConflictNoStructuredHeaders(t *testing.T) {
	err := fmt.Errorf("%w: generic", service.ErrConflict)
	translated := toConnectError(err)

	var connectErr *connect.Error
	if !errors.As(translated, &connectErr) {
		t.Fatalf("expected connect.Error, got %T", translated)
	}
	if got := connectErr.Meta().Get("x-solar3d-error-code"); got != "" {
		t.Fatalf("expected no error-code header, got %q", got)
	}
}

