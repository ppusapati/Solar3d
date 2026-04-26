//
//  Generated code. Do not modify.
//  source: ml_inference/v1/ml_inference.proto
//

import "package:connectrpc/connect.dart" as connect;
import "ml_inference.pb.dart" as ml_inferencev1ml_inference;
import "ml_inference.connect.spec.dart" as specs;

extension type MLInferenceServiceClient (connect.Transport _transport) {
  /// Inference RPCs
  Future<ml_inferencev1ml_inference.YieldPredictionResponse> predictYield(
    ml_inferencev1ml_inference.YieldPredictionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.predictYield,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.AnomalyDetectionResponse> detectAnomaly(
    ml_inferencev1ml_inference.AnomalyDetectionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.detectAnomaly,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.DegradationResponse> forecastDegradation(
    ml_inferencev1ml_inference.DegradationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.forecastDegradation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.FeatureExtractionResponse> extractFeatures(
    ml_inferencev1ml_inference.FeatureExtractionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.extractFeatures,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Training & Management RPCs
  Future<ml_inferencev1ml_inference.SubmitFeedbackResponse> submitFeedback(
    ml_inferencev1ml_inference.SubmitFeedbackRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.submitFeedback,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.StartTrainingResponse> startTraining(
    ml_inferencev1ml_inference.StartTrainingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.startTraining,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.GetTrainingStatusResponse> getTrainingStatus(
    ml_inferencev1ml_inference.GetTrainingStatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.getTrainingStatus,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.EvaluateModelResponse> evaluateModel(
    ml_inferencev1ml_inference.EvaluateModelRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.evaluateModel,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.GetModelVersionsResponse> getModelVersions(
    ml_inferencev1ml_inference.GetModelVersionsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.getModelVersions,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.DeployModelVersionResponse> deployModelVersion(
    ml_inferencev1ml_inference.DeployModelVersionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.deployModelVersion,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.GetActiveModelVersionResponse> getActiveModelVersion(
    ml_inferencev1ml_inference.GetActiveModelVersionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.getActiveModelVersion,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_inferencev1ml_inference.RollbackModelVersionResponse> rollbackModelVersion(
    ml_inferencev1ml_inference.RollbackModelVersionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLInferenceService.rollbackModelVersion,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
