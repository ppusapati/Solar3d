//
//  Generated code. Do not modify.
//  source: packages/pagination.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use paginationDescriptor instead')
const Pagination$json = {
  '1': 'Pagination',
  '2': [
    {'1': 'page_offset', '3': 1, '4': 1, '5': 5, '10': 'pageOffset'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'sort', '3': 3, '4': 3, '5': 9, '10': 'sort'},
    {'1': 'fields', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.FieldMask', '10': 'fields'},
  ],
};

/// Descriptor for `Pagination`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationDescriptor = $convert.base64Decode(
    'CgpQYWdpbmF0aW9uEh8KC3BhZ2Vfb2Zmc2V0GAEgASgFUgpwYWdlT2Zmc2V0EhsKCXBhZ2Vfc2'
    'l6ZRgCIAEoBVIIcGFnZVNpemUSEgoEc29ydBgDIAMoCVIEc29ydBIyCgZmaWVsZHMYBCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuRmllbGRNYXNrUgZmaWVsZHM=');

@$core.Deprecated('Use paginationRequestDescriptor instead')
const PaginationRequest$json = {
  '1': 'PaginationRequest',
  '2': [
    {'1': 'page_offset', '3': 1, '4': 1, '5': 5, '10': 'pageOffset'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'sort', '3': 3, '4': 3, '5': 9, '10': 'sort'},
    {'1': 'fields', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.FieldMask', '10': 'fields'},
  ],
};

/// Descriptor for `PaginationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationRequestDescriptor = $convert.base64Decode(
    'ChFQYWdpbmF0aW9uUmVxdWVzdBIfCgtwYWdlX29mZnNldBgBIAEoBVIKcGFnZU9mZnNldBIbCg'
    'lwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXplEhIKBHNvcnQYAyADKAlSBHNvcnQSMgoGZmllbGRz'
    'GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLkZpZWxkTWFza1IGZmllbGRz');

@$core.Deprecated('Use paginationResponseDescriptor instead')
const PaginationResponse$json = {
  '1': 'PaginationResponse',
  '2': [
    {'1': 'total_count', '3': 1, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'page_offset', '3': 2, '4': 1, '5': 5, '10': 'pageOffset'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'has_next', '3': 4, '4': 1, '5': 8, '10': 'hasNext'},
  ],
};

/// Descriptor for `PaginationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationResponseDescriptor = $convert.base64Decode(
    'ChJQYWdpbmF0aW9uUmVzcG9uc2USHwoLdG90YWxfY291bnQYASABKAVSCnRvdGFsQ291bnQSHw'
    'oLcGFnZV9vZmZzZXQYAiABKAVSCnBhZ2VPZmZzZXQSGwoJcGFnZV9zaXplGAMgASgFUghwYWdl'
    'U2l6ZRIZCghoYXNfbmV4dBgEIAEoCFIHaGFzTmV4dA==');

