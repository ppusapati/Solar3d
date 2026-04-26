//
//  Generated code. Do not modify.
//  source: drawing/v1/drawing.proto
//

import "package:connectrpc/connect.dart" as connect;
import "drawing.pb.dart" as drawingv1drawing;
import "drawing.connect.spec.dart" as specs;

/// DrawingRevisionService manages drawing metadata and immutable revision snapshots.
extension type DrawingRevisionServiceClient (connect.Transport _transport) {
  /// CreateDrawing creates a new drawing and its initial empty revision.
  Future<drawingv1drawing.CreateDrawingResponse> createDrawing(
    drawingv1drawing.CreateDrawingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.createDrawing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetDrawing returns drawing metadata without materializing entity state.
  Future<drawingv1drawing.GetDrawingResponse> getDrawing(
    drawingv1drawing.GetDrawingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.getDrawing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListDrawings returns drawings for a project in descending update order.
  Future<drawingv1drawing.ListDrawingsResponse> listDrawings(
    drawingv1drawing.ListDrawingsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.listDrawings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// UpdateDrawing updates mutable drawing metadata and archive status.
  Future<drawingv1drawing.UpdateDrawingResponse> updateDrawing(
    drawingv1drawing.UpdateDrawingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.updateDrawing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetDrawingState returns a materialized snapshot for the requested revision or current head.
  Future<drawingv1drawing.GetDrawingStateResponse> getDrawingState(
    drawingv1drawing.GetDrawingStateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.getDrawingState,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListDrawingRevisions returns revision pointers for a drawing head history.
  Future<drawingv1drawing.ListDrawingRevisionsResponse> listDrawingRevisions(
    drawingv1drawing.ListDrawingRevisionsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.listDrawingRevisions,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetDrawingRevision returns a specific immutable drawing revision snapshot.
  Future<drawingv1drawing.GetDrawingRevisionResponse> getDrawingRevision(
    drawingv1drawing.GetDrawingRevisionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.getDrawingRevision,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// StoreDrawingRevision persists a new immutable snapshot and advances the drawing head.
  Future<drawingv1drawing.StoreDrawingRevisionResponse> storeDrawingRevision(
    drawingv1drawing.StoreDrawingRevisionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DrawingRevisionService.storeDrawingRevision,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// CadCoreService validates and applies drawing commands on top of revision storage.
extension type CadCoreServiceClient (connect.Transport _transport) {
  /// ValidateDrawingCommand validates a command against a drawing revision without persisting it.
  Future<drawingv1drawing.ValidateDrawingCommandResponse> validateDrawingCommand(
    drawingv1drawing.ValidateDrawingCommandRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadCoreService.validateDrawingCommand,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CommitDrawingCommand validates and persists a command as a new drawing revision.
  Future<drawingv1drawing.CommitDrawingCommandResponse> commitDrawingCommand(
    drawingv1drawing.CommitDrawingCommandRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadCoreService.commitDrawingCommand,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RevertDrawingRevision promotes a previous revision snapshot as the new drawing head.
  Future<drawingv1drawing.RevertDrawingRevisionResponse> revertDrawingRevision(
    drawingv1drawing.RevertDrawingRevisionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadCoreService.revertDrawingRevision,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// CadAnnotationService manages associative drafting annotations layered on CadCoreService.
extension type CadAnnotationServiceClient (connect.Transport _transport) {
  /// CreateAnnotation creates a text, dimension, or leader annotation entity on a drawing revision.
  Future<drawingv1drawing.CreateAnnotationResponse> createAnnotation(
    drawingv1drawing.CreateAnnotationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadAnnotationService.createAnnotation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RegenerateAssociativeAnnotations recalculates associative annotations from their referenced source geometry.
  Future<drawingv1drawing.RegenerateAssociativeAnnotationsResponse> regenerateAssociativeAnnotations(
    drawingv1drawing.RegenerateAssociativeAnnotationsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadAnnotationService.regenerateAssociativeAnnotations,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// CadLayerBlockService manages layer standards, block definitions, and block inserts.
extension type CadLayerBlockServiceClient (connect.Transport _transport) {
  /// UpsertLayer creates or updates a managed layer definition entity in the drawing model.
  Future<drawingv1drawing.UpsertLayerResponse> upsertLayer(
    drawingv1drawing.UpsertLayerRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadLayerBlockService.upsertLayer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CreateBlockDefinition stores a reusable block definition with embedded drafting geometry.
  Future<drawingv1drawing.CreateBlockDefinitionResponse> createBlockDefinition(
    drawingv1drawing.CreateBlockDefinitionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadLayerBlockService.createBlockDefinition,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// InsertBlockReference places a block reference instance for an existing block definition.
  Future<drawingv1drawing.InsertBlockReferenceResponse> insertBlockReference(
    drawingv1drawing.InsertBlockReferenceRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CadLayerBlockService.insertBlockReference,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// InteropService imports, exports, and validates round-trips for supported CAD exchange formats.
extension type InteropServiceClient (connect.Transport _transport) {
  /// ExportDrawing serializes a drawing revision into a supported exchange format.
  Future<drawingv1drawing.ExportDrawingResponse> exportDrawing(
    drawingv1drawing.ExportDrawingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InteropService.exportDrawing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ImportDrawing materializes exchange-format payloads into drawing entities and commits them.
  Future<drawingv1drawing.ImportDrawingResponse> importDrawing(
    drawingv1drawing.ImportDrawingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InteropService.importDrawing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ValidateDrawingRoundTrip exports and reimports a drawing revision to measure fidelity.
  Future<drawingv1drawing.ValidateDrawingRoundTripResponse> validateDrawingRoundTrip(
    drawingv1drawing.ValidateDrawingRoundTripRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.InteropService.validateDrawingRoundTrip,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// PlotSheetService manages sheet definitions and publish artifacts.
extension type PlotSheetServiceClient (connect.Transport _transport) {
  /// CreateSheet persists a sheet definition entity for later publishing.
  Future<drawingv1drawing.CreateSheetResponse> createSheet(
    drawingv1drawing.CreateSheetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PlotSheetService.createSheet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// PublishDrawing renders selected sheets as SVG or PDF publish artifacts.
  Future<drawingv1drawing.PublishDrawingResponse> publishDrawing(
    drawingv1drawing.PublishDrawingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PlotSheetService.publishDrawing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
