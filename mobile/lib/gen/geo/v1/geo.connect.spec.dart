//
//  Generated code. Do not modify.
//  source: geo/v1/geo.proto
//

import "package:connectrpc/connect.dart" as connect;
import "geo.pb.dart" as geov1geo;

/// GeoService exposes geometry and raster algorithms built on geo-compute.
abstract final class GeoService {
  /// Fully-qualified name of the GeoService service.
  static const name = 'geo.v1.GeoService';

  /// BufferPoint generates a polygonal buffer around a point.
  static const bufferPoint = connect.Spec(
    '/$name/BufferPoint',
    connect.StreamType.unary,
    geov1geo.BufferPointRequest.new,
    geov1geo.BufferPointResponse.new,
  );

  /// NearestPoint returns the closest candidate point to the query point.
  static const nearestPoint = connect.Spec(
    '/$name/NearestPoint',
    connect.StreamType.unary,
    geov1geo.NearestPointRequest.new,
    geov1geo.NearestPointResponse.new,
  );

  /// GenerateContours derives contour lines from an input raster grid.
  static const generateContours = connect.Spec(
    '/$name/GenerateContours',
    connect.StreamType.unary,
    geov1geo.GenerateContoursRequest.new,
    geov1geo.GenerateContoursResponse.new,
  );
}
