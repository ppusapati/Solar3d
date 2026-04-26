//
//  Generated code. Do not modify.
//  source: constraint/v1/constraint_zones.proto
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

import 'constraint_zones.pb.dart' as $2;
import 'constraint_zones.pbjson.dart';

export 'constraint_zones.pb.dart';

abstract class ConstraintZoneServiceBase extends $pb.GeneratedService {
  $async.Future<$2.CreateZoneResponse> createZone($pb.ServerContext ctx, $2.CreateZoneRequest request);
  $async.Future<$2.UpdateZoneResponse> updateZone($pb.ServerContext ctx, $2.UpdateZoneRequest request);
  $async.Future<$2.DeleteZoneResponse> deleteZone($pb.ServerContext ctx, $2.DeleteZoneRequest request);
  $async.Future<$2.GetZoneResponse> getZone($pb.ServerContext ctx, $2.GetZoneRequest request);
  $async.Future<$2.ListZonesResponse> listZones($pb.ServerContext ctx, $2.ListZonesRequest request);
  $async.Future<$2.QueryZonesByLocationResponse> queryZonesByLocation($pb.ServerContext ctx, $2.QueryZonesByLocationRequest request);
  $async.Future<$2.CheckSitingConflictsResponse> checkSitingConflicts($pb.ServerContext ctx, $2.CheckSitingConflictsRequest request);
  $async.Future<$2.ListZoneCategoriesResponse> listZoneCategories($pb.ServerContext ctx, $2.ListZoneCategoriesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateZone': return $2.CreateZoneRequest();
      case 'UpdateZone': return $2.UpdateZoneRequest();
      case 'DeleteZone': return $2.DeleteZoneRequest();
      case 'GetZone': return $2.GetZoneRequest();
      case 'ListZones': return $2.ListZonesRequest();
      case 'QueryZonesByLocation': return $2.QueryZonesByLocationRequest();
      case 'CheckSitingConflicts': return $2.CheckSitingConflictsRequest();
      case 'ListZoneCategories': return $2.ListZoneCategoriesRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateZone': return this.createZone(ctx, request as $2.CreateZoneRequest);
      case 'UpdateZone': return this.updateZone(ctx, request as $2.UpdateZoneRequest);
      case 'DeleteZone': return this.deleteZone(ctx, request as $2.DeleteZoneRequest);
      case 'GetZone': return this.getZone(ctx, request as $2.GetZoneRequest);
      case 'ListZones': return this.listZones(ctx, request as $2.ListZonesRequest);
      case 'QueryZonesByLocation': return this.queryZonesByLocation(ctx, request as $2.QueryZonesByLocationRequest);
      case 'CheckSitingConflicts': return this.checkSitingConflicts(ctx, request as $2.CheckSitingConflictsRequest);
      case 'ListZoneCategories': return this.listZoneCategories(ctx, request as $2.ListZoneCategoriesRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ConstraintZoneServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ConstraintZoneServiceBase$messageJson;
}

