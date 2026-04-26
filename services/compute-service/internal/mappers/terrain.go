package mappers

import (
	"p9e.in/samavaya/solar3d/compute-service/internal/models"

	terrainv1 "p9e.in/samavaya/solar3d/gen/terrain/v1"
)

func ProtoToGetElevation(req *terrainv1.GetElevationRequest) *models.GetElevationRequest {
	if req == nil {
		return nil
	}
	return &models.GetElevationRequest{
		ProjectID: req.ProjectId,
		Longitude: req.Longitude,
		Latitude:  req.Latitude,
	}
}

func GetElevationToProto(resp *models.GetElevationResponse) *terrainv1.GetElevationResponse {
	if resp == nil {
		return &terrainv1.GetElevationResponse{}
	}
	return &terrainv1.GetElevationResponse{Elevation: resp.Elevation}
}

func ProtoToGetElevationGrid(req *terrainv1.GetElevationGridRequest) *models.GetElevationGridRequest {
	if req == nil || req.Bounds == nil {
		return nil
	}
	return &models.GetElevationGridRequest{
		ProjectID: req.ProjectId,
		Bounds: models.BoundingBoxModel{
			MinX: req.Bounds.MinX,
			MinY: req.Bounds.MinY,
			MaxX: req.Bounds.MaxX,
			MaxY: req.Bounds.MaxY,
		},
		ResolutionM: req.ResolutionM,
	}
}

func GetElevationGridToProto(resp *models.GetElevationGridResponse) *terrainv1.GetElevationGridResponse {
	if resp == nil {
		return &terrainv1.GetElevationGridResponse{}
	}
	return &terrainv1.GetElevationGridResponse{
		Width:        resp.Width,
		Height:       resp.Height,
		Elevations:   append([]float64(nil), resp.Elevations...),
		MinElevation: resp.MinElevation,
		MaxElevation: resp.MaxElevation,
	}
}

func ProtoToComputeSlope(req *terrainv1.ComputeSlopeRequest) *models.ComputeSlopeRequest {
	if req == nil {
		return nil
	}
	return &models.ComputeSlopeRequest{TerrainLayerID: req.TerrainLayerId}
}

func ComputeSlopeToProto(resp *models.ComputeSlopeResponse) *terrainv1.ComputeSlopeResponse {
	if resp == nil {
		return &terrainv1.ComputeSlopeResponse{}
	}
	return &terrainv1.ComputeSlopeResponse{SlopeLayer: terrainLayerToProto(resp.SlopeLayer)}
}

func ProtoToComputeAspect(req *terrainv1.ComputeAspectRequest) *models.ComputeAspectRequest {
	if req == nil {
		return nil
	}
	return &models.ComputeAspectRequest{TerrainLayerID: req.TerrainLayerId}
}

func ComputeAspectToProto(resp *models.ComputeAspectResponse) *terrainv1.ComputeAspectResponse {
	if resp == nil {
		return &terrainv1.ComputeAspectResponse{}
	}
	return &terrainv1.ComputeAspectResponse{AspectLayer: terrainLayerToProto(resp.AspectLayer)}
}

func terrainLayerToProto(in models.TerrainLayerModel) *terrainv1.TerrainLayer {
	return &terrainv1.TerrainLayer{
		Id:         in.ID,
		Name:       in.Name,
		SourceFile: in.SourceFile,
		Bounds: &terrainv1.BoundingBox{
			MinX: in.Bounds.MinX,
			MinY: in.Bounds.MinY,
			MaxX: in.Bounds.MaxX,
			MaxY: in.Bounds.MaxY,
		},
		ResolutionM:  in.ResolutionM,
		Crs:          in.CRS,
		MinElevation: in.MinElevation,
		MaxElevation: in.MaxElevation,
		LayerType:    layerTypeToProto(in.LayerType),
	}
}

func layerTypeToProto(kind string) terrainv1.TerrainLayerType {
	switch kind {
	case "DEM":
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_DEM
	case "SLOPE":
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_SLOPE
	case "ASPECT":
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_ASPECT
	case "HILLSHADE":
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_HILLSHADE
	default:
		return terrainv1.TerrainLayerType_TERRAIN_LAYER_TYPE_UNSPECIFIED
	}
}

