import 'package:equatable/equatable.dart';

class Layout extends Equatable {
  final String id;
  final String projectId;
  final String name;
  final int totalPanels;
  final double totalCapacityKw;
  final int tileCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Layout({
    required this.id,
    required this.projectId,
    required this.name,
    required this.totalPanels,
    required this.totalCapacityKw,
    required this.tileCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Layout.fromJson(Map<String, dynamic> json) {
    return Layout(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      name: json['name'] as String,
      totalPanels: json['total_panels'] as int? ?? 0,
      totalCapacityKw: (json['total_capacity_kw'] as num?)?.toDouble() ?? 0,
      tileCount: json['tile_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'name': name,
        'total_panels': totalPanels,
        'total_capacity_kw': totalCapacityKw,
        'tile_count': tileCount,
      };

  @override
  List<Object?> get props => [id, projectId, name, totalPanels];
}

class BoundingBox extends Equatable {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  const BoundingBox({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      minX: (json['min_x'] as num).toDouble(),
      minY: (json['min_y'] as num).toDouble(),
      maxX: (json['max_x'] as num).toDouble(),
      maxY: (json['max_y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'min_x': minX,
        'min_y': minY,
        'max_x': maxX,
        'max_y': maxY,
      };

  @override
  List<Object?> get props => [minX, minY, maxX, maxY];
}

class LayoutTile extends Equatable {
  final String id;
  final String layoutId;
  final BoundingBox bbox;
  final int lodLevel;
  final int panelCount;

  const LayoutTile({
    required this.id,
    required this.layoutId,
    required this.bbox,
    required this.lodLevel,
    required this.panelCount,
  });

  factory LayoutTile.fromJson(Map<String, dynamic> json) {
    return LayoutTile(
      id: json['id'] as String,
      layoutId: json['layout_id'] as String,
      bbox: BoundingBox.fromJson(json['bbox'] as Map<String, dynamic>),
      lodLevel: json['lod_level'] as int? ?? 0,
      panelCount: json['panel_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, layoutId, lodLevel];
}

class Panel extends Equatable {
  final String id;
  final String tileId;
  final String? stringId;
  final String geometryGeojson;
  final double tilt;
  final double azimuth;
  final double elevation;

  const Panel({
    required this.id,
    required this.tileId,
    this.stringId,
    required this.geometryGeojson,
    required this.tilt,
    required this.azimuth,
    required this.elevation,
  });

  factory Panel.fromJson(Map<String, dynamic> json) {
    return Panel(
      id: json['id'] as String,
      tileId: json['tile_id'] as String,
      stringId: json['string_id'] as String?,
      geometryGeojson: json['geometry_geojson'] as String,
      tilt: (json['tilt'] as num).toDouble(),
      azimuth: (json['azimuth'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, tileId];
}

class PanelArrayParams {
  final double panelWidth;
  final double panelHeight;
  final double tiltAngle;
  final double azimuth;
  final double rowSpacing;
  final double columnSpacing;
  final String fillAreaGeojson;
  final String? terrainLayerId;

  const PanelArrayParams({
    required this.panelWidth,
    required this.panelHeight,
    required this.tiltAngle,
    required this.azimuth,
    required this.rowSpacing,
    required this.columnSpacing,
    required this.fillAreaGeojson,
    this.terrainLayerId,
  });

  Map<String, dynamic> toJson() => {
        'panel_width': panelWidth,
        'panel_height': panelHeight,
        'tilt_angle': tiltAngle,
        'azimuth': azimuth,
        'row_spacing': rowSpacing,
        'column_spacing': columnSpacing,
        'fill_area_geojson': fillAreaGeojson,
        if (terrainLayerId != null) 'terrain_layer_id': terrainLayerId,
      };
}

class Component extends Equatable {
  final String id;
  final String layoutId;
  final String? assetId;
  final String componentType;
  final ComponentPosition position;
  final double rotation;
  final String? metadataJson;

  const Component({
    required this.id,
    required this.layoutId,
    this.assetId,
    required this.componentType,
    required this.position,
    this.rotation = 0,
    this.metadataJson,
  });

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      id: json['id'] as String,
      layoutId: json['layout_id'] as String,
      assetId: json['asset_id'] as String?,
      componentType: json['component_type'] as String,
      position: ComponentPosition.fromJson(
          json['position'] as Map<String, dynamic>),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
      metadataJson: json['metadata_json'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, layoutId, componentType];
}

class ComponentPosition extends Equatable {
  final double longitude;
  final double latitude;
  final double elevation;

  const ComponentPosition({
    required this.longitude,
    required this.latitude,
    this.elevation = 0,
  });

  factory ComponentPosition.fromJson(Map<String, dynamic> json) {
    return ComponentPosition(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
        'elevation': elevation,
      };

  @override
  List<Object?> get props => [longitude, latitude, elevation];
}
