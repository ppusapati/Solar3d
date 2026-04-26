//
//  Generated code. Do not modify.
//  source: ml_inference/v1/ml_inference.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AnomalyType extends $pb.ProtobufEnum {
  static const AnomalyType NORMAL = AnomalyType._(0, _omitEnumNames ? '' : 'NORMAL');
  static const AnomalyType SENSOR_FAULT = AnomalyType._(1, _omitEnumNames ? '' : 'SENSOR_FAULT');
  static const AnomalyType PERFORMANCE_DEGRADATION = AnomalyType._(2, _omitEnumNames ? '' : 'PERFORMANCE_DEGRADATION');
  static const AnomalyType INVERTER_ISSUE = AnomalyType._(3, _omitEnumNames ? '' : 'INVERTER_ISSUE');
  static const AnomalyType STRING_MALFUNCTION = AnomalyType._(4, _omitEnumNames ? '' : 'STRING_MALFUNCTION');
  static const AnomalyType WEATHER_EVENT = AnomalyType._(5, _omitEnumNames ? '' : 'WEATHER_EVENT');

  static const $core.List<AnomalyType> values = <AnomalyType> [
    NORMAL,
    SENSOR_FAULT,
    PERFORMANCE_DEGRADATION,
    INVERTER_ISSUE,
    STRING_MALFUNCTION,
    WEATHER_EVENT,
  ];

  static final $core.Map<$core.int, AnomalyType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AnomalyType? valueOf($core.int value) => _byValue[value];

  const AnomalyType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
