//
//  Generated code. Do not modify.
//  source: solar/v1/solar.proto
//

import "package:connectrpc/connect.dart" as connect;
import "solar.pb.dart" as solarv1solar;
import "solar.connect.spec.dart" as specs;

/// SolarService exposes solar position, irradiance, and shadow algorithms.
extension type SolarServiceClient (connect.Transport _transport) {
  /// CalculateSolarPosition computes elevation and azimuth angles.
  Future<solarv1solar.SolarPositionResponse> calculateSolarPosition(
    solarv1solar.SolarPositionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SolarService.calculateSolarPosition,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CastShadows projects shadows from obstacles given sun position.
  Future<solarv1solar.CastShadowsResponse> castShadows(
    solarv1solar.CastShadowsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SolarService.castShadows,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CalculateDNI computes direct normal irradiance.
  Future<solarv1solar.DNIResponse> calculateDNI(
    solarv1solar.DNIRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SolarService.calculateDNI,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CalculateDHI computes diffuse horizontal irradiance.
  Future<solarv1solar.DHIResponse> calculateDHI(
    solarv1solar.DHIRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SolarService.calculateDHI,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// BulkSolarPosition computes positions for multiple timestamps (optimized).
  Future<solarv1solar.BulkSolarPositionResponse> bulkSolarPosition(
    solarv1solar.BulkSolarPositionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SolarService.bulkSolarPosition,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
