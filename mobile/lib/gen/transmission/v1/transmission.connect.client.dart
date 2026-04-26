//
//  Generated code. Do not modify.
//  source: transmission/v1/transmission.proto
//

import "package:connectrpc/connect.dart" as connect;
import "transmission.pb.dart" as transmissionv1transmission;
import "transmission.connect.spec.dart" as specs;

/// TransmissionRoutingService manages end-to-end transmission corridor routing
/// with engineering validation, governance workflow, and exportable delivery packs.
extension type TransmissionRoutingServiceClient (connect.Transport _transport) {
  /// CalculateTransmissionRoute computes a transmission route and returns the final result.
  Future<transmissionv1transmission.CalculateTransmissionRouteResponse> calculateTransmissionRoute(
    transmissionv1transmission.CalculateTransmissionRouteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.calculateTransmissionRoute,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// StreamTransmissionRoute streams phase progress updates and emits the final route.
  Stream<transmissionv1transmission.StreamTransmissionRouteResponse> streamTransmissionRoute(
    transmissionv1transmission.StreamTransmissionRouteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.TransmissionRoutingService.streamTransmissionRoute,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetTransmissionRoute returns a previously calculated transmission route by ID.
  Future<transmissionv1transmission.GetTransmissionRouteResponse> getTransmissionRoute(
    transmissionv1transmission.GetTransmissionRouteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.getTransmissionRoute,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListTransmissionRoutes lists transmission routes for a project.
  Future<transmissionv1transmission.ListTransmissionRoutesResponse> listTransmissionRoutes(
    transmissionv1transmission.ListTransmissionRoutesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.listTransmissionRoutes,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SubmitTransmissionRouteForReview transitions a route into engineering review.
  Future<transmissionv1transmission.SubmitTransmissionRouteForReviewResponse> submitTransmissionRouteForReview(
    transmissionv1transmission.SubmitTransmissionRouteForReviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.submitTransmissionRouteForReview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApproveTransmissionRoute approves a reviewed route for downstream delivery.
  Future<transmissionv1transmission.ApproveTransmissionRouteResponse> approveTransmissionRoute(
    transmissionv1transmission.ApproveTransmissionRouteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.approveTransmissionRoute,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ExportTransmissionRoutePack exports route artifacts required for handoff.
  Future<transmissionv1transmission.ExportTransmissionRoutePackResponse> exportTransmissionRoutePack(
    transmissionv1transmission.ExportTransmissionRoutePackRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.exportTransmissionRoutePack,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteTransmissionRoute removes a transmission route.
  Future<transmissionv1transmission.DeleteTransmissionRouteResponse> deleteTransmissionRoute(
    transmissionv1transmission.DeleteTransmissionRouteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.deleteTransmissionRoute,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RejectTransmissionRoute rejects a route under engineering review, returning it to draft.
  Future<transmissionv1transmission.RejectTransmissionRouteResponse> rejectTransmissionRoute(
    transmissionv1transmission.RejectTransmissionRouteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TransmissionRoutingService.rejectTransmissionRoute,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
