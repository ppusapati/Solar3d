package handler

import (
	"context"
	"errors"

	"p9e.in/samavaya/solar3d/compute-service/internal/mappers"
	"p9e.in/samavaya/solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	optimizationv1 "p9e.in/samavaya/solar3d/gen/optimization/v1"
	optimizationv1connect "p9e.in/samavaya/solar3d/gen/optimization/v1/optimizationv1connect"
)

// OptimizationServiceHandler implements connectRPC optimization service.
type OptimizationServiceHandler struct {
	svc *service.OptimizationService
}

var _ optimizationv1connect.OptimizationServiceHandler = (*OptimizationServiceHandler)(nil)

func NewOptimizationServiceHandler(svc *service.OptimizationService) *OptimizationServiceHandler {
	return &OptimizationServiceHandler{svc: svc}
}

func (h *OptimizationServiceHandler) ParetoFrontier(
	ctx context.Context,
	req *connect.Request[optimizationv1.AddToFrontierRequest],
) (*connect.Response[optimizationv1.ParetoFrontierResponse], error) {
	domainReq := mappers.ProtoToParetoFrontier(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid pareto frontier request"))
	}
	resp, err := h.svc.ParetoFrontier(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.ParetoFrontierToProto(resp)), nil
}

func (h *OptimizationServiceHandler) MonteCarloSampling(
	ctx context.Context,
	req *connect.Request[optimizationv1.MonteCarloRequest],
) (*connect.Response[optimizationv1.MonteCarloResponse], error) {
	domainReq := mappers.ProtoToMonteCarlo(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid monte carlo request"))
	}
	resp, err := h.svc.MonteCarloSampling(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.MonteCarloToProto(resp)), nil
}

func (h *OptimizationServiceHandler) GeneticAlgorithm(
	ctx context.Context,
	req *connect.Request[optimizationv1.GARequest],
) (*connect.Response[optimizationv1.GAResponse], error) {
	domainReq := mappers.ProtoToGA(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid ga request"))
	}
	resp, err := h.svc.GeneticAlgorithm(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.GAToProto(resp)), nil
}

func (h *OptimizationServiceHandler) SimulatedAnnealing(
	ctx context.Context,
	req *connect.Request[optimizationv1.SARequest],
) (*connect.Response[optimizationv1.SAResponse], error) {
	domainReq := mappers.ProtoToSA(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid sa request"))
	}
	resp, err := h.svc.SimulatedAnnealing(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.SAToProto(resp)), nil
}

func (h *OptimizationServiceHandler) ParticleSwarmOptimization(
	ctx context.Context,
	req *connect.Request[optimizationv1.PSORequest],
) (*connect.Response[optimizationv1.PSOResponse], error) {
	domainReq := mappers.ProtoToPSO(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid pso request"))
	}
	resp, err := h.svc.ParticleSwarmOptimization(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.PSOToProto(resp)), nil
}

