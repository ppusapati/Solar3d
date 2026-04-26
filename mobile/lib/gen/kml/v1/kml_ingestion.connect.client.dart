//
//  Generated code. Do not modify.
//  source: kml/v1/kml_ingestion.proto
//

import "package:connectrpc/connect.dart" as connect;
import "kml_ingestion.pb.dart" as kmlv1kml_ingestion;
import "kml_ingestion.connect.spec.dart" as specs;

/// KMLIngestionService exposes KML/KMZ upload, parsing, and geometry import workflows.
extension type KMLIngestionServiceClient (connect.Transport _transport) {
  /// UploadKML initiates async KML/KMZ file processing.
  Future<kmlv1kml_ingestion.UploadKMLResponse> uploadKML(
    kmlv1kml_ingestion.UploadKMLRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.KMLIngestionService.uploadKML,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetUploadStatus retrieves the status of a KML upload job.
  Future<kmlv1kml_ingestion.GetUploadStatusResponse> getUploadStatus(
    kmlv1kml_ingestion.GetUploadStatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.KMLIngestionService.getUploadStatus,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListImportedGeometries retrieves geometries from a completed upload.
  Future<kmlv1kml_ingestion.ListImportedGeometriesResponse> listImportedGeometries(
    kmlv1kml_ingestion.ListImportedGeometriesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.KMLIngestionService.listImportedGeometries,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetImportedGeometry retrieves a single imported geometry with full details.
  Future<kmlv1kml_ingestion.GetImportedGeometryResponse> getImportedGeometry(
    kmlv1kml_ingestion.GetImportedGeometryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.KMLIngestionService.getImportedGeometry,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteUpload removes an upload job and associated geometries.
  Future<kmlv1kml_ingestion.DeleteUploadResponse> deleteUpload(
    kmlv1kml_ingestion.DeleteUploadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.KMLIngestionService.deleteUpload,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
