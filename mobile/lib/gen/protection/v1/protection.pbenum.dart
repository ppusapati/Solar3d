//
//  Generated code. Do not modify.
//  source: protection/v1/protection.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class NeutralEarthing extends $pb.ProtobufEnum {
  static const NeutralEarthing NEUTRAL_EARTHING_UNSPECIFIED = NeutralEarthing._(0, _omitEnumNames ? '' : 'NEUTRAL_EARTHING_UNSPECIFIED');
  static const NeutralEarthing NEUTRAL_EARTHING_SOLID = NeutralEarthing._(1, _omitEnumNames ? '' : 'NEUTRAL_EARTHING_SOLID');
  static const NeutralEarthing NEUTRAL_EARTHING_RESISTANCE = NeutralEarthing._(2, _omitEnumNames ? '' : 'NEUTRAL_EARTHING_RESISTANCE');
  static const NeutralEarthing NEUTRAL_EARTHING_PETERSEN_COIL = NeutralEarthing._(3, _omitEnumNames ? '' : 'NEUTRAL_EARTHING_PETERSEN_COIL');
  static const NeutralEarthing NEUTRAL_EARTHING_ISOLATED = NeutralEarthing._(4, _omitEnumNames ? '' : 'NEUTRAL_EARTHING_ISOLATED');

  static const $core.List<NeutralEarthing> values = <NeutralEarthing> [
    NEUTRAL_EARTHING_UNSPECIFIED,
    NEUTRAL_EARTHING_SOLID,
    NEUTRAL_EARTHING_RESISTANCE,
    NEUTRAL_EARTHING_PETERSEN_COIL,
    NEUTRAL_EARTHING_ISOLATED,
  ];

  static final $core.Map<$core.int, NeutralEarthing> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NeutralEarthing? valueOf($core.int value) => _byValue[value];

  const NeutralEarthing._(super.v, super.n);
}

class RelayCharacteristic extends $pb.ProtobufEnum {
  static const RelayCharacteristic RELAY_CHARACTERISTIC_UNSPECIFIED = RelayCharacteristic._(0, _omitEnumNames ? '' : 'RELAY_CHARACTERISTIC_UNSPECIFIED');
  static const RelayCharacteristic RELAY_CHARACTERISTIC_STANDARD_INVERSE = RelayCharacteristic._(1, _omitEnumNames ? '' : 'RELAY_CHARACTERISTIC_STANDARD_INVERSE');
  static const RelayCharacteristic RELAY_CHARACTERISTIC_VERY_INVERSE = RelayCharacteristic._(2, _omitEnumNames ? '' : 'RELAY_CHARACTERISTIC_VERY_INVERSE');
  static const RelayCharacteristic RELAY_CHARACTERISTIC_EXTREMELY_INVERSE = RelayCharacteristic._(3, _omitEnumNames ? '' : 'RELAY_CHARACTERISTIC_EXTREMELY_INVERSE');
  static const RelayCharacteristic RELAY_CHARACTERISTIC_DEFINITE_TIME = RelayCharacteristic._(4, _omitEnumNames ? '' : 'RELAY_CHARACTERISTIC_DEFINITE_TIME');

  static const $core.List<RelayCharacteristic> values = <RelayCharacteristic> [
    RELAY_CHARACTERISTIC_UNSPECIFIED,
    RELAY_CHARACTERISTIC_STANDARD_INVERSE,
    RELAY_CHARACTERISTIC_VERY_INVERSE,
    RELAY_CHARACTERISTIC_EXTREMELY_INVERSE,
    RELAY_CHARACTERISTIC_DEFINITE_TIME,
  ];

  static final $core.Map<$core.int, RelayCharacteristic> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RelayCharacteristic? valueOf($core.int value) => _byValue[value];

  const RelayCharacteristic._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
