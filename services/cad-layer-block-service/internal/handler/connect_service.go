package handler

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	connect "connectrpc.com/connect"
	drawingv1 "github.com/solar3d/solar3d/gen/drawing/v1"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/cad-layer-block-service/internal/service"
)

type ConnectCadLayerBlockService struct {
	svc *service.Service
}

var _ drawingv1connect.CadLayerBlockServiceHandler = (*ConnectCadLayerBlockService)(nil)

func NewConnectCadLayerBlockService(svc *service.Service) *ConnectCadLayerBlockService {
	return &ConnectCadLayerBlockService{svc: svc}
}

func (h *ConnectCadLayerBlockService) UpsertLayer(ctx context.Context, req *connect.Request[drawingv1.UpsertLayerRequest]) (*connect.Response[drawingv1.UpsertLayerResponse], error) {
	response, err := h.svc.UpsertLayer(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectCadLayerBlockService) CreateBlockDefinition(ctx context.Context, req *connect.Request[drawingv1.CreateBlockDefinitionRequest]) (*connect.Response[drawingv1.CreateBlockDefinitionResponse], error) {
	response, err := h.svc.CreateBlockDefinition(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectCadLayerBlockService) InsertBlockReference(ctx context.Context, req *connect.Request[drawingv1.InsertBlockReferenceRequest]) (*connect.Response[drawingv1.InsertBlockReferenceResponse], error) {
	response, err := h.svc.InsertBlockReference(ctx, req.Msg)
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

