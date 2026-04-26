//
//  Generated code. Do not modify.
//  source: asset/v1/asset_identity.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// DesignAssetType identifies the class of design artifact that an AssetIdentity
/// record links to a physical installation instance.
class DesignAssetType extends $pb.ProtobufEnum {
  static const DesignAssetType DESIGN_ASSET_TYPE_UNSPECIFIED = DesignAssetType._(0, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_UNSPECIFIED');
  /// DESIGN_ASSET_TYPE_SOLAR_PANEL: Individual PV module (from layout service tile/panel record).
  static const DesignAssetType DESIGN_ASSET_TYPE_SOLAR_PANEL = DesignAssetType._(1, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_SOLAR_PANEL');
  /// DESIGN_ASSET_TYPE_INVERTER: String or central inverter (from electrical network inverter group).
  static const DesignAssetType DESIGN_ASSET_TYPE_INVERTER = DesignAssetType._(2, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_INVERTER');
  /// DESIGN_ASSET_TYPE_STRING: Panel string (from electrical network string record).
  static const DesignAssetType DESIGN_ASSET_TYPE_STRING = DesignAssetType._(3, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_STRING');
  /// DESIGN_ASSET_TYPE_TRANSFORMER: MV/LV transformer (from electrical network or layout zone).
  static const DesignAssetType DESIGN_ASSET_TYPE_TRANSFORMER = DesignAssetType._(4, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_TRANSFORMER');
  /// DESIGN_ASSET_TYPE_CABLE_RUN: DC or AC cable run (from electrical BOM or transmission route).
  static const DesignAssetType DESIGN_ASSET_TYPE_CABLE_RUN = DesignAssetType._(5, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_CABLE_RUN');
  /// DESIGN_ASSET_TYPE_COMBINER_BOX: DC combiner or junction box.
  static const DesignAssetType DESIGN_ASSET_TYPE_COMBINER_BOX = DesignAssetType._(6, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_COMBINER_BOX');
  /// DESIGN_ASSET_TYPE_PROTECTION_RELAY: IEC 60255 protection relay (from protection study).
  static const DesignAssetType DESIGN_ASSET_TYPE_PROTECTION_RELAY = DesignAssetType._(7, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_PROTECTION_RELAY');
  /// DESIGN_ASSET_TYPE_TRANSMISSION_TOWER: Overhead line tower (from transmission route tower position).
  static const DesignAssetType DESIGN_ASSET_TYPE_TRANSMISSION_TOWER = DesignAssetType._(8, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_TRANSMISSION_TOWER');
  /// DESIGN_ASSET_TYPE_OTHER: Any asset class not covered by the above types.
  static const DesignAssetType DESIGN_ASSET_TYPE_OTHER = DesignAssetType._(9, _omitEnumNames ? '' : 'DESIGN_ASSET_TYPE_OTHER');

  static const $core.List<DesignAssetType> values = <DesignAssetType> [
    DESIGN_ASSET_TYPE_UNSPECIFIED,
    DESIGN_ASSET_TYPE_SOLAR_PANEL,
    DESIGN_ASSET_TYPE_INVERTER,
    DESIGN_ASSET_TYPE_STRING,
    DESIGN_ASSET_TYPE_TRANSFORMER,
    DESIGN_ASSET_TYPE_CABLE_RUN,
    DESIGN_ASSET_TYPE_COMBINER_BOX,
    DESIGN_ASSET_TYPE_PROTECTION_RELAY,
    DESIGN_ASSET_TYPE_TRANSMISSION_TOWER,
    DESIGN_ASSET_TYPE_OTHER,
  ];

  static final $core.Map<$core.int, DesignAssetType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DesignAssetType? valueOf($core.int value) => _byValue[value];

  const DesignAssetType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
