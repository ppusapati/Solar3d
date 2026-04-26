//
//  Generated code. Do not modify.
//  source: terrain/v1/terrain.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TerrainLayerType extends $pb.ProtobufEnum {
  static const TerrainLayerType TERRAIN_LAYER_TYPE_UNSPECIFIED = TerrainLayerType._(0, _omitEnumNames ? '' : 'TERRAIN_LAYER_TYPE_UNSPECIFIED');
  static const TerrainLayerType TERRAIN_LAYER_TYPE_DEM = TerrainLayerType._(1, _omitEnumNames ? '' : 'TERRAIN_LAYER_TYPE_DEM');
  static const TerrainLayerType TERRAIN_LAYER_TYPE_SLOPE = TerrainLayerType._(2, _omitEnumNames ? '' : 'TERRAIN_LAYER_TYPE_SLOPE');
  static const TerrainLayerType TERRAIN_LAYER_TYPE_ASPECT = TerrainLayerType._(3, _omitEnumNames ? '' : 'TERRAIN_LAYER_TYPE_ASPECT');
  static const TerrainLayerType TERRAIN_LAYER_TYPE_HILLSHADE = TerrainLayerType._(4, _omitEnumNames ? '' : 'TERRAIN_LAYER_TYPE_HILLSHADE');

  static const $core.List<TerrainLayerType> values = <TerrainLayerType> [
    TERRAIN_LAYER_TYPE_UNSPECIFIED,
    TERRAIN_LAYER_TYPE_DEM,
    TERRAIN_LAYER_TYPE_SLOPE,
    TERRAIN_LAYER_TYPE_ASPECT,
    TERRAIN_LAYER_TYPE_HILLSHADE,
  ];

  static final $core.Map<$core.int, TerrainLayerType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TerrainLayerType? valueOf($core.int value) => _byValue[value];

  const TerrainLayerType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
