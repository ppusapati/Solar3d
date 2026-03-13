import 'package:equatable/equatable.dart';

class RouteModel extends Equatable {
  final String id;
  final String projectId;
  final String layoutId;
  final String name;
  final String routeType;
  final List<Waypoint> waypoints;
  final double distanceM;
  final double? costEstimate;
  final String? geojson;
  final DateTime createdAt;

  const RouteModel({
    required this.id,
    required this.projectId,
    required this.layoutId,
    required this.name,
    required this.routeType,
    required this.waypoints,
    required this.distanceM,
    this.costEstimate,
    this.geojson,
    required this.createdAt,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      layoutId: json['layout_id'] as String,
      name: json['name'] as String,
      routeType: json['route_type'] as String,
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => Waypoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      distanceM: (json['distance_m'] as num).toDouble(),
      costEstimate: (json['cost_estimate'] as num?)?.toDouble(),
      geojson: json['geojson'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, projectId, routeType];
}

class Waypoint extends Equatable {
  final double longitude;
  final double latitude;
  final double? elevation;

  const Waypoint({
    required this.longitude,
    required this.latitude,
    this.elevation,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        if (elevation != null) 'elevation': elevation,
      };

  @override
  List<Object?> get props => [longitude, latitude];
}

class RouteConstraints {
  final double? maxSlopePercent;
  final bool avoidWater;
  final List<String>? avoidanceZonesGeojson;
  final double? slopePenalty;

  const RouteConstraints({
    this.maxSlopePercent,
    this.avoidWater = false,
    this.avoidanceZonesGeojson,
    this.slopePenalty,
  });

  Map<String, dynamic> toJson() => {
        if (maxSlopePercent != null) 'max_slope_percent': maxSlopePercent,
        'avoid_water': avoidWater,
        if (avoidanceZonesGeojson != null)
          'avoidance_zones_geojson': avoidanceZonesGeojson,
        if (slopePenalty != null) 'slope_penalty': slopePenalty,
      };
}
