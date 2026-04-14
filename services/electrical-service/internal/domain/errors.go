package domain

import "errors"

// Acceptance workflow errors for electrical networks.
var (
	ErrNetworkNotInReview           = errors.New("electrical network is not in REVIEW_PENDING state")
	ErrNetworkAlreadyApproved       = errors.New("electrical network is already approved")
	ErrNetworkRejectReasonsRequired = errors.New("at least one rejection reason is required")
)
