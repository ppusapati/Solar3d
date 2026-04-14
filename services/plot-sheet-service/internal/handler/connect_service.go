package handler

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	connect "connectrpc.com/connect"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/plot-sheet-service/internal/service"
)

type ConnectPlotSheetService struct {
	svc *service.Service
}

var _ drawingv1connect.PlotSheetServiceHandler = (*ConnectPlotSheetService)(nil)

func NewConnectPlotSheetService(svc *service.Service) *ConnectPlotSheetService {
	return &ConnectPlotSheetService{svc: svc}
}

func (h *ConnectPlotSheetService) CreateSheet(ctx context.Context, req *connect.Request[drawingv1.CreateSheetRequest]) (*connect.Response[drawingv1.CreateSheetResponse], error) {
	response, err := h.svc.CreateSheet(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectPlotSheetService) PublishDrawing(ctx context.Context, req *connect.Request[drawingv1.PublishDrawingRequest]) (*connect.Response[drawingv1.PublishDrawingResponse], error) {
	response, err := h.svc.PublishDrawing(ctx, req.Msg)
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

