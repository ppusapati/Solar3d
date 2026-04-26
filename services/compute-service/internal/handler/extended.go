package handler

import (
	"context"
	"errors"

	"p9e.in/samavaya/solar3d/compute-service/internal/mappers"
	"p9e.in/samavaya/solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	extendedv1 "p9e.in/samavaya/solar3d/gen/extended/v1"
	extendedv1connect "p9e.in/samavaya/solar3d/gen/extended/v1/extendedv1connect"
)

type ExtendedServiceHandler struct {
	svc *service.ExtendedService
}

var _ extendedv1connect.ExtendedServiceHandler = (*ExtendedServiceHandler)(nil)

func NewExtendedServiceHandler(svc *service.ExtendedService) *ExtendedServiceHandler {
	return &ExtendedServiceHandler{svc: svc}
}

func (h *ExtendedServiceHandler) SolarTransposition(
	ctx context.Context,
	req *connect.Request[extendedv1.SolarTranspositionRequest],
) (*connect.Response[extendedv1.SolarTranspositionResponse], error) {
	domainReq := mappers.ProtoToSolarTransposition(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid solar transposition request"))
	}
	resp, err := h.svc.SolarTransposition(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.SolarTranspositionToProto(resp)), nil
}

func (h *ExtendedServiceHandler) FinancialMetrics(
	ctx context.Context,
	req *connect.Request[extendedv1.FinancialMetricsRequest],
) (*connect.Response[extendedv1.FinancialMetricsResponse], error) {
	domainReq := mappers.ProtoToFinancialMetrics(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid financial metrics request"))
	}
	resp, err := h.svc.FinancialMetrics(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.FinancialMetricsToProto(resp)), nil
}

func (h *ExtendedServiceHandler) CompareFinancialScenarios(
	ctx context.Context,
	req *connect.Request[extendedv1.CompareFinancialScenariosRequest],
) (*connect.Response[extendedv1.CompareFinancialScenariosResponse], error) {
	domainReq := mappers.ProtoToFinancialScenarioComparison(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid financial scenario comparison request"))
	}
	resp, err := h.svc.CompareFinancialScenarios(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.FinancialScenarioComparisonToProto(resp)), nil
}

func (h *ExtendedServiceHandler) ClimateImpact(
	ctx context.Context,
	req *connect.Request[extendedv1.ClimateImpactRequest],
) (*connect.Response[extendedv1.ClimateImpactResponse], error) {
	domainReq := mappers.ProtoToClimateImpact(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid climate impact request"))
	}
	resp, err := h.svc.ClimateImpact(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.ClimateImpactToProto(resp)), nil
}

func (h *ExtendedServiceHandler) SaveFinancialScenarioSet(
	ctx context.Context,
	req *connect.Request[extendedv1.SaveFinancialScenarioSetRequest],
) (*connect.Response[extendedv1.SaveFinancialScenarioSetResponse], error) {
	domainReq := mappers.ProtoToSaveFinancialScenarioSet(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid save financial scenario set request"))
	}

	resp, err := h.svc.SaveFinancialScenarioSet(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.FinancialScenarioSetToSaveProto(resp)), nil
}

func (h *ExtendedServiceHandler) GetFinancialScenarioSet(
	ctx context.Context,
	req *connect.Request[extendedv1.GetFinancialScenarioSetRequest],
) (*connect.Response[extendedv1.GetFinancialScenarioSetResponse], error) {
	domainReq := mappers.ProtoToGetFinancialScenarioSet(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid get financial scenario set request"))
	}

	resp, err := h.svc.GetFinancialScenarioSet(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(mappers.FinancialScenarioSetToGetProto(resp)), nil
}

func (h *ExtendedServiceHandler) ListFinancialScenarioSets(
	ctx context.Context,
	req *connect.Request[extendedv1.ListFinancialScenarioSetsRequest],
) (*connect.Response[extendedv1.ListFinancialScenarioSetsResponse], error) {
	domainReq := mappers.ProtoToListFinancialScenarioSets(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid list financial scenario sets request"))
	}

	summaries, err := h.svc.ListFinancialScenarioSets(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.ListFinancialScenarioSetsToProto(summaries)), nil
}

func (h *ExtendedServiceHandler) GetFinancialScenarioSetVersions(
	ctx context.Context,
	req *connect.Request[extendedv1.GetFinancialScenarioSetVersionsRequest],
) (*connect.Response[extendedv1.GetFinancialScenarioSetVersionsResponse], error) {
	domainReq := mappers.ProtoToGetFinancialScenarioSetVersions(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid get financial scenario set versions request"))
	}

	versions, err := h.svc.GetFinancialScenarioSetVersions(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(mappers.GetFinancialScenarioSetVersionsToProto(versions)), nil
}

func (h *ExtendedServiceHandler) CalculateInterRowShading(
	ctx context.Context,
	req *connect.Request[extendedv1.CalculateInterRowShadingRequest],
) (*connect.Response[extendedv1.CalculateInterRowShadingResponse], error) {
	domainReq := mappers.ProtoToInterRowShading(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid inter-row shading request"))
	}

	resp, err := h.svc.CalculateInterRowShading(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.InterRowShadingToProto(resp)), nil
}

func (h *ExtendedServiceHandler) CalculateYieldUncertainty(
	ctx context.Context,
	req *connect.Request[extendedv1.CalculateYieldUncertaintyRequest],
) (*connect.Response[extendedv1.CalculateYieldUncertaintyResponse], error) {
	domainReq := mappers.ProtoToYieldUncertainty(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid yield uncertainty request"))
	}

	resp, err := h.svc.CalculateYieldUncertainty(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(mappers.YieldUncertaintyToProto(resp)), nil
}
