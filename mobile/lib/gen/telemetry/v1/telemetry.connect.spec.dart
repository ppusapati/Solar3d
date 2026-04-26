//
//  Generated code. Do not modify.
//  source: telemetry/v1/telemetry.proto
//

import "package:connectrpc/connect.dart" as connect;
import "telemetry.pb.dart" as telemetryv1telemetry;

/// TelemetryService manages ingestion and retrieval of time-series sensor readings
/// from provisioned digital twins.  Storage backend uses PostgreSQL with a
/// TimescaleDB hypertable partitioned on recorded_at (Option A per Pre-Implementation
/// Locked Decisions).  Ingest batches are atomic: all readings succeed or none persist.
abstract final class TelemetryService {
  /// Fully-qualified name of the TelemetryService service.
  static const name = 'telemetry.v1.TelemetryService';

  /// IngestReadings stores a batch of sensor readings for a twin in a single
  /// atomic transaction.  Returns the count of accepted readings.
  /// Returns NOT_FOUND if the twin_id does not correspond to an ACTIVE twin.
  static const ingestReadings = connect.Spec(
    '/$name/IngestReadings',
    connect.StreamType.unary,
    telemetryv1telemetry.IngestReadingsRequest.new,
    telemetryv1telemetry.IngestReadingsResponse.new,
  );

  /// GetLatestReadings returns the single most recent reading per metric for a twin.
  /// Useful for dashboard snapshots; does not paginate.
  static const getLatestReadings = connect.Spec(
    '/$name/GetLatestReadings',
    connect.StreamType.unary,
    telemetryv1telemetry.GetLatestReadingsRequest.new,
    telemetryv1telemetry.GetLatestReadingsResponse.new,
  );

  /// ListReadings returns readings for a twin within a time window, optionally
  /// filtered by metric. Results are ordered by recorded_at ascending.
  /// Maximum 1000 readings per call; use page_token for continuation.
  static const listReadings = connect.Spec(
    '/$name/ListReadings',
    connect.StreamType.unary,
    telemetryv1telemetry.ListReadingsRequest.new,
    telemetryv1telemetry.ListReadingsResponse.new,
  );

  /// GetAggregatedMetrics returns min/max/avg/sum aggregates over a time window
  /// for a specified metric and twin.  Window is inclusive on both ends.
  static const getAggregatedMetrics = connect.Spec(
    '/$name/GetAggregatedMetrics',
    connect.StreamType.unary,
    telemetryv1telemetry.GetAggregatedMetricsRequest.new,
    telemetryv1telemetry.GetAggregatedMetricsResponse.new,
  );
}
