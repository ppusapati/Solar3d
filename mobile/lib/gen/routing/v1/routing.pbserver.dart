//
//  Generated code. Do not modify.
//  source: routing/v1/routing.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'routing.pb.dart' as $3;
import 'routing.pbjson.dart';

export 'routing.pb.dart';

abstract class RoutingServiceBase extends $pb.GeneratedService {
  $async.Future<$3.CreateRouteResponse> createRoute($pb.ServerContext ctx, $3.CreateRouteRequest request);
  $async.Future<$3.GetRouteResponse> getRoute($pb.ServerContext ctx, $3.GetRouteRequest request);
  $async.Future<$3.CalculateRouteResponse> calculateRoute($pb.ServerContext ctx, $3.CalculateRouteRequest request);
  $async.Future<$3.CreateCableRouteResponse> createCableRoute($pb.ServerContext ctx, $3.CreateCableRouteRequest request);
  $async.Future<$3.CreateRoadRouteResponse> createRoadRoute($pb.ServerContext ctx, $3.CreateRoadRouteRequest request);
  $async.Future<$3.ListRoutesResponse> listRoutes($pb.ServerContext ctx, $3.ListRoutesRequest request);
  $async.Future<$3.DeleteRouteResponse> deleteRoute($pb.ServerContext ctx, $3.DeleteRouteRequest request);
  $async.Future<$3.OptimizeRoutesResponse> optimizeRoutes($pb.ServerContext ctx, $3.OptimizeRoutesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateRoute': return $3.CreateRouteRequest();
      case 'GetRoute': return $3.GetRouteRequest();
      case 'CalculateRoute': return $3.CalculateRouteRequest();
      case 'CreateCableRoute': return $3.CreateCableRouteRequest();
      case 'CreateRoadRoute': return $3.CreateRoadRouteRequest();
      case 'ListRoutes': return $3.ListRoutesRequest();
      case 'DeleteRoute': return $3.DeleteRouteRequest();
      case 'OptimizeRoutes': return $3.OptimizeRoutesRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateRoute': return this.createRoute(ctx, request as $3.CreateRouteRequest);
      case 'GetRoute': return this.getRoute(ctx, request as $3.GetRouteRequest);
      case 'CalculateRoute': return this.calculateRoute(ctx, request as $3.CalculateRouteRequest);
      case 'CreateCableRoute': return this.createCableRoute(ctx, request as $3.CreateCableRouteRequest);
      case 'CreateRoadRoute': return this.createRoadRoute(ctx, request as $3.CreateRoadRouteRequest);
      case 'ListRoutes': return this.listRoutes(ctx, request as $3.ListRoutesRequest);
      case 'DeleteRoute': return this.deleteRoute(ctx, request as $3.DeleteRouteRequest);
      case 'OptimizeRoutes': return this.optimizeRoutes(ctx, request as $3.OptimizeRoutesRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => RoutingServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => RoutingServiceBase$messageJson;
}

