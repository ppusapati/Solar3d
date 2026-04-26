//
//  Generated code. Do not modify.
//  source: ml_inference/v1/features.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class FeatureDataType extends $pb.ProtobufEnum {
  static const FeatureDataType FEATURE_DATA_TYPE_UNSPECIFIED = FeatureDataType._(0, _omitEnumNames ? '' : 'FEATURE_DATA_TYPE_UNSPECIFIED');
  static const FeatureDataType FEATURE_DATA_TYPE_FLOAT64 = FeatureDataType._(1, _omitEnumNames ? '' : 'FEATURE_DATA_TYPE_FLOAT64');
  static const FeatureDataType FEATURE_DATA_TYPE_INT64 = FeatureDataType._(2, _omitEnumNames ? '' : 'FEATURE_DATA_TYPE_INT64');
  static const FeatureDataType FEATURE_DATA_TYPE_BOOL = FeatureDataType._(3, _omitEnumNames ? '' : 'FEATURE_DATA_TYPE_BOOL');
  static const FeatureDataType FEATURE_DATA_TYPE_STRING = FeatureDataType._(4, _omitEnumNames ? '' : 'FEATURE_DATA_TYPE_STRING');

  static const $core.List<FeatureDataType> values = <FeatureDataType> [
    FEATURE_DATA_TYPE_UNSPECIFIED,
    FEATURE_DATA_TYPE_FLOAT64,
    FEATURE_DATA_TYPE_INT64,
    FEATURE_DATA_TYPE_BOOL,
    FEATURE_DATA_TYPE_STRING,
  ];

  static final $core.Map<$core.int, FeatureDataType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FeatureDataType? valueOf($core.int value) => _byValue[value];

  const FeatureDataType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
