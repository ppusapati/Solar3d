//
//  Generated code. Do not modify.
//  source: kml/v1/kml_ingestion.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Canonical coordinate reference system codes.
class CRSCode extends $pb.ProtobufEnum {
  static const CRSCode CRS_UNKNOWN = CRSCode._(0, _omitEnumNames ? '' : 'CRS_UNKNOWN');
  static const CRSCode CRS_WGS84 = CRSCode._(4326, _omitEnumNames ? '' : 'CRS_WGS84');
  static const CRSCode CRS_WEB_MERCATOR = CRSCode._(3857, _omitEnumNames ? '' : 'CRS_WEB_MERCATOR');
  static const CRSCode CRS_UTM = CRSCode._(32633, _omitEnumNames ? '' : 'CRS_UTM');

  static const $core.List<CRSCode> values = <CRSCode> [
    CRS_UNKNOWN,
    CRS_WGS84,
    CRS_WEB_MERCATOR,
    CRS_UTM,
  ];

  static final $core.Map<$core.int, CRSCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CRSCode? valueOf($core.int value) => _byValue[value];

  const CRSCode._(super.v, super.n);
}

/// Status of KML upload job.
class UploadStatus extends $pb.ProtobufEnum {
  static const UploadStatus STATUS_UNKNOWN = UploadStatus._(0, _omitEnumNames ? '' : 'STATUS_UNKNOWN');
  static const UploadStatus STATUS_PENDING = UploadStatus._(1, _omitEnumNames ? '' : 'STATUS_PENDING');
  static const UploadStatus STATUS_PROCESSING = UploadStatus._(2, _omitEnumNames ? '' : 'STATUS_PROCESSING');
  static const UploadStatus STATUS_COMPLETED = UploadStatus._(3, _omitEnumNames ? '' : 'STATUS_COMPLETED');
  static const UploadStatus STATUS_FAILED = UploadStatus._(4, _omitEnumNames ? '' : 'STATUS_FAILED');

  static const $core.List<UploadStatus> values = <UploadStatus> [
    STATUS_UNKNOWN,
    STATUS_PENDING,
    STATUS_PROCESSING,
    STATUS_COMPLETED,
    STATUS_FAILED,
  ];

  static final $core.Map<$core.int, UploadStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UploadStatus? valueOf($core.int value) => _byValue[value];

  const UploadStatus._(super.v, super.n);
}

/// Canonical geometry type.
class GeometryType extends $pb.ProtobufEnum {
  static const GeometryType TYPE_UNKNOWN = GeometryType._(0, _omitEnumNames ? '' : 'TYPE_UNKNOWN');
  static const GeometryType TYPE_POINT = GeometryType._(1, _omitEnumNames ? '' : 'TYPE_POINT');
  static const GeometryType TYPE_LINESTRING = GeometryType._(2, _omitEnumNames ? '' : 'TYPE_LINESTRING');
  static const GeometryType TYPE_POLYGON = GeometryType._(3, _omitEnumNames ? '' : 'TYPE_POLYGON');
  static const GeometryType TYPE_MULTIPOLYGON = GeometryType._(4, _omitEnumNames ? '' : 'TYPE_MULTIPOLYGON');

  static const $core.List<GeometryType> values = <GeometryType> [
    TYPE_UNKNOWN,
    TYPE_POINT,
    TYPE_LINESTRING,
    TYPE_POLYGON,
    TYPE_MULTIPOLYGON,
  ];

  static final $core.Map<$core.int, GeometryType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GeometryType? valueOf($core.int value) => _byValue[value];

  const GeometryType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
