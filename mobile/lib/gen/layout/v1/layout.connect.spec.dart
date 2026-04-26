//
//  Generated code. Do not modify.
//  source: layout/v1/layout.proto
//

import "package:connectrpc/connect.dart" as connect;
import "layout.pb.dart" as layoutv1layout;

/// LayoutService manages solar farm layout entities including panel arrays,
/// components (inverters, transformers, trackers), tile-based spatial queries,
/// and the acceptance workflow gate required for ElectricalReady phase progression.
abstract final class LayoutService {
  /// Fully-qualified name of the LayoutService service.
  static const name = 'layout.v1.LayoutService';

  /// CreateLayout creates a new empty layout for a project.
  static const createLayout = connect.Spec(
    '/$name/CreateLayout',
    connect.StreamType.unary,
    layoutv1layout.CreateLayoutRequest.new,
    layoutv1layout.CreateLayoutResponse.new,
  );

  /// GetLayout retrieves a layout by ID including its current review metadata.
  static const getLayout = connect.Spec(
    '/$name/GetLayout',
    connect.StreamType.unary,
    layoutv1layout.GetLayoutRequest.new,
    layoutv1layout.GetLayoutResponse.new,
  );

  /// ListLayouts returns all layouts for a project ordered by creation time.
  static const listLayouts = connect.Spec(
    '/$name/ListLayouts',
    connect.StreamType.unary,
    layoutv1layout.ListLayoutsRequest.new,
    layoutv1layout.ListLayoutsResponse.new,
  );

  /// DeleteLayout permanently removes a layout and all its components and tiles.
  static const deleteLayout = connect.Spec(
    '/$name/DeleteLayout',
    connect.StreamType.unary,
    layoutv1layout.DeleteLayoutRequest.new,
    layoutv1layout.DeleteLayoutResponse.new,
  );

  /// Component placement
  static const placeComponent = connect.Spec(
    '/$name/PlaceComponent',
    connect.StreamType.unary,
    layoutv1layout.PlaceComponentRequest.new,
    layoutv1layout.PlaceComponentResponse.new,
  );

  /// MoveComponent updates the position of an existing placed component.
  static const moveComponent = connect.Spec(
    '/$name/MoveComponent',
    connect.StreamType.unary,
    layoutv1layout.MoveComponentRequest.new,
    layoutv1layout.MoveComponentResponse.new,
  );

  /// RemoveComponent removes a placed component from the layout.
  static const removeComponent = connect.Spec(
    '/$name/RemoveComponent',
    connect.StreamType.unary,
    layoutv1layout.RemoveComponentRequest.new,
    layoutv1layout.RemoveComponentResponse.new,
  );

  /// ListComponents returns all placed components for a layout.
  static const listComponents = connect.Spec(
    '/$name/ListComponents',
    connect.StreamType.unary,
    layoutv1layout.ListComponentsRequest.new,
    layoutv1layout.ListComponentsResponse.new,
  );

  /// Panel array generation
  static const generatePanelArray = connect.Spec(
    '/$name/GeneratePanelArray',
    connect.StreamType.unary,
    layoutv1layout.GeneratePanelArrayRequest.new,
    layoutv1layout.GeneratePanelArrayResponse.new,
  );

  /// Tile-based queries
  static const getTiles = connect.Spec(
    '/$name/GetTiles',
    connect.StreamType.unary,
    layoutv1layout.GetTilesRequest.new,
    layoutv1layout.GetTilesResponse.new,
  );

  /// GetTilePanels returns individual panel geometries within a specific tile for viewport rendering.
  static const getTilePanels = connect.Spec(
    '/$name/GetTilePanels',
    connect.StreamType.unary,
    layoutv1layout.GetTilePanelsRequest.new,
    layoutv1layout.GetTilePanelsResponse.new,
  );

  /// Acceptance workflow — gates the LayoutReady -> ElectricalReady phase transition.
  /// SubmitLayoutForReview transitions review_metadata.status to REVIEW_PENDING.
  static const submitLayoutForReview = connect.Spec(
    '/$name/SubmitLayoutForReview',
    connect.StreamType.unary,
    layoutv1layout.SubmitLayoutForReviewRequest.new,
    layoutv1layout.SubmitLayoutForReviewResponse.new,
  );

  /// ApproveLayout sets review_metadata.status to APPROVED, enabling ElectricalReady transition.
  static const approveLayout = connect.Spec(
    '/$name/ApproveLayout',
    connect.StreamType.unary,
    layoutv1layout.ApproveLayoutRequest.new,
    layoutv1layout.ApproveLayoutResponse.new,
  );

  /// RejectLayout sets review_metadata.status to REJECTED and records blockers preventing approval.
  static const rejectLayout = connect.Spec(
    '/$name/RejectLayout',
    connect.StreamType.unary,
    layoutv1layout.RejectLayoutRequest.new,
    layoutv1layout.RejectLayoutResponse.new,
  );
}
