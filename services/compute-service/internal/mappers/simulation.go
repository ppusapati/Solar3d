package mappers

import (
	"solar3d/compute-service/internal/models"

	simulationv1 "github.com/solar3d/solar3d/gen/simulation/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func ProtoToGetSunPosition(req *simulationv1.GetSunPositionRequest) *models.GetSunPositionRequest {
	if req == nil || req.Timestamp == nil {
		return nil
	}
	return &models.GetSunPositionRequest{
		Latitude:      req.Latitude,
		Longitude:     req.Longitude,
		TimestampUnix: req.Timestamp.AsTime().Unix(),
	}
}

func SunPositionToProto(resp *models.GetSunPositionResponse) *simulationv1.GetSunPositionResponse {
	if resp == nil {
		return &simulationv1.GetSunPositionResponse{}
	}
	return &simulationv1.GetSunPositionResponse{
		Position: &simulationv1.SunPosition{
			Azimuth:   resp.Position.Azimuth,
			Elevation: resp.Position.Elevation,
			Zenith:    resp.Position.Zenith,
			HourAngle: resp.Position.HourAngle,
			Timestamp: timestamppb.New(unixSeconds(resp.Position.TimestampUnix)),
		},
	}
}

func ProtoToGetShadowMap(req *simulationv1.GetShadowMapRequest) *models.GetShadowMapRequest {
	if req == nil || req.Timestamp == nil {
		return nil
	}
	return &models.GetShadowMapRequest{
		LayoutID:      req.LayoutId,
		Latitude:      req.Latitude,
		Longitude:     req.Longitude,
		TimestampUnix: req.Timestamp.AsTime().Unix(),
	}
}

func ShadowMapToProto(resp *models.GetShadowMapResponse) *simulationv1.GetShadowMapResponse {
	if resp == nil {
		return &simulationv1.GetShadowMapResponse{}
	}
	shadows := make([]*simulationv1.ShadowPolygon, 0, len(resp.Shadows))
	for _, s := range resp.Shadows {
		shadows = append(shadows, &simulationv1.ShadowPolygon{
			SourcePanelId:   s.SourcePanelID,
			ShadowGeojson:   s.ShadowGeoJSON,
			ShadowIntensity: s.ShadowIntensity,
		})
	}
	return &simulationv1.GetShadowMapResponse{
		Shadows: shadows,
		SunPosition: &simulationv1.SunPosition{
			Azimuth:   resp.SunPosition.Azimuth,
			Elevation: resp.SunPosition.Elevation,
			Zenith:    resp.SunPosition.Zenith,
			HourAngle: resp.SunPosition.HourAngle,
			Timestamp: timestamppb.New(unixSeconds(resp.SunPosition.TimestampUnix)),
		},
	}
}

