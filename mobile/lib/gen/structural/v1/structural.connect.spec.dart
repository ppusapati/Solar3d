//
//  Generated code. Do not modify.
//  source: structural/v1/structural.proto
//

import "package:connectrpc/connect.dart" as connect;
import "structural.pb.dart" as structuralv1structural;

/// StructuralService provides load analysis and design verification for solar
/// mounting structures.  All calculations are traceable to ASCE 7-16 / EN 1991.
abstract final class StructuralService {
  /// Fully-qualified name of the StructuralService service.
  static const name = 'structural.v1.StructuralService';

  /// Design lifecycle
  static const createDesign = connect.Spec(
    '/$name/CreateDesign',
    connect.StreamType.unary,
    structuralv1structural.CreateDesignRequest.new,
    structuralv1structural.CreateDesignResponse.new,
  );

  /// GetDesign returns a structural design by ID.
  static const getDesign = connect.Spec(
    '/$name/GetDesign',
    connect.StreamType.unary,
    structuralv1structural.GetDesignRequest.new,
    structuralv1structural.GetDesignResponse.new,
  );

  /// ListDesigns lists structural designs for a project.
  static const listDesigns = connect.Spec(
    '/$name/ListDesigns',
    connect.StreamType.unary,
    structuralv1structural.ListDesignsRequest.new,
    structuralv1structural.ListDesignsResponse.new,
  );

  /// DeleteDesign removes a structural design by ID.
  static const deleteDesign = connect.Spec(
    '/$name/DeleteDesign',
    connect.StreamType.unary,
    structuralv1structural.DeleteDesignRequest.new,
    structuralv1structural.DeleteDesignResponse.new,
  );

  /// Load calculations — every result references the equation used.
  static const computeDeadLoad = connect.Spec(
    '/$name/ComputeDeadLoad',
    connect.StreamType.unary,
    structuralv1structural.ComputeDeadLoadRequest.new,
    structuralv1structural.ComputeDeadLoadResponse.new,
  );

  /// ComputeWindLoad calculates wind load for the design inputs.
  static const computeWindLoad = connect.Spec(
    '/$name/ComputeWindLoad',
    connect.StreamType.unary,
    structuralv1structural.ComputeWindLoadRequest.new,
    structuralv1structural.ComputeWindLoadResponse.new,
  );

  /// ComputeSeismicLoad calculates seismic load for the design inputs.
  static const computeSeismicLoad = connect.Spec(
    '/$name/ComputeSeismicLoad',
    connect.StreamType.unary,
    structuralv1structural.ComputeSeismicLoadRequest.new,
    structuralv1structural.ComputeSeismicLoadResponse.new,
  );

  /// ComputeFoundationRequirement estimates foundation requirements from loads and soil.
  static const computeFoundationRequirement = connect.Spec(
    '/$name/ComputeFoundationRequirement',
    connect.StreamType.unary,
    structuralv1structural.ComputeFoundationRequirementRequest.new,
    structuralv1structural.ComputeFoundationRequirementResponse.new,
  );

  /// ValidateStructuralDesign validates design constraints and reports violations.
  static const validateStructuralDesign = connect.Spec(
    '/$name/ValidateStructuralDesign',
    connect.StreamType.unary,
    structuralv1structural.ValidateStructuralDesignRequest.new,
    structuralv1structural.ValidateStructuralDesignResponse.new,
  );

  /// Engineer review workflow
  static const submitForReview = connect.Spec(
    '/$name/SubmitForReview',
    connect.StreamType.unary,
    structuralv1structural.SubmitForReviewRequest.new,
    structuralv1structural.SubmitForReviewResponse.new,
  );

  /// ApproveDesign marks a submitted design as approved.
  static const approveDesign = connect.Spec(
    '/$name/ApproveDesign',
    connect.StreamType.unary,
    structuralv1structural.ApproveDesignRequest.new,
    structuralv1structural.ApproveDesignResponse.new,
  );

  /// RejectDesign marks a submitted design as rejected.
  static const rejectDesign = connect.Spec(
    '/$name/RejectDesign',
    connect.StreamType.unary,
    structuralv1structural.RejectDesignRequest.new,
    structuralv1structural.RejectDesignResponse.new,
  );

  /// Plain-text design report with all assumptions and equations
  static const generateStructuralReport = connect.Spec(
    '/$name/GenerateStructuralReport',
    connect.StreamType.unary,
    structuralv1structural.GenerateStructuralReportRequest.new,
    structuralv1structural.GenerateStructuralReportResponse.new,
  );
}
