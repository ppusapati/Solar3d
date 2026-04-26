package handler

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	connect "connectrpc.com/connect"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/interop-service/internal/service"
)

type ConnectInteropService struct {
	svc *service.Service
}

var _ drawingv1connect.InteropServiceHandler = (*ConnectInteropService)(nil)

func NewConnectInteropService(svc *service.Service) *ConnectInteropService {
	return &ConnectInteropService{svc: svc}
}

func (h *ConnectInteropService) ExportDrawing(ctx context.Context, req *connect.Request[drawingv1.ExportDrawingRequest]) (*connect.Response[drawingv1.ExportDrawingResponse], error) {
	response, err := h.svc.ExportDrawing(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectInteropService) ImportDrawing(ctx context.Context, req *connect.Request[drawingv1.ImportDrawingRequest]) (*connect.Response[drawingv1.ImportDrawingResponse], error) {
	response, err := h.svc.ImportDrawing(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectInteropService) ValidateDrawingRoundTrip(ctx context.Context, req *connect.Request[drawingv1.ValidateDrawingRoundTripRequest]) (*connect.Response[drawingv1.ValidateDrawingRoundTripResponse], error) {
	response, err := h.svc.ValidateDrawingRoundTrip(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func toConnectError(err error) error {
	switch {
	case errors.Is(err, service.ErrInvalidInput):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, service.ErrNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, service.ErrConflict):
		connectErr := connect.NewError(connect.CodeFailedPrecondition, err)
		var conflictErr *service.ConflictError
		if errors.As(err, &conflictErr) {
			if conflictErr.Code != "" {
				connectErr.Meta().Set("x-solar3d-error-code", conflictErr.Code)
			}
			if conflictErr.OutcomeCode != "" {
				connectErr.Meta().Set("x-solar3d-outcome-code", conflictErr.OutcomeCode)
			}
			if conflictErr.AttemptID != "" {
				connectErr.Meta().Set("x-solar3d-attempt-id", conflictErr.AttemptID)
			}
			if conflictErr.HeadVersion > 0 {
				connectErr.Meta().Set("x-solar3d-head-version", strconv.FormatUint(uint64(conflictErr.HeadVersion), 10))
			}
			if conflictErr.BaseRevisionID != "" {
				connectErr.Meta().Set("x-solar3d-base-revision-id", conflictErr.BaseRevisionID)
			}
			if conflictErr.HeadRevisionID != "" {
				connectErr.Meta().Set("x-solar3d-head-revision-id", conflictErr.HeadRevisionID)
			}
			if conflictErr.RetryAfterMs > 0 {
				connectErr.Meta().Set("retry-after", fmt.Sprintf("%.3f", float64(conflictErr.RetryAfterMs)/1000.0))
			}
		}
		return connectErr
	default:
		service.RecordInternalError()
		return connect.NewError(connect.CodeInternal, err)
	}
}

