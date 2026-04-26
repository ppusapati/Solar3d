//
//  Generated code. Do not modify.
//  source: drawing/v1/drawing.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DrawingEntityType extends $pb.ProtobufEnum {
  static const DrawingEntityType DRAWING_ENTITY_TYPE_UNSPECIFIED = DrawingEntityType._(0, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_UNSPECIFIED');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_POLYLINE = DrawingEntityType._(1, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_POLYLINE');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_POLYGON = DrawingEntityType._(2, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_POLYGON');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_TEXT = DrawingEntityType._(3, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_TEXT');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_DIMENSION = DrawingEntityType._(4, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_DIMENSION');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_BLOCK_REFERENCE = DrawingEntityType._(5, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_BLOCK_REFERENCE');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_LAYER_DEFINITION = DrawingEntityType._(6, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_LAYER_DEFINITION');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_BLOCK_DEFINITION = DrawingEntityType._(7, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_BLOCK_DEFINITION');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_LEADER = DrawingEntityType._(8, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_LEADER');
  static const DrawingEntityType DRAWING_ENTITY_TYPE_SHEET = DrawingEntityType._(9, _omitEnumNames ? '' : 'DRAWING_ENTITY_TYPE_SHEET');

  static const $core.List<DrawingEntityType> values = <DrawingEntityType> [
    DRAWING_ENTITY_TYPE_UNSPECIFIED,
    DRAWING_ENTITY_TYPE_POLYLINE,
    DRAWING_ENTITY_TYPE_POLYGON,
    DRAWING_ENTITY_TYPE_TEXT,
    DRAWING_ENTITY_TYPE_DIMENSION,
    DRAWING_ENTITY_TYPE_BLOCK_REFERENCE,
    DRAWING_ENTITY_TYPE_LAYER_DEFINITION,
    DRAWING_ENTITY_TYPE_BLOCK_DEFINITION,
    DRAWING_ENTITY_TYPE_LEADER,
    DRAWING_ENTITY_TYPE_SHEET,
  ];

  static final $core.Map<$core.int, DrawingEntityType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DrawingEntityType? valueOf($core.int value) => _byValue[value];

  const DrawingEntityType._(super.v, super.n);
}

class RevisionAction extends $pb.ProtobufEnum {
  static const RevisionAction REVISION_ACTION_UNSPECIFIED = RevisionAction._(0, _omitEnumNames ? '' : 'REVISION_ACTION_UNSPECIFIED');
  static const RevisionAction REVISION_ACTION_CREATE = RevisionAction._(1, _omitEnumNames ? '' : 'REVISION_ACTION_CREATE');
  static const RevisionAction REVISION_ACTION_UPDATE = RevisionAction._(2, _omitEnumNames ? '' : 'REVISION_ACTION_UPDATE');
  static const RevisionAction REVISION_ACTION_DELETE = RevisionAction._(3, _omitEnumNames ? '' : 'REVISION_ACTION_DELETE');

  static const $core.List<RevisionAction> values = <RevisionAction> [
    REVISION_ACTION_UNSPECIFIED,
    REVISION_ACTION_CREATE,
    REVISION_ACTION_UPDATE,
    REVISION_ACTION_DELETE,
  ];

  static final $core.Map<$core.int, RevisionAction> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RevisionAction? valueOf($core.int value) => _byValue[value];

  const RevisionAction._(super.v, super.n);
}

class DrawingStatus extends $pb.ProtobufEnum {
  static const DrawingStatus DRAWING_STATUS_UNSPECIFIED = DrawingStatus._(0, _omitEnumNames ? '' : 'DRAWING_STATUS_UNSPECIFIED');
  static const DrawingStatus DRAWING_STATUS_ACTIVE = DrawingStatus._(1, _omitEnumNames ? '' : 'DRAWING_STATUS_ACTIVE');
  static const DrawingStatus DRAWING_STATUS_ARCHIVED = DrawingStatus._(2, _omitEnumNames ? '' : 'DRAWING_STATUS_ARCHIVED');

  static const $core.List<DrawingStatus> values = <DrawingStatus> [
    DRAWING_STATUS_UNSPECIFIED,
    DRAWING_STATUS_ACTIVE,
    DRAWING_STATUS_ARCHIVED,
  ];

  static final $core.Map<$core.int, DrawingStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DrawingStatus? valueOf($core.int value) => _byValue[value];

  const DrawingStatus._(super.v, super.n);
}

class FileFormat extends $pb.ProtobufEnum {
  static const FileFormat FILE_FORMAT_UNSPECIFIED = FileFormat._(0, _omitEnumNames ? '' : 'FILE_FORMAT_UNSPECIFIED');
  static const FileFormat FILE_FORMAT_SOLAR3D_JSON = FileFormat._(1, _omitEnumNames ? '' : 'FILE_FORMAT_SOLAR3D_JSON');
  static const FileFormat FILE_FORMAT_DXF_ASCII = FileFormat._(2, _omitEnumNames ? '' : 'FILE_FORMAT_DXF_ASCII');

  static const $core.List<FileFormat> values = <FileFormat> [
    FILE_FORMAT_UNSPECIFIED,
    FILE_FORMAT_SOLAR3D_JSON,
    FILE_FORMAT_DXF_ASCII,
  ];

  static final $core.Map<$core.int, FileFormat> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FileFormat? valueOf($core.int value) => _byValue[value];

  const FileFormat._(super.v, super.n);
}

class InteropMergeStrategy extends $pb.ProtobufEnum {
  static const InteropMergeStrategy INTEROP_MERGE_STRATEGY_UNSPECIFIED = InteropMergeStrategy._(0, _omitEnumNames ? '' : 'INTEROP_MERGE_STRATEGY_UNSPECIFIED');
  static const InteropMergeStrategy INTEROP_MERGE_STRATEGY_REPLACE = InteropMergeStrategy._(1, _omitEnumNames ? '' : 'INTEROP_MERGE_STRATEGY_REPLACE');
  static const InteropMergeStrategy INTEROP_MERGE_STRATEGY_APPEND = InteropMergeStrategy._(2, _omitEnumNames ? '' : 'INTEROP_MERGE_STRATEGY_APPEND');
  static const InteropMergeStrategy INTEROP_MERGE_STRATEGY_UPSERT = InteropMergeStrategy._(3, _omitEnumNames ? '' : 'INTEROP_MERGE_STRATEGY_UPSERT');

  static const $core.List<InteropMergeStrategy> values = <InteropMergeStrategy> [
    INTEROP_MERGE_STRATEGY_UNSPECIFIED,
    INTEROP_MERGE_STRATEGY_REPLACE,
    INTEROP_MERGE_STRATEGY_APPEND,
    INTEROP_MERGE_STRATEGY_UPSERT,
  ];

  static final $core.Map<$core.int, InteropMergeStrategy> _byValue = $pb.ProtobufEnum.initByValue(values);
  static InteropMergeStrategy? valueOf($core.int value) => _byValue[value];

  const InteropMergeStrategy._(super.v, super.n);
}

class PlotOutputFormat extends $pb.ProtobufEnum {
  static const PlotOutputFormat PLOT_OUTPUT_FORMAT_UNSPECIFIED = PlotOutputFormat._(0, _omitEnumNames ? '' : 'PLOT_OUTPUT_FORMAT_UNSPECIFIED');
  static const PlotOutputFormat PLOT_OUTPUT_FORMAT_SVG = PlotOutputFormat._(1, _omitEnumNames ? '' : 'PLOT_OUTPUT_FORMAT_SVG');
  static const PlotOutputFormat PLOT_OUTPUT_FORMAT_PDF = PlotOutputFormat._(2, _omitEnumNames ? '' : 'PLOT_OUTPUT_FORMAT_PDF');

  static const $core.List<PlotOutputFormat> values = <PlotOutputFormat> [
    PLOT_OUTPUT_FORMAT_UNSPECIFIED,
    PLOT_OUTPUT_FORMAT_SVG,
    PLOT_OUTPUT_FORMAT_PDF,
  ];

  static final $core.Map<$core.int, PlotOutputFormat> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PlotOutputFormat? valueOf($core.int value) => _byValue[value];

  const PlotOutputFormat._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
