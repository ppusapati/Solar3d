package handler

import (
	"context"
	"errors"

	"solar3d/compute-service/internal/mappers"
	"solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	graphv1 "github.com/solar3d/solar3d/gen/graph/v1"
	graphv1connect "github.com/solar3d/solar3d/gen/graph/v1/graphv1connect"
)

type GraphServiceHandler struct {
	svc *service.GraphService
}

var _ graphv1connect.GraphServiceHandler = (*GraphServiceHandler)(nil)

func NewGraphServiceHandler(svc *service.GraphService) *GraphServiceHandler {
	return &GraphServiceHandler{svc: svc}
}

func (h *GraphServiceHandler) MinimumSpanningTree(
	ctx context.Context,
	req *connect.Request[graphv1.MinimumSpanningTreeRequest],
) (*connect.Response[graphv1.MinimumSpanningTreeResponse], error) {
	domainReq := mappers.ProtoToMinimumSpanningTree(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid minimum spanning tree request"))
	}
	resp, err := h.svc.MinimumSpanningTree(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.MinimumSpanningTreeToProto(resp)), nil
}

func (h *GraphServiceHandler) ApproximateSteinerTree(
	ctx context.Context,
	req *connect.Request[graphv1.ApproximateSteinerTreeRequest],
) (*connect.Response[graphv1.ApproximateSteinerTreeResponse], error) {
	domainReq := mappers.ProtoToApproximateSteinerTree(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid approximate steiner tree request"))
	}
	resp, err := h.svc.ApproximateSteinerTree(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.ApproximateSteinerTreeToProto(resp)), nil
}

