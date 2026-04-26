//
//  Generated code. Do not modify.
//  source: ml_orchestration/v1/ml_orchestration.proto
//

import "package:connectrpc/connect.dart" as connect;
import "ml_orchestration.pb.dart" as ml_orchestrationv1ml_orchestration;
import "ml_orchestration.connect.spec.dart" as specs;

extension type MLOrchestrationServiceClient (connect.Transport _transport) {
  Future<ml_orchestrationv1ml_orchestration.SubmitTrainingJobResponse> submitTrainingJob(
    ml_orchestrationv1ml_orchestration.SubmitTrainingJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLOrchestrationService.submitTrainingJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_orchestrationv1ml_orchestration.GetJobStatusResponse> getJobStatus(
    ml_orchestrationv1ml_orchestration.GetJobStatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLOrchestrationService.getJobStatus,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_orchestrationv1ml_orchestration.CancelJobResponse> cancelJob(
    ml_orchestrationv1ml_orchestration.CancelJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLOrchestrationService.cancelJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<ml_orchestrationv1ml_orchestration.GetJobHistoryResponse> getJobHistory(
    ml_orchestrationv1ml_orchestration.GetJobHistoryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MLOrchestrationService.getJobHistory,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
