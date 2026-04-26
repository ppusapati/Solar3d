//
//  Generated code. Do not modify.
//  source: orchestration/v1/orchestration.proto
//

import "package:connectrpc/connect.dart" as connect;
import "orchestration.pb.dart" as orchestrationv1orchestration;
import "orchestration.connect.spec.dart" as specs;

/// ComputeOrchestrationService manages long-running compute jobs, retries, and artifacts.
extension type ComputeOrchestrationServiceClient (connect.Transport _transport) {
  /// SubmitJob enqueues a new compute job for asynchronous processing.
  Future<orchestrationv1orchestration.SubmitJobResponse> submitJob(
    orchestrationv1orchestration.SubmitJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ComputeOrchestrationService.submitJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetJob returns the latest state of a compute job.
  Future<orchestrationv1orchestration.GetJobResponse> getJob(
    orchestrationv1orchestration.GetJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ComputeOrchestrationService.getJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListJobs returns jobs optionally filtered by status.
  Future<orchestrationv1orchestration.ListJobsResponse> listJobs(
    orchestrationv1orchestration.ListJobsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ComputeOrchestrationService.listJobs,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// RetryJob retries a failed or canceled job.
  Future<orchestrationv1orchestration.RetryJobResponse> retryJob(
    orchestrationv1orchestration.RetryJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ComputeOrchestrationService.retryJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CancelJob requests cancelation for a queued or running job.
  Future<orchestrationv1orchestration.CancelJobResponse> cancelJob(
    orchestrationv1orchestration.CancelJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ComputeOrchestrationService.cancelJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListDeadLetters returns dead-lettered jobs for a project.
  Future<orchestrationv1orchestration.ListDeadLettersResponse> listDeadLetters(
    orchestrationv1orchestration.ListDeadLettersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ComputeOrchestrationService.listDeadLetters,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetDeadLetter returns details of a specific dead-lettered job.
  Future<orchestrationv1orchestration.GetDeadLetterResponse> getDeadLetter(
    orchestrationv1orchestration.GetDeadLetterRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ComputeOrchestrationService.getDeadLetter,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
