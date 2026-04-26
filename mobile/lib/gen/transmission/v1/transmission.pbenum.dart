//
//  Generated code. Do not modify.
//  source: transmission/v1/transmission.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// ========== Acceptance Status Enum ==========
/// AcceptanceStatus is the workflow gate acceptance state — distinct from ApprovalStatus
/// (which tracks the governance review stage). AcceptanceStatus determines whether this
/// artefact satisfies its predecessor gate for phase progression.
class AcceptanceStatus extends $pb.ProtobufEnum {
  static const AcceptanceStatus ACCEPTANCE_STATUS_UNSPECIFIED = AcceptanceStatus._(0, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_UNSPECIFIED');
  static const AcceptanceStatus ACCEPTANCE_STATUS_DRAFT = AcceptanceStatus._(1, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_DRAFT');
  static const AcceptanceStatus ACCEPTANCE_STATUS_REVIEW_PENDING = AcceptanceStatus._(2, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_REVIEW_PENDING');
  static const AcceptanceStatus ACCEPTANCE_STATUS_APPROVED = AcceptanceStatus._(3, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_APPROVED');
  static const AcceptanceStatus ACCEPTANCE_STATUS_REJECTED = AcceptanceStatus._(4, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_REJECTED');

  static const $core.List<AcceptanceStatus> values = <AcceptanceStatus> [
    ACCEPTANCE_STATUS_UNSPECIFIED,
    ACCEPTANCE_STATUS_DRAFT,
    ACCEPTANCE_STATUS_REVIEW_PENDING,
    ACCEPTANCE_STATUS_APPROVED,
    ACCEPTANCE_STATUS_REJECTED,
  ];

  static final $core.Map<$core.int, AcceptanceStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AcceptanceStatus? valueOf($core.int value) => _byValue[value];

  const AcceptanceStatus._(super.v, super.n);
}

class VoltageClass extends $pb.ProtobufEnum {
  static const VoltageClass VOLTAGE_CLASS_UNSPECIFIED = VoltageClass._(0, _omitEnumNames ? '' : 'VOLTAGE_CLASS_UNSPECIFIED');
  static const VoltageClass VOLTAGE_CLASS_11KV = VoltageClass._(1, _omitEnumNames ? '' : 'VOLTAGE_CLASS_11KV');
  static const VoltageClass VOLTAGE_CLASS_33KV = VoltageClass._(2, _omitEnumNames ? '' : 'VOLTAGE_CLASS_33KV');
  static const VoltageClass VOLTAGE_CLASS_HT_66KV = VoltageClass._(3, _omitEnumNames ? '' : 'VOLTAGE_CLASS_HT_66KV');
  static const VoltageClass VOLTAGE_CLASS_HT_132KV = VoltageClass._(4, _omitEnumNames ? '' : 'VOLTAGE_CLASS_HT_132KV');
  static const VoltageClass VOLTAGE_CLASS_HT_220KV = VoltageClass._(5, _omitEnumNames ? '' : 'VOLTAGE_CLASS_HT_220KV');
  static const VoltageClass VOLTAGE_CLASS_HT_400KV = VoltageClass._(6, _omitEnumNames ? '' : 'VOLTAGE_CLASS_HT_400KV');

  static const $core.List<VoltageClass> values = <VoltageClass> [
    VOLTAGE_CLASS_UNSPECIFIED,
    VOLTAGE_CLASS_11KV,
    VOLTAGE_CLASS_33KV,
    VOLTAGE_CLASS_HT_66KV,
    VOLTAGE_CLASS_HT_132KV,
    VOLTAGE_CLASS_HT_220KV,
    VOLTAGE_CLASS_HT_400KV,
  ];

  static final $core.Map<$core.int, VoltageClass> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VoltageClass? valueOf($core.int value) => _byValue[value];

  const VoltageClass._(super.v, super.n);
}

class ApprovalStatus extends $pb.ProtobufEnum {
  static const ApprovalStatus APPROVAL_STATUS_UNSPECIFIED = ApprovalStatus._(0, _omitEnumNames ? '' : 'APPROVAL_STATUS_UNSPECIFIED');
  static const ApprovalStatus APPROVAL_STATUS_DRAFT = ApprovalStatus._(1, _omitEnumNames ? '' : 'APPROVAL_STATUS_DRAFT');
  static const ApprovalStatus APPROVAL_STATUS_ENGINEERING_REVIEW = ApprovalStatus._(2, _omitEnumNames ? '' : 'APPROVAL_STATUS_ENGINEERING_REVIEW');
  static const ApprovalStatus APPROVAL_STATUS_APPROVED = ApprovalStatus._(3, _omitEnumNames ? '' : 'APPROVAL_STATUS_APPROVED');
  static const ApprovalStatus APPROVAL_STATUS_REJECTED = ApprovalStatus._(4, _omitEnumNames ? '' : 'APPROVAL_STATUS_REJECTED');

  static const $core.List<ApprovalStatus> values = <ApprovalStatus> [
    APPROVAL_STATUS_UNSPECIFIED,
    APPROVAL_STATUS_DRAFT,
    APPROVAL_STATUS_ENGINEERING_REVIEW,
    APPROVAL_STATUS_APPROVED,
    APPROVAL_STATUS_REJECTED,
  ];

  static final $core.Map<$core.int, ApprovalStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ApprovalStatus? valueOf($core.int value) => _byValue[value];

  const ApprovalStatus._(super.v, super.n);
}

class InstallationMode extends $pb.ProtobufEnum {
  static const InstallationMode INSTALLATION_MODE_UNSPECIFIED = InstallationMode._(0, _omitEnumNames ? '' : 'INSTALLATION_MODE_UNSPECIFIED');
  static const InstallationMode INSTALLATION_MODE_OVERHEAD = InstallationMode._(1, _omitEnumNames ? '' : 'INSTALLATION_MODE_OVERHEAD');
  static const InstallationMode INSTALLATION_MODE_UNDERGROUND = InstallationMode._(2, _omitEnumNames ? '' : 'INSTALLATION_MODE_UNDERGROUND');

  static const $core.List<InstallationMode> values = <InstallationMode> [
    INSTALLATION_MODE_UNSPECIFIED,
    INSTALLATION_MODE_OVERHEAD,
    INSTALLATION_MODE_UNDERGROUND,
  ];

  static final $core.Map<$core.int, InstallationMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static InstallationMode? valueOf($core.int value) => _byValue[value];

  const InstallationMode._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
