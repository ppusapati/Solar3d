//
//  Generated code. Do not modify.
//  source: structural/v1/structural.proto
//

import "package:connectrpc/connect.dart" as connect;
import "structural.pb.dart" as structuralv1structural;
import "structural.connect.spec.dart" as specs;

/// StructuralService provides load analysis and design verification for solar
/// mounting structures.  All calculations are traceable to ASCE 7-16 / EN 1991.
extension type StructuralServiceClient (connect.Transport _transport) {
  /// Design lifecycle
  Future<structuralv1structural.CreateDesignResponse> createDesign(
    structuralv1structural.CreateDesignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.createDesign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetDesign returns a structural design by ID.
  Future<structuralv1structural.GetDesignResponse> getDesign(
    structuralv1structural.GetDesignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.getDesign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListDesigns lists structural designs for a project.
  Future<structuralv1structural.ListDesignsResponse> listDesigns(
    structuralv1structural.ListDesignsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.listDesigns,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteDesign removes a structural design by ID.
  Future<structuralv1structural.DeleteDesignResponse> deleteDesign(
    structuralv1structural.DeleteDesignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.deleteDesign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Load calculations — every result references the equation used.
  Future<structuralv1structural.ComputeDeadLoadResponse> computeDeadLoad(
    structuralv1structural.ComputeDeadLoadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.computeDeadLoad,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ComputeWindLoad calculates wind load for the design inputs.
  Future<structuralv1structural.ComputeWindLoadResponse> computeWindLoad(
    structuralv1structural.ComputeWindLoadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.computeWindLoad,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ComputeSeismicLoad calculates seismic load for the design inputs.
  Future<structuralv1structural.ComputeSeismicLoadResponse> computeSeismicLoad(
    structuralv1structural.ComputeSeismicLoadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.computeSeismicLoad,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ComputeFoundationRequirement estimates foundation requirements from loads and soil.
  Future<structuralv1structural.ComputeFoundationRequirementResponse> computeFoundationRequirement(
    structuralv1structural.ComputeFoundationRequirementRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.computeFoundationRequirement,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ValidateStructuralDesign validates design constraints and reports violations.
  Future<structuralv1structural.ValidateStructuralDesignResponse> validateStructuralDesign(
    structuralv1structural.ValidateStructuralDesignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.validateStructuralDesign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Engineer review workflow
  Future<structuralv1structural.SubmitForReviewResponse> submitForReview(
    structuralv1structural.SubmitForReviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.submitForReview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ApproveDesign marks a submitted design as approved.
  Future<structuralv1structural.ApproveDesignResponse> approveDesign(
    structuralv1structural.ApproveDesignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.approveDesign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RejectDesign marks a submitted design as rejected.
  Future<structuralv1structural.RejectDesignResponse> rejectDesign(
    structuralv1structural.RejectDesignRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.rejectDesign,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Plain-text design report with all assumptions and equations
  Future<structuralv1structural.GenerateStructuralReportResponse> generateStructuralReport(
    structuralv1structural.GenerateStructuralReportRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.StructuralService.generateStructuralReport,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
