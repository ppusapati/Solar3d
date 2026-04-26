//
//  Generated code. Do not modify.
//  source: commissioning/v1/commissioning.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CommissioningStatus extends $pb.ProtobufEnum {
  static const CommissioningStatus COMMISSIONING_STATUS_UNSPECIFIED = CommissioningStatus._(0, _omitEnumNames ? '' : 'COMMISSIONING_STATUS_UNSPECIFIED');
  static const CommissioningStatus COMMISSIONING_STATUS_PENDING = CommissioningStatus._(1, _omitEnumNames ? '' : 'COMMISSIONING_STATUS_PENDING');
  static const CommissioningStatus COMMISSIONING_STATUS_IN_PROGRESS = CommissioningStatus._(2, _omitEnumNames ? '' : 'COMMISSIONING_STATUS_IN_PROGRESS');
  static const CommissioningStatus COMMISSIONING_STATUS_COMPLETED = CommissioningStatus._(3, _omitEnumNames ? '' : 'COMMISSIONING_STATUS_COMPLETED');
  static const CommissioningStatus COMMISSIONING_STATUS_SIGNED_OFF = CommissioningStatus._(4, _omitEnumNames ? '' : 'COMMISSIONING_STATUS_SIGNED_OFF');
  static const CommissioningStatus COMMISSIONING_STATUS_HANDED_OVER = CommissioningStatus._(5, _omitEnumNames ? '' : 'COMMISSIONING_STATUS_HANDED_OVER');

  static const $core.List<CommissioningStatus> values = <CommissioningStatus> [
    COMMISSIONING_STATUS_UNSPECIFIED,
    COMMISSIONING_STATUS_PENDING,
    COMMISSIONING_STATUS_IN_PROGRESS,
    COMMISSIONING_STATUS_COMPLETED,
    COMMISSIONING_STATUS_SIGNED_OFF,
    COMMISSIONING_STATUS_HANDED_OVER,
  ];

  static final $core.Map<$core.int, CommissioningStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CommissioningStatus? valueOf($core.int value) => _byValue[value];

  const CommissioningStatus._(super.v, super.n);
}

class ChecklistItemStatus extends $pb.ProtobufEnum {
  static const ChecklistItemStatus CHECKLIST_ITEM_STATUS_UNSPECIFIED = ChecklistItemStatus._(0, _omitEnumNames ? '' : 'CHECKLIST_ITEM_STATUS_UNSPECIFIED');
  static const ChecklistItemStatus CHECKLIST_ITEM_STATUS_PENDING = ChecklistItemStatus._(1, _omitEnumNames ? '' : 'CHECKLIST_ITEM_STATUS_PENDING');
  static const ChecklistItemStatus CHECKLIST_ITEM_STATUS_PASS = ChecklistItemStatus._(2, _omitEnumNames ? '' : 'CHECKLIST_ITEM_STATUS_PASS');
  static const ChecklistItemStatus CHECKLIST_ITEM_STATUS_FAIL = ChecklistItemStatus._(3, _omitEnumNames ? '' : 'CHECKLIST_ITEM_STATUS_FAIL');
  static const ChecklistItemStatus CHECKLIST_ITEM_STATUS_NOT_APPLICABLE = ChecklistItemStatus._(4, _omitEnumNames ? '' : 'CHECKLIST_ITEM_STATUS_NOT_APPLICABLE');

  static const $core.List<ChecklistItemStatus> values = <ChecklistItemStatus> [
    CHECKLIST_ITEM_STATUS_UNSPECIFIED,
    CHECKLIST_ITEM_STATUS_PENDING,
    CHECKLIST_ITEM_STATUS_PASS,
    CHECKLIST_ITEM_STATUS_FAIL,
    CHECKLIST_ITEM_STATUS_NOT_APPLICABLE,
  ];

  static final $core.Map<$core.int, ChecklistItemStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ChecklistItemStatus? valueOf($core.int value) => _byValue[value];

  const ChecklistItemStatus._(super.v, super.n);
}

class ChecklistSection extends $pb.ProtobufEnum {
  static const ChecklistSection CHECKLIST_SECTION_UNSPECIFIED = ChecklistSection._(0, _omitEnumNames ? '' : 'CHECKLIST_SECTION_UNSPECIFIED');
  static const ChecklistSection CHECKLIST_SECTION_CIVIL = ChecklistSection._(1, _omitEnumNames ? '' : 'CHECKLIST_SECTION_CIVIL');
  static const ChecklistSection CHECKLIST_SECTION_MECHANICAL = ChecklistSection._(2, _omitEnumNames ? '' : 'CHECKLIST_SECTION_MECHANICAL');
  static const ChecklistSection CHECKLIST_SECTION_ELECTRICAL = ChecklistSection._(3, _omitEnumNames ? '' : 'CHECKLIST_SECTION_ELECTRICAL');
  static const ChecklistSection CHECKLIST_SECTION_PROTECTION = ChecklistSection._(4, _omitEnumNames ? '' : 'CHECKLIST_SECTION_PROTECTION');
  static const ChecklistSection CHECKLIST_SECTION_SCADA = ChecklistSection._(5, _omitEnumNames ? '' : 'CHECKLIST_SECTION_SCADA');
  static const ChecklistSection CHECKLIST_SECTION_SAFETY = ChecklistSection._(6, _omitEnumNames ? '' : 'CHECKLIST_SECTION_SAFETY');
  static const ChecklistSection CHECKLIST_SECTION_DOCUMENTATION = ChecklistSection._(7, _omitEnumNames ? '' : 'CHECKLIST_SECTION_DOCUMENTATION');

  static const $core.List<ChecklistSection> values = <ChecklistSection> [
    CHECKLIST_SECTION_UNSPECIFIED,
    CHECKLIST_SECTION_CIVIL,
    CHECKLIST_SECTION_MECHANICAL,
    CHECKLIST_SECTION_ELECTRICAL,
    CHECKLIST_SECTION_PROTECTION,
    CHECKLIST_SECTION_SCADA,
    CHECKLIST_SECTION_SAFETY,
    CHECKLIST_SECTION_DOCUMENTATION,
  ];

  static final $core.Map<$core.int, ChecklistSection> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ChecklistSection? valueOf($core.int value) => _byValue[value];

  const ChecklistSection._(super.v, super.n);
}

class AsBuiltArtifactType extends $pb.ProtobufEnum {
  static const AsBuiltArtifactType AS_BUILT_ARTIFACT_TYPE_UNSPECIFIED = AsBuiltArtifactType._(0, _omitEnumNames ? '' : 'AS_BUILT_ARTIFACT_TYPE_UNSPECIFIED');
  static const AsBuiltArtifactType AS_BUILT_ARTIFACT_TYPE_DRAWING = AsBuiltArtifactType._(1, _omitEnumNames ? '' : 'AS_BUILT_ARTIFACT_TYPE_DRAWING');
  static const AsBuiltArtifactType AS_BUILT_ARTIFACT_TYPE_REPORT = AsBuiltArtifactType._(2, _omitEnumNames ? '' : 'AS_BUILT_ARTIFACT_TYPE_REPORT');
  static const AsBuiltArtifactType AS_BUILT_ARTIFACT_TYPE_SPECIFICATION = AsBuiltArtifactType._(3, _omitEnumNames ? '' : 'AS_BUILT_ARTIFACT_TYPE_SPECIFICATION');
  static const AsBuiltArtifactType AS_BUILT_ARTIFACT_TYPE_PHOTO = AsBuiltArtifactType._(4, _omitEnumNames ? '' : 'AS_BUILT_ARTIFACT_TYPE_PHOTO');
  static const AsBuiltArtifactType AS_BUILT_ARTIFACT_TYPE_TEST_RECORD = AsBuiltArtifactType._(5, _omitEnumNames ? '' : 'AS_BUILT_ARTIFACT_TYPE_TEST_RECORD');
  static const AsBuiltArtifactType AS_BUILT_ARTIFACT_TYPE_CERTIFICATE = AsBuiltArtifactType._(6, _omitEnumNames ? '' : 'AS_BUILT_ARTIFACT_TYPE_CERTIFICATE');

  static const $core.List<AsBuiltArtifactType> values = <AsBuiltArtifactType> [
    AS_BUILT_ARTIFACT_TYPE_UNSPECIFIED,
    AS_BUILT_ARTIFACT_TYPE_DRAWING,
    AS_BUILT_ARTIFACT_TYPE_REPORT,
    AS_BUILT_ARTIFACT_TYPE_SPECIFICATION,
    AS_BUILT_ARTIFACT_TYPE_PHOTO,
    AS_BUILT_ARTIFACT_TYPE_TEST_RECORD,
    AS_BUILT_ARTIFACT_TYPE_CERTIFICATE,
  ];

  static final $core.Map<$core.int, AsBuiltArtifactType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AsBuiltArtifactType? valueOf($core.int value) => _byValue[value];

  const AsBuiltArtifactType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
