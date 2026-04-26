//
//  Generated code. Do not modify.
//  source: graph/v1/graph.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'graph_domain.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GraphEdge extends $pb.GeneratedMessage {
  factory GraphEdge({
    $core.int? u,
    $core.int? v,
    $core.double? weight,
  }) {
    final $result = create();
    if (u != null) {
      $result.u = u;
    }
    if (v != null) {
      $result.v = v;
    }
    if (weight != null) {
      $result.weight = weight;
    }
    return $result;
  }
  GraphEdge._() : super();
  factory GraphEdge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GraphEdge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GraphEdge', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'u', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'v', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'weight', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GraphEdge clone() => GraphEdge()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GraphEdge copyWith(void Function(GraphEdge) updates) => super.copyWith((message) => updates(message as GraphEdge)) as GraphEdge;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphEdge create() => GraphEdge._();
  GraphEdge createEmptyInstance() => create();
  static $pb.PbList<GraphEdge> createRepeated() => $pb.PbList<GraphEdge>();
  @$core.pragma('dart2js:noInline')
  static GraphEdge getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GraphEdge>(create);
  static GraphEdge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get u => $_getIZ(0);
  @$pb.TagNumber(1)
  set u($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasU() => $_has(0);
  @$pb.TagNumber(1)
  void clearU() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get v => $_getIZ(1);
  @$pb.TagNumber(2)
  set v($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasV() => $_has(1);
  @$pb.TagNumber(2)
  void clearV() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get weight => $_getN(2);
  @$pb.TagNumber(3)
  set weight($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => $_clearField(3);
}

class MinimumSpanningTreeRequest extends $pb.GeneratedMessage {
  factory MinimumSpanningTreeRequest({
    $core.int? nodeCount,
    $core.Iterable<GraphEdge>? edges,
    $1.GraphTopology? topology,
  }) {
    final $result = create();
    if (nodeCount != null) {
      $result.nodeCount = nodeCount;
    }
    if (edges != null) {
      $result.edges.addAll(edges);
    }
    if (topology != null) {
      $result.topology = topology;
    }
    return $result;
  }
  MinimumSpanningTreeRequest._() : super();
  factory MinimumSpanningTreeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MinimumSpanningTreeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MinimumSpanningTreeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'nodeCount', $pb.PbFieldType.O3)
    ..pc<GraphEdge>(2, _omitFieldNames ? '' : 'edges', $pb.PbFieldType.PM, subBuilder: GraphEdge.create)
    ..aOM<$1.GraphTopology>(10, _omitFieldNames ? '' : 'topology', subBuilder: $1.GraphTopology.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MinimumSpanningTreeRequest clone() => MinimumSpanningTreeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MinimumSpanningTreeRequest copyWith(void Function(MinimumSpanningTreeRequest) updates) => super.copyWith((message) => updates(message as MinimumSpanningTreeRequest)) as MinimumSpanningTreeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MinimumSpanningTreeRequest create() => MinimumSpanningTreeRequest._();
  MinimumSpanningTreeRequest createEmptyInstance() => create();
  static $pb.PbList<MinimumSpanningTreeRequest> createRepeated() => $pb.PbList<MinimumSpanningTreeRequest>();
  @$core.pragma('dart2js:noInline')
  static MinimumSpanningTreeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MinimumSpanningTreeRequest>(create);
  static MinimumSpanningTreeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get nodeCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set nodeCount($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<GraphEdge> get edges => $_getList(1);

  /// Canonical topology payload for cross-service compatibility.
  @$pb.TagNumber(10)
  $1.GraphTopology get topology => $_getN(2);
  @$pb.TagNumber(10)
  set topology($1.GraphTopology v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasTopology() => $_has(2);
  @$pb.TagNumber(10)
  void clearTopology() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.GraphTopology ensureTopology() => $_ensure(2);
}

class MinimumSpanningTreeResponse extends $pb.GeneratedMessage {
  factory MinimumSpanningTreeResponse({
    $core.Iterable<GraphEdge>? edges,
    $1.GraphTopology? outputTopology,
  }) {
    final $result = create();
    if (edges != null) {
      $result.edges.addAll(edges);
    }
    if (outputTopology != null) {
      $result.outputTopology = outputTopology;
    }
    return $result;
  }
  MinimumSpanningTreeResponse._() : super();
  factory MinimumSpanningTreeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MinimumSpanningTreeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MinimumSpanningTreeResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..pc<GraphEdge>(1, _omitFieldNames ? '' : 'edges', $pb.PbFieldType.PM, subBuilder: GraphEdge.create)
    ..aOM<$1.GraphTopology>(10, _omitFieldNames ? '' : 'outputTopology', subBuilder: $1.GraphTopology.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MinimumSpanningTreeResponse clone() => MinimumSpanningTreeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MinimumSpanningTreeResponse copyWith(void Function(MinimumSpanningTreeResponse) updates) => super.copyWith((message) => updates(message as MinimumSpanningTreeResponse)) as MinimumSpanningTreeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MinimumSpanningTreeResponse create() => MinimumSpanningTreeResponse._();
  MinimumSpanningTreeResponse createEmptyInstance() => create();
  static $pb.PbList<MinimumSpanningTreeResponse> createRepeated() => $pb.PbList<MinimumSpanningTreeResponse>();
  @$core.pragma('dart2js:noInline')
  static MinimumSpanningTreeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MinimumSpanningTreeResponse>(create);
  static MinimumSpanningTreeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GraphEdge> get edges => $_getList(0);

  @$pb.TagNumber(10)
  $1.GraphTopology get outputTopology => $_getN(1);
  @$pb.TagNumber(10)
  set outputTopology($1.GraphTopology v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasOutputTopology() => $_has(1);
  @$pb.TagNumber(10)
  void clearOutputTopology() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.GraphTopology ensureOutputTopology() => $_ensure(1);
}

class ApproximateSteinerTreeRequest extends $pb.GeneratedMessage {
  factory ApproximateSteinerTreeRequest({
    $core.int? nodeCount,
    $core.Iterable<GraphEdge>? edges,
    $core.Iterable<$core.int>? terminals,
    $1.GraphTopology? topology,
    $1.TerminalSet? terminalSet,
    $1.GraphConstraint? constraints,
  }) {
    final $result = create();
    if (nodeCount != null) {
      $result.nodeCount = nodeCount;
    }
    if (edges != null) {
      $result.edges.addAll(edges);
    }
    if (terminals != null) {
      $result.terminals.addAll(terminals);
    }
    if (topology != null) {
      $result.topology = topology;
    }
    if (terminalSet != null) {
      $result.terminalSet = terminalSet;
    }
    if (constraints != null) {
      $result.constraints = constraints;
    }
    return $result;
  }
  ApproximateSteinerTreeRequest._() : super();
  factory ApproximateSteinerTreeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproximateSteinerTreeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproximateSteinerTreeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'nodeCount', $pb.PbFieldType.O3)
    ..pc<GraphEdge>(2, _omitFieldNames ? '' : 'edges', $pb.PbFieldType.PM, subBuilder: GraphEdge.create)
    ..p<$core.int>(3, _omitFieldNames ? '' : 'terminals', $pb.PbFieldType.K3)
    ..aOM<$1.GraphTopology>(10, _omitFieldNames ? '' : 'topology', subBuilder: $1.GraphTopology.create)
    ..aOM<$1.TerminalSet>(11, _omitFieldNames ? '' : 'terminalSet', subBuilder: $1.TerminalSet.create)
    ..aOM<$1.GraphConstraint>(12, _omitFieldNames ? '' : 'constraints', subBuilder: $1.GraphConstraint.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproximateSteinerTreeRequest clone() => ApproximateSteinerTreeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproximateSteinerTreeRequest copyWith(void Function(ApproximateSteinerTreeRequest) updates) => super.copyWith((message) => updates(message as ApproximateSteinerTreeRequest)) as ApproximateSteinerTreeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproximateSteinerTreeRequest create() => ApproximateSteinerTreeRequest._();
  ApproximateSteinerTreeRequest createEmptyInstance() => create();
  static $pb.PbList<ApproximateSteinerTreeRequest> createRepeated() => $pb.PbList<ApproximateSteinerTreeRequest>();
  @$core.pragma('dart2js:noInline')
  static ApproximateSteinerTreeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproximateSteinerTreeRequest>(create);
  static ApproximateSteinerTreeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get nodeCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set nodeCount($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<GraphEdge> get edges => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get terminals => $_getList(2);

  @$pb.TagNumber(10)
  $1.GraphTopology get topology => $_getN(3);
  @$pb.TagNumber(10)
  set topology($1.GraphTopology v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasTopology() => $_has(3);
  @$pb.TagNumber(10)
  void clearTopology() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.GraphTopology ensureTopology() => $_ensure(3);

  @$pb.TagNumber(11)
  $1.TerminalSet get terminalSet => $_getN(4);
  @$pb.TagNumber(11)
  set terminalSet($1.TerminalSet v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasTerminalSet() => $_has(4);
  @$pb.TagNumber(11)
  void clearTerminalSet() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.TerminalSet ensureTerminalSet() => $_ensure(4);

  @$pb.TagNumber(12)
  $1.GraphConstraint get constraints => $_getN(5);
  @$pb.TagNumber(12)
  set constraints($1.GraphConstraint v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasConstraints() => $_has(5);
  @$pb.TagNumber(12)
  void clearConstraints() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.GraphConstraint ensureConstraints() => $_ensure(5);
}

class ApproximateSteinerTreeResponse extends $pb.GeneratedMessage {
  factory ApproximateSteinerTreeResponse({
    $core.Iterable<GraphEdge>? edges,
    $1.GraphTopology? outputTopology,
  }) {
    final $result = create();
    if (edges != null) {
      $result.edges.addAll(edges);
    }
    if (outputTopology != null) {
      $result.outputTopology = outputTopology;
    }
    return $result;
  }
  ApproximateSteinerTreeResponse._() : super();
  factory ApproximateSteinerTreeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproximateSteinerTreeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproximateSteinerTreeResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..pc<GraphEdge>(1, _omitFieldNames ? '' : 'edges', $pb.PbFieldType.PM, subBuilder: GraphEdge.create)
    ..aOM<$1.GraphTopology>(10, _omitFieldNames ? '' : 'outputTopology', subBuilder: $1.GraphTopology.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproximateSteinerTreeResponse clone() => ApproximateSteinerTreeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproximateSteinerTreeResponse copyWith(void Function(ApproximateSteinerTreeResponse) updates) => super.copyWith((message) => updates(message as ApproximateSteinerTreeResponse)) as ApproximateSteinerTreeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproximateSteinerTreeResponse create() => ApproximateSteinerTreeResponse._();
  ApproximateSteinerTreeResponse createEmptyInstance() => create();
  static $pb.PbList<ApproximateSteinerTreeResponse> createRepeated() => $pb.PbList<ApproximateSteinerTreeResponse>();
  @$core.pragma('dart2js:noInline')
  static ApproximateSteinerTreeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproximateSteinerTreeResponse>(create);
  static ApproximateSteinerTreeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GraphEdge> get edges => $_getList(0);

  @$pb.TagNumber(10)
  $1.GraphTopology get outputTopology => $_getN(1);
  @$pb.TagNumber(10)
  set outputTopology($1.GraphTopology v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasOutputTopology() => $_has(1);
  @$pb.TagNumber(10)
  void clearOutputTopology() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.GraphTopology ensureOutputTopology() => $_ensure(1);
}

/// GraphService exposes graph algorithms used for layout and routing optimization.
class GraphServiceApi {
  $pb.RpcClient _client;
  GraphServiceApi(this._client);

  /// MinimumSpanningTree computes the MST over the provided weighted graph.
  $async.Future<MinimumSpanningTreeResponse> minimumSpanningTree($pb.ClientContext? ctx, MinimumSpanningTreeRequest request) =>
    _client.invoke<MinimumSpanningTreeResponse>(ctx, 'GraphService', 'MinimumSpanningTree', request, MinimumSpanningTreeResponse())
  ;
  /// ApproximateSteinerTree computes an approximate Steiner tree for terminal nodes.
  $async.Future<ApproximateSteinerTreeResponse> approximateSteinerTree($pb.ClientContext? ctx, ApproximateSteinerTreeRequest request) =>
    _client.invoke<ApproximateSteinerTreeResponse>(ctx, 'GraphService', 'ApproximateSteinerTree', request, ApproximateSteinerTreeResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
