//
//  Generated code. Do not modify.
//  source: constraint/v1/constraint_zones.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ZoneType extends $pb.ProtobufEnum {
  static const ZoneType ZONE_TYPE_UNSPECIFIED = ZoneType._(0, _omitEnumNames ? '' : 'ZONE_TYPE_UNSPECIFIED');
  static const ZoneType ZONE_TYPE_EXCLUSION = ZoneType._(1, _omitEnumNames ? '' : 'ZONE_TYPE_EXCLUSION');
  static const ZoneType ZONE_TYPE_INCLUSION = ZoneType._(2, _omitEnumNames ? '' : 'ZONE_TYPE_INCLUSION');
  static const ZoneType ZONE_TYPE_BUFFER = ZoneType._(3, _omitEnumNames ? '' : 'ZONE_TYPE_BUFFER');

  static const $core.List<ZoneType> values = <ZoneType> [
    ZONE_TYPE_UNSPECIFIED,
    ZONE_TYPE_EXCLUSION,
    ZONE_TYPE_INCLUSION,
    ZONE_TYPE_BUFFER,
  ];

  static final $core.Map<$core.int, ZoneType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ZoneType? valueOf($core.int value) => _byValue[value];

  const ZoneType._(super.v, super.n);
}

class ZoneCategory extends $pb.ProtobufEnum {
  static const ZoneCategory ZONE_CATEGORY_UNSPECIFIED = ZoneCategory._(0, _omitEnumNames ? '' : 'ZONE_CATEGORY_UNSPECIFIED');
  static const ZoneCategory ZONE_CATEGORY_GEOLOGICAL = ZoneCategory._(1, _omitEnumNames ? '' : 'ZONE_CATEGORY_GEOLOGICAL');
  static const ZoneCategory ZONE_CATEGORY_ENVIRONMENTAL = ZoneCategory._(2, _omitEnumNames ? '' : 'ZONE_CATEGORY_ENVIRONMENTAL');
  static const ZoneCategory ZONE_CATEGORY_REGULATORY = ZoneCategory._(3, _omitEnumNames ? '' : 'ZONE_CATEGORY_REGULATORY');
  static const ZoneCategory ZONE_CATEGORY_INFRASTRUCTURE = ZoneCategory._(4, _omitEnumNames ? '' : 'ZONE_CATEGORY_INFRASTRUCTURE');
  static const ZoneCategory ZONE_CATEGORY_MILITARY = ZoneCategory._(5, _omitEnumNames ? '' : 'ZONE_CATEGORY_MILITARY');
  static const ZoneCategory ZONE_CATEGORY_PROTECTED = ZoneCategory._(6, _omitEnumNames ? '' : 'ZONE_CATEGORY_PROTECTED');

  static const $core.List<ZoneCategory> values = <ZoneCategory> [
    ZONE_CATEGORY_UNSPECIFIED,
    ZONE_CATEGORY_GEOLOGICAL,
    ZONE_CATEGORY_ENVIRONMENTAL,
    ZONE_CATEGORY_REGULATORY,
    ZONE_CATEGORY_INFRASTRUCTURE,
    ZONE_CATEGORY_MILITARY,
    ZONE_CATEGORY_PROTECTED,
  ];

  static final $core.Map<$core.int, ZoneCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ZoneCategory? valueOf($core.int value) => _byValue[value];

  const ZoneCategory._(super.v, super.n);
}

class ConflictSeverity extends $pb.ProtobufEnum {
  static const ConflictSeverity CONFLICT_SEVERITY_UNSPECIFIED = ConflictSeverity._(0, _omitEnumNames ? '' : 'CONFLICT_SEVERITY_UNSPECIFIED');
  static const ConflictSeverity CONFLICT_SEVERITY_INFO = ConflictSeverity._(1, _omitEnumNames ? '' : 'CONFLICT_SEVERITY_INFO');
  static const ConflictSeverity CONFLICT_SEVERITY_WARNING = ConflictSeverity._(2, _omitEnumNames ? '' : 'CONFLICT_SEVERITY_WARNING');
  static const ConflictSeverity CONFLICT_SEVERITY_ERROR = ConflictSeverity._(3, _omitEnumNames ? '' : 'CONFLICT_SEVERITY_ERROR');
  static const ConflictSeverity CONFLICT_SEVERITY_BLOCKER = ConflictSeverity._(4, _omitEnumNames ? '' : 'CONFLICT_SEVERITY_BLOCKER');

  static const $core.List<ConflictSeverity> values = <ConflictSeverity> [
    CONFLICT_SEVERITY_UNSPECIFIED,
    CONFLICT_SEVERITY_INFO,
    CONFLICT_SEVERITY_WARNING,
    CONFLICT_SEVERITY_ERROR,
    CONFLICT_SEVERITY_BLOCKER,
  ];

  static final $core.Map<$core.int, ConflictSeverity> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConflictSeverity? valueOf($core.int value) => _byValue[value];

  const ConflictSeverity._(super.v, super.n);
}

class ZoneStatus extends $pb.ProtobufEnum {
  static const ZoneStatus ZONE_STATUS_UNSPECIFIED = ZoneStatus._(0, _omitEnumNames ? '' : 'ZONE_STATUS_UNSPECIFIED');
  static const ZoneStatus ZONE_STATUS_ACTIVE = ZoneStatus._(1, _omitEnumNames ? '' : 'ZONE_STATUS_ACTIVE');
  static const ZoneStatus ZONE_STATUS_INACTIVE = ZoneStatus._(2, _omitEnumNames ? '' : 'ZONE_STATUS_INACTIVE');
  static const ZoneStatus ZONE_STATUS_EXPIRED = ZoneStatus._(3, _omitEnumNames ? '' : 'ZONE_STATUS_EXPIRED');
  static const ZoneStatus ZONE_STATUS_PENDING = ZoneStatus._(4, _omitEnumNames ? '' : 'ZONE_STATUS_PENDING');

  static const $core.List<ZoneStatus> values = <ZoneStatus> [
    ZONE_STATUS_UNSPECIFIED,
    ZONE_STATUS_ACTIVE,
    ZONE_STATUS_INACTIVE,
    ZONE_STATUS_EXPIRED,
    ZONE_STATUS_PENDING,
  ];

  static final $core.Map<$core.int, ZoneStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ZoneStatus? valueOf($core.int value) => _byValue[value];

  const ZoneStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
