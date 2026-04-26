//
//  Generated code. Do not modify.
//  source: solar/v1/solar.proto
//

import "package:connectrpc/connect.dart" as connect;
import "solar.pb.dart" as solarv1solar;

/// SolarService exposes solar position, irradiance, and shadow algorithms.
abstract final class SolarService {
  /// Fully-qualified name of the SolarService service.
  static const name = 'solar.v1.SolarService';

  /// CalculateSolarPosition computes elevation and azimuth angles.
  static const calculateSolarPosition = connect.Spec(
    '/$name/CalculateSolarPosition',
    connect.StreamType.unary,
    solarv1solar.SolarPositionRequest.new,
    solarv1solar.SolarPositionResponse.new,
  );

  /// CastShadows projects shadows from obstacles given sun position.
  static const castShadows = connect.Spec(
    '/$name/CastShadows',
    connect.StreamType.unary,
    solarv1solar.CastShadowsRequest.new,
    solarv1solar.CastShadowsResponse.new,
  );

  /// CalculateDNI computes direct normal irradiance.
  static const calculateDNI = connect.Spec(
    '/$name/CalculateDNI',
    connect.StreamType.unary,
    solarv1solar.DNIRequest.new,
    solarv1solar.DNIResponse.new,
  );

  /// CalculateDHI computes diffuse horizontal irradiance.
  static const calculateDHI = connect.Spec(
    '/$name/CalculateDHI',
    connect.StreamType.unary,
    solarv1solar.DHIRequest.new,
    solarv1solar.DHIResponse.new,
  );

  /// BulkSolarPosition computes positions for multiple timestamps (optimized).
  static const bulkSolarPosition = connect.Spec(
    '/$name/BulkSolarPosition',
    connect.StreamType.unary,
    solarv1solar.BulkSolarPositionRequest.new,
    solarv1solar.BulkSolarPositionResponse.new,
  );
}
