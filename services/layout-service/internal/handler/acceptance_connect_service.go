package handler

import (
	"context"
	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"google.golang.org/protobuf/types/known/timestamppb"

	layoutv1 "p9e.in/samavaya/solar3d/gen/layout/v1"
	"p9e.in/samavaya/solar3d/layout-service/internal/domain"
	"p9e.in/samavaya/solar3d/layout-service/internal/service"
)

// SubmitLayoutForReview transitions a layout into REVIEW_PENDING so that the
// LayoutReady → ElectricalReady planning gate can evaluate it.
func (h *ConnectLayoutService) SubmitLayoutForReview(
	ctx context.Context,
	req *connect.Request[layoutv1.SubmitLayoutForReviewRequest],
) (*connect.Response[layoutv1.SubmitLayoutForReviewResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}

	layout, err := h.svc.SubmitForReview(ctx, service.SubmitForReviewRequest{
		LayoutID:         layoutID,
		SubmissionReason: req.Msg.GetSubmissionReason(),
		ActorID:          req.Msg.GetSubmittedByActorId(),
	})
	if err != nil {
		return nil, layoutAcceptanceError(err)
	}

	return connect.NewResponse(&layoutv1.SubmitLayoutForReviewResponse{
		Layout:         layoutToProto(layout),
		ReviewMetadata: layoutReviewMetadataToProto(layout.ReviewMetadata),
	}), nil
}

// ApproveLayout transitions a layout from REVIEW_PENDING to APPROVED, satisfying
// the ElectricalReady phase gate.
func (h *ConnectLayoutService) ApproveLayout(
	ctx context.Context,
	req *connect.Request[layoutv1.ApproveLayoutRequest],
) (*connect.Response[layoutv1.ApproveLayoutResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}

	layout, err := h.svc.ApproveLayout(ctx, service.ApproveLayoutRequest{
		LayoutID:         layoutID,
		QualityScore:     req.Msg.GetQualityScore(),
		ApprovalComments: req.Msg.GetApprovalComments(),
		ActorID:          req.Msg.GetApprovedByActorId(),
	})
	if err != nil {
		return nil, layoutAcceptanceError(err)
	}

	return connect.NewResponse(&layoutv1.ApproveLayoutResponse{
		Layout:         layoutToProto(layout),
		ReviewMetadata: layoutReviewMetadataToProto(layout.ReviewMetadata),
	}), nil
}

// RejectLayout transitions a layout from REVIEW_PENDING to REJECTED with
// documented reasons. At least one rejection reason is required; the service
// enforces this.
func (h *ConnectLayoutService) RejectLayout(
	ctx context.Context,
	req *connect.Request[layoutv1.RejectLayoutRequest],
) (*connect.Response[layoutv1.RejectLayoutResponse], error) {
	layoutID, err := uuid.Parse(req.Msg.GetLayoutId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layout_id"))
	}

	layout, err := h.svc.RejectLayout(ctx, service.RejectLayoutRequest{
		LayoutID:         layoutID,
		RejectionReasons: req.Msg.GetRejectionReasons(),
		ActorID:          req.Msg.GetRejectedByActorId(),
	})
	if err != nil {
		return nil, layoutAcceptanceError(err)
	}

	return connect.NewResponse(&layoutv1.RejectLayoutResponse{
		Layout:         layoutToProto(layout),
		ReviewMetadata: layoutReviewMetadataToProto(layout.ReviewMetadata),
	}), nil
}

// layoutReviewMetadataToProto maps domain review metadata onto its proto form.
// Returns nil if the input is nil so response messages can pass it through
// without nil-guarding at each call site.
func layoutReviewMetadataToProto(m *domain.ReviewMetadata) *layoutv1.ReviewMetadata {
	if m == nil {
		return nil
	}
	out := &layoutv1.ReviewMetadata{
		Status:                    layoutv1.AcceptanceStatus(m.Status),
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

// layoutAcceptanceError maps domain state-machine errors onto the appropriate
// Connect code, so clients can distinguish bad-request from
// failed-precondition (e.g., approving a layout that is not under review).
func layoutAcceptanceError(err error) error {
	switch {
	case errors.Is(err, domain.ErrInvalidID):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, domain.ErrRejectReasonsRequired):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, domain.ErrLayoutAlreadyApproved),
		errors.Is(err, domain.ErrLayoutNotInReview):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}
