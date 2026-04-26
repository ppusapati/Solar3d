//
//  Generated code. Do not modify.
//  source: ml_orchestration/v1/ml_orchestration.proto
//

import "package:connectrpc/connect.dart" as connect;
import "ml_orchestration.pb.dart" as ml_orchestrationv1ml_orchestration;

abstract final class MLOrchestrationService {
  /// Fully-qualified name of the MLOrchestrationService service.
  static const name = 'ml_orchestration.v1.MLOrchestrationService';

  static const submitTrainingJob = connect.Spec(
    '/$name/SubmitTrainingJob',
    connect.StreamType.unary,
    ml_orchestrationv1ml_orchestration.SubmitTrainingJobRequest.new,
    ml_orchestrationv1ml_orchestration.SubmitTrainingJobResponse.new,
  );

  static const getJobStatus = connect.Spec(
    '/$name/GetJobStatus',
    connect.StreamType.unary,
    ml_orchestrationv1ml_orchestration.GetJobStatusRequest.new,
    ml_orchestrationv1ml_orchestration.GetJobStatusResponse.new,
  );

  static const cancelJob = connect.Spec(
    '/$name/CancelJob',
    connect.StreamType.unary,
    ml_orchestrationv1ml_orchestration.CancelJobRequest.new,
    ml_orchestrationv1ml_orchestration.CancelJobResponse.new,
  );

  static const getJobHistory = connect.Spec(
    '/$name/GetJobHistory',
    connect.StreamType.unary,
    ml_orchestrationv1ml_orchestration.GetJobHistoryRequest.new,
    ml_orchestrationv1ml_orchestration.GetJobHistoryResponse.new,
  );
}
