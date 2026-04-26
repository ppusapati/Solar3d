//
//  Generated code. Do not modify.
//  source: transmission/v1/transmission.proto
//

import "package:connectrpc/connect.dart" as connect;
import "transmission.pb.dart" as transmissionv1transmission;

/// TransmissionRoutingService manages end-to-end transmission corridor routing
/// with engineering validation, governance workflow, and exportable delivery packs.
abstract final class TransmissionRoutingService {
  /// Fully-qualified name of the TransmissionRoutingService service.
  static const name = 'transmission.v1.TransmissionRoutingService';

  /// CalculateTransmissionRoute computes a transmission route and returns the final result.
  static const calculateTransmissionRoute = connect.Spec(
    '/$name/CalculateTransmissionRoute',
    connect.StreamType.unary,
    transmissionv1transmission.CalculateTransmissionRouteRequest.new,
    transmissionv1transmission.CalculateTransmissionRouteResponse.new,
  );

  /// StreamTransmissionRoute streams phase progress updates and emits the final route.
  static const streamTransmissionRoute = connect.Spec(
    '/$name/StreamTransmissionRoute',
    connect.StreamType.server,
    transmissionv1transmission.StreamTransmissionRouteRequest.new,
    transmissionv1transmission.StreamTransmissionRouteResponse.new,
  );

  /// GetTransmissionRoute returns a previously calculated transmission route by ID.
  static const getTransmissionRoute = connect.Spec(
    '/$name/GetTransmissionRoute',
    connect.StreamType.unary,
    transmissionv1transmission.GetTransmissionRouteRequest.new,
    transmissionv1transmission.GetTransmissionRouteResponse.new,
  );

  /// ListTransmissionRoutes lists transmission routes for a project.
  static const listTransmissionRoutes = connect.Spec(
    '/$name/ListTransmissionRoutes',
    connect.StreamType.unary,
    transmissionv1transmission.ListTransmissionRoutesRequest.new,
    transmissionv1transmission.ListTransmissionRoutesResponse.new,
  );

  /// SubmitTransmissionRouteForReview transitions a route into engineering review.
  static const submitTransmissionRouteForReview = connect.Spec(
    '/$name/SubmitTransmissionRouteForReview',
    connect.StreamType.unary,
    transmissionv1transmission.SubmitTransmissionRouteForReviewRequest.new,
    transmissionv1transmission.SubmitTransmissionRouteForReviewResponse.new,
  );

  /// ApproveTransmissionRoute approves a reviewed route for downstream delivery.
  static const approveTransmissionRoute = connect.Spec(
    '/$name/ApproveTransmissionRoute',
    connect.StreamType.unary,
    transmissionv1transmission.ApproveTransmissionRouteRequest.new,
    transmissionv1transmission.ApproveTransmissionRouteResponse.new,
  );

  /// ExportTransmissionRoutePack exports route artifacts required for handoff.
  static const exportTransmissionRoutePack = connect.Spec(
    '/$name/ExportTransmissionRoutePack',
    connect.StreamType.unary,
    transmissionv1transmission.ExportTransmissionRoutePackRequest.new,
    transmissionv1transmission.ExportTransmissionRoutePackResponse.new,
  );

  /// DeleteTransmissionRoute removes a transmission route.
  static const deleteTransmissionRoute = connect.Spec(
    '/$name/DeleteTransmissionRoute',
    connect.StreamType.unary,
    transmissionv1transmission.DeleteTransmissionRouteRequest.new,
    transmissionv1transmission.DeleteTransmissionRouteResponse.new,
  );

  /// RejectTransmissionRoute rejects a route under engineering review, returning it to draft.
  static const rejectTransmissionRoute = connect.Spec(
    '/$name/RejectTransmissionRoute',
    connect.StreamType.unary,
    transmissionv1transmission.RejectTransmissionRouteRequest.new,
    transmissionv1transmission.RejectTransmissionRouteResponse.new,
  );
}
