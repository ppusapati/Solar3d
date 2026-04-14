package handler

import (
	"context"
	"encoding/json"
	"errors"

	connect "connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	routingv1 "github.com/solar3d/solar3d/gen/routing/v1"
	routingv1connect "github.com/solar3d/solar3d/gen/routing/v1/routingv1connect"

	"solar3d/routing-service/internal/domain"
	"solar3d/routing-service/internal/service"
)

type ConnectRoutingService struct {
	svc *service.RoutingService
}

var _ routingv1connect.RoutingServiceHandler = (*ConnectRoutingService)(nil)

func NewConnectRoutingService(svc *service.RoutingService) *ConnectRoutingService {
	return &ConnectRoutingService{svc: svc}
}

func (h *ConnectRoutingService) CreateRoute(
	ctx context.Context,
	req *connect.Request[routingv1.CreateRouteRequest],
) (*connect.Response[routingv1.CreateRouteResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	route, err := h.svc.CreateRoute(ctx, domain.CreateRouteRequest{
		ProjectID:       projectID,
		RouteType:       protoRouteTypeToDomain(req.Msg.GetRouteType()),
		Name:            req.Msg.GetName(),
		GeometryGeoJSON: json.RawMessage(req.Msg.GetGeometryGeojson()),
		DistanceM:       req.Msg.GetDistanceM(),
		CostEstimate:    req.Msg.GetCostEstimate(),
		Metadata:        routeMetadataToRawJSON(req.Msg.GetMetadata()),
	})
	if err != nil {
		return nil, routingConnectError(err)
	}

	return connect.NewResponse(&routingv1.CreateRouteResponse{
		Route: routeToProto(route),
	}), nil
}

func (h *ConnectRoutingService) GetRoute(
	ctx context.Context,
	req *connect.Request[routingv1.GetRouteRequest],
) (*connect.Response[routingv1.GetRouteResponse], error) {
	routeID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid route id"))
	}

	route, err := h.svc.GetRoute(ctx, routeID)
	if err != nil {
		return nil, routingConnectError(err)
	}

	return connect.NewResponse(&routingv1.GetRouteResponse{
		Route: routeToProto(route),
	}), nil
}

func (h *ConnectRoutingService) CalculateRoute(
	ctx context.Context,
	req *connect.Request[routingv1.CalculateRouteRequest],
) (*connect.Response[routingv1.CalculateRouteResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	if req.Msg.GetSource() == nil || req.Msg.GetDestination() == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("source and destination are required"))
	}

	route, err := h.svc.CalculateRoute(ctx, domain.CalculateRouteRequest{
		ProjectID:   projectID,
		RouteType:   protoRouteTypeToDomain(req.Msg.GetRouteType()),
		Name:        "",
		Start:       protoWaypointToDomain(req.Msg.GetSource()),
		End:         protoWaypointToDomain(req.Msg.GetDestination()),
		Constraints: protoConstraintsToDomain(req.Msg.GetConstraints()),
	})
	if err != nil {
		return nil, routingConnectError(err)
	}

	waypoints := routeGeometryToWaypoints(route.GeometryGeoJSON)
	maxSlope := 0.0
	if constraints := req.Msg.GetConstraints(); constraints != nil {
		maxSlope = constraints.GetMaxSlopePercent()
	}
	return connect.NewResponse(&routingv1.CalculateRouteResponse{
		Waypoints:           waypoints,
		DistanceM:           route.DistanceM,
		CostEstimate:        route.CostEstimate,
		MaxSlopeEncountered: maxSlope,
	}), nil
}

func (h *ConnectRoutingService) CreateCableRoute(
	ctx context.Context,
	req *connect.Request[routingv1.CreateCableRouteRequest],
) (*connect.Response[routingv1.CreateCableRouteResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	if req.Msg.GetSource() == nil || req.Msg.GetDestination() == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("source and destination are required"))
	}

	route, err := h.svc.CreateCableRoute(ctx, domain.CalculateRouteRequest{
		ProjectID:   projectID,
		RouteType:   domain.RouteTypeCable,
		Name:        req.Msg.GetName(),
		Start:       protoWaypointToDomain(req.Msg.GetSource()),
		End:         protoWaypointToDomain(req.Msg.GetDestination()),
		Constraints: protoConstraintsToDomain(req.Msg.GetConstraints()),
	})
	if err != nil {
		return nil, routingConnectError(err)
	}

	return connect.NewResponse(&routingv1.CreateCableRouteResponse{
		Route: routeToProto(route),
	}), nil
}

func (h *ConnectRoutingService) CreateRoadRoute(
	ctx context.Context,
	req *connect.Request[routingv1.CreateRoadRouteRequest],
) (*connect.Response[routingv1.CreateRoadRouteResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}
	if req.Msg.GetSource() == nil || req.Msg.GetDestination() == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("source and destination are required"))
	}

	route, err := h.svc.CreateRoadRoute(ctx, domain.CalculateRouteRequest{
		ProjectID:   projectID,
		RouteType:   domain.RouteTypeRoad,
		Name:        req.Msg.GetName(),
		Start:       protoWaypointToDomain(req.Msg.GetSource()),
		End:         protoWaypointToDomain(req.Msg.GetDestination()),
		Constraints: protoConstraintsToDomain(req.Msg.GetConstraints()),
	})
	if err != nil {
		return nil, routingConnectError(err)
	}

	return connect.NewResponse(&routingv1.CreateRoadRouteResponse{
		Route: routeToProto(route),
	}), nil
}

func (h *ConnectRoutingService) ListRoutes(
	ctx context.Context,
	req *connect.Request[routingv1.ListRoutesRequest],
) (*connect.Response[routingv1.ListRoutesResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	routes, err := h.svc.ListRoutes(ctx, projectID)
	if err != nil {
		return nil, routingConnectError(err)
	}

	filter := req.Msg.GetTypeFilter()
	result := make([]*routingv1.Route, 0, len(routes))
	for i := range routes {
		route := routes[i]
		protoRoute := routeToProto(&route)
		if filter != routingv1.RouteType_ROUTE_TYPE_UNSPECIFIED && protoRoute.GetRouteType() != filter {
			continue
		}
		result = append(result, protoRoute)
	}

	return connect.NewResponse(&routingv1.ListRoutesResponse{
		Routes: result,
	}), nil
}

func (h *ConnectRoutingService) DeleteRoute(
	ctx context.Context,
	req *connect.Request[routingv1.DeleteRouteRequest],
) (*connect.Response[routingv1.DeleteRouteResponse], error) {
	routeID, err := uuid.Parse(req.Msg.GetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid route id"))
	}

	if err := h.svc.DeleteRoute(ctx, routeID); err != nil {
		return nil, routingConnectError(err)
	}

	return connect.NewResponse(&routingv1.DeleteRouteResponse{}), nil
}

func (h *ConnectRoutingService) OptimizeRoutes(
	ctx context.Context,
	req *connect.Request[routingv1.OptimizeRoutesRequest],
) (*connect.Response[routingv1.OptimizeRoutesResponse], error) {
	projectID, err := uuid.Parse(req.Msg.GetProjectId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid project_id"))
	}

	routes, err := h.svc.OptimizeRoutes(ctx, projectID)
	if err != nil {
		return nil, routingConnectError(err)
	}

	filter := req.Msg.GetRouteType()
	result := make([]*routingv1.Route, 0, len(routes))
	totalDistance := 0.0
	totalCost := 0.0
	for i := range routes {
		route := routes[i]
		protoRoute := routeToProto(&route)
		if filter != routingv1.RouteType_ROUTE_TYPE_UNSPECIFIED && protoRoute.GetRouteType() != filter {
			continue
		}
		result = append(result, protoRoute)
		totalDistance += route.DistanceM
		totalCost += route.CostEstimate
	}

	return connect.NewResponse(&routingv1.OptimizeRoutesResponse{
		OptimizedRoutes:   result,
		TotalDistanceM:    totalDistance,
		TotalCostEstimate: totalCost,
	}), nil
}

func routeToProto(route *domain.Route) *routingv1.Route {
	if route == nil {
		return nil
	}
	return &routingv1.Route{
		Id:              route.ID.String(),
		ProjectId:       route.ProjectID.String(),
		RouteType:       domainRouteTypeToProto(route.RouteType),
		Name:            route.Name,
		GeometryGeojson: string(route.GeometryGeoJSON),
		DistanceM:       route.DistanceM,
		CostEstimate:    route.CostEstimate,
		Metadata:        rawJSONToRouteMetadata(route.Metadata),
	}
}

func routeGeometryToWaypoints(geometry json.RawMessage) []*routingv1.Waypoint {
	var data struct {
		Coordinates [][]float64 `json:"coordinates"`
	}
	if err := json.Unmarshal(geometry, &data); err != nil {
		return []*routingv1.Waypoint{}
	}

	waypoints := make([]*routingv1.Waypoint, 0, len(data.Coordinates))
	for _, coordinate := range data.Coordinates {
		if len(coordinate) < 2 {
			continue
		}
		elevation := 0.0
		if len(coordinate) > 2 {
			elevation = coordinate[2]
		}
		waypoints = append(waypoints, &routingv1.Waypoint{
			Longitude: coordinate[0],
			Latitude:  coordinate[1],
			Elevation: elevation,
		})
	}
	return waypoints
}

func protoWaypointToDomain(waypoint *routingv1.Waypoint) domain.Waypoint {
	if waypoint == nil {
		return domain.Waypoint{}
	}
	return domain.Waypoint{
		Lon:       waypoint.GetLongitude(),
		Lat:       waypoint.GetLatitude(),
		Elevation: waypoint.GetElevation(),
	}
}

func protoConstraintsToDomain(constraints *routingv1.RouteConstraints) domain.RouteConstraints {
	if constraints == nil {
		return domain.RouteConstraints{}
	}
	return domain.RouteConstraints{
		MaxSlope:     constraints.GetMaxSlopePercent(),
		AvoidWater:   constraints.GetAvoidWater(),
		SlopePenalty: constraints.GetTerrainSlopePenalty(),
	}
}

func routeMetadataToRawJSON(metadata *routingv1.RouteMetadata) json.RawMessage {
	if metadata == nil {
		return nil
	}
	data, err := json.Marshal(map[string]any{
		"cable_type":           metadata.GetCableType(),
		"cable_size_mm2":       metadata.GetCableSizeMm2(),
		"voltage_drop_percent": metadata.GetVoltageDropPercent(),
		"max_slope_percent":    metadata.GetMaxSlopePercent(),
	})
	if err != nil {
		return nil
	}
	return data
}

func rawJSONToRouteMetadata(metadata json.RawMessage) *routingv1.RouteMetadata {
	if len(metadata) == 0 {
		return nil
	}
	var raw struct {
		CableType       string  `json:"cable_type"`
		CableSizeMM2    float64 `json:"cable_size_mm2"`
		VoltageDrop     float64 `json:"voltage_drop_percent"`
		MaxSlopePercent float64 `json:"max_slope_percent"`
	}
	if err := json.Unmarshal(metadata, &raw); err != nil {
		return nil
	}
	return &routingv1.RouteMetadata{
		CableType:          raw.CableType,
		CableSizeMm2:       raw.CableSizeMM2,
		VoltageDropPercent: raw.VoltageDrop,
		MaxSlopePercent:    raw.MaxSlopePercent,
	}
}

func protoRouteTypeToDomain(routeType routingv1.RouteType) domain.RouteType {
	switch routeType {
	case routingv1.RouteType_ROUTE_TYPE_FENCE:
		return domain.RouteTypeFence
	case routingv1.RouteType_ROUTE_TYPE_ACCESS_ROAD, routingv1.RouteType_ROUTE_TYPE_SERVICE_ROAD:
		return domain.RouteTypeRoad
	case routingv1.RouteType_ROUTE_TYPE_DC_CABLE, routingv1.RouteType_ROUTE_TYPE_AC_CABLE, routingv1.RouteType_ROUTE_TYPE_COMMUNICATION:
		return domain.RouteTypeCable
	default:
		return domain.RouteTypeCable
	}
}

func domainRouteTypeToProto(routeType domain.RouteType) routingv1.RouteType {
	switch routeType {
	case domain.RouteTypeRoad:
		return routingv1.RouteType_ROUTE_TYPE_ACCESS_ROAD
	case domain.RouteTypeFence:
		return routingv1.RouteType_ROUTE_TYPE_FENCE
	case domain.RouteTypeCable:
		return routingv1.RouteType_ROUTE_TYPE_DC_CABLE
	default:
		return routingv1.RouteType_ROUTE_TYPE_UNSPECIFIED
	}
}

func routingConnectError(err error) error {
	switch {
	case errors.Is(err, pgx.ErrNoRows):
		return connect.NewError(connect.CodeNotFound, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

