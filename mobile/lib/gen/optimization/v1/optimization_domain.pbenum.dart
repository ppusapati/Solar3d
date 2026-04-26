//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization_domain.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class VariableType extends $pb.ProtobufEnum {
  static const VariableType VARIABLE_TYPE_UNSPECIFIED = VariableType._(0, _omitEnumNames ? '' : 'VARIABLE_TYPE_UNSPECIFIED');
  static const VariableType VARIABLE_TYPE_CONTINUOUS = VariableType._(1, _omitEnumNames ? '' : 'VARIABLE_TYPE_CONTINUOUS');
  static const VariableType VARIABLE_TYPE_INTEGER = VariableType._(2, _omitEnumNames ? '' : 'VARIABLE_TYPE_INTEGER');
  static const VariableType VARIABLE_TYPE_BINARY = VariableType._(3, _omitEnumNames ? '' : 'VARIABLE_TYPE_BINARY');

  static const $core.List<VariableType> values = <VariableType> [
    VARIABLE_TYPE_UNSPECIFIED,
    VARIABLE_TYPE_CONTINUOUS,
    VARIABLE_TYPE_INTEGER,
    VARIABLE_TYPE_BINARY,
  ];

  static final $core.Map<$core.int, VariableType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VariableType? valueOf($core.int value) => _byValue[value];

  const VariableType._(super.v, super.n);
}

class ObjectiveKind extends $pb.ProtobufEnum {
  static const ObjectiveKind OBJECTIVE_KIND_UNSPECIFIED = ObjectiveKind._(0, _omitEnumNames ? '' : 'OBJECTIVE_KIND_UNSPECIFIED');
  static const ObjectiveKind OBJECTIVE_KIND_MINIMIZE = ObjectiveKind._(1, _omitEnumNames ? '' : 'OBJECTIVE_KIND_MINIMIZE');
  static const ObjectiveKind OBJECTIVE_KIND_MAXIMIZE = ObjectiveKind._(2, _omitEnumNames ? '' : 'OBJECTIVE_KIND_MAXIMIZE');

  static const $core.List<ObjectiveKind> values = <ObjectiveKind> [
    OBJECTIVE_KIND_UNSPECIFIED,
    OBJECTIVE_KIND_MINIMIZE,
    OBJECTIVE_KIND_MAXIMIZE,
  ];

  static final $core.Map<$core.int, ObjectiveKind> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ObjectiveKind? valueOf($core.int value) => _byValue[value];

  const ObjectiveKind._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
