package handler

import (
	"context"
	"errors"
	"math"
	"strings"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	terrainv1 "p9e.in/samavaya/solar3d/gen/terrain/v1"
	terrainv1connect "p9e.in/samavaya/solar3d/gen/terrain/v1/terrainv1connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"p9e.in/samavaya/solar3d/terrain-service/internal/domain"
	"p9e.in/samavaya/solar3d/terrain-service/internal/service"
)

type ConnectTerrainService struct {
	svc *service.Service
}

var _ terrainv1connect.TerrainServiceHandler = (*ConnectTerrainService)(nil)

func NewConnectTerrainService(svc *service.Service) *ConnectTerrainService {
	return &ConnectTerrainService{svc: svc}
}

func (h *ConnectTerrainService) UploadTerrain(
	ctx context.Context,
	req *connect.Request[terrainv1.UploadTerrainRequest],
) (*connect.Response[terrainv1.UploadTerrainResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	layer, err := h.svc.UploadTerrain(ctx, service.UploadTerrainRequest{
		ProjectID:    projectID,
		Name:         strings.TrimSpace(req.Msg.GetName()),
		LayerType:    domain.LayerTypeDEM,
		SourceFile:   strings.TrimSpace(req.Msg.GetFilePath()),
		Bounds:       domain.BoundingBox{MinX: 0, MinY: 0, MaxX: 1, MaxY: 1},
		ResolutionM:  1,
		CRS:          defaultString(req.Msg.GetCrs(), "EPSG:4326"),
		MinElevation: 0,
		MaxElevation: 0,
	})
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.UploadTerrainResponse{
		Layer: terrainLayerToProto(layer),
	}), nil
}

func (h *ConnectTerrainService) GetTerrainLayer(
	ctx context.Context,
	req *connect.Request[terrainv1.GetTerrainLayerRequest],
) (*connect.Response[terrainv1.GetTerrainLayerResponse], error) {
	layerID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layer id"))
	}

	layer, err := h.svc.GetLayer(ctx, layerID)
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.GetTerrainLayerResponse{
		Layer: terrainLayerToProto(layer),
	}), nil
}

func (h *ConnectTerrainService) ListTerrainLayers(
	ctx context.Context,
	req *connect.Request[terrainv1.ListTerrainLayersRequest],
) (*connect.Response[terrainv1.ListTerrainLayersResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	layers, err := h.svc.ListLayers(ctx, projectID)
	if err != nil {
		return nil, terrainConnectError(err)
	}

	filter := req.Msg.GetTypeFilter()
	result := make([]*terrainv1.TerrainLayer, 0, len(layers))
	for i := range layers {
		layer := layers[i]
		if filter != terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_UNSPECIFIED &&
			terrainLayerTypeToProto(layer.LayerType) != filter {
			continue
		}
		result = append(result, terrainLayerToProto(&layer))
	}

	return connect.NewResponse(&terrainv1.ListTerrainLayersResponse{
		Layers: result,
	}), nil
}

func (h *ConnectTerrainService) GetElevation(
	ctx context.Context,
	req *connect.Request[terrainv1.GetElevationRequest],
) (*connect.Response[terrainv1.GetElevationResponse], error) {
	layer, err := h.findProjectLayer(ctx, req.Msg.GetProjectId(), terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_DEM)
	if err != nil {
		return nil, err
	}

	point, err := h.svc.GetElevation(ctx, layer.ID, req.Msg.GetLongitude(), req.Msg.GetLatitude())
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.GetElevationResponse{
		Elevation: point.Elevation,
	}), nil
}

func (h *ConnectTerrainService) GetElevationGrid(
	ctx context.Context,
	req *connect.Request[terrainv1.GetElevationGridRequest],
) (*connect.Response[terrainv1.GetElevationGridResponse], error) {
	layer, err := h.findProjectLayer(ctx, req.Msg.GetProjectId(), terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_DEM)
	if err != nil {
		return nil, err
	}
	if req.Msg.GetBounds() == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("bounds is required"))
	}
	if req.Msg.GetResolutionM() <= 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("resolution_m must be positive"))
	}

	bounds := protoBoundsToDomain(req.Msg.GetBounds())
	width := int(math.Ceil((bounds.MaxX - bounds.MinX) / req.Msg.GetResolutionM()))
	height := int(math.Ceil((bounds.MaxY - bounds.MinY) / req.Msg.GetResolutionM()))
	if width < 1 {
		width = 1
	}
	if height < 1 {
		height = 1
	}

	grid, err := h.svc.GetElevationGrid(ctx, layer.ID, bounds, width, height)
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.GetElevationGridResponse{
		Width:        int32(grid.Width),
		Height:       int32(grid.Height),
		Elevations:   grid.Elevations,
		MinElevation: grid.MinElev,
		MaxElevation: grid.MaxElev,
	}), nil
}

func (h *ConnectTerrainService) AnalyzeEarthwork(
	ctx context.Context,
	req *connect.Request[terrainv1.AnalyzeEarthworkRequest],
) (*connect.Response[terrainv1.AnalyzeEarthworkResponse], error) {
	layerID, err := uuid.Parse(req.Msg.GetTerrainLayerId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid terrain_layer_id"))
	}

	var targetElevationM *float64
	if req.Msg.TargetElevationM != nil {
		v := req.Msg.GetTargetElevationM()
		targetElevationM = &v
	}

	summary, err := h.svc.AnalyzeEarthwork(ctx, layerID, service.AnalyzeEarthworkRequest{
		TargetElevationM: targetElevationM,
		BoundaryGeoJSON:  req.Msg.GetBoundaryGeojson(),
		MinDeltaM:        req.Msg.GetMinDeltaM(),
		HaulFactor:       req.Msg.GetHaulFactor(),
		GridWidth:        int(req.Msg.GetGridWidth()),
		GridHeight:       int(req.Msg.GetGridHeight()),
	})
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.AnalyzeEarthworkResponse{
		DemSourceLayerId:      summary.DEMSourceLayerID.String(),
		GridWidth:             int32(summary.GridWidth),
		GridHeight:            int32(summary.GridHeight),
		CellAreaSqm:           summary.CellAreaSqm,
		MeanElevationM:        summary.MeanElevationM,
		TargetElevationM:      summary.TargetElevationM,
		CutVolumeM3:           summary.CutVolumeM3,
		FillVolumeM3:          summary.FillVolumeM3,
		NetVolumeM3:           summary.NetVolumeM3,
		ImbalanceVolumeM3:     summary.ImbalanceVolumeM3,
		BalancedVolumeRatio:   summary.BalancedVolumeRatio,
		AffectedAreaSqm:       summary.AffectedAreaSqm,
		AverageAbsoluteDeltaM: summary.AverageAbsoluteDeltaM,
		MaximumAbsoluteDeltaM: summary.MaximumAbsoluteDeltaM,
		IncludedCellCount:     int32(summary.IncludedCellCount),
		ClippedAreaSqm:        summary.ClippedAreaSqm,
		HaulDistanceM:         summary.HaulDistanceM,
		HaulEffortM3M:         summary.HaulEffortM3M,
		RecommendedTargetMinM: summary.RecommendedTargetMinM,
		RecommendedTargetMaxM: summary.RecommendedTargetMaxM,
	}), nil
}

func (h *ConnectTerrainService) ComputeSlope(
	ctx context.Context,
	req *connect.Request[terrainv1.ComputeSlopeRequest],
) (*connect.Response[terrainv1.ComputeSlopeResponse], error) {
	layerID, err := uuid.Parse(req.Msg.GetTerrainLayerId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid terrain_layer_id"))
	}

	layer, err := h.svc.ComputeSlope(ctx, layerID)
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.ComputeSlopeResponse{
		SlopeLayer: terrainLayerToProto(layer),
	}), nil
}

func (h *ConnectTerrainService) ComputeAspect(
	ctx context.Context,
	req *connect.Request[terrainv1.ComputeAspectRequest],
) (*connect.Response[terrainv1.ComputeAspectResponse], error) {
	layerID, err := uuid.Parse(req.Msg.GetTerrainLayerId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid terrain_layer_id"))
	}

	layer, err := h.svc.ComputeAspect(ctx, layerID)
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.ComputeAspectResponse{
		AspectLayer: terrainLayerToProto(layer),
	}), nil
}

func (h *ConnectTerrainService) DeleteTerrainLayer(
	ctx context.Context,
	req *connect.Request[terrainv1.DeleteTerrainLayerRequest],
) (*connect.Response[terrainv1.DeleteTerrainLayerResponse], error) {
	layerID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid layer id"))
	}

	if err := h.svc.DeleteLayer(ctx, layerID); err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.DeleteTerrainLayerResponse{}), nil
}

func (h *ConnectTerrainService) DiffTerrainLayers(
	ctx context.Context,
	req *connect.Request[terrainv1.DiffTerrainLayersRequest],
) (*connect.Response[terrainv1.DiffTerrainLayersResponse], error) {
	baseID, err := uuid.Parse(req.Msg.GetBaseLayerId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid base_layer_id"))
	}
	compareID, err := uuid.Parse(req.Msg.GetCompareLayerId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid compare_layer_id"))
	}

	diff, err := h.svc.DiffTerrainLayers(ctx, baseID, service.DiffTerrainLayersRequest{
		CompareLayerID: compareID,
		GridWidth:      int(req.Msg.GetGridWidth()),
		GridHeight:     int(req.Msg.GetGridHeight()),
	})
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.DiffTerrainLayersResponse{
		BaseLayerId:    diff.BaseLayerID.String(),
		CompareLayerId: diff.CompareLayerID.String(),
		OverlapBounds: &terrainv1.BoundingBox{
			MinX: diff.OverlapBounds.MinX,
			MinY: diff.OverlapBounds.MinY,
			MaxX: diff.OverlapBounds.MaxX,
			MaxY: diff.OverlapBounds.MaxY,
		},
		GridWidth:       int32(diff.GridWidth),
		GridHeight:      int32(diff.GridHeight),
		CellAreaSqm:     diff.CellAreaSqm,
		DeltaElevations: diff.DeltaElevations,
		MeanDeltaM:      diff.MeanDeltaM,
		RmsDeltaM:       diff.RMSDeltaM,
		MaxAbsDeltaM:    diff.MaxAbsDeltaM,
		VolumeAddedM3:   diff.VolumeAddedM3,
		VolumeRemovedM3: diff.VolumeRemovedM3,
		NetVolumeM3:     diff.NetVolumeM3,
		ValidCellCount:  int32(diff.ValidCellCount),
	}), nil
}

func (h *ConnectTerrainService) GenerateGradingPlan(
	ctx context.Context,
	req *connect.Request[terrainv1.GenerateGradingPlanRequest],
) (*connect.Response[terrainv1.GenerateGradingPlanResponse], error) {
	layerID, err := uuid.Parse(req.Msg.GetTerrainLayerId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid terrain_layer_id"))
	}

	var targetElevationM *float64
	if req.Msg.TargetElevationM != nil {
		v := req.Msg.GetTargetElevationM()
		targetElevationM = &v
	}

	plan, err := h.svc.GenerateGradingPlan(ctx, layerID, service.GradingPlanRequest{
		TargetElevationM: targetElevationM,
		BoundaryGeoJSON:  req.Msg.GetBoundaryGeojson(),
		MinDeltaM:        req.Msg.GetMinDeltaM(),
		HaulFactor:       req.Msg.GetHaulFactor(),
		GridWidth:        int(req.Msg.GetGridWidth()),
		GridHeight:       int(req.Msg.GetGridHeight()),
		CutRatePerM3:     req.Msg.GetCutRatePerM3(),
		FillRatePerM3:    req.Msg.GetFillRatePerM3(),
		HaulRatePerM3M:   req.Msg.GetHaulRatePerM3M(),
		ImportRatePerM3:  req.Msg.GetImportRatePerM3(),
		ExportRatePerM3:  req.Msg.GetExportRatePerM3(),
		CompactionFactor: req.Msg.GetCompactionFactor(),
		CurrencyCode:     req.Msg.GetCurrencyCode(),
	})
	if err != nil {
		return nil, terrainConnectError(err)
	}

	return connect.NewResponse(&terrainv1.GenerateGradingPlanResponse{
		DemLayerId:          plan.DEMLayerID.String(),
		TargetElevationM:    plan.TargetElevationM,
		MeanElevationM:      plan.MeanElevationM,
		AffectedAreaSqm:     plan.AffectedAreaSqm,
		BalancedVolumeRatio: plan.BalancedVolumeRatio,
		CompactionFactor:    plan.CompactionFactor,
		CutRatePerM3:        plan.CutRatePerM3,
		FillRatePerM3:       plan.FillRatePerM3,
		HaulRatePerM3M:      plan.HaulRatePerM3M,
		ImportRatePerM3:     plan.ImportRatePerM3,
		ExportRatePerM3:     plan.ExportRatePerM3,
		Cost: &terrainv1.GradingPlanCostBreakdown{
			CutVolumeM3:    plan.Cost.CutVolumeM3,
			FillVolumeM3:   plan.Cost.FillVolumeM3,
			FillDemandM3:   plan.Cost.FillDemandM3,
			ExportVolumeM3: plan.Cost.ExportVolumeM3,
			ImportVolumeM3: plan.Cost.ImportVolumeM3,
			HauledVolumeM3: plan.Cost.HauledVolumeM3,
			HaulDistanceM:  plan.Cost.HaulDistanceM,
			HaulEffortM3M:  plan.Cost.HaulEffortM3M,
			CutCost:        plan.Cost.CutCost,
			FillCost:       plan.Cost.FillCost,
			HaulCost:       plan.Cost.HaulCost,
			ImportCost:     plan.Cost.ImportCost,
			ExportCost:     plan.Cost.ExportCost,
			TotalCost:      plan.Cost.TotalCost,
			CurrencyCode:   plan.Cost.CurrencyCode,
		},
	}), nil
}

func (h *ConnectTerrainService) findProjectLayer(
	ctx context.Context,
	projectIDRaw string,
	preferred terrainv1.TerrainLayerType,
) (*domain.TerrainLayer, error) {
	projectID, err := uuid.Parse(projectIDRaw)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	layers, err := h.svc.ListLayers(ctx, projectID)
	if err != nil {
		return nil, terrainConnectError(err)
	}
	if len(layers) == 0 {
		return nil, connect.NewError(connect.CodeNotFound, errors.New("terrain layer not found"))
	}

	for i := range layers {
		if terrainLayerTypeToProto(layers[i].LayerType) == preferred {
			return &layers[i], nil
		}
	}
	return &layers[0], nil
}

func terrainLayerToProto(layer *domain.TerrainLayer) *terrainv1.TerrainLayer {
	if layer == nil {
		return nil
	}

	return &terrainv1.TerrainLayer{
		Id:           layer.ID.String(),
		ProjectId:    layer.ProjectID.String(),
		Name:         layer.Name,
		LayerType:    terrainLayerTypeToProto(layer.LayerType),
		SourceFile:   layer.SourceFile,
		Bounds:       domainBoundsToProto(layer.Bounds),
		ResolutionM:  layer.ResolutionM,
		Crs:          layer.CRS,
		MinElevation: layer.MinElevation,
		MaxElevation: layer.MaxElevation,
		CreatedAt:    timestamppb.New(layer.CreatedAt),
	}
}

func domainBoundsToProto(bounds domain.BoundingBox) *terrainv1.BoundingBox {
	return &terrainv1.BoundingBox{
		MinX: bounds.MinX,
		MinY: bounds.MinY,
		MaxX: bounds.MaxX,
		MaxY: bounds.MaxY,
	}
}

func protoBoundsToDomain(bounds *terrainv1.BoundingBox) domain.BoundingBox {
	return domain.BoundingBox{
		MinX: bounds.GetMinX(),
		MinY: bounds.GetMinY(),
		MaxX: bounds.GetMaxX(),
		MaxY: bounds.GetMaxY(),
	}
}

func terrainLayerTypeToProto(layerType domain.LayerType) terrainv1.TerrainLayerType {
	switch layerType {
	case domain.LayerTypeDEM:
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_DEM
	case domain.LayerTypeSlope:
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_SLOPE
	case domain.LayerTypeAspect:
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_ASPECT
	case domain.LayerTypeHillshade:
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_HILLSHADE
	default:
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_UNSPECIFIED
	}
}

func terrainConnectError(err error) error {
	switch {
	case errors.Is(err, pgx.ErrNoRows):
		return connect.NewError(connect.CodeNotFound, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

func defaultString(value, fallback string) string {
	if strings.TrimSpace(value) == "" {
		return fallback
	}
	return value
}
