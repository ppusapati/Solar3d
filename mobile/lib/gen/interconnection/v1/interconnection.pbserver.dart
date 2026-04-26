//
//  Generated code. Do not modify.
//  source: interconnection/v1/interconnection.proto
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

import 'interconnection.pb.dart' as $1;
import 'interconnection.pbjson.dart';

export 'interconnection.pb.dart';

abstract class InterconnectionServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreatePOIResponse> createPOI($pb.ServerContext ctx, $1.CreatePOIRequest request);
  $async.Future<$1.GetPOIResponse> getPOI($pb.ServerContext ctx, $1.GetPOIRequest request);
  $async.Future<$1.ListPOIsResponse> listPOIs($pb.ServerContext ctx, $1.ListPOIsRequest request);
  $async.Future<$1.SizeTransformerResponse> sizeTransformer($pb.ServerContext ctx, $1.SizeTransformerRequest request);
  $async.Future<$1.ReactivePowerStudyResponse> reactivePowerStudy($pb.ServerContext ctx, $1.ReactivePowerStudyRequest request);
  $async.Future<$1.GenerateApplicationFormResponse> generateApplicationForm($pb.ServerContext ctx, $1.GenerateApplicationFormRequest request);
  $async.Future<$1.DeletePOIResponse> deletePOI($pb.ServerContext ctx, $1.DeletePOIRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreatePOI': return $1.CreatePOIRequest();
      case 'GetPOI': return $1.GetPOIRequest();
      case 'ListPOIs': return $1.ListPOIsRequest();
      case 'SizeTransformer': return $1.SizeTransformerRequest();
      case 'ReactivePowerStudy': return $1.ReactivePowerStudyRequest();
      case 'GenerateApplicationForm': return $1.GenerateApplicationFormRequest();
      case 'DeletePOI': return $1.DeletePOIRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreatePOI': return this.createPOI(ctx, request as $1.CreatePOIRequest);
      case 'GetPOI': return this.getPOI(ctx, request as $1.GetPOIRequest);
      case 'ListPOIs': return this.listPOIs(ctx, request as $1.ListPOIsRequest);
      case 'SizeTransformer': return this.sizeTransformer(ctx, request as $1.SizeTransformerRequest);
      case 'ReactivePowerStudy': return this.reactivePowerStudy(ctx, request as $1.ReactivePowerStudyRequest);
      case 'GenerateApplicationForm': return this.generateApplicationForm(ctx, request as $1.GenerateApplicationFormRequest);
      case 'DeletePOI': return this.deletePOI(ctx, request as $1.DeletePOIRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => InterconnectionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => InterconnectionServiceBase$messageJson;
}

