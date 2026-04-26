//
//  Generated code. Do not modify.
//  source: ml_inference/v1/ml_inference.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'ml_inference.pb.dart' as $3;
import 'ml_inference.pbjson.dart';

export 'ml_inference.pb.dart';

abstract class MLInferenceServiceBase extends $pb.GeneratedService {
  $async.Future<$3.YieldPredictionResponse> predictYield($pb.ServerContext ctx, $3.YieldPredictionRequest request);
  $async.Future<$3.AnomalyDetectionResponse> detectAnomaly($pb.ServerContext ctx, $3.AnomalyDetectionRequest request);
  $async.Future<$3.DegradationResponse> forecastDegradation($pb.ServerContext ctx, $3.DegradationRequest request);
  $async.Future<$3.FeatureExtractionResponse> extractFeatures($pb.ServerContext ctx, $3.FeatureExtractionRequest request);
  $async.Future<$3.SubmitFeedbackResponse> submitFeedback($pb.ServerContext ctx, $3.SubmitFeedbackRequest request);
  $async.Future<$3.StartTrainingResponse> startTraining($pb.ServerContext ctx, $3.StartTrainingRequest request);
  $async.Future<$3.GetTrainingStatusResponse> getTrainingStatus($pb.ServerContext ctx, $3.GetTrainingStatusRequest request);
  $async.Future<$3.EvaluateModelResponse> evaluateModel($pb.ServerContext ctx, $3.EvaluateModelRequest request);
  $async.Future<$3.GetModelVersionsResponse> getModelVersions($pb.ServerContext ctx, $3.GetModelVersionsRequest request);
  $async.Future<$3.DeployModelVersionResponse> deployModelVersion($pb.ServerContext ctx, $3.DeployModelVersionRequest request);
  $async.Future<$3.GetActiveModelVersionResponse> getActiveModelVersion($pb.ServerContext ctx, $3.GetActiveModelVersionRequest request);
  $async.Future<$3.RollbackModelVersionResponse> rollbackModelVersion($pb.ServerContext ctx, $3.RollbackModelVersionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'PredictYield': return $3.YieldPredictionRequest();
      case 'DetectAnomaly': return $3.AnomalyDetectionRequest();
      case 'ForecastDegradation': return $3.DegradationRequest();
      case 'ExtractFeatures': return $3.FeatureExtractionRequest();
      case 'SubmitFeedback': return $3.SubmitFeedbackRequest();
      case 'StartTraining': return $3.StartTrainingRequest();
      case 'GetTrainingStatus': return $3.GetTrainingStatusRequest();
      case 'EvaluateModel': return $3.EvaluateModelRequest();
      case 'GetModelVersions': return $3.GetModelVersionsRequest();
      case 'DeployModelVersion': return $3.DeployModelVersionRequest();
      case 'GetActiveModelVersion': return $3.GetActiveModelVersionRequest();
      case 'RollbackModelVersion': return $3.RollbackModelVersionRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'PredictYield': return this.predictYield(ctx, request as $3.YieldPredictionRequest);
      case 'DetectAnomaly': return this.detectAnomaly(ctx, request as $3.AnomalyDetectionRequest);
      case 'ForecastDegradation': return this.forecastDegradation(ctx, request as $3.DegradationRequest);
      case 'ExtractFeatures': return this.extractFeatures(ctx, request as $3.FeatureExtractionRequest);
      case 'SubmitFeedback': return this.submitFeedback(ctx, request as $3.SubmitFeedbackRequest);
      case 'StartTraining': return this.startTraining(ctx, request as $3.StartTrainingRequest);
      case 'GetTrainingStatus': return this.getTrainingStatus(ctx, request as $3.GetTrainingStatusRequest);
      case 'EvaluateModel': return this.evaluateModel(ctx, request as $3.EvaluateModelRequest);
      case 'GetModelVersions': return this.getModelVersions(ctx, request as $3.GetModelVersionsRequest);
      case 'DeployModelVersion': return this.deployModelVersion(ctx, request as $3.DeployModelVersionRequest);
      case 'GetActiveModelVersion': return this.getActiveModelVersion(ctx, request as $3.GetActiveModelVersionRequest);
      case 'RollbackModelVersion': return this.rollbackModelVersion(ctx, request as $3.RollbackModelVersionRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => MLInferenceServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => MLInferenceServiceBase$messageJson;
}

