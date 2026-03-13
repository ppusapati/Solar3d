import 'package:equatable/equatable.dart';

class TerrainLayer extends Equatable {
  final String id;
  final String projectId;
  final String name;
  final String layerType;
  final String? sourceFile;
  final TerrainBounds? bounds;
  final double? resolutionM;
  final String? crs;
  final double? minElevation;
  final double? maxElevation;
  final DateTime createdAt;

  const TerrainLayer({
    required this.id,
    required this.projectId,
    required this.name,
    required this.layerType,
    this.sourceFile,
    this.bounds,
    this.resolutionM,
    this.crs,
    this.minElevation,
    this.maxElevation,
    required this.createdAt,
  });

  factory TerrainLayer.fromJson(Map<String, dynamic> json) {
    return TerrainLayer(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      name: json['name'] as String,
      layerType: json['layer_type'] as String,
      sourceFile: json['source_file'] as String?,
      bounds: json['bounds'] != null
          ? TerrainBounds.fromJson(json['bounds'] as Map<String, dynamic>)
          : null,
      resolutionM: (json['resolution_m'] as num?)?.toDouble(),
      crs: json['crs'] as String?,
      minElevation: (json['min_elevation'] as num?)?.toDouble(),
      maxElevation: (json['max_elevation'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, projectId, layerType];
}

class TerrainBounds extends Equatable {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  const TerrainBounds({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  factory TerrainBounds.fromJson(Map<String, dynamic> json) {
    return TerrainBounds(
      minX: (json['min_x'] as num).toDouble(),
      minY: (json['min_y'] as num).toDouble(),
      maxX: (json['max_x'] as num).toDouble(),
      maxY: (json['max_y'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [minX, minY, maxX, maxY];
}

class ElevationGrid extends Equatable {
  final int width;
  final int height;
  final List<double> elevations;
  final double minElevation;
  final double maxElevation;

  const ElevationGrid({
    required this.width,
    required this.height,
    required this.elevations,
    required this.minElevation,
    required this.maxElevation,
  });

  factory ElevationGrid.fromJson(Map<String, dynamic> json) {
    return ElevationGrid(
      width: json['width'] as int,
      height: json['height'] as int,
      elevations: (json['elevations'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      minElevation: (json['min_elevation'] as num).toDouble(),
      maxElevation: (json['max_elevation'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [width, height, minElevation, maxElevation];
}
