//
//  Generated code. Do not modify.
//  source: drawing/v1/drawing.proto
//

import "package:connectrpc/connect.dart" as connect;
import "drawing.pb.dart" as drawingv1drawing;

/// DrawingRevisionService manages drawing metadata and immutable revision snapshots.
abstract final class DrawingRevisionService {
  /// Fully-qualified name of the DrawingRevisionService service.
  static const name = 'drawing.v1.DrawingRevisionService';

  /// CreateDrawing creates a new drawing and its initial empty revision.
  static const createDrawing = connect.Spec(
    '/$name/CreateDrawing',
    connect.StreamType.unary,
    drawingv1drawing.CreateDrawingRequest.new,
    drawingv1drawing.CreateDrawingResponse.new,
  );

  /// GetDrawing returns drawing metadata without materializing entity state.
  static const getDrawing = connect.Spec(
    '/$name/GetDrawing',
    connect.StreamType.unary,
    drawingv1drawing.GetDrawingRequest.new,
    drawingv1drawing.GetDrawingResponse.new,
  );

  /// ListDrawings returns drawings for a project in descending update order.
  static const listDrawings = connect.Spec(
    '/$name/ListDrawings',
    connect.StreamType.unary,
    drawingv1drawing.ListDrawingsRequest.new,
    drawingv1drawing.ListDrawingsResponse.new,
  );

  /// UpdateDrawing updates mutable drawing metadata and archive status.
  static const updateDrawing = connect.Spec(
    '/$name/UpdateDrawing',
    connect.StreamType.unary,
    drawingv1drawing.UpdateDrawingRequest.new,
    drawingv1drawing.UpdateDrawingResponse.new,
  );

  /// GetDrawingState returns a materialized snapshot for the requested revision or current head.
  static const getDrawingState = connect.Spec(
    '/$name/GetDrawingState',
    connect.StreamType.unary,
    drawingv1drawing.GetDrawingStateRequest.new,
    drawingv1drawing.GetDrawingStateResponse.new,
  );

  /// ListDrawingRevisions returns revision pointers for a drawing head history.
  static const listDrawingRevisions = connect.Spec(
    '/$name/ListDrawingRevisions',
    connect.StreamType.unary,
    drawingv1drawing.ListDrawingRevisionsRequest.new,
    drawingv1drawing.ListDrawingRevisionsResponse.new,
  );

  /// GetDrawingRevision returns a specific immutable drawing revision snapshot.
  static const getDrawingRevision = connect.Spec(
    '/$name/GetDrawingRevision',
    connect.StreamType.unary,
    drawingv1drawing.GetDrawingRevisionRequest.new,
    drawingv1drawing.GetDrawingRevisionResponse.new,
  );

  /// StoreDrawingRevision persists a new immutable snapshot and advances the drawing head.
  static const storeDrawingRevision = connect.Spec(
    '/$name/StoreDrawingRevision',
    connect.StreamType.unary,
    drawingv1drawing.StoreDrawingRevisionRequest.new,
    drawingv1drawing.StoreDrawingRevisionResponse.new,
  );
}
/// CadCoreService validates and applies drawing commands on top of revision storage.
abstract final class CadCoreService {
  /// Fully-qualified name of the CadCoreService service.
  static const name = 'drawing.v1.CadCoreService';

  /// ValidateDrawingCommand validates a command against a drawing revision without persisting it.
  static const validateDrawingCommand = connect.Spec(
    '/$name/ValidateDrawingCommand',
    connect.StreamType.unary,
    drawingv1drawing.ValidateDrawingCommandRequest.new,
    drawingv1drawing.ValidateDrawingCommandResponse.new,
  );

  /// CommitDrawingCommand validates and persists a command as a new drawing revision.
  static const commitDrawingCommand = connect.Spec(
    '/$name/CommitDrawingCommand',
    connect.StreamType.unary,
    drawingv1drawing.CommitDrawingCommandRequest.new,
    drawingv1drawing.CommitDrawingCommandResponse.new,
  );

  /// RevertDrawingRevision promotes a previous revision snapshot as the new drawing head.
  static const revertDrawingRevision = connect.Spec(
    '/$name/RevertDrawingRevision',
    connect.StreamType.unary,
    drawingv1drawing.RevertDrawingRevisionRequest.new,
    drawingv1drawing.RevertDrawingRevisionResponse.new,
  );
}
/// CadAnnotationService manages associative drafting annotations layered on CadCoreService.
abstract final class CadAnnotationService {
  /// Fully-qualified name of the CadAnnotationService service.
  static const name = 'drawing.v1.CadAnnotationService';

  /// CreateAnnotation creates a text, dimension, or leader annotation entity on a drawing revision.
  static const createAnnotation = connect.Spec(
    '/$name/CreateAnnotation',
    connect.StreamType.unary,
    drawingv1drawing.CreateAnnotationRequest.new,
    drawingv1drawing.CreateAnnotationResponse.new,
  );

  /// RegenerateAssociativeAnnotations recalculates associative annotations from their referenced source geometry.
  static const regenerateAssociativeAnnotations = connect.Spec(
    '/$name/RegenerateAssociativeAnnotations',
    connect.StreamType.unary,
    drawingv1drawing.RegenerateAssociativeAnnotationsRequest.new,
    drawingv1drawing.RegenerateAssociativeAnnotationsResponse.new,
  );
}
/// CadLayerBlockService manages layer standards, block definitions, and block inserts.
abstract final class CadLayerBlockService {
  /// Fully-qualified name of the CadLayerBlockService service.
  static const name = 'drawing.v1.CadLayerBlockService';

  /// UpsertLayer creates or updates a managed layer definition entity in the drawing model.
  static const upsertLayer = connect.Spec(
    '/$name/UpsertLayer',
    connect.StreamType.unary,
    drawingv1drawing.UpsertLayerRequest.new,
    drawingv1drawing.UpsertLayerResponse.new,
  );

  /// CreateBlockDefinition stores a reusable block definition with embedded drafting geometry.
  static const createBlockDefinition = connect.Spec(
    '/$name/CreateBlockDefinition',
    connect.StreamType.unary,
    drawingv1drawing.CreateBlockDefinitionRequest.new,
    drawingv1drawing.CreateBlockDefinitionResponse.new,
  );

  /// InsertBlockReference places a block reference instance for an existing block definition.
  static const insertBlockReference = connect.Spec(
    '/$name/InsertBlockReference',
    connect.StreamType.unary,
    drawingv1drawing.InsertBlockReferenceRequest.new,
    drawingv1drawing.InsertBlockReferenceResponse.new,
  );
}
/// InteropService imports, exports, and validates round-trips for supported CAD exchange formats.
abstract final class InteropService {
  /// Fully-qualified name of the InteropService service.
  static const name = 'drawing.v1.InteropService';

  /// ExportDrawing serializes a drawing revision into a supported exchange format.
  static const exportDrawing = connect.Spec(
    '/$name/ExportDrawing',
    connect.StreamType.unary,
    drawingv1drawing.ExportDrawingRequest.new,
    drawingv1drawing.ExportDrawingResponse.new,
  );

  /// ImportDrawing materializes exchange-format payloads into drawing entities and commits them.
  static const importDrawing = connect.Spec(
    '/$name/ImportDrawing',
    connect.StreamType.unary,
    drawingv1drawing.ImportDrawingRequest.new,
    drawingv1drawing.ImportDrawingResponse.new,
  );

  /// ValidateDrawingRoundTrip exports and reimports a drawing revision to measure fidelity.
  static const validateDrawingRoundTrip = connect.Spec(
    '/$name/ValidateDrawingRoundTrip',
    connect.StreamType.unary,
    drawingv1drawing.ValidateDrawingRoundTripRequest.new,
    drawingv1drawing.ValidateDrawingRoundTripResponse.new,
  );
}
/// PlotSheetService manages sheet definitions and publish artifacts.
abstract final class PlotSheetService {
  /// Fully-qualified name of the PlotSheetService service.
  static const name = 'drawing.v1.PlotSheetService';

  /// CreateSheet persists a sheet definition entity for later publishing.
  static const createSheet = connect.Spec(
    '/$name/CreateSheet',
    connect.StreamType.unary,
    drawingv1drawing.CreateSheetRequest.new,
    drawingv1drawing.CreateSheetResponse.new,
  );

  /// PublishDrawing renders selected sheets as SVG or PDF publish artifacts.
  static const publishDrawing = connect.Spec(
    '/$name/PublishDrawing',
    connect.StreamType.unary,
    drawingv1drawing.PublishDrawingRequest.new,
    drawingv1drawing.PublishDrawingResponse.new,
  );
}
