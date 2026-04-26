//
//  Generated code. Do not modify.
//  source: graph/v1/graph_domain.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/primitives.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GraphNode extends $pb.GeneratedMessage {
  factory GraphNode({
    $core.String? nodeId,
    $0.Point3D? position,
    $core.String? kind,
    $pb.PbMap<$core.String, $core.double>? scalarAttributes,
    $pb.PbMap<$core.String, $core.String>? tags,
  }) {
    final $result = create();
    if (nodeId != null) {
      $result.nodeId = nodeId;
    }
    if (position != null) {
      $result.position = position;
    }
    if (kind != null) {
      $result.kind = kind;
    }
    if (scalarAttributes != null) {
      $result.scalarAttributes.addAll(scalarAttributes);
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    return $result;
  }
  GraphNode._() : super();
  factory GraphNode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GraphNode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GraphNode', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOM<$0.Point3D>(2, _omitFieldNames ? '' : 'position', subBuilder: $0.Point3D.create)
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..m<$core.String, $core.double>(4, _omitFieldNames ? '' : 'scalarAttributes', entryClassName: 'GraphNode.ScalarAttributesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('graph.v1'))
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'tags', entryClassName: 'GraphNode.TagsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('graph.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GraphNode clone() => GraphNode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GraphNode copyWith(void Function(GraphNode) updates) => super.copyWith((message) => updates(message as GraphNode)) as GraphNode;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphNode create() => GraphNode._();
  GraphNode createEmptyInstance() => create();
  static $pb.PbList<GraphNode> createRepeated() => $pb.PbList<GraphNode>();
  @$core.pragma('dart2js:noInline')
  static GraphNode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GraphNode>(create);
  static GraphNode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Point3D get position => $_getN(1);
  @$pb.TagNumber(2)
  set position($0.Point3D v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Point3D ensurePosition() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get scalarAttributes => $_getMap(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get tags => $_getMap(4);
}

class WeightedEdge extends $pb.GeneratedMessage {
  factory WeightedEdge({
    $core.String? edgeId,
    $core.String? fromNodeId,
    $core.String? toNodeId,
    $core.double? weight,
    $core.bool? directed,
    $core.double? capacity,
    $pb.PbMap<$core.String, $core.double>? scalarAttributes,
  }) {
    final $result = create();
    if (edgeId != null) {
      $result.edgeId = edgeId;
    }
    if (fromNodeId != null) {
      $result.fromNodeId = fromNodeId;
    }
    if (toNodeId != null) {
      $result.toNodeId = toNodeId;
    }
    if (weight != null) {
      $result.weight = weight;
    }
    if (directed != null) {
      $result.directed = directed;
    }
    if (capacity != null) {
      $result.capacity = capacity;
    }
    if (scalarAttributes != null) {
      $result.scalarAttributes.addAll(scalarAttributes);
    }
    return $result;
  }
  WeightedEdge._() : super();
  factory WeightedEdge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WeightedEdge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WeightedEdge', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'edgeId')
    ..aOS(2, _omitFieldNames ? '' : 'fromNodeId')
    ..aOS(3, _omitFieldNames ? '' : 'toNodeId')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'weight', $pb.PbFieldType.OD)
    ..aOB(5, _omitFieldNames ? '' : 'directed')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'capacity', $pb.PbFieldType.OD)
    ..m<$core.String, $core.double>(7, _omitFieldNames ? '' : 'scalarAttributes', entryClassName: 'WeightedEdge.ScalarAttributesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('graph.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WeightedEdge clone() => WeightedEdge()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WeightedEdge copyWith(void Function(WeightedEdge) updates) => super.copyWith((message) => updates(message as WeightedEdge)) as WeightedEdge;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeightedEdge create() => WeightedEdge._();
  WeightedEdge createEmptyInstance() => create();
  static $pb.PbList<WeightedEdge> createRepeated() => $pb.PbList<WeightedEdge>();
  @$core.pragma('dart2js:noInline')
  static WeightedEdge getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WeightedEdge>(create);
  static WeightedEdge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get edgeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set edgeId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEdgeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEdgeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromNodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromNodeId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromNodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toNodeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set toNodeId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToNodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToNodeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get weight => $_getN(3);
  @$pb.TagNumber(4)
  set weight($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasWeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get directed => $_getBF(4);
  @$pb.TagNumber(5)
  set directed($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDirected() => $_has(4);
  @$pb.TagNumber(5)
  void clearDirected() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get capacity => $_getN(5);
  @$pb.TagNumber(6)
  set capacity($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCapacity() => $_has(5);
  @$pb.TagNumber(6)
  void clearCapacity() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.double> get scalarAttributes => $_getMap(6);
}

class GraphTopology extends $pb.GeneratedMessage {
  factory GraphTopology({
    $core.String? graphId,
    $core.Iterable<GraphNode>? nodes,
    $core.Iterable<WeightedEdge>? edges,
    $core.String? coordinateSystem,
    $0.ContractMetadata? contract,
  }) {
    final $result = create();
    if (graphId != null) {
      $result.graphId = graphId;
    }
    if (nodes != null) {
      $result.nodes.addAll(nodes);
    }
    if (edges != null) {
      $result.edges.addAll(edges);
    }
    if (coordinateSystem != null) {
      $result.coordinateSystem = coordinateSystem;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  GraphTopology._() : super();
  factory GraphTopology.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GraphTopology.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GraphTopology', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'graphId')
    ..pc<GraphNode>(2, _omitFieldNames ? '' : 'nodes', $pb.PbFieldType.PM, subBuilder: GraphNode.create)
    ..pc<WeightedEdge>(3, _omitFieldNames ? '' : 'edges', $pb.PbFieldType.PM, subBuilder: WeightedEdge.create)
    ..aOS(4, _omitFieldNames ? '' : 'coordinateSystem')
    ..aOM<$0.ContractMetadata>(5, _omitFieldNames ? '' : 'contract', subBuilder: $0.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GraphTopology clone() => GraphTopology()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GraphTopology copyWith(void Function(GraphTopology) updates) => super.copyWith((message) => updates(message as GraphTopology)) as GraphTopology;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphTopology create() => GraphTopology._();
  GraphTopology createEmptyInstance() => create();
  static $pb.PbList<GraphTopology> createRepeated() => $pb.PbList<GraphTopology>();
  @$core.pragma('dart2js:noInline')
  static GraphTopology getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GraphTopology>(create);
  static GraphTopology? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get graphId => $_getSZ(0);
  @$pb.TagNumber(1)
  set graphId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGraphId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGraphId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<GraphNode> get nodes => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<WeightedEdge> get edges => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get coordinateSystem => $_getSZ(3);
  @$pb.TagNumber(4)
  set coordinateSystem($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCoordinateSystem() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoordinateSystem() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.ContractMetadata get contract => $_getN(4);
  @$pb.TagNumber(5)
  set contract($0.ContractMetadata v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasContract() => $_has(4);
  @$pb.TagNumber(5)
  void clearContract() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.ContractMetadata ensureContract() => $_ensure(4);
}

class TerminalSet extends $pb.GeneratedMessage {
  factory TerminalSet({
    $core.Iterable<$core.String>? nodeIds,
  }) {
    final $result = create();
    if (nodeIds != null) {
      $result.nodeIds.addAll(nodeIds);
    }
    return $result;
  }
  TerminalSet._() : super();
  factory TerminalSet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerminalSet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TerminalSet', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'nodeIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TerminalSet clone() => TerminalSet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TerminalSet copyWith(void Function(TerminalSet) updates) => super.copyWith((message) => updates(message as TerminalSet)) as TerminalSet;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TerminalSet create() => TerminalSet._();
  TerminalSet createEmptyInstance() => create();
  static $pb.PbList<TerminalSet> createRepeated() => $pb.PbList<TerminalSet>();
  @$core.pragma('dart2js:noInline')
  static TerminalSet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TerminalSet>(create);
  static TerminalSet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get nodeIds => $_getList(0);
}

class GraphConstraint extends $pb.GeneratedMessage {
  factory GraphConstraint({
    $0.NumericRange? maxDegree,
    $0.NumericRange? maxPathLength,
    $core.bool? enforceConnectivity,
    $core.Iterable<$core.String>? forbiddenEdgeIds,
  }) {
    final $result = create();
    if (maxDegree != null) {
      $result.maxDegree = maxDegree;
    }
    if (maxPathLength != null) {
      $result.maxPathLength = maxPathLength;
    }
    if (enforceConnectivity != null) {
      $result.enforceConnectivity = enforceConnectivity;
    }
    if (forbiddenEdgeIds != null) {
      $result.forbiddenEdgeIds.addAll(forbiddenEdgeIds);
    }
    return $result;
  }
  GraphConstraint._() : super();
  factory GraphConstraint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GraphConstraint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GraphConstraint', package: const $pb.PackageName(_omitMessageNames ? '' : 'graph.v1'), createEmptyInstance: create)
    ..aOM<$0.NumericRange>(1, _omitFieldNames ? '' : 'maxDegree', subBuilder: $0.NumericRange.create)
    ..aOM<$0.NumericRange>(2, _omitFieldNames ? '' : 'maxPathLength', subBuilder: $0.NumericRange.create)
    ..aOB(3, _omitFieldNames ? '' : 'enforceConnectivity')
    ..pPS(4, _omitFieldNames ? '' : 'forbiddenEdgeIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GraphConstraint clone() => GraphConstraint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GraphConstraint copyWith(void Function(GraphConstraint) updates) => super.copyWith((message) => updates(message as GraphConstraint)) as GraphConstraint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphConstraint create() => GraphConstraint._();
  GraphConstraint createEmptyInstance() => create();
  static $pb.PbList<GraphConstraint> createRepeated() => $pb.PbList<GraphConstraint>();
  @$core.pragma('dart2js:noInline')
  static GraphConstraint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GraphConstraint>(create);
  static GraphConstraint? _defaultInstance;

  @$pb.TagNumber(1)
  $0.NumericRange get maxDegree => $_getN(0);
  @$pb.TagNumber(1)
  set maxDegree($0.NumericRange v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMaxDegree() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxDegree() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.NumericRange ensureMaxDegree() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.NumericRange get maxPathLength => $_getN(1);
  @$pb.TagNumber(2)
  set maxPathLength($0.NumericRange v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxPathLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxPathLength() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.NumericRange ensureMaxPathLength() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get enforceConnectivity => $_getBF(2);
  @$pb.TagNumber(3)
  set enforceConnectivity($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEnforceConnectivity() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnforceConnectivity() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get forbiddenEdgeIds => $_getList(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
