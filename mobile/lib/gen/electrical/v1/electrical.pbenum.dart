//
//  Generated code. Do not modify.
//  source: electrical/v1/electrical.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// ========== Acceptance Status Enum ==========
/// AcceptanceStatus is the workflow gate state for an electrical network artefact.
/// Determines whether this network satisfies the ElectricalReady gate for phase progression.
class AcceptanceStatus extends $pb.ProtobufEnum {
  /// ACCEPTANCE_STATUS_UNSPECIFIED is the default zero value; treat as DRAFT.
  static const AcceptanceStatus ACCEPTANCE_STATUS_UNSPECIFIED = AcceptanceStatus._(0, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_UNSPECIFIED');
  /// ACCEPTANCE_STATUS_DRAFT indicates no review has been requested yet.
  static const AcceptanceStatus ACCEPTANCE_STATUS_DRAFT = AcceptanceStatus._(1, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_DRAFT');
  /// ACCEPTANCE_STATUS_REVIEW_PENDING indicates a review has been submitted and is awaiting decision.
  static const AcceptanceStatus ACCEPTANCE_STATUS_REVIEW_PENDING = AcceptanceStatus._(2, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_REVIEW_PENDING');
  /// ACCEPTANCE_STATUS_APPROVED indicates the network passed acceptance and may proceed.
  static const AcceptanceStatus ACCEPTANCE_STATUS_APPROVED = AcceptanceStatus._(3, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_APPROVED');
  /// ACCEPTANCE_STATUS_REJECTED indicates the network failed acceptance; blockers must be resolved.
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


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
