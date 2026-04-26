//
//  Generated code. Do not modify.
//  source: geo/v1/geo.proto
//

import "package:connectrpc/connect.dart" as connect;
import "geo.pb.dart" as geov1geo;
import "geo.connect.spec.dart" as specs;

/// GeoService exposes geometry and raster algorithms built on geo-compute.
extension type GeoServiceClient (connect.Transport _transport) {
  /// BufferPoint generates a polygonal buffer around a point.
  Future<geov1geo.BufferPointResponse> bufferPoint(
    geov1geo.BufferPointRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.GeoService.bufferPoint,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// NearestPoint returns the closest candidate point to the query point.
  Future<geov1geo.NearestPointResponse> nearestPoint(
    geov1geo.NearestPointRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.GeoService.nearestPoint,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GenerateContours derives contour lines from an input raster grid.
  Future<geov1geo.GenerateContoursResponse> generateContours(
    geov1geo.GenerateContoursRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.GeoService.generateContours,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
