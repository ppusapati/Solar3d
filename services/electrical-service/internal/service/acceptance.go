package service

// Acceptance workflow methods for ElectricalNetwork.
//
// These methods enforce the DRAFT → REVIEW_PENDING → APPROVED/REJECTED lifecycle
// for electrical networks. The gate mirrors the layout acceptance pattern and is
// consumed by the transmission service, which checks that a network is APPROVED
// before a transmission route can be created.

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"

	"p9e.in/samavaya/solar3d/electrical-service/internal/domain"
)

// SubmitNetworkForReviewRequest carries the inputs for submitting an
// electrical network into the review queue.
type SubmitNetworkForReviewRequest struct {
	NetworkID        uuid.UUID
	SubmissionReason string
	ActorID          string
}

// ApproveNetworkRequest carries the inputs for approving a network that is
// currently in REVIEW_PENDING state.
type ApproveNetworkRequest struct {
	NetworkID        uuid.UUID
	ActorID          string
	QualityScore     float64 // [0, 1]
	FeasibilityScore float64 // [0, 1]
	Comments         []string
}

// RejectNetworkRequest carries the inputs for rejecting a network.
type RejectNetworkRequest struct {
	NetworkID        uuid.UUID
	ActorID          string
	RejectionReasons []string
}

// SubmitNetworkForReview transitions an electrical network from DRAFT (or
// REJECTED) into REVIEW_PENDING.
func (s *ElectricalService) SubmitNetworkForReview(ctx context.Context, req SubmitNetworkForReviewRequest) (*domain.ElectricalNetwork, error) {
	net, err := s.repo.GetNetworkByID(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("submit network for review: fetch network: %w", err)
	}

	if net.ReviewMetadata != nil && net.ReviewMetadata.Status == domain.AcceptanceStatusApproved {
		return nil, domain.ErrNetworkAlreadyApproved
	}

	now := time.Now().UTC()
	meta := &domain.ReviewMetadata{
		Status:            domain.AcceptanceStatusReviewPending,
		ReviewedByActorID: req.ActorID,
		ReviewedAt:        &now,
		ReviewComments:    []string{req.SubmissionReason},
	}

	metaJSON, err := json.Marshal(meta)
	if err != nil {
		return nil, fmt.Errorf("submit network for review: marshal metadata: %w", err)
	}

	if err := s.repo.UpdateNetworkReviewMetadata(ctx, req.NetworkID, metaJSON); err != nil {
		return nil, fmt.Errorf("submit network for review: persist metadata: %w", err)
	}

	net.ReviewMetadata = meta
	return net, nil
}

// ApproveNetwork transitions an electrical network from REVIEW_PENDING to APPROVED.
func (s *ElectricalService) ApproveNetwork(ctx context.Context, req ApproveNetworkRequest) (*domain.ElectricalNetwork, error) {
	net, err := s.repo.GetNetworkByID(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("approve network: fetch network: %w", err)
	}

	if net.ReviewMetadata == nil || net.ReviewMetadata.Status != domain.AcceptanceStatusReviewPending {
		return nil, domain.ErrNetworkNotInReview
	}

	now := time.Now().UTC()
	meta := &domain.ReviewMetadata{
		Status:                    domain.AcceptanceStatusApproved,
		ReviewedByActorID:         req.ActorID,
		ReviewedAt:                &now,
		QualityScore:              req.QualityScore,
		ApprovalTimestampUnixSecs: now.Format(time.RFC3339),
		ReviewComments:            req.Comments,
	}

	metaJSON, err := json.Marshal(meta)
	if err != nil {
		return nil, fmt.Errorf("approve network: marshal metadata: %w", err)
	}

	if err := s.repo.UpdateNetworkReviewMetadata(ctx, req.NetworkID, metaJSON); err != nil {
		return nil, fmt.Errorf("approve network: persist metadata: %w", err)
	}

	net.ReviewMetadata = meta
	return net, nil
}

// RejectNetwork transitions an electrical network from REVIEW_PENDING to REJECTED.
// At least one rejection reason must be provided.
func (s *ElectricalService) RejectNetwork(ctx context.Context, req RejectNetworkRequest) (*domain.ElectricalNetwork, error) {
	if len(req.RejectionReasons) == 0 {
		return nil, domain.ErrNetworkRejectReasonsRequired
	}

	net, err := s.repo.GetNetworkByID(ctx, req.NetworkID)
	if err != nil {
		return nil, fmt.Errorf("reject network: fetch network: %w", err)
	}

	if net.ReviewMetadata == nil || net.ReviewMetadata.Status != domain.AcceptanceStatusReviewPending {
		return nil, domain.ErrNetworkNotInReview
	}

	now := time.Now().UTC()
	meta := &domain.ReviewMetadata{
		Status:            domain.AcceptanceStatusRejected,
		ReviewedByActorID: req.ActorID,
		ReviewedAt:        &now,
		Blockers:          req.RejectionReasons,
	}

	metaJSON, err := json.Marshal(meta)
	if err != nil {
		return nil, fmt.Errorf("reject network: marshal metadata: %w", err)
	}

	if err := s.repo.UpdateNetworkReviewMetadata(ctx, req.NetworkID, metaJSON); err != nil {
		return nil, fmt.Errorf("reject network: persist metadata: %w", err)
	}

	net.ReviewMetadata = meta
	return net, nil
}
