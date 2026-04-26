//
//  Generated code. Do not modify.
//  source: twin/v1/digital_twin.proto
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

import 'digital_twin.pb.dart' as $1;
import 'digital_twin.pbjson.dart';

export 'digital_twin.pb.dart';

abstract class DigitalTwinServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ProvisionTwinResponse> provisionTwin($pb.ServerContext ctx, $1.ProvisionTwinRequest request);
  $async.Future<$1.GetTwinStateResponse> getTwinState($pb.ServerContext ctx, $1.GetTwinStateRequest request);
  $async.Future<$1.UpdateTwinStateResponse> updateTwinState($pb.ServerContext ctx, $1.UpdateTwinStateRequest request);
  $async.Future<$1.DeprovisionTwinResponse> deprovisionTwin($pb.ServerContext ctx, $1.DeprovisionTwinRequest request);
  $async.Future<$1.ListTwinsByProjectResponse> listTwinsByProject($pb.ServerContext ctx, $1.ListTwinsByProjectRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ProvisionTwin': return $1.ProvisionTwinRequest();
      case 'GetTwinState': return $1.GetTwinStateRequest();
      case 'UpdateTwinState': return $1.UpdateTwinStateRequest();
      case 'DeprovisionTwin': return $1.DeprovisionTwinRequest();
      case 'ListTwinsByProject': return $1.ListTwinsByProjectRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ProvisionTwin': return this.provisionTwin(ctx, request as $1.ProvisionTwinRequest);
      case 'GetTwinState': return this.getTwinState(ctx, request as $1.GetTwinStateRequest);
      case 'UpdateTwinState': return this.updateTwinState(ctx, request as $1.UpdateTwinStateRequest);
      case 'DeprovisionTwin': return this.deprovisionTwin(ctx, request as $1.DeprovisionTwinRequest);
      case 'ListTwinsByProject': return this.listTwinsByProject(ctx, request as $1.ListTwinsByProjectRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => DigitalTwinServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => DigitalTwinServiceBase$messageJson;
}

