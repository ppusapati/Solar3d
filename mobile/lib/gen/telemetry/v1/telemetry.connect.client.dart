//
//  Generated code. Do not modify.
//  source: telemetry/v1/telemetry.proto
//

import "package:connectrpc/connect.dart" as connect;
import "telemetry.pb.dart" as telemetryv1telemetry;
import "telemetry.connect.spec.dart" as specs;

/// TelemetryService manages ingestion and retrieval of time-series sensor readings
/// from provisioned digital twins.  Storage backend uses PostgreSQL with a
/// TimescaleDB hypertable partitioned on recorded_at (Option A per Pre-Implementation
/// Locked Decisions).  Ingest batches are atomic: all readings succeed or none persist.
extension type TelemetryServiceClient (connect.Transport _transport) {
  /// IngestReadings stores a batch of sensor readings for a twin in a single
  /// atomic transaction.  Returns the count of accepted readings.
  /// Returns NOT_FOUND if the twin_id does not correspond to an ACTIVE twin.
  Future<telemetryv1telemetry.IngestReadingsResponse> ingestReadings(
    telemetryv1telemetry.IngestReadingsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TelemetryService.ingestReadings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetLatestReadings returns the single most recent reading per metric for a twin.
  /// Useful for dashboard snapshots; does not paginate.
  Future<telemetryv1telemetry.GetLatestReadingsResponse> getLatestReadings(
    telemetryv1telemetry.GetLatestReadingsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TelemetryService.getLatestReadings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListReadings returns readings for a twin within a time window, optionally
  /// filtered by metric. Results are ordered by recorded_at ascending.
  /// Maximum 1000 readings per call; use page_token for continuation.
  Future<telemetryv1telemetry.ListReadingsResponse> listReadings(
    telemetryv1telemetry.ListReadingsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TelemetryService.listReadings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetAggregatedMetrics returns min/max/avg/sum aggregates over a time window
  /// for a specified metric and twin.  Window is inclusive on both ends.
  Future<telemetryv1telemetry.GetAggregatedMetricsResponse> getAggregatedMetrics(
    telemetryv1telemetry.GetAggregatedMetricsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TelemetryService.getAggregatedMetrics,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
