//
//  Generated code. Do not modify.
//  source: transmission/v1/transmission.proto
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

import 'transmission.pb.dart' as $3;
import 'transmission.pbjson.dart';

export 'transmission.pb.dart';

abstract class TransmissionRoutingServiceBase extends $pb.GeneratedService {
  $async.Future<$3.CalculateTransmissionRouteResponse> calculateTransmissionRoute($pb.ServerContext ctx, $3.CalculateTransmissionRouteRequest request);
  $async.Future<$3.StreamTransmissionRouteResponse> streamTransmissionRoute($pb.ServerContext ctx, $3.StreamTransmissionRouteRequest request);
  $async.Future<$3.GetTransmissionRouteResponse> getTransmissionRoute($pb.ServerContext ctx, $3.GetTransmissionRouteRequest request);
  $async.Future<$3.ListTransmissionRoutesResponse> listTransmissionRoutes($pb.ServerContext ctx, $3.ListTransmissionRoutesRequest request);
  $async.Future<$3.SubmitTransmissionRouteForReviewResponse> submitTransmissionRouteForReview($pb.ServerContext ctx, $3.SubmitTransmissionRouteForReviewRequest request);
  $async.Future<$3.ApproveTransmissionRouteResponse> approveTransmissionRoute($pb.ServerContext ctx, $3.ApproveTransmissionRouteRequest request);
  $async.Future<$3.ExportTransmissionRoutePackResponse> exportTransmissionRoutePack($pb.ServerContext ctx, $3.ExportTransmissionRoutePackRequest request);
  $async.Future<$3.DeleteTransmissionRouteResponse> deleteTransmissionRoute($pb.ServerContext ctx, $3.DeleteTransmissionRouteRequest request);
  $async.Future<$3.RejectTransmissionRouteResponse> rejectTransmissionRoute($pb.ServerContext ctx, $3.RejectTransmissionRouteRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CalculateTransmissionRoute': return $3.CalculateTransmissionRouteRequest();
      case 'StreamTransmissionRoute': return $3.StreamTransmissionRouteRequest();
      case 'GetTransmissionRoute': return $3.GetTransmissionRouteRequest();
      case 'ListTransmissionRoutes': return $3.ListTransmissionRoutesRequest();
      case 'SubmitTransmissionRouteForReview': return $3.SubmitTransmissionRouteForReviewRequest();
      case 'ApproveTransmissionRoute': return $3.ApproveTransmissionRouteRequest();
      case 'ExportTransmissionRoutePack': return $3.ExportTransmissionRoutePackRequest();
      case 'DeleteTransmissionRoute': return $3.DeleteTransmissionRouteRequest();
      case 'RejectTransmissionRoute': return $3.RejectTransmissionRouteRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CalculateTransmissionRoute': return this.calculateTransmissionRoute(ctx, request as $3.CalculateTransmissionRouteRequest);
      case 'StreamTransmissionRoute': return this.streamTransmissionRoute(ctx, request as $3.StreamTransmissionRouteRequest);
      case 'GetTransmissionRoute': return this.getTransmissionRoute(ctx, request as $3.GetTransmissionRouteRequest);
      case 'ListTransmissionRoutes': return this.listTransmissionRoutes(ctx, request as $3.ListTransmissionRoutesRequest);
      case 'SubmitTransmissionRouteForReview': return this.submitTransmissionRouteForReview(ctx, request as $3.SubmitTransmissionRouteForReviewRequest);
      case 'ApproveTransmissionRoute': return this.approveTransmissionRoute(ctx, request as $3.ApproveTransmissionRouteRequest);
      case 'ExportTransmissionRoutePack': return this.exportTransmissionRoutePack(ctx, request as $3.ExportTransmissionRoutePackRequest);
      case 'DeleteTransmissionRoute': return this.deleteTransmissionRoute(ctx, request as $3.DeleteTransmissionRouteRequest);
      case 'RejectTransmissionRoute': return this.rejectTransmissionRoute(ctx, request as $3.RejectTransmissionRouteRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TransmissionRoutingServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => TransmissionRoutingServiceBase$messageJson;
}

