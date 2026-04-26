//
//  Generated code. Do not modify.
//  source: ml_orchestration/v1/ml_orchestration.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use featureExtractionDescriptor instead')
const FeatureExtraction$json = {
  '1': 'FeatureExtraction',
  '2': [
    {'1': 'selected_features', '3': 1, '4': 3, '5': 9, '10': 'selectedFeatures'},
    {'1': 'normalize', '3': 2, '4': 1, '5': 8, '10': 'normalize'},
    {'1': 'outlier_percentile', '3': 3, '4': 1, '5': 1, '10': 'outlierPercentile'},
  ],
};

/// Descriptor for `FeatureExtraction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureExtractionDescriptor = $convert.base64Decode(
    'ChFGZWF0dXJlRXh0cmFjdGlvbhIrChFzZWxlY3RlZF9mZWF0dXJlcxgBIAMoCVIQc2VsZWN0ZW'
    'RGZWF0dXJlcxIcCglub3JtYWxpemUYAiABKAhSCW5vcm1hbGl6ZRItChJvdXRsaWVyX3BlcmNl'
    'bnRpbGUYAyABKAFSEW91dGxpZXJQZXJjZW50aWxl');

@$core.Deprecated('Use datasetWindowDescriptor instead')
const DatasetWindow$json = {
  '1': 'DatasetWindow',
  '2': [
    {'1': 'lookback_days', '3': 1, '4': 1, '5': 5, '10': 'lookbackDays'},
    {'1': 'min_samples_per_site', '3': 2, '4': 1, '5': 5, '10': 'minSamplesPerSite'},
    {'1': 'include_synthetic', '3': 3, '4': 1, '5': 8, '10': 'includeSynthetic'},
  ],
};

/// Descriptor for `DatasetWindow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List datasetWindowDescriptor = $convert.base64Decode(
    'Cg1EYXRhc2V0V2luZG93EiMKDWxvb2tiYWNrX2RheXMYASABKAVSDGxvb2tiYWNrRGF5cxIvCh'
    'RtaW5fc2FtcGxlc19wZXJfc2l0ZRgCIAEoBVIRbWluU2FtcGxlc1BlclNpdGUSKwoRaW5jbHVk'
    'ZV9zeW50aGV0aWMYAyABKAhSEGluY2x1ZGVTeW50aGV0aWM=');

@$core.Deprecated('Use datasetSplitDescriptor instead')
const DatasetSplit$json = {
  '1': 'DatasetSplit',
  '2': [
    {'1': 'train_ratio', '3': 1, '4': 1, '5': 1, '10': 'trainRatio'},
    {'1': 'validation_ratio', '3': 2, '4': 1, '5': 1, '10': 'validationRatio'},
    {'1': 'test_ratio', '3': 3, '4': 1, '5': 1, '10': 'testRatio'},
    {'1': 'time_aware', '3': 4, '4': 1, '5': 8, '10': 'timeAware'},
  ],
};

/// Descriptor for `DatasetSplit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List datasetSplitDescriptor = $convert.base64Decode(
    'CgxEYXRhc2V0U3BsaXQSHwoLdHJhaW5fcmF0aW8YASABKAFSCnRyYWluUmF0aW8SKQoQdmFsaW'
    'RhdGlvbl9yYXRpbxgCIAEoAVIPdmFsaWRhdGlvblJhdGlvEh0KCnRlc3RfcmF0aW8YAyABKAFS'
    'CXRlc3RSYXRpbxIdCgp0aW1lX2F3YXJlGAQgASgIUgl0aW1lQXdhcmU=');

@$core.Deprecated('Use datasetConfigDescriptor instead')
const DatasetConfig$json = {
  '1': 'DatasetConfig',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    {'1': 'window', '3': 2, '4': 1, '5': 11, '6': '.ml_orchestration.v1.DatasetWindow', '10': 'window'},
    {'1': 'split', '3': 3, '4': 1, '5': 11, '6': '.ml_orchestration.v1.DatasetSplit', '10': 'split'},
    {'1': 'features', '3': 4, '4': 1, '5': 11, '6': '.ml_orchestration.v1.FeatureExtraction', '10': 'features'},
    {'1': 'feedback_source', '3': 5, '4': 1, '5': 9, '10': 'feedbackSource'},
  ],
};

/// Descriptor for `DatasetConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List datasetConfigDescriptor = $convert.base64Decode(
    'Cg1EYXRhc2V0Q29uZmlnEhgKB3ZlcnNpb24YASABKAlSB3ZlcnNpb24SOgoGd2luZG93GAIgAS'
    'gLMiIubWxfb3JjaGVzdHJhdGlvbi52MS5EYXRhc2V0V2luZG93UgZ3aW5kb3cSNwoFc3BsaXQY'
    'AyABKAsyIS5tbF9vcmNoZXN0cmF0aW9uLnYxLkRhdGFzZXRTcGxpdFIFc3BsaXQSQgoIZmVhdH'
    'VyZXMYBCABKAsyJi5tbF9vcmNoZXN0cmF0aW9uLnYxLkZlYXR1cmVFeHRyYWN0aW9uUghmZWF0'
    'dXJlcxInCg9mZWVkYmFja19zb3VyY2UYBSABKAlSDmZlZWRiYWNrU291cmNl');

@$core.Deprecated('Use trainingHyperparamsDescriptor instead')
const TrainingHyperparams$json = {
  '1': 'TrainingHyperparams',
  '2': [
    {'1': 'algorithm', '3': 1, '4': 1, '5': 9, '10': 'algorithm'},
    {'1': 'epochs', '3': 2, '4': 1, '5': 5, '10': 'epochs'},
    {'1': 'batch_size', '3': 3, '4': 1, '5': 5, '10': 'batchSize'},
    {'1': 'learning_rate', '3': 4, '4': 1, '5': 1, '10': 'learningRate'},
    {'1': 'regularization_l1', '3': 5, '4': 1, '5': 1, '10': 'regularizationL1'},
    {'1': 'regularization_l2', '3': 6, '4': 1, '5': 1, '10': 'regularizationL2'},
    {'1': 'dropout_rate', '3': 7, '4': 1, '5': 1, '10': 'dropoutRate'},
    {'1': 'extra_params', '3': 8, '4': 3, '5': 11, '6': '.ml_orchestration.v1.TrainingHyperparams.ExtraParamsEntry', '10': 'extraParams'},
  ],
  '3': [TrainingHyperparams_ExtraParamsEntry$json],
};

@$core.Deprecated('Use trainingHyperparamsDescriptor instead')
const TrainingHyperparams_ExtraParamsEntry$json = {
  '1': 'ExtraParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TrainingHyperparams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trainingHyperparamsDescriptor = $convert.base64Decode(
    'ChNUcmFpbmluZ0h5cGVycGFyYW1zEhwKCWFsZ29yaXRobRgBIAEoCVIJYWxnb3JpdGhtEhYKBm'
    'Vwb2NocxgCIAEoBVIGZXBvY2hzEh0KCmJhdGNoX3NpemUYAyABKAVSCWJhdGNoU2l6ZRIjCg1s'
    'ZWFybmluZ19yYXRlGAQgASgBUgxsZWFybmluZ1JhdGUSKwoRcmVndWxhcml6YXRpb25fbDEYBS'
    'ABKAFSEHJlZ3VsYXJpemF0aW9uTDESKwoRcmVndWxhcml6YXRpb25fbDIYBiABKAFSEHJlZ3Vs'
    'YXJpemF0aW9uTDISIQoMZHJvcG91dF9yYXRlGAcgASgBUgtkcm9wb3V0UmF0ZRJcCgxleHRyYV'
    '9wYXJhbXMYCCADKAsyOS5tbF9vcmNoZXN0cmF0aW9uLnYxLlRyYWluaW5nSHlwZXJwYXJhbXMu'
    'RXh0cmFQYXJhbXNFbnRyeVILZXh0cmFQYXJhbXMaPgoQRXh0cmFQYXJhbXNFbnRyeRIQCgNrZX'
    'kYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use earlyStoppingPolicyDescriptor instead')
const EarlyStoppingPolicy$json = {
  '1': 'EarlyStoppingPolicy',
  '2': [
    {'1': 'patience_epochs', '3': 1, '4': 1, '5': 5, '10': 'patienceEpochs'},
    {'1': 'min_delta', '3': 2, '4': 1, '5': 1, '10': 'minDelta'},
    {'1': 'monitor_validation', '3': 3, '4': 1, '5': 8, '10': 'monitorValidation'},
  ],
};

/// Descriptor for `EarlyStoppingPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List earlyStoppingPolicyDescriptor = $convert.base64Decode(
    'ChNFYXJseVN0b3BwaW5nUG9saWN5EicKD3BhdGllbmNlX2Vwb2NocxgBIAEoBVIOcGF0aWVuY2'
    'VFcG9jaHMSGwoJbWluX2RlbHRhGAIgASgBUghtaW5EZWx0YRItChJtb25pdG9yX3ZhbGlkYXRp'
    'b24YAyABKAhSEW1vbml0b3JWYWxpZGF0aW9u');

@$core.Deprecated('Use submitTrainingJobRequestDescriptor instead')
const SubmitTrainingJobRequest$json = {
  '1': 'SubmitTrainingJobRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'task_type', '3': 2, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'dataset_config', '3': 3, '4': 1, '5': 11, '6': '.ml_orchestration.v1.DatasetConfig', '10': 'datasetConfig'},
    {'1': 'hyperparams', '3': 4, '4': 1, '5': 11, '6': '.ml_orchestration.v1.TrainingHyperparams', '10': 'hyperparams'},
    {'1': 'stopping_policy', '3': 5, '4': 1, '5': 11, '6': '.ml_orchestration.v1.EarlyStoppingPolicy', '10': 'stoppingPolicy'},
    {'1': 'triggered_by', '3': 6, '4': 1, '5': 9, '10': 'triggeredBy'},
    {'1': 'commit_hash', '3': 7, '4': 1, '5': 9, '10': 'commitHash'},
    {'1': 'labels', '3': 8, '4': 3, '5': 11, '6': '.ml_orchestration.v1.SubmitTrainingJobRequest.LabelsEntry', '10': 'labels'},
    {'1': 'timeout_minutes', '3': 9, '4': 1, '5': 5, '10': 'timeoutMinutes'},
  ],
  '3': [SubmitTrainingJobRequest_LabelsEntry$json],
};

@$core.Deprecated('Use submitTrainingJobRequestDescriptor instead')
const SubmitTrainingJobRequest_LabelsEntry$json = {
  '1': 'LabelsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SubmitTrainingJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitTrainingJobRequestDescriptor = $convert.base64Decode(
    'ChhTdWJtaXRUcmFpbmluZ0pvYlJlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZBIbCgl0YX'
    'NrX3R5cGUYAiABKAlSCHRhc2tUeXBlEkkKDmRhdGFzZXRfY29uZmlnGAMgASgLMiIubWxfb3Jj'
    'aGVzdHJhdGlvbi52MS5EYXRhc2V0Q29uZmlnUg1kYXRhc2V0Q29uZmlnEkoKC2h5cGVycGFyYW'
    '1zGAQgASgLMigubWxfb3JjaGVzdHJhdGlvbi52MS5UcmFpbmluZ0h5cGVycGFyYW1zUgtoeXBl'
    'cnBhcmFtcxJRCg9zdG9wcGluZ19wb2xpY3kYBSABKAsyKC5tbF9vcmNoZXN0cmF0aW9uLnYxLk'
    'Vhcmx5U3RvcHBpbmdQb2xpY3lSDnN0b3BwaW5nUG9saWN5EiEKDHRyaWdnZXJlZF9ieRgGIAEo'
    'CVILdHJpZ2dlcmVkQnkSHwoLY29tbWl0X2hhc2gYByABKAlSCmNvbW1pdEhhc2gSUQoGbGFiZW'
    'xzGAggAygLMjkubWxfb3JjaGVzdHJhdGlvbi52MS5TdWJtaXRUcmFpbmluZ0pvYlJlcXVlc3Qu'
    'TGFiZWxzRW50cnlSBmxhYmVscxInCg90aW1lb3V0X21pbnV0ZXMYCSABKAVSDnRpbWVvdXRNaW'
    '51dGVzGjkKC0xhYmVsc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2'
    'YWx1ZToCOAE=');

@$core.Deprecated('Use submitTrainingJobResponseDescriptor instead')
const SubmitTrainingJobResponse$json = {
  '1': 'SubmitTrainingJobResponse',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {'1': 'queued_at_ms', '3': 4, '4': 1, '5': 3, '10': 'queuedAtMs'},
  ],
};

/// Descriptor for `SubmitTrainingJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitTrainingJobResponseDescriptor = $convert.base64Decode(
    'ChlTdWJtaXRUcmFpbmluZ0pvYlJlc3BvbnNlEhUKBmpvYl9pZBgBIAEoCVIFam9iSWQSFgoGc3'
    'RhdHVzGAIgASgJUgZzdGF0dXMSGAoHbWVzc2FnZRgDIAEoCVIHbWVzc2FnZRIgCgxxdWV1ZWRf'
    'YXRfbXMYBCABKANSCnF1ZXVlZEF0TXM=');

@$core.Deprecated('Use trainingProgressDescriptor instead')
const TrainingProgress$json = {
  '1': 'TrainingProgress',
  '2': [
    {'1': 'current_epoch', '3': 1, '4': 1, '5': 5, '10': 'currentEpoch'},
    {'1': 'total_epochs', '3': 2, '4': 1, '5': 5, '10': 'totalEpochs'},
    {'1': 'completion_percent', '3': 3, '4': 1, '5': 1, '10': 'completionPercent'},
    {'1': 'elapsed_seconds', '3': 4, '4': 1, '5': 3, '10': 'elapsedSeconds'},
    {'1': 'estimated_remaining_seconds', '3': 5, '4': 1, '5': 3, '10': 'estimatedRemainingSeconds'},
  ],
};

/// Descriptor for `TrainingProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trainingProgressDescriptor = $convert.base64Decode(
    'ChBUcmFpbmluZ1Byb2dyZXNzEiMKDWN1cnJlbnRfZXBvY2gYASABKAVSDGN1cnJlbnRFcG9jaB'
    'IhCgx0b3RhbF9lcG9jaHMYAiABKAVSC3RvdGFsRXBvY2hzEi0KEmNvbXBsZXRpb25fcGVyY2Vu'
    'dBgDIAEoAVIRY29tcGxldGlvblBlcmNlbnQSJwoPZWxhcHNlZF9zZWNvbmRzGAQgASgDUg5lbG'
    'Fwc2VkU2Vjb25kcxI+Chtlc3RpbWF0ZWRfcmVtYWluaW5nX3NlY29uZHMYBSABKANSGWVzdGlt'
    'YXRlZFJlbWFpbmluZ1NlY29uZHM=');

@$core.Deprecated('Use trainingMetricsDescriptor instead')
const TrainingMetrics$json = {
  '1': 'TrainingMetrics',
  '2': [
    {'1': 'train_loss', '3': 1, '4': 1, '5': 1, '10': 'trainLoss'},
    {'1': 'validation_loss', '3': 2, '4': 1, '5': 1, '10': 'validationLoss'},
    {'1': 'test_loss', '3': 3, '4': 1, '5': 1, '10': 'testLoss'},
    {'1': 'test_mae', '3': 4, '4': 1, '5': 1, '10': 'testMae'},
    {'1': 'test_rmse', '3': 5, '4': 1, '5': 1, '10': 'testRmse'},
    {'1': 'test_r2_score', '3': 6, '4': 1, '5': 1, '10': 'testR2Score'},
    {'1': 'test_coverage_lower', '3': 7, '4': 1, '5': 1, '10': 'testCoverageLower'},
    {'1': 'test_coverage_upper', '3': 8, '4': 1, '5': 1, '10': 'testCoverageUpper'},
    {'1': 'custom_metrics', '3': 9, '4': 3, '5': 11, '6': '.ml_orchestration.v1.TrainingMetrics.CustomMetricsEntry', '10': 'customMetrics'},
  ],
  '3': [TrainingMetrics_CustomMetricsEntry$json],
};

@$core.Deprecated('Use trainingMetricsDescriptor instead')
const TrainingMetrics_CustomMetricsEntry$json = {
  '1': 'CustomMetricsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TrainingMetrics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trainingMetricsDescriptor = $convert.base64Decode(
    'Cg9UcmFpbmluZ01ldHJpY3MSHQoKdHJhaW5fbG9zcxgBIAEoAVIJdHJhaW5Mb3NzEicKD3ZhbG'
    'lkYXRpb25fbG9zcxgCIAEoAVIOdmFsaWRhdGlvbkxvc3MSGwoJdGVzdF9sb3NzGAMgASgBUgh0'
    'ZXN0TG9zcxIZCgh0ZXN0X21hZRgEIAEoAVIHdGVzdE1hZRIbCgl0ZXN0X3Jtc2UYBSABKAFSCH'
    'Rlc3RSbXNlEiIKDXRlc3RfcjJfc2NvcmUYBiABKAFSC3Rlc3RSMlNjb3JlEi4KE3Rlc3RfY292'
    'ZXJhZ2VfbG93ZXIYByABKAFSEXRlc3RDb3ZlcmFnZUxvd2VyEi4KE3Rlc3RfY292ZXJhZ2VfdX'
    'BwZXIYCCABKAFSEXRlc3RDb3ZlcmFnZVVwcGVyEl4KDmN1c3RvbV9tZXRyaWNzGAkgAygLMjcu'
    'bWxfb3JjaGVzdHJhdGlvbi52MS5UcmFpbmluZ01ldHJpY3MuQ3VzdG9tTWV0cmljc0VudHJ5Ug'
    '1jdXN0b21NZXRyaWNzGkAKEkN1c3RvbU1ldHJpY3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIU'
    'CgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');

@$core.Deprecated('Use modelArtifactInfoDescriptor instead')
const ModelArtifactInfo$json = {
  '1': 'ModelArtifactInfo',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'hash', '3': 2, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'size_bytes', '3': 3, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'format', '3': 4, '4': 1, '5': 9, '10': 'format'},
  ],
};

/// Descriptor for `ModelArtifactInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modelArtifactInfoDescriptor = $convert.base64Decode(
    'ChFNb2RlbEFydGlmYWN0SW5mbxISCgRwYXRoGAEgASgJUgRwYXRoEhIKBGhhc2gYAiABKAlSBG'
    'hhc2gSHQoKc2l6ZV9ieXRlcxgDIAEoA1IJc2l6ZUJ5dGVzEhYKBmZvcm1hdBgEIAEoCVIGZm9y'
    'bWF0');

@$core.Deprecated('Use getJobStatusRequestDescriptor instead')
const GetJobStatusRequest$json = {
  '1': 'GetJobStatusRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `GetJobStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobStatusRequestDescriptor = $convert.base64Decode(
    'ChNHZXRKb2JTdGF0dXNSZXF1ZXN0EhUKBmpvYl9pZBgBIAEoCVIFam9iSWQ=');

@$core.Deprecated('Use getJobStatusResponseDescriptor instead')
const GetJobStatusResponse$json = {
  '1': 'GetJobStatusResponse',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'progress', '3': 3, '4': 1, '5': 11, '6': '.ml_orchestration.v1.TrainingProgress', '10': 'progress'},
    {'1': 'metrics', '3': 4, '4': 1, '5': 11, '6': '.ml_orchestration.v1.TrainingMetrics', '10': 'metrics'},
    {'1': 'artifact', '3': 5, '4': 1, '5': 11, '6': '.ml_orchestration.v1.ModelArtifactInfo', '10': 'artifact'},
    {'1': 'model_version_id', '3': 6, '4': 1, '5': 9, '10': 'modelVersionId'},
    {'1': 'error_message', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'started_at_ms', '3': 8, '4': 1, '5': 3, '10': 'startedAtMs'},
    {'1': 'completed_at_ms', '3': 9, '4': 1, '5': 3, '10': 'completedAtMs'},
    {'1': 'logs', '3': 10, '4': 3, '5': 11, '6': '.ml_orchestration.v1.GetJobStatusResponse.LogsEntry', '10': 'logs'},
  ],
  '3': [GetJobStatusResponse_LogsEntry$json],
};

@$core.Deprecated('Use getJobStatusResponseDescriptor instead')
const GetJobStatusResponse_LogsEntry$json = {
  '1': 'LogsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `GetJobStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobStatusResponseDescriptor = $convert.base64Decode(
    'ChRHZXRKb2JTdGF0dXNSZXNwb25zZRIVCgZqb2JfaWQYASABKAlSBWpvYklkEhYKBnN0YXR1cx'
    'gCIAEoCVIGc3RhdHVzEkEKCHByb2dyZXNzGAMgASgLMiUubWxfb3JjaGVzdHJhdGlvbi52MS5U'
    'cmFpbmluZ1Byb2dyZXNzUghwcm9ncmVzcxI+CgdtZXRyaWNzGAQgASgLMiQubWxfb3JjaGVzdH'
    'JhdGlvbi52MS5UcmFpbmluZ01ldHJpY3NSB21ldHJpY3MSQgoIYXJ0aWZhY3QYBSABKAsyJi5t'
    'bF9vcmNoZXN0cmF0aW9uLnYxLk1vZGVsQXJ0aWZhY3RJbmZvUghhcnRpZmFjdBIoChBtb2RlbF'
    '92ZXJzaW9uX2lkGAYgASgJUg5tb2RlbFZlcnNpb25JZBIjCg1lcnJvcl9tZXNzYWdlGAcgASgJ'
    'UgxlcnJvck1lc3NhZ2USIgoNc3RhcnRlZF9hdF9tcxgIIAEoA1ILc3RhcnRlZEF0TXMSJgoPY2'
    '9tcGxldGVkX2F0X21zGAkgASgDUg1jb21wbGV0ZWRBdE1zEkcKBGxvZ3MYCiADKAsyMy5tbF9v'
    'cmNoZXN0cmF0aW9uLnYxLkdldEpvYlN0YXR1c1Jlc3BvbnNlLkxvZ3NFbnRyeVIEbG9ncxo3Cg'
    'lMb2dzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use cancelJobRequestDescriptor instead')
const CancelJobRequest$json = {
  '1': 'CancelJobRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'cancelled_by', '3': 3, '4': 1, '5': 9, '10': 'cancelledBy'},
  ],
};

/// Descriptor for `CancelJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelJobRequestDescriptor = $convert.base64Decode(
    'ChBDYW5jZWxKb2JSZXF1ZXN0EhUKBmpvYl9pZBgBIAEoCVIFam9iSWQSFgoGcmVhc29uGAIgAS'
    'gJUgZyZWFzb24SIQoMY2FuY2VsbGVkX2J5GAMgASgJUgtjYW5jZWxsZWRCeQ==');

@$core.Deprecated('Use cancelJobResponseDescriptor instead')
const CancelJobResponse$json = {
  '1': 'CancelJobResponse',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'cancelled', '3': 2, '4': 1, '5': 8, '10': 'cancelled'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CancelJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelJobResponseDescriptor = $convert.base64Decode(
    'ChFDYW5jZWxKb2JSZXNwb25zZRIVCgZqb2JfaWQYASABKAlSBWpvYklkEhwKCWNhbmNlbGxlZB'
    'gCIAEoCFIJY2FuY2VsbGVkEhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use jobHistoryFilterDescriptor instead')
const JobHistoryFilter$json = {
  '1': 'JobHistoryFilter',
  '2': [
    {'1': 'task_type', '3': 1, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `JobHistoryFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobHistoryFilterDescriptor = $convert.base64Decode(
    'ChBKb2JIaXN0b3J5RmlsdGVyEhsKCXRhc2tfdHlwZRgBIAEoCVIIdGFza1R5cGUSFgoGc3RhdH'
    'VzGAIgASgJUgZzdGF0dXMSFAoFbGltaXQYAyABKAVSBWxpbWl0EhYKBm9mZnNldBgEIAEoBVIG'
    'b2Zmc2V0');

@$core.Deprecated('Use jobHistoryEntryDescriptor instead')
const JobHistoryEntry$json = {
  '1': 'JobHistoryEntry',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'task_type', '3': 2, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'triggered_by', '3': 4, '4': 1, '5': 9, '10': 'triggeredBy'},
    {'1': 'created_at_ms', '3': 5, '4': 1, '5': 3, '10': 'createdAtMs'},
    {'1': 'completed_at_ms', '3': 6, '4': 1, '5': 3, '10': 'completedAtMs'},
    {'1': 'model_version_id', '3': 7, '4': 1, '5': 9, '10': 'modelVersionId'},
  ],
};

/// Descriptor for `JobHistoryEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobHistoryEntryDescriptor = $convert.base64Decode(
    'Cg9Kb2JIaXN0b3J5RW50cnkSFQoGam9iX2lkGAEgASgJUgVqb2JJZBIbCgl0YXNrX3R5cGUYAi'
    'ABKAlSCHRhc2tUeXBlEhYKBnN0YXR1cxgDIAEoCVIGc3RhdHVzEiEKDHRyaWdnZXJlZF9ieRgE'
    'IAEoCVILdHJpZ2dlcmVkQnkSIgoNY3JlYXRlZF9hdF9tcxgFIAEoA1ILY3JlYXRlZEF0TXMSJg'
    'oPY29tcGxldGVkX2F0X21zGAYgASgDUg1jb21wbGV0ZWRBdE1zEigKEG1vZGVsX3ZlcnNpb25f'
    'aWQYByABKAlSDm1vZGVsVmVyc2lvbklk');

@$core.Deprecated('Use getJobHistoryRequestDescriptor instead')
const GetJobHistoryRequest$json = {
  '1': 'GetJobHistoryRequest',
  '2': [
    {'1': 'filter', '3': 1, '4': 1, '5': 11, '6': '.ml_orchestration.v1.JobHistoryFilter', '10': 'filter'},
  ],
};

/// Descriptor for `GetJobHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobHistoryRequestDescriptor = $convert.base64Decode(
    'ChRHZXRKb2JIaXN0b3J5UmVxdWVzdBI9CgZmaWx0ZXIYASABKAsyJS5tbF9vcmNoZXN0cmF0aW'
    '9uLnYxLkpvYkhpc3RvcnlGaWx0ZXJSBmZpbHRlcg==');

@$core.Deprecated('Use getJobHistoryResponseDescriptor instead')
const GetJobHistoryResponse$json = {
  '1': 'GetJobHistoryResponse',
  '2': [
    {'1': 'jobs', '3': 1, '4': 3, '5': 11, '6': '.ml_orchestration.v1.JobHistoryEntry', '10': 'jobs'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `GetJobHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getJobHistoryResponseDescriptor = $convert.base64Decode(
    'ChVHZXRKb2JIaXN0b3J5UmVzcG9uc2USOAoEam9icxgBIAMoCzIkLm1sX29yY2hlc3RyYXRpb2'
    '4udjEuSm9iSGlzdG9yeUVudHJ5UgRqb2JzEh8KC3RvdGFsX2NvdW50GAIgASgFUgp0b3RhbENv'
    'dW50');

const $core.Map<$core.String, $core.dynamic> MLOrchestrationServiceBase$json = {
  '1': 'MLOrchestrationService',
  '2': [
    {'1': 'SubmitTrainingJob', '2': '.ml_orchestration.v1.SubmitTrainingJobRequest', '3': '.ml_orchestration.v1.SubmitTrainingJobResponse'},
    {'1': 'GetJobStatus', '2': '.ml_orchestration.v1.GetJobStatusRequest', '3': '.ml_orchestration.v1.GetJobStatusResponse'},
    {'1': 'CancelJob', '2': '.ml_orchestration.v1.CancelJobRequest', '3': '.ml_orchestration.v1.CancelJobResponse'},
    {'1': 'GetJobHistory', '2': '.ml_orchestration.v1.GetJobHistoryRequest', '3': '.ml_orchestration.v1.GetJobHistoryResponse'},
  ],
};

@$core.Deprecated('Use mLOrchestrationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> MLOrchestrationServiceBase$messageJson = {
  '.ml_orchestration.v1.SubmitTrainingJobRequest': SubmitTrainingJobRequest$json,
  '.ml_orchestration.v1.DatasetConfig': DatasetConfig$json,
  '.ml_orchestration.v1.DatasetWindow': DatasetWindow$json,
  '.ml_orchestration.v1.DatasetSplit': DatasetSplit$json,
  '.ml_orchestration.v1.FeatureExtraction': FeatureExtraction$json,
  '.ml_orchestration.v1.TrainingHyperparams': TrainingHyperparams$json,
  '.ml_orchestration.v1.TrainingHyperparams.ExtraParamsEntry': TrainingHyperparams_ExtraParamsEntry$json,
  '.ml_orchestration.v1.EarlyStoppingPolicy': EarlyStoppingPolicy$json,
  '.ml_orchestration.v1.SubmitTrainingJobRequest.LabelsEntry': SubmitTrainingJobRequest_LabelsEntry$json,
  '.ml_orchestration.v1.SubmitTrainingJobResponse': SubmitTrainingJobResponse$json,
  '.ml_orchestration.v1.GetJobStatusRequest': GetJobStatusRequest$json,
  '.ml_orchestration.v1.GetJobStatusResponse': GetJobStatusResponse$json,
  '.ml_orchestration.v1.TrainingProgress': TrainingProgress$json,
  '.ml_orchestration.v1.TrainingMetrics': TrainingMetrics$json,
  '.ml_orchestration.v1.TrainingMetrics.CustomMetricsEntry': TrainingMetrics_CustomMetricsEntry$json,
  '.ml_orchestration.v1.ModelArtifactInfo': ModelArtifactInfo$json,
  '.ml_orchestration.v1.GetJobStatusResponse.LogsEntry': GetJobStatusResponse_LogsEntry$json,
  '.ml_orchestration.v1.CancelJobRequest': CancelJobRequest$json,
  '.ml_orchestration.v1.CancelJobResponse': CancelJobResponse$json,
  '.ml_orchestration.v1.GetJobHistoryRequest': GetJobHistoryRequest$json,
  '.ml_orchestration.v1.JobHistoryFilter': JobHistoryFilter$json,
  '.ml_orchestration.v1.GetJobHistoryResponse': GetJobHistoryResponse$json,
  '.ml_orchestration.v1.JobHistoryEntry': JobHistoryEntry$json,
};

/// Descriptor for `MLOrchestrationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List mLOrchestrationServiceDescriptor = $convert.base64Decode(
    'ChZNTE9yY2hlc3RyYXRpb25TZXJ2aWNlEnIKEVN1Ym1pdFRyYWluaW5nSm9iEi0ubWxfb3JjaG'
    'VzdHJhdGlvbi52MS5TdWJtaXRUcmFpbmluZ0pvYlJlcXVlc3QaLi5tbF9vcmNoZXN0cmF0aW9u'
    'LnYxLlN1Ym1pdFRyYWluaW5nSm9iUmVzcG9uc2USYwoMR2V0Sm9iU3RhdHVzEigubWxfb3JjaG'
    'VzdHJhdGlvbi52MS5HZXRKb2JTdGF0dXNSZXF1ZXN0GikubWxfb3JjaGVzdHJhdGlvbi52MS5H'
    'ZXRKb2JTdGF0dXNSZXNwb25zZRJaCglDYW5jZWxKb2ISJS5tbF9vcmNoZXN0cmF0aW9uLnYxLk'
    'NhbmNlbEpvYlJlcXVlc3QaJi5tbF9vcmNoZXN0cmF0aW9uLnYxLkNhbmNlbEpvYlJlc3BvbnNl'
    'EmYKDUdldEpvYkhpc3RvcnkSKS5tbF9vcmNoZXN0cmF0aW9uLnYxLkdldEpvYkhpc3RvcnlSZX'
    'F1ZXN0GioubWxfb3JjaGVzdHJhdGlvbi52MS5HZXRKb2JIaXN0b3J5UmVzcG9uc2U=');

