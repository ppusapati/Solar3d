//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Objective_ObjectiveKind extends $pb.ProtobufEnum {
  static const Objective_ObjectiveKind MINIMIZE = Objective_ObjectiveKind._(0, _omitEnumNames ? '' : 'MINIMIZE');
  static const Objective_ObjectiveKind MAXIMIZE = Objective_ObjectiveKind._(1, _omitEnumNames ? '' : 'MAXIMIZE');

  static const $core.List<Objective_ObjectiveKind> values = <Objective_ObjectiveKind> [
    MINIMIZE,
    MAXIMIZE,
  ];

  static final $core.Map<$core.int, Objective_ObjectiveKind> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Objective_ObjectiveKind? valueOf($core.int value) => _byValue[value];

  const Objective_ObjectiveKind._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
