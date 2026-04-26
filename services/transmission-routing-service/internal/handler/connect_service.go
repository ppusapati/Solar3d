package handler

import (
	"context"
	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	transmissionv1 "p9e.in/samavaya/solar3d/gen/transmission/v1"
	transmissionv1connect "p9e.in/samavaya/solar3d/gen/transmission/v1/transmissionv1connect"
	paginationv1 "p9e.in/samavaya/packages/api/v1/pagination"
	pkgErrors "p9e.in/samavaya/packages/errors"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/mappers"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/repository"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/service"
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
		return nil, pkgErrors.InvalidArgumentf("invalid route request: %v", err).ToConnectError()
	}
	route, err := h.svc.CalculateTransmissionRoute(ctx, *domainReq)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.CalculateTransmissionRouteResponse{Route: mappers.RouteToProto(route)}), nil
}

func (h *ConnectTransmissionRoutingService) StreamTransmissionRoute(ctx context.Context, req *connect.Request[transmissionv1.StreamTransmissionRouteRequest], stream *connect.ServerStream[transmissionv1.StreamTransmissionRouteResponse]) error {
	if req.Msg.GetRequest() == nil {
		return pkgErrors.InvalidArgumentf("request is required").ToConnectError()
	}
	domainReq, err := mappers.ProtoToCalculateTransmissionRouteRequest(req.Msg.GetRequest())
	if err != nil {
		return pkgErrors.InvalidArgumentf("invalid route request: %v", err).ToConnectError()
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
		return nil, pkgErrors.InvalidArgumentf("invalid route id: %v", err).ToConnectError()
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
		return nil, pkgErrors.InvalidArgumentf("invalid project id: %v", err).ToConnectError()
	}
	routes, err := h.svc.ListTransmissionRoutes(ctx, projectID)
	if err != nil {
		return nil, toConnectError(err)
	}

	pagination := req.Msg.GetPagination()
	offset := pagination.GetPageOffset()
	size := pagination.GetPageSize()
	if size <= 0 {
		size = 20
	}
	if size > 100 {
		size = 100
	}

	totalCount := int32(len(routes))
	start := int(offset)
	if start > len(routes) {
		start = len(routes)
	}
	end := start + int(size)
	if end > len(routes) {
		end = len(routes)
	}

	paged := routes[start:end]
	protoRoutes := make([]*transmissionv1.TransmissionRoute, 0, len(paged))
	for index := range paged {
		protoRoutes = append(protoRoutes, mappers.RouteToProto(&paged[index]))
	}
	return connect.NewResponse(&transmissionv1.ListTransmissionRoutesResponse{
		Routes: protoRoutes,
		Pagination: &paginationv1.PaginationResponse{
			TotalCount: totalCount,
			PageOffset: int32(start),
			PageSize:   size,
			HasNext:    end < len(routes),
		},
	}), nil
}

func (h *ConnectTransmissionRoutingService) SubmitTransmissionRouteForReview(ctx context.Context, req *connect.Request[transmissionv1.SubmitTransmissionRouteForReviewRequest]) (*connect.Response[transmissionv1.SubmitTransmissionRouteForReviewResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid route id: %v", err).ToConnectError()
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
		return nil, pkgErrors.InvalidArgumentf("invalid route id: %v", err).ToConnectError()
	}
	route, err := h.svc.ApproveTransmissionRoute(ctx, id, req.Msg.GetActor(), req.Msg.GetNote())
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.ApproveTransmissionRouteResponse{Route: mappers.RouteToProto(route)}), nil
}

// RejectTransmissionRoute transitions a route from engineering_review to
// rejected, recording the rejection reasons in the governance event stream.
// At least one rejection reason is required; the service enforces this.
func (h *ConnectTransmissionRoutingService) RejectTransmissionRoute(ctx context.Context, req *connect.Request[transmissionv1.RejectTransmissionRouteRequest]) (*connect.Response[transmissionv1.RejectTransmissionRouteResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid route id: %v", err).ToConnectError()
	}
	route, err := h.svc.RejectTransmissionRoute(ctx, id, req.Msg.GetActor(), req.Msg.GetRejectionReasons(), "")
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.RejectTransmissionRouteResponse{Route: mappers.RouteToProto(route)}), nil
}

func (h *ConnectTransmissionRoutingService) ExportTransmissionRoutePack(ctx context.Context, req *connect.Request[transmissionv1.ExportTransmissionRoutePackRequest]) (*connect.Response[transmissionv1.ExportTransmissionRoutePackResponse], error) {
	id, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, pkgErrors.InvalidArgumentf("invalid route id: %v", err).ToConnectError()
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
		return nil, pkgErrors.InvalidArgumentf("invalid route id: %v", err).ToConnectError()
	}
	if err := h.svc.DeleteTransmissionRoute(ctx, id); err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&transmissionv1.DeleteTransmissionRouteResponse{}), nil
}

func toConnectError(err error) error {
	if errors.Is(err, repository.ErrNotFound) {
		return pkgErrors.NotFound("transmission_route", "").ToConnectError()
	}
	if errors.Is(err, service.ErrInvalidInput) {
		return pkgErrors.InvalidArgumentf("%v", err).ToConnectError()
	}
	if errors.Is(err, service.ErrInvalidWorkflowTransition) || errors.Is(err, service.ErrTraceabilityIncomplete) {
		return pkgErrors.NewValidation("failed_precondition", err.Error()).ToConnectError()
	}
	if pkgErr, ok := err.(*pkgErrors.Error); ok {
		return pkgErr.ToConnectError()
	}
	return pkgErrors.Internal("transmission routing operation failed", err.Error()).ToConnectError()
}
