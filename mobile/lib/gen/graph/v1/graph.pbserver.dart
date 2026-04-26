//
//  Generated code. Do not modify.
//  source: graph/v1/graph.proto
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

import 'graph.pb.dart' as $3;
import 'graph.pbjson.dart';

export 'graph.pb.dart';

abstract class GraphServiceBase extends $pb.GeneratedService {
  $async.Future<$3.MinimumSpanningTreeResponse> minimumSpanningTree($pb.ServerContext ctx, $3.MinimumSpanningTreeRequest request);
  $async.Future<$3.ApproximateSteinerTreeResponse> approximateSteinerTree($pb.ServerContext ctx, $3.ApproximateSteinerTreeRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'MinimumSpanningTree': return $3.MinimumSpanningTreeRequest();
      case 'ApproximateSteinerTree': return $3.ApproximateSteinerTreeRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'MinimumSpanningTree': return this.minimumSpanningTree(ctx, request as $3.MinimumSpanningTreeRequest);
      case 'ApproximateSteinerTree': return this.approximateSteinerTree(ctx, request as $3.ApproximateSteinerTreeRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => GraphServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => GraphServiceBase$messageJson;
}

