//
//  Generated code. Do not modify.
//  source: asset/v1/asset.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AssetCategory extends $pb.ProtobufEnum {
  static const AssetCategory ASSET_CATEGORY_UNSPECIFIED = AssetCategory._(0, _omitEnumNames ? '' : 'ASSET_CATEGORY_UNSPECIFIED');
  static const AssetCategory ASSET_CATEGORY_SOLAR_PANEL = AssetCategory._(1, _omitEnumNames ? '' : 'ASSET_CATEGORY_SOLAR_PANEL');
  static const AssetCategory ASSET_CATEGORY_TRACKER = AssetCategory._(2, _omitEnumNames ? '' : 'ASSET_CATEGORY_TRACKER');
  static const AssetCategory ASSET_CATEGORY_STRING_INVERTER = AssetCategory._(3, _omitEnumNames ? '' : 'ASSET_CATEGORY_STRING_INVERTER');
  static const AssetCategory ASSET_CATEGORY_CENTRAL_INVERTER = AssetCategory._(4, _omitEnumNames ? '' : 'ASSET_CATEGORY_CENTRAL_INVERTER');
  static const AssetCategory ASSET_CATEGORY_TRANSFORMER = AssetCategory._(5, _omitEnumNames ? '' : 'ASSET_CATEGORY_TRANSFORMER');
  static const AssetCategory ASSET_CATEGORY_JUNCTION_BOX = AssetCategory._(6, _omitEnumNames ? '' : 'ASSET_CATEGORY_JUNCTION_BOX');
  static const AssetCategory ASSET_CATEGORY_COMBINER_BOX = AssetCategory._(7, _omitEnumNames ? '' : 'ASSET_CATEGORY_COMBINER_BOX');
  static const AssetCategory ASSET_CATEGORY_CABLE = AssetCategory._(8, _omitEnumNames ? '' : 'ASSET_CATEGORY_CABLE');
  static const AssetCategory ASSET_CATEGORY_MOUNTING_STRUCTURE = AssetCategory._(9, _omitEnumNames ? '' : 'ASSET_CATEGORY_MOUNTING_STRUCTURE');
  static const AssetCategory ASSET_CATEGORY_SUBSTATION = AssetCategory._(10, _omitEnumNames ? '' : 'ASSET_CATEGORY_SUBSTATION');

  static const $core.List<AssetCategory> values = <AssetCategory> [
    ASSET_CATEGORY_UNSPECIFIED,
    ASSET_CATEGORY_SOLAR_PANEL,
    ASSET_CATEGORY_TRACKER,
    ASSET_CATEGORY_STRING_INVERTER,
    ASSET_CATEGORY_CENTRAL_INVERTER,
    ASSET_CATEGORY_TRANSFORMER,
    ASSET_CATEGORY_JUNCTION_BOX,
    ASSET_CATEGORY_COMBINER_BOX,
    ASSET_CATEGORY_CABLE,
    ASSET_CATEGORY_MOUNTING_STRUCTURE,
    ASSET_CATEGORY_SUBSTATION,
  ];

  static final $core.Map<$core.int, AssetCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AssetCategory? valueOf($core.int value) => _byValue[value];

  const AssetCategory._(super.v, super.n);
}

/// CellTechnology captures the PV cell architecture. Drives efficiency, temp
/// coefficients, and bifacial behavior in downstream modeling.
class CellTechnology extends $pb.ProtobufEnum {
  static const CellTechnology CELL_TECHNOLOGY_UNSPECIFIED = CellTechnology._(0, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_UNSPECIFIED');
  static const CellTechnology CELL_TECHNOLOGY_MONO_PERC = CellTechnology._(1, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_MONO_PERC');
  static const CellTechnology CELL_TECHNOLOGY_POLY = CellTechnology._(2, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_POLY');
  static const CellTechnology CELL_TECHNOLOGY_TOPCON = CellTechnology._(3, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_TOPCON');
  static const CellTechnology CELL_TECHNOLOGY_HJT = CellTechnology._(4, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_HJT');
  static const CellTechnology CELL_TECHNOLOGY_IBC = CellTechnology._(5, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_IBC');
  static const CellTechnology CELL_TECHNOLOGY_THIN_FILM = CellTechnology._(6, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_THIN_FILM');
  static const CellTechnology CELL_TECHNOLOGY_PERC_PLUS = CellTechnology._(7, _omitEnumNames ? '' : 'CELL_TECHNOLOGY_PERC_PLUS');

  static const $core.List<CellTechnology> values = <CellTechnology> [
    CELL_TECHNOLOGY_UNSPECIFIED,
    CELL_TECHNOLOGY_MONO_PERC,
    CELL_TECHNOLOGY_POLY,
    CELL_TECHNOLOGY_TOPCON,
    CELL_TECHNOLOGY_HJT,
    CELL_TECHNOLOGY_IBC,
    CELL_TECHNOLOGY_THIN_FILM,
    CELL_TECHNOLOGY_PERC_PLUS,
  ];

  static final $core.Map<$core.int, CellTechnology> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CellTechnology? valueOf($core.int value) => _byValue[value];

  const CellTechnology._(super.v, super.n);
}

/// FrameType identifies module frame material/finish; affects clamp selection.
class FrameType extends $pb.ProtobufEnum {
  static const FrameType FRAME_TYPE_UNSPECIFIED = FrameType._(0, _omitEnumNames ? '' : 'FRAME_TYPE_UNSPECIFIED');
  static const FrameType FRAME_TYPE_ANODIZED_ALUMINUM = FrameType._(1, _omitEnumNames ? '' : 'FRAME_TYPE_ANODIZED_ALUMINUM');
  static const FrameType FRAME_TYPE_BLACK_ANODIZED = FrameType._(2, _omitEnumNames ? '' : 'FRAME_TYPE_BLACK_ANODIZED');
  static const FrameType FRAME_TYPE_FRAMELESS = FrameType._(3, _omitEnumNames ? '' : 'FRAME_TYPE_FRAMELESS');

  static const $core.List<FrameType> values = <FrameType> [
    FRAME_TYPE_UNSPECIFIED,
    FRAME_TYPE_ANODIZED_ALUMINUM,
    FRAME_TYPE_BLACK_ANODIZED,
    FRAME_TYPE_FRAMELESS,
  ];

  static final $core.Map<$core.int, FrameType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FrameType? valueOf($core.int value) => _byValue[value];

  const FrameType._(super.v, super.n);
}

/// InverterTopology identifies the galvanic isolation architecture. Drives
/// grounding strategy, arc-fault detection requirements, and efficiency curve
/// shape. Modern utility-scale string inverters are almost universally
/// transformer-less; legacy installations use LF transformer types.
class InverterTopology extends $pb.ProtobufEnum {
  static const InverterTopology INVERTER_TOPOLOGY_UNSPECIFIED = InverterTopology._(0, _omitEnumNames ? '' : 'INVERTER_TOPOLOGY_UNSPECIFIED');
  static const InverterTopology INVERTER_TOPOLOGY_TRANSFORMER_LESS = InverterTopology._(1, _omitEnumNames ? '' : 'INVERTER_TOPOLOGY_TRANSFORMER_LESS');
  static const InverterTopology INVERTER_TOPOLOGY_HF_TRANSFORMER = InverterTopology._(2, _omitEnumNames ? '' : 'INVERTER_TOPOLOGY_HF_TRANSFORMER');
  static const InverterTopology INVERTER_TOPOLOGY_LF_TRANSFORMER = InverterTopology._(3, _omitEnumNames ? '' : 'INVERTER_TOPOLOGY_LF_TRANSFORMER');

  static const $core.List<InverterTopology> values = <InverterTopology> [
    INVERTER_TOPOLOGY_UNSPECIFIED,
    INVERTER_TOPOLOGY_TRANSFORMER_LESS,
    INVERTER_TOPOLOGY_HF_TRANSFORMER,
    INVERTER_TOPOLOGY_LF_TRANSFORMER,
  ];

  static final $core.Map<$core.int, InverterTopology> _byValue = $pb.ProtobufEnum.initByValue(values);
  static InverterTopology? valueOf($core.int value) => _byValue[value];

  const InverterTopology._(super.v, super.n);
}

/// InverterGridType describes how the inverter interacts with the utility grid
/// and local storage. Gates which downstream features (battery dispatch,
/// anti-islanding protection) are applicable.
class InverterGridType extends $pb.ProtobufEnum {
  static const InverterGridType INVERTER_GRID_TYPE_UNSPECIFIED = InverterGridType._(0, _omitEnumNames ? '' : 'INVERTER_GRID_TYPE_UNSPECIFIED');
  static const InverterGridType INVERTER_GRID_TYPE_GRID_TIED = InverterGridType._(1, _omitEnumNames ? '' : 'INVERTER_GRID_TYPE_GRID_TIED');
  static const InverterGridType INVERTER_GRID_TYPE_HYBRID = InverterGridType._(2, _omitEnumNames ? '' : 'INVERTER_GRID_TYPE_HYBRID');
  static const InverterGridType INVERTER_GRID_TYPE_OFF_GRID = InverterGridType._(3, _omitEnumNames ? '' : 'INVERTER_GRID_TYPE_OFF_GRID');

  static const $core.List<InverterGridType> values = <InverterGridType> [
    INVERTER_GRID_TYPE_UNSPECIFIED,
    INVERTER_GRID_TYPE_GRID_TIED,
    INVERTER_GRID_TYPE_HYBRID,
    INVERTER_GRID_TYPE_OFF_GRID,
  ];

  static final $core.Map<$core.int, InverterGridType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static InverterGridType? valueOf($core.int value) => _byValue[value];

  const InverterGridType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
