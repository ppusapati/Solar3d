package service

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"

	"solar3d/layout-service/internal/domain"
)

// SubmitForReviewRequest is the input for submitting a layout for acceptance review.
type SubmitForReviewRequest struct {
	LayoutID         uuid.UUID
	SubmissionReason string
	ActorID          string
}

// ApproveLayoutRequest is the input for approving a layout's acceptance review.
type ApproveLayoutRequest struct {
	LayoutID         uuid.UUID
	QualityScore     float64 // [0, 1]
	ApprovalComments []string
	ActorID          string
}

// RejectLayoutRequest is the input for rejecting a layout's acceptance review.
type RejectLayoutRequest struct {
	LayoutID         uuid.UUID
	RejectionReasons []string
	ActorID          string
}

// SubmitForReview transitions a layout's review status to REVIEW_PENDING.
// Returns an error if the layout is already approved so that prior approvals are not silently
// invalidated by a re-submission without an explicit rejection cycle first.
func (s *Service) SubmitForReview(ctx context.Context, req SubmitForReviewRequest) (*domain.Layout, error) {
	if req.LayoutID == uuid.Nil {
		return nil, fmt.Errorf("%w: layout_id", domain.ErrInvalidID)
	}
	if req.ActorID == "" {
		return nil, fmt.Errorf("actor_id is required")
	}
	if req.SubmissionReason == "" {
		return nil, fmt.Errorf("submission_reason is required")
	}

	layout, err := s.repo.GetLayout(ctx, req.LayoutID)
	if err != nil {
		return nil, fmt.Errorf("submit for review: %w", err)
	}

	if layout.ReviewMetadata != nil &&
		layout.ReviewMetadata.Status == domain.AcceptanceStatusApproved {
		return nil, fmt.Errorf("submit for review: %w", domain.ErrLayoutAlreadyApproved)
	}

	now := time.Now().UTC()
	layout.ReviewMetadata = &domain.ReviewMetadata{
		Status:                    domain.AcceptanceStatusReviewPending,
		ReviewedByActorID:         req.ActorID,
		ReviewedAt:                &now,
		ReviewComments:            []string{req.SubmissionReason},
		ApprovalTimestampUnixSecs: "",
	}

	if err := s.repo.UpdateLayoutReviewMetadata(ctx, req.LayoutID, layout.ReviewMetadata); err != nil {
		return nil, fmt.Errorf("submit for review: persist: %w", err)
	}

	return layout, nil
}

// ApproveLayout sets a layout's review status to APPROVED.
// Only layouts in REVIEW_PENDING state can be approved.
// Once approved, the layout satisfies the gate for ElectricalReady phase transition.
func (s *Service) ApproveLayout(ctx context.Context, req ApproveLayoutRequest) (*domain.Layout, error) {
	if req.LayoutID == uuid.Nil {
		return nil, fmt.Errorf("%w: layout_id", domain.ErrInvalidID)
	}
	if req.ActorID == "" {
		return nil, fmt.Errorf("actor_id is required")
	}
	if req.QualityScore < 0 || req.QualityScore > 1 {
		return nil, fmt.Errorf("quality_score must be in [0, 1], got %f", req.QualityScore)
	}

	layout, err := s.repo.GetLayout(ctx, req.LayoutID)
	if err != nil {
		return nil, fmt.Errorf("approve layout: %w", err)
	}

	if layout.ReviewMetadata == nil ||
		layout.ReviewMetadata.Status != domain.AcceptanceStatusReviewPending {
		return nil, fmt.Errorf("approve layout: %w", domain.ErrLayoutNotInReview)
	}

	now := time.Now().UTC()
	layout.ReviewMetadata = &domain.ReviewMetadata{
		Status:                    domain.AcceptanceStatusApproved,
		ReviewedByActorID:         req.ActorID,
		ReviewedAt:                &now,
		QualityScore:              req.QualityScore,
		ReviewComments:            req.ApprovalComments,
		ApprovalTimestampUnixSecs: now.Format(time.RFC3339),
	}

	if err := s.repo.UpdateLayoutReviewMetadata(ctx, req.LayoutID, layout.ReviewMetadata); err != nil {
		return nil, fmt.Errorf("approve layout: persist: %w", err)
	}

	return layout, nil
}

// RejectLayout sets a layout's review status to REJECTED with documented reasons.
// The layout must be in REVIEW_PENDING state. After rejection, the submitter must
// address all rejection reasons and re-submit before approval is possible.
func (s *Service) RejectLayout(ctx context.Context, req RejectLayoutRequest) (*domain.Layout, error) {
	if req.LayoutID == uuid.Nil {
		return nil, fmt.Errorf("%w: layout_id", domain.ErrInvalidID)
	}
	if req.ActorID == "" {
		return nil, fmt.Errorf("actor_id is required")
	}
	if len(req.RejectionReasons) == 0 {
		return nil, domain.ErrRejectReasonsRequired
	}

	layout, err := s.repo.GetLayout(ctx, req.LayoutID)
	if err != nil {
		return nil, fmt.Errorf("reject layout: %w", err)
	}

	if layout.ReviewMetadata == nil ||
		layout.ReviewMetadata.Status != domain.AcceptanceStatusReviewPending {
		return nil, fmt.Errorf("reject layout: %w", domain.ErrLayoutNotInReview)
	}

	now := time.Now().UTC()
	layout.ReviewMetadata = &domain.ReviewMetadata{
		Status:            domain.AcceptanceStatusRejected,
		ReviewedByActorID: req.ActorID,
		ReviewedAt:        &now,
		Blockers:          req.RejectionReasons,
	}

	if err := s.repo.UpdateLayoutReviewMetadata(ctx, req.LayoutID, layout.ReviewMetadata); err != nil {
		return nil, fmt.Errorf("reject layout: persist: %w", err)
	}

	return layout, nil
}
