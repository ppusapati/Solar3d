package handler

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	connect "connectrpc.com/connect"
	drawingv1 "p9e.in/samavaya/solar3d/gen/drawing/v1"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/cad-annotation-service/internal/service"
)

type ConnectCadAnnotationService struct {
	svc *service.Service
}

var _ drawingv1connect.CadAnnotationServiceHandler = (*ConnectCadAnnotationService)(nil)

func NewConnectCadAnnotationService(svc *service.Service) *ConnectCadAnnotationService {
	return &ConnectCadAnnotationService{svc: svc}
}

func (h *ConnectCadAnnotationService) CreateAnnotation(ctx context.Context, req *connect.Request[drawingv1.CreateAnnotationRequest]) (*connect.Response[drawingv1.CreateAnnotationResponse], error) {
	response, err := h.svc.CreateAnnotation(ctx, req.Msg)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(response), nil
}

func (h *ConnectCadAnnotationService) RegenerateAssociativeAnnotations(ctx context.Context, req *connect.Request[drawingv1.RegenerateAssociativeAnnotationsRequest]) (*connect.Response[drawingv1.RegenerateAssociativeAnnotationsResponse], error) {
	response, err := h.svc.RegenerateAssociativeAnnotations(ctx, req.Msg)
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

