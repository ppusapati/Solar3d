//
//  Generated code. Do not modify.
//  source: structural/v1/structural.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use reviewStateDescriptor instead')
const ReviewState$json = {
  '1': 'ReviewState',
  '2': [
    {'1': 'REVIEW_STATE_UNSPECIFIED', '2': 0},
    {'1': 'REVIEW_STATE_DRAFT', '2': 1},
    {'1': 'REVIEW_STATE_SUBMITTED', '2': 2},
    {'1': 'REVIEW_STATE_APPROVED', '2': 3},
    {'1': 'REVIEW_STATE_REJECTED', '2': 4},
  ],
};

/// Descriptor for `ReviewState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewStateDescriptor = $convert.base64Decode(
    'CgtSZXZpZXdTdGF0ZRIcChhSRVZJRVdfU1RBVEVfVU5TUEVDSUZJRUQQABIWChJSRVZJRVdfU1'
    'RBVEVfRFJBRlQQARIaChZSRVZJRVdfU1RBVEVfU1VCTUlUVEVEEAISGQoVUkVWSUVXX1NUQVRF'
    'X0FQUFJPVkVEEAMSGQoVUkVWSUVXX1NUQVRFX1JFSkVDVEVEEAQ=');

@$core.Deprecated('Use exposureCategoryDescriptor instead')
const ExposureCategory$json = {
  '1': 'ExposureCategory',
  '2': [
    {'1': 'EXPOSURE_CATEGORY_UNSPECIFIED', '2': 0},
    {'1': 'EXPOSURE_CATEGORY_B', '2': 1},
    {'1': 'EXPOSURE_CATEGORY_C', '2': 2},
    {'1': 'EXPOSURE_CATEGORY_D', '2': 3},
  ],
};

/// Descriptor for `ExposureCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List exposureCategoryDescriptor = $convert.base64Decode(
    'ChBFeHBvc3VyZUNhdGVnb3J5EiEKHUVYUE9TVVJFX0NBVEVHT1JZX1VOU1BFQ0lGSUVEEAASFw'
    'oTRVhQT1NVUkVfQ0FURUdPUllfQhABEhcKE0VYUE9TVVJFX0NBVEVHT1JZX0MQAhIXChNFWFBP'
    'U1VSRV9DQVRFR09SWV9EEAM=');

@$core.Deprecated('Use foundationTypeDescriptor instead')
const FoundationType$json = {
  '1': 'FoundationType',
  '2': [
    {'1': 'FOUNDATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FOUNDATION_TYPE_DRIVEN_PILE', '2': 1},
    {'1': 'FOUNDATION_TYPE_CONCRETE_PILE', '2': 2},
    {'1': 'FOUNDATION_TYPE_BALLAST', '2': 3},
    {'1': 'FOUNDATION_TYPE_SCREW_PILE', '2': 4},
  ],
};

/// Descriptor for `FoundationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List foundationTypeDescriptor = $convert.base64Decode(
    'Cg5Gb3VuZGF0aW9uVHlwZRIfChtGT1VOREFUSU9OX1RZUEVfVU5TUEVDSUZJRUQQABIfChtGT1'
    'VOREFUSU9OX1RZUEVfRFJJVkVOX1BJTEUQARIhCh1GT1VOREFUSU9OX1RZUEVfQ09OQ1JFVEVf'
    'UElMRRACEhsKF0ZPVU5EQVRJT05fVFlQRV9CQUxMQVNUEAMSHgoaRk9VTkRBVElPTl9UWVBFX1'
    'NDUkVXX1BJTEUQBA==');

@$core.Deprecated('Use structuralDesignDescriptor instead')
const StructuralDesign$json = {
  '1': 'StructuralDesign',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'review_state', '3': 4, '4': 1, '5': 14, '6': '.structural.v1.ReviewState', '10': 'reviewState'},
    {'1': 'reviewed_by', '3': 5, '4': 1, '5': 9, '10': 'reviewedBy'},
    {'1': 'review_notes', '3': 6, '4': 1, '5': 9, '10': 'reviewNotes'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'dead_load_kn', '3': 9, '4': 1, '5': 1, '10': 'deadLoadKn'},
    {'1': 'wind_load_kn', '3': 10, '4': 1, '5': 1, '10': 'windLoadKn'},
    {'1': 'seismic_load_kn', '3': 11, '4': 1, '5': 1, '10': 'seismicLoadKn'},
    {'1': 'governing_load_kn', '3': 12, '4': 1, '5': 1, '10': 'governingLoadKn'},
    {'1': 'foundation', '3': 13, '4': 1, '5': 11, '6': '.structural.v1.FoundationResult', '10': 'foundation'},
  ],
};

/// Descriptor for `StructuralDesign`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List structuralDesignDescriptor = $convert.base64Decode(
    'ChBTdHJ1Y3R1cmFsRGVzaWduEg4KAmlkGAEgASgJUgJpZBIdCgpwcm9qZWN0X2lkGAIgASgJUg'
    'lwcm9qZWN0SWQSEgoEbmFtZRgDIAEoCVIEbmFtZRI9CgxyZXZpZXdfc3RhdGUYBCABKA4yGi5z'
    'dHJ1Y3R1cmFsLnYxLlJldmlld1N0YXRlUgtyZXZpZXdTdGF0ZRIfCgtyZXZpZXdlZF9ieRgFIA'
    'EoCVIKcmV2aWV3ZWRCeRIhCgxyZXZpZXdfbm90ZXMYBiABKAlSC3Jldmlld05vdGVzEjkKCmNy'
    'ZWF0ZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQ'
    'oKdXBkYXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRB'
    'dBIgCgxkZWFkX2xvYWRfa24YCSABKAFSCmRlYWRMb2FkS24SIAoMd2luZF9sb2FkX2tuGAogAS'
    'gBUgp3aW5kTG9hZEtuEiYKD3NlaXNtaWNfbG9hZF9rbhgLIAEoAVINc2Vpc21pY0xvYWRLbhIq'
    'ChFnb3Zlcm5pbmdfbG9hZF9rbhgMIAEoAVIPZ292ZXJuaW5nTG9hZEtuEj8KCmZvdW5kYXRpb2'
    '4YDSABKAsyHy5zdHJ1Y3R1cmFsLnYxLkZvdW5kYXRpb25SZXN1bHRSCmZvdW5kYXRpb24=');

@$core.Deprecated('Use computeDeadLoadRequestDescriptor instead')
const ComputeDeadLoadRequest$json = {
  '1': 'ComputeDeadLoadRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'panel_count', '3': 2, '4': 1, '5': 5, '10': 'panelCount'},
    {'1': 'panel_mass_kg', '3': 3, '4': 1, '5': 1, '10': 'panelMassKg'},
    {'1': 'mounting_mass_per_panel_kg', '3': 4, '4': 1, '5': 1, '10': 'mountingMassPerPanelKg'},
    {'1': 'cable_mass_kg', '3': 5, '4': 1, '5': 1, '10': 'cableMassKg'},
  ],
};

/// Descriptor for `ComputeDeadLoadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeDeadLoadRequestDescriptor = $convert.base64Decode(
    'ChZDb21wdXRlRGVhZExvYWRSZXF1ZXN0EhsKCWRlc2lnbl9pZBgBIAEoCVIIZGVzaWduSWQSHw'
    'oLcGFuZWxfY291bnQYAiABKAVSCnBhbmVsQ291bnQSIgoNcGFuZWxfbWFzc19rZxgDIAEoAVIL'
    'cGFuZWxNYXNzS2cSOgoabW91bnRpbmdfbWFzc19wZXJfcGFuZWxfa2cYBCABKAFSFm1vdW50aW'
    '5nTWFzc1BlclBhbmVsS2cSIgoNY2FibGVfbWFzc19rZxgFIAEoAVILY2FibGVNYXNzS2c=');

@$core.Deprecated('Use computeDeadLoadResponseDescriptor instead')
const ComputeDeadLoadResponse$json = {
  '1': 'ComputeDeadLoadResponse',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'panel_mass_total_kg', '3': 2, '4': 1, '5': 1, '10': 'panelMassTotalKg'},
    {'1': 'mounting_mass_total_kg', '3': 3, '4': 1, '5': 1, '10': 'mountingMassTotalKg'},
    {'1': 'cable_mass_kg', '3': 4, '4': 1, '5': 1, '10': 'cableMassKg'},
    {'1': 'total_mass_kg', '3': 5, '4': 1, '5': 1, '10': 'totalMassKg'},
    {'1': 'dead_load_kn', '3': 6, '4': 1, '5': 1, '10': 'deadLoadKn'},
    {'1': 'equation', '3': 7, '4': 1, '5': 9, '10': 'equation'},
  ],
};

/// Descriptor for `ComputeDeadLoadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeDeadLoadResponseDescriptor = $convert.base64Decode(
    'ChdDb21wdXRlRGVhZExvYWRSZXNwb25zZRIbCglkZXNpZ25faWQYASABKAlSCGRlc2lnbklkEi'
    '0KE3BhbmVsX21hc3NfdG90YWxfa2cYAiABKAFSEHBhbmVsTWFzc1RvdGFsS2cSMwoWbW91bnRp'
    'bmdfbWFzc190b3RhbF9rZxgDIAEoAVITbW91bnRpbmdNYXNzVG90YWxLZxIiCg1jYWJsZV9tYX'
    'NzX2tnGAQgASgBUgtjYWJsZU1hc3NLZxIiCg10b3RhbF9tYXNzX2tnGAUgASgBUgt0b3RhbE1h'
    'c3NLZxIgCgxkZWFkX2xvYWRfa24YBiABKAFSCmRlYWRMb2FkS24SGgoIZXF1YXRpb24YByABKA'
    'lSCGVxdWF0aW9u');

@$core.Deprecated('Use computeWindLoadRequestDescriptor instead')
const ComputeWindLoadRequest$json = {
  '1': 'ComputeWindLoadRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'wind_speed_m_s', '3': 2, '4': 1, '5': 1, '10': 'windSpeedMS'},
    {'1': 'exposure', '3': 3, '4': 1, '5': 14, '6': '.structural.v1.ExposureCategory', '10': 'exposure'},
    {'1': 'height_m', '3': 4, '4': 1, '5': 1, '10': 'heightM'},
    {'1': 'panel_tilt_deg', '3': 5, '4': 1, '5': 1, '10': 'panelTiltDeg'},
    {'1': 'total_panel_area_sqm', '3': 6, '4': 1, '5': 1, '10': 'totalPanelAreaSqm'},
    {'1': 'k_zt', '3': 7, '4': 1, '5': 1, '10': 'kZt'},
    {'1': 'k_d', '3': 8, '4': 1, '5': 1, '10': 'kD'},
    {'1': 'gust_factor', '3': 9, '4': 1, '5': 1, '10': 'gustFactor'},
  ],
};

/// Descriptor for `ComputeWindLoadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeWindLoadRequestDescriptor = $convert.base64Decode(
    'ChZDb21wdXRlV2luZExvYWRSZXF1ZXN0EhsKCWRlc2lnbl9pZBgBIAEoCVIIZGVzaWduSWQSIw'
    'oOd2luZF9zcGVlZF9tX3MYAiABKAFSC3dpbmRTcGVlZE1TEjsKCGV4cG9zdXJlGAMgASgOMh8u'
    'c3RydWN0dXJhbC52MS5FeHBvc3VyZUNhdGVnb3J5UghleHBvc3VyZRIZCghoZWlnaHRfbRgEIA'
    'EoAVIHaGVpZ2h0TRIkCg5wYW5lbF90aWx0X2RlZxgFIAEoAVIMcGFuZWxUaWx0RGVnEi8KFHRv'
    'dGFsX3BhbmVsX2FyZWFfc3FtGAYgASgBUhF0b3RhbFBhbmVsQXJlYVNxbRIRCgRrX3p0GAcgAS'
    'gBUgNrWnQSDwoDa19kGAggASgBUgJrRBIfCgtndXN0X2ZhY3RvchgJIAEoAVIKZ3VzdEZhY3Rv'
    'cg==');

@$core.Deprecated('Use computeWindLoadResponseDescriptor instead')
const ComputeWindLoadResponse$json = {
  '1': 'ComputeWindLoadResponse',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'k_z', '3': 2, '4': 1, '5': 1, '10': 'kZ'},
    {'1': 'q_z_pa', '3': 3, '4': 1, '5': 1, '10': 'qZPa'},
    {'1': 'c_p', '3': 4, '4': 1, '5': 1, '10': 'cP'},
    {'1': 'pressure_pa', '3': 5, '4': 1, '5': 1, '10': 'pressurePa'},
    {'1': 'total_wind_force_kn', '3': 6, '4': 1, '5': 1, '10': 'totalWindForceKn'},
    {'1': 'wind_uplift_kn', '3': 7, '4': 1, '5': 1, '10': 'windUpliftKn'},
    {'1': 'equation', '3': 8, '4': 1, '5': 9, '10': 'equation'},
  ],
};

/// Descriptor for `ComputeWindLoadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeWindLoadResponseDescriptor = $convert.base64Decode(
    'ChdDb21wdXRlV2luZExvYWRSZXNwb25zZRIbCglkZXNpZ25faWQYASABKAlSCGRlc2lnbklkEg'
    '8KA2tfehgCIAEoAVICa1oSFAoGcV96X3BhGAMgASgBUgRxWlBhEg8KA2NfcBgEIAEoAVICY1AS'
    'HwoLcHJlc3N1cmVfcGEYBSABKAFSCnByZXNzdXJlUGESLQoTdG90YWxfd2luZF9mb3JjZV9rbh'
    'gGIAEoAVIQdG90YWxXaW5kRm9yY2VLbhIkCg53aW5kX3VwbGlmdF9rbhgHIAEoAVIMd2luZFVw'
    'bGlmdEtuEhoKCGVxdWF0aW9uGAggASgJUghlcXVhdGlvbg==');

@$core.Deprecated('Use computeSeismicLoadRequestDescriptor instead')
const ComputeSeismicLoadRequest$json = {
  '1': 'ComputeSeismicLoadRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'sds', '3': 2, '4': 1, '5': 1, '10': 'sds'},
    {'1': 'total_mass_kg', '3': 3, '4': 1, '5': 1, '10': 'totalMassKg'},
    {'1': 'r_factor', '3': 4, '4': 1, '5': 1, '10': 'rFactor'},
    {'1': 'importance_factor', '3': 5, '4': 1, '5': 1, '10': 'importanceFactor'},
    {'1': 'cs_override', '3': 6, '4': 1, '5': 1, '10': 'csOverride'},
  ],
};

/// Descriptor for `ComputeSeismicLoadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeSeismicLoadRequestDescriptor = $convert.base64Decode(
    'ChlDb21wdXRlU2Vpc21pY0xvYWRSZXF1ZXN0EhsKCWRlc2lnbl9pZBgBIAEoCVIIZGVzaWduSW'
    'QSEAoDc2RzGAIgASgBUgNzZHMSIgoNdG90YWxfbWFzc19rZxgDIAEoAVILdG90YWxNYXNzS2cS'
    'GQoIcl9mYWN0b3IYBCABKAFSB3JGYWN0b3ISKwoRaW1wb3J0YW5jZV9mYWN0b3IYBSABKAFSEG'
    'ltcG9ydGFuY2VGYWN0b3ISHwoLY3Nfb3ZlcnJpZGUYBiABKAFSCmNzT3ZlcnJpZGU=');

@$core.Deprecated('Use computeSeismicLoadResponseDescriptor instead')
const ComputeSeismicLoadResponse$json = {
  '1': 'ComputeSeismicLoadResponse',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'cs', '3': 2, '4': 1, '5': 1, '10': 'cs'},
    {'1': 'seismic_weight_kn', '3': 3, '4': 1, '5': 1, '10': 'seismicWeightKn'},
    {'1': 'base_shear_kn', '3': 4, '4': 1, '5': 1, '10': 'baseShearKn'},
    {'1': 'equation', '3': 5, '4': 1, '5': 1, '10': 'equation'},
    {'1': 'equation_str', '3': 6, '4': 1, '5': 9, '10': 'equationStr'},
  ],
};

/// Descriptor for `ComputeSeismicLoadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeSeismicLoadResponseDescriptor = $convert.base64Decode(
    'ChpDb21wdXRlU2Vpc21pY0xvYWRSZXNwb25zZRIbCglkZXNpZ25faWQYASABKAlSCGRlc2lnbk'
    'lkEg4KAmNzGAIgASgBUgJjcxIqChFzZWlzbWljX3dlaWdodF9rbhgDIAEoAVIPc2Vpc21pY1dl'
    'aWdodEtuEiIKDWJhc2Vfc2hlYXJfa24YBCABKAFSC2Jhc2VTaGVhcktuEhoKCGVxdWF0aW9uGA'
    'UgASgBUghlcXVhdGlvbhIhCgxlcXVhdGlvbl9zdHIYBiABKAlSC2VxdWF0aW9uU3Ry');

@$core.Deprecated('Use computeFoundationRequirementRequestDescriptor instead')
const ComputeFoundationRequirementRequest$json = {
  '1': 'ComputeFoundationRequirementRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'dead_load_kn', '3': 2, '4': 1, '5': 1, '10': 'deadLoadKn'},
    {'1': 'wind_load_kn', '3': 3, '4': 1, '5': 1, '10': 'windLoadKn'},
    {'1': 'seismic_load_kn', '3': 4, '4': 1, '5': 1, '10': 'seismicLoadKn'},
    {'1': 'foundation_type', '3': 5, '4': 1, '5': 14, '6': '.structural.v1.FoundationType', '10': 'foundationType'},
    {'1': 'pile_capacity_kn', '3': 6, '4': 1, '5': 1, '10': 'pileCapacityKn'},
    {'1': 'total_area_sqm', '3': 7, '4': 1, '5': 1, '10': 'totalAreaSqm'},
  ],
};

/// Descriptor for `ComputeFoundationRequirementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeFoundationRequirementRequestDescriptor = $convert.base64Decode(
    'CiNDb21wdXRlRm91bmRhdGlvblJlcXVpcmVtZW50UmVxdWVzdBIbCglkZXNpZ25faWQYASABKA'
    'lSCGRlc2lnbklkEiAKDGRlYWRfbG9hZF9rbhgCIAEoAVIKZGVhZExvYWRLbhIgCgx3aW5kX2xv'
    'YWRfa24YAyABKAFSCndpbmRMb2FkS24SJgoPc2Vpc21pY19sb2FkX2tuGAQgASgBUg1zZWlzbW'
    'ljTG9hZEtuEkYKD2ZvdW5kYXRpb25fdHlwZRgFIAEoDjIdLnN0cnVjdHVyYWwudjEuRm91bmRh'
    'dGlvblR5cGVSDmZvdW5kYXRpb25UeXBlEigKEHBpbGVfY2FwYWNpdHlfa24YBiABKAFSDnBpbG'
    'VDYXBhY2l0eUtuEiQKDnRvdGFsX2FyZWFfc3FtGAcgASgBUgx0b3RhbEFyZWFTcW0=');

@$core.Deprecated('Use foundationResultDescriptor instead')
const FoundationResult$json = {
  '1': 'FoundationResult',
  '2': [
    {'1': 'pile_count', '3': 1, '4': 1, '5': 5, '10': 'pileCount'},
    {'1': 'design_load_kn', '3': 2, '4': 1, '5': 1, '10': 'designLoadKn'},
    {'1': 'pile_spacing_m', '3': 3, '4': 1, '5': 1, '10': 'pileSpacingM'},
    {'1': 'foundation_type', '3': 4, '4': 1, '5': 14, '6': '.structural.v1.FoundationType', '10': 'foundationType'},
    {'1': 'pile_capacity_kn', '3': 5, '4': 1, '5': 1, '10': 'pileCapacityKn'},
    {'1': 'load_combination', '3': 6, '4': 1, '5': 9, '10': 'loadCombination'},
  ],
};

/// Descriptor for `FoundationResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List foundationResultDescriptor = $convert.base64Decode(
    'ChBGb3VuZGF0aW9uUmVzdWx0Eh0KCnBpbGVfY291bnQYASABKAVSCXBpbGVDb3VudBIkCg5kZX'
    'NpZ25fbG9hZF9rbhgCIAEoAVIMZGVzaWduTG9hZEtuEiQKDnBpbGVfc3BhY2luZ19tGAMgASgB'
    'UgxwaWxlU3BhY2luZ00SRgoPZm91bmRhdGlvbl90eXBlGAQgASgOMh0uc3RydWN0dXJhbC52MS'
    '5Gb3VuZGF0aW9uVHlwZVIOZm91bmRhdGlvblR5cGUSKAoQcGlsZV9jYXBhY2l0eV9rbhgFIAEo'
    'AVIOcGlsZUNhcGFjaXR5S24SKQoQbG9hZF9jb21iaW5hdGlvbhgGIAEoCVIPbG9hZENvbWJpbm'
    'F0aW9u');

@$core.Deprecated('Use computeFoundationRequirementResponseDescriptor instead')
const ComputeFoundationRequirementResponse$json = {
  '1': 'ComputeFoundationRequirementResponse',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'result', '3': 2, '4': 1, '5': 11, '6': '.structural.v1.FoundationResult', '10': 'result'},
    {'1': 'equation', '3': 3, '4': 1, '5': 9, '10': 'equation'},
  ],
};

/// Descriptor for `ComputeFoundationRequirementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeFoundationRequirementResponseDescriptor = $convert.base64Decode(
    'CiRDb21wdXRlRm91bmRhdGlvblJlcXVpcmVtZW50UmVzcG9uc2USGwoJZGVzaWduX2lkGAEgAS'
    'gJUghkZXNpZ25JZBI3CgZyZXN1bHQYAiABKAsyHy5zdHJ1Y3R1cmFsLnYxLkZvdW5kYXRpb25S'
    'ZXN1bHRSBnJlc3VsdBIaCghlcXVhdGlvbhgDIAEoCVIIZXF1YXRpb24=');

@$core.Deprecated('Use structuralViolationDescriptor instead')
const StructuralViolation$json = {
  '1': 'StructuralViolation',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'limit', '3': 3, '4': 1, '5': 1, '10': 'limit'},
    {'1': 'actual', '3': 4, '4': 1, '5': 1, '10': 'actual'},
  ],
};

/// Descriptor for `StructuralViolation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List structuralViolationDescriptor = $convert.base64Decode(
    'ChNTdHJ1Y3R1cmFsVmlvbGF0aW9uEhIKBGNvZGUYASABKAlSBGNvZGUSGAoHbWVzc2FnZRgCIA'
    'EoCVIHbWVzc2FnZRIUCgVsaW1pdBgDIAEoAVIFbGltaXQSFgoGYWN0dWFsGAQgASgBUgZhY3R1'
    'YWw=');

@$core.Deprecated('Use validateStructuralDesignRequestDescriptor instead')
const ValidateStructuralDesignRequest$json = {
  '1': 'ValidateStructuralDesignRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'max_dc_ac_ratio', '3': 2, '4': 1, '5': 1, '10': 'maxDcAcRatio'},
    {'1': 'max_wind_pressure_pa', '3': 3, '4': 1, '5': 1, '10': 'maxWindPressurePa'},
    {'1': 'max_seismic_coefficient', '3': 4, '4': 1, '5': 1, '10': 'maxSeismicCoefficient'},
  ],
};

/// Descriptor for `ValidateStructuralDesignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateStructuralDesignRequestDescriptor = $convert.base64Decode(
    'Ch9WYWxpZGF0ZVN0cnVjdHVyYWxEZXNpZ25SZXF1ZXN0EhsKCWRlc2lnbl9pZBgBIAEoCVIIZG'
    'VzaWduSWQSJQoPbWF4X2RjX2FjX3JhdGlvGAIgASgBUgxtYXhEY0FjUmF0aW8SLwoUbWF4X3dp'
    'bmRfcHJlc3N1cmVfcGEYAyABKAFSEW1heFdpbmRQcmVzc3VyZVBhEjYKF21heF9zZWlzbWljX2'
    'NvZWZmaWNpZW50GAQgASgBUhVtYXhTZWlzbWljQ29lZmZpY2llbnQ=');

@$core.Deprecated('Use validateStructuralDesignResponseDescriptor instead')
const ValidateStructuralDesignResponse$json = {
  '1': 'ValidateStructuralDesignResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'violations', '3': 2, '4': 3, '5': 11, '6': '.structural.v1.StructuralViolation', '10': 'violations'},
    {'1': 'utilization_ratio', '3': 3, '4': 1, '5': 1, '10': 'utilizationRatio'},
  ],
};

/// Descriptor for `ValidateStructuralDesignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateStructuralDesignResponseDescriptor = $convert.base64Decode(
    'CiBWYWxpZGF0ZVN0cnVjdHVyYWxEZXNpZ25SZXNwb25zZRIUCgV2YWxpZBgBIAEoCFIFdmFsaW'
    'QSQgoKdmlvbGF0aW9ucxgCIAMoCzIiLnN0cnVjdHVyYWwudjEuU3RydWN0dXJhbFZpb2xhdGlv'
    'blIKdmlvbGF0aW9ucxIrChF1dGlsaXphdGlvbl9yYXRpbxgDIAEoAVIQdXRpbGl6YXRpb25SYX'
    'Rpbw==');

@$core.Deprecated('Use submitForReviewRequestDescriptor instead')
const SubmitForReviewRequest$json = {
  '1': 'SubmitForReviewRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'submitted_by', '3': 2, '4': 1, '5': 9, '10': 'submittedBy'},
    {'1': 'notes', '3': 3, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SubmitForReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitForReviewRequestDescriptor = $convert.base64Decode(
    'ChZTdWJtaXRGb3JSZXZpZXdSZXF1ZXN0EhsKCWRlc2lnbl9pZBgBIAEoCVIIZGVzaWduSWQSIQ'
    'oMc3VibWl0dGVkX2J5GAIgASgJUgtzdWJtaXR0ZWRCeRIUCgVub3RlcxgDIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use submitForReviewResponseDescriptor instead')
const SubmitForReviewResponse$json = {
  '1': 'SubmitForReviewResponse',
  '2': [
    {'1': 'design', '3': 1, '4': 1, '5': 11, '6': '.structural.v1.StructuralDesign', '10': 'design'},
  ],
};

/// Descriptor for `SubmitForReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitForReviewResponseDescriptor = $convert.base64Decode(
    'ChdTdWJtaXRGb3JSZXZpZXdSZXNwb25zZRI3CgZkZXNpZ24YASABKAsyHy5zdHJ1Y3R1cmFsLn'
    'YxLlN0cnVjdHVyYWxEZXNpZ25SBmRlc2lnbg==');

@$core.Deprecated('Use approveDesignRequestDescriptor instead')
const ApproveDesignRequest$json = {
  '1': 'ApproveDesignRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'approved_by', '3': 2, '4': 1, '5': 9, '10': 'approvedBy'},
    {'1': 'notes', '3': 3, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `ApproveDesignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveDesignRequestDescriptor = $convert.base64Decode(
    'ChRBcHByb3ZlRGVzaWduUmVxdWVzdBIbCglkZXNpZ25faWQYASABKAlSCGRlc2lnbklkEh8KC2'
    'FwcHJvdmVkX2J5GAIgASgJUgphcHByb3ZlZEJ5EhQKBW5vdGVzGAMgASgJUgVub3Rlcw==');

@$core.Deprecated('Use approveDesignResponseDescriptor instead')
const ApproveDesignResponse$json = {
  '1': 'ApproveDesignResponse',
  '2': [
    {'1': 'design', '3': 1, '4': 1, '5': 11, '6': '.structural.v1.StructuralDesign', '10': 'design'},
  ],
};

/// Descriptor for `ApproveDesignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveDesignResponseDescriptor = $convert.base64Decode(
    'ChVBcHByb3ZlRGVzaWduUmVzcG9uc2USNwoGZGVzaWduGAEgASgLMh8uc3RydWN0dXJhbC52MS'
    '5TdHJ1Y3R1cmFsRGVzaWduUgZkZXNpZ24=');

@$core.Deprecated('Use rejectDesignRequestDescriptor instead')
const RejectDesignRequest$json = {
  '1': 'RejectDesignRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'rejected_by', '3': 2, '4': 1, '5': 9, '10': 'rejectedBy'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RejectDesignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectDesignRequestDescriptor = $convert.base64Decode(
    'ChNSZWplY3REZXNpZ25SZXF1ZXN0EhsKCWRlc2lnbl9pZBgBIAEoCVIIZGVzaWduSWQSHwoLcm'
    'VqZWN0ZWRfYnkYAiABKAlSCnJlamVjdGVkQnkSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use rejectDesignResponseDescriptor instead')
const RejectDesignResponse$json = {
  '1': 'RejectDesignResponse',
  '2': [
    {'1': 'design', '3': 1, '4': 1, '5': 11, '6': '.structural.v1.StructuralDesign', '10': 'design'},
  ],
};

/// Descriptor for `RejectDesignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectDesignResponseDescriptor = $convert.base64Decode(
    'ChRSZWplY3REZXNpZ25SZXNwb25zZRI3CgZkZXNpZ24YASABKAsyHy5zdHJ1Y3R1cmFsLnYxLl'
    'N0cnVjdHVyYWxEZXNpZ25SBmRlc2lnbg==');

@$core.Deprecated('Use generateStructuralReportRequestDescriptor instead')
const GenerateStructuralReportRequest$json = {
  '1': 'GenerateStructuralReportRequest',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
  ],
};

/// Descriptor for `GenerateStructuralReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateStructuralReportRequestDescriptor = $convert.base64Decode(
    'Ch9HZW5lcmF0ZVN0cnVjdHVyYWxSZXBvcnRSZXF1ZXN0EhsKCWRlc2lnbl9pZBgBIAEoCVIIZG'
    'VzaWduSWQ=');

@$core.Deprecated('Use generateStructuralReportResponseDescriptor instead')
const GenerateStructuralReportResponse$json = {
  '1': 'GenerateStructuralReportResponse',
  '2': [
    {'1': 'design_id', '3': 1, '4': 1, '5': 9, '10': 'designId'},
    {'1': 'report_text', '3': 2, '4': 1, '5': 9, '10': 'reportText'},
    {'1': 'review_state', '3': 3, '4': 1, '5': 14, '6': '.structural.v1.ReviewState', '10': 'reviewState'},
  ],
};

/// Descriptor for `GenerateStructuralReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateStructuralReportResponseDescriptor = $convert.base64Decode(
    'CiBHZW5lcmF0ZVN0cnVjdHVyYWxSZXBvcnRSZXNwb25zZRIbCglkZXNpZ25faWQYASABKAlSCG'
    'Rlc2lnbklkEh8KC3JlcG9ydF90ZXh0GAIgASgJUgpyZXBvcnRUZXh0Ej0KDHJldmlld19zdGF0'
    'ZRgDIAEoDjIaLnN0cnVjdHVyYWwudjEuUmV2aWV3U3RhdGVSC3Jldmlld1N0YXRl');

@$core.Deprecated('Use createDesignRequestDescriptor instead')
const CreateDesignRequest$json = {
  '1': 'CreateDesignRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `CreateDesignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDesignRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVEZXNpZ25SZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBISCg'
    'RuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use createDesignResponseDescriptor instead')
const CreateDesignResponse$json = {
  '1': 'CreateDesignResponse',
  '2': [
    {'1': 'design', '3': 1, '4': 1, '5': 11, '6': '.structural.v1.StructuralDesign', '10': 'design'},
  ],
};

/// Descriptor for `CreateDesignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDesignResponseDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVEZXNpZ25SZXNwb25zZRI3CgZkZXNpZ24YASABKAsyHy5zdHJ1Y3R1cmFsLnYxLl'
    'N0cnVjdHVyYWxEZXNpZ25SBmRlc2lnbg==');

@$core.Deprecated('Use getDesignRequestDescriptor instead')
const GetDesignRequest$json = {
  '1': 'GetDesignRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetDesignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDesignRequestDescriptor = $convert.base64Decode(
    'ChBHZXREZXNpZ25SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use getDesignResponseDescriptor instead')
const GetDesignResponse$json = {
  '1': 'GetDesignResponse',
  '2': [
    {'1': 'design', '3': 1, '4': 1, '5': 11, '6': '.structural.v1.StructuralDesign', '10': 'design'},
  ],
};

/// Descriptor for `GetDesignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDesignResponseDescriptor = $convert.base64Decode(
    'ChFHZXREZXNpZ25SZXNwb25zZRI3CgZkZXNpZ24YASABKAsyHy5zdHJ1Y3R1cmFsLnYxLlN0cn'
    'VjdHVyYWxEZXNpZ25SBmRlc2lnbg==');

@$core.Deprecated('Use listDesignsRequestDescriptor instead')
const ListDesignsRequest$json = {
  '1': 'ListDesignsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListDesignsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDesignsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0RGVzaWduc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElk');

@$core.Deprecated('Use listDesignsResponseDescriptor instead')
const ListDesignsResponse$json = {
  '1': 'ListDesignsResponse',
  '2': [
    {'1': 'designs', '3': 1, '4': 3, '5': 11, '6': '.structural.v1.StructuralDesign', '10': 'designs'},
  ],
};

/// Descriptor for `ListDesignsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDesignsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0RGVzaWduc1Jlc3BvbnNlEjkKB2Rlc2lnbnMYASADKAsyHy5zdHJ1Y3R1cmFsLnYxLl'
    'N0cnVjdHVyYWxEZXNpZ25SB2Rlc2lnbnM=');

@$core.Deprecated('Use deleteDesignRequestDescriptor instead')
const DeleteDesignRequest$json = {
  '1': 'DeleteDesignRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteDesignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteDesignRequestDescriptor = $convert.base64Decode(
    'ChNEZWxldGVEZXNpZ25SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deleteDesignResponseDescriptor instead')
const DeleteDesignResponse$json = {
  '1': 'DeleteDesignResponse',
};

/// Descriptor for `DeleteDesignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteDesignResponseDescriptor = $convert.base64Decode(
    'ChREZWxldGVEZXNpZ25SZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> StructuralServiceBase$json = {
  '1': 'StructuralService',
  '2': [
    {'1': 'CreateDesign', '2': '.structural.v1.CreateDesignRequest', '3': '.structural.v1.CreateDesignResponse'},
    {'1': 'GetDesign', '2': '.structural.v1.GetDesignRequest', '3': '.structural.v1.GetDesignResponse'},
    {'1': 'ListDesigns', '2': '.structural.v1.ListDesignsRequest', '3': '.structural.v1.ListDesignsResponse'},
    {'1': 'DeleteDesign', '2': '.structural.v1.DeleteDesignRequest', '3': '.structural.v1.DeleteDesignResponse'},
    {'1': 'ComputeDeadLoad', '2': '.structural.v1.ComputeDeadLoadRequest', '3': '.structural.v1.ComputeDeadLoadResponse'},
    {'1': 'ComputeWindLoad', '2': '.structural.v1.ComputeWindLoadRequest', '3': '.structural.v1.ComputeWindLoadResponse'},
    {'1': 'ComputeSeismicLoad', '2': '.structural.v1.ComputeSeismicLoadRequest', '3': '.structural.v1.ComputeSeismicLoadResponse'},
    {'1': 'ComputeFoundationRequirement', '2': '.structural.v1.ComputeFoundationRequirementRequest', '3': '.structural.v1.ComputeFoundationRequirementResponse'},
    {'1': 'ValidateStructuralDesign', '2': '.structural.v1.ValidateStructuralDesignRequest', '3': '.structural.v1.ValidateStructuralDesignResponse'},
    {'1': 'SubmitForReview', '2': '.structural.v1.SubmitForReviewRequest', '3': '.structural.v1.SubmitForReviewResponse'},
    {'1': 'ApproveDesign', '2': '.structural.v1.ApproveDesignRequest', '3': '.structural.v1.ApproveDesignResponse'},
    {'1': 'RejectDesign', '2': '.structural.v1.RejectDesignRequest', '3': '.structural.v1.RejectDesignResponse'},
    {'1': 'GenerateStructuralReport', '2': '.structural.v1.GenerateStructuralReportRequest', '3': '.structural.v1.GenerateStructuralReportResponse'},
  ],
};

@$core.Deprecated('Use structuralServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> StructuralServiceBase$messageJson = {
  '.structural.v1.CreateDesignRequest': CreateDesignRequest$json,
  '.structural.v1.CreateDesignResponse': CreateDesignResponse$json,
  '.structural.v1.StructuralDesign': StructuralDesign$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.structural.v1.FoundationResult': FoundationResult$json,
  '.structural.v1.GetDesignRequest': GetDesignRequest$json,
  '.structural.v1.GetDesignResponse': GetDesignResponse$json,
  '.structural.v1.ListDesignsRequest': ListDesignsRequest$json,
  '.structural.v1.ListDesignsResponse': ListDesignsResponse$json,
  '.structural.v1.DeleteDesignRequest': DeleteDesignRequest$json,
  '.structural.v1.DeleteDesignResponse': DeleteDesignResponse$json,
  '.structural.v1.ComputeDeadLoadRequest': ComputeDeadLoadRequest$json,
  '.structural.v1.ComputeDeadLoadResponse': ComputeDeadLoadResponse$json,
  '.structural.v1.ComputeWindLoadRequest': ComputeWindLoadRequest$json,
  '.structural.v1.ComputeWindLoadResponse': ComputeWindLoadResponse$json,
  '.structural.v1.ComputeSeismicLoadRequest': ComputeSeismicLoadRequest$json,
  '.structural.v1.ComputeSeismicLoadResponse': ComputeSeismicLoadResponse$json,
  '.structural.v1.ComputeFoundationRequirementRequest': ComputeFoundationRequirementRequest$json,
  '.structural.v1.ComputeFoundationRequirementResponse': ComputeFoundationRequirementResponse$json,
  '.structural.v1.ValidateStructuralDesignRequest': ValidateStructuralDesignRequest$json,
  '.structural.v1.ValidateStructuralDesignResponse': ValidateStructuralDesignResponse$json,
  '.structural.v1.StructuralViolation': StructuralViolation$json,
  '.structural.v1.SubmitForReviewRequest': SubmitForReviewRequest$json,
  '.structural.v1.SubmitForReviewResponse': SubmitForReviewResponse$json,
  '.structural.v1.ApproveDesignRequest': ApproveDesignRequest$json,
  '.structural.v1.ApproveDesignResponse': ApproveDesignResponse$json,
  '.structural.v1.RejectDesignRequest': RejectDesignRequest$json,
  '.structural.v1.RejectDesignResponse': RejectDesignResponse$json,
  '.structural.v1.GenerateStructuralReportRequest': GenerateStructuralReportRequest$json,
  '.structural.v1.GenerateStructuralReportResponse': GenerateStructuralReportResponse$json,
};

/// Descriptor for `StructuralService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List structuralServiceDescriptor = $convert.base64Decode(
    'ChFTdHJ1Y3R1cmFsU2VydmljZRJXCgxDcmVhdGVEZXNpZ24SIi5zdHJ1Y3R1cmFsLnYxLkNyZW'
    'F0ZURlc2lnblJlcXVlc3QaIy5zdHJ1Y3R1cmFsLnYxLkNyZWF0ZURlc2lnblJlc3BvbnNlEk4K'
    'CUdldERlc2lnbhIfLnN0cnVjdHVyYWwudjEuR2V0RGVzaWduUmVxdWVzdBogLnN0cnVjdHVyYW'
    'wudjEuR2V0RGVzaWduUmVzcG9uc2USVAoLTGlzdERlc2lnbnMSIS5zdHJ1Y3R1cmFsLnYxLkxp'
    'c3REZXNpZ25zUmVxdWVzdBoiLnN0cnVjdHVyYWwudjEuTGlzdERlc2lnbnNSZXNwb25zZRJXCg'
    'xEZWxldGVEZXNpZ24SIi5zdHJ1Y3R1cmFsLnYxLkRlbGV0ZURlc2lnblJlcXVlc3QaIy5zdHJ1'
    'Y3R1cmFsLnYxLkRlbGV0ZURlc2lnblJlc3BvbnNlEmAKD0NvbXB1dGVEZWFkTG9hZBIlLnN0cn'
    'VjdHVyYWwudjEuQ29tcHV0ZURlYWRMb2FkUmVxdWVzdBomLnN0cnVjdHVyYWwudjEuQ29tcHV0'
    'ZURlYWRMb2FkUmVzcG9uc2USYAoPQ29tcHV0ZVdpbmRMb2FkEiUuc3RydWN0dXJhbC52MS5Db2'
    '1wdXRlV2luZExvYWRSZXF1ZXN0GiYuc3RydWN0dXJhbC52MS5Db21wdXRlV2luZExvYWRSZXNw'
    'b25zZRJpChJDb21wdXRlU2Vpc21pY0xvYWQSKC5zdHJ1Y3R1cmFsLnYxLkNvbXB1dGVTZWlzbW'
    'ljTG9hZFJlcXVlc3QaKS5zdHJ1Y3R1cmFsLnYxLkNvbXB1dGVTZWlzbWljTG9hZFJlc3BvbnNl'
    'EocBChxDb21wdXRlRm91bmRhdGlvblJlcXVpcmVtZW50EjIuc3RydWN0dXJhbC52MS5Db21wdX'
    'RlRm91bmRhdGlvblJlcXVpcmVtZW50UmVxdWVzdBozLnN0cnVjdHVyYWwudjEuQ29tcHV0ZUZv'
    'dW5kYXRpb25SZXF1aXJlbWVudFJlc3BvbnNlEnsKGFZhbGlkYXRlU3RydWN0dXJhbERlc2lnbh'
    'IuLnN0cnVjdHVyYWwudjEuVmFsaWRhdGVTdHJ1Y3R1cmFsRGVzaWduUmVxdWVzdBovLnN0cnVj'
    'dHVyYWwudjEuVmFsaWRhdGVTdHJ1Y3R1cmFsRGVzaWduUmVzcG9uc2USYAoPU3VibWl0Rm9yUm'
    'V2aWV3EiUuc3RydWN0dXJhbC52MS5TdWJtaXRGb3JSZXZpZXdSZXF1ZXN0GiYuc3RydWN0dXJh'
    'bC52MS5TdWJtaXRGb3JSZXZpZXdSZXNwb25zZRJaCg1BcHByb3ZlRGVzaWduEiMuc3RydWN0dX'
    'JhbC52MS5BcHByb3ZlRGVzaWduUmVxdWVzdBokLnN0cnVjdHVyYWwudjEuQXBwcm92ZURlc2ln'
    'blJlc3BvbnNlElcKDFJlamVjdERlc2lnbhIiLnN0cnVjdHVyYWwudjEuUmVqZWN0RGVzaWduUm'
    'VxdWVzdBojLnN0cnVjdHVyYWwudjEuUmVqZWN0RGVzaWduUmVzcG9uc2USewoYR2VuZXJhdGVT'
    'dHJ1Y3R1cmFsUmVwb3J0Ei4uc3RydWN0dXJhbC52MS5HZW5lcmF0ZVN0cnVjdHVyYWxSZXBvcn'
    'RSZXF1ZXN0Gi8uc3RydWN0dXJhbC52MS5HZW5lcmF0ZVN0cnVjdHVyYWxSZXBvcnRSZXNwb25z'
    'ZQ==');

