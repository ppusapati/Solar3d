//
//  Generated code. Do not modify.
//  source: drawing/v1/drawing.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'drawing.pb.dart' as $2;
import 'drawing.pbjson.dart';

export 'drawing.pb.dart';

abstract class DrawingRevisionServiceBase extends $pb.GeneratedService {
  $async.Future<$2.CreateDrawingResponse> createDrawing($pb.ServerContext ctx, $2.CreateDrawingRequest request);
  $async.Future<$2.GetDrawingResponse> getDrawing($pb.ServerContext ctx, $2.GetDrawingRequest request);
  $async.Future<$2.ListDrawingsResponse> listDrawings($pb.ServerContext ctx, $2.ListDrawingsRequest request);
  $async.Future<$2.UpdateDrawingResponse> updateDrawing($pb.ServerContext ctx, $2.UpdateDrawingRequest request);
  $async.Future<$2.GetDrawingStateResponse> getDrawingState($pb.ServerContext ctx, $2.GetDrawingStateRequest request);
  $async.Future<$2.ListDrawingRevisionsResponse> listDrawingRevisions($pb.ServerContext ctx, $2.ListDrawingRevisionsRequest request);
  $async.Future<$2.GetDrawingRevisionResponse> getDrawingRevision($pb.ServerContext ctx, $2.GetDrawingRevisionRequest request);
  $async.Future<$2.StoreDrawingRevisionResponse> storeDrawingRevision($pb.ServerContext ctx, $2.StoreDrawingRevisionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateDrawing': return $2.CreateDrawingRequest();
      case 'GetDrawing': return $2.GetDrawingRequest();
      case 'ListDrawings': return $2.ListDrawingsRequest();
      case 'UpdateDrawing': return $2.UpdateDrawingRequest();
      case 'GetDrawingState': return $2.GetDrawingStateRequest();
      case 'ListDrawingRevisions': return $2.ListDrawingRevisionsRequest();
      case 'GetDrawingRevision': return $2.GetDrawingRevisionRequest();
      case 'StoreDrawingRevision': return $2.StoreDrawingRevisionRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateDrawing': return this.createDrawing(ctx, request as $2.CreateDrawingRequest);
      case 'GetDrawing': return this.getDrawing(ctx, request as $2.GetDrawingRequest);
      case 'ListDrawings': return this.listDrawings(ctx, request as $2.ListDrawingsRequest);
      case 'UpdateDrawing': return this.updateDrawing(ctx, request as $2.UpdateDrawingRequest);
      case 'GetDrawingState': return this.getDrawingState(ctx, request as $2.GetDrawingStateRequest);
      case 'ListDrawingRevisions': return this.listDrawingRevisions(ctx, request as $2.ListDrawingRevisionsRequest);
      case 'GetDrawingRevision': return this.getDrawingRevision(ctx, request as $2.GetDrawingRevisionRequest);
      case 'StoreDrawingRevision': return this.storeDrawingRevision(ctx, request as $2.StoreDrawingRevisionRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => DrawingRevisionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => DrawingRevisionServiceBase$messageJson;
}

abstract class CadCoreServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ValidateDrawingCommandResponse> validateDrawingCommand($pb.ServerContext ctx, $2.ValidateDrawingCommandRequest request);
  $async.Future<$2.CommitDrawingCommandResponse> commitDrawingCommand($pb.ServerContext ctx, $2.CommitDrawingCommandRequest request);
  $async.Future<$2.RevertDrawingRevisionResponse> revertDrawingRevision($pb.ServerContext ctx, $2.RevertDrawingRevisionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ValidateDrawingCommand': return $2.ValidateDrawingCommandRequest();
      case 'CommitDrawingCommand': return $2.CommitDrawingCommandRequest();
      case 'RevertDrawingRevision': return $2.RevertDrawingRevisionRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ValidateDrawingCommand': return this.validateDrawingCommand(ctx, request as $2.ValidateDrawingCommandRequest);
      case 'CommitDrawingCommand': return this.commitDrawingCommand(ctx, request as $2.CommitDrawingCommandRequest);
      case 'RevertDrawingRevision': return this.revertDrawingRevision(ctx, request as $2.RevertDrawingRevisionRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => CadCoreServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => CadCoreServiceBase$messageJson;
}

abstract class CadAnnotationServiceBase extends $pb.GeneratedService {
  $async.Future<$2.CreateAnnotationResponse> createAnnotation($pb.ServerContext ctx, $2.CreateAnnotationRequest request);
  $async.Future<$2.RegenerateAssociativeAnnotationsResponse> regenerateAssociativeAnnotations($pb.ServerContext ctx, $2.RegenerateAssociativeAnnotationsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateAnnotation': return $2.CreateAnnotationRequest();
      case 'RegenerateAssociativeAnnotations': return $2.RegenerateAssociativeAnnotationsRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateAnnotation': return this.createAnnotation(ctx, request as $2.CreateAnnotationRequest);
      case 'RegenerateAssociativeAnnotations': return this.regenerateAssociativeAnnotations(ctx, request as $2.RegenerateAssociativeAnnotationsRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => CadAnnotationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => CadAnnotationServiceBase$messageJson;
}

abstract class CadLayerBlockServiceBase extends $pb.GeneratedService {
  $async.Future<$2.UpsertLayerResponse> upsertLayer($pb.ServerContext ctx, $2.UpsertLayerRequest request);
  $async.Future<$2.CreateBlockDefinitionResponse> createBlockDefinition($pb.ServerContext ctx, $2.CreateBlockDefinitionRequest request);
  $async.Future<$2.InsertBlockReferenceResponse> insertBlockReference($pb.ServerContext ctx, $2.InsertBlockReferenceRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'UpsertLayer': return $2.UpsertLayerRequest();
      case 'CreateBlockDefinition': return $2.CreateBlockDefinitionRequest();
      case 'InsertBlockReference': return $2.InsertBlockReferenceRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'UpsertLayer': return this.upsertLayer(ctx, request as $2.UpsertLayerRequest);
      case 'CreateBlockDefinition': return this.createBlockDefinition(ctx, request as $2.CreateBlockDefinitionRequest);
      case 'InsertBlockReference': return this.insertBlockReference(ctx, request as $2.InsertBlockReferenceRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => CadLayerBlockServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => CadLayerBlockServiceBase$messageJson;
}

abstract class InteropServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ExportDrawingResponse> exportDrawing($pb.ServerContext ctx, $2.ExportDrawingRequest request);
  $async.Future<$2.ImportDrawingResponse> importDrawing($pb.ServerContext ctx, $2.ImportDrawingRequest request);
  $async.Future<$2.ValidateDrawingRoundTripResponse> validateDrawingRoundTrip($pb.ServerContext ctx, $2.ValidateDrawingRoundTripRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ExportDrawing': return $2.ExportDrawingRequest();
      case 'ImportDrawing': return $2.ImportDrawingRequest();
      case 'ValidateDrawingRoundTrip': return $2.ValidateDrawingRoundTripRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ExportDrawing': return this.exportDrawing(ctx, request as $2.ExportDrawingRequest);
      case 'ImportDrawing': return this.importDrawing(ctx, request as $2.ImportDrawingRequest);
      case 'ValidateDrawingRoundTrip': return this.validateDrawingRoundTrip(ctx, request as $2.ValidateDrawingRoundTripRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => InteropServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => InteropServiceBase$messageJson;
}

abstract class PlotSheetServiceBase extends $pb.GeneratedService {
  $async.Future<$2.CreateSheetResponse> createSheet($pb.ServerContext ctx, $2.CreateSheetRequest request);
  $async.Future<$2.PublishDrawingResponse> publishDrawing($pb.ServerContext ctx, $2.PublishDrawingRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateSheet': return $2.CreateSheetRequest();
      case 'PublishDrawing': return $2.PublishDrawingRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateSheet': return this.createSheet(ctx, request as $2.CreateSheetRequest);
      case 'PublishDrawing': return this.publishDrawing(ctx, request as $2.PublishDrawingRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PlotSheetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => PlotSheetServiceBase$messageJson;
}

