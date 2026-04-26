//
//  Generated code. Do not modify.
//  source: routing/v1/routing.proto
//

import "package:connectrpc/connect.dart" as connect;
import "routing.pb.dart" as routingv1routing;

abstract final class RoutingService {
  /// Fully-qualified name of the RoutingService service.
  static const name = 'routing.v1.RoutingService';

  static const createRoute = connect.Spec(
    '/$name/CreateRoute',
    connect.StreamType.unary,
    routingv1routing.CreateRouteRequest.new,
    routingv1routing.CreateRouteResponse.new,
  );

  static const getRoute = connect.Spec(
    '/$name/GetRoute',
    connect.StreamType.unary,
    routingv1routing.GetRouteRequest.new,
    routingv1routing.GetRouteResponse.new,
  );

  static const calculateRoute = connect.Spec(
    '/$name/CalculateRoute',
    connect.StreamType.unary,
    routingv1routing.CalculateRouteRequest.new,
    routingv1routing.CalculateRouteResponse.new,
  );

  static const createCableRoute = connect.Spec(
    '/$name/CreateCableRoute',
    connect.StreamType.unary,
    routingv1routing.CreateCableRouteRequest.new,
    routingv1routing.CreateCableRouteResponse.new,
  );

  static const createRoadRoute = connect.Spec(
    '/$name/CreateRoadRoute',
    connect.StreamType.unary,
    routingv1routing.CreateRoadRouteRequest.new,
    routingv1routing.CreateRoadRouteResponse.new,
  );

  static const listRoutes = connect.Spec(
    '/$name/ListRoutes',
    connect.StreamType.unary,
    routingv1routing.ListRoutesRequest.new,
    routingv1routing.ListRoutesResponse.new,
  );

  static const deleteRoute = connect.Spec(
    '/$name/DeleteRoute',
    connect.StreamType.unary,
    routingv1routing.DeleteRouteRequest.new,
    routingv1routing.DeleteRouteResponse.new,
  );

  static const optimizeRoutes = connect.Spec(
    '/$name/OptimizeRoutes',
    connect.StreamType.unary,
    routingv1routing.OptimizeRoutesRequest.new,
    routingv1routing.OptimizeRoutesResponse.new,
  );
}
