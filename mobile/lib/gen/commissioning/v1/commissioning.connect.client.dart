//
//  Generated code. Do not modify.
//  source: commissioning/v1/commissioning.proto
//

import "package:connectrpc/connect.dart" as connect;
import "commissioning.pb.dart" as commissioningv1commissioning;
import "commissioning.connect.spec.dart" as specs;

/// CommissioningService manages commissioning checklists, signoff workflows,
/// formal handover records, and as-built artifact registration for solar projects.
extension type CommissioningServiceClient (connect.Transport _transport) {
  /// Checklist lifecycle
  Future<commissioningv1commissioning.CreateChecklistResponse> createChecklist(
    commissioningv1commissioning.CreateChecklistRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.createChecklist,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<commissioningv1commissioning.GetChecklistResponse> getChecklist(
    commissioningv1commissioning.GetChecklistRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.getChecklist,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<commissioningv1commissioning.ListChecklistsResponse> listChecklists(
    commissioningv1commissioning.ListChecklistsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.listChecklists,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Checklist item management
  Future<commissioningv1commissioning.AddChecklistItemResponse> addChecklistItem(
    commissioningv1commissioning.AddChecklistItemRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.addChecklistItem,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<commissioningv1commissioning.UpdateChecklistItemResponse> updateChecklistItem(
    commissioningv1commissioning.UpdateChecklistItemRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.updateChecklistItem,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Engineer / contractor signoff
  Future<commissioningv1commissioning.SignOffChecklistResponse> signOffChecklist(
    commissioningv1commissioning.SignOffChecklistRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.signOffChecklist,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<commissioningv1commissioning.ListSignoffsResponse> listSignoffs(
    commissioningv1commissioning.ListSignoffsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.listSignoffs,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Formal project handover
  Future<commissioningv1commissioning.CreateHandoverResponse> createHandover(
    commissioningv1commissioning.CreateHandoverRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.createHandover,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<commissioningv1commissioning.GetHandoverResponse> getHandover(
    commissioningv1commissioning.GetHandoverRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.getHandover,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// As-built artifact registry (URL-based; binary upload is a separate storage concern)
  Future<commissioningv1commissioning.RecordAsBuiltResponse> recordAsBuilt(
    commissioningv1commissioning.RecordAsBuiltRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.recordAsBuilt,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<commissioningv1commissioning.ListAsBuiltArtifactsResponse> listAsBuiltArtifacts(
    commissioningv1commissioning.ListAsBuiltArtifactsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.listAsBuiltArtifacts,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Plain-text commissioning report covering all checklist items and signoffs
  Future<commissioningv1commissioning.GenerateCommissioningReportResponse> generateCommissioningReport(
    commissioningv1commissioning.GenerateCommissioningReportRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommissioningService.generateCommissioningReport,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
