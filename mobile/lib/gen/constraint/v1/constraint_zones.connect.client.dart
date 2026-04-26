//
//  Generated code. Do not modify.
//  source: constraint/v1/constraint_zones.proto
//

import "package:connectrpc/connect.dart" as connect;
import "constraint_zones.pb.dart" as constraintv1constraint_zones;
import "constraint_zones.connect.spec.dart" as specs;

/// ConstraintZoneService provides zone management and siting conflict analysis.
extension type ConstraintZoneServiceClient (connect.Transport _transport) {
  /// CreateZone creates a new constraint zone.
  Future<constraintv1constraint_zones.CreateZoneResponse> createZone(
    constraintv1constraint_zones.CreateZoneRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.createZone,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdateZone updates an existing zone.
  Future<constraintv1constraint_zones.UpdateZoneResponse> updateZone(
    constraintv1constraint_zones.UpdateZoneRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.updateZone,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteZone removes a zone (soft delete with audit trail).
  Future<constraintv1constraint_zones.DeleteZoneResponse> deleteZone(
    constraintv1constraint_zones.DeleteZoneRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.deleteZone,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetZone retrieves a single zone by ID.
  Future<constraintv1constraint_zones.GetZoneResponse> getZone(
    constraintv1constraint_zones.GetZoneRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.getZone,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListZones lists zones with filtering and pagination.
  Future<constraintv1constraint_zones.ListZonesResponse> listZones(
    constraintv1constraint_zones.ListZonesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.listZones,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// QueryZonesByLocation finds zones intersecting/containing a location or geometry.
  Future<constraintv1constraint_zones.QueryZonesByLocationResponse> queryZonesByLocation(
    constraintv1constraint_zones.QueryZonesByLocationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.queryZonesByLocation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CheckSitingConflicts analyzes proposed landing site against constraint zones.
  Future<constraintv1constraint_zones.CheckSitingConflictsResponse> checkSitingConflicts(
    constraintv1constraint_zones.CheckSitingConflictsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.checkSitingConflicts,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListZoneCategories returns available zone category taxonomy.
  Future<constraintv1constraint_zones.ListZoneCategoriesResponse> listZoneCategories(
    constraintv1constraint_zones.ListZoneCategoriesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ConstraintZoneService.listZoneCategories,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
