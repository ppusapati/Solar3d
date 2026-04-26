//
//  Generated code. Do not modify.
//  source: simulation/v1/simulation.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SimulationType extends $pb.ProtobufEnum {
  static const SimulationType SIMULATION_TYPE_UNSPECIFIED = SimulationType._(0, _omitEnumNames ? '' : 'SIMULATION_TYPE_UNSPECIFIED');
  static const SimulationType SIMULATION_TYPE_SHADOW = SimulationType._(1, _omitEnumNames ? '' : 'SIMULATION_TYPE_SHADOW');
  static const SimulationType SIMULATION_TYPE_IRRADIANCE = SimulationType._(2, _omitEnumNames ? '' : 'SIMULATION_TYPE_IRRADIANCE');
  static const SimulationType SIMULATION_TYPE_ANNUAL_YIELD = SimulationType._(3, _omitEnumNames ? '' : 'SIMULATION_TYPE_ANNUAL_YIELD');

  static const $core.List<SimulationType> values = <SimulationType> [
    SIMULATION_TYPE_UNSPECIFIED,
    SIMULATION_TYPE_SHADOW,
    SIMULATION_TYPE_IRRADIANCE,
    SIMULATION_TYPE_ANNUAL_YIELD,
  ];

  static final $core.Map<$core.int, SimulationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SimulationType? valueOf($core.int value) => _byValue[value];

  const SimulationType._(super.v, super.n);
}

class SimulationStatus extends $pb.ProtobufEnum {
  static const SimulationStatus SIMULATION_STATUS_UNSPECIFIED = SimulationStatus._(0, _omitEnumNames ? '' : 'SIMULATION_STATUS_UNSPECIFIED');
  static const SimulationStatus SIMULATION_STATUS_PENDING = SimulationStatus._(1, _omitEnumNames ? '' : 'SIMULATION_STATUS_PENDING');
  static const SimulationStatus SIMULATION_STATUS_RUNNING = SimulationStatus._(2, _omitEnumNames ? '' : 'SIMULATION_STATUS_RUNNING');
  static const SimulationStatus SIMULATION_STATUS_COMPLETED = SimulationStatus._(3, _omitEnumNames ? '' : 'SIMULATION_STATUS_COMPLETED');
  static const SimulationStatus SIMULATION_STATUS_FAILED = SimulationStatus._(4, _omitEnumNames ? '' : 'SIMULATION_STATUS_FAILED');

  static const $core.List<SimulationStatus> values = <SimulationStatus> [
    SIMULATION_STATUS_UNSPECIFIED,
    SIMULATION_STATUS_PENDING,
    SIMULATION_STATUS_RUNNING,
    SIMULATION_STATUS_COMPLETED,
    SIMULATION_STATUS_FAILED,
  ];

  static final $core.Map<$core.int, SimulationStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SimulationStatus? valueOf($core.int value) => _byValue[value];

  const SimulationStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
