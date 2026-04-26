//
//  Generated code. Do not modify.
//  source: ml_inference/v1/ml_inference.proto
//

import "package:connectrpc/connect.dart" as connect;
import "ml_inference.pb.dart" as ml_inferencev1ml_inference;

abstract final class MLInferenceService {
  /// Fully-qualified name of the MLInferenceService service.
  static const name = 'ml_inference.v1.MLInferenceService';

  /// Inference RPCs
  static const predictYield = connect.Spec(
    '/$name/PredictYield',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.YieldPredictionRequest.new,
    ml_inferencev1ml_inference.YieldPredictionResponse.new,
  );

  static const detectAnomaly = connect.Spec(
    '/$name/DetectAnomaly',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.AnomalyDetectionRequest.new,
    ml_inferencev1ml_inference.AnomalyDetectionResponse.new,
  );

  static const forecastDegradation = connect.Spec(
    '/$name/ForecastDegradation',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.DegradationRequest.new,
    ml_inferencev1ml_inference.DegradationResponse.new,
  );

  static const extractFeatures = connect.Spec(
    '/$name/ExtractFeatures',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.FeatureExtractionRequest.new,
    ml_inferencev1ml_inference.FeatureExtractionResponse.new,
  );

  /// Training & Management RPCs
  static const submitFeedback = connect.Spec(
    '/$name/SubmitFeedback',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.SubmitFeedbackRequest.new,
    ml_inferencev1ml_inference.SubmitFeedbackResponse.new,
  );

  static const startTraining = connect.Spec(
    '/$name/StartTraining',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.StartTrainingRequest.new,
    ml_inferencev1ml_inference.StartTrainingResponse.new,
  );

  static const getTrainingStatus = connect.Spec(
    '/$name/GetTrainingStatus',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.GetTrainingStatusRequest.new,
    ml_inferencev1ml_inference.GetTrainingStatusResponse.new,
  );

  static const evaluateModel = connect.Spec(
    '/$name/EvaluateModel',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.EvaluateModelRequest.new,
    ml_inferencev1ml_inference.EvaluateModelResponse.new,
  );

  static const getModelVersions = connect.Spec(
    '/$name/GetModelVersions',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.GetModelVersionsRequest.new,
    ml_inferencev1ml_inference.GetModelVersionsResponse.new,
  );

  static const deployModelVersion = connect.Spec(
    '/$name/DeployModelVersion',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.DeployModelVersionRequest.new,
    ml_inferencev1ml_inference.DeployModelVersionResponse.new,
  );

  static const getActiveModelVersion = connect.Spec(
    '/$name/GetActiveModelVersion',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.GetActiveModelVersionRequest.new,
    ml_inferencev1ml_inference.GetActiveModelVersionResponse.new,
  );

  static const rollbackModelVersion = connect.Spec(
    '/$name/RollbackModelVersion',
    connect.StreamType.unary,
    ml_inferencev1ml_inference.RollbackModelVersionRequest.new,
    ml_inferencev1ml_inference.RollbackModelVersionResponse.new,
  );
}
