package handler

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	connect "connectrpc.com/connect"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/service"
)

type ConnectDrawingRevisionService struct {
	svc *service.Service
}

var _ drawingv1connect.DrawingRevisionServiceHandler = (*ConnectDrawingRevisionService)(nil)

func NewConnectDrawingRevisionService(svc *service.Service) *ConnectDrawingRevisionService {
	return &ConnectDrawingRevisionService{svc: svc}
}

func (h *ConnectDrawingRevisionService) CreateDrawing(ctx context.Context, req *connect.Request[drawingv1.CreateDrawingRequest]) (*connect.Response[drawingv1.CreateDrawingResponse], error) {
	response, err := h.svc.CreateDrawing(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectDrawingRevisionService) GetDrawing(ctx context.Context, req *connect.Request[drawingv1.GetDrawingRequest]) (*connect.Response[drawingv1.GetDrawingResponse], error) {
	drawing, err := h.svc.GetDrawing(ctx, req.Msg.GetDrawingId())
	if err != nil {
		return nil, toConnectError(err)
	}
	response := connect.NewResponse(&drawingv1.GetDrawingResponse{Drawing: drawing})
	response.Header().Set(service.HeaderHeadVersion, strconv.FormatUint(uint64(drawing.GetRevisionCount()), 10))
	return response, nil
}

func (h *ConnectDrawingRevisionService) ListDrawings(ctx context.Context, req *connect.Request[drawingv1.ListDrawingsRequest]) (*connect.Response[drawingv1.ListDrawingsResponse], error) {
	response, err := h.svc.ListDrawings(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectDrawingRevisionService) UpdateDrawing(ctx context.Context, req *connect.Request[drawingv1.UpdateDrawingRequest]) (*connect.Response[drawingv1.UpdateDrawingResponse], error) {
	response, err := h.svc.UpdateDrawing(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectDrawingRevisionService) GetDrawingState(ctx context.Context, req *connect.Request[drawingv1.GetDrawingStateRequest]) (*connect.Response[drawingv1.GetDrawingStateResponse], error) {
	response, err := h.svc.GetDrawingState(ctx, req.Msg.GetDrawingId(), req.Msg.GetRevisionId())
	if err != nil {
		return nil, toConnectError(err)
	}
	connectResponse := connect.NewResponse(response)
	connectResponse.Header().Set(service.HeaderHeadVersion, strconv.FormatUint(uint64(response.GetDrawing().GetRevisionCount()), 10))
	return connectResponse, nil
}

func (h *ConnectDrawingRevisionService) ListDrawingRevisions(ctx context.Context, req *connect.Request[drawingv1.ListDrawingRevisionsRequest]) (*connect.Response[drawingv1.ListDrawingRevisionsResponse], error) {
	response, err := h.svc.ListDrawingRevisions(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectDrawingRevisionService) GetDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.GetDrawingRevisionRequest]) (*connect.Response[drawingv1.GetDrawingRevisionResponse], error) {
	response, err := h.svc.GetDrawingRevision(ctx, req.Msg.GetDrawingId(), req.Msg.GetRevisionId())
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectDrawingRevisionService) StoreDrawingRevision(ctx context.Context, req *connect.Request[drawingv1.StoreDrawingRevisionRequest]) (*connect.Response[drawingv1.StoreDrawingRevisionResponse], error) {
	response, metadata, err := h.svc.StoreDrawingRevision(ctx, req.Msg, req.Header().Get(service.HeaderBaseRevisionID), parseHeadVersion(req.Header().Get(service.HeaderRequestedHeadVersion)))
	if err != nil {
		return nil, toConnectError(err)
	}
	connectResponse := connect.NewResponse(response)
	connectResponse.Header().Set(service.HeaderHeadVersion, strconv.FormatUint(uint64(response.GetDrawing().GetRevisionCount()), 10))
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

func toConnectError(err error) error {
	switch {
	case errors.Is(err, service.ErrInvalidInput):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, service.ErrNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, service.ErrConflict):
		var conflictErr *service.ConflictError
		if errors.As(err, &conflictErr) {
			code := connect.CodeAlreadyExists
			if conflictErr.OutcomeCode == service.OutcomeStaleBase {
				code = connect.CodeFailedPrecondition
			}
			if conflictErr.OutcomeCode == service.OutcomeLockTimeout {
				code = connect.CodeAborted
			}
			connectErr := connect.NewError(code, err)
			if conflictErr.OutcomeCode != "" {
				connectErr.Meta().Set(service.HeaderOutcomeCode, conflictErr.OutcomeCode)
			}
			if conflictErr.AttemptID != "" {
				connectErr.Meta().Set(service.HeaderAttemptID, conflictErr.AttemptID)
			}
			if conflictErr.HeadVersion > 0 {
				connectErr.Meta().Set(service.HeaderHeadVersion, strconv.FormatUint(uint64(conflictErr.HeadVersion), 10))
			}
			if conflictErr.OutcomeCode == service.OutcomeStaleBase {
				connectErr.Meta().Set(service.HeaderErrorCode, service.ConflictCodeStaleRevision)
				if conflictErr.BaseRevisionID != "" {
					connectErr.Meta().Set(service.HeaderBaseRevisionID, conflictErr.BaseRevisionID)
				}
				if conflictErr.HeadRevisionID != "" {
					connectErr.Meta().Set(service.HeaderHeadRevisionID, conflictErr.HeadRevisionID)
				}
				connectErr.Meta().Set(service.HeaderRetryAfter, fmt.Sprintf("%.3f", float64(service.DefaultRetryAfterMs)/1000.0))
			}
			return connectErr
		}
		return connect.NewError(connect.CodeAlreadyExists, err)
	default:
		service.RecordInternalError()
		return connect.NewError(connect.CodeInternal, err)
	}
}

func parseHeadVersion(raw string) uint32 {
	parsed, err := strconv.ParseUint(raw, 10, 32)
	if err != nil {
		return 0
	}
	return uint32(parsed)
}

