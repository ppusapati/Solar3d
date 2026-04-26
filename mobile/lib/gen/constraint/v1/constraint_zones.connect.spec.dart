//
//  Generated code. Do not modify.
//  source: constraint/v1/constraint_zones.proto
//

import "package:connectrpc/connect.dart" as connect;
import "constraint_zones.pb.dart" as constraintv1constraint_zones;

/// ConstraintZoneService provides zone management and siting conflict analysis.
abstract final class ConstraintZoneService {
  /// Fully-qualified name of the ConstraintZoneService service.
  static const name = 'constraint.v1.ConstraintZoneService';

  /// CreateZone creates a new constraint zone.
  static const createZone = connect.Spec(
    '/$name/CreateZone',
    connect.StreamType.unary,
    constraintv1constraint_zones.CreateZoneRequest.new,
    constraintv1constraint_zones.CreateZoneResponse.new,
  );

  /// UpdateZone updates an existing zone.
  static const updateZone = connect.Spec(
    '/$name/UpdateZone',
    connect.StreamType.unary,
    constraintv1constraint_zones.UpdateZoneRequest.new,
    constraintv1constraint_zones.UpdateZoneResponse.new,
  );

  /// DeleteZone removes a zone (soft delete with audit trail).
  static const deleteZone = connect.Spec(
    '/$name/DeleteZone',
    connect.StreamType.unary,
    constraintv1constraint_zones.DeleteZoneRequest.new,
    constraintv1constraint_zones.DeleteZoneResponse.new,
  );

  /// GetZone retrieves a single zone by ID.
  static const getZone = connect.Spec(
    '/$name/GetZone',
    connect.StreamType.unary,
    constraintv1constraint_zones.GetZoneRequest.new,
    constraintv1constraint_zones.GetZoneResponse.new,
  );

  /// ListZones lists zones with filtering and pagination.
  static const listZones = connect.Spec(
    '/$name/ListZones',
    connect.StreamType.unary,
    constraintv1constraint_zones.ListZonesRequest.new,
    constraintv1constraint_zones.ListZonesResponse.new,
  );

  /// QueryZonesByLocation finds zones intersecting/containing a location or geometry.
  static const queryZonesByLocation = connect.Spec(
    '/$name/QueryZonesByLocation',
    connect.StreamType.unary,
    constraintv1constraint_zones.QueryZonesByLocationRequest.new,
    constraintv1constraint_zones.QueryZonesByLocationResponse.new,
  );

  /// CheckSitingConflicts analyzes proposed landing site against constraint zones.
  static const checkSitingConflicts = connect.Spec(
    '/$name/CheckSitingConflicts',
    connect.StreamType.unary,
    constraintv1constraint_zones.CheckSitingConflictsRequest.new,
    constraintv1constraint_zones.CheckSitingConflictsResponse.new,
  );

  /// ListZoneCategories returns available zone category taxonomy.
  static const listZoneCategories = connect.Spec(
    '/$name/ListZoneCategories',
    connect.StreamType.unary,
    constraintv1constraint_zones.ListZoneCategoriesRequest.new,
    constraintv1constraint_zones.ListZoneCategoriesResponse.new,
  );
}
