//
//  Generated code. Do not modify.
//  source: fault/v1/fault_schema.proto
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

import 'fault_schema.pb.dart' as $1;
import 'fault_schema.pbjson.dart';

export 'fault_schema.pb.dart';

abstract class FaultServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ReportFaultResponse> reportFault($pb.ServerContext ctx, $1.ReportFaultRequest request);
  $async.Future<$1.GetFaultResponse> getFault($pb.ServerContext ctx, $1.GetFaultRequest request);
  $async.Future<$1.ListFaultsResponse> listFaults($pb.ServerContext ctx, $1.ListFaultsRequest request);
  $async.Future<$1.AcknowledgeFaultResponse> acknowledgeFault($pb.ServerContext ctx, $1.AcknowledgeFaultRequest request);
  $async.Future<$1.ResolveFaultResponse> resolveFault($pb.ServerContext ctx, $1.ResolveFaultRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ReportFault': return $1.ReportFaultRequest();
      case 'GetFault': return $1.GetFaultRequest();
      case 'ListFaults': return $1.ListFaultsRequest();
      case 'AcknowledgeFault': return $1.AcknowledgeFaultRequest();
      case 'ResolveFault': return $1.ResolveFaultRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ReportFault': return this.reportFault(ctx, request as $1.ReportFaultRequest);
      case 'GetFault': return this.getFault(ctx, request as $1.GetFaultRequest);
      case 'ListFaults': return this.listFaults(ctx, request as $1.ListFaultsRequest);
      case 'AcknowledgeFault': return this.acknowledgeFault(ctx, request as $1.AcknowledgeFaultRequest);
      case 'ResolveFault': return this.resolveFault(ctx, request as $1.ResolveFaultRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FaultServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => FaultServiceBase$messageJson;
}

