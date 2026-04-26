package handler

import (
	"context"
	"errors"

	"p9e.in/samavaya/solar3d/compute-service/internal/mappers"
	"p9e.in/samavaya/solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	simulationv1 "p9e.in/samavaya/solar3d/gen/simulation/v1"
	simulationv1connect "p9e.in/samavaya/solar3d/gen/simulation/v1/simulationv1connect"
)

type SimulationServiceHandler struct {
	svc       *service.SimulationService
	lifecycle simulationLifecycleClient
}

type simulationLifecycleClient interface {
	CreateSimulation(context.Context, *connect.Request[simulationv1.CreateSimulationRequest]) (*connect.Response[simulationv1.CreateSimulationResponse], error)
	GetSimulation(context.Context, *connect.Request[simulationv1.GetSimulationRequest]) (*connect.Response[simulationv1.GetSimulationResponse], error)
	ListSimulations(context.Context, *connect.Request[simulationv1.ListSimulationsRequest]) (*connect.Response[simulationv1.ListSimulationsResponse], error)
	RunSimulation(context.Context, *connect.Request[simulationv1.RunSimulationRequest]) (*connect.Response[simulationv1.RunSimulationResponse], error)
	DeleteSimulation(context.Context, *connect.Request[simulationv1.DeleteSimulationRequest]) (*connect.Response[simulationv1.DeleteSimulationResponse], error)
}

var _ simulationv1connect.SimulationServiceHandler = (*SimulationServiceHandler)(nil)

func NewSimulationServiceHandler(svc *service.SimulationService, lifecycle simulationLifecycleClient) *SimulationServiceHandler {
	return &SimulationServiceHandler{svc: svc, lifecycle: lifecycle}
}

func (h *SimulationServiceHandler) CreateSimulation(ctx context.Context, req *connect.Request[simulationv1.CreateSimulationRequest]) (*connect.Response[simulationv1.CreateSimulationResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("simulation lifecycle client is not configured"))
	}
	return h.lifecycle.CreateSimulation(ctx, req)
}

func (h *SimulationServiceHandler) GetSimulation(ctx context.Context, req *connect.Request[simulationv1.GetSimulationRequest]) (*connect.Response[simulationv1.GetSimulationResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("simulation lifecycle client is not configured"))
	}
	return h.lifecycle.GetSimulation(ctx, req)
}

func (h *SimulationServiceHandler) ListSimulations(ctx context.Context, req *connect.Request[simulationv1.ListSimulationsRequest]) (*connect.Response[simulationv1.ListSimulationsResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("simulation lifecycle client is not configured"))
	}
	return h.lifecycle.ListSimulations(ctx, req)
}

func (h *SimulationServiceHandler) RunSimulation(ctx context.Context, req *connect.Request[simulationv1.RunSimulationRequest]) (*connect.Response[simulationv1.RunSimulationResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("simulation lifecycle client is not configured"))
	}
	return h.lifecycle.RunSimulation(ctx, req)
}

func (h *SimulationServiceHandler) GetSunPosition(
	ctx context.Context,
	req *connect.Request[simulationv1.GetSunPositionRequest],
) (*connect.Response[simulationv1.GetSunPositionResponse], error) {
	domainReq := mappers.ProtoToGetSunPosition(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid get sun position request"))
	}
	resp, err := h.svc.GetSunPosition(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.SunPositionToProto(resp)), nil
}

func (h *SimulationServiceHandler) GetShadowMap(
	ctx context.Context,
	req *connect.Request[simulationv1.GetShadowMapRequest],
) (*connect.Response[simulationv1.GetShadowMapResponse], error) {
	domainReq := mappers.ProtoToGetShadowMap(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid get shadow map request"))
	}
	resp, err := h.svc.GetShadowMap(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.ShadowMapToProto(resp)), nil
}

func (h *SimulationServiceHandler) DeleteSimulation(ctx context.Context, req *connect.Request[simulationv1.DeleteSimulationRequest]) (*connect.Response[simulationv1.DeleteSimulationResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("simulation lifecycle client is not configured"))
	}
	return h.lifecycle.DeleteSimulation(ctx, req)
}

