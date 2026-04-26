//
//  Generated code. Do not modify.
//  source: drawing/v1/drawing.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../common/v1/primitives.pbjson.dart' as $1;
import '../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use drawingEntityTypeDescriptor instead')
const DrawingEntityType$json = {
  '1': 'DrawingEntityType',
  '2': [
    {'1': 'DRAWING_ENTITY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'DRAWING_ENTITY_TYPE_POLYLINE', '2': 1},
    {'1': 'DRAWING_ENTITY_TYPE_POLYGON', '2': 2},
    {'1': 'DRAWING_ENTITY_TYPE_TEXT', '2': 3},
    {'1': 'DRAWING_ENTITY_TYPE_DIMENSION', '2': 4},
    {'1': 'DRAWING_ENTITY_TYPE_BLOCK_REFERENCE', '2': 5},
    {'1': 'DRAWING_ENTITY_TYPE_LAYER_DEFINITION', '2': 6},
    {'1': 'DRAWING_ENTITY_TYPE_BLOCK_DEFINITION', '2': 7},
    {'1': 'DRAWING_ENTITY_TYPE_LEADER', '2': 8},
    {'1': 'DRAWING_ENTITY_TYPE_SHEET', '2': 9},
  ],
};

/// Descriptor for `DrawingEntityType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List drawingEntityTypeDescriptor = $convert.base64Decode(
    'ChFEcmF3aW5nRW50aXR5VHlwZRIjCh9EUkFXSU5HX0VOVElUWV9UWVBFX1VOU1BFQ0lGSUVEEA'
    'ASIAocRFJBV0lOR19FTlRJVFlfVFlQRV9QT0xZTElORRABEh8KG0RSQVdJTkdfRU5USVRZX1RZ'
    'UEVfUE9MWUdPThACEhwKGERSQVdJTkdfRU5USVRZX1RZUEVfVEVYVBADEiEKHURSQVdJTkdfRU'
    '5USVRZX1RZUEVfRElNRU5TSU9OEAQSJwojRFJBV0lOR19FTlRJVFlfVFlQRV9CTE9DS19SRUZF'
    'UkVOQ0UQBRIoCiREUkFXSU5HX0VOVElUWV9UWVBFX0xBWUVSX0RFRklOSVRJT04QBhIoCiREUk'
    'FXSU5HX0VOVElUWV9UWVBFX0JMT0NLX0RFRklOSVRJT04QBxIeChpEUkFXSU5HX0VOVElUWV9U'
    'WVBFX0xFQURFUhAIEh0KGURSQVdJTkdfRU5USVRZX1RZUEVfU0hFRVQQCQ==');

@$core.Deprecated('Use revisionActionDescriptor instead')
const RevisionAction$json = {
  '1': 'RevisionAction',
  '2': [
    {'1': 'REVISION_ACTION_UNSPECIFIED', '2': 0},
    {'1': 'REVISION_ACTION_CREATE', '2': 1},
    {'1': 'REVISION_ACTION_UPDATE', '2': 2},
    {'1': 'REVISION_ACTION_DELETE', '2': 3},
  ],
};

/// Descriptor for `RevisionAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List revisionActionDescriptor = $convert.base64Decode(
    'Cg5SZXZpc2lvbkFjdGlvbhIfChtSRVZJU0lPTl9BQ1RJT05fVU5TUEVDSUZJRUQQABIaChZSRV'
    'ZJU0lPTl9BQ1RJT05fQ1JFQVRFEAESGgoWUkVWSVNJT05fQUNUSU9OX1VQREFURRACEhoKFlJF'
    'VklTSU9OX0FDVElPTl9ERUxFVEUQAw==');

@$core.Deprecated('Use drawingStatusDescriptor instead')
const DrawingStatus$json = {
  '1': 'DrawingStatus',
  '2': [
    {'1': 'DRAWING_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DRAWING_STATUS_ACTIVE', '2': 1},
    {'1': 'DRAWING_STATUS_ARCHIVED', '2': 2},
  ],
};

/// Descriptor for `DrawingStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List drawingStatusDescriptor = $convert.base64Decode(
    'Cg1EcmF3aW5nU3RhdHVzEh4KGkRSQVdJTkdfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGQoVRFJBV0'
    'lOR19TVEFUVVNfQUNUSVZFEAESGwoXRFJBV0lOR19TVEFUVVNfQVJDSElWRUQQAg==');

@$core.Deprecated('Use fileFormatDescriptor instead')
const FileFormat$json = {
  '1': 'FileFormat',
  '2': [
    {'1': 'FILE_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'FILE_FORMAT_SOLAR3D_JSON', '2': 1},
    {'1': 'FILE_FORMAT_DXF_ASCII', '2': 2},
  ],
};

/// Descriptor for `FileFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fileFormatDescriptor = $convert.base64Decode(
    'CgpGaWxlRm9ybWF0EhsKF0ZJTEVfRk9STUFUX1VOU1BFQ0lGSUVEEAASHAoYRklMRV9GT1JNQV'
    'RfU09MQVIzRF9KU09OEAESGQoVRklMRV9GT1JNQVRfRFhGX0FTQ0lJEAI=');

@$core.Deprecated('Use interopMergeStrategyDescriptor instead')
const InteropMergeStrategy$json = {
  '1': 'InteropMergeStrategy',
  '2': [
    {'1': 'INTEROP_MERGE_STRATEGY_UNSPECIFIED', '2': 0},
    {'1': 'INTEROP_MERGE_STRATEGY_REPLACE', '2': 1},
    {'1': 'INTEROP_MERGE_STRATEGY_APPEND', '2': 2},
    {'1': 'INTEROP_MERGE_STRATEGY_UPSERT', '2': 3},
  ],
};

/// Descriptor for `InteropMergeStrategy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List interopMergeStrategyDescriptor = $convert.base64Decode(
    'ChRJbnRlcm9wTWVyZ2VTdHJhdGVneRImCiJJTlRFUk9QX01FUkdFX1NUUkFURUdZX1VOU1BFQ0'
    'lGSUVEEAASIgoeSU5URVJPUF9NRVJHRV9TVFJBVEVHWV9SRVBMQUNFEAESIQodSU5URVJPUF9N'
    'RVJHRV9TVFJBVEVHWV9BUFBFTkQQAhIhCh1JTlRFUk9QX01FUkdFX1NUUkFURUdZX1VQU0VSVB'
    'AD');

@$core.Deprecated('Use plotOutputFormatDescriptor instead')
const PlotOutputFormat$json = {
  '1': 'PlotOutputFormat',
  '2': [
    {'1': 'PLOT_OUTPUT_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'PLOT_OUTPUT_FORMAT_SVG', '2': 1},
    {'1': 'PLOT_OUTPUT_FORMAT_PDF', '2': 2},
  ],
};

/// Descriptor for `PlotOutputFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List plotOutputFormatDescriptor = $convert.base64Decode(
    'ChBQbG90T3V0cHV0Rm9ybWF0EiIKHlBMT1RfT1VUUFVUX0ZPUk1BVF9VTlNQRUNJRklFRBAAEh'
    'oKFlBMT1RfT1VUUFVUX0ZPUk1BVF9TVkcQARIaChZQTE9UX09VVFBVVF9GT1JNQVRfUERGEAI=');

@$core.Deprecated('Use layerRefDescriptor instead')
const LayerRef$json = {
  '1': 'LayerRef',
  '2': [
    {'1': 'layer_id', '3': 1, '4': 1, '5': 9, '10': 'layerId'},
    {'1': 'layer_name', '3': 2, '4': 1, '5': 9, '10': 'layerName'},
  ],
};

/// Descriptor for `LayerRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layerRefDescriptor = $convert.base64Decode(
    'CghMYXllclJlZhIZCghsYXllcl9pZBgBIAEoCVIHbGF5ZXJJZBIdCgpsYXllcl9uYW1lGAIgAS'
    'gJUglsYXllck5hbWU=');

@$core.Deprecated('Use styleRefDescriptor instead')
const StyleRef$json = {
  '1': 'StyleRef',
  '2': [
    {'1': 'style_id', '3': 1, '4': 1, '5': 9, '10': 'styleId'},
    {'1': 'style_name', '3': 2, '4': 1, '5': 9, '10': 'styleName'},
  ],
};

/// Descriptor for `StyleRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List styleRefDescriptor = $convert.base64Decode(
    'CghTdHlsZVJlZhIZCghzdHlsZV9pZBgBIAEoCVIHc3R5bGVJZBIdCgpzdHlsZV9uYW1lGAIgAS'
    'gJUglzdHlsZU5hbWU=');

@$core.Deprecated('Use entityHeaderDescriptor instead')
const EntityHeader$json = {
  '1': 'EntityHeader',
  '2': [
    {'1': 'entity_id', '3': 1, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'drawing_id', '3': 2, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'entity_type', '3': 3, '4': 1, '5': 14, '6': '.drawing.v1.DrawingEntityType', '10': 'entityType'},
    {'1': 'layer', '3': 4, '4': 1, '5': 11, '6': '.drawing.v1.LayerRef', '10': 'layer'},
    {'1': 'style', '3': 5, '4': 1, '5': 11, '6': '.drawing.v1.StyleRef', '10': 'style'},
    {'1': 'metadata_json', '3': 6, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'contract', '3': 9, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `EntityHeader`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHeaderDescriptor = $convert.base64Decode(
    'CgxFbnRpdHlIZWFkZXISGwoJZW50aXR5X2lkGAEgASgJUghlbnRpdHlJZBIdCgpkcmF3aW5nX2'
    'lkGAIgASgJUglkcmF3aW5nSWQSPgoLZW50aXR5X3R5cGUYAyABKA4yHS5kcmF3aW5nLnYxLkRy'
    'YXdpbmdFbnRpdHlUeXBlUgplbnRpdHlUeXBlEioKBWxheWVyGAQgASgLMhQuZHJhd2luZy52MS'
    '5MYXllclJlZlIFbGF5ZXISKgoFc3R5bGUYBSABKAsyFC5kcmF3aW5nLnYxLlN0eWxlUmVmUgVz'
    'dHlsZRIjCg1tZXRhZGF0YV9qc29uGAYgASgJUgxtZXRhZGF0YUpzb24SOQoKY3JlYXRlZF9hdB'
    'gHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVk'
    'X2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EjcKCGNvbn'
    'RyYWN0GAkgASgLMhsuY29tbW9uLnYxLkNvbnRyYWN0TWV0YWRhdGFSCGNvbnRyYWN0');

@$core.Deprecated('Use polylineEntityDescriptor instead')
const PolylineEntity$json = {
  '1': 'PolylineEntity',
  '2': [
    {'1': 'vertices', '3': 1, '4': 3, '5': 11, '6': '.common.v1.Point2D', '10': 'vertices'},
    {'1': 'closed', '3': 2, '4': 1, '5': 8, '10': 'closed'},
  ],
};

/// Descriptor for `PolylineEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List polylineEntityDescriptor = $convert.base64Decode(
    'Cg5Qb2x5bGluZUVudGl0eRIuCgh2ZXJ0aWNlcxgBIAMoCzISLmNvbW1vbi52MS5Qb2ludDJEUg'
    'h2ZXJ0aWNlcxIWCgZjbG9zZWQYAiABKAhSBmNsb3NlZA==');

@$core.Deprecated('Use polygonEntityDescriptor instead')
const PolygonEntity$json = {
  '1': 'PolygonEntity',
  '2': [
    {'1': 'geometry', '3': 1, '4': 1, '5': 11, '6': '.common.v1.Polygon2D', '10': 'geometry'},
  ],
};

/// Descriptor for `PolygonEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List polygonEntityDescriptor = $convert.base64Decode(
    'Cg1Qb2x5Z29uRW50aXR5EjAKCGdlb21ldHJ5GAEgASgLMhQuY29tbW9uLnYxLlBvbHlnb24yRF'
    'IIZ2VvbWV0cnk=');

@$core.Deprecated('Use textEntityDescriptor instead')
const TextEntity$json = {
  '1': 'TextEntity',
  '2': [
    {'1': 'anchor', '3': 1, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'anchor'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'rotation_deg', '3': 3, '4': 1, '5': 1, '10': 'rotationDeg'},
    {'1': 'height', '3': 4, '4': 1, '5': 1, '10': 'height'},
    {'1': 'font_family', '3': 5, '4': 1, '5': 9, '10': 'fontFamily'},
  ],
};

/// Descriptor for `TextEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textEntityDescriptor = $convert.base64Decode(
    'CgpUZXh0RW50aXR5EioKBmFuY2hvchgBIAEoCzISLmNvbW1vbi52MS5Qb2ludDJEUgZhbmNob3'
    'ISEgoEdGV4dBgCIAEoCVIEdGV4dBIhCgxyb3RhdGlvbl9kZWcYAyABKAFSC3JvdGF0aW9uRGVn'
    'EhYKBmhlaWdodBgEIAEoAVIGaGVpZ2h0Eh8KC2ZvbnRfZmFtaWx5GAUgASgJUgpmb250RmFtaW'
    'x5');

@$core.Deprecated('Use dimensionEntityDescriptor instead')
const DimensionEntity$json = {
  '1': 'DimensionEntity',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'end'},
    {'1': 'text_anchor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'textAnchor'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'precision', '3': 5, '4': 1, '5': 1, '10': 'precision'},
  ],
};

/// Descriptor for `DimensionEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dimensionEntityDescriptor = $convert.base64Decode(
    'Cg9EaW1lbnNpb25FbnRpdHkSKAoFc3RhcnQYASABKAsyEi5jb21tb24udjEuUG9pbnQyRFIFc3'
    'RhcnQSJAoDZW5kGAIgASgLMhIuY29tbW9uLnYxLlBvaW50MkRSA2VuZBIzCgt0ZXh0X2FuY2hv'
    'chgDIAEoCzISLmNvbW1vbi52MS5Qb2ludDJEUgp0ZXh0QW5jaG9yEhIKBHVuaXQYBCABKAlSBH'
    'VuaXQSHAoJcHJlY2lzaW9uGAUgASgBUglwcmVjaXNpb24=');

@$core.Deprecated('Use blockReferenceEntityDescriptor instead')
const BlockReferenceEntity$json = {
  '1': 'BlockReferenceEntity',
  '2': [
    {'1': 'block_definition_id', '3': 1, '4': 1, '5': 9, '10': 'blockDefinitionId'},
    {'1': 'insertion_point', '3': 2, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'insertionPoint'},
    {'1': 'rotation_deg', '3': 3, '4': 1, '5': 1, '10': 'rotationDeg'},
    {'1': 'scale_x', '3': 4, '4': 1, '5': 1, '10': 'scaleX'},
    {'1': 'scale_y', '3': 5, '4': 1, '5': 1, '10': 'scaleY'},
    {'1': 'attributes', '3': 6, '4': 3, '5': 11, '6': '.drawing.v1.BlockReferenceEntity.AttributesEntry', '10': 'attributes'},
  ],
  '3': [BlockReferenceEntity_AttributesEntry$json],
};

@$core.Deprecated('Use blockReferenceEntityDescriptor instead')
const BlockReferenceEntity_AttributesEntry$json = {
  '1': 'AttributesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `BlockReferenceEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockReferenceEntityDescriptor = $convert.base64Decode(
    'ChRCbG9ja1JlZmVyZW5jZUVudGl0eRIuChNibG9ja19kZWZpbml0aW9uX2lkGAEgASgJUhFibG'
    '9ja0RlZmluaXRpb25JZBI7Cg9pbnNlcnRpb25fcG9pbnQYAiABKAsyEi5jb21tb24udjEuUG9p'
    'bnQyRFIOaW5zZXJ0aW9uUG9pbnQSIQoMcm90YXRpb25fZGVnGAMgASgBUgtyb3RhdGlvbkRlZx'
    'IXCgdzY2FsZV94GAQgASgBUgZzY2FsZVgSFwoHc2NhbGVfeRgFIAEoAVIGc2NhbGVZElAKCmF0'
    'dHJpYnV0ZXMYBiADKAsyMC5kcmF3aW5nLnYxLkJsb2NrUmVmZXJlbmNlRW50aXR5LkF0dHJpYn'
    'V0ZXNFbnRyeVIKYXR0cmlidXRlcxo9Cg9BdHRyaWJ1dGVzRW50cnkSEAoDa2V5GAEgASgJUgNr'
    'ZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use layerDefinitionEntityDescriptor instead')
const LayerDefinitionEntity$json = {
  '1': 'LayerDefinitionEntity',
  '2': [
    {'1': 'layer_id', '3': 1, '4': 1, '5': 9, '10': 'layerId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'color_hex', '3': 3, '4': 1, '5': 9, '10': 'colorHex'},
    {'1': 'line_type', '3': 4, '4': 1, '5': 9, '10': 'lineType'},
    {'1': 'line_weight_mm', '3': 5, '4': 1, '5': 1, '10': 'lineWeightMm'},
    {'1': 'visible', '3': 6, '4': 1, '5': 8, '10': 'visible'},
    {'1': 'locked', '3': 7, '4': 1, '5': 8, '10': 'locked'},
    {'1': 'plottable', '3': 8, '4': 1, '5': 8, '10': 'plottable'},
  ],
};

/// Descriptor for `LayerDefinitionEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layerDefinitionEntityDescriptor = $convert.base64Decode(
    'ChVMYXllckRlZmluaXRpb25FbnRpdHkSGQoIbGF5ZXJfaWQYASABKAlSB2xheWVySWQSEgoEbm'
    'FtZRgCIAEoCVIEbmFtZRIbCgljb2xvcl9oZXgYAyABKAlSCGNvbG9ySGV4EhsKCWxpbmVfdHlw'
    'ZRgEIAEoCVIIbGluZVR5cGUSJAoObGluZV93ZWlnaHRfbW0YBSABKAFSDGxpbmVXZWlnaHRNbR'
    'IYCgd2aXNpYmxlGAYgASgIUgd2aXNpYmxlEhYKBmxvY2tlZBgHIAEoCFIGbG9ja2VkEhwKCXBs'
    'b3R0YWJsZRgIIAEoCFIJcGxvdHRhYmxl');

@$core.Deprecated('Use blockDefinitionEntityDescriptor instead')
const BlockDefinitionEntity$json = {
  '1': 'BlockDefinitionEntity',
  '2': [
    {'1': 'block_definition_id', '3': 1, '4': 1, '5': 9, '10': 'blockDefinitionId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'base_point', '3': 3, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'basePoint'},
    {'1': 'entities', '3': 4, '4': 3, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'entities'},
    {'1': 'default_attributes', '3': 5, '4': 3, '5': 11, '6': '.drawing.v1.BlockDefinitionEntity.DefaultAttributesEntry', '10': 'defaultAttributes'},
  ],
  '3': [BlockDefinitionEntity_DefaultAttributesEntry$json],
};

@$core.Deprecated('Use blockDefinitionEntityDescriptor instead')
const BlockDefinitionEntity_DefaultAttributesEntry$json = {
  '1': 'DefaultAttributesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `BlockDefinitionEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockDefinitionEntityDescriptor = $convert.base64Decode(
    'ChVCbG9ja0RlZmluaXRpb25FbnRpdHkSLgoTYmxvY2tfZGVmaW5pdGlvbl9pZBgBIAEoCVIRYm'
    'xvY2tEZWZpbml0aW9uSWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIxCgpiYXNlX3BvaW50GAMgASgL'
    'MhIuY29tbW9uLnYxLlBvaW50MkRSCWJhc2VQb2ludBI1CghlbnRpdGllcxgEIAMoCzIZLmRyYX'
    'dpbmcudjEuRHJhd2luZ0VudGl0eVIIZW50aXRpZXMSZwoSZGVmYXVsdF9hdHRyaWJ1dGVzGAUg'
    'AygLMjguZHJhd2luZy52MS5CbG9ja0RlZmluaXRpb25FbnRpdHkuRGVmYXVsdEF0dHJpYnV0ZX'
    'NFbnRyeVIRZGVmYXVsdEF0dHJpYnV0ZXMaRAoWRGVmYXVsdEF0dHJpYnV0ZXNFbnRyeRIQCgNr'
    'ZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use leaderEntityDescriptor instead')
const LeaderEntity$json = {
  '1': 'LeaderEntity',
  '2': [
    {'1': 'vertices', '3': 1, '4': 3, '5': 11, '6': '.common.v1.Point2D', '10': 'vertices'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'text_height', '3': 3, '4': 1, '5': 1, '10': 'textHeight'},
    {'1': 'arrow_head', '3': 4, '4': 1, '5': 9, '10': 'arrowHead'},
  ],
};

/// Descriptor for `LeaderEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaderEntityDescriptor = $convert.base64Decode(
    'CgxMZWFkZXJFbnRpdHkSLgoIdmVydGljZXMYASADKAsyEi5jb21tb24udjEuUG9pbnQyRFIIdm'
    'VydGljZXMSEgoEdGV4dBgCIAEoCVIEdGV4dBIfCgt0ZXh0X2hlaWdodBgDIAEoAVIKdGV4dEhl'
    'aWdodBIdCgphcnJvd19oZWFkGAQgASgJUglhcnJvd0hlYWQ=');

@$core.Deprecated('Use sheetEntityDescriptor instead')
const SheetEntity$json = {
  '1': 'SheetEntity',
  '2': [
    {'1': 'sheet_id', '3': 1, '4': 1, '5': 9, '10': 'sheetId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'page_width_mm', '3': 3, '4': 1, '5': 1, '10': 'pageWidthMm'},
    {'1': 'page_height_mm', '3': 4, '4': 1, '5': 1, '10': 'pageHeightMm'},
    {'1': 'view_scale', '3': 5, '4': 1, '5': 1, '10': 'viewScale'},
    {'1': 'viewport_entity_ids', '3': 6, '4': 3, '5': 9, '10': 'viewportEntityIds'},
    {'1': 'title_block_name', '3': 7, '4': 1, '5': 9, '10': 'titleBlockName'},
    {'1': 'metadata_json', '3': 8, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `SheetEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sheetEntityDescriptor = $convert.base64Decode(
    'CgtTaGVldEVudGl0eRIZCghzaGVldF9pZBgBIAEoCVIHc2hlZXRJZBIUCgV0aXRsZRgCIAEoCV'
    'IFdGl0bGUSIgoNcGFnZV93aWR0aF9tbRgDIAEoAVILcGFnZVdpZHRoTW0SJAoOcGFnZV9oZWln'
    'aHRfbW0YBCABKAFSDHBhZ2VIZWlnaHRNbRIdCgp2aWV3X3NjYWxlGAUgASgBUgl2aWV3U2NhbG'
    'USLgoTdmlld3BvcnRfZW50aXR5X2lkcxgGIAMoCVIRdmlld3BvcnRFbnRpdHlJZHMSKAoQdGl0'
    'bGVfYmxvY2tfbmFtZRgHIAEoCVIOdGl0bGVCbG9ja05hbWUSIwoNbWV0YWRhdGFfanNvbhgIIA'
    'EoCVIMbWV0YWRhdGFKc29u');

@$core.Deprecated('Use drawingEntityDescriptor instead')
const DrawingEntity$json = {
  '1': 'DrawingEntity',
  '2': [
    {'1': 'header', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.EntityHeader', '10': 'header'},
    {'1': 'polyline', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.PolylineEntity', '9': 0, '10': 'polyline'},
    {'1': 'polygon', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.PolygonEntity', '9': 0, '10': 'polygon'},
    {'1': 'text', '3': 4, '4': 1, '5': 11, '6': '.drawing.v1.TextEntity', '9': 0, '10': 'text'},
    {'1': 'dimension', '3': 5, '4': 1, '5': 11, '6': '.drawing.v1.DimensionEntity', '9': 0, '10': 'dimension'},
    {'1': 'block_reference', '3': 6, '4': 1, '5': 11, '6': '.drawing.v1.BlockReferenceEntity', '9': 0, '10': 'blockReference'},
    {'1': 'layer_definition', '3': 7, '4': 1, '5': 11, '6': '.drawing.v1.LayerDefinitionEntity', '9': 0, '10': 'layerDefinition'},
    {'1': 'block_definition', '3': 8, '4': 1, '5': 11, '6': '.drawing.v1.BlockDefinitionEntity', '9': 0, '10': 'blockDefinition'},
    {'1': 'leader', '3': 9, '4': 1, '5': 11, '6': '.drawing.v1.LeaderEntity', '9': 0, '10': 'leader'},
    {'1': 'sheet', '3': 10, '4': 1, '5': 11, '6': '.drawing.v1.SheetEntity', '9': 0, '10': 'sheet'},
  ],
  '8': [
    {'1': 'geometry'},
  ],
};

/// Descriptor for `DrawingEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List drawingEntityDescriptor = $convert.base64Decode(
    'Cg1EcmF3aW5nRW50aXR5EjAKBmhlYWRlchgBIAEoCzIYLmRyYXdpbmcudjEuRW50aXR5SGVhZG'
    'VyUgZoZWFkZXISOAoIcG9seWxpbmUYAiABKAsyGi5kcmF3aW5nLnYxLlBvbHlsaW5lRW50aXR5'
    'SABSCHBvbHlsaW5lEjUKB3BvbHlnb24YAyABKAsyGS5kcmF3aW5nLnYxLlBvbHlnb25FbnRpdH'
    'lIAFIHcG9seWdvbhIsCgR0ZXh0GAQgASgLMhYuZHJhd2luZy52MS5UZXh0RW50aXR5SABSBHRl'
    'eHQSOwoJZGltZW5zaW9uGAUgASgLMhsuZHJhd2luZy52MS5EaW1lbnNpb25FbnRpdHlIAFIJZG'
    'ltZW5zaW9uEksKD2Jsb2NrX3JlZmVyZW5jZRgGIAEoCzIgLmRyYXdpbmcudjEuQmxvY2tSZWZl'
    'cmVuY2VFbnRpdHlIAFIOYmxvY2tSZWZlcmVuY2USTgoQbGF5ZXJfZGVmaW5pdGlvbhgHIAEoCz'
    'IhLmRyYXdpbmcudjEuTGF5ZXJEZWZpbml0aW9uRW50aXR5SABSD2xheWVyRGVmaW5pdGlvbhJO'
    'ChBibG9ja19kZWZpbml0aW9uGAggASgLMiEuZHJhd2luZy52MS5CbG9ja0RlZmluaXRpb25Fbn'
    'RpdHlIAFIPYmxvY2tEZWZpbml0aW9uEjIKBmxlYWRlchgJIAEoCzIYLmRyYXdpbmcudjEuTGVh'
    'ZGVyRW50aXR5SABSBmxlYWRlchIvCgVzaGVldBgKIAEoCzIXLmRyYXdpbmcudjEuU2hlZXRFbn'
    'RpdHlIAFIFc2hlZXRCCgoIZ2VvbWV0cnk=');

@$core.Deprecated('Use revisionPointerDescriptor instead')
const RevisionPointer$json = {
  '1': 'RevisionPointer',
  '2': [
    {'1': 'revision_id', '3': 1, '4': 1, '5': 9, '10': 'revisionId'},
    {'1': 'parent_revision_id', '3': 2, '4': 1, '5': 9, '10': 'parentRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'committed_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'committedAt'},
    {'1': 'contract', '3': 6, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `RevisionPointer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revisionPointerDescriptor = $convert.base64Decode(
    'Cg9SZXZpc2lvblBvaW50ZXISHwoLcmV2aXNpb25faWQYASABKAlSCnJldmlzaW9uSWQSLAoScG'
    'FyZW50X3JldmlzaW9uX2lkGAIgASgJUhBwYXJlbnRSZXZpc2lvbklkEhYKBmF1dGhvchgDIAEo'
    'CVIGYXV0aG9yEhgKB3N1bW1hcnkYBCABKAlSB3N1bW1hcnkSPQoMY29tbWl0dGVkX2F0GAUgAS'
    'gLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29tbWl0dGVkQXQSNwoIY29udHJhY3QY'
    'BiABKAsyGy5jb21tb24udjEuQ29udHJhY3RNZXRhZGF0YVIIY29udHJhY3Q=');

@$core.Deprecated('Use drawingMutationDescriptor instead')
const DrawingMutation$json = {
  '1': 'DrawingMutation',
  '2': [
    {'1': 'action', '3': 1, '4': 1, '5': 14, '6': '.drawing.v1.RevisionAction', '10': 'action'},
    {'1': 'entity_id', '3': 2, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'before', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'before'},
    {'1': 'after', '3': 4, '4': 1, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'after'},
  ],
};

/// Descriptor for `DrawingMutation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List drawingMutationDescriptor = $convert.base64Decode(
    'Cg9EcmF3aW5nTXV0YXRpb24SMgoGYWN0aW9uGAEgASgOMhouZHJhd2luZy52MS5SZXZpc2lvbk'
    'FjdGlvblIGYWN0aW9uEhsKCWVudGl0eV9pZBgCIAEoCVIIZW50aXR5SWQSMQoGYmVmb3JlGAMg'
    'ASgLMhkuZHJhd2luZy52MS5EcmF3aW5nRW50aXR5UgZiZWZvcmUSLwoFYWZ0ZXIYBCABKAsyGS'
    '5kcmF3aW5nLnYxLkRyYXdpbmdFbnRpdHlSBWFmdGVy');

@$core.Deprecated('Use drawingCommandDescriptor instead')
const DrawingCommand$json = {
  '1': 'DrawingCommand',
  '2': [
    {'1': 'command_id', '3': 1, '4': 1, '5': 9, '10': 'commandId'},
    {'1': 'drawing_id', '3': 2, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'actor', '3': 3, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'mutations', '3': 4, '4': 3, '5': 11, '6': '.drawing.v1.DrawingMutation', '10': 'mutations'},
    {'1': 'issued_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'issuedAt'},
    {'1': 'contract', '3': 6, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `DrawingCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List drawingCommandDescriptor = $convert.base64Decode(
    'Cg5EcmF3aW5nQ29tbWFuZBIdCgpjb21tYW5kX2lkGAEgASgJUgljb21tYW5kSWQSHQoKZHJhd2'
    'luZ19pZBgCIAEoCVIJZHJhd2luZ0lkEhQKBWFjdG9yGAMgASgJUgVhY3RvchI5CgltdXRhdGlv'
    'bnMYBCADKAsyGy5kcmF3aW5nLnYxLkRyYXdpbmdNdXRhdGlvblIJbXV0YXRpb25zEjcKCWlzc3'
    'VlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGlzc3VlZEF0EjcKCGNv'
    'bnRyYWN0GAYgASgLMhsuY29tbW9uLnYxLkNvbnRyYWN0TWV0YWRhdGFSCGNvbnRyYWN0');

@$core.Deprecated('Use drawingDescriptor instead')
const Drawing$json = {
  '1': 'Drawing',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'metadata_json', '3': 5, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.drawing.v1.DrawingStatus', '10': 'status'},
    {'1': 'current_revision_id', '3': 7, '4': 1, '5': 9, '10': 'currentRevisionId'},
    {'1': 'revision_count', '3': 8, '4': 1, '5': 13, '10': 'revisionCount'},
    {'1': 'entity_count', '3': 9, '4': 1, '5': 13, '10': 'entityCount'},
    {'1': 'created_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'contract', '3': 12, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `Drawing`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List drawingDescriptor = $convert.base64Decode(
    'CgdEcmF3aW5nEh0KCmRyYXdpbmdfaWQYASABKAlSCWRyYXdpbmdJZBIdCgpwcm9qZWN0X2lkGA'
    'IgASgJUglwcm9qZWN0SWQSEgoEbmFtZRgDIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgEIAEo'
    'CVILZGVzY3JpcHRpb24SIwoNbWV0YWRhdGFfanNvbhgFIAEoCVIMbWV0YWRhdGFKc29uEjEKBn'
    'N0YXR1cxgGIAEoDjIZLmRyYXdpbmcudjEuRHJhd2luZ1N0YXR1c1IGc3RhdHVzEi4KE2N1cnJl'
    'bnRfcmV2aXNpb25faWQYByABKAlSEWN1cnJlbnRSZXZpc2lvbklkEiUKDnJldmlzaW9uX2NvdW'
    '50GAggASgNUg1yZXZpc2lvbkNvdW50EiEKDGVudGl0eV9jb3VudBgJIAEoDVILZW50aXR5Q291'
    'bnQSOQoKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZW'
    'F0ZWRBdBI5Cgp1cGRhdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJ'
    'dXBkYXRlZEF0EjcKCGNvbnRyYWN0GAwgASgLMhsuY29tbW9uLnYxLkNvbnRyYWN0TWV0YWRhdG'
    'FSCGNvbnRyYWN0');

@$core.Deprecated('Use drawingRevisionDescriptor instead')
const DrawingRevision$json = {
  '1': 'DrawingRevision',
  '2': [
    {'1': 'pointer', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.RevisionPointer', '10': 'pointer'},
    {'1': 'drawing_id', '3': 2, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'command_id', '3': 3, '4': 1, '5': 9, '10': 'commandId'},
    {'1': 'entities', '3': 4, '4': 3, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'entities'},
  ],
};

/// Descriptor for `DrawingRevision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List drawingRevisionDescriptor = $convert.base64Decode(
    'Cg9EcmF3aW5nUmV2aXNpb24SNQoHcG9pbnRlchgBIAEoCzIbLmRyYXdpbmcudjEuUmV2aXNpb2'
    '5Qb2ludGVyUgdwb2ludGVyEh0KCmRyYXdpbmdfaWQYAiABKAlSCWRyYXdpbmdJZBIdCgpjb21t'
    'YW5kX2lkGAMgASgJUgljb21tYW5kSWQSNQoIZW50aXRpZXMYBCADKAsyGS5kcmF3aW5nLnYxLk'
    'RyYXdpbmdFbnRpdHlSCGVudGl0aWVz');

@$core.Deprecated('Use createDrawingRequestDescriptor instead')
const CreateDrawingRequest$json = {
  '1': 'CreateDrawingRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'metadata_json', '3': 4, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'author', '3': 5, '4': 1, '5': 9, '10': 'author'},
    {'1': 'contract', '3': 6, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `CreateDrawingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDrawingRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVEcmF3aW5nUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSEg'
    'oEbmFtZRgCIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SIwoN'
    'bWV0YWRhdGFfanNvbhgEIAEoCVIMbWV0YWRhdGFKc29uEhYKBmF1dGhvchgFIAEoCVIGYXV0aG'
    '9yEjcKCGNvbnRyYWN0GAYgASgLMhsuY29tbW9uLnYxLkNvbnRyYWN0TWV0YWRhdGFSCGNvbnRy'
    'YWN0');

@$core.Deprecated('Use createDrawingResponseDescriptor instead')
const CreateDrawingResponse$json = {
  '1': 'CreateDrawingResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
  ],
};

/// Descriptor for `CreateDrawingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDrawingResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVEcmF3aW5nUmVzcG9uc2USLQoHZHJhd2luZxgBIAEoCzITLmRyYXdpbmcudjEuRH'
    'Jhd2luZ1IHZHJhd2luZxI3CghyZXZpc2lvbhgCIAEoCzIbLmRyYXdpbmcudjEuRHJhd2luZ1Jl'
    'dmlzaW9uUghyZXZpc2lvbg==');

@$core.Deprecated('Use getDrawingRequestDescriptor instead')
const GetDrawingRequest$json = {
  '1': 'GetDrawingRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
  ],
};

/// Descriptor for `GetDrawingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDrawingRequestDescriptor = $convert.base64Decode(
    'ChFHZXREcmF3aW5nUmVxdWVzdBIdCgpkcmF3aW5nX2lkGAEgASgJUglkcmF3aW5nSWQ=');

@$core.Deprecated('Use getDrawingResponseDescriptor instead')
const GetDrawingResponse$json = {
  '1': 'GetDrawingResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
  ],
};

/// Descriptor for `GetDrawingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDrawingResponseDescriptor = $convert.base64Decode(
    'ChJHZXREcmF3aW5nUmVzcG9uc2USLQoHZHJhd2luZxgBIAEoCzITLmRyYXdpbmcudjEuRHJhd2'
    'luZ1IHZHJhd2luZw==');

@$core.Deprecated('Use listDrawingsRequestDescriptor instead')
const ListDrawingsRequest$json = {
  '1': 'ListDrawingsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 13, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'include_archived', '3': 4, '4': 1, '5': 8, '10': 'includeArchived'},
  ],
};

/// Descriptor for `ListDrawingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDrawingsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0RHJhd2luZ3NSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBIbCg'
    'lwYWdlX3NpemUYAiABKA1SCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW4YAyABKAlSCXBhZ2VUb2tl'
    'bhIpChBpbmNsdWRlX2FyY2hpdmVkGAQgASgIUg9pbmNsdWRlQXJjaGl2ZWQ=');

@$core.Deprecated('Use listDrawingsResponseDescriptor instead')
const ListDrawingsResponse$json = {
  '1': 'ListDrawingsResponse',
  '2': [
    {'1': 'drawings', '3': 1, '4': 3, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawings'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 13, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListDrawingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDrawingsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0RHJhd2luZ3NSZXNwb25zZRIvCghkcmF3aW5ncxgBIAMoCzITLmRyYXdpbmcudjEuRH'
    'Jhd2luZ1IIZHJhd2luZ3MSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFnZVRva2Vu'
    'Eh8KC3RvdGFsX2NvdW50GAMgASgNUgp0b3RhbENvdW50');

@$core.Deprecated('Use updateDrawingRequestDescriptor instead')
const UpdateDrawingRequest$json = {
  '1': 'UpdateDrawingRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'metadata_json', '3': 4, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'status', '3': 5, '4': 1, '5': 14, '6': '.drawing.v1.DrawingStatus', '10': 'status'},
  ],
};

/// Descriptor for `UpdateDrawingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDrawingRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVEcmF3aW5nUmVxdWVzdBIdCgpkcmF3aW5nX2lkGAEgASgJUglkcmF3aW5nSWQSEg'
    'oEbmFtZRgCIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SIwoN'
    'bWV0YWRhdGFfanNvbhgEIAEoCVIMbWV0YWRhdGFKc29uEjEKBnN0YXR1cxgFIAEoDjIZLmRyYX'
    'dpbmcudjEuRHJhd2luZ1N0YXR1c1IGc3RhdHVz');

@$core.Deprecated('Use updateDrawingResponseDescriptor instead')
const UpdateDrawingResponse$json = {
  '1': 'UpdateDrawingResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
  ],
};

/// Descriptor for `UpdateDrawingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDrawingResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVEcmF3aW5nUmVzcG9uc2USLQoHZHJhd2luZxgBIAEoCzITLmRyYXdpbmcudjEuRH'
    'Jhd2luZ1IHZHJhd2luZw==');

@$core.Deprecated('Use getDrawingStateRequestDescriptor instead')
const GetDrawingStateRequest$json = {
  '1': 'GetDrawingStateRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'revision_id', '3': 2, '4': 1, '5': 9, '10': 'revisionId'},
  ],
};

/// Descriptor for `GetDrawingStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDrawingStateRequestDescriptor = $convert.base64Decode(
    'ChZHZXREcmF3aW5nU3RhdGVSZXF1ZXN0Eh0KCmRyYXdpbmdfaWQYASABKAlSCWRyYXdpbmdJZB'
    'IfCgtyZXZpc2lvbl9pZBgCIAEoCVIKcmV2aXNpb25JZA==');

@$core.Deprecated('Use getDrawingStateResponseDescriptor instead')
const GetDrawingStateResponse$json = {
  '1': 'GetDrawingStateResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
  ],
};

/// Descriptor for `GetDrawingStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDrawingStateResponseDescriptor = $convert.base64Decode(
    'ChdHZXREcmF3aW5nU3RhdGVSZXNwb25zZRItCgdkcmF3aW5nGAEgASgLMhMuZHJhd2luZy52MS'
    '5EcmF3aW5nUgdkcmF3aW5nEjcKCHJldmlzaW9uGAIgASgLMhsuZHJhd2luZy52MS5EcmF3aW5n'
    'UmV2aXNpb25SCHJldmlzaW9u');

@$core.Deprecated('Use listDrawingRevisionsRequestDescriptor instead')
const ListDrawingRevisionsRequest$json = {
  '1': 'ListDrawingRevisionsRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 13, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListDrawingRevisionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDrawingRevisionsRequestDescriptor = $convert.base64Decode(
    'ChtMaXN0RHJhd2luZ1JldmlzaW9uc1JlcXVlc3QSHQoKZHJhd2luZ19pZBgBIAEoCVIJZHJhd2'
    'luZ0lkEhsKCXBhZ2Vfc2l6ZRgCIAEoDVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgDIAEoCVIJ'
    'cGFnZVRva2Vu');

@$core.Deprecated('Use listDrawingRevisionsResponseDescriptor instead')
const ListDrawingRevisionsResponse$json = {
  '1': 'ListDrawingRevisionsResponse',
  '2': [
    {'1': 'revisions', '3': 1, '4': 3, '5': 11, '6': '.drawing.v1.RevisionPointer', '10': 'revisions'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 13, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListDrawingRevisionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDrawingRevisionsResponseDescriptor = $convert.base64Decode(
    'ChxMaXN0RHJhd2luZ1JldmlzaW9uc1Jlc3BvbnNlEjkKCXJldmlzaW9ucxgBIAMoCzIbLmRyYX'
    'dpbmcudjEuUmV2aXNpb25Qb2ludGVyUglyZXZpc2lvbnMSJgoPbmV4dF9wYWdlX3Rva2VuGAIg'
    'ASgJUg1uZXh0UGFnZVRva2VuEh8KC3RvdGFsX2NvdW50GAMgASgNUgp0b3RhbENvdW50');

@$core.Deprecated('Use getDrawingRevisionRequestDescriptor instead')
const GetDrawingRevisionRequest$json = {
  '1': 'GetDrawingRevisionRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'revision_id', '3': 2, '4': 1, '5': 9, '10': 'revisionId'},
  ],
};

/// Descriptor for `GetDrawingRevisionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDrawingRevisionRequestDescriptor = $convert.base64Decode(
    'ChlHZXREcmF3aW5nUmV2aXNpb25SZXF1ZXN0Eh0KCmRyYXdpbmdfaWQYASABKAlSCWRyYXdpbm'
    'dJZBIfCgtyZXZpc2lvbl9pZBgCIAEoCVIKcmV2aXNpb25JZA==');

@$core.Deprecated('Use getDrawingRevisionResponseDescriptor instead')
const GetDrawingRevisionResponse$json = {
  '1': 'GetDrawingRevisionResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
  ],
};

/// Descriptor for `GetDrawingRevisionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDrawingRevisionResponseDescriptor = $convert.base64Decode(
    'ChpHZXREcmF3aW5nUmV2aXNpb25SZXNwb25zZRItCgdkcmF3aW5nGAEgASgLMhMuZHJhd2luZy'
    '52MS5EcmF3aW5nUgdkcmF3aW5nEjcKCHJldmlzaW9uGAIgASgLMhsuZHJhd2luZy52MS5EcmF3'
    'aW5nUmV2aXNpb25SCHJldmlzaW9u');

@$core.Deprecated('Use storeDrawingRevisionRequestDescriptor instead')
const StoreDrawingRevisionRequest$json = {
  '1': 'StoreDrawingRevisionRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'author', '3': 2, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 3, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'command_id', '3': 4, '4': 1, '5': 9, '10': 'commandId'},
    {'1': 'entities', '3': 5, '4': 3, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'entities'},
    {'1': 'contract', '3': 6, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `StoreDrawingRevisionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeDrawingRevisionRequestDescriptor = $convert.base64Decode(
    'ChtTdG9yZURyYXdpbmdSZXZpc2lvblJlcXVlc3QSHQoKZHJhd2luZ19pZBgBIAEoCVIJZHJhd2'
    'luZ0lkEhYKBmF1dGhvchgCIAEoCVIGYXV0aG9yEhgKB3N1bW1hcnkYAyABKAlSB3N1bW1hcnkS'
    'HQoKY29tbWFuZF9pZBgEIAEoCVIJY29tbWFuZElkEjUKCGVudGl0aWVzGAUgAygLMhkuZHJhd2'
    'luZy52MS5EcmF3aW5nRW50aXR5UghlbnRpdGllcxI3Cghjb250cmFjdBgGIAEoCzIbLmNvbW1v'
    'bi52MS5Db250cmFjdE1ldGFkYXRhUghjb250cmFjdA==');

@$core.Deprecated('Use storeDrawingRevisionResponseDescriptor instead')
const StoreDrawingRevisionResponse$json = {
  '1': 'StoreDrawingRevisionResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
  ],
};

/// Descriptor for `StoreDrawingRevisionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeDrawingRevisionResponseDescriptor = $convert.base64Decode(
    'ChxTdG9yZURyYXdpbmdSZXZpc2lvblJlc3BvbnNlEi0KB2RyYXdpbmcYASABKAsyEy5kcmF3aW'
    '5nLnYxLkRyYXdpbmdSB2RyYXdpbmcSNwoIcmV2aXNpb24YAiABKAsyGy5kcmF3aW5nLnYxLkRy'
    'YXdpbmdSZXZpc2lvblIIcmV2aXNpb24=');

@$core.Deprecated('Use validateDrawingCommandRequestDescriptor instead')
const ValidateDrawingCommandRequest$json = {
  '1': 'ValidateDrawingCommandRequest',
  '2': [
    {'1': 'command', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.DrawingCommand', '10': 'command'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
  ],
};

/// Descriptor for `ValidateDrawingCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateDrawingCommandRequestDescriptor = $convert.base64Decode(
    'Ch1WYWxpZGF0ZURyYXdpbmdDb21tYW5kUmVxdWVzdBI0Cgdjb21tYW5kGAEgASgLMhouZHJhd2'
    'luZy52MS5EcmF3aW5nQ29tbWFuZFIHY29tbWFuZBIoChBiYXNlX3JldmlzaW9uX2lkGAIgASgJ'
    'Ug5iYXNlUmV2aXNpb25JZA==');

@$core.Deprecated('Use validateDrawingCommandResponseDescriptor instead')
const ValidateDrawingCommandResponse$json = {
  '1': 'ValidateDrawingCommandResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'violations', '3': 2, '4': 3, '5': 9, '10': 'violations'},
    {'1': 'resulting_entities', '3': 3, '4': 3, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'resultingEntities'},
  ],
};

/// Descriptor for `ValidateDrawingCommandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateDrawingCommandResponseDescriptor = $convert.base64Decode(
    'Ch5WYWxpZGF0ZURyYXdpbmdDb21tYW5kUmVzcG9uc2USFAoFdmFsaWQYASABKAhSBXZhbGlkEh'
    '4KCnZpb2xhdGlvbnMYAiADKAlSCnZpb2xhdGlvbnMSSAoScmVzdWx0aW5nX2VudGl0aWVzGAMg'
    'AygLMhkuZHJhd2luZy52MS5EcmF3aW5nRW50aXR5UhFyZXN1bHRpbmdFbnRpdGllcw==');

@$core.Deprecated('Use commitDrawingCommandRequestDescriptor instead')
const CommitDrawingCommandRequest$json = {
  '1': 'CommitDrawingCommandRequest',
  '2': [
    {'1': 'command', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.DrawingCommand', '10': 'command'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'summary', '3': 3, '4': 1, '5': 9, '10': 'summary'},
  ],
};

/// Descriptor for `CommitDrawingCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commitDrawingCommandRequestDescriptor = $convert.base64Decode(
    'ChtDb21taXREcmF3aW5nQ29tbWFuZFJlcXVlc3QSNAoHY29tbWFuZBgBIAEoCzIaLmRyYXdpbm'
    'cudjEuRHJhd2luZ0NvbW1hbmRSB2NvbW1hbmQSKAoQYmFzZV9yZXZpc2lvbl9pZBgCIAEoCVIO'
    'YmFzZVJldmlzaW9uSWQSGAoHc3VtbWFyeRgDIAEoCVIHc3VtbWFyeQ==');

@$core.Deprecated('Use commitDrawingCommandResponseDescriptor instead')
const CommitDrawingCommandResponse$json = {
  '1': 'CommitDrawingCommandResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
  ],
};

/// Descriptor for `CommitDrawingCommandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commitDrawingCommandResponseDescriptor = $convert.base64Decode(
    'ChxDb21taXREcmF3aW5nQ29tbWFuZFJlc3BvbnNlEi0KB2RyYXdpbmcYASABKAsyEy5kcmF3aW'
    '5nLnYxLkRyYXdpbmdSB2RyYXdpbmcSNwoIcmV2aXNpb24YAiABKAsyGy5kcmF3aW5nLnYxLkRy'
    'YXdpbmdSZXZpc2lvblIIcmV2aXNpb24=');

@$core.Deprecated('Use revertDrawingRevisionRequestDescriptor instead')
const RevertDrawingRevisionRequest$json = {
  '1': 'RevertDrawingRevisionRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'target_revision_id', '3': 2, '4': 1, '5': 9, '10': 'targetRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
  ],
};

/// Descriptor for `RevertDrawingRevisionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revertDrawingRevisionRequestDescriptor = $convert.base64Decode(
    'ChxSZXZlcnREcmF3aW5nUmV2aXNpb25SZXF1ZXN0Eh0KCmRyYXdpbmdfaWQYASABKAlSCWRyYX'
    'dpbmdJZBIsChJ0YXJnZXRfcmV2aXNpb25faWQYAiABKAlSEHRhcmdldFJldmlzaW9uSWQSFgoG'
    'YXV0aG9yGAMgASgJUgZhdXRob3ISGAoHc3VtbWFyeRgEIAEoCVIHc3VtbWFyeQ==');

@$core.Deprecated('Use revertDrawingRevisionResponseDescriptor instead')
const RevertDrawingRevisionResponse$json = {
  '1': 'RevertDrawingRevisionResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
  ],
};

/// Descriptor for `RevertDrawingRevisionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revertDrawingRevisionResponseDescriptor = $convert.base64Decode(
    'Ch1SZXZlcnREcmF3aW5nUmV2aXNpb25SZXNwb25zZRItCgdkcmF3aW5nGAEgASgLMhMuZHJhd2'
    'luZy52MS5EcmF3aW5nUgdkcmF3aW5nEjcKCHJldmlzaW9uGAIgASgLMhsuZHJhd2luZy52MS5E'
    'cmF3aW5nUmV2aXNpb25SCHJldmlzaW9u');

@$core.Deprecated('Use annotationReferenceDescriptor instead')
const AnnotationReference$json = {
  '1': 'AnnotationReference',
  '2': [
    {'1': 'entity_id', '3': 1, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'entity_type', '3': 2, '4': 1, '5': 14, '6': '.drawing.v1.DrawingEntityType', '10': 'entityType'},
  ],
};

/// Descriptor for `AnnotationReference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List annotationReferenceDescriptor = $convert.base64Decode(
    'ChNBbm5vdGF0aW9uUmVmZXJlbmNlEhsKCWVudGl0eV9pZBgBIAEoCVIIZW50aXR5SWQSPgoLZW'
    '50aXR5X3R5cGUYAiABKA4yHS5kcmF3aW5nLnYxLkRyYXdpbmdFbnRpdHlUeXBlUgplbnRpdHlU'
    'eXBl');

@$core.Deprecated('Use annotationTextSpecDescriptor instead')
const AnnotationTextSpec$json = {
  '1': 'AnnotationTextSpec',
  '2': [
    {'1': 'anchor', '3': 1, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'anchor'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'rotation_deg', '3': 3, '4': 1, '5': 1, '10': 'rotationDeg'},
    {'1': 'height', '3': 4, '4': 1, '5': 1, '10': 'height'},
    {'1': 'font_family', '3': 5, '4': 1, '5': 9, '10': 'fontFamily'},
  ],
};

/// Descriptor for `AnnotationTextSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List annotationTextSpecDescriptor = $convert.base64Decode(
    'ChJBbm5vdGF0aW9uVGV4dFNwZWMSKgoGYW5jaG9yGAEgASgLMhIuY29tbW9uLnYxLlBvaW50Mk'
    'RSBmFuY2hvchISCgR0ZXh0GAIgASgJUgR0ZXh0EiEKDHJvdGF0aW9uX2RlZxgDIAEoAVILcm90'
    'YXRpb25EZWcSFgoGaGVpZ2h0GAQgASgBUgZoZWlnaHQSHwoLZm9udF9mYW1pbHkYBSABKAlSCm'
    'ZvbnRGYW1pbHk=');

@$core.Deprecated('Use annotationDimensionSpecDescriptor instead')
const AnnotationDimensionSpec$json = {
  '1': 'AnnotationDimensionSpec',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'end'},
    {'1': 'text_anchor', '3': 3, '4': 1, '5': 11, '6': '.common.v1.Point2D', '10': 'textAnchor'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'precision', '3': 5, '4': 1, '5': 1, '10': 'precision'},
    {'1': 'associations', '3': 6, '4': 3, '5': 11, '6': '.drawing.v1.AnnotationReference', '10': 'associations'},
  ],
};

/// Descriptor for `AnnotationDimensionSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List annotationDimensionSpecDescriptor = $convert.base64Decode(
    'ChdBbm5vdGF0aW9uRGltZW5zaW9uU3BlYxIoCgVzdGFydBgBIAEoCzISLmNvbW1vbi52MS5Qb2'
    'ludDJEUgVzdGFydBIkCgNlbmQYAiABKAsyEi5jb21tb24udjEuUG9pbnQyRFIDZW5kEjMKC3Rl'
    'eHRfYW5jaG9yGAMgASgLMhIuY29tbW9uLnYxLlBvaW50MkRSCnRleHRBbmNob3ISEgoEdW5pdB'
    'gEIAEoCVIEdW5pdBIcCglwcmVjaXNpb24YBSABKAFSCXByZWNpc2lvbhJDCgxhc3NvY2lhdGlv'
    'bnMYBiADKAsyHy5kcmF3aW5nLnYxLkFubm90YXRpb25SZWZlcmVuY2VSDGFzc29jaWF0aW9ucw'
    '==');

@$core.Deprecated('Use annotationLeaderSpecDescriptor instead')
const AnnotationLeaderSpec$json = {
  '1': 'AnnotationLeaderSpec',
  '2': [
    {'1': 'vertices', '3': 1, '4': 3, '5': 11, '6': '.common.v1.Point2D', '10': 'vertices'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'text_height', '3': 3, '4': 1, '5': 1, '10': 'textHeight'},
    {'1': 'arrow_head', '3': 4, '4': 1, '5': 9, '10': 'arrowHead'},
    {'1': 'associations', '3': 5, '4': 3, '5': 11, '6': '.drawing.v1.AnnotationReference', '10': 'associations'},
  ],
};

/// Descriptor for `AnnotationLeaderSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List annotationLeaderSpecDescriptor = $convert.base64Decode(
    'ChRBbm5vdGF0aW9uTGVhZGVyU3BlYxIuCgh2ZXJ0aWNlcxgBIAMoCzISLmNvbW1vbi52MS5Qb2'
    'ludDJEUgh2ZXJ0aWNlcxISCgR0ZXh0GAIgASgJUgR0ZXh0Eh8KC3RleHRfaGVpZ2h0GAMgASgB'
    'Ugp0ZXh0SGVpZ2h0Eh0KCmFycm93X2hlYWQYBCABKAlSCWFycm93SGVhZBJDCgxhc3NvY2lhdG'
    'lvbnMYBSADKAsyHy5kcmF3aW5nLnYxLkFubm90YXRpb25SZWZlcmVuY2VSDGFzc29jaWF0aW9u'
    'cw==');

@$core.Deprecated('Use annotationSpecDescriptor instead')
const AnnotationSpec$json = {
  '1': 'AnnotationSpec',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.AnnotationTextSpec', '9': 0, '10': 'text'},
    {'1': 'dimension', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.AnnotationDimensionSpec', '9': 0, '10': 'dimension'},
    {'1': 'leader', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.AnnotationLeaderSpec', '9': 0, '10': 'leader'},
  ],
  '8': [
    {'1': 'kind'},
  ],
};

/// Descriptor for `AnnotationSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List annotationSpecDescriptor = $convert.base64Decode(
    'Cg5Bbm5vdGF0aW9uU3BlYxI0CgR0ZXh0GAEgASgLMh4uZHJhd2luZy52MS5Bbm5vdGF0aW9uVG'
    'V4dFNwZWNIAFIEdGV4dBJDCglkaW1lbnNpb24YAiABKAsyIy5kcmF3aW5nLnYxLkFubm90YXRp'
    'b25EaW1lbnNpb25TcGVjSABSCWRpbWVuc2lvbhI6CgZsZWFkZXIYAyABKAsyIC5kcmF3aW5nLn'
    'YxLkFubm90YXRpb25MZWFkZXJTcGVjSABSBmxlYWRlckIGCgRraW5k');

@$core.Deprecated('Use createAnnotationRequestDescriptor instead')
const CreateAnnotationRequest$json = {
  '1': 'CreateAnnotationRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'layer_id', '3': 5, '4': 1, '5': 9, '10': 'layerId'},
    {'1': 'layer_name', '3': 6, '4': 1, '5': 9, '10': 'layerName'},
    {'1': 'style_id', '3': 7, '4': 1, '5': 9, '10': 'styleId'},
    {'1': 'style_name', '3': 8, '4': 1, '5': 9, '10': 'styleName'},
    {'1': 'metadata_json', '3': 9, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'annotation', '3': 10, '4': 1, '5': 11, '6': '.drawing.v1.AnnotationSpec', '10': 'annotation'},
    {'1': 'contract', '3': 11, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `CreateAnnotationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAnnotationRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVBbm5vdGF0aW9uUmVxdWVzdBIdCgpkcmF3aW5nX2lkGAEgASgJUglkcmF3aW5nSW'
    'QSKAoQYmFzZV9yZXZpc2lvbl9pZBgCIAEoCVIOYmFzZVJldmlzaW9uSWQSFgoGYXV0aG9yGAMg'
    'ASgJUgZhdXRob3ISGAoHc3VtbWFyeRgEIAEoCVIHc3VtbWFyeRIZCghsYXllcl9pZBgFIAEoCV'
    'IHbGF5ZXJJZBIdCgpsYXllcl9uYW1lGAYgASgJUglsYXllck5hbWUSGQoIc3R5bGVfaWQYByAB'
    'KAlSB3N0eWxlSWQSHQoKc3R5bGVfbmFtZRgIIAEoCVIJc3R5bGVOYW1lEiMKDW1ldGFkYXRhX2'
    'pzb24YCSABKAlSDG1ldGFkYXRhSnNvbhI6Cgphbm5vdGF0aW9uGAogASgLMhouZHJhd2luZy52'
    'MS5Bbm5vdGF0aW9uU3BlY1IKYW5ub3RhdGlvbhI3Cghjb250cmFjdBgLIAEoCzIbLmNvbW1vbi'
    '52MS5Db250cmFjdE1ldGFkYXRhUghjb250cmFjdA==');

@$core.Deprecated('Use createAnnotationResponseDescriptor instead')
const CreateAnnotationResponse$json = {
  '1': 'CreateAnnotationResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'annotation_entity', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'annotationEntity'},
  ],
};

/// Descriptor for `CreateAnnotationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAnnotationResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVBbm5vdGF0aW9uUmVzcG9uc2USLQoHZHJhd2luZxgBIAEoCzITLmRyYXdpbmcudj'
    'EuRHJhd2luZ1IHZHJhd2luZxI3CghyZXZpc2lvbhgCIAEoCzIbLmRyYXdpbmcudjEuRHJhd2lu'
    'Z1JldmlzaW9uUghyZXZpc2lvbhJGChFhbm5vdGF0aW9uX2VudGl0eRgDIAEoCzIZLmRyYXdpbm'
    'cudjEuRHJhd2luZ0VudGl0eVIQYW5ub3RhdGlvbkVudGl0eQ==');

@$core.Deprecated('Use regenerateAssociativeAnnotationsRequestDescriptor instead')
const RegenerateAssociativeAnnotationsRequest$json = {
  '1': 'RegenerateAssociativeAnnotationsRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'contract', '3': 5, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `RegenerateAssociativeAnnotationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List regenerateAssociativeAnnotationsRequestDescriptor = $convert.base64Decode(
    'CidSZWdlbmVyYXRlQXNzb2NpYXRpdmVBbm5vdGF0aW9uc1JlcXVlc3QSHQoKZHJhd2luZ19pZB'
    'gBIAEoCVIJZHJhd2luZ0lkEigKEGJhc2VfcmV2aXNpb25faWQYAiABKAlSDmJhc2VSZXZpc2lv'
    'bklkEhYKBmF1dGhvchgDIAEoCVIGYXV0aG9yEhgKB3N1bW1hcnkYBCABKAlSB3N1bW1hcnkSNw'
    'oIY29udHJhY3QYBSABKAsyGy5jb21tb24udjEuQ29udHJhY3RNZXRhZGF0YVIIY29udHJhY3Q=');

@$core.Deprecated('Use regenerateAssociativeAnnotationsResponseDescriptor instead')
const RegenerateAssociativeAnnotationsResponse$json = {
  '1': 'RegenerateAssociativeAnnotationsResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'updated_annotations', '3': 3, '4': 3, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'updatedAnnotations'},
    {'1': 'violations', '3': 4, '4': 3, '5': 9, '10': 'violations'},
  ],
};

/// Descriptor for `RegenerateAssociativeAnnotationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List regenerateAssociativeAnnotationsResponseDescriptor = $convert.base64Decode(
    'CihSZWdlbmVyYXRlQXNzb2NpYXRpdmVBbm5vdGF0aW9uc1Jlc3BvbnNlEi0KB2RyYXdpbmcYAS'
    'ABKAsyEy5kcmF3aW5nLnYxLkRyYXdpbmdSB2RyYXdpbmcSNwoIcmV2aXNpb24YAiABKAsyGy5k'
    'cmF3aW5nLnYxLkRyYXdpbmdSZXZpc2lvblIIcmV2aXNpb24SSgoTdXBkYXRlZF9hbm5vdGF0aW'
    '9ucxgDIAMoCzIZLmRyYXdpbmcudjEuRHJhd2luZ0VudGl0eVISdXBkYXRlZEFubm90YXRpb25z'
    'Eh4KCnZpb2xhdGlvbnMYBCADKAlSCnZpb2xhdGlvbnM=');

@$core.Deprecated('Use upsertLayerRequestDescriptor instead')
const UpsertLayerRequest$json = {
  '1': 'UpsertLayerRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'metadata_json', '3': 5, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'layer', '3': 6, '4': 1, '5': 11, '6': '.drawing.v1.LayerDefinitionEntity', '10': 'layer'},
    {'1': 'contract', '3': 7, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `UpsertLayerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertLayerRequestDescriptor = $convert.base64Decode(
    'ChJVcHNlcnRMYXllclJlcXVlc3QSHQoKZHJhd2luZ19pZBgBIAEoCVIJZHJhd2luZ0lkEigKEG'
    'Jhc2VfcmV2aXNpb25faWQYAiABKAlSDmJhc2VSZXZpc2lvbklkEhYKBmF1dGhvchgDIAEoCVIG'
    'YXV0aG9yEhgKB3N1bW1hcnkYBCABKAlSB3N1bW1hcnkSIwoNbWV0YWRhdGFfanNvbhgFIAEoCV'
    'IMbWV0YWRhdGFKc29uEjcKBWxheWVyGAYgASgLMiEuZHJhd2luZy52MS5MYXllckRlZmluaXRp'
    'b25FbnRpdHlSBWxheWVyEjcKCGNvbnRyYWN0GAcgASgLMhsuY29tbW9uLnYxLkNvbnRyYWN0TW'
    'V0YWRhdGFSCGNvbnRyYWN0');

@$core.Deprecated('Use upsertLayerResponseDescriptor instead')
const UpsertLayerResponse$json = {
  '1': 'UpsertLayerResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'layer_entity', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'layerEntity'},
  ],
};

/// Descriptor for `UpsertLayerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertLayerResponseDescriptor = $convert.base64Decode(
    'ChNVcHNlcnRMYXllclJlc3BvbnNlEi0KB2RyYXdpbmcYASABKAsyEy5kcmF3aW5nLnYxLkRyYX'
    'dpbmdSB2RyYXdpbmcSNwoIcmV2aXNpb24YAiABKAsyGy5kcmF3aW5nLnYxLkRyYXdpbmdSZXZp'
    'c2lvblIIcmV2aXNpb24SPAoMbGF5ZXJfZW50aXR5GAMgASgLMhkuZHJhd2luZy52MS5EcmF3aW'
    '5nRW50aXR5UgtsYXllckVudGl0eQ==');

@$core.Deprecated('Use createBlockDefinitionRequestDescriptor instead')
const CreateBlockDefinitionRequest$json = {
  '1': 'CreateBlockDefinitionRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'layer_id', '3': 5, '4': 1, '5': 9, '10': 'layerId'},
    {'1': 'layer_name', '3': 6, '4': 1, '5': 9, '10': 'layerName'},
    {'1': 'style_id', '3': 7, '4': 1, '5': 9, '10': 'styleId'},
    {'1': 'style_name', '3': 8, '4': 1, '5': 9, '10': 'styleName'},
    {'1': 'metadata_json', '3': 9, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'block', '3': 10, '4': 1, '5': 11, '6': '.drawing.v1.BlockDefinitionEntity', '10': 'block'},
    {'1': 'contract', '3': 11, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `CreateBlockDefinitionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createBlockDefinitionRequestDescriptor = $convert.base64Decode(
    'ChxDcmVhdGVCbG9ja0RlZmluaXRpb25SZXF1ZXN0Eh0KCmRyYXdpbmdfaWQYASABKAlSCWRyYX'
    'dpbmdJZBIoChBiYXNlX3JldmlzaW9uX2lkGAIgASgJUg5iYXNlUmV2aXNpb25JZBIWCgZhdXRo'
    'b3IYAyABKAlSBmF1dGhvchIYCgdzdW1tYXJ5GAQgASgJUgdzdW1tYXJ5EhkKCGxheWVyX2lkGA'
    'UgASgJUgdsYXllcklkEh0KCmxheWVyX25hbWUYBiABKAlSCWxheWVyTmFtZRIZCghzdHlsZV9p'
    'ZBgHIAEoCVIHc3R5bGVJZBIdCgpzdHlsZV9uYW1lGAggASgJUglzdHlsZU5hbWUSIwoNbWV0YW'
    'RhdGFfanNvbhgJIAEoCVIMbWV0YWRhdGFKc29uEjcKBWJsb2NrGAogASgLMiEuZHJhd2luZy52'
    'MS5CbG9ja0RlZmluaXRpb25FbnRpdHlSBWJsb2NrEjcKCGNvbnRyYWN0GAsgASgLMhsuY29tbW'
    '9uLnYxLkNvbnRyYWN0TWV0YWRhdGFSCGNvbnRyYWN0');

@$core.Deprecated('Use createBlockDefinitionResponseDescriptor instead')
const CreateBlockDefinitionResponse$json = {
  '1': 'CreateBlockDefinitionResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'block_entity', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'blockEntity'},
  ],
};

/// Descriptor for `CreateBlockDefinitionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createBlockDefinitionResponseDescriptor = $convert.base64Decode(
    'Ch1DcmVhdGVCbG9ja0RlZmluaXRpb25SZXNwb25zZRItCgdkcmF3aW5nGAEgASgLMhMuZHJhd2'
    'luZy52MS5EcmF3aW5nUgdkcmF3aW5nEjcKCHJldmlzaW9uGAIgASgLMhsuZHJhd2luZy52MS5E'
    'cmF3aW5nUmV2aXNpb25SCHJldmlzaW9uEjwKDGJsb2NrX2VudGl0eRgDIAEoCzIZLmRyYXdpbm'
    'cudjEuRHJhd2luZ0VudGl0eVILYmxvY2tFbnRpdHk=');

@$core.Deprecated('Use insertBlockReferenceRequestDescriptor instead')
const InsertBlockReferenceRequest$json = {
  '1': 'InsertBlockReferenceRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'layer_id', '3': 5, '4': 1, '5': 9, '10': 'layerId'},
    {'1': 'layer_name', '3': 6, '4': 1, '5': 9, '10': 'layerName'},
    {'1': 'style_id', '3': 7, '4': 1, '5': 9, '10': 'styleId'},
    {'1': 'style_name', '3': 8, '4': 1, '5': 9, '10': 'styleName'},
    {'1': 'metadata_json', '3': 9, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'block_reference', '3': 10, '4': 1, '5': 11, '6': '.drawing.v1.BlockReferenceEntity', '10': 'blockReference'},
    {'1': 'contract', '3': 11, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `InsertBlockReferenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List insertBlockReferenceRequestDescriptor = $convert.base64Decode(
    'ChtJbnNlcnRCbG9ja1JlZmVyZW5jZVJlcXVlc3QSHQoKZHJhd2luZ19pZBgBIAEoCVIJZHJhd2'
    'luZ0lkEigKEGJhc2VfcmV2aXNpb25faWQYAiABKAlSDmJhc2VSZXZpc2lvbklkEhYKBmF1dGhv'
    'chgDIAEoCVIGYXV0aG9yEhgKB3N1bW1hcnkYBCABKAlSB3N1bW1hcnkSGQoIbGF5ZXJfaWQYBS'
    'ABKAlSB2xheWVySWQSHQoKbGF5ZXJfbmFtZRgGIAEoCVIJbGF5ZXJOYW1lEhkKCHN0eWxlX2lk'
    'GAcgASgJUgdzdHlsZUlkEh0KCnN0eWxlX25hbWUYCCABKAlSCXN0eWxlTmFtZRIjCg1tZXRhZG'
    'F0YV9qc29uGAkgASgJUgxtZXRhZGF0YUpzb24SSQoPYmxvY2tfcmVmZXJlbmNlGAogASgLMiAu'
    'ZHJhd2luZy52MS5CbG9ja1JlZmVyZW5jZUVudGl0eVIOYmxvY2tSZWZlcmVuY2USNwoIY29udH'
    'JhY3QYCyABKAsyGy5jb21tb24udjEuQ29udHJhY3RNZXRhZGF0YVIIY29udHJhY3Q=');

@$core.Deprecated('Use insertBlockReferenceResponseDescriptor instead')
const InsertBlockReferenceResponse$json = {
  '1': 'InsertBlockReferenceResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'block_reference_entity', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'blockReferenceEntity'},
  ],
};

/// Descriptor for `InsertBlockReferenceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List insertBlockReferenceResponseDescriptor = $convert.base64Decode(
    'ChxJbnNlcnRCbG9ja1JlZmVyZW5jZVJlc3BvbnNlEi0KB2RyYXdpbmcYASABKAsyEy5kcmF3aW'
    '5nLnYxLkRyYXdpbmdSB2RyYXdpbmcSNwoIcmV2aXNpb24YAiABKAsyGy5kcmF3aW5nLnYxLkRy'
    'YXdpbmdSZXZpc2lvblIIcmV2aXNpb24STwoWYmxvY2tfcmVmZXJlbmNlX2VudGl0eRgDIAEoCz'
    'IZLmRyYXdpbmcudjEuRHJhd2luZ0VudGl0eVIUYmxvY2tSZWZlcmVuY2VFbnRpdHk=');

@$core.Deprecated('Use fidelityReportDescriptor instead')
const FidelityReport$json = {
  '1': 'FidelityReport',
  '2': [
    {'1': 'source_entity_count', '3': 1, '4': 1, '5': 13, '10': 'sourceEntityCount'},
    {'1': 'output_entity_count', '3': 2, '4': 1, '5': 13, '10': 'outputEntityCount'},
    {'1': 'matched_entity_count', '3': 3, '4': 1, '5': 13, '10': 'matchedEntityCount'},
    {'1': 'warnings', '3': 4, '4': 3, '5': 9, '10': 'warnings'},
  ],
};

/// Descriptor for `FidelityReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fidelityReportDescriptor = $convert.base64Decode(
    'Cg5GaWRlbGl0eVJlcG9ydBIuChNzb3VyY2VfZW50aXR5X2NvdW50GAEgASgNUhFzb3VyY2VFbn'
    'RpdHlDb3VudBIuChNvdXRwdXRfZW50aXR5X2NvdW50GAIgASgNUhFvdXRwdXRFbnRpdHlDb3Vu'
    'dBIwChRtYXRjaGVkX2VudGl0eV9jb3VudBgDIAEoDVISbWF0Y2hlZEVudGl0eUNvdW50EhoKCH'
    'dhcm5pbmdzGAQgAygJUgh3YXJuaW5ncw==');

@$core.Deprecated('Use exportDrawingRequestDescriptor instead')
const ExportDrawingRequest$json = {
  '1': 'ExportDrawingRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'revision_id', '3': 2, '4': 1, '5': 9, '10': 'revisionId'},
    {'1': 'format', '3': 3, '4': 1, '5': 14, '6': '.drawing.v1.FileFormat', '10': 'format'},
  ],
};

/// Descriptor for `ExportDrawingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportDrawingRequestDescriptor = $convert.base64Decode(
    'ChRFeHBvcnREcmF3aW5nUmVxdWVzdBIdCgpkcmF3aW5nX2lkGAEgASgJUglkcmF3aW5nSWQSHw'
    'oLcmV2aXNpb25faWQYAiABKAlSCnJldmlzaW9uSWQSLgoGZm9ybWF0GAMgASgOMhYuZHJhd2lu'
    'Zy52MS5GaWxlRm9ybWF0UgZmb3JtYXQ=');

@$core.Deprecated('Use exportDrawingResponseDescriptor instead')
const ExportDrawingResponse$json = {
  '1': 'ExportDrawingResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'format', '3': 3, '4': 1, '5': 14, '6': '.drawing.v1.FileFormat', '10': 'format'},
    {'1': 'file_name', '3': 4, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'content_type', '3': 5, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'payload', '3': 6, '4': 1, '5': 12, '10': 'payload'},
    {'1': 'report', '3': 7, '4': 1, '5': 11, '6': '.drawing.v1.FidelityReport', '10': 'report'},
  ],
};

/// Descriptor for `ExportDrawingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportDrawingResponseDescriptor = $convert.base64Decode(
    'ChVFeHBvcnREcmF3aW5nUmVzcG9uc2USLQoHZHJhd2luZxgBIAEoCzITLmRyYXdpbmcudjEuRH'
    'Jhd2luZ1IHZHJhd2luZxI3CghyZXZpc2lvbhgCIAEoCzIbLmRyYXdpbmcudjEuRHJhd2luZ1Jl'
    'dmlzaW9uUghyZXZpc2lvbhIuCgZmb3JtYXQYAyABKA4yFi5kcmF3aW5nLnYxLkZpbGVGb3JtYX'
    'RSBmZvcm1hdBIbCglmaWxlX25hbWUYBCABKAlSCGZpbGVOYW1lEiEKDGNvbnRlbnRfdHlwZRgF'
    'IAEoCVILY29udGVudFR5cGUSGAoHcGF5bG9hZBgGIAEoDFIHcGF5bG9hZBIyCgZyZXBvcnQYBy'
    'ABKAsyGi5kcmF3aW5nLnYxLkZpZGVsaXR5UmVwb3J0UgZyZXBvcnQ=');

@$core.Deprecated('Use importDrawingRequestDescriptor instead')
const ImportDrawingRequest$json = {
  '1': 'ImportDrawingRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'format', '3': 5, '4': 1, '5': 14, '6': '.drawing.v1.FileFormat', '10': 'format'},
    {'1': 'payload', '3': 6, '4': 1, '5': 12, '10': 'payload'},
    {'1': 'merge_strategy', '3': 7, '4': 1, '5': 14, '6': '.drawing.v1.InteropMergeStrategy', '10': 'mergeStrategy'},
    {'1': 'contract', '3': 8, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `ImportDrawingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importDrawingRequestDescriptor = $convert.base64Decode(
    'ChRJbXBvcnREcmF3aW5nUmVxdWVzdBIdCgpkcmF3aW5nX2lkGAEgASgJUglkcmF3aW5nSWQSKA'
    'oQYmFzZV9yZXZpc2lvbl9pZBgCIAEoCVIOYmFzZVJldmlzaW9uSWQSFgoGYXV0aG9yGAMgASgJ'
    'UgZhdXRob3ISGAoHc3VtbWFyeRgEIAEoCVIHc3VtbWFyeRIuCgZmb3JtYXQYBSABKA4yFi5kcm'
    'F3aW5nLnYxLkZpbGVGb3JtYXRSBmZvcm1hdBIYCgdwYXlsb2FkGAYgASgMUgdwYXlsb2FkEkcK'
    'Dm1lcmdlX3N0cmF0ZWd5GAcgASgOMiAuZHJhd2luZy52MS5JbnRlcm9wTWVyZ2VTdHJhdGVneV'
    'INbWVyZ2VTdHJhdGVneRI3Cghjb250cmFjdBgIIAEoCzIbLmNvbW1vbi52MS5Db250cmFjdE1l'
    'dGFkYXRhUghjb250cmFjdA==');

@$core.Deprecated('Use importDrawingResponseDescriptor instead')
const ImportDrawingResponse$json = {
  '1': 'ImportDrawingResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'report', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.FidelityReport', '10': 'report'},
  ],
};

/// Descriptor for `ImportDrawingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importDrawingResponseDescriptor = $convert.base64Decode(
    'ChVJbXBvcnREcmF3aW5nUmVzcG9uc2USLQoHZHJhd2luZxgBIAEoCzITLmRyYXdpbmcudjEuRH'
    'Jhd2luZ1IHZHJhd2luZxI3CghyZXZpc2lvbhgCIAEoCzIbLmRyYXdpbmcudjEuRHJhd2luZ1Jl'
    'dmlzaW9uUghyZXZpc2lvbhIyCgZyZXBvcnQYAyABKAsyGi5kcmF3aW5nLnYxLkZpZGVsaXR5Um'
    'Vwb3J0UgZyZXBvcnQ=');

@$core.Deprecated('Use validateDrawingRoundTripRequestDescriptor instead')
const ValidateDrawingRoundTripRequest$json = {
  '1': 'ValidateDrawingRoundTripRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'revision_id', '3': 2, '4': 1, '5': 9, '10': 'revisionId'},
    {'1': 'format', '3': 3, '4': 1, '5': 14, '6': '.drawing.v1.FileFormat', '10': 'format'},
  ],
};

/// Descriptor for `ValidateDrawingRoundTripRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateDrawingRoundTripRequestDescriptor = $convert.base64Decode(
    'Ch9WYWxpZGF0ZURyYXdpbmdSb3VuZFRyaXBSZXF1ZXN0Eh0KCmRyYXdpbmdfaWQYASABKAlSCW'
    'RyYXdpbmdJZBIfCgtyZXZpc2lvbl9pZBgCIAEoCVIKcmV2aXNpb25JZBIuCgZmb3JtYXQYAyAB'
    'KA4yFi5kcmF3aW5nLnYxLkZpbGVGb3JtYXRSBmZvcm1hdA==');

@$core.Deprecated('Use validateDrawingRoundTripResponseDescriptor instead')
const ValidateDrawingRoundTripResponse$json = {
  '1': 'ValidateDrawingRoundTripResponse',
  '2': [
    {'1': 'report', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.FidelityReport', '10': 'report'},
  ],
};

/// Descriptor for `ValidateDrawingRoundTripResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateDrawingRoundTripResponseDescriptor = $convert.base64Decode(
    'CiBWYWxpZGF0ZURyYXdpbmdSb3VuZFRyaXBSZXNwb25zZRIyCgZyZXBvcnQYASABKAsyGi5kcm'
    'F3aW5nLnYxLkZpZGVsaXR5UmVwb3J0UgZyZXBvcnQ=');

@$core.Deprecated('Use createSheetRequestDescriptor instead')
const CreateSheetRequest$json = {
  '1': 'CreateSheetRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'base_revision_id', '3': 2, '4': 1, '5': 9, '10': 'baseRevisionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'layer_id', '3': 5, '4': 1, '5': 9, '10': 'layerId'},
    {'1': 'layer_name', '3': 6, '4': 1, '5': 9, '10': 'layerName'},
    {'1': 'style_id', '3': 7, '4': 1, '5': 9, '10': 'styleId'},
    {'1': 'style_name', '3': 8, '4': 1, '5': 9, '10': 'styleName'},
    {'1': 'metadata_json', '3': 9, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'sheet', '3': 10, '4': 1, '5': 11, '6': '.drawing.v1.SheetEntity', '10': 'sheet'},
    {'1': 'contract', '3': 11, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `CreateSheetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSheetRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVTaGVldFJlcXVlc3QSHQoKZHJhd2luZ19pZBgBIAEoCVIJZHJhd2luZ0lkEigKEG'
    'Jhc2VfcmV2aXNpb25faWQYAiABKAlSDmJhc2VSZXZpc2lvbklkEhYKBmF1dGhvchgDIAEoCVIG'
    'YXV0aG9yEhgKB3N1bW1hcnkYBCABKAlSB3N1bW1hcnkSGQoIbGF5ZXJfaWQYBSABKAlSB2xheW'
    'VySWQSHQoKbGF5ZXJfbmFtZRgGIAEoCVIJbGF5ZXJOYW1lEhkKCHN0eWxlX2lkGAcgASgJUgdz'
    'dHlsZUlkEh0KCnN0eWxlX25hbWUYCCABKAlSCXN0eWxlTmFtZRIjCg1tZXRhZGF0YV9qc29uGA'
    'kgASgJUgxtZXRhZGF0YUpzb24SLQoFc2hlZXQYCiABKAsyFy5kcmF3aW5nLnYxLlNoZWV0RW50'
    'aXR5UgVzaGVldBI3Cghjb250cmFjdBgLIAEoCzIbLmNvbW1vbi52MS5Db250cmFjdE1ldGFkYX'
    'RhUghjb250cmFjdA==');

@$core.Deprecated('Use createSheetResponseDescriptor instead')
const CreateSheetResponse$json = {
  '1': 'CreateSheetResponse',
  '2': [
    {'1': 'drawing', '3': 1, '4': 1, '5': 11, '6': '.drawing.v1.Drawing', '10': 'drawing'},
    {'1': 'revision', '3': 2, '4': 1, '5': 11, '6': '.drawing.v1.DrawingRevision', '10': 'revision'},
    {'1': 'sheet_entity', '3': 3, '4': 1, '5': 11, '6': '.drawing.v1.DrawingEntity', '10': 'sheetEntity'},
  ],
};

/// Descriptor for `CreateSheetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSheetResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVTaGVldFJlc3BvbnNlEi0KB2RyYXdpbmcYASABKAsyEy5kcmF3aW5nLnYxLkRyYX'
    'dpbmdSB2RyYXdpbmcSNwoIcmV2aXNpb24YAiABKAsyGy5kcmF3aW5nLnYxLkRyYXdpbmdSZXZp'
    'c2lvblIIcmV2aXNpb24SPAoMc2hlZXRfZW50aXR5GAMgASgLMhkuZHJhd2luZy52MS5EcmF3aW'
    '5nRW50aXR5UgtzaGVldEVudGl0eQ==');

@$core.Deprecated('Use plotOptionsDescriptor instead')
const PlotOptions$json = {
  '1': 'PlotOptions',
  '2': [
    {'1': 'monochrome', '3': 1, '4': 1, '5': 8, '10': 'monochrome'},
    {'1': 'include_metadata', '3': 2, '4': 1, '5': 8, '10': 'includeMetadata'},
    {'1': 'stroke_width_mm', '3': 3, '4': 1, '5': 1, '10': 'strokeWidthMm'},
  ],
};

/// Descriptor for `PlotOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List plotOptionsDescriptor = $convert.base64Decode(
    'CgtQbG90T3B0aW9ucxIeCgptb25vY2hyb21lGAEgASgIUgptb25vY2hyb21lEikKEGluY2x1ZG'
    'VfbWV0YWRhdGEYAiABKAhSD2luY2x1ZGVNZXRhZGF0YRImCg9zdHJva2Vfd2lkdGhfbW0YAyAB'
    'KAFSDXN0cm9rZVdpZHRoTW0=');

@$core.Deprecated('Use publishedSheetArtifactDescriptor instead')
const PublishedSheetArtifact$json = {
  '1': 'PublishedSheetArtifact',
  '2': [
    {'1': 'sheet_id', '3': 1, '4': 1, '5': 9, '10': 'sheetId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'format', '3': 3, '4': 1, '5': 14, '6': '.drawing.v1.PlotOutputFormat', '10': 'format'},
    {'1': 'file_name', '3': 4, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'content_type', '3': 5, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'payload', '3': 6, '4': 1, '5': 12, '10': 'payload'},
  ],
};

/// Descriptor for `PublishedSheetArtifact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishedSheetArtifactDescriptor = $convert.base64Decode(
    'ChZQdWJsaXNoZWRTaGVldEFydGlmYWN0EhkKCHNoZWV0X2lkGAEgASgJUgdzaGVldElkEhQKBX'
    'RpdGxlGAIgASgJUgV0aXRsZRI0CgZmb3JtYXQYAyABKA4yHC5kcmF3aW5nLnYxLlBsb3RPdXRw'
    'dXRGb3JtYXRSBmZvcm1hdBIbCglmaWxlX25hbWUYBCABKAlSCGZpbGVOYW1lEiEKDGNvbnRlbn'
    'RfdHlwZRgFIAEoCVILY29udGVudFR5cGUSGAoHcGF5bG9hZBgGIAEoDFIHcGF5bG9hZA==');

@$core.Deprecated('Use publishDrawingRequestDescriptor instead')
const PublishDrawingRequest$json = {
  '1': 'PublishDrawingRequest',
  '2': [
    {'1': 'drawing_id', '3': 1, '4': 1, '5': 9, '10': 'drawingId'},
    {'1': 'revision_id', '3': 2, '4': 1, '5': 9, '10': 'revisionId'},
    {'1': 'sheet_ids', '3': 3, '4': 3, '5': 9, '10': 'sheetIds'},
    {'1': 'format', '3': 4, '4': 1, '5': 14, '6': '.drawing.v1.PlotOutputFormat', '10': 'format'},
    {'1': 'options', '3': 5, '4': 1, '5': 11, '6': '.drawing.v1.PlotOptions', '10': 'options'},
  ],
};

/// Descriptor for `PublishDrawingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishDrawingRequestDescriptor = $convert.base64Decode(
    'ChVQdWJsaXNoRHJhd2luZ1JlcXVlc3QSHQoKZHJhd2luZ19pZBgBIAEoCVIJZHJhd2luZ0lkEh'
    '8KC3JldmlzaW9uX2lkGAIgASgJUgpyZXZpc2lvbklkEhsKCXNoZWV0X2lkcxgDIAMoCVIIc2hl'
    'ZXRJZHMSNAoGZm9ybWF0GAQgASgOMhwuZHJhd2luZy52MS5QbG90T3V0cHV0Rm9ybWF0UgZmb3'
    'JtYXQSMQoHb3B0aW9ucxgFIAEoCzIXLmRyYXdpbmcudjEuUGxvdE9wdGlvbnNSB29wdGlvbnM=');

@$core.Deprecated('Use publishDrawingResponseDescriptor instead')
const PublishDrawingResponse$json = {
  '1': 'PublishDrawingResponse',
  '2': [
    {'1': 'artifacts', '3': 1, '4': 3, '5': 11, '6': '.drawing.v1.PublishedSheetArtifact', '10': 'artifacts'},
    {'1': 'manifest_json', '3': 2, '4': 1, '5': 9, '10': 'manifestJson'},
  ],
};

/// Descriptor for `PublishDrawingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishDrawingResponseDescriptor = $convert.base64Decode(
    'ChZQdWJsaXNoRHJhd2luZ1Jlc3BvbnNlEkAKCWFydGlmYWN0cxgBIAMoCzIiLmRyYXdpbmcudj'
    'EuUHVibGlzaGVkU2hlZXRBcnRpZmFjdFIJYXJ0aWZhY3RzEiMKDW1hbmlmZXN0X2pzb24YAiAB'
    'KAlSDG1hbmlmZXN0SnNvbg==');

const $core.Map<$core.String, $core.dynamic> DrawingRevisionServiceBase$json = {
  '1': 'DrawingRevisionService',
  '2': [
    {'1': 'CreateDrawing', '2': '.drawing.v1.CreateDrawingRequest', '3': '.drawing.v1.CreateDrawingResponse'},
    {'1': 'GetDrawing', '2': '.drawing.v1.GetDrawingRequest', '3': '.drawing.v1.GetDrawingResponse'},
    {'1': 'ListDrawings', '2': '.drawing.v1.ListDrawingsRequest', '3': '.drawing.v1.ListDrawingsResponse'},
    {'1': 'UpdateDrawing', '2': '.drawing.v1.UpdateDrawingRequest', '3': '.drawing.v1.UpdateDrawingResponse'},
    {'1': 'GetDrawingState', '2': '.drawing.v1.GetDrawingStateRequest', '3': '.drawing.v1.GetDrawingStateResponse'},
    {'1': 'ListDrawingRevisions', '2': '.drawing.v1.ListDrawingRevisionsRequest', '3': '.drawing.v1.ListDrawingRevisionsResponse'},
    {'1': 'GetDrawingRevision', '2': '.drawing.v1.GetDrawingRevisionRequest', '3': '.drawing.v1.GetDrawingRevisionResponse'},
    {'1': 'StoreDrawingRevision', '2': '.drawing.v1.StoreDrawingRevisionRequest', '3': '.drawing.v1.StoreDrawingRevisionResponse'},
  ],
};

@$core.Deprecated('Use drawingRevisionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> DrawingRevisionServiceBase$messageJson = {
  '.drawing.v1.CreateDrawingRequest': CreateDrawingRequest$json,
  '.common.v1.ContractMetadata': $1.ContractMetadata$json,
  '.common.v1.ApiVersion': $1.ApiVersion$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.drawing.v1.CreateDrawingResponse': CreateDrawingResponse$json,
  '.drawing.v1.Drawing': Drawing$json,
  '.drawing.v1.DrawingRevision': DrawingRevision$json,
  '.drawing.v1.RevisionPointer': RevisionPointer$json,
  '.drawing.v1.DrawingEntity': DrawingEntity$json,
  '.drawing.v1.EntityHeader': EntityHeader$json,
  '.drawing.v1.LayerRef': LayerRef$json,
  '.drawing.v1.StyleRef': StyleRef$json,
  '.drawing.v1.PolylineEntity': PolylineEntity$json,
  '.common.v1.Point2D': $1.Point2D$json,
  '.drawing.v1.PolygonEntity': PolygonEntity$json,
  '.common.v1.Polygon2D': $1.Polygon2D$json,
  '.common.v1.LineString2D': $1.LineString2D$json,
  '.drawing.v1.TextEntity': TextEntity$json,
  '.drawing.v1.DimensionEntity': DimensionEntity$json,
  '.drawing.v1.BlockReferenceEntity': BlockReferenceEntity$json,
  '.drawing.v1.BlockReferenceEntity.AttributesEntry': BlockReferenceEntity_AttributesEntry$json,
  '.drawing.v1.LayerDefinitionEntity': LayerDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity': BlockDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity.DefaultAttributesEntry': BlockDefinitionEntity_DefaultAttributesEntry$json,
  '.drawing.v1.LeaderEntity': LeaderEntity$json,
  '.drawing.v1.SheetEntity': SheetEntity$json,
  '.drawing.v1.GetDrawingRequest': GetDrawingRequest$json,
  '.drawing.v1.GetDrawingResponse': GetDrawingResponse$json,
  '.drawing.v1.ListDrawingsRequest': ListDrawingsRequest$json,
  '.drawing.v1.ListDrawingsResponse': ListDrawingsResponse$json,
  '.drawing.v1.UpdateDrawingRequest': UpdateDrawingRequest$json,
  '.drawing.v1.UpdateDrawingResponse': UpdateDrawingResponse$json,
  '.drawing.v1.GetDrawingStateRequest': GetDrawingStateRequest$json,
  '.drawing.v1.GetDrawingStateResponse': GetDrawingStateResponse$json,
  '.drawing.v1.ListDrawingRevisionsRequest': ListDrawingRevisionsRequest$json,
  '.drawing.v1.ListDrawingRevisionsResponse': ListDrawingRevisionsResponse$json,
  '.drawing.v1.GetDrawingRevisionRequest': GetDrawingRevisionRequest$json,
  '.drawing.v1.GetDrawingRevisionResponse': GetDrawingRevisionResponse$json,
  '.drawing.v1.StoreDrawingRevisionRequest': StoreDrawingRevisionRequest$json,
  '.drawing.v1.StoreDrawingRevisionResponse': StoreDrawingRevisionResponse$json,
};

/// Descriptor for `DrawingRevisionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List drawingRevisionServiceDescriptor = $convert.base64Decode(
    'ChZEcmF3aW5nUmV2aXNpb25TZXJ2aWNlElQKDUNyZWF0ZURyYXdpbmcSIC5kcmF3aW5nLnYxLk'
    'NyZWF0ZURyYXdpbmdSZXF1ZXN0GiEuZHJhd2luZy52MS5DcmVhdGVEcmF3aW5nUmVzcG9uc2US'
    'SwoKR2V0RHJhd2luZxIdLmRyYXdpbmcudjEuR2V0RHJhd2luZ1JlcXVlc3QaHi5kcmF3aW5nLn'
    'YxLkdldERyYXdpbmdSZXNwb25zZRJRCgxMaXN0RHJhd2luZ3MSHy5kcmF3aW5nLnYxLkxpc3RE'
    'cmF3aW5nc1JlcXVlc3QaIC5kcmF3aW5nLnYxLkxpc3REcmF3aW5nc1Jlc3BvbnNlElQKDVVwZG'
    'F0ZURyYXdpbmcSIC5kcmF3aW5nLnYxLlVwZGF0ZURyYXdpbmdSZXF1ZXN0GiEuZHJhd2luZy52'
    'MS5VcGRhdGVEcmF3aW5nUmVzcG9uc2USWgoPR2V0RHJhd2luZ1N0YXRlEiIuZHJhd2luZy52MS'
    '5HZXREcmF3aW5nU3RhdGVSZXF1ZXN0GiMuZHJhd2luZy52MS5HZXREcmF3aW5nU3RhdGVSZXNw'
    'b25zZRJpChRMaXN0RHJhd2luZ1JldmlzaW9ucxInLmRyYXdpbmcudjEuTGlzdERyYXdpbmdSZX'
    'Zpc2lvbnNSZXF1ZXN0GiguZHJhd2luZy52MS5MaXN0RHJhd2luZ1JldmlzaW9uc1Jlc3BvbnNl'
    'EmMKEkdldERyYXdpbmdSZXZpc2lvbhIlLmRyYXdpbmcudjEuR2V0RHJhd2luZ1JldmlzaW9uUm'
    'VxdWVzdBomLmRyYXdpbmcudjEuR2V0RHJhd2luZ1JldmlzaW9uUmVzcG9uc2USaQoUU3RvcmVE'
    'cmF3aW5nUmV2aXNpb24SJy5kcmF3aW5nLnYxLlN0b3JlRHJhd2luZ1JldmlzaW9uUmVxdWVzdB'
    'ooLmRyYXdpbmcudjEuU3RvcmVEcmF3aW5nUmV2aXNpb25SZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> CadCoreServiceBase$json = {
  '1': 'CadCoreService',
  '2': [
    {'1': 'ValidateDrawingCommand', '2': '.drawing.v1.ValidateDrawingCommandRequest', '3': '.drawing.v1.ValidateDrawingCommandResponse'},
    {'1': 'CommitDrawingCommand', '2': '.drawing.v1.CommitDrawingCommandRequest', '3': '.drawing.v1.CommitDrawingCommandResponse'},
    {'1': 'RevertDrawingRevision', '2': '.drawing.v1.RevertDrawingRevisionRequest', '3': '.drawing.v1.RevertDrawingRevisionResponse'},
  ],
};

@$core.Deprecated('Use cadCoreServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> CadCoreServiceBase$messageJson = {
  '.drawing.v1.ValidateDrawingCommandRequest': ValidateDrawingCommandRequest$json,
  '.drawing.v1.DrawingCommand': DrawingCommand$json,
  '.drawing.v1.DrawingMutation': DrawingMutation$json,
  '.drawing.v1.DrawingEntity': DrawingEntity$json,
  '.drawing.v1.EntityHeader': EntityHeader$json,
  '.drawing.v1.LayerRef': LayerRef$json,
  '.drawing.v1.StyleRef': StyleRef$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.common.v1.ContractMetadata': $1.ContractMetadata$json,
  '.common.v1.ApiVersion': $1.ApiVersion$json,
  '.drawing.v1.PolylineEntity': PolylineEntity$json,
  '.common.v1.Point2D': $1.Point2D$json,
  '.drawing.v1.PolygonEntity': PolygonEntity$json,
  '.common.v1.Polygon2D': $1.Polygon2D$json,
  '.common.v1.LineString2D': $1.LineString2D$json,
  '.drawing.v1.TextEntity': TextEntity$json,
  '.drawing.v1.DimensionEntity': DimensionEntity$json,
  '.drawing.v1.BlockReferenceEntity': BlockReferenceEntity$json,
  '.drawing.v1.BlockReferenceEntity.AttributesEntry': BlockReferenceEntity_AttributesEntry$json,
  '.drawing.v1.LayerDefinitionEntity': LayerDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity': BlockDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity.DefaultAttributesEntry': BlockDefinitionEntity_DefaultAttributesEntry$json,
  '.drawing.v1.LeaderEntity': LeaderEntity$json,
  '.drawing.v1.SheetEntity': SheetEntity$json,
  '.drawing.v1.ValidateDrawingCommandResponse': ValidateDrawingCommandResponse$json,
  '.drawing.v1.CommitDrawingCommandRequest': CommitDrawingCommandRequest$json,
  '.drawing.v1.CommitDrawingCommandResponse': CommitDrawingCommandResponse$json,
  '.drawing.v1.Drawing': Drawing$json,
  '.drawing.v1.DrawingRevision': DrawingRevision$json,
  '.drawing.v1.RevisionPointer': RevisionPointer$json,
  '.drawing.v1.RevertDrawingRevisionRequest': RevertDrawingRevisionRequest$json,
  '.drawing.v1.RevertDrawingRevisionResponse': RevertDrawingRevisionResponse$json,
};

/// Descriptor for `CadCoreService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List cadCoreServiceDescriptor = $convert.base64Decode(
    'Cg5DYWRDb3JlU2VydmljZRJvChZWYWxpZGF0ZURyYXdpbmdDb21tYW5kEikuZHJhd2luZy52MS'
    '5WYWxpZGF0ZURyYXdpbmdDb21tYW5kUmVxdWVzdBoqLmRyYXdpbmcudjEuVmFsaWRhdGVEcmF3'
    'aW5nQ29tbWFuZFJlc3BvbnNlEmkKFENvbW1pdERyYXdpbmdDb21tYW5kEicuZHJhd2luZy52MS'
    '5Db21taXREcmF3aW5nQ29tbWFuZFJlcXVlc3QaKC5kcmF3aW5nLnYxLkNvbW1pdERyYXdpbmdD'
    'b21tYW5kUmVzcG9uc2USbAoVUmV2ZXJ0RHJhd2luZ1JldmlzaW9uEiguZHJhd2luZy52MS5SZX'
    'ZlcnREcmF3aW5nUmV2aXNpb25SZXF1ZXN0GikuZHJhd2luZy52MS5SZXZlcnREcmF3aW5nUmV2'
    'aXNpb25SZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> CadAnnotationServiceBase$json = {
  '1': 'CadAnnotationService',
  '2': [
    {'1': 'CreateAnnotation', '2': '.drawing.v1.CreateAnnotationRequest', '3': '.drawing.v1.CreateAnnotationResponse'},
    {'1': 'RegenerateAssociativeAnnotations', '2': '.drawing.v1.RegenerateAssociativeAnnotationsRequest', '3': '.drawing.v1.RegenerateAssociativeAnnotationsResponse'},
  ],
};

@$core.Deprecated('Use cadAnnotationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> CadAnnotationServiceBase$messageJson = {
  '.drawing.v1.CreateAnnotationRequest': CreateAnnotationRequest$json,
  '.drawing.v1.AnnotationSpec': AnnotationSpec$json,
  '.drawing.v1.AnnotationTextSpec': AnnotationTextSpec$json,
  '.common.v1.Point2D': $1.Point2D$json,
  '.drawing.v1.AnnotationDimensionSpec': AnnotationDimensionSpec$json,
  '.drawing.v1.AnnotationReference': AnnotationReference$json,
  '.drawing.v1.AnnotationLeaderSpec': AnnotationLeaderSpec$json,
  '.common.v1.ContractMetadata': $1.ContractMetadata$json,
  '.common.v1.ApiVersion': $1.ApiVersion$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.drawing.v1.CreateAnnotationResponse': CreateAnnotationResponse$json,
  '.drawing.v1.Drawing': Drawing$json,
  '.drawing.v1.DrawingRevision': DrawingRevision$json,
  '.drawing.v1.RevisionPointer': RevisionPointer$json,
  '.drawing.v1.DrawingEntity': DrawingEntity$json,
  '.drawing.v1.EntityHeader': EntityHeader$json,
  '.drawing.v1.LayerRef': LayerRef$json,
  '.drawing.v1.StyleRef': StyleRef$json,
  '.drawing.v1.PolylineEntity': PolylineEntity$json,
  '.drawing.v1.PolygonEntity': PolygonEntity$json,
  '.common.v1.Polygon2D': $1.Polygon2D$json,
  '.common.v1.LineString2D': $1.LineString2D$json,
  '.drawing.v1.TextEntity': TextEntity$json,
  '.drawing.v1.DimensionEntity': DimensionEntity$json,
  '.drawing.v1.BlockReferenceEntity': BlockReferenceEntity$json,
  '.drawing.v1.BlockReferenceEntity.AttributesEntry': BlockReferenceEntity_AttributesEntry$json,
  '.drawing.v1.LayerDefinitionEntity': LayerDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity': BlockDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity.DefaultAttributesEntry': BlockDefinitionEntity_DefaultAttributesEntry$json,
  '.drawing.v1.LeaderEntity': LeaderEntity$json,
  '.drawing.v1.SheetEntity': SheetEntity$json,
  '.drawing.v1.RegenerateAssociativeAnnotationsRequest': RegenerateAssociativeAnnotationsRequest$json,
  '.drawing.v1.RegenerateAssociativeAnnotationsResponse': RegenerateAssociativeAnnotationsResponse$json,
};

/// Descriptor for `CadAnnotationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List cadAnnotationServiceDescriptor = $convert.base64Decode(
    'ChRDYWRBbm5vdGF0aW9uU2VydmljZRJdChBDcmVhdGVBbm5vdGF0aW9uEiMuZHJhd2luZy52MS'
    '5DcmVhdGVBbm5vdGF0aW9uUmVxdWVzdBokLmRyYXdpbmcudjEuQ3JlYXRlQW5ub3RhdGlvblJl'
    'c3BvbnNlEo0BCiBSZWdlbmVyYXRlQXNzb2NpYXRpdmVBbm5vdGF0aW9ucxIzLmRyYXdpbmcudj'
    'EuUmVnZW5lcmF0ZUFzc29jaWF0aXZlQW5ub3RhdGlvbnNSZXF1ZXN0GjQuZHJhd2luZy52MS5S'
    'ZWdlbmVyYXRlQXNzb2NpYXRpdmVBbm5vdGF0aW9uc1Jlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> CadLayerBlockServiceBase$json = {
  '1': 'CadLayerBlockService',
  '2': [
    {'1': 'UpsertLayer', '2': '.drawing.v1.UpsertLayerRequest', '3': '.drawing.v1.UpsertLayerResponse'},
    {'1': 'CreateBlockDefinition', '2': '.drawing.v1.CreateBlockDefinitionRequest', '3': '.drawing.v1.CreateBlockDefinitionResponse'},
    {'1': 'InsertBlockReference', '2': '.drawing.v1.InsertBlockReferenceRequest', '3': '.drawing.v1.InsertBlockReferenceResponse'},
  ],
};

@$core.Deprecated('Use cadLayerBlockServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> CadLayerBlockServiceBase$messageJson = {
  '.drawing.v1.UpsertLayerRequest': UpsertLayerRequest$json,
  '.drawing.v1.LayerDefinitionEntity': LayerDefinitionEntity$json,
  '.common.v1.ContractMetadata': $1.ContractMetadata$json,
  '.common.v1.ApiVersion': $1.ApiVersion$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.drawing.v1.UpsertLayerResponse': UpsertLayerResponse$json,
  '.drawing.v1.Drawing': Drawing$json,
  '.drawing.v1.DrawingRevision': DrawingRevision$json,
  '.drawing.v1.RevisionPointer': RevisionPointer$json,
  '.drawing.v1.DrawingEntity': DrawingEntity$json,
  '.drawing.v1.EntityHeader': EntityHeader$json,
  '.drawing.v1.LayerRef': LayerRef$json,
  '.drawing.v1.StyleRef': StyleRef$json,
  '.drawing.v1.PolylineEntity': PolylineEntity$json,
  '.common.v1.Point2D': $1.Point2D$json,
  '.drawing.v1.PolygonEntity': PolygonEntity$json,
  '.common.v1.Polygon2D': $1.Polygon2D$json,
  '.common.v1.LineString2D': $1.LineString2D$json,
  '.drawing.v1.TextEntity': TextEntity$json,
  '.drawing.v1.DimensionEntity': DimensionEntity$json,
  '.drawing.v1.BlockReferenceEntity': BlockReferenceEntity$json,
  '.drawing.v1.BlockReferenceEntity.AttributesEntry': BlockReferenceEntity_AttributesEntry$json,
  '.drawing.v1.BlockDefinitionEntity': BlockDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity.DefaultAttributesEntry': BlockDefinitionEntity_DefaultAttributesEntry$json,
  '.drawing.v1.LeaderEntity': LeaderEntity$json,
  '.drawing.v1.SheetEntity': SheetEntity$json,
  '.drawing.v1.CreateBlockDefinitionRequest': CreateBlockDefinitionRequest$json,
  '.drawing.v1.CreateBlockDefinitionResponse': CreateBlockDefinitionResponse$json,
  '.drawing.v1.InsertBlockReferenceRequest': InsertBlockReferenceRequest$json,
  '.drawing.v1.InsertBlockReferenceResponse': InsertBlockReferenceResponse$json,
};

/// Descriptor for `CadLayerBlockService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List cadLayerBlockServiceDescriptor = $convert.base64Decode(
    'ChRDYWRMYXllckJsb2NrU2VydmljZRJOCgtVcHNlcnRMYXllchIeLmRyYXdpbmcudjEuVXBzZX'
    'J0TGF5ZXJSZXF1ZXN0Gh8uZHJhd2luZy52MS5VcHNlcnRMYXllclJlc3BvbnNlEmwKFUNyZWF0'
    'ZUJsb2NrRGVmaW5pdGlvbhIoLmRyYXdpbmcudjEuQ3JlYXRlQmxvY2tEZWZpbml0aW9uUmVxdW'
    'VzdBopLmRyYXdpbmcudjEuQ3JlYXRlQmxvY2tEZWZpbml0aW9uUmVzcG9uc2USaQoUSW5zZXJ0'
    'QmxvY2tSZWZlcmVuY2USJy5kcmF3aW5nLnYxLkluc2VydEJsb2NrUmVmZXJlbmNlUmVxdWVzdB'
    'ooLmRyYXdpbmcudjEuSW5zZXJ0QmxvY2tSZWZlcmVuY2VSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> InteropServiceBase$json = {
  '1': 'InteropService',
  '2': [
    {'1': 'ExportDrawing', '2': '.drawing.v1.ExportDrawingRequest', '3': '.drawing.v1.ExportDrawingResponse'},
    {'1': 'ImportDrawing', '2': '.drawing.v1.ImportDrawingRequest', '3': '.drawing.v1.ImportDrawingResponse'},
    {'1': 'ValidateDrawingRoundTrip', '2': '.drawing.v1.ValidateDrawingRoundTripRequest', '3': '.drawing.v1.ValidateDrawingRoundTripResponse'},
  ],
};

@$core.Deprecated('Use interopServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> InteropServiceBase$messageJson = {
  '.drawing.v1.ExportDrawingRequest': ExportDrawingRequest$json,
  '.drawing.v1.ExportDrawingResponse': ExportDrawingResponse$json,
  '.drawing.v1.Drawing': Drawing$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.common.v1.ContractMetadata': $1.ContractMetadata$json,
  '.common.v1.ApiVersion': $1.ApiVersion$json,
  '.drawing.v1.DrawingRevision': DrawingRevision$json,
  '.drawing.v1.RevisionPointer': RevisionPointer$json,
  '.drawing.v1.DrawingEntity': DrawingEntity$json,
  '.drawing.v1.EntityHeader': EntityHeader$json,
  '.drawing.v1.LayerRef': LayerRef$json,
  '.drawing.v1.StyleRef': StyleRef$json,
  '.drawing.v1.PolylineEntity': PolylineEntity$json,
  '.common.v1.Point2D': $1.Point2D$json,
  '.drawing.v1.PolygonEntity': PolygonEntity$json,
  '.common.v1.Polygon2D': $1.Polygon2D$json,
  '.common.v1.LineString2D': $1.LineString2D$json,
  '.drawing.v1.TextEntity': TextEntity$json,
  '.drawing.v1.DimensionEntity': DimensionEntity$json,
  '.drawing.v1.BlockReferenceEntity': BlockReferenceEntity$json,
  '.drawing.v1.BlockReferenceEntity.AttributesEntry': BlockReferenceEntity_AttributesEntry$json,
  '.drawing.v1.LayerDefinitionEntity': LayerDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity': BlockDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity.DefaultAttributesEntry': BlockDefinitionEntity_DefaultAttributesEntry$json,
  '.drawing.v1.LeaderEntity': LeaderEntity$json,
  '.drawing.v1.SheetEntity': SheetEntity$json,
  '.drawing.v1.FidelityReport': FidelityReport$json,
  '.drawing.v1.ImportDrawingRequest': ImportDrawingRequest$json,
  '.drawing.v1.ImportDrawingResponse': ImportDrawingResponse$json,
  '.drawing.v1.ValidateDrawingRoundTripRequest': ValidateDrawingRoundTripRequest$json,
  '.drawing.v1.ValidateDrawingRoundTripResponse': ValidateDrawingRoundTripResponse$json,
};

/// Descriptor for `InteropService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List interopServiceDescriptor = $convert.base64Decode(
    'Cg5JbnRlcm9wU2VydmljZRJUCg1FeHBvcnREcmF3aW5nEiAuZHJhd2luZy52MS5FeHBvcnREcm'
    'F3aW5nUmVxdWVzdBohLmRyYXdpbmcudjEuRXhwb3J0RHJhd2luZ1Jlc3BvbnNlElQKDUltcG9y'
    'dERyYXdpbmcSIC5kcmF3aW5nLnYxLkltcG9ydERyYXdpbmdSZXF1ZXN0GiEuZHJhd2luZy52MS'
    '5JbXBvcnREcmF3aW5nUmVzcG9uc2USdQoYVmFsaWRhdGVEcmF3aW5nUm91bmRUcmlwEisuZHJh'
    'd2luZy52MS5WYWxpZGF0ZURyYXdpbmdSb3VuZFRyaXBSZXF1ZXN0GiwuZHJhd2luZy52MS5WYW'
    'xpZGF0ZURyYXdpbmdSb3VuZFRyaXBSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> PlotSheetServiceBase$json = {
  '1': 'PlotSheetService',
  '2': [
    {'1': 'CreateSheet', '2': '.drawing.v1.CreateSheetRequest', '3': '.drawing.v1.CreateSheetResponse'},
    {'1': 'PublishDrawing', '2': '.drawing.v1.PublishDrawingRequest', '3': '.drawing.v1.PublishDrawingResponse'},
  ],
};

@$core.Deprecated('Use plotSheetServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> PlotSheetServiceBase$messageJson = {
  '.drawing.v1.CreateSheetRequest': CreateSheetRequest$json,
  '.drawing.v1.SheetEntity': SheetEntity$json,
  '.common.v1.ContractMetadata': $1.ContractMetadata$json,
  '.common.v1.ApiVersion': $1.ApiVersion$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.drawing.v1.CreateSheetResponse': CreateSheetResponse$json,
  '.drawing.v1.Drawing': Drawing$json,
  '.drawing.v1.DrawingRevision': DrawingRevision$json,
  '.drawing.v1.RevisionPointer': RevisionPointer$json,
  '.drawing.v1.DrawingEntity': DrawingEntity$json,
  '.drawing.v1.EntityHeader': EntityHeader$json,
  '.drawing.v1.LayerRef': LayerRef$json,
  '.drawing.v1.StyleRef': StyleRef$json,
  '.drawing.v1.PolylineEntity': PolylineEntity$json,
  '.common.v1.Point2D': $1.Point2D$json,
  '.drawing.v1.PolygonEntity': PolygonEntity$json,
  '.common.v1.Polygon2D': $1.Polygon2D$json,
  '.common.v1.LineString2D': $1.LineString2D$json,
  '.drawing.v1.TextEntity': TextEntity$json,
  '.drawing.v1.DimensionEntity': DimensionEntity$json,
  '.drawing.v1.BlockReferenceEntity': BlockReferenceEntity$json,
  '.drawing.v1.BlockReferenceEntity.AttributesEntry': BlockReferenceEntity_AttributesEntry$json,
  '.drawing.v1.LayerDefinitionEntity': LayerDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity': BlockDefinitionEntity$json,
  '.drawing.v1.BlockDefinitionEntity.DefaultAttributesEntry': BlockDefinitionEntity_DefaultAttributesEntry$json,
  '.drawing.v1.LeaderEntity': LeaderEntity$json,
  '.drawing.v1.PublishDrawingRequest': PublishDrawingRequest$json,
  '.drawing.v1.PlotOptions': PlotOptions$json,
  '.drawing.v1.PublishDrawingResponse': PublishDrawingResponse$json,
  '.drawing.v1.PublishedSheetArtifact': PublishedSheetArtifact$json,
};

/// Descriptor for `PlotSheetService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List plotSheetServiceDescriptor = $convert.base64Decode(
    'ChBQbG90U2hlZXRTZXJ2aWNlEk4KC0NyZWF0ZVNoZWV0Eh4uZHJhd2luZy52MS5DcmVhdGVTaG'
    'VldFJlcXVlc3QaHy5kcmF3aW5nLnYxLkNyZWF0ZVNoZWV0UmVzcG9uc2USVwoOUHVibGlzaERy'
    'YXdpbmcSIS5kcmF3aW5nLnYxLlB1Ymxpc2hEcmF3aW5nUmVxdWVzdBoiLmRyYXdpbmcudjEuUH'
    'VibGlzaERyYXdpbmdSZXNwb25zZQ==');

