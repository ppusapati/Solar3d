//
//  Generated code. Do not modify.
//  source: fault/v1/fault_schema.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// FaultType classifies the physical or logical nature of the fault condition.
/// Electrical types align with IEC 60909 symmetrical component analysis categories.
class FaultType extends $pb.ProtobufEnum {
  static const FaultType FAULT_TYPE_UNSPECIFIED = FaultType._(0, _omitEnumNames ? '' : 'FAULT_TYPE_UNSPECIFIED');
  /// FAULT_TYPE_OVERCURRENT: Current exceeds protective relay pickup threshold.
  static const FaultType FAULT_TYPE_OVERCURRENT = FaultType._(1, _omitEnumNames ? '' : 'FAULT_TYPE_OVERCURRENT');
  /// FAULT_TYPE_EARTH_FAULT: Ground fault detected (phase-to-earth, IEC 60909 SLG).
  static const FaultType FAULT_TYPE_EARTH_FAULT = FaultType._(2, _omitEnumNames ? '' : 'FAULT_TYPE_EARTH_FAULT');
  /// FAULT_TYPE_UNDERVOLTAGE: Bus voltage below minimum operating threshold.
  static const FaultType FAULT_TYPE_UNDERVOLTAGE = FaultType._(3, _omitEnumNames ? '' : 'FAULT_TYPE_UNDERVOLTAGE');
  /// FAULT_TYPE_OVERVOLTAGE: Bus voltage above maximum operating threshold.
  static const FaultType FAULT_TYPE_OVERVOLTAGE = FaultType._(4, _omitEnumNames ? '' : 'FAULT_TYPE_OVERVOLTAGE');
  /// FAULT_TYPE_INVERTER_TRIP: Inverter protection tripped (MPPT, DC isolation failure, etc.).
  static const FaultType FAULT_TYPE_INVERTER_TRIP = FaultType._(5, _omitEnumNames ? '' : 'FAULT_TYPE_INVERTER_TRIP');
  /// FAULT_TYPE_COMMUNICATION_LOSS: SCADA or Modbus communication to asset lost.
  static const FaultType FAULT_TYPE_COMMUNICATION_LOSS = FaultType._(6, _omitEnumNames ? '' : 'FAULT_TYPE_COMMUNICATION_LOSS');
  /// FAULT_TYPE_THERMAL: Temperature sensor exceeded design operating limits.
  static const FaultType FAULT_TYPE_THERMAL = FaultType._(7, _omitEnumNames ? '' : 'FAULT_TYPE_THERMAL');
  /// FAULT_TYPE_MECHANICAL: Mechanical damage, tracker failure, or structural anomaly.
  static const FaultType FAULT_TYPE_MECHANICAL = FaultType._(8, _omitEnumNames ? '' : 'FAULT_TYPE_MECHANICAL');
  /// FAULT_TYPE_PROTECTION_TRIP: Protection relay operated; circuit isolated.
  static const FaultType FAULT_TYPE_PROTECTION_TRIP = FaultType._(9, _omitEnumNames ? '' : 'FAULT_TYPE_PROTECTION_TRIP');

  static const $core.List<FaultType> values = <FaultType> [
    FAULT_TYPE_UNSPECIFIED,
    FAULT_TYPE_OVERCURRENT,
    FAULT_TYPE_EARTH_FAULT,
    FAULT_TYPE_UNDERVOLTAGE,
    FAULT_TYPE_OVERVOLTAGE,
    FAULT_TYPE_INVERTER_TRIP,
    FAULT_TYPE_COMMUNICATION_LOSS,
    FAULT_TYPE_THERMAL,
    FAULT_TYPE_MECHANICAL,
    FAULT_TYPE_PROTECTION_TRIP,
  ];

  static final $core.Map<$core.int, FaultType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FaultType? valueOf($core.int value) => _byValue[value];

  const FaultType._(super.v, super.n);
}

/// FaultSeverity represents the operational impact classification of the fault.
class FaultSeverity extends $pb.ProtobufEnum {
  static const FaultSeverity FAULT_SEVERITY_UNSPECIFIED = FaultSeverity._(0, _omitEnumNames ? '' : 'FAULT_SEVERITY_UNSPECIFIED');
  /// FAULT_SEVERITY_INFO: Informational/monitoring event; no immediate action required.
  static const FaultSeverity FAULT_SEVERITY_INFO = FaultSeverity._(1, _omitEnumNames ? '' : 'FAULT_SEVERITY_INFO');
  /// FAULT_SEVERITY_WARNING: Degraded performance; monitor and schedule maintenance.
  static const FaultSeverity FAULT_SEVERITY_WARNING = FaultSeverity._(2, _omitEnumNames ? '' : 'FAULT_SEVERITY_WARNING');
  /// FAULT_SEVERITY_CRITICAL: Significant revenue or equipment loss; respond within 4 hours.
  static const FaultSeverity FAULT_SEVERITY_CRITICAL = FaultSeverity._(3, _omitEnumNames ? '' : 'FAULT_SEVERITY_CRITICAL');
  /// FAULT_SEVERITY_EMERGENCY: Plant safety risk or grid code violation; immediate response required.
  static const FaultSeverity FAULT_SEVERITY_EMERGENCY = FaultSeverity._(4, _omitEnumNames ? '' : 'FAULT_SEVERITY_EMERGENCY');

  static const $core.List<FaultSeverity> values = <FaultSeverity> [
    FAULT_SEVERITY_UNSPECIFIED,
    FAULT_SEVERITY_INFO,
    FAULT_SEVERITY_WARNING,
    FAULT_SEVERITY_CRITICAL,
    FAULT_SEVERITY_EMERGENCY,
  ];

  static final $core.Map<$core.int, FaultSeverity> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FaultSeverity? valueOf($core.int value) => _byValue[value];

  const FaultSeverity._(super.v, super.n);
}

/// FaultStatus tracks the lifecycle of a fault event from detection to resolution.
class FaultStatus extends $pb.ProtobufEnum {
  static const FaultStatus FAULT_STATUS_UNSPECIFIED = FaultStatus._(0, _omitEnumNames ? '' : 'FAULT_STATUS_UNSPECIFIED');
  /// FAULT_STATUS_ACTIVE: Fault detected; no operator action taken yet.
  static const FaultStatus FAULT_STATUS_ACTIVE = FaultStatus._(1, _omitEnumNames ? '' : 'FAULT_STATUS_ACTIVE');
  /// FAULT_STATUS_ACKNOWLEDGED: Operator has seen the fault; remediation in progress.
  static const FaultStatus FAULT_STATUS_ACKNOWLEDGED = FaultStatus._(2, _omitEnumNames ? '' : 'FAULT_STATUS_ACKNOWLEDGED');
  /// FAULT_STATUS_RESOLVED: Fault cleared; equipment returned to normal operation.
  static const FaultStatus FAULT_STATUS_RESOLVED = FaultStatus._(3, _omitEnumNames ? '' : 'FAULT_STATUS_RESOLVED');

  static const $core.List<FaultStatus> values = <FaultStatus> [
    FAULT_STATUS_UNSPECIFIED,
    FAULT_STATUS_ACTIVE,
    FAULT_STATUS_ACKNOWLEDGED,
    FAULT_STATUS_RESOLVED,
  ];

  static final $core.Map<$core.int, FaultStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FaultStatus? valueOf($core.int value) => _byValue[value];

  const FaultStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
