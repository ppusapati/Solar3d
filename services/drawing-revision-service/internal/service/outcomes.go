package service

const (
	HeaderOutcomeCode          = "x-solar3d-outcome-code"
	HeaderAttemptID            = "x-solar3d-attempt-id"
	HeaderHeadVersion          = "x-solar3d-head-version"
	HeaderBaseRevisionID       = "x-solar3d-base-revision-id"
	HeaderRequestedHeadVersion = "x-solar3d-requested-head-version"
	HeaderErrorCode            = "x-solar3d-error-code"
	HeaderHeadRevisionID       = "x-solar3d-head-revision-id"
	HeaderRetryAfter           = "retry-after"

	OutcomeCommitted           = "committed"
	OutcomeStaleBase           = "stale_base"
	OutcomeLockTimeout         = "lock_timeout"
	OutcomeIdempotentDuplicate = "idempotent_duplicate"
	ConflictCodeStaleRevision  = "stale_revision"
	DefaultRetryAfterMs        = 300
)

type StoreRevisionMetadata struct {
	OutcomeCode string
	AttemptID   string
	HeadVersion uint32
}

type ConflictError struct {
	OutcomeCode    string
	AttemptID      string
	BaseRevisionID string
	HeadRevisionID string
	HeadVersion    uint32
	Message        string
}

func (e *ConflictError) Error() string {
	if e == nil || e.Message == "" {
		return ErrConflict.Error()
	}
	return ErrConflict.Error() + ": " + e.Message
}

func (e *ConflictError) Unwrap() error {
	return ErrConflict
}

