package handler

import (
	"context"

	connect "connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	pkgErrors "p9e.in/samavaya/packages/errors"
	electricalv1 "p9e.in/samavaya/solar3d/gen/electrical/v1"
	"p9e.in/samavaya/solar3d/electrical-service/internal/domain"
	"p9e.in/samavaya/solar3d/electrical-service/internal/service"

	"github.com/google/uuid"
)

// SubmitNetworkForReview transitions an electrical network from DRAFT (or
// REJECTED) into REVIEW_PENDING and persists the review metadata.
func (h *ConnectElectricalService) SubmitNetworkForReview(
	ctx context.Context,
	req *connect.Request[electricalv1.SubmitNetworkForReviewRequest],
) (*connect.Response[electricalv1.SubmitNetworkForReviewResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid network_id: %v", err).ToConnectError()
	}

	net, err := h.svc.SubmitNetworkForReview(ctx, service.SubmitNetworkForReviewRequest{
		NetworkID:        networkID,
		SubmissionReason: req.Msg.GetSubmissionReason(),
		ActorID:          req.Msg.GetSubmittedByActorId(),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.SubmitNetworkForReviewResponse{
		Network:        electricalNetworkToProto(net),
		ReviewMetadata: reviewMetadataToProto(net.ReviewMetadata),
	}), nil
}

// ApproveNetwork transitions an electrical network from REVIEW_PENDING to
// APPROVED. Rejects the call if the network is not currently in review.
func (h *ConnectElectricalService) ApproveNetwork(
	ctx context.Context,
	req *connect.Request[electricalv1.ApproveNetworkRequest],
) (*connect.Response[electricalv1.ApproveNetworkResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid network_id: %v", err).ToConnectError()
	}

	net, err := h.svc.ApproveNetwork(ctx, service.ApproveNetworkRequest{
		NetworkID:        networkID,
		ActorID:          req.Msg.GetApprovedByActorId(),
		QualityScore:     req.Msg.GetQualityScore(),
		FeasibilityScore: req.Msg.GetFeasibilityScore(),
		Comments:         req.Msg.GetApprovalComments(),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.ApproveNetworkResponse{
		Network:        electricalNetworkToProto(net),
		ReviewMetadata: reviewMetadataToProto(net.ReviewMetadata),
	}), nil
}

// RejectNetwork transitions an electrical network from REVIEW_PENDING to
// REJECTED with the provided rejection reasons. At least one reason is
// required; the service enforces this.
func (h *ConnectElectricalService) RejectNetwork(
	ctx context.Context,
	req *connect.Request[electricalv1.RejectNetworkRequest],
) (*connect.Response[electricalv1.RejectNetworkResponse], error) {
	networkID, err := uuid.Parse(req.Msg.GetNetworkId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid network_id: %v", err).ToConnectError()
	}

	net, err := h.svc.RejectNetwork(ctx, service.RejectNetworkRequest{
		NetworkID:        networkID,
		ActorID:          req.Msg.GetRejectedByActorId(),
		RejectionReasons: req.Msg.GetRejectionReasons(),
	})
	if err != nil {
		return nil, electricalConnectError(err)
	}

	return connect.NewResponse(&electricalv1.RejectNetworkResponse{
		Network:        electricalNetworkToProto(net),
		ReviewMetadata: reviewMetadataToProto(net.ReviewMetadata),
	}), nil
}

// reviewMetadataToProto maps a domain ReviewMetadata to its proto representation.
// Returns nil when the input is nil, matching the optional-field semantics on the
// proto response messages.
func reviewMetadataToProto(m *domain.ReviewMetadata) *electricalv1.ReviewMetadata {
	if m == nil {
		return nil
	}
	out := &electricalv1.ReviewMetadata{
		Status:                    electricalv1.AcceptanceStatus(m.Status),
		ReviewedByActorId:         m.ReviewedByActorID,
		QualityScore:              m.QualityScore,
		ReviewComments:            m.ReviewComments,
		Blockers:                  m.Blockers,
		ApprovalTimestampUnixSecs: m.ApprovalTimestampUnixSecs,
	}
	if m.ReviewedAt != nil {
		out.ReviewedAt = timestamppb.New(*m.ReviewedAt)
	}
	return out
}
