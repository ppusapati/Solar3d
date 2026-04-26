//
//  Generated code. Do not modify.
//  source: twin/v1/digital_twin.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TwinStatus extends $pb.ProtobufEnum {
  static const TwinStatus TWIN_STATUS_UNSPECIFIED = TwinStatus._(0, _omitEnumNames ? '' : 'TWIN_STATUS_UNSPECIFIED');
  /// TWIN_STATUS_PROVISIONING: Twin record created; asset identity linking in progress.
  static const TwinStatus TWIN_STATUS_PROVISIONING = TwinStatus._(1, _omitEnumNames ? '' : 'TWIN_STATUS_PROVISIONING');
  /// TWIN_STATUS_ACTIVE: Twin fully provisioned and accepting telemetry.
  static const TwinStatus TWIN_STATUS_ACTIVE = TwinStatus._(2, _omitEnumNames ? '' : 'TWIN_STATUS_ACTIVE');
  /// TWIN_STATUS_SUSPENDED: Temporarily offline; telemetry accepted but not processed.
  static const TwinStatus TWIN_STATUS_SUSPENDED = TwinStatus._(3, _omitEnumNames ? '' : 'TWIN_STATUS_SUSPENDED');
  /// TWIN_STATUS_DECOMMISSIONED: Final immutable terminal state; no further updates accepted.
  static const TwinStatus TWIN_STATUS_DECOMMISSIONED = TwinStatus._(4, _omitEnumNames ? '' : 'TWIN_STATUS_DECOMMISSIONED');

  static const $core.List<TwinStatus> values = <TwinStatus> [
    TWIN_STATUS_UNSPECIFIED,
    TWIN_STATUS_PROVISIONING,
    TWIN_STATUS_ACTIVE,
    TWIN_STATUS_SUSPENDED,
    TWIN_STATUS_DECOMMISSIONED,
  ];

  static final $core.Map<$core.int, TwinStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TwinStatus? valueOf($core.int value) => _byValue[value];

  const TwinStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
