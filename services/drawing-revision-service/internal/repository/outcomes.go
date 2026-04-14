package repository

import (
	"errors"
	"fmt"
)

const (
	AttemptStatusPending   = "pending"
	AttemptStatusSucceeded = "succeeded"
	AttemptStatusFailed    = "failed"

	OutcomeCommitted           = "committed"
	OutcomeStaleBase           = "stale_base"
	OutcomeLockTimeout         = "lock_timeout"
	OutcomeIdempotentDuplicate = "idempotent_duplicate"
)

type StoreRevisionOutcome struct {
	Code             string
	AttemptID        string
	HeadVersion      uint32
	HeadRevisionID   string
	IdempotentReplay bool
}

type ConflictError struct {
	OutcomeCode    string
	Message        string
	AttemptID      string
	BaseRevisionID string
	HeadRevisionID string
	HeadVersion    uint32
}

func (e *ConflictError) Error() string {
	if e == nil {
		return ErrConflict.Error()
	}
	if e.Message != "" {
		return fmt.Sprintf("%s: %s", ErrConflict.Error(), e.Message)
	}
	return ErrConflict.Error()
}

func (e *ConflictError) Unwrap() error {
	return ErrConflict
}

func IsConflictOutcome(err error, outcomeCode string) bool {
	var conflictErr *ConflictError
	if !errors.As(err, &conflictErr) {
		return false
	}
	return conflictErr.OutcomeCode == outcomeCode
}

type ConflictEventInput struct {
	DrawingID      string
	CommandID      string
	Actor          string
	Summary        string
	BaseRevisionID string
	HeadRevisionID string
	HeadVersion    uint32
	OutcomeCode    string
	DetailsJSON    string
}

