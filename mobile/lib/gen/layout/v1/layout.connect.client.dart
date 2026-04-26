//
//  Generated code. Do not modify.
//  source: layout/v1/layout.proto
//

import "package:connectrpc/connect.dart" as connect;
import "layout.pb.dart" as layoutv1layout;
import "layout.connect.spec.dart" as specs;

/// LayoutService manages solar farm layout entities including panel arrays,
/// components (inverters, transformers, trackers), tile-based spatial queries,
/// and the acceptance workflow gate required for ElectricalReady phase progression.
extension type LayoutServiceClient (connect.Transport _transport) {
  /// CreateLayout creates a new empty layout for a project.
  Future<layoutv1layout.CreateLayoutResponse> createLayout(
    layoutv1layout.CreateLayoutRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.createLayout,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetLayout retrieves a layout by ID including its current review metadata.
  Future<layoutv1layout.GetLayoutResponse> getLayout(
    layoutv1layout.GetLayoutRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.getLayout,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListLayouts returns all layouts for a project ordered by creation time.
  Future<layoutv1layout.ListLayoutsResponse> listLayouts(
    layoutv1layout.ListLayoutsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.listLayouts,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteLayout permanently removes a layout and all its components and tiles.
  Future<layoutv1layout.DeleteLayoutResponse> deleteLayout(
    layoutv1layout.DeleteLayoutRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.deleteLayout,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Component placement
  Future<layoutv1layout.PlaceComponentResponse> placeComponent(
    layoutv1layout.PlaceComponentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.placeComponent,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// MoveComponent updates the position of an existing placed component.
  Future<layoutv1layout.MoveComponentResponse> moveComponent(
    layoutv1layout.MoveComponentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.moveComponent,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RemoveComponent removes a placed component from the layout.
  Future<layoutv1layout.RemoveComponentResponse> removeComponent(
    layoutv1layout.RemoveComponentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.removeComponent,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListComponents returns all placed components for a layout.
  Future<layoutv1layout.ListComponentsResponse> listComponents(
    layoutv1layout.ListComponentsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.listComponents,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Panel array generation
  Future<layoutv1layout.GeneratePanelArrayResponse> generatePanelArray(
    layoutv1layout.GeneratePanelArrayRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.generatePanelArray,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Tile-based queries
  Future<layoutv1layout.GetTilesResponse> getTiles(
    layoutv1layout.GetTilesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.getTiles,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetTilePanels returns individual panel geometries within a specific tile for viewport rendering.
  Future<layoutv1layout.GetTilePanelsResponse> getTilePanels(
    layoutv1layout.GetTilePanelsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.getTilePanels,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Acceptance workflow — gates the LayoutReady -> ElectricalReady phase transition.
  /// SubmitLayoutForReview transitions review_metadata.status to REVIEW_PENDING.
  Future<layoutv1layout.SubmitLayoutForReviewResponse> submitLayoutForReview(
    layoutv1layout.SubmitLayoutForReviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.submitLayoutForReview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApproveLayout sets review_metadata.status to APPROVED, enabling ElectricalReady transition.
  Future<layoutv1layout.ApproveLayoutResponse> approveLayout(
    layoutv1layout.ApproveLayoutRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.approveLayout,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RejectLayout sets review_metadata.status to REJECTED and records blockers preventing approval.
  Future<layoutv1layout.RejectLayoutResponse> rejectLayout(
    layoutv1layout.RejectLayoutRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LayoutService.rejectLayout,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
