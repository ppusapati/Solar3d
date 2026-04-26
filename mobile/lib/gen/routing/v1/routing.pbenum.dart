//
//  Generated code. Do not modify.
//  source: routing/v1/routing.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RouteType extends $pb.ProtobufEnum {
  static const RouteType ROUTE_TYPE_UNSPECIFIED = RouteType._(0, _omitEnumNames ? '' : 'ROUTE_TYPE_UNSPECIFIED');
  static const RouteType ROUTE_TYPE_DC_CABLE = RouteType._(1, _omitEnumNames ? '' : 'ROUTE_TYPE_DC_CABLE');
  static const RouteType ROUTE_TYPE_AC_CABLE = RouteType._(2, _omitEnumNames ? '' : 'ROUTE_TYPE_AC_CABLE');
  static const RouteType ROUTE_TYPE_COMMUNICATION = RouteType._(3, _omitEnumNames ? '' : 'ROUTE_TYPE_COMMUNICATION');
  static const RouteType ROUTE_TYPE_ACCESS_ROAD = RouteType._(4, _omitEnumNames ? '' : 'ROUTE_TYPE_ACCESS_ROAD');
  static const RouteType ROUTE_TYPE_SERVICE_ROAD = RouteType._(5, _omitEnumNames ? '' : 'ROUTE_TYPE_SERVICE_ROAD');
  static const RouteType ROUTE_TYPE_FENCE = RouteType._(6, _omitEnumNames ? '' : 'ROUTE_TYPE_FENCE');

  static const $core.List<RouteType> values = <RouteType> [
    ROUTE_TYPE_UNSPECIFIED,
    ROUTE_TYPE_DC_CABLE,
    ROUTE_TYPE_AC_CABLE,
    ROUTE_TYPE_COMMUNICATION,
    ROUTE_TYPE_ACCESS_ROAD,
    ROUTE_TYPE_SERVICE_ROAD,
    ROUTE_TYPE_FENCE,
  ];

  static final $core.Map<$core.int, RouteType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RouteType? valueOf($core.int value) => _byValue[value];

  const RouteType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
