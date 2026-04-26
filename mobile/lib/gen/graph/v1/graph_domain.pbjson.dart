//
//  Generated code. Do not modify.
//  source: graph/v1/graph_domain.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use graphNodeDescriptor instead')
const GraphNode$json = {
  '1': 'GraphNode',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.common.v1.Point3D', '10': 'position'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'scalar_attributes', '3': 4, '4': 3, '5': 11, '6': '.graph.v1.GraphNode.ScalarAttributesEntry', '10': 'scalarAttributes'},
    {'1': 'tags', '3': 5, '4': 3, '5': 11, '6': '.graph.v1.GraphNode.TagsEntry', '10': 'tags'},
  ],
  '3': [GraphNode_ScalarAttributesEntry$json, GraphNode_TagsEntry$json],
};

@$core.Deprecated('Use graphNodeDescriptor instead')
const GraphNode_ScalarAttributesEntry$json = {
  '1': 'ScalarAttributesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use graphNodeDescriptor instead')
const GraphNode_TagsEntry$json = {
  '1': 'TagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `GraphNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphNodeDescriptor = $convert.base64Decode(
    'CglHcmFwaE5vZGUSFwoHbm9kZV9pZBgBIAEoCVIGbm9kZUlkEi4KCHBvc2l0aW9uGAIgASgLMh'
    'IuY29tbW9uLnYxLlBvaW50M0RSCHBvc2l0aW9uEhIKBGtpbmQYAyABKAlSBGtpbmQSVgoRc2Nh'
    'bGFyX2F0dHJpYnV0ZXMYBCADKAsyKS5ncmFwaC52MS5HcmFwaE5vZGUuU2NhbGFyQXR0cmlidX'
    'Rlc0VudHJ5UhBzY2FsYXJBdHRyaWJ1dGVzEjEKBHRhZ3MYBSADKAsyHS5ncmFwaC52MS5HcmFw'
    'aE5vZGUuVGFnc0VudHJ5UgR0YWdzGkMKFVNjYWxhckF0dHJpYnV0ZXNFbnRyeRIQCgNrZXkYAS'
    'ABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgBGjcKCVRhZ3NFbnRyeRIQCgNrZXkY'
    'ASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use weightedEdgeDescriptor instead')
const WeightedEdge$json = {
  '1': 'WeightedEdge',
  '2': [
    {'1': 'edge_id', '3': 1, '4': 1, '5': 9, '10': 'edgeId'},
    {'1': 'from_node_id', '3': 2, '4': 1, '5': 9, '10': 'fromNodeId'},
    {'1': 'to_node_id', '3': 3, '4': 1, '5': 9, '10': 'toNodeId'},
    {'1': 'weight', '3': 4, '4': 1, '5': 1, '10': 'weight'},
    {'1': 'directed', '3': 5, '4': 1, '5': 8, '10': 'directed'},
    {'1': 'capacity', '3': 6, '4': 1, '5': 1, '10': 'capacity'},
    {'1': 'scalar_attributes', '3': 7, '4': 3, '5': 11, '6': '.graph.v1.WeightedEdge.ScalarAttributesEntry', '10': 'scalarAttributes'},
  ],
  '3': [WeightedEdge_ScalarAttributesEntry$json],
};

@$core.Deprecated('Use weightedEdgeDescriptor instead')
const WeightedEdge_ScalarAttributesEntry$json = {
  '1': 'ScalarAttributesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `WeightedEdge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weightedEdgeDescriptor = $convert.base64Decode(
    'CgxXZWlnaHRlZEVkZ2USFwoHZWRnZV9pZBgBIAEoCVIGZWRnZUlkEiAKDGZyb21fbm9kZV9pZB'
    'gCIAEoCVIKZnJvbU5vZGVJZBIcCgp0b19ub2RlX2lkGAMgASgJUgh0b05vZGVJZBIWCgZ3ZWln'
    'aHQYBCABKAFSBndlaWdodBIaCghkaXJlY3RlZBgFIAEoCFIIZGlyZWN0ZWQSGgoIY2FwYWNpdH'
    'kYBiABKAFSCGNhcGFjaXR5ElkKEXNjYWxhcl9hdHRyaWJ1dGVzGAcgAygLMiwuZ3JhcGgudjEu'
    'V2VpZ2h0ZWRFZGdlLlNjYWxhckF0dHJpYnV0ZXNFbnRyeVIQc2NhbGFyQXR0cmlidXRlcxpDCh'
    'VTY2FsYXJBdHRyaWJ1dGVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAFS'
    'BXZhbHVlOgI4AQ==');

@$core.Deprecated('Use graphTopologyDescriptor instead')
const GraphTopology$json = {
  '1': 'GraphTopology',
  '2': [
    {'1': 'graph_id', '3': 1, '4': 1, '5': 9, '10': 'graphId'},
    {'1': 'nodes', '3': 2, '4': 3, '5': 11, '6': '.graph.v1.GraphNode', '10': 'nodes'},
    {'1': 'edges', '3': 3, '4': 3, '5': 11, '6': '.graph.v1.WeightedEdge', '10': 'edges'},
    {'1': 'coordinate_system', '3': 4, '4': 1, '5': 9, '10': 'coordinateSystem'},
    {'1': 'contract', '3': 5, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `GraphTopology`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphTopologyDescriptor = $convert.base64Decode(
    'Cg1HcmFwaFRvcG9sb2d5EhkKCGdyYXBoX2lkGAEgASgJUgdncmFwaElkEikKBW5vZGVzGAIgAy'
    'gLMhMuZ3JhcGgudjEuR3JhcGhOb2RlUgVub2RlcxIsCgVlZGdlcxgDIAMoCzIWLmdyYXBoLnYx'
    'LldlaWdodGVkRWRnZVIFZWRnZXMSKwoRY29vcmRpbmF0ZV9zeXN0ZW0YBCABKAlSEGNvb3JkaW'
    '5hdGVTeXN0ZW0SNwoIY29udHJhY3QYBSABKAsyGy5jb21tb24udjEuQ29udHJhY3RNZXRhZGF0'
    'YVIIY29udHJhY3Q=');

@$core.Deprecated('Use terminalSetDescriptor instead')
const TerminalSet$json = {
  '1': 'TerminalSet',
  '2': [
    {'1': 'node_ids', '3': 1, '4': 3, '5': 9, '10': 'nodeIds'},
  ],
};

/// Descriptor for `TerminalSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terminalSetDescriptor = $convert.base64Decode(
    'CgtUZXJtaW5hbFNldBIZCghub2RlX2lkcxgBIAMoCVIHbm9kZUlkcw==');

@$core.Deprecated('Use graphConstraintDescriptor instead')
const GraphConstraint$json = {
  '1': 'GraphConstraint',
  '2': [
    {'1': 'max_degree', '3': 1, '4': 1, '5': 11, '6': '.common.v1.NumericRange', '10': 'maxDegree'},
    {'1': 'max_path_length', '3': 2, '4': 1, '5': 11, '6': '.common.v1.NumericRange', '10': 'maxPathLength'},
    {'1': 'enforce_connectivity', '3': 3, '4': 1, '5': 8, '10': 'enforceConnectivity'},
    {'1': 'forbidden_edge_ids', '3': 4, '4': 3, '5': 9, '10': 'forbiddenEdgeIds'},
  ],
};

/// Descriptor for `GraphConstraint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphConstraintDescriptor = $convert.base64Decode(
    'Cg9HcmFwaENvbnN0cmFpbnQSNgoKbWF4X2RlZ3JlZRgBIAEoCzIXLmNvbW1vbi52MS5OdW1lcm'
    'ljUmFuZ2VSCW1heERlZ3JlZRI/Cg9tYXhfcGF0aF9sZW5ndGgYAiABKAsyFy5jb21tb24udjEu'
    'TnVtZXJpY1JhbmdlUg1tYXhQYXRoTGVuZ3RoEjEKFGVuZm9yY2VfY29ubmVjdGl2aXR5GAMgAS'
    'gIUhNlbmZvcmNlQ29ubmVjdGl2aXR5EiwKEmZvcmJpZGRlbl9lZGdlX2lkcxgEIAMoCVIQZm9y'
    'YmlkZGVuRWRnZUlkcw==');

