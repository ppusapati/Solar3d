//
//  Generated code. Do not modify.
//  source: layout/v1/layout.proto
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

import 'layout.pb.dart' as $1;
import 'layout.pbjson.dart';

export 'layout.pb.dart';

abstract class LayoutServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreateLayoutResponse> createLayout($pb.ServerContext ctx, $1.CreateLayoutRequest request);
  $async.Future<$1.GetLayoutResponse> getLayout($pb.ServerContext ctx, $1.GetLayoutRequest request);
  $async.Future<$1.ListLayoutsResponse> listLayouts($pb.ServerContext ctx, $1.ListLayoutsRequest request);
  $async.Future<$1.DeleteLayoutResponse> deleteLayout($pb.ServerContext ctx, $1.DeleteLayoutRequest request);
  $async.Future<$1.PlaceComponentResponse> placeComponent($pb.ServerContext ctx, $1.PlaceComponentRequest request);
  $async.Future<$1.MoveComponentResponse> moveComponent($pb.ServerContext ctx, $1.MoveComponentRequest request);
  $async.Future<$1.RemoveComponentResponse> removeComponent($pb.ServerContext ctx, $1.RemoveComponentRequest request);
  $async.Future<$1.ListComponentsResponse> listComponents($pb.ServerContext ctx, $1.ListComponentsRequest request);
  $async.Future<$1.GeneratePanelArrayResponse> generatePanelArray($pb.ServerContext ctx, $1.GeneratePanelArrayRequest request);
  $async.Future<$1.GetTilesResponse> getTiles($pb.ServerContext ctx, $1.GetTilesRequest request);
  $async.Future<$1.GetTilePanelsResponse> getTilePanels($pb.ServerContext ctx, $1.GetTilePanelsRequest request);
  $async.Future<$1.SubmitLayoutForReviewResponse> submitLayoutForReview($pb.ServerContext ctx, $1.SubmitLayoutForReviewRequest request);
  $async.Future<$1.ApproveLayoutResponse> approveLayout($pb.ServerContext ctx, $1.ApproveLayoutRequest request);
  $async.Future<$1.RejectLayoutResponse> rejectLayout($pb.ServerContext ctx, $1.RejectLayoutRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateLayout': return $1.CreateLayoutRequest();
      case 'GetLayout': return $1.GetLayoutRequest();
      case 'ListLayouts': return $1.ListLayoutsRequest();
      case 'DeleteLayout': return $1.DeleteLayoutRequest();
      case 'PlaceComponent': return $1.PlaceComponentRequest();
      case 'MoveComponent': return $1.MoveComponentRequest();
      case 'RemoveComponent': return $1.RemoveComponentRequest();
      case 'ListComponents': return $1.ListComponentsRequest();
      case 'GeneratePanelArray': return $1.GeneratePanelArrayRequest();
      case 'GetTiles': return $1.GetTilesRequest();
      case 'GetTilePanels': return $1.GetTilePanelsRequest();
      case 'SubmitLayoutForReview': return $1.SubmitLayoutForReviewRequest();
      case 'ApproveLayout': return $1.ApproveLayoutRequest();
      case 'RejectLayout': return $1.RejectLayoutRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateLayout': return this.createLayout(ctx, request as $1.CreateLayoutRequest);
      case 'GetLayout': return this.getLayout(ctx, request as $1.GetLayoutRequest);
      case 'ListLayouts': return this.listLayouts(ctx, request as $1.ListLayoutsRequest);
      case 'DeleteLayout': return this.deleteLayout(ctx, request as $1.DeleteLayoutRequest);
      case 'PlaceComponent': return this.placeComponent(ctx, request as $1.PlaceComponentRequest);
      case 'MoveComponent': return this.moveComponent(ctx, request as $1.MoveComponentRequest);
      case 'RemoveComponent': return this.removeComponent(ctx, request as $1.RemoveComponentRequest);
      case 'ListComponents': return this.listComponents(ctx, request as $1.ListComponentsRequest);
      case 'GeneratePanelArray': return this.generatePanelArray(ctx, request as $1.GeneratePanelArrayRequest);
      case 'GetTiles': return this.getTiles(ctx, request as $1.GetTilesRequest);
      case 'GetTilePanels': return this.getTilePanels(ctx, request as $1.GetTilePanelsRequest);
      case 'SubmitLayoutForReview': return this.submitLayoutForReview(ctx, request as $1.SubmitLayoutForReviewRequest);
      case 'ApproveLayout': return this.approveLayout(ctx, request as $1.ApproveLayoutRequest);
      case 'RejectLayout': return this.rejectLayout(ctx, request as $1.RejectLayoutRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LayoutServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => LayoutServiceBase$messageJson;
}

