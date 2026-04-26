//
//  Generated code. Do not modify.
//  source: graph/v1/graph.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../common/v1/primitives.pbjson.dart' as $0;
import '../../google/protobuf/timestamp.pbjson.dart' as $2;
import 'graph_domain.pbjson.dart' as $1;

@$core.Deprecated('Use graphEdgeDescriptor instead')
const GraphEdge$json = {
  '1': 'GraphEdge',
  '2': [
    {'1': 'u', '3': 1, '4': 1, '5': 5, '10': 'u'},
    {'1': 'v', '3': 2, '4': 1, '5': 5, '10': 'v'},
    {'1': 'weight', '3': 3, '4': 1, '5': 1, '10': 'weight'},
  ],
};

/// Descriptor for `GraphEdge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphEdgeDescriptor = $convert.base64Decode(
    'CglHcmFwaEVkZ2USDAoBdRgBIAEoBVIBdRIMCgF2GAIgASgFUgF2EhYKBndlaWdodBgDIAEoAV'
    'IGd2VpZ2h0');

@$core.Deprecated('Use minimumSpanningTreeRequestDescriptor instead')
const MinimumSpanningTreeRequest$json = {
  '1': 'MinimumSpanningTreeRequest',
  '2': [
    {'1': 'node_count', '3': 1, '4': 1, '5': 5, '10': 'nodeCount'},
    {'1': 'edges', '3': 2, '4': 3, '5': 11, '6': '.graph.v1.GraphEdge', '10': 'edges'},
    {'1': 'topology', '3': 10, '4': 1, '5': 11, '6': '.graph.v1.GraphTopology', '10': 'topology'},
  ],
};

/// Descriptor for `MinimumSpanningTreeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List minimumSpanningTreeRequestDescriptor = $convert.base64Decode(
    'ChpNaW5pbXVtU3Bhbm5pbmdUcmVlUmVxdWVzdBIdCgpub2RlX2NvdW50GAEgASgFUglub2RlQ2'
    '91bnQSKQoFZWRnZXMYAiADKAsyEy5ncmFwaC52MS5HcmFwaEVkZ2VSBWVkZ2VzEjMKCHRvcG9s'
    'b2d5GAogASgLMhcuZ3JhcGgudjEuR3JhcGhUb3BvbG9neVIIdG9wb2xvZ3k=');

@$core.Deprecated('Use minimumSpanningTreeResponseDescriptor instead')
const MinimumSpanningTreeResponse$json = {
  '1': 'MinimumSpanningTreeResponse',
  '2': [
    {'1': 'edges', '3': 1, '4': 3, '5': 11, '6': '.graph.v1.GraphEdge', '10': 'edges'},
    {'1': 'output_topology', '3': 10, '4': 1, '5': 11, '6': '.graph.v1.GraphTopology', '10': 'outputTopology'},
  ],
};

/// Descriptor for `MinimumSpanningTreeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List minimumSpanningTreeResponseDescriptor = $convert.base64Decode(
    'ChtNaW5pbXVtU3Bhbm5pbmdUcmVlUmVzcG9uc2USKQoFZWRnZXMYASADKAsyEy5ncmFwaC52MS'
    '5HcmFwaEVkZ2VSBWVkZ2VzEkAKD291dHB1dF90b3BvbG9neRgKIAEoCzIXLmdyYXBoLnYxLkdy'
    'YXBoVG9wb2xvZ3lSDm91dHB1dFRvcG9sb2d5');

@$core.Deprecated('Use approximateSteinerTreeRequestDescriptor instead')
const ApproximateSteinerTreeRequest$json = {
  '1': 'ApproximateSteinerTreeRequest',
  '2': [
    {'1': 'node_count', '3': 1, '4': 1, '5': 5, '10': 'nodeCount'},
    {'1': 'edges', '3': 2, '4': 3, '5': 11, '6': '.graph.v1.GraphEdge', '10': 'edges'},
    {'1': 'terminals', '3': 3, '4': 3, '5': 5, '10': 'terminals'},
    {'1': 'topology', '3': 10, '4': 1, '5': 11, '6': '.graph.v1.GraphTopology', '10': 'topology'},
    {'1': 'terminal_set', '3': 11, '4': 1, '5': 11, '6': '.graph.v1.TerminalSet', '10': 'terminalSet'},
    {'1': 'constraints', '3': 12, '4': 1, '5': 11, '6': '.graph.v1.GraphConstraint', '10': 'constraints'},
  ],
};

/// Descriptor for `ApproximateSteinerTreeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approximateSteinerTreeRequestDescriptor = $convert.base64Decode(
    'Ch1BcHByb3hpbWF0ZVN0ZWluZXJUcmVlUmVxdWVzdBIdCgpub2RlX2NvdW50GAEgASgFUglub2'
    'RlQ291bnQSKQoFZWRnZXMYAiADKAsyEy5ncmFwaC52MS5HcmFwaEVkZ2VSBWVkZ2VzEhwKCXRl'
    'cm1pbmFscxgDIAMoBVIJdGVybWluYWxzEjMKCHRvcG9sb2d5GAogASgLMhcuZ3JhcGgudjEuR3'
    'JhcGhUb3BvbG9neVIIdG9wb2xvZ3kSOAoMdGVybWluYWxfc2V0GAsgASgLMhUuZ3JhcGgudjEu'
    'VGVybWluYWxTZXRSC3Rlcm1pbmFsU2V0EjsKC2NvbnN0cmFpbnRzGAwgASgLMhkuZ3JhcGgudj'
    'EuR3JhcGhDb25zdHJhaW50Ugtjb25zdHJhaW50cw==');

@$core.Deprecated('Use approximateSteinerTreeResponseDescriptor instead')
const ApproximateSteinerTreeResponse$json = {
  '1': 'ApproximateSteinerTreeResponse',
  '2': [
    {'1': 'edges', '3': 1, '4': 3, '5': 11, '6': '.graph.v1.GraphEdge', '10': 'edges'},
    {'1': 'output_topology', '3': 10, '4': 1, '5': 11, '6': '.graph.v1.GraphTopology', '10': 'outputTopology'},
  ],
};

/// Descriptor for `ApproximateSteinerTreeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approximateSteinerTreeResponseDescriptor = $convert.base64Decode(
    'Ch5BcHByb3hpbWF0ZVN0ZWluZXJUcmVlUmVzcG9uc2USKQoFZWRnZXMYASADKAsyEy5ncmFwaC'
    '52MS5HcmFwaEVkZ2VSBWVkZ2VzEkAKD291dHB1dF90b3BvbG9neRgKIAEoCzIXLmdyYXBoLnYx'
    'LkdyYXBoVG9wb2xvZ3lSDm91dHB1dFRvcG9sb2d5');

const $core.Map<$core.String, $core.dynamic> GraphServiceBase$json = {
  '1': 'GraphService',
  '2': [
    {'1': 'MinimumSpanningTree', '2': '.graph.v1.MinimumSpanningTreeRequest', '3': '.graph.v1.MinimumSpanningTreeResponse'},
    {'1': 'ApproximateSteinerTree', '2': '.graph.v1.ApproximateSteinerTreeRequest', '3': '.graph.v1.ApproximateSteinerTreeResponse'},
  ],
};

@$core.Deprecated('Use graphServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> GraphServiceBase$messageJson = {
  '.graph.v1.MinimumSpanningTreeRequest': MinimumSpanningTreeRequest$json,
  '.graph.v1.GraphEdge': GraphEdge$json,
  '.graph.v1.GraphTopology': $1.GraphTopology$json,
  '.graph.v1.GraphNode': $1.GraphNode$json,
  '.common.v1.Point3D': $0.Point3D$json,
  '.graph.v1.GraphNode.ScalarAttributesEntry': $1.GraphNode_ScalarAttributesEntry$json,
  '.graph.v1.GraphNode.TagsEntry': $1.GraphNode_TagsEntry$json,
  '.graph.v1.WeightedEdge': $1.WeightedEdge$json,
  '.graph.v1.WeightedEdge.ScalarAttributesEntry': $1.WeightedEdge_ScalarAttributesEntry$json,
  '.common.v1.ContractMetadata': $0.ContractMetadata$json,
  '.common.v1.ApiVersion': $0.ApiVersion$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.graph.v1.MinimumSpanningTreeResponse': MinimumSpanningTreeResponse$json,
  '.graph.v1.ApproximateSteinerTreeRequest': ApproximateSteinerTreeRequest$json,
  '.graph.v1.TerminalSet': $1.TerminalSet$json,
  '.graph.v1.GraphConstraint': $1.GraphConstraint$json,
  '.common.v1.NumericRange': $0.NumericRange$json,
  '.graph.v1.ApproximateSteinerTreeResponse': ApproximateSteinerTreeResponse$json,
};

/// Descriptor for `GraphService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List graphServiceDescriptor = $convert.base64Decode(
    'CgxHcmFwaFNlcnZpY2USYgoTTWluaW11bVNwYW5uaW5nVHJlZRIkLmdyYXBoLnYxLk1pbmltdW'
    '1TcGFubmluZ1RyZWVSZXF1ZXN0GiUuZ3JhcGgudjEuTWluaW11bVNwYW5uaW5nVHJlZVJlc3Bv'
    'bnNlEmsKFkFwcHJveGltYXRlU3RlaW5lclRyZWUSJy5ncmFwaC52MS5BcHByb3hpbWF0ZVN0ZW'
    'luZXJUcmVlUmVxdWVzdBooLmdyYXBoLnYxLkFwcHJveGltYXRlU3RlaW5lclRyZWVSZXNwb25z'
    'ZQ==');

