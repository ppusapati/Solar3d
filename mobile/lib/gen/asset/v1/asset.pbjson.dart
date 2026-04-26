//
//  Generated code. Do not modify.
//  source: asset/v1/asset.proto
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

@$core.Deprecated('Use assetCategoryDescriptor instead')
const AssetCategory$json = {
  '1': 'AssetCategory',
  '2': [
    {'1': 'ASSET_CATEGORY_UNSPECIFIED', '2': 0},
    {'1': 'ASSET_CATEGORY_SOLAR_PANEL', '2': 1},
    {'1': 'ASSET_CATEGORY_TRACKER', '2': 2},
    {'1': 'ASSET_CATEGORY_STRING_INVERTER', '2': 3},
    {'1': 'ASSET_CATEGORY_CENTRAL_INVERTER', '2': 4},
    {'1': 'ASSET_CATEGORY_TRANSFORMER', '2': 5},
    {'1': 'ASSET_CATEGORY_JUNCTION_BOX', '2': 6},
    {'1': 'ASSET_CATEGORY_COMBINER_BOX', '2': 7},
    {'1': 'ASSET_CATEGORY_CABLE', '2': 8},
    {'1': 'ASSET_CATEGORY_MOUNTING_STRUCTURE', '2': 9},
    {'1': 'ASSET_CATEGORY_SUBSTATION', '2': 10},
  ],
};

/// Descriptor for `AssetCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetCategoryDescriptor = $convert.base64Decode(
    'Cg1Bc3NldENhdGVnb3J5Eh4KGkFTU0VUX0NBVEVHT1JZX1VOU1BFQ0lGSUVEEAASHgoaQVNTRV'
    'RfQ0FURUdPUllfU09MQVJfUEFORUwQARIaChZBU1NFVF9DQVRFR09SWV9UUkFDS0VSEAISIgoe'
    'QVNTRVRfQ0FURUdPUllfU1RSSU5HX0lOVkVSVEVSEAMSIwofQVNTRVRfQ0FURUdPUllfQ0VOVF'
    'JBTF9JTlZFUlRFUhAEEh4KGkFTU0VUX0NBVEVHT1JZX1RSQU5TRk9STUVSEAUSHwobQVNTRVRf'
    'Q0FURUdPUllfSlVOQ1RJT05fQk9YEAYSHwobQVNTRVRfQ0FURUdPUllfQ09NQklORVJfQk9YEA'
    'cSGAoUQVNTRVRfQ0FURUdPUllfQ0FCTEUQCBIlCiFBU1NFVF9DQVRFR09SWV9NT1VOVElOR19T'
    'VFJVQ1RVUkUQCRIdChlBU1NFVF9DQVRFR09SWV9TVUJTVEFUSU9OEAo=');

@$core.Deprecated('Use cellTechnologyDescriptor instead')
const CellTechnology$json = {
  '1': 'CellTechnology',
  '2': [
    {'1': 'CELL_TECHNOLOGY_UNSPECIFIED', '2': 0},
    {'1': 'CELL_TECHNOLOGY_MONO_PERC', '2': 1},
    {'1': 'CELL_TECHNOLOGY_POLY', '2': 2},
    {'1': 'CELL_TECHNOLOGY_TOPCON', '2': 3},
    {'1': 'CELL_TECHNOLOGY_HJT', '2': 4},
    {'1': 'CELL_TECHNOLOGY_IBC', '2': 5},
    {'1': 'CELL_TECHNOLOGY_THIN_FILM', '2': 6},
    {'1': 'CELL_TECHNOLOGY_PERC_PLUS', '2': 7},
  ],
};

/// Descriptor for `CellTechnology`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cellTechnologyDescriptor = $convert.base64Decode(
    'Cg5DZWxsVGVjaG5vbG9neRIfChtDRUxMX1RFQ0hOT0xPR1lfVU5TUEVDSUZJRUQQABIdChlDRU'
    'xMX1RFQ0hOT0xPR1lfTU9OT19QRVJDEAESGAoUQ0VMTF9URUNITk9MT0dZX1BPTFkQAhIaChZD'
    'RUxMX1RFQ0hOT0xPR1lfVE9QQ09OEAMSFwoTQ0VMTF9URUNITk9MT0dZX0hKVBAEEhcKE0NFTE'
    'xfVEVDSE5PTE9HWV9JQkMQBRIdChlDRUxMX1RFQ0hOT0xPR1lfVEhJTl9GSUxNEAYSHQoZQ0VM'
    'TF9URUNITk9MT0dZX1BFUkNfUExVUxAH');

@$core.Deprecated('Use frameTypeDescriptor instead')
const FrameType$json = {
  '1': 'FrameType',
  '2': [
    {'1': 'FRAME_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FRAME_TYPE_ANODIZED_ALUMINUM', '2': 1},
    {'1': 'FRAME_TYPE_BLACK_ANODIZED', '2': 2},
    {'1': 'FRAME_TYPE_FRAMELESS', '2': 3},
  ],
};

/// Descriptor for `FrameType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List frameTypeDescriptor = $convert.base64Decode(
    'CglGcmFtZVR5cGUSGgoWRlJBTUVfVFlQRV9VTlNQRUNJRklFRBAAEiAKHEZSQU1FX1RZUEVfQU'
    '5PRElaRURfQUxVTUlOVU0QARIdChlGUkFNRV9UWVBFX0JMQUNLX0FOT0RJWkVEEAISGAoURlJB'
    'TUVfVFlQRV9GUkFNRUxFU1MQAw==');

@$core.Deprecated('Use inverterTopologyDescriptor instead')
const InverterTopology$json = {
  '1': 'InverterTopology',
  '2': [
    {'1': 'INVERTER_TOPOLOGY_UNSPECIFIED', '2': 0},
    {'1': 'INVERTER_TOPOLOGY_TRANSFORMER_LESS', '2': 1},
    {'1': 'INVERTER_TOPOLOGY_HF_TRANSFORMER', '2': 2},
    {'1': 'INVERTER_TOPOLOGY_LF_TRANSFORMER', '2': 3},
  ],
};

/// Descriptor for `InverterTopology`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List inverterTopologyDescriptor = $convert.base64Decode(
    'ChBJbnZlcnRlclRvcG9sb2d5EiEKHUlOVkVSVEVSX1RPUE9MT0dZX1VOU1BFQ0lGSUVEEAASJg'
    'oiSU5WRVJURVJfVE9QT0xPR1lfVFJBTlNGT1JNRVJfTEVTUxABEiQKIElOVkVSVEVSX1RPUE9M'
    'T0dZX0hGX1RSQU5TRk9STUVSEAISJAogSU5WRVJURVJfVE9QT0xPR1lfTEZfVFJBTlNGT1JNRV'
    'IQAw==');

@$core.Deprecated('Use inverterGridTypeDescriptor instead')
const InverterGridType$json = {
  '1': 'InverterGridType',
  '2': [
    {'1': 'INVERTER_GRID_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'INVERTER_GRID_TYPE_GRID_TIED', '2': 1},
    {'1': 'INVERTER_GRID_TYPE_HYBRID', '2': 2},
    {'1': 'INVERTER_GRID_TYPE_OFF_GRID', '2': 3},
  ],
};

/// Descriptor for `InverterGridType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List inverterGridTypeDescriptor = $convert.base64Decode(
    'ChBJbnZlcnRlckdyaWRUeXBlEiIKHklOVkVSVEVSX0dSSURfVFlQRV9VTlNQRUNJRklFRBAAEi'
    'AKHElOVkVSVEVSX0dSSURfVFlQRV9HUklEX1RJRUQQARIdChlJTlZFUlRFUl9HUklEX1RZUEVf'
    'SFlCUklEEAISHwobSU5WRVJURVJfR1JJRF9UWVBFX09GRl9HUklEEAM=');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'manufacturer', '3': 3, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'model', '3': 4, '4': 1, '5': 9, '10': 'model'},
    {'1': 'category', '3': 5, '4': 1, '5': 14, '6': '.asset.v1.AssetCategory', '10': 'category'},
    {'1': 'dimensions', '3': 6, '4': 1, '5': 11, '6': '.asset.v1.Dimensions', '10': 'dimensions'},
    {'1': 'electrical', '3': 7, '4': 1, '5': 11, '6': '.asset.v1.ElectricalParameters', '10': 'electrical'},
    {'1': 'model_3d_path', '3': 8, '4': 1, '5': 9, '10': 'model3dPath'},
    {'1': 'datasheet_path', '3': 9, '4': 1, '5': 9, '10': 'datasheetPath'},
    {'1': 'metadata_json', '3': 10, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'created_at', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIiCgxtYW51ZmFjdH'
    'VyZXIYAyABKAlSDG1hbnVmYWN0dXJlchIUCgVtb2RlbBgEIAEoCVIFbW9kZWwSMwoIY2F0ZWdv'
    'cnkYBSABKA4yFy5hc3NldC52MS5Bc3NldENhdGVnb3J5UghjYXRlZ29yeRI0CgpkaW1lbnNpb2'
    '5zGAYgASgLMhQuYXNzZXQudjEuRGltZW5zaW9uc1IKZGltZW5zaW9ucxI+CgplbGVjdHJpY2Fs'
    'GAcgASgLMh4uYXNzZXQudjEuRWxlY3RyaWNhbFBhcmFtZXRlcnNSCmVsZWN0cmljYWwSIgoNbW'
    '9kZWxfM2RfcGF0aBgIIAEoCVILbW9kZWwzZFBhdGgSJQoOZGF0YXNoZWV0X3BhdGgYCSABKAlS'
    'DWRhdGFzaGVldFBhdGgSIwoNbWV0YWRhdGFfanNvbhgKIAEoCVIMbWV0YWRhdGFKc29uEjkKCm'
    'NyZWF0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQS'
    'OQoKdXBkYXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZW'
    'RBdA==');

@$core.Deprecated('Use dimensionsDescriptor instead')
const Dimensions$json = {
  '1': 'Dimensions',
  '2': [
    {'1': 'width_mm', '3': 1, '4': 1, '5': 1, '10': 'widthMm'},
    {'1': 'height_mm', '3': 2, '4': 1, '5': 1, '10': 'heightMm'},
    {'1': 'depth_mm', '3': 3, '4': 1, '5': 1, '10': 'depthMm'},
    {'1': 'weight_kg', '3': 4, '4': 1, '5': 1, '10': 'weightKg'},
    {'1': 'cell_count', '3': 5, '4': 1, '5': 5, '10': 'cellCount'},
    {'1': 'cell_technology', '3': 6, '4': 1, '5': 14, '6': '.asset.v1.CellTechnology', '10': 'cellTechnology'},
    {'1': 'frame_type', '3': 7, '4': 1, '5': 14, '6': '.asset.v1.FrameType', '10': 'frameType'},
    {'1': 'mounting_hole_count', '3': 8, '4': 1, '5': 5, '10': 'mountingHoleCount'},
  ],
};

/// Descriptor for `Dimensions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dimensionsDescriptor = $convert.base64Decode(
    'CgpEaW1lbnNpb25zEhkKCHdpZHRoX21tGAEgASgBUgd3aWR0aE1tEhsKCWhlaWdodF9tbRgCIA'
    'EoAVIIaGVpZ2h0TW0SGQoIZGVwdGhfbW0YAyABKAFSB2RlcHRoTW0SGwoJd2VpZ2h0X2tnGAQg'
    'ASgBUgh3ZWlnaHRLZxIdCgpjZWxsX2NvdW50GAUgASgFUgljZWxsQ291bnQSQQoPY2VsbF90ZW'
    'Nobm9sb2d5GAYgASgOMhguYXNzZXQudjEuQ2VsbFRlY2hub2xvZ3lSDmNlbGxUZWNobm9sb2d5'
    'EjIKCmZyYW1lX3R5cGUYByABKA4yEy5hc3NldC52MS5GcmFtZVR5cGVSCWZyYW1lVHlwZRIuCh'
    'Ntb3VudGluZ19ob2xlX2NvdW50GAggASgFUhFtb3VudGluZ0hvbGVDb3VudA==');

@$core.Deprecated('Use electricalParametersDescriptor instead')
const ElectricalParameters$json = {
  '1': 'ElectricalParameters',
  '2': [
    {'1': 'rated_power_w', '3': 1, '4': 1, '5': 1, '10': 'ratedPowerW'},
    {'1': 'voc', '3': 2, '4': 1, '5': 1, '10': 'voc'},
    {'1': 'isc', '3': 3, '4': 1, '5': 1, '10': 'isc'},
    {'1': 'vmp', '3': 4, '4': 1, '5': 1, '10': 'vmp'},
    {'1': 'imp', '3': 5, '4': 1, '5': 1, '10': 'imp'},
    {'1': 'efficiency', '3': 6, '4': 1, '5': 1, '10': 'efficiency'},
    {'1': 'temp_coefficient_pmax', '3': 7, '4': 1, '5': 1, '10': 'tempCoefficientPmax'},
    {'1': 'temp_coefficient_voc', '3': 8, '4': 1, '5': 1, '10': 'tempCoefficientVoc'},
    {'1': 'max_dc_input_w', '3': 9, '4': 1, '5': 1, '10': 'maxDcInputW'},
    {'1': 'max_ac_output_w', '3': 10, '4': 1, '5': 1, '10': 'maxAcOutputW'},
    {'1': 'mppt_count', '3': 11, '4': 1, '5': 5, '10': 'mpptCount'},
    {'1': 'max_input_voltage', '3': 12, '4': 1, '5': 1, '10': 'maxInputVoltage'},
    {'1': 'min_input_voltage', '3': 13, '4': 1, '5': 1, '10': 'minInputVoltage'},
    {'1': 'max_strings_per_mppt', '3': 14, '4': 1, '5': 5, '10': 'maxStringsPerMppt'},
    {'1': 'kva_rating', '3': 15, '4': 1, '5': 1, '10': 'kvaRating'},
    {'1': 'primary_voltage', '3': 16, '4': 1, '5': 1, '10': 'primaryVoltage'},
    {'1': 'secondary_voltage', '3': 17, '4': 1, '5': 1, '10': 'secondaryVoltage'},
    {'1': 'temp_coefficient_isc', '3': 18, '4': 1, '5': 1, '10': 'tempCoefficientIsc'},
    {'1': 'noct_c', '3': 19, '4': 1, '5': 1, '10': 'noctC'},
    {'1': 'bifacial_factor', '3': 20, '4': 1, '5': 1, '10': 'bifacialFactor'},
    {'1': 'max_system_voltage', '3': 21, '4': 1, '5': 1, '10': 'maxSystemVoltage'},
    {'1': 'series_fuse_rating_a', '3': 22, '4': 1, '5': 1, '10': 'seriesFuseRatingA'},
    {'1': 'nominal_power_tolerance_pct', '3': 23, '4': 1, '5': 1, '10': 'nominalPowerTolerancePct'},
    {'1': 'cells_in_series', '3': 24, '4': 1, '5': 5, '10': 'cellsInSeries'},
    {'1': 'cells_in_parallel', '3': 25, '4': 1, '5': 5, '10': 'cellsInParallel'},
    {'1': 'euro_efficiency', '3': 26, '4': 1, '5': 1, '10': 'euroEfficiency'},
    {'1': 'cec_efficiency', '3': 27, '4': 1, '5': 1, '10': 'cecEfficiency'},
    {'1': 'max_efficiency', '3': 28, '4': 1, '5': 1, '10': 'maxEfficiency'},
    {'1': 'mppt_min_voltage', '3': 29, '4': 1, '5': 1, '10': 'mpptMinVoltage'},
    {'1': 'mppt_max_voltage', '3': 30, '4': 1, '5': 1, '10': 'mpptMaxVoltage'},
    {'1': 'startup_voltage', '3': 31, '4': 1, '5': 1, '10': 'startupVoltage'},
    {'1': 'max_dc_input_current_a', '3': 32, '4': 1, '5': 1, '10': 'maxDcInputCurrentA'},
    {'1': 'max_output_current_a', '3': 33, '4': 1, '5': 1, '10': 'maxOutputCurrentA'},
    {'1': 'rated_ac_output_w', '3': 34, '4': 1, '5': 1, '10': 'ratedAcOutputW'},
    {'1': 'ac_phase_count', '3': 35, '4': 1, '5': 5, '10': 'acPhaseCount'},
    {'1': 'ac_frequency_hz', '3': 36, '4': 1, '5': 1, '10': 'acFrequencyHz'},
    {'1': 'nominal_ac_voltage', '3': 37, '4': 1, '5': 1, '10': 'nominalAcVoltage'},
    {'1': 'night_consumption_w', '3': 38, '4': 1, '5': 1, '10': 'nightConsumptionW'},
    {'1': 'operating_temp_min_c', '3': 39, '4': 1, '5': 1, '10': 'operatingTempMinC'},
    {'1': 'operating_temp_max_c', '3': 40, '4': 1, '5': 1, '10': 'operatingTempMaxC'},
    {'1': 'topology', '3': 41, '4': 1, '5': 14, '6': '.asset.v1.InverterTopology', '10': 'topology'},
    {'1': 'grid_type', '3': 42, '4': 1, '5': 14, '6': '.asset.v1.InverterGridType', '10': 'gridType'},
  ],
};

/// Descriptor for `ElectricalParameters`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electricalParametersDescriptor = $convert.base64Decode(
    'ChRFbGVjdHJpY2FsUGFyYW1ldGVycxIiCg1yYXRlZF9wb3dlcl93GAEgASgBUgtyYXRlZFBvd2'
    'VyVxIQCgN2b2MYAiABKAFSA3ZvYxIQCgNpc2MYAyABKAFSA2lzYxIQCgN2bXAYBCABKAFSA3Zt'
    'cBIQCgNpbXAYBSABKAFSA2ltcBIeCgplZmZpY2llbmN5GAYgASgBUgplZmZpY2llbmN5EjIKFX'
    'RlbXBfY29lZmZpY2llbnRfcG1heBgHIAEoAVITdGVtcENvZWZmaWNpZW50UG1heBIwChR0ZW1w'
    'X2NvZWZmaWNpZW50X3ZvYxgIIAEoAVISdGVtcENvZWZmaWNpZW50Vm9jEiMKDm1heF9kY19pbn'
    'B1dF93GAkgASgBUgttYXhEY0lucHV0VxIlCg9tYXhfYWNfb3V0cHV0X3cYCiABKAFSDG1heEFj'
    'T3V0cHV0VxIdCgptcHB0X2NvdW50GAsgASgFUgltcHB0Q291bnQSKgoRbWF4X2lucHV0X3ZvbH'
    'RhZ2UYDCABKAFSD21heElucHV0Vm9sdGFnZRIqChFtaW5faW5wdXRfdm9sdGFnZRgNIAEoAVIP'
    'bWluSW5wdXRWb2x0YWdlEi8KFG1heF9zdHJpbmdzX3Blcl9tcHB0GA4gASgFUhFtYXhTdHJpbm'
    'dzUGVyTXBwdBIdCgprdmFfcmF0aW5nGA8gASgBUglrdmFSYXRpbmcSJwoPcHJpbWFyeV92b2x0'
    'YWdlGBAgASgBUg5wcmltYXJ5Vm9sdGFnZRIrChFzZWNvbmRhcnlfdm9sdGFnZRgRIAEoAVIQc2'
    'Vjb25kYXJ5Vm9sdGFnZRIwChR0ZW1wX2NvZWZmaWNpZW50X2lzYxgSIAEoAVISdGVtcENvZWZm'
    'aWNpZW50SXNjEhUKBm5vY3RfYxgTIAEoAVIFbm9jdEMSJwoPYmlmYWNpYWxfZmFjdG9yGBQgAS'
    'gBUg5iaWZhY2lhbEZhY3RvchIsChJtYXhfc3lzdGVtX3ZvbHRhZ2UYFSABKAFSEG1heFN5c3Rl'
    'bVZvbHRhZ2USLwoUc2VyaWVzX2Z1c2VfcmF0aW5nX2EYFiABKAFSEXNlcmllc0Z1c2VSYXRpbm'
    'dBEj0KG25vbWluYWxfcG93ZXJfdG9sZXJhbmNlX3BjdBgXIAEoAVIYbm9taW5hbFBvd2VyVG9s'
    'ZXJhbmNlUGN0EiYKD2NlbGxzX2luX3NlcmllcxgYIAEoBVINY2VsbHNJblNlcmllcxIqChFjZW'
    'xsc19pbl9wYXJhbGxlbBgZIAEoBVIPY2VsbHNJblBhcmFsbGVsEicKD2V1cm9fZWZmaWNpZW5j'
    'eRgaIAEoAVIOZXVyb0VmZmljaWVuY3kSJQoOY2VjX2VmZmljaWVuY3kYGyABKAFSDWNlY0VmZm'
    'ljaWVuY3kSJQoObWF4X2VmZmljaWVuY3kYHCABKAFSDW1heEVmZmljaWVuY3kSKAoQbXBwdF9t'
    'aW5fdm9sdGFnZRgdIAEoAVIObXBwdE1pblZvbHRhZ2USKAoQbXBwdF9tYXhfdm9sdGFnZRgeIA'
    'EoAVIObXBwdE1heFZvbHRhZ2USJwoPc3RhcnR1cF92b2x0YWdlGB8gASgBUg5zdGFydHVwVm9s'
    'dGFnZRIyChZtYXhfZGNfaW5wdXRfY3VycmVudF9hGCAgASgBUhJtYXhEY0lucHV0Q3VycmVudE'
    'ESLwoUbWF4X291dHB1dF9jdXJyZW50X2EYISABKAFSEW1heE91dHB1dEN1cnJlbnRBEikKEXJh'
    'dGVkX2FjX291dHB1dF93GCIgASgBUg5yYXRlZEFjT3V0cHV0VxIkCg5hY19waGFzZV9jb3VudB'
    'gjIAEoBVIMYWNQaGFzZUNvdW50EiYKD2FjX2ZyZXF1ZW5jeV9oehgkIAEoAVINYWNGcmVxdWVu'
    'Y3lIehIsChJub21pbmFsX2FjX3ZvbHRhZ2UYJSABKAFSEG5vbWluYWxBY1ZvbHRhZ2USLgoTbm'
    'lnaHRfY29uc3VtcHRpb25fdxgmIAEoAVIRbmlnaHRDb25zdW1wdGlvblcSLwoUb3BlcmF0aW5n'
    'X3RlbXBfbWluX2MYJyABKAFSEW9wZXJhdGluZ1RlbXBNaW5DEi8KFG9wZXJhdGluZ190ZW1wX2'
    '1heF9jGCggASgBUhFvcGVyYXRpbmdUZW1wTWF4QxI2Cgh0b3BvbG9neRgpIAEoDjIaLmFzc2V0'
    'LnYxLkludmVydGVyVG9wb2xvZ3lSCHRvcG9sb2d5EjcKCWdyaWRfdHlwZRgqIAEoDjIaLmFzc2'
    'V0LnYxLkludmVydGVyR3JpZFR5cGVSCGdyaWRUeXBl');

@$core.Deprecated('Use createAssetRequestDescriptor instead')
const CreateAssetRequest$json = {
  '1': 'CreateAssetRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'manufacturer', '3': 2, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'model', '3': 3, '4': 1, '5': 9, '10': 'model'},
    {'1': 'category', '3': 4, '4': 1, '5': 14, '6': '.asset.v1.AssetCategory', '10': 'category'},
    {'1': 'dimensions', '3': 5, '4': 1, '5': 11, '6': '.asset.v1.Dimensions', '10': 'dimensions'},
    {'1': 'electrical', '3': 6, '4': 1, '5': 11, '6': '.asset.v1.ElectricalParameters', '10': 'electrical'},
    {'1': 'model_3d_path', '3': 7, '4': 1, '5': 9, '10': 'model3dPath'},
    {'1': 'metadata_json', '3': 8, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `CreateAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAssetRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVBc3NldFJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIiCgxtYW51ZmFjdHVyZX'
    'IYAiABKAlSDG1hbnVmYWN0dXJlchIUCgVtb2RlbBgDIAEoCVIFbW9kZWwSMwoIY2F0ZWdvcnkY'
    'BCABKA4yFy5hc3NldC52MS5Bc3NldENhdGVnb3J5UghjYXRlZ29yeRI0CgpkaW1lbnNpb25zGA'
    'UgASgLMhQuYXNzZXQudjEuRGltZW5zaW9uc1IKZGltZW5zaW9ucxI+CgplbGVjdHJpY2FsGAYg'
    'ASgLMh4uYXNzZXQudjEuRWxlY3RyaWNhbFBhcmFtZXRlcnNSCmVsZWN0cmljYWwSIgoNbW9kZW'
    'xfM2RfcGF0aBgHIAEoCVILbW9kZWwzZFBhdGgSIwoNbWV0YWRhdGFfanNvbhgIIAEoCVIMbWV0'
    'YWRhdGFKc29u');

@$core.Deprecated('Use createAssetResponseDescriptor instead')
const CreateAssetResponse$json = {
  '1': 'CreateAssetResponse',
  '2': [
    {'1': 'asset', '3': 1, '4': 1, '5': 11, '6': '.asset.v1.Asset', '10': 'asset'},
  ],
};

/// Descriptor for `CreateAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAssetResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVBc3NldFJlc3BvbnNlEiUKBWFzc2V0GAEgASgLMg8uYXNzZXQudjEuQXNzZXRSBW'
    'Fzc2V0');

@$core.Deprecated('Use getAssetRequestDescriptor instead')
const GetAssetRequest$json = {
  '1': 'GetAssetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRBc3NldFJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use getAssetResponseDescriptor instead')
const GetAssetResponse$json = {
  '1': 'GetAssetResponse',
  '2': [
    {'1': 'asset', '3': 1, '4': 1, '5': 11, '6': '.asset.v1.Asset', '10': 'asset'},
  ],
};

/// Descriptor for `GetAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetResponseDescriptor = $convert.base64Decode(
    'ChBHZXRBc3NldFJlc3BvbnNlEiUKBWFzc2V0GAEgASgLMg8uYXNzZXQudjEuQXNzZXRSBWFzc2'
    'V0');

@$core.Deprecated('Use listAssetsRequestDescriptor instead')
const ListAssetsRequest$json = {
  '1': 'ListAssetsRequest',
  '2': [
    {'1': 'category_filter', '3': 1, '4': 1, '5': 14, '6': '.asset.v1.AssetCategory', '10': 'categoryFilter'},
    {'1': 'manufacturer_filter', '3': 2, '4': 1, '5': 9, '10': 'manufacturerFilter'},
    {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QXNzZXRzUmVxdWVzdBJACg9jYXRlZ29yeV9maWx0ZXIYASABKA4yFy5hc3NldC52MS'
    '5Bc3NldENhdGVnb3J5Ug5jYXRlZ29yeUZpbHRlchIvChNtYW51ZmFjdHVyZXJfZmlsdGVyGAIg'
    'ASgJUhJtYW51ZmFjdHVyZXJGaWx0ZXISTQoKcGFnaW5hdGlvbhgDIAEoCzItLnBhY2thZ2VzLm'
    'FwaS52MS5wYWdpbmF0aW9uLlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listAssetsResponseDescriptor instead')
const ListAssetsResponse$json = {
  '1': 'ListAssetsResponse',
  '2': [
    {'1': 'assets', '3': 1, '4': 3, '5': 11, '6': '.asset.v1.Asset', '10': 'assets'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QXNzZXRzUmVzcG9uc2USJwoGYXNzZXRzGAEgAygLMg8uYXNzZXQudjEuQXNzZXRSBm'
    'Fzc2V0cxJOCgpwYWdpbmF0aW9uGAIgASgLMi4ucGFja2FnZXMuYXBpLnYxLnBhZ2luYXRpb24u'
    'UGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use updateAssetRequestDescriptor instead')
const UpdateAssetRequest$json = {
  '1': 'UpdateAssetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'manufacturer', '3': 3, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'model', '3': 4, '4': 1, '5': 9, '10': 'model'},
    {'1': 'dimensions', '3': 5, '4': 1, '5': 11, '6': '.asset.v1.Dimensions', '10': 'dimensions'},
    {'1': 'electrical', '3': 6, '4': 1, '5': 11, '6': '.asset.v1.ElectricalParameters', '10': 'electrical'},
    {'1': 'model_3d_path', '3': 7, '4': 1, '5': 9, '10': 'model3dPath'},
    {'1': 'metadata_json', '3': 8, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `UpdateAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAssetRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVBc3NldFJlcXVlc3QSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbW'
    'USIgoMbWFudWZhY3R1cmVyGAMgASgJUgxtYW51ZmFjdHVyZXISFAoFbW9kZWwYBCABKAlSBW1v'
    'ZGVsEjQKCmRpbWVuc2lvbnMYBSABKAsyFC5hc3NldC52MS5EaW1lbnNpb25zUgpkaW1lbnNpb2'
    '5zEj4KCmVsZWN0cmljYWwYBiABKAsyHi5hc3NldC52MS5FbGVjdHJpY2FsUGFyYW1ldGVyc1IK'
    'ZWxlY3RyaWNhbBIiCg1tb2RlbF8zZF9wYXRoGAcgASgJUgttb2RlbDNkUGF0aBIjCg1tZXRhZG'
    'F0YV9qc29uGAggASgJUgxtZXRhZGF0YUpzb24=');

@$core.Deprecated('Use updateAssetResponseDescriptor instead')
const UpdateAssetResponse$json = {
  '1': 'UpdateAssetResponse',
  '2': [
    {'1': 'asset', '3': 1, '4': 1, '5': 11, '6': '.asset.v1.Asset', '10': 'asset'},
  ],
};

/// Descriptor for `UpdateAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAssetResponseDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVBc3NldFJlc3BvbnNlEiUKBWFzc2V0GAEgASgLMg8uYXNzZXQudjEuQXNzZXRSBW'
    'Fzc2V0');

@$core.Deprecated('Use deleteAssetRequestDescriptor instead')
const DeleteAssetRequest$json = {
  '1': 'DeleteAssetRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAssetRequestDescriptor = $convert.base64Decode(
    'ChJEZWxldGVBc3NldFJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use deleteAssetResponseDescriptor instead')
const DeleteAssetResponse$json = {
  '1': 'DeleteAssetResponse',
};

/// Descriptor for `DeleteAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAssetResponseDescriptor = $convert.base64Decode(
    'ChNEZWxldGVBc3NldFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> AssetServiceBase$json = {
  '1': 'AssetService',
  '2': [
    {'1': 'CreateAsset', '2': '.asset.v1.CreateAssetRequest', '3': '.asset.v1.CreateAssetResponse'},
    {'1': 'GetAsset', '2': '.asset.v1.GetAssetRequest', '3': '.asset.v1.GetAssetResponse'},
    {'1': 'ListAssets', '2': '.asset.v1.ListAssetsRequest', '3': '.asset.v1.ListAssetsResponse'},
    {'1': 'UpdateAsset', '2': '.asset.v1.UpdateAssetRequest', '3': '.asset.v1.UpdateAssetResponse'},
    {'1': 'DeleteAsset', '2': '.asset.v1.DeleteAssetRequest', '3': '.asset.v1.DeleteAssetResponse'},
  ],
};

@$core.Deprecated('Use assetServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> AssetServiceBase$messageJson = {
  '.asset.v1.CreateAssetRequest': CreateAssetRequest$json,
  '.asset.v1.Dimensions': Dimensions$json,
  '.asset.v1.ElectricalParameters': ElectricalParameters$json,
  '.asset.v1.CreateAssetResponse': CreateAssetResponse$json,
  '.asset.v1.Asset': Asset$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.asset.v1.GetAssetRequest': GetAssetRequest$json,
  '.asset.v1.GetAssetResponse': GetAssetResponse$json,
  '.asset.v1.ListAssetsRequest': ListAssetsRequest$json,
  '.packages.api.v1.pagination.PaginationRequest': $1.PaginationRequest$json,
  '.google.protobuf.FieldMask': $2.FieldMask$json,
  '.asset.v1.ListAssetsResponse': ListAssetsResponse$json,
  '.packages.api.v1.pagination.PaginationResponse': $1.PaginationResponse$json,
  '.asset.v1.UpdateAssetRequest': UpdateAssetRequest$json,
  '.asset.v1.UpdateAssetResponse': UpdateAssetResponse$json,
  '.asset.v1.DeleteAssetRequest': DeleteAssetRequest$json,
  '.asset.v1.DeleteAssetResponse': DeleteAssetResponse$json,
};

/// Descriptor for `AssetService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List assetServiceDescriptor = $convert.base64Decode(
    'CgxBc3NldFNlcnZpY2USSgoLQ3JlYXRlQXNzZXQSHC5hc3NldC52MS5DcmVhdGVBc3NldFJlcX'
    'Vlc3QaHS5hc3NldC52MS5DcmVhdGVBc3NldFJlc3BvbnNlEkEKCEdldEFzc2V0EhkuYXNzZXQu'
    'djEuR2V0QXNzZXRSZXF1ZXN0GhouYXNzZXQudjEuR2V0QXNzZXRSZXNwb25zZRJHCgpMaXN0QX'
    'NzZXRzEhsuYXNzZXQudjEuTGlzdEFzc2V0c1JlcXVlc3QaHC5hc3NldC52MS5MaXN0QXNzZXRz'
    'UmVzcG9uc2USSgoLVXBkYXRlQXNzZXQSHC5hc3NldC52MS5VcGRhdGVBc3NldFJlcXVlc3QaHS'
    '5hc3NldC52MS5VcGRhdGVBc3NldFJlc3BvbnNlEkoKC0RlbGV0ZUFzc2V0EhwuYXNzZXQudjEu'
    'RGVsZXRlQXNzZXRSZXF1ZXN0Gh0uYXNzZXQudjEuRGVsZXRlQXNzZXRSZXNwb25zZQ==');

