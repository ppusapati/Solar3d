package handler

import (
	"context"
	"errors"
	"fmt"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	transmissionv1 "github.com/solar3d/solar3d/gen/transmission/v1"
	transmissionv1connect "github.com/solar3d/solar3d/gen/transmission/v1/transmissionv1connect"

	"solar3d/transmission-routing-service/internal/domain"
	"solar3d/transmission-routing-service/internal/mappers"
	"solar3d/transmission-routing-service/internal/repository"
	"solar3d/transmission-routing-service/internal/service"
)

type ConnectTransmissionRoutingService struct {
	svc *service.TransmissionService
}

var _ transmissionv1connect.TransmissionRoutingServiceHandler = (*ConnectTransmissionRoutingService)(nil)

func NewConnectTransmissionRoutingService(svc *service.TransmissionService) *ConnectTransmissionRoutingService {
	return &ConnectTransmissionRoutingService{svc: svc}
}

func (h *ConnectTransmissionRoutingService) CalculateTransmissionRoute(ctx context.Context, req *connect.Request[transmissionv1.CalculateTransmissionRouteRequest]) (*connect.Response[transmissionv1.CalculateTransmissionRouteResponse], error) {
	domainReq, err := mappers.ProtoToCalculateTransmissionRouteRequest(req.Msg)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	route, err := h.svc.CalculateTransmissionRoute(ctx, *domainReq)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.CalculateTransmissionRouteResponse{Route: mappers.RouteToProto(route)}), nil
}

func (h *ConnectTransmissionRoutingService) StreamTransmissionRoute(ctx context.Context, req *connect.Request[transmissionv1.StreamTransmissionRouteRequest], stream *connect.ServerStream[transmissionv1.StreamTransmissionRouteResponse]) error {
	if req.Msg.GetRequest() == nil {
		return connect.NewError(connect.CodeInvalidArgument, errors.New("request is required"))
	}
	domainReq, err := mappers.ProtoToCalculateTransmissionRouteRequest(req.Msg.GetRequest())
	if err != nil {
		return connect.NewError(connect.CodeInvalidArgument, err)
	}
	_, err = h.svc.StreamTransmissionRoute(ctx, *domainReq, func(update domain.ProgressUpdate) error {
		return stream.Send(mappers.ProgressUpdateToProto(&update))
	})
	if err != nil {
		return toConnectError(err)
	}
	return nil
}

func (h *ConnectTransmissionRoutingService) GetTransmissionRoute(ctx context.Context, req *connect.Request[transmissionv1.GetTransmissionRouteRequest]) (*connect.Response[transmissionv1.GetTransmissionRouteResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid route id: %w", err))
	}
	route, err := h.svc.GetTransmissionRoute(ctx, id)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.GetTransmissionRouteResponse{Route: mappers.RouteToProto(route)}), nil
}

func (h *ConnectTransmissionRoutingService) ListTransmissionRoutes(ctx context.Context, req *connect.Request[transmissionv1.ListTransmissionRoutesRequest]) (*connect.Response[transmissionv1.ListTransmissionRoutesResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid project id: %w", err))
	}
	routes, err := h.svc.ListTransmissionRoutes(ctx, projectID)
	if err != nil {
		return nil, toConnectError(err)
	}
	protoRoutes := make([]*transmissionv1.TransmissionRoute, 0, len(routes))
	for index := range routes {
		protoRoutes = append(protoRoutes, mappers.RouteToProto(&routes[index]))
	}
	return connect.NewResponse(&transmissionv1.ListTransmissionRoutesResponse{Routes: protoRoutes}), nil
}

func (h *ConnectTransmissionRoutingService) SubmitTransmissionRouteForReview(ctx context.Context, req *connect.Request[transmissionv1.SubmitTransmissionRouteForReviewRequest]) (*connect.Response[transmissionv1.SubmitTransmissionRouteForReviewResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid route id: %w", err))
	}
	route, err := h.svc.SubmitTransmissionRouteForReview(ctx, id, req.Msg.GetActor(), req.Msg.GetNote())
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.SubmitTransmissionRouteForReviewResponse{Route: mappers.RouteToProto(route)}), nil
}

func (h *ConnectTransmissionRoutingService) ApproveTransmissionRoute(ctx context.Context, req *connect.Request[transmissionv1.ApproveTransmissionRouteRequest]) (*connect.Response[transmissionv1.ApproveTransmissionRouteResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid route id: %w", err))
	}
	route, err := h.svc.ApproveTransmissionRoute(ctx, id, req.Msg.GetActor(), req.Msg.GetNote())
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.ApproveTransmissionRouteResponse{Route: mappers.RouteToProto(route)}), nil
}

func (h *ConnectTransmissionRoutingService) ExportTransmissionRoutePack(ctx context.Context, req *connect.Request[transmissionv1.ExportTransmissionRoutePackRequest]) (*connect.Response[transmissionv1.ExportTransmissionRoutePackResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid route id: %w", err))
	}
	pack, err := h.svc.ExportTransmissionRoutePack(ctx, id, req.Msg.GetGeneratedBy())
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.ExportTransmissionRoutePackResponse{Pack: mappers.ExportPackToProto(pack)}), nil
}

func (h *ConnectTransmissionRoutingService) DeleteTransmissionRoute(ctx context.Context, req *connect.Request[transmissionv1.DeleteTransmissionRouteRequest]) (*connect.Response[transmissionv1.DeleteTransmissionRouteResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid route id: %w", err))
	}
	if err := h.svc.DeleteTransmissionRoute(ctx, id); err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.DeleteTransmissionRouteResponse{}), nil
}

func toConnectError(err error) error {
	if errors.Is(err, repository.ErrNotFound) {
		return connect.NewError(connect.CodeNotFound, err)
	}
	if errors.Is(err, service.ErrInvalidInput) {
		return connect.NewError(connect.CodeInvalidArgument, err)
	}
	if errors.Is(err, service.ErrInvalidWorkflowTransition) || errors.Is(err, service.ErrTraceabilityIncomplete) {
		return connect.NewError(connect.CodeFailedPrecondition, err)
	}
	return connect.NewError(connect.CodeInternal, err)
}

