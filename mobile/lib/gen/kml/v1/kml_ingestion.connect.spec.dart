//
//  Generated code. Do not modify.
//  source: kml/v1/kml_ingestion.proto
//

import "package:connectrpc/connect.dart" as connect;
import "kml_ingestion.pb.dart" as kmlv1kml_ingestion;

/// KMLIngestionService exposes KML/KMZ upload, parsing, and geometry import workflows.
abstract final class KMLIngestionService {
  /// Fully-qualified name of the KMLIngestionService service.
  static const name = 'kml.v1.KMLIngestionService';

  /// UploadKML initiates async KML/KMZ file processing.
  static const uploadKML = connect.Spec(
    '/$name/UploadKML',
    connect.StreamType.unary,
    kmlv1kml_ingestion.UploadKMLRequest.new,
    kmlv1kml_ingestion.UploadKMLResponse.new,
  );

  /// GetUploadStatus retrieves the status of a KML upload job.
  static const getUploadStatus = connect.Spec(
    '/$name/GetUploadStatus',
    connect.StreamType.unary,
    kmlv1kml_ingestion.GetUploadStatusRequest.new,
    kmlv1kml_ingestion.GetUploadStatusResponse.new,
  );

  /// ListImportedGeometries retrieves geometries from a completed upload.
  static const listImportedGeometries = connect.Spec(
    '/$name/ListImportedGeometries',
    connect.StreamType.unary,
    kmlv1kml_ingestion.ListImportedGeometriesRequest.new,
    kmlv1kml_ingestion.ListImportedGeometriesResponse.new,
  );

  /// GetImportedGeometry retrieves a single imported geometry with full details.
  static const getImportedGeometry = connect.Spec(
    '/$name/GetImportedGeometry',
    connect.StreamType.unary,
    kmlv1kml_ingestion.GetImportedGeometryRequest.new,
    kmlv1kml_ingestion.GetImportedGeometryResponse.new,
  );

  /// DeleteUpload removes an upload job and associated geometries.
  static const deleteUpload = connect.Spec(
    '/$name/DeleteUpload',
    connect.StreamType.unary,
    kmlv1kml_ingestion.DeleteUploadRequest.new,
    kmlv1kml_ingestion.DeleteUploadResponse.new,
  );
}
