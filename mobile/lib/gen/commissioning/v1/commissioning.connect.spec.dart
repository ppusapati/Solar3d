//
//  Generated code. Do not modify.
//  source: commissioning/v1/commissioning.proto
//

import "package:connectrpc/connect.dart" as connect;
import "commissioning.pb.dart" as commissioningv1commissioning;

/// CommissioningService manages commissioning checklists, signoff workflows,
/// formal handover records, and as-built artifact registration for solar projects.
abstract final class CommissioningService {
  /// Fully-qualified name of the CommissioningService service.
  static const name = 'commissioning.v1.CommissioningService';

  /// Checklist lifecycle
  static const createChecklist = connect.Spec(
    '/$name/CreateChecklist',
    connect.StreamType.unary,
    commissioningv1commissioning.CreateChecklistRequest.new,
    commissioningv1commissioning.CreateChecklistResponse.new,
  );

  static const getChecklist = connect.Spec(
    '/$name/GetChecklist',
    connect.StreamType.unary,
    commissioningv1commissioning.GetChecklistRequest.new,
    commissioningv1commissioning.GetChecklistResponse.new,
  );

  static const listChecklists = connect.Spec(
    '/$name/ListChecklists',
    connect.StreamType.unary,
    commissioningv1commissioning.ListChecklistsRequest.new,
    commissioningv1commissioning.ListChecklistsResponse.new,
  );

  /// Checklist item management
  static const addChecklistItem = connect.Spec(
    '/$name/AddChecklistItem',
    connect.StreamType.unary,
    commissioningv1commissioning.AddChecklistItemRequest.new,
    commissioningv1commissioning.AddChecklistItemResponse.new,
  );

  static const updateChecklistItem = connect.Spec(
    '/$name/UpdateChecklistItem',
    connect.StreamType.unary,
    commissioningv1commissioning.UpdateChecklistItemRequest.new,
    commissioningv1commissioning.UpdateChecklistItemResponse.new,
  );

  /// Engineer / contractor signoff
  static const signOffChecklist = connect.Spec(
    '/$name/SignOffChecklist',
    connect.StreamType.unary,
    commissioningv1commissioning.SignOffChecklistRequest.new,
    commissioningv1commissioning.SignOffChecklistResponse.new,
  );

  static const listSignoffs = connect.Spec(
    '/$name/ListSignoffs',
    connect.StreamType.unary,
    commissioningv1commissioning.ListSignoffsRequest.new,
    commissioningv1commissioning.ListSignoffsResponse.new,
  );

  /// Formal project handover
  static const createHandover = connect.Spec(
    '/$name/CreateHandover',
    connect.StreamType.unary,
    commissioningv1commissioning.CreateHandoverRequest.new,
    commissioningv1commissioning.CreateHandoverResponse.new,
  );

  static const getHandover = connect.Spec(
    '/$name/GetHandover',
    connect.StreamType.unary,
    commissioningv1commissioning.GetHandoverRequest.new,
    commissioningv1commissioning.GetHandoverResponse.new,
  );

  /// As-built artifact registry (URL-based; binary upload is a separate storage concern)
  static const recordAsBuilt = connect.Spec(
    '/$name/RecordAsBuilt',
    connect.StreamType.unary,
    commissioningv1commissioning.RecordAsBuiltRequest.new,
    commissioningv1commissioning.RecordAsBuiltResponse.new,
  );

  static const listAsBuiltArtifacts = connect.Spec(
    '/$name/ListAsBuiltArtifacts',
    connect.StreamType.unary,
    commissioningv1commissioning.ListAsBuiltArtifactsRequest.new,
    commissioningv1commissioning.ListAsBuiltArtifactsResponse.new,
  );

  /// Plain-text commissioning report covering all checklist items and signoffs
  static const generateCommissioningReport = connect.Spec(
    '/$name/GenerateCommissioningReport',
    connect.StreamType.unary,
    commissioningv1commissioning.GenerateCommissioningReportRequest.new,
    commissioningv1commissioning.GenerateCommissioningReportResponse.new,
  );
}
