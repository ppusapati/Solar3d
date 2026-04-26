//
//  Generated code. Do not modify.
//  source: commissioning/v1/commissioning.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/field_mask.pbjson.dart' as $2;
import '../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../../packages/pagination.pbjson.dart' as $1;

@$core.Deprecated('Use commissioningStatusDescriptor instead')
const CommissioningStatus$json = {
  '1': 'CommissioningStatus',
  '2': [
    {'1': 'COMMISSIONING_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'COMMISSIONING_STATUS_PENDING', '2': 1},
    {'1': 'COMMISSIONING_STATUS_IN_PROGRESS', '2': 2},
    {'1': 'COMMISSIONING_STATUS_COMPLETED', '2': 3},
    {'1': 'COMMISSIONING_STATUS_SIGNED_OFF', '2': 4},
    {'1': 'COMMISSIONING_STATUS_HANDED_OVER', '2': 5},
  ],
};

/// Descriptor for `CommissioningStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commissioningStatusDescriptor = $convert.base64Decode(
    'ChNDb21taXNzaW9uaW5nU3RhdHVzEiQKIENPTU1JU1NJT05JTkdfU1RBVFVTX1VOU1BFQ0lGSU'
    'VEEAASIAocQ09NTUlTU0lPTklOR19TVEFUVVNfUEVORElORxABEiQKIENPTU1JU1NJT05JTkdf'
    'U1RBVFVTX0lOX1BST0dSRVNTEAISIgoeQ09NTUlTU0lPTklOR19TVEFUVVNfQ09NUExFVEVEEA'
    'MSIwofQ09NTUlTU0lPTklOR19TVEFUVVNfU0lHTkVEX09GRhAEEiQKIENPTU1JU1NJT05JTkdf'
    'U1RBVFVTX0hBTkRFRF9PVkVSEAU=');

@$core.Deprecated('Use checklistItemStatusDescriptor instead')
const ChecklistItemStatus$json = {
  '1': 'ChecklistItemStatus',
  '2': [
    {'1': 'CHECKLIST_ITEM_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CHECKLIST_ITEM_STATUS_PENDING', '2': 1},
    {'1': 'CHECKLIST_ITEM_STATUS_PASS', '2': 2},
    {'1': 'CHECKLIST_ITEM_STATUS_FAIL', '2': 3},
    {'1': 'CHECKLIST_ITEM_STATUS_NOT_APPLICABLE', '2': 4},
  ],
};

/// Descriptor for `ChecklistItemStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List checklistItemStatusDescriptor = $convert.base64Decode(
    'ChNDaGVja2xpc3RJdGVtU3RhdHVzEiUKIUNIRUNLTElTVF9JVEVNX1NUQVRVU19VTlNQRUNJRk'
    'lFRBAAEiEKHUNIRUNLTElTVF9JVEVNX1NUQVRVU19QRU5ESU5HEAESHgoaQ0hFQ0tMSVNUX0lU'
    'RU1fU1RBVFVTX1BBU1MQAhIeChpDSEVDS0xJU1RfSVRFTV9TVEFUVVNfRkFJTBADEigKJENIRU'
    'NLTElTVF9JVEVNX1NUQVRVU19OT1RfQVBQTElDQUJMRRAE');

@$core.Deprecated('Use checklistSectionDescriptor instead')
const ChecklistSection$json = {
  '1': 'ChecklistSection',
  '2': [
    {'1': 'CHECKLIST_SECTION_UNSPECIFIED', '2': 0},
    {'1': 'CHECKLIST_SECTION_CIVIL', '2': 1},
    {'1': 'CHECKLIST_SECTION_MECHANICAL', '2': 2},
    {'1': 'CHECKLIST_SECTION_ELECTRICAL', '2': 3},
    {'1': 'CHECKLIST_SECTION_PROTECTION', '2': 4},
    {'1': 'CHECKLIST_SECTION_SCADA', '2': 5},
    {'1': 'CHECKLIST_SECTION_SAFETY', '2': 6},
    {'1': 'CHECKLIST_SECTION_DOCUMENTATION', '2': 7},
  ],
};

/// Descriptor for `ChecklistSection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List checklistSectionDescriptor = $convert.base64Decode(
    'ChBDaGVja2xpc3RTZWN0aW9uEiEKHUNIRUNLTElTVF9TRUNUSU9OX1VOU1BFQ0lGSUVEEAASGw'
    'oXQ0hFQ0tMSVNUX1NFQ1RJT05fQ0lWSUwQARIgChxDSEVDS0xJU1RfU0VDVElPTl9NRUNIQU5J'
    'Q0FMEAISIAocQ0hFQ0tMSVNUX1NFQ1RJT05fRUxFQ1RSSUNBTBADEiAKHENIRUNLTElTVF9TRU'
    'NUSU9OX1BST1RFQ1RJT04QBBIbChdDSEVDS0xJU1RfU0VDVElPTl9TQ0FEQRAFEhwKGENIRUNL'
    'TElTVF9TRUNUSU9OX1NBRkVUWRAGEiMKH0NIRUNLTElTVF9TRUNUSU9OX0RPQ1VNRU5UQVRJT0'
    '4QBw==');

@$core.Deprecated('Use asBuiltArtifactTypeDescriptor instead')
const AsBuiltArtifactType$json = {
  '1': 'AsBuiltArtifactType',
  '2': [
    {'1': 'AS_BUILT_ARTIFACT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'AS_BUILT_ARTIFACT_TYPE_DRAWING', '2': 1},
    {'1': 'AS_BUILT_ARTIFACT_TYPE_REPORT', '2': 2},
    {'1': 'AS_BUILT_ARTIFACT_TYPE_SPECIFICATION', '2': 3},
    {'1': 'AS_BUILT_ARTIFACT_TYPE_PHOTO', '2': 4},
    {'1': 'AS_BUILT_ARTIFACT_TYPE_TEST_RECORD', '2': 5},
    {'1': 'AS_BUILT_ARTIFACT_TYPE_CERTIFICATE', '2': 6},
  ],
};

/// Descriptor for `AsBuiltArtifactType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List asBuiltArtifactTypeDescriptor = $convert.base64Decode(
    'ChNBc0J1aWx0QXJ0aWZhY3RUeXBlEiYKIkFTX0JVSUxUX0FSVElGQUNUX1RZUEVfVU5TUEVDSU'
    'ZJRUQQABIiCh5BU19CVUlMVF9BUlRJRkFDVF9UWVBFX0RSQVdJTkcQARIhCh1BU19CVUlMVF9B'
    'UlRJRkFDVF9UWVBFX1JFUE9SVBACEigKJEFTX0JVSUxUX0FSVElGQUNUX1RZUEVfU1BFQ0lGSU'
    'NBVElPThADEiAKHEFTX0JVSUxUX0FSVElGQUNUX1RZUEVfUEhPVE8QBBImCiJBU19CVUlMVF9B'
    'UlRJRkFDVF9UWVBFX1RFU1RfUkVDT1JEEAUSJgoiQVNfQlVJTFRfQVJUSUZBQ1RfVFlQRV9DRV'
    'JUSUZJQ0FURRAG');

@$core.Deprecated('Use commissioningChecklistDescriptor instead')
const CommissioningChecklist$json = {
  '1': 'CommissioningChecklist',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.commissioning.v1.CommissioningStatus', '10': 'status'},
    {'1': 'items', '3': 5, '4': 3, '5': 11, '6': '.commissioning.v1.ChecklistItem', '10': 'items'},
    {'1': 'signoffs', '3': 6, '4': 3, '5': 11, '6': '.commissioning.v1.CommissioningSignoff', '10': 'signoffs'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'created_by', '3': 9, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'total_items', '3': 10, '4': 1, '5': 5, '10': 'totalItems'},
    {'1': 'completed_items', '3': 11, '4': 1, '5': 5, '10': 'completedItems'},
    {'1': 'failed_items', '3': 12, '4': 1, '5': 5, '10': 'failedItems'},
  ],
};

/// Descriptor for `CommissioningChecklist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissioningChecklistDescriptor = $convert.base64Decode(
    'ChZDb21taXNzaW9uaW5nQ2hlY2tsaXN0Eg4KAmlkGAEgASgJUgJpZBIdCgpwcm9qZWN0X2lkGA'
    'IgASgJUglwcm9qZWN0SWQSEgoEbmFtZRgDIAEoCVIEbmFtZRI9CgZzdGF0dXMYBCABKA4yJS5j'
    'b21taXNzaW9uaW5nLnYxLkNvbW1pc3Npb25pbmdTdGF0dXNSBnN0YXR1cxI1CgVpdGVtcxgFIA'
    'MoCzIfLmNvbW1pc3Npb25pbmcudjEuQ2hlY2tsaXN0SXRlbVIFaXRlbXMSQgoIc2lnbm9mZnMY'
    'BiADKAsyJi5jb21taXNzaW9uaW5nLnYxLkNvbW1pc3Npb25pbmdTaWdub2ZmUghzaWdub2Zmcx'
    'I5CgpjcmVhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRl'
    'ZEF0EjkKCnVwZGF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cG'
    'RhdGVkQXQSHQoKY3JlYXRlZF9ieRgJIAEoCVIJY3JlYXRlZEJ5Eh8KC3RvdGFsX2l0ZW1zGAog'
    'ASgFUgp0b3RhbEl0ZW1zEicKD2NvbXBsZXRlZF9pdGVtcxgLIAEoBVIOY29tcGxldGVkSXRlbX'
    'MSIQoMZmFpbGVkX2l0ZW1zGAwgASgFUgtmYWlsZWRJdGVtcw==');

@$core.Deprecated('Use checklistItemDescriptor instead')
const ChecklistItem$json = {
  '1': 'ChecklistItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'checklist_id', '3': 2, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'section', '3': 4, '4': 1, '5': 14, '6': '.commissioning.v1.ChecklistSection', '10': 'section'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.commissioning.v1.ChecklistItemStatus', '10': 'status'},
    {'1': 'required', '3': 6, '4': 1, '5': 8, '10': 'required'},
    {'1': 'completed_by', '3': 7, '4': 1, '5': 9, '10': 'completedBy'},
    {'1': 'completed_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'completedAt'},
    {'1': 'notes', '3': 9, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'sequence', '3': 10, '4': 1, '5': 5, '10': 'sequence'},
  ],
};

/// Descriptor for `ChecklistItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checklistItemDescriptor = $convert.base64Decode(
    'Cg1DaGVja2xpc3RJdGVtEg4KAmlkGAEgASgJUgJpZBIhCgxjaGVja2xpc3RfaWQYAiABKAlSC2'
    'NoZWNrbGlzdElkEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhI8CgdzZWN0aW9u'
    'GAQgASgOMiIuY29tbWlzc2lvbmluZy52MS5DaGVja2xpc3RTZWN0aW9uUgdzZWN0aW9uEj0KBn'
    'N0YXR1cxgFIAEoDjIlLmNvbW1pc3Npb25pbmcudjEuQ2hlY2tsaXN0SXRlbVN0YXR1c1IGc3Rh'
    'dHVzEhoKCHJlcXVpcmVkGAYgASgIUghyZXF1aXJlZBIhCgxjb21wbGV0ZWRfYnkYByABKAlSC2'
    'NvbXBsZXRlZEJ5Ej0KDGNvbXBsZXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSC2NvbXBsZXRlZEF0EhQKBW5vdGVzGAkgASgJUgVub3RlcxIaCghzZXF1ZW5jZRgKIA'
    'EoBVIIc2VxdWVuY2U=');

@$core.Deprecated('Use commissioningSignoffDescriptor instead')
const CommissioningSignoff$json = {
  '1': 'CommissioningSignoff',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'checklist_id', '3': 2, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'signed_by', '3': 3, '4': 1, '5': 9, '10': 'signedBy'},
    {'1': 'role', '3': 4, '4': 1, '5': 9, '10': 'role'},
    {'1': 'comments', '3': 5, '4': 1, '5': 9, '10': 'comments'},
    {'1': 'signed_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'signedAt'},
  ],
};

/// Descriptor for `CommissioningSignoff`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissioningSignoffDescriptor = $convert.base64Decode(
    'ChRDb21taXNzaW9uaW5nU2lnbm9mZhIOCgJpZBgBIAEoCVICaWQSIQoMY2hlY2tsaXN0X2lkGA'
    'IgASgJUgtjaGVja2xpc3RJZBIbCglzaWduZWRfYnkYAyABKAlSCHNpZ25lZEJ5EhIKBHJvbGUY'
    'BCABKAlSBHJvbGUSGgoIY29tbWVudHMYBSABKAlSCGNvbW1lbnRzEjcKCXNpZ25lZF9hdBgGIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHNpZ25lZEF0');

@$core.Deprecated('Use handoverRecordDescriptor instead')
const HandoverRecord$json = {
  '1': 'HandoverRecord',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'checklist_id', '3': 3, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'handed_over_by', '3': 4, '4': 1, '5': 9, '10': 'handedOverBy'},
    {'1': 'received_by', '3': 5, '4': 1, '5': 9, '10': 'receivedBy'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'artifact_ids', '3': 7, '4': 3, '5': 9, '10': 'artifactIds'},
    {'1': 'handover_date', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'handoverDate'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `HandoverRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handoverRecordDescriptor = $convert.base64Decode(
    'Cg5IYW5kb3ZlclJlY29yZBIOCgJpZBgBIAEoCVICaWQSHQoKcHJvamVjdF9pZBgCIAEoCVIJcH'
    'JvamVjdElkEiEKDGNoZWNrbGlzdF9pZBgDIAEoCVILY2hlY2tsaXN0SWQSJAoOaGFuZGVkX292'
    'ZXJfYnkYBCABKAlSDGhhbmRlZE92ZXJCeRIfCgtyZWNlaXZlZF9ieRgFIAEoCVIKcmVjZWl2ZW'
    'RCeRIUCgVub3RlcxgGIAEoCVIFbm90ZXMSIQoMYXJ0aWZhY3RfaWRzGAcgAygJUgthcnRpZmFj'
    'dElkcxI/Cg1oYW5kb3Zlcl9kYXRlGAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IMaGFuZG92ZXJEYXRlEjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use asBuiltArtifactDescriptor instead')
const AsBuiltArtifact$json = {
  '1': 'AsBuiltArtifact',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'artifact_type', '3': 4, '4': 1, '5': 14, '6': '.commissioning.v1.AsBuiltArtifactType', '10': 'artifactType'},
    {'1': 'storage_url', '3': 5, '4': 1, '5': 9, '10': 'storageUrl'},
    {'1': 'uploaded_by', '3': 6, '4': 1, '5': 9, '10': 'uploadedBy'},
    {'1': 'uploaded_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'uploadedAt'},
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {'1': 'file_size_bytes', '3': 9, '4': 1, '5': 3, '10': 'fileSizeBytes'},
    {'1': 'revision', '3': 10, '4': 1, '5': 9, '10': 'revision'},
  ],
};

/// Descriptor for `AsBuiltArtifact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List asBuiltArtifactDescriptor = $convert.base64Decode(
    'Cg9Bc0J1aWx0QXJ0aWZhY3QSDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKAlSCX'
    'Byb2plY3RJZBISCgRuYW1lGAMgASgJUgRuYW1lEkoKDWFydGlmYWN0X3R5cGUYBCABKA4yJS5j'
    'b21taXNzaW9uaW5nLnYxLkFzQnVpbHRBcnRpZmFjdFR5cGVSDGFydGlmYWN0VHlwZRIfCgtzdG'
    '9yYWdlX3VybBgFIAEoCVIKc3RvcmFnZVVybBIfCgt1cGxvYWRlZF9ieRgGIAEoCVIKdXBsb2Fk'
    'ZWRCeRI7Cgt1cGxvYWRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCn'
    'VwbG9hZGVkQXQSIAoLZGVzY3JpcHRpb24YCCABKAlSC2Rlc2NyaXB0aW9uEiYKD2ZpbGVfc2l6'
    'ZV9ieXRlcxgJIAEoA1INZmlsZVNpemVCeXRlcxIaCghyZXZpc2lvbhgKIAEoCVIIcmV2aXNpb2'
    '4=');

@$core.Deprecated('Use createChecklistRequestDescriptor instead')
const CreateChecklistRequest$json = {
  '1': 'CreateChecklistRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'created_by', '3': 3, '4': 1, '5': 9, '10': 'createdBy'},
  ],
};

/// Descriptor for `CreateChecklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChecklistRequestDescriptor = $convert.base64Decode(
    'ChZDcmVhdGVDaGVja2xpc3RSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZB'
    'ISCgRuYW1lGAIgASgJUgRuYW1lEh0KCmNyZWF0ZWRfYnkYAyABKAlSCWNyZWF0ZWRCeQ==');

@$core.Deprecated('Use createChecklistResponseDescriptor instead')
const CreateChecklistResponse$json = {
  '1': 'CreateChecklistResponse',
  '2': [
    {'1': 'checklist', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.CommissioningChecklist', '10': 'checklist'},
  ],
};

/// Descriptor for `CreateChecklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChecklistResponseDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVDaGVja2xpc3RSZXNwb25zZRJGCgljaGVja2xpc3QYASABKAsyKC5jb21taXNzaW'
    '9uaW5nLnYxLkNvbW1pc3Npb25pbmdDaGVja2xpc3RSCWNoZWNrbGlzdA==');

@$core.Deprecated('Use getChecklistRequestDescriptor instead')
const GetChecklistRequest$json = {
  '1': 'GetChecklistRequest',
  '2': [
    {'1': 'checklist_id', '3': 1, '4': 1, '5': 9, '10': 'checklistId'},
  ],
};

/// Descriptor for `GetChecklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChecklistRequestDescriptor = $convert.base64Decode(
    'ChNHZXRDaGVja2xpc3RSZXF1ZXN0EiEKDGNoZWNrbGlzdF9pZBgBIAEoCVILY2hlY2tsaXN0SW'
    'Q=');

@$core.Deprecated('Use getChecklistResponseDescriptor instead')
const GetChecklistResponse$json = {
  '1': 'GetChecklistResponse',
  '2': [
    {'1': 'checklist', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.CommissioningChecklist', '10': 'checklist'},
  ],
};

/// Descriptor for `GetChecklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChecklistResponseDescriptor = $convert.base64Decode(
    'ChRHZXRDaGVja2xpc3RSZXNwb25zZRJGCgljaGVja2xpc3QYASABKAsyKC5jb21taXNzaW9uaW'
    '5nLnYxLkNvbW1pc3Npb25pbmdDaGVja2xpc3RSCWNoZWNrbGlzdA==');

@$core.Deprecated('Use listChecklistsRequestDescriptor instead')
const ListChecklistsRequest$json = {
  '1': 'ListChecklistsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListChecklistsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChecklistsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Q2hlY2tsaXN0c1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEk'
    '0KCnBhZ2luYXRpb24YAiABKAsyLS5wYWNrYWdlcy5hcGkudjEucGFnaW5hdGlvbi5QYWdpbmF0'
    'aW9uUmVxdWVzdFIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use listChecklistsResponseDescriptor instead')
const ListChecklistsResponse$json = {
  '1': 'ListChecklistsResponse',
  '2': [
    {'1': 'checklists', '3': 1, '4': 3, '5': 11, '6': '.commissioning.v1.CommissioningChecklist', '10': 'checklists'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListChecklistsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChecklistsResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0Q2hlY2tsaXN0c1Jlc3BvbnNlEkgKCmNoZWNrbGlzdHMYASADKAsyKC5jb21taXNzaW'
    '9uaW5nLnYxLkNvbW1pc3Npb25pbmdDaGVja2xpc3RSCmNoZWNrbGlzdHMSTgoKcGFnaW5hdGlv'
    'bhgCIAEoCzIuLnBhY2thZ2VzLmFwaS52MS5wYWdpbmF0aW9uLlBhZ2luYXRpb25SZXNwb25zZV'
    'IKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use addChecklistItemRequestDescriptor instead')
const AddChecklistItemRequest$json = {
  '1': 'AddChecklistItemRequest',
  '2': [
    {'1': 'checklist_id', '3': 1, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'section', '3': 3, '4': 1, '5': 14, '6': '.commissioning.v1.ChecklistSection', '10': 'section'},
    {'1': 'required', '3': 4, '4': 1, '5': 8, '10': 'required'},
    {'1': 'sequence', '3': 5, '4': 1, '5': 5, '10': 'sequence'},
  ],
};

/// Descriptor for `AddChecklistItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addChecklistItemRequestDescriptor = $convert.base64Decode(
    'ChdBZGRDaGVja2xpc3RJdGVtUmVxdWVzdBIhCgxjaGVja2xpc3RfaWQYASABKAlSC2NoZWNrbG'
    'lzdElkEiAKC2Rlc2NyaXB0aW9uGAIgASgJUgtkZXNjcmlwdGlvbhI8CgdzZWN0aW9uGAMgASgO'
    'MiIuY29tbWlzc2lvbmluZy52MS5DaGVja2xpc3RTZWN0aW9uUgdzZWN0aW9uEhoKCHJlcXVpcm'
    'VkGAQgASgIUghyZXF1aXJlZBIaCghzZXF1ZW5jZRgFIAEoBVIIc2VxdWVuY2U=');

@$core.Deprecated('Use addChecklistItemResponseDescriptor instead')
const AddChecklistItemResponse$json = {
  '1': 'AddChecklistItemResponse',
  '2': [
    {'1': 'item', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.ChecklistItem', '10': 'item'},
  ],
};

/// Descriptor for `AddChecklistItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addChecklistItemResponseDescriptor = $convert.base64Decode(
    'ChhBZGRDaGVja2xpc3RJdGVtUmVzcG9uc2USMwoEaXRlbRgBIAEoCzIfLmNvbW1pc3Npb25pbm'
    'cudjEuQ2hlY2tsaXN0SXRlbVIEaXRlbQ==');

@$core.Deprecated('Use updateChecklistItemRequestDescriptor instead')
const UpdateChecklistItemRequest$json = {
  '1': 'UpdateChecklistItemRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.commissioning.v1.ChecklistItemStatus', '10': 'status'},
    {'1': 'completed_by', '3': 3, '4': 1, '5': 9, '10': 'completedBy'},
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `UpdateChecklistItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChecklistItemRequestDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVDaGVja2xpc3RJdGVtUmVxdWVzdBIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSPQ'
    'oGc3RhdHVzGAIgASgOMiUuY29tbWlzc2lvbmluZy52MS5DaGVja2xpc3RJdGVtU3RhdHVzUgZz'
    'dGF0dXMSIQoMY29tcGxldGVkX2J5GAMgASgJUgtjb21wbGV0ZWRCeRIUCgVub3RlcxgEIAEoCV'
    'IFbm90ZXM=');

@$core.Deprecated('Use updateChecklistItemResponseDescriptor instead')
const UpdateChecklistItemResponse$json = {
  '1': 'UpdateChecklistItemResponse',
  '2': [
    {'1': 'item', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.ChecklistItem', '10': 'item'},
  ],
};

/// Descriptor for `UpdateChecklistItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChecklistItemResponseDescriptor = $convert.base64Decode(
    'ChtVcGRhdGVDaGVja2xpc3RJdGVtUmVzcG9uc2USMwoEaXRlbRgBIAEoCzIfLmNvbW1pc3Npb2'
    '5pbmcudjEuQ2hlY2tsaXN0SXRlbVIEaXRlbQ==');

@$core.Deprecated('Use signOffChecklistRequestDescriptor instead')
const SignOffChecklistRequest$json = {
  '1': 'SignOffChecklistRequest',
  '2': [
    {'1': 'checklist_id', '3': 1, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'signed_by', '3': 2, '4': 1, '5': 9, '10': 'signedBy'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'comments', '3': 4, '4': 1, '5': 9, '10': 'comments'},
  ],
};

/// Descriptor for `SignOffChecklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOffChecklistRequestDescriptor = $convert.base64Decode(
    'ChdTaWduT2ZmQ2hlY2tsaXN0UmVxdWVzdBIhCgxjaGVja2xpc3RfaWQYASABKAlSC2NoZWNrbG'
    'lzdElkEhsKCXNpZ25lZF9ieRgCIAEoCVIIc2lnbmVkQnkSEgoEcm9sZRgDIAEoCVIEcm9sZRIa'
    'Cghjb21tZW50cxgEIAEoCVIIY29tbWVudHM=');

@$core.Deprecated('Use signOffChecklistResponseDescriptor instead')
const SignOffChecklistResponse$json = {
  '1': 'SignOffChecklistResponse',
  '2': [
    {'1': 'signoff', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.CommissioningSignoff', '10': 'signoff'},
    {'1': 'updated_checklist', '3': 2, '4': 1, '5': 11, '6': '.commissioning.v1.CommissioningChecklist', '10': 'updatedChecklist'},
  ],
};

/// Descriptor for `SignOffChecklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOffChecklistResponseDescriptor = $convert.base64Decode(
    'ChhTaWduT2ZmQ2hlY2tsaXN0UmVzcG9uc2USQAoHc2lnbm9mZhgBIAEoCzImLmNvbW1pc3Npb2'
    '5pbmcudjEuQ29tbWlzc2lvbmluZ1NpZ25vZmZSB3NpZ25vZmYSVQoRdXBkYXRlZF9jaGVja2xp'
    'c3QYAiABKAsyKC5jb21taXNzaW9uaW5nLnYxLkNvbW1pc3Npb25pbmdDaGVja2xpc3RSEHVwZG'
    'F0ZWRDaGVja2xpc3Q=');

@$core.Deprecated('Use listSignoffsRequestDescriptor instead')
const ListSignoffsRequest$json = {
  '1': 'ListSignoffsRequest',
  '2': [
    {'1': 'checklist_id', '3': 1, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListSignoffsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSignoffsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0U2lnbm9mZnNSZXF1ZXN0EiEKDGNoZWNrbGlzdF9pZBgBIAEoCVILY2hlY2tsaXN0SW'
    'QSTQoKcGFnaW5hdGlvbhgCIAEoCzItLnBhY2thZ2VzLmFwaS52MS5wYWdpbmF0aW9uLlBhZ2lu'
    'YXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listSignoffsResponseDescriptor instead')
const ListSignoffsResponse$json = {
  '1': 'ListSignoffsResponse',
  '2': [
    {'1': 'signoffs', '3': 1, '4': 3, '5': 11, '6': '.commissioning.v1.CommissioningSignoff', '10': 'signoffs'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListSignoffsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSignoffsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0U2lnbm9mZnNSZXNwb25zZRJCCghzaWdub2ZmcxgBIAMoCzImLmNvbW1pc3Npb25pbm'
    'cudjEuQ29tbWlzc2lvbmluZ1NpZ25vZmZSCHNpZ25vZmZzEk4KCnBhZ2luYXRpb24YAiABKAsy'
    'Li5wYWNrYWdlcy5hcGkudjEucGFnaW5hdGlvbi5QYWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYX'
    'Rpb24=');

@$core.Deprecated('Use createHandoverRequestDescriptor instead')
const CreateHandoverRequest$json = {
  '1': 'CreateHandoverRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'checklist_id', '3': 2, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'handed_over_by', '3': 3, '4': 1, '5': 9, '10': 'handedOverBy'},
    {'1': 'received_by', '3': 4, '4': 1, '5': 9, '10': 'receivedBy'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'artifact_ids', '3': 6, '4': 3, '5': 9, '10': 'artifactIds'},
  ],
};

/// Descriptor for `CreateHandoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createHandoverRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVIYW5kb3ZlclJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEi'
    'EKDGNoZWNrbGlzdF9pZBgCIAEoCVILY2hlY2tsaXN0SWQSJAoOaGFuZGVkX292ZXJfYnkYAyAB'
    'KAlSDGhhbmRlZE92ZXJCeRIfCgtyZWNlaXZlZF9ieRgEIAEoCVIKcmVjZWl2ZWRCeRIUCgVub3'
    'RlcxgFIAEoCVIFbm90ZXMSIQoMYXJ0aWZhY3RfaWRzGAYgAygJUgthcnRpZmFjdElkcw==');

@$core.Deprecated('Use createHandoverResponseDescriptor instead')
const CreateHandoverResponse$json = {
  '1': 'CreateHandoverResponse',
  '2': [
    {'1': 'handover', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.HandoverRecord', '10': 'handover'},
  ],
};

/// Descriptor for `CreateHandoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createHandoverResponseDescriptor = $convert.base64Decode(
    'ChZDcmVhdGVIYW5kb3ZlclJlc3BvbnNlEjwKCGhhbmRvdmVyGAEgASgLMiAuY29tbWlzc2lvbm'
    'luZy52MS5IYW5kb3ZlclJlY29yZFIIaGFuZG92ZXI=');

@$core.Deprecated('Use getHandoverRequestDescriptor instead')
const GetHandoverRequest$json = {
  '1': 'GetHandoverRequest',
  '2': [
    {'1': 'handover_id', '3': 1, '4': 1, '5': 9, '10': 'handoverId'},
  ],
};

/// Descriptor for `GetHandoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHandoverRequestDescriptor = $convert.base64Decode(
    'ChJHZXRIYW5kb3ZlclJlcXVlc3QSHwoLaGFuZG92ZXJfaWQYASABKAlSCmhhbmRvdmVySWQ=');

@$core.Deprecated('Use getHandoverResponseDescriptor instead')
const GetHandoverResponse$json = {
  '1': 'GetHandoverResponse',
  '2': [
    {'1': 'handover', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.HandoverRecord', '10': 'handover'},
  ],
};

/// Descriptor for `GetHandoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHandoverResponseDescriptor = $convert.base64Decode(
    'ChNHZXRIYW5kb3ZlclJlc3BvbnNlEjwKCGhhbmRvdmVyGAEgASgLMiAuY29tbWlzc2lvbmluZy'
    '52MS5IYW5kb3ZlclJlY29yZFIIaGFuZG92ZXI=');

@$core.Deprecated('Use recordAsBuiltRequestDescriptor instead')
const RecordAsBuiltRequest$json = {
  '1': 'RecordAsBuiltRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'artifact_type', '3': 3, '4': 1, '5': 14, '6': '.commissioning.v1.AsBuiltArtifactType', '10': 'artifactType'},
    {'1': 'storage_url', '3': 4, '4': 1, '5': 9, '10': 'storageUrl'},
    {'1': 'uploaded_by', '3': 5, '4': 1, '5': 9, '10': 'uploadedBy'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {'1': 'file_size_bytes', '3': 7, '4': 1, '5': 3, '10': 'fileSizeBytes'},
    {'1': 'revision', '3': 8, '4': 1, '5': 9, '10': 'revision'},
  ],
};

/// Descriptor for `RecordAsBuiltRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAsBuiltRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRBc0J1aWx0UmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSEg'
    'oEbmFtZRgCIAEoCVIEbmFtZRJKCg1hcnRpZmFjdF90eXBlGAMgASgOMiUuY29tbWlzc2lvbmlu'
    'Zy52MS5Bc0J1aWx0QXJ0aWZhY3RUeXBlUgxhcnRpZmFjdFR5cGUSHwoLc3RvcmFnZV91cmwYBC'
    'ABKAlSCnN0b3JhZ2VVcmwSHwoLdXBsb2FkZWRfYnkYBSABKAlSCnVwbG9hZGVkQnkSIAoLZGVz'
    'Y3JpcHRpb24YBiABKAlSC2Rlc2NyaXB0aW9uEiYKD2ZpbGVfc2l6ZV9ieXRlcxgHIAEoA1INZm'
    'lsZVNpemVCeXRlcxIaCghyZXZpc2lvbhgIIAEoCVIIcmV2aXNpb24=');

@$core.Deprecated('Use recordAsBuiltResponseDescriptor instead')
const RecordAsBuiltResponse$json = {
  '1': 'RecordAsBuiltResponse',
  '2': [
    {'1': 'artifact', '3': 1, '4': 1, '5': 11, '6': '.commissioning.v1.AsBuiltArtifact', '10': 'artifact'},
  ],
};

/// Descriptor for `RecordAsBuiltResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAsBuiltResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRBc0J1aWx0UmVzcG9uc2USPQoIYXJ0aWZhY3QYASABKAsyIS5jb21taXNzaW9uaW'
    '5nLnYxLkFzQnVpbHRBcnRpZmFjdFIIYXJ0aWZhY3Q=');

@$core.Deprecated('Use listAsBuiltArtifactsRequestDescriptor instead')
const ListAsBuiltArtifactsRequest$json = {
  '1': 'ListAsBuiltArtifactsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListAsBuiltArtifactsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAsBuiltArtifactsRequestDescriptor = $convert.base64Decode(
    'ChtMaXN0QXNCdWlsdEFydGlmYWN0c1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvam'
    'VjdElkEk0KCnBhZ2luYXRpb24YAiABKAsyLS5wYWNrYWdlcy5hcGkudjEucGFnaW5hdGlvbi5Q'
    'YWdpbmF0aW9uUmVxdWVzdFIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use listAsBuiltArtifactsResponseDescriptor instead')
const ListAsBuiltArtifactsResponse$json = {
  '1': 'ListAsBuiltArtifactsResponse',
  '2': [
    {'1': 'artifacts', '3': 1, '4': 3, '5': 11, '6': '.commissioning.v1.AsBuiltArtifact', '10': 'artifacts'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListAsBuiltArtifactsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAsBuiltArtifactsResponseDescriptor = $convert.base64Decode(
    'ChxMaXN0QXNCdWlsdEFydGlmYWN0c1Jlc3BvbnNlEj8KCWFydGlmYWN0cxgBIAMoCzIhLmNvbW'
    '1pc3Npb25pbmcudjEuQXNCdWlsdEFydGlmYWN0UglhcnRpZmFjdHMSTgoKcGFnaW5hdGlvbhgC'
    'IAEoCzIuLnBhY2thZ2VzLmFwaS52MS5wYWdpbmF0aW9uLlBhZ2luYXRpb25SZXNwb25zZVIKcG'
    'FnaW5hdGlvbg==');

@$core.Deprecated('Use generateCommissioningReportRequestDescriptor instead')
const GenerateCommissioningReportRequest$json = {
  '1': 'GenerateCommissioningReportRequest',
  '2': [
    {'1': 'checklist_id', '3': 1, '4': 1, '5': 9, '10': 'checklistId'},
  ],
};

/// Descriptor for `GenerateCommissioningReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateCommissioningReportRequestDescriptor = $convert.base64Decode(
    'CiJHZW5lcmF0ZUNvbW1pc3Npb25pbmdSZXBvcnRSZXF1ZXN0EiEKDGNoZWNrbGlzdF9pZBgBIA'
    'EoCVILY2hlY2tsaXN0SWQ=');

@$core.Deprecated('Use generateCommissioningReportResponseDescriptor instead')
const GenerateCommissioningReportResponse$json = {
  '1': 'GenerateCommissioningReportResponse',
  '2': [
    {'1': 'report_text', '3': 1, '4': 1, '5': 9, '10': 'reportText'},
    {'1': 'generated_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'generatedAt'},
  ],
};

/// Descriptor for `GenerateCommissioningReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateCommissioningReportResponseDescriptor = $convert.base64Decode(
    'CiNHZW5lcmF0ZUNvbW1pc3Npb25pbmdSZXBvcnRSZXNwb25zZRIfCgtyZXBvcnRfdGV4dBgBIA'
    'EoCVIKcmVwb3J0VGV4dBI9CgxnZW5lcmF0ZWRfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgtnZW5lcmF0ZWRBdA==');

const $core.Map<$core.String, $core.dynamic> CommissioningServiceBase$json = {
  '1': 'CommissioningService',
  '2': [
    {'1': 'CreateChecklist', '2': '.commissioning.v1.CreateChecklistRequest', '3': '.commissioning.v1.CreateChecklistResponse'},
    {'1': 'GetChecklist', '2': '.commissioning.v1.GetChecklistRequest', '3': '.commissioning.v1.GetChecklistResponse'},
    {'1': 'ListChecklists', '2': '.commissioning.v1.ListChecklistsRequest', '3': '.commissioning.v1.ListChecklistsResponse'},
    {'1': 'AddChecklistItem', '2': '.commissioning.v1.AddChecklistItemRequest', '3': '.commissioning.v1.AddChecklistItemResponse'},
    {'1': 'UpdateChecklistItem', '2': '.commissioning.v1.UpdateChecklistItemRequest', '3': '.commissioning.v1.UpdateChecklistItemResponse'},
    {'1': 'SignOffChecklist', '2': '.commissioning.v1.SignOffChecklistRequest', '3': '.commissioning.v1.SignOffChecklistResponse'},
    {'1': 'ListSignoffs', '2': '.commissioning.v1.ListSignoffsRequest', '3': '.commissioning.v1.ListSignoffsResponse'},
    {'1': 'CreateHandover', '2': '.commissioning.v1.CreateHandoverRequest', '3': '.commissioning.v1.CreateHandoverResponse'},
    {'1': 'GetHandover', '2': '.commissioning.v1.GetHandoverRequest', '3': '.commissioning.v1.GetHandoverResponse'},
    {'1': 'RecordAsBuilt', '2': '.commissioning.v1.RecordAsBuiltRequest', '3': '.commissioning.v1.RecordAsBuiltResponse'},
    {'1': 'ListAsBuiltArtifacts', '2': '.commissioning.v1.ListAsBuiltArtifactsRequest', '3': '.commissioning.v1.ListAsBuiltArtifactsResponse'},
    {'1': 'GenerateCommissioningReport', '2': '.commissioning.v1.GenerateCommissioningReportRequest', '3': '.commissioning.v1.GenerateCommissioningReportResponse'},
  ],
};

@$core.Deprecated('Use commissioningServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> CommissioningServiceBase$messageJson = {
  '.commissioning.v1.CreateChecklistRequest': CreateChecklistRequest$json,
  '.commissioning.v1.CreateChecklistResponse': CreateChecklistResponse$json,
  '.commissioning.v1.CommissioningChecklist': CommissioningChecklist$json,
  '.commissioning.v1.ChecklistItem': ChecklistItem$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.commissioning.v1.CommissioningSignoff': CommissioningSignoff$json,
  '.commissioning.v1.GetChecklistRequest': GetChecklistRequest$json,
  '.commissioning.v1.GetChecklistResponse': GetChecklistResponse$json,
  '.commissioning.v1.ListChecklistsRequest': ListChecklistsRequest$json,
  '.packages.api.v1.pagination.PaginationRequest': $1.PaginationRequest$json,
  '.google.protobuf.FieldMask': $2.FieldMask$json,
  '.commissioning.v1.ListChecklistsResponse': ListChecklistsResponse$json,
  '.packages.api.v1.pagination.PaginationResponse': $1.PaginationResponse$json,
  '.commissioning.v1.AddChecklistItemRequest': AddChecklistItemRequest$json,
  '.commissioning.v1.AddChecklistItemResponse': AddChecklistItemResponse$json,
  '.commissioning.v1.UpdateChecklistItemRequest': UpdateChecklistItemRequest$json,
  '.commissioning.v1.UpdateChecklistItemResponse': UpdateChecklistItemResponse$json,
  '.commissioning.v1.SignOffChecklistRequest': SignOffChecklistRequest$json,
  '.commissioning.v1.SignOffChecklistResponse': SignOffChecklistResponse$json,
  '.commissioning.v1.ListSignoffsRequest': ListSignoffsRequest$json,
  '.commissioning.v1.ListSignoffsResponse': ListSignoffsResponse$json,
  '.commissioning.v1.CreateHandoverRequest': CreateHandoverRequest$json,
  '.commissioning.v1.CreateHandoverResponse': CreateHandoverResponse$json,
  '.commissioning.v1.HandoverRecord': HandoverRecord$json,
  '.commissioning.v1.GetHandoverRequest': GetHandoverRequest$json,
  '.commissioning.v1.GetHandoverResponse': GetHandoverResponse$json,
  '.commissioning.v1.RecordAsBuiltRequest': RecordAsBuiltRequest$json,
  '.commissioning.v1.RecordAsBuiltResponse': RecordAsBuiltResponse$json,
  '.commissioning.v1.AsBuiltArtifact': AsBuiltArtifact$json,
  '.commissioning.v1.ListAsBuiltArtifactsRequest': ListAsBuiltArtifactsRequest$json,
  '.commissioning.v1.ListAsBuiltArtifactsResponse': ListAsBuiltArtifactsResponse$json,
  '.commissioning.v1.GenerateCommissioningReportRequest': GenerateCommissioningReportRequest$json,
  '.commissioning.v1.GenerateCommissioningReportResponse': GenerateCommissioningReportResponse$json,
};

/// Descriptor for `CommissioningService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List commissioningServiceDescriptor = $convert.base64Decode(
    'ChRDb21taXNzaW9uaW5nU2VydmljZRJmCg9DcmVhdGVDaGVja2xpc3QSKC5jb21taXNzaW9uaW'
    '5nLnYxLkNyZWF0ZUNoZWNrbGlzdFJlcXVlc3QaKS5jb21taXNzaW9uaW5nLnYxLkNyZWF0ZUNo'
    'ZWNrbGlzdFJlc3BvbnNlEl0KDEdldENoZWNrbGlzdBIlLmNvbW1pc3Npb25pbmcudjEuR2V0Q2'
    'hlY2tsaXN0UmVxdWVzdBomLmNvbW1pc3Npb25pbmcudjEuR2V0Q2hlY2tsaXN0UmVzcG9uc2US'
    'YwoOTGlzdENoZWNrbGlzdHMSJy5jb21taXNzaW9uaW5nLnYxLkxpc3RDaGVja2xpc3RzUmVxdW'
    'VzdBooLmNvbW1pc3Npb25pbmcudjEuTGlzdENoZWNrbGlzdHNSZXNwb25zZRJpChBBZGRDaGVj'
    'a2xpc3RJdGVtEikuY29tbWlzc2lvbmluZy52MS5BZGRDaGVja2xpc3RJdGVtUmVxdWVzdBoqLm'
    'NvbW1pc3Npb25pbmcudjEuQWRkQ2hlY2tsaXN0SXRlbVJlc3BvbnNlEnIKE1VwZGF0ZUNoZWNr'
    'bGlzdEl0ZW0SLC5jb21taXNzaW9uaW5nLnYxLlVwZGF0ZUNoZWNrbGlzdEl0ZW1SZXF1ZXN0Gi'
    '0uY29tbWlzc2lvbmluZy52MS5VcGRhdGVDaGVja2xpc3RJdGVtUmVzcG9uc2USaQoQU2lnbk9m'
    'ZkNoZWNrbGlzdBIpLmNvbW1pc3Npb25pbmcudjEuU2lnbk9mZkNoZWNrbGlzdFJlcXVlc3QaKi'
    '5jb21taXNzaW9uaW5nLnYxLlNpZ25PZmZDaGVja2xpc3RSZXNwb25zZRJdCgxMaXN0U2lnbm9m'
    'ZnMSJS5jb21taXNzaW9uaW5nLnYxLkxpc3RTaWdub2Zmc1JlcXVlc3QaJi5jb21taXNzaW9uaW'
    '5nLnYxLkxpc3RTaWdub2Zmc1Jlc3BvbnNlEmMKDkNyZWF0ZUhhbmRvdmVyEicuY29tbWlzc2lv'
    'bmluZy52MS5DcmVhdGVIYW5kb3ZlclJlcXVlc3QaKC5jb21taXNzaW9uaW5nLnYxLkNyZWF0ZU'
    'hhbmRvdmVyUmVzcG9uc2USWgoLR2V0SGFuZG92ZXISJC5jb21taXNzaW9uaW5nLnYxLkdldEhh'
    'bmRvdmVyUmVxdWVzdBolLmNvbW1pc3Npb25pbmcudjEuR2V0SGFuZG92ZXJSZXNwb25zZRJgCg'
    '1SZWNvcmRBc0J1aWx0EiYuY29tbWlzc2lvbmluZy52MS5SZWNvcmRBc0J1aWx0UmVxdWVzdBon'
    'LmNvbW1pc3Npb25pbmcudjEuUmVjb3JkQXNCdWlsdFJlc3BvbnNlEnUKFExpc3RBc0J1aWx0QX'
    'J0aWZhY3RzEi0uY29tbWlzc2lvbmluZy52MS5MaXN0QXNCdWlsdEFydGlmYWN0c1JlcXVlc3Qa'
    'Li5jb21taXNzaW9uaW5nLnYxLkxpc3RBc0J1aWx0QXJ0aWZhY3RzUmVzcG9uc2USigEKG0dlbm'
    'VyYXRlQ29tbWlzc2lvbmluZ1JlcG9ydBI0LmNvbW1pc3Npb25pbmcudjEuR2VuZXJhdGVDb21t'
    'aXNzaW9uaW5nUmVwb3J0UmVxdWVzdBo1LmNvbW1pc3Npb25pbmcudjEuR2VuZXJhdGVDb21taX'
    'NzaW9uaW5nUmVwb3J0UmVzcG9uc2U=');

