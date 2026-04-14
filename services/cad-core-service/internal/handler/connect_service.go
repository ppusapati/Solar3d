package handler

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	connect "connectrpc.com/connect"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/cad-core-service/internal/service"
)

type ConnectCadCoreService struct {
	svc *service.Service
}

var _ drawingv1connect.CadCoreServiceHandler = (*ConnectCadCoreService)(nil)

func NewConnectCadCoreService(svc *service.Service) *ConnectCadCoreService {
	return &ConnectCadCoreService{svc: svc}
}

func (h *ConnectCadCoreService) ValidateDrawingCommand(ctx context.Context, req *connect.Request[drawingv1.ValidateDrawingCommandRequest]) (*connect.Response[drawingv1.ValidateDrawingCommandResponse], error) {
	response, err := h.svc.ValidateDrawingCommand(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectCadCoreService) CommitDrawingCommand(ctx context.Context, req *connect.Request[drawingv1.CommitDrawingCommandRequest]) (*connect.Response[drawingv1.CommitDrawingCommandResponse], error) {
	response, metadata, err := h.svc.CommitDrawingCommand(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	connectResponse := connect.NewResponse(response)
	if metadata.OutcomeCode != "" {
		connectResponse.Header().Set(service.HeaderOutcomeCode, metadata.OutcomeCode)
	}
	if metadata.AttemptID != "" {
		connectResponse.Header().Set(service.HeaderAttemptID, metadata.AttemptID)
	}
	if metadata.HeadVersion > 0 {
		connectResponse.Header().Set(service.HeaderHeadVersion, strconv.FormatUint(uint64(metadata.HeadVersion), 10))
	}
	return connectResponse, nil
}

func (h *ConnectCadCoreService) RevertDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.RevertDrawingRevisionRequest]) (*connect.Response[drawingv1.RevertDrawingRevisionResponse], error) {
	response, err := h.svc.RevertDrawingRevision(ctx, req.Msg)
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
			if conflictErr.OutcomeCode == service.OutcomeLockTimeout {
				connectErr = connect.NewError(connect.CodeAborted, err)
			}
			if conflictErr.Code != "" {
				connectErr.Meta().Set("x-solar3d-error-code", conflictErr.Code)
			}
			if conflictErr.OutcomeCode != "" {
				connectErr.Meta().Set(service.HeaderOutcomeCode, conflictErr.OutcomeCode)
			}
			if conflictErr.AttemptID != "" {
				connectErr.Meta().Set(service.HeaderAttemptID, conflictErr.AttemptID)
			}
			if conflictErr.HeadVersion > 0 {
				connectErr.Meta().Set(service.HeaderHeadVersion, strconv.FormatUint(uint64(conflictErr.HeadVersion), 10))
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

