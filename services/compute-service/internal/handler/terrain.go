package handler

import (
	"context"
	"errors"

	"solar3d/compute-service/internal/mappers"
	"solar3d/compute-service/internal/service"

	"connectrpc.com/connect"
	terrainv1 "github.com/solar3d/solar3d/gen/terrain/v1"
	terrainv1connect "github.com/solar3d/solar3d/gen/terrain/v1/terrainv1connect"
)

type TerrainServiceHandler struct {
	svc       *service.TerrainService
	lifecycle terrainLifecycleClient
}

type terrainLifecycleClient interface {
	UploadTerrain(context.Context, *connect.Request[terrainv1.UploadTerrainRequest]) (*connect.Response[terrainv1.UploadTerrainResponse], error)
	GetTerrainLayer(context.Context, *connect.Request[terrainv1.GetTerrainLayerRequest]) (*connect.Response[terrainv1.GetTerrainLayerResponse], error)
	ListTerrainLayers(context.Context, *connect.Request[terrainv1.ListTerrainLayersRequest]) (*connect.Response[terrainv1.ListTerrainLayersResponse], error)
	AnalyzeEarthwork(context.Context, *connect.Request[terrainv1.AnalyzeEarthworkRequest]) (*connect.Response[terrainv1.AnalyzeEarthworkResponse], error)
	DiffTerrainLayers(context.Context, *connect.Request[terrainv1.DiffTerrainLayersRequest]) (*connect.Response[terrainv1.DiffTerrainLayersResponse], error)
	GenerateGradingPlan(context.Context, *connect.Request[terrainv1.GenerateGradingPlanRequest]) (*connect.Response[terrainv1.GenerateGradingPlanResponse], error)
	DeleteTerrainLayer(context.Context, *connect.Request[terrainv1.DeleteTerrainLayerRequest]) (*connect.Response[terrainv1.DeleteTerrainLayerResponse], error)
}

var _ terrainv1connect.TerrainServiceHandler = (*TerrainServiceHandler)(nil)

func NewTerrainServiceHandler(svc *service.TerrainService, lifecycle terrainLifecycleClient) *TerrainServiceHandler {
	return &TerrainServiceHandler{svc: svc, lifecycle: lifecycle}
}

func (h *TerrainServiceHandler) UploadTerrain(ctx context.Context, req *connect.Request[terrainv1.UploadTerrainRequest]) (*connect.Response[terrainv1.UploadTerrainResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("terrain lifecycle client is not configured"))
	}
	return h.lifecycle.UploadTerrain(ctx, req)
}

func (h *TerrainServiceHandler) GetTerrainLayer(ctx context.Context, req *connect.Request[terrainv1.GetTerrainLayerRequest]) (*connect.Response[terrainv1.GetTerrainLayerResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("terrain lifecycle client is not configured"))
	}
	return h.lifecycle.GetTerrainLayer(ctx, req)
}

func (h *TerrainServiceHandler) ListTerrainLayers(ctx context.Context, req *connect.Request[terrainv1.ListTerrainLayersRequest]) (*connect.Response[terrainv1.ListTerrainLayersResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("terrain lifecycle client is not configured"))
	}
	return h.lifecycle.ListTerrainLayers(ctx, req)
}

func (h *TerrainServiceHandler) GetElevation(
	ctx context.Context,
	req *connect.Request[terrainv1.GetElevationRequest],
) (*connect.Response[terrainv1.GetElevationResponse], error) {
	domainReq := mappers.ProtoToGetElevation(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid get elevation request"))
	}
	resp, err := h.svc.GetElevation(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.GetElevationToProto(resp)), nil
}

func (h *TerrainServiceHandler) GetElevationGrid(
	ctx context.Context,
	req *connect.Request[terrainv1.GetElevationGridRequest],
) (*connect.Response[terrainv1.GetElevationGridResponse], error) {
	domainReq := mappers.ProtoToGetElevationGrid(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid get elevation grid request"))
	}
	resp, err := h.svc.GetElevationGrid(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.GetElevationGridToProto(resp)), nil
}

func (h *TerrainServiceHandler) ComputeSlope(
	ctx context.Context,
	req *connect.Request[terrainv1.ComputeSlopeRequest],
) (*connect.Response[terrainv1.ComputeSlopeResponse], error) {
	domainReq := mappers.ProtoToComputeSlope(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid compute slope request"))
	}
	resp, err := h.svc.ComputeSlope(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.ComputeSlopeToProto(resp)), nil
}

func (h *TerrainServiceHandler) ComputeAspect(
	ctx context.Context,
	req *connect.Request[terrainv1.ComputeAspectRequest],
) (*connect.Response[terrainv1.ComputeAspectResponse], error) {
	domainReq := mappers.ProtoToComputeAspect(req.Msg)
	if domainReq == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid compute aspect request"))
	}
	resp, err := h.svc.ComputeAspect(ctx, domainReq)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(mappers.ComputeAspectToProto(resp)), nil
}

func (h *TerrainServiceHandler) AnalyzeEarthwork(
	ctx context.Context,
	req *connect.Request[terrainv1.AnalyzeEarthworkRequest],
) (*connect.Response[terrainv1.AnalyzeEarthworkResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("terrain lifecycle client is not configured"))
	}
	return h.lifecycle.AnalyzeEarthwork(ctx, req)
}

func (h *TerrainServiceHandler) DiffTerrainLayers(
	ctx context.Context,
	req *connect.Request[terrainv1.DiffTerrainLayersRequest],
) (*connect.Response[terrainv1.DiffTerrainLayersResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("terrain lifecycle client is not configured"))
	}
	return h.lifecycle.DiffTerrainLayers(ctx, req)
}

func (h *TerrainServiceHandler) GenerateGradingPlan(
	ctx context.Context,
	req *connect.Request[terrainv1.GenerateGradingPlanRequest],
) (*connect.Response[terrainv1.GenerateGradingPlanResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("terrain lifecycle client is not configured"))
	}
	return h.lifecycle.GenerateGradingPlan(ctx, req)
}

func (h *TerrainServiceHandler) DeleteTerrainLayer(ctx context.Context, req *connect.Request[terrainv1.DeleteTerrainLayerRequest]) (*connect.Response[terrainv1.DeleteTerrainLayerResponse], error) {
	if h.lifecycle == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("terrain lifecycle client is not configured"))
	}
	return h.lifecycle.DeleteTerrainLayer(ctx, req)
}
