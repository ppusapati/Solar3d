package handler

import (
	"context"
	"errors"

	"p9e.in/samavaya/solar3d/compute-service/internal/mappers"
	"p9e.in/samavaya/solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	geov1 "p9e.in/samavaya/solar3d/gen/geo/v1"
	geov1connect "p9e.in/samavaya/solar3d/gen/geo/v1/geov1connect"
)

type GeoServiceHandler struct {
	svc *service.GeoService
}

var _ geov1connect.GeoServiceHandler = (*GeoServiceHandler)(nil)

func NewGeoServiceHandler(svc *service.GeoService) *GeoServiceHandler {
	return &GeoServiceHandler{svc: svc}
}

func (h *GeoServiceHandler) BufferPoint(
	ctx context.Context,
	req *connect.Request[geov1.BufferPointRequest],
) (*connect.Response[geov1.BufferPointResponse], error) {
	domainReq := mappers.ProtoToBufferPoint(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid buffer point request"))
	}
	resp, err := h.svc.BufferPoint(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.BufferPointToProto(resp)), nil
}

func (h *GeoServiceHandler) NearestPoint(
	ctx context.Context,
	req *connect.Request[geov1.NearestPointRequest],
) (*connect.Response[geov1.NearestPointResponse], error) {
	domainReq := mappers.ProtoToNearestPoint(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid nearest point request"))
	}
	resp, err := h.svc.NearestPoint(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.NearestPointToProto(resp)), nil
}

func (h *GeoServiceHandler) GenerateContours(
	ctx context.Context,
	req *connect.Request[geov1.GenerateContoursRequest],
) (*connect.Response[geov1.GenerateContoursResponse], error) {
	domainReq := mappers.ProtoToGenerateContours(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid generate contours request"))
	}
	resp, err := h.svc.GenerateContours(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.GenerateContoursToProto(resp)), nil
}

