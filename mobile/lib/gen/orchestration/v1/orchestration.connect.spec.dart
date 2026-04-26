//
//  Generated code. Do not modify.
//  source: orchestration/v1/orchestration.proto
//

import "package:connectrpc/connect.dart" as connect;
import "orchestration.pb.dart" as orchestrationv1orchestration;

/// ComputeOrchestrationService manages long-running compute jobs, retries, and artifacts.
abstract final class ComputeOrchestrationService {
  /// Fully-qualified name of the ComputeOrchestrationService service.
  static const name = 'orchestration.v1.ComputeOrchestrationService';

  /// SubmitJob enqueues a new compute job for asynchronous processing.
  static const submitJob = connect.Spec(
    '/$name/SubmitJob',
    connect.StreamType.unary,
    orchestrationv1orchestration.SubmitJobRequest.new,
    orchestrationv1orchestration.SubmitJobResponse.new,
  );

  /// GetJob returns the latest state of a compute job.
  static const getJob = connect.Spec(
    '/$name/GetJob',
    connect.StreamType.unary,
    orchestrationv1orchestration.GetJobRequest.new,
    orchestrationv1orchestration.GetJobResponse.new,
  );

  /// ListJobs returns jobs optionally filtered by status.
  static const listJobs = connect.Spec(
    '/$name/ListJobs',
    connect.StreamType.unary,
    orchestrationv1orchestration.ListJobsRequest.new,
    orchestrationv1orchestration.ListJobsResponse.new,
  );

  /// RetryJob retries a failed or canceled job.
  static const retryJob = connect.Spec(
    '/$name/RetryJob',
    connect.StreamType.unary,
    orchestrationv1orchestration.RetryJobRequest.new,
    orchestrationv1orchestration.RetryJobResponse.new,
  );

  /// CancelJob requests cancelation for a queued or running job.
  static const cancelJob = connect.Spec(
    '/$name/CancelJob',
    connect.StreamType.unary,
    orchestrationv1orchestration.CancelJobRequest.new,
    orchestrationv1orchestration.CancelJobResponse.new,
  );

  /// ListDeadLetters returns dead-lettered jobs for a project.
  static const listDeadLetters = connect.Spec(
    '/$name/ListDeadLetters',
    connect.StreamType.unary,
    orchestrationv1orchestration.ListDeadLettersRequest.new,
    orchestrationv1orchestration.ListDeadLettersResponse.new,
  );

  /// GetDeadLetter returns details of a specific dead-lettered job.
  static const getDeadLetter = connect.Spec(
    '/$name/GetDeadLetter',
    connect.StreamType.unary,
    orchestrationv1orchestration.GetDeadLetterRequest.new,
    orchestrationv1orchestration.GetDeadLetterResponse.new,
  );
}
