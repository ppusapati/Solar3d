//
//  Generated code. Do not modify.
//  source: kml/v1/kml_ingestion.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'kml_ingestion.pb.dart' as $2;
import 'kml_ingestion.pbjson.dart';

export 'kml_ingestion.pb.dart';

abstract class KMLIngestionServiceBase extends $pb.GeneratedService {
  $async.Future<$2.UploadKMLResponse> uploadKML($pb.ServerContext ctx, $2.UploadKMLRequest request);
  $async.Future<$2.GetUploadStatusResponse> getUploadStatus($pb.ServerContext ctx, $2.GetUploadStatusRequest request);
  $async.Future<$2.ListImportedGeometriesResponse> listImportedGeometries($pb.ServerContext ctx, $2.ListImportedGeometriesRequest request);
  $async.Future<$2.GetImportedGeometryResponse> getImportedGeometry($pb.ServerContext ctx, $2.GetImportedGeometryRequest request);
  $async.Future<$2.DeleteUploadResponse> deleteUpload($pb.ServerContext ctx, $2.DeleteUploadRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'UploadKML': return $2.UploadKMLRequest();
      case 'GetUploadStatus': return $2.GetUploadStatusRequest();
      case 'ListImportedGeometries': return $2.ListImportedGeometriesRequest();
      case 'GetImportedGeometry': return $2.GetImportedGeometryRequest();
      case 'DeleteUpload': return $2.DeleteUploadRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'UploadKML': return this.uploadKML(ctx, request as $2.UploadKMLRequest);
      case 'GetUploadStatus': return this.getUploadStatus(ctx, request as $2.GetUploadStatusRequest);
      case 'ListImportedGeometries': return this.listImportedGeometries(ctx, request as $2.ListImportedGeometriesRequest);
      case 'GetImportedGeometry': return this.getImportedGeometry(ctx, request as $2.GetImportedGeometryRequest);
      case 'DeleteUpload': return this.deleteUpload(ctx, request as $2.DeleteUploadRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => KMLIngestionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => KMLIngestionServiceBase$messageJson;
}

