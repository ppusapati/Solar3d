//
//  Generated code. Do not modify.
//  source: geo/v1/geo.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use point2DDescriptor instead')
const Point2D$json = {
  '1': 'Point2D',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `Point2D`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List point2DDescriptor = $convert.base64Decode(
    'CgdQb2ludDJEEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeQ==');

@$core.Deprecated('Use polygonDescriptor instead')
const Polygon$json = {
  '1': 'Polygon',
  '2': [
    {'1': 'ring', '3': 1, '4': 3, '5': 11, '6': '.geo.v1.Point2D', '10': 'ring'},
  ],
};

/// Descriptor for `Polygon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List polygonDescriptor = $convert.base64Decode(
    'CgdQb2x5Z29uEiMKBHJpbmcYASADKAsyDy5nZW8udjEuUG9pbnQyRFIEcmluZw==');

@$core.Deprecated('Use bufferPointRequestDescriptor instead')
const BufferPointRequest$json = {
  '1': 'BufferPointRequest',
  '2': [
    {'1': 'center', '3': 1, '4': 1, '5': 11, '6': '.geo.v1.Point2D', '10': 'center'},
    {'1': 'radius', '3': 2, '4': 1, '5': 1, '10': 'radius'},
    {'1': 'segments', '3': 3, '4': 1, '5': 5, '10': 'segments'},
  ],
};

/// Descriptor for `BufferPointRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bufferPointRequestDescriptor = $convert.base64Decode(
    'ChJCdWZmZXJQb2ludFJlcXVlc3QSJwoGY2VudGVyGAEgASgLMg8uZ2VvLnYxLlBvaW50MkRSBm'
    'NlbnRlchIWCgZyYWRpdXMYAiABKAFSBnJhZGl1cxIaCghzZWdtZW50cxgDIAEoBVIIc2VnbWVu'
    'dHM=');

@$core.Deprecated('Use bufferPointResponseDescriptor instead')
const BufferPointResponse$json = {
  '1': 'BufferPointResponse',
  '2': [
    {'1': 'polygon', '3': 1, '4': 1, '5': 11, '6': '.geo.v1.Polygon', '10': 'polygon'},
  ],
};

/// Descriptor for `BufferPointResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bufferPointResponseDescriptor = $convert.base64Decode(
    'ChNCdWZmZXJQb2ludFJlc3BvbnNlEikKB3BvbHlnb24YASABKAsyDy5nZW8udjEuUG9seWdvbl'
    'IHcG9seWdvbg==');

@$core.Deprecated('Use nearestPointRequestDescriptor instead')
const NearestPointRequest$json = {
  '1': 'NearestPointRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 11, '6': '.geo.v1.Point2D', '10': 'query'},
    {'1': 'candidates', '3': 2, '4': 3, '5': 11, '6': '.geo.v1.Point2D', '10': 'candidates'},
  ],
};

/// Descriptor for `NearestPointRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nearestPointRequestDescriptor = $convert.base64Decode(
    'ChNOZWFyZXN0UG9pbnRSZXF1ZXN0EiUKBXF1ZXJ5GAEgASgLMg8uZ2VvLnYxLlBvaW50MkRSBX'
    'F1ZXJ5Ei8KCmNhbmRpZGF0ZXMYAiADKAsyDy5nZW8udjEuUG9pbnQyRFIKY2FuZGlkYXRlcw==');

@$core.Deprecated('Use nearestPointResponseDescriptor instead')
const NearestPointResponse$json = {
  '1': 'NearestPointResponse',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {'1': 'distance', '3': 2, '4': 1, '5': 1, '10': 'distance'},
    {'1': 'point', '3': 3, '4': 1, '5': 11, '6': '.geo.v1.Point2D', '10': 'point'},
  ],
};

/// Descriptor for `NearestPointResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nearestPointResponseDescriptor = $convert.base64Decode(
    'ChROZWFyZXN0UG9pbnRSZXNwb25zZRIUCgVpbmRleBgBIAEoBVIFaW5kZXgSGgoIZGlzdGFuY2'
    'UYAiABKAFSCGRpc3RhbmNlEiUKBXBvaW50GAMgASgLMg8uZ2VvLnYxLlBvaW50MkRSBXBvaW50');

@$core.Deprecated('Use generateContoursRequestDescriptor instead')
const GenerateContoursRequest$json = {
  '1': 'GenerateContoursRequest',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 5, '10': 'height'},
    {'1': 'resolution', '3': 3, '4': 1, '5': 1, '10': 'resolution'},
    {'1': 'origin_x', '3': 4, '4': 1, '5': 1, '10': 'originX'},
    {'1': 'origin_y', '3': 5, '4': 1, '5': 1, '10': 'originY'},
    {'1': 'no_data', '3': 6, '4': 1, '5': 1, '10': 'noData'},
    {'1': 'data', '3': 7, '4': 3, '5': 1, '10': 'data'},
    {'1': 'interval', '3': 8, '4': 1, '5': 1, '10': 'interval'},
  ],
};

/// Descriptor for `GenerateContoursRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateContoursRequestDescriptor = $convert.base64Decode(
    'ChdHZW5lcmF0ZUNvbnRvdXJzUmVxdWVzdBIUCgV3aWR0aBgBIAEoBVIFd2lkdGgSFgoGaGVpZ2'
    'h0GAIgASgFUgZoZWlnaHQSHgoKcmVzb2x1dGlvbhgDIAEoAVIKcmVzb2x1dGlvbhIZCghvcmln'
    'aW5feBgEIAEoAVIHb3JpZ2luWBIZCghvcmlnaW5feRgFIAEoAVIHb3JpZ2luWRIXCgdub19kYX'
    'RhGAYgASgBUgZub0RhdGESEgoEZGF0YRgHIAMoAVIEZGF0YRIaCghpbnRlcnZhbBgIIAEoAVII'
    'aW50ZXJ2YWw=');

@$core.Deprecated('Use contourLineDescriptor instead')
const ContourLine$json = {
  '1': 'ContourLine',
  '2': [
    {'1': 'elevation', '3': 1, '4': 1, '5': 1, '10': 'elevation'},
    {'1': 'points', '3': 2, '4': 3, '5': 11, '6': '.geo.v1.Point2D', '10': 'points'},
  ],
};

/// Descriptor for `ContourLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contourLineDescriptor = $convert.base64Decode(
    'CgtDb250b3VyTGluZRIcCgllbGV2YXRpb24YASABKAFSCWVsZXZhdGlvbhInCgZwb2ludHMYAi'
    'ADKAsyDy5nZW8udjEuUG9pbnQyRFIGcG9pbnRz');

@$core.Deprecated('Use generateContoursResponseDescriptor instead')
const GenerateContoursResponse$json = {
  '1': 'GenerateContoursResponse',
  '2': [
    {'1': 'contours', '3': 1, '4': 3, '5': 11, '6': '.geo.v1.ContourLine', '10': 'contours'},
  ],
};

/// Descriptor for `GenerateContoursResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateContoursResponseDescriptor = $convert.base64Decode(
    'ChhHZW5lcmF0ZUNvbnRvdXJzUmVzcG9uc2USLwoIY29udG91cnMYASADKAsyEy5nZW8udjEuQ2'
    '9udG91ckxpbmVSCGNvbnRvdXJz');

const $core.Map<$core.String, $core.dynamic> GeoServiceBase$json = {
  '1': 'GeoService',
  '2': [
    {'1': 'BufferPoint', '2': '.geo.v1.BufferPointRequest', '3': '.geo.v1.BufferPointResponse'},
    {'1': 'NearestPoint', '2': '.geo.v1.NearestPointRequest', '3': '.geo.v1.NearestPointResponse'},
    {'1': 'GenerateContours', '2': '.geo.v1.GenerateContoursRequest', '3': '.geo.v1.GenerateContoursResponse'},
  ],
};

@$core.Deprecated('Use geoServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> GeoServiceBase$messageJson = {
  '.geo.v1.BufferPointRequest': BufferPointRequest$json,
  '.geo.v1.Point2D': Point2D$json,
  '.geo.v1.BufferPointResponse': BufferPointResponse$json,
  '.geo.v1.Polygon': Polygon$json,
  '.geo.v1.NearestPointRequest': NearestPointRequest$json,
  '.geo.v1.NearestPointResponse': NearestPointResponse$json,
  '.geo.v1.GenerateContoursRequest': GenerateContoursRequest$json,
  '.geo.v1.GenerateContoursResponse': GenerateContoursResponse$json,
  '.geo.v1.ContourLine': ContourLine$json,
};

/// Descriptor for `GeoService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List geoServiceDescriptor = $convert.base64Decode(
    'CgpHZW9TZXJ2aWNlEkYKC0J1ZmZlclBvaW50EhouZ2VvLnYxLkJ1ZmZlclBvaW50UmVxdWVzdB'
    'obLmdlby52MS5CdWZmZXJQb2ludFJlc3BvbnNlEkkKDE5lYXJlc3RQb2ludBIbLmdlby52MS5O'
    'ZWFyZXN0UG9pbnRSZXF1ZXN0GhwuZ2VvLnYxLk5lYXJlc3RQb2ludFJlc3BvbnNlElUKEEdlbm'
    'VyYXRlQ29udG91cnMSHy5nZW8udjEuR2VuZXJhdGVDb250b3Vyc1JlcXVlc3QaIC5nZW8udjEu'
    'R2VuZXJhdGVDb250b3Vyc1Jlc3BvbnNl');

