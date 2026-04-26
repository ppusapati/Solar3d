package mappers

import (
	"p9e.in/samavaya/solar3d/compute-service/internal/models"

	geov1 "p9e.in/samavaya/solar3d/gen/geo/v1"
)

func ProtoToBufferPoint(req *geov1.BufferPointRequest) *models.BufferPointRequest {
	if req == nil || req.Center == nil {
		return nil
	}
	return &models.BufferPointRequest{
		Center:   models.Point2DModel{X: req.Center.X, Y: req.Center.Y},
		Radius:   req.Radius,
		Segments: req.Segments,
	}
}

func BufferPointToProto(resp *models.BufferPointResponse) *geov1.BufferPointResponse {
	if resp == nil {
		return &geov1.BufferPointResponse{}
	}
	ring := make([]*geov1.Point2D, 0, len(resp.Polygon.Ring))
	for _, p := range resp.Polygon.Ring {
		ring = append(ring, &geov1.Point2D{X: p.X, Y: p.Y})
	}
	return &geov1.BufferPointResponse{Polygon: &geov1.Polygon{Ring: ring}}
}

func ProtoToNearestPoint(req *geov1.NearestPointRequest) *models.NearestPointRequest {
	if req == nil || req.Query == nil {
		return nil
	}
	candidates := make([]models.Point2DModel, 0, len(req.Candidates))
	for _, c := range req.Candidates {
		candidates = append(candidates, models.Point2DModel{X: c.X, Y: c.Y})
	}
	return &models.NearestPointRequest{
		Query:      models.Point2DModel{X: req.Query.X, Y: req.Query.Y},
		Candidates: candidates,
	}
}

func NearestPointToProto(resp *models.NearestPointResponse) *geov1.NearestPointResponse {
	if resp == nil {
		return &geov1.NearestPointResponse{}
	}
	return &geov1.NearestPointResponse{
		Index:    resp.Index,
		Distance: resp.Distance,
		Point:    &geov1.Point2D{X: resp.Point.X, Y: resp.Point.Y},
	}
}

func ProtoToGenerateContours(req *geov1.GenerateContoursRequest) *models.GenerateContoursRequest {
	if req == nil {
		return nil
	}
	return &models.GenerateContoursRequest{
		Width:      req.Width,
		Height:     req.Height,
		Resolution: req.Resolution,
		OriginX:    req.OriginX,
		OriginY:    req.OriginY,
		NoData:     req.NoData,
		Data:       append([]float64(nil), req.Data...),
		Interval:   req.Interval,
	}
}

func GenerateContoursToProto(resp *models.GenerateContoursResponse) *geov1.GenerateContoursResponse {
	if resp == nil {
		return &geov1.GenerateContoursResponse{}
	}
	contours := make([]*geov1.ContourLine, 0, len(resp.Contours))
	for _, c := range resp.Contours {
		pts := make([]*geov1.Point2D, 0, len(c.Points))
		for _, p := range c.Points {
			pts = append(pts, &geov1.Point2D{X: p.X, Y: p.Y})
		}
		contours = append(contours, &geov1.ContourLine{Elevation: c.Elevation, Points: pts})
	}
	return &geov1.GenerateContoursResponse{Contours: contours}
}

