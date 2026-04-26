//
//  Generated code. Do not modify.
//  source: layout/v1/layout.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// ========== Acceptance Status Enum ==========
/// AcceptanceStatus is the workflow gate state for a layout artefact.
/// Determines whether this layout satisfies the LayoutReady gate for phase progression.
class AcceptanceStatus extends $pb.ProtobufEnum {
  /// ACCEPTANCE_STATUS_UNSPECIFIED is the default zero value; treat as DRAFT.
  static const AcceptanceStatus ACCEPTANCE_STATUS_UNSPECIFIED = AcceptanceStatus._(0, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_UNSPECIFIED');
  /// ACCEPTANCE_STATUS_DRAFT indicates no review has been requested yet.
  static const AcceptanceStatus ACCEPTANCE_STATUS_DRAFT = AcceptanceStatus._(1, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_DRAFT');
  /// ACCEPTANCE_STATUS_REVIEW_PENDING indicates a review has been submitted and is awaiting decision.
  static const AcceptanceStatus ACCEPTANCE_STATUS_REVIEW_PENDING = AcceptanceStatus._(2, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_REVIEW_PENDING');
  /// ACCEPTANCE_STATUS_APPROVED indicates the layout passed acceptance and may proceed.
  static const AcceptanceStatus ACCEPTANCE_STATUS_APPROVED = AcceptanceStatus._(3, _omitEnumNames ? '' : 'ACCEPTANCE_STATUS_APPROVED');
  /// ACCEPTANCE_STATUS_REJECTED indicates the layout failed acceptance; blockers must be resolved.
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

class ComponentType extends $pb.ProtobufEnum {
  static const ComponentType COMPONENT_TYPE_UNSPECIFIED = ComponentType._(0, _omitEnumNames ? '' : 'COMPONENT_TYPE_UNSPECIFIED');
  static const ComponentType COMPONENT_TYPE_PANEL = ComponentType._(1, _omitEnumNames ? '' : 'COMPONENT_TYPE_PANEL');
  static const ComponentType COMPONENT_TYPE_INVERTER = ComponentType._(2, _omitEnumNames ? '' : 'COMPONENT_TYPE_INVERTER');
  static const ComponentType COMPONENT_TYPE_TRANSFORMER = ComponentType._(3, _omitEnumNames ? '' : 'COMPONENT_TYPE_TRANSFORMER');
  static const ComponentType COMPONENT_TYPE_JUNCTION_BOX = ComponentType._(4, _omitEnumNames ? '' : 'COMPONENT_TYPE_JUNCTION_BOX');
  static const ComponentType COMPONENT_TYPE_SUBSTATION = ComponentType._(5, _omitEnumNames ? '' : 'COMPONENT_TYPE_SUBSTATION');
  static const ComponentType COMPONENT_TYPE_TRACKER = ComponentType._(6, _omitEnumNames ? '' : 'COMPONENT_TYPE_TRACKER');
  static const ComponentType COMPONENT_TYPE_COMBINER_BOX = ComponentType._(7, _omitEnumNames ? '' : 'COMPONENT_TYPE_COMBINER_BOX');

  static const $core.List<ComponentType> values = <ComponentType> [
    COMPONENT_TYPE_UNSPECIFIED,
    COMPONENT_TYPE_PANEL,
    COMPONENT_TYPE_INVERTER,
    COMPONENT_TYPE_TRANSFORMER,
    COMPONENT_TYPE_JUNCTION_BOX,
    COMPONENT_TYPE_SUBSTATION,
    COMPONENT_TYPE_TRACKER,
    COMPONENT_TYPE_COMBINER_BOX,
  ];

  static final $core.Map<$core.int, ComponentType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ComponentType? valueOf($core.int value) => _byValue[value];

  const ComponentType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
