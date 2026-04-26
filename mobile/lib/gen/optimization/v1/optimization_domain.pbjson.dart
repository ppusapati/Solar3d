//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization_domain.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use variableTypeDescriptor instead')
const VariableType$json = {
  '1': 'VariableType',
  '2': [
    {'1': 'VARIABLE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'VARIABLE_TYPE_CONTINUOUS', '2': 1},
    {'1': 'VARIABLE_TYPE_INTEGER', '2': 2},
    {'1': 'VARIABLE_TYPE_BINARY', '2': 3},
  ],
};

/// Descriptor for `VariableType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List variableTypeDescriptor = $convert.base64Decode(
    'CgxWYXJpYWJsZVR5cGUSHQoZVkFSSUFCTEVfVFlQRV9VTlNQRUNJRklFRBAAEhwKGFZBUklBQk'
    'xFX1RZUEVfQ09OVElOVU9VUxABEhkKFVZBUklBQkxFX1RZUEVfSU5URUdFUhACEhgKFFZBUklB'
    'QkxFX1RZUEVfQklOQVJZEAM=');

@$core.Deprecated('Use objectiveKindDescriptor instead')
const ObjectiveKind$json = {
  '1': 'ObjectiveKind',
  '2': [
    {'1': 'OBJECTIVE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'OBJECTIVE_KIND_MINIMIZE', '2': 1},
    {'1': 'OBJECTIVE_KIND_MAXIMIZE', '2': 2},
  ],
};

/// Descriptor for `ObjectiveKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List objectiveKindDescriptor = $convert.base64Decode(
    'Cg1PYmplY3RpdmVLaW5kEh4KGk9CSkVDVElWRV9LSU5EX1VOU1BFQ0lGSUVEEAASGwoXT0JKRU'
    'NUSVZFX0tJTkRfTUlOSU1JWkUQARIbChdPQkpFQ1RJVkVfS0lORF9NQVhJTUlaRRAC');

@$core.Deprecated('Use decisionVariableDescriptor instead')
const DecisionVariable$json = {
  '1': 'DecisionVariable',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'variable_type', '3': 2, '4': 1, '5': 14, '6': '.optimization.v1.VariableType', '10': 'variableType'},
    {'1': 'bounds', '3': 3, '4': 1, '5': 11, '6': '.common.v1.NumericRange', '10': 'bounds'},
  ],
};

/// Descriptor for `DecisionVariable`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decisionVariableDescriptor = $convert.base64Decode(
    'ChBEZWNpc2lvblZhcmlhYmxlEhIKBG5hbWUYASABKAlSBG5hbWUSQgoNdmFyaWFibGVfdHlwZR'
    'gCIAEoDjIdLm9wdGltaXphdGlvbi52MS5WYXJpYWJsZVR5cGVSDHZhcmlhYmxlVHlwZRIvCgZi'
    'b3VuZHMYAyABKAsyFy5jb21tb24udjEuTnVtZXJpY1JhbmdlUgZib3VuZHM=');

@$core.Deprecated('Use objectiveDefinitionDescriptor instead')
const ObjectiveDefinition$json = {
  '1': 'ObjectiveDefinition',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'kind', '3': 2, '4': 1, '5': 14, '6': '.optimization.v1.ObjectiveKind', '10': 'kind'},
    {'1': 'weight', '3': 3, '4': 1, '5': 1, '10': 'weight'},
  ],
};

/// Descriptor for `ObjectiveDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List objectiveDefinitionDescriptor = $convert.base64Decode(
    'ChNPYmplY3RpdmVEZWZpbml0aW9uEhIKBG5hbWUYASABKAlSBG5hbWUSMgoEa2luZBgCIAEoDj'
    'IeLm9wdGltaXphdGlvbi52MS5PYmplY3RpdmVLaW5kUgRraW5kEhYKBndlaWdodBgDIAEoAVIG'
    'd2VpZ2h0');

@$core.Deprecated('Use distributionModelDescriptor instead')
const DistributionModel$json = {
  '1': 'DistributionModel',
  '2': [
    {'1': 'mean', '3': 1, '4': 1, '5': 1, '10': 'mean'},
    {'1': 'std_dev', '3': 2, '4': 1, '5': 1, '10': 'stdDev'},
  ],
};

/// Descriptor for `DistributionModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List distributionModelDescriptor = $convert.base64Decode(
    'ChFEaXN0cmlidXRpb25Nb2RlbBISCgRtZWFuGAEgASgBUgRtZWFuEhcKB3N0ZF9kZXYYAiABKA'
    'FSBnN0ZERldg==');

@$core.Deprecated('Use constraintDefinitionDescriptor instead')
const ConstraintDefinition$json = {
  '1': 'ConstraintDefinition',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'expression', '3': 2, '4': 1, '5': 9, '10': 'expression'},
    {'1': 'allowed_range', '3': 3, '4': 1, '5': 11, '6': '.common.v1.NumericRange', '10': 'allowedRange'},
    {'1': 'hard_constraint', '3': 4, '4': 1, '5': 8, '10': 'hardConstraint'},
  ],
};

/// Descriptor for `ConstraintDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List constraintDefinitionDescriptor = $convert.base64Decode(
    'ChRDb25zdHJhaW50RGVmaW5pdGlvbhISCgRuYW1lGAEgASgJUgRuYW1lEh4KCmV4cHJlc3Npb2'
    '4YAiABKAlSCmV4cHJlc3Npb24SPAoNYWxsb3dlZF9yYW5nZRgDIAEoCzIXLmNvbW1vbi52MS5O'
    'dW1lcmljUmFuZ2VSDGFsbG93ZWRSYW5nZRInCg9oYXJkX2NvbnN0cmFpbnQYBCABKAhSDmhhcm'
    'RDb25zdHJhaW50');

@$core.Deprecated('Use optimizationProblemDescriptor instead')
const OptimizationProblem$json = {
  '1': 'OptimizationProblem',
  '2': [
    {'1': 'problem_id', '3': 1, '4': 1, '5': 9, '10': 'problemId'},
    {'1': 'variables', '3': 2, '4': 3, '5': 11, '6': '.optimization.v1.DecisionVariable', '10': 'variables'},
    {'1': 'objectives', '3': 3, '4': 3, '5': 11, '6': '.optimization.v1.ObjectiveDefinition', '10': 'objectives'},
    {'1': 'constraints', '3': 4, '4': 3, '5': 11, '6': '.optimization.v1.ConstraintDefinition', '10': 'constraints'},
    {'1': 'random_seed', '3': 5, '4': 1, '5': 3, '10': 'randomSeed'},
    {'1': 'max_iterations', '3': 6, '4': 1, '5': 5, '10': 'maxIterations'},
    {'1': 'contract', '3': 7, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `OptimizationProblem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List optimizationProblemDescriptor = $convert.base64Decode(
    'ChNPcHRpbWl6YXRpb25Qcm9ibGVtEh0KCnByb2JsZW1faWQYASABKAlSCXByb2JsZW1JZBI/Cg'
    'l2YXJpYWJsZXMYAiADKAsyIS5vcHRpbWl6YXRpb24udjEuRGVjaXNpb25WYXJpYWJsZVIJdmFy'
    'aWFibGVzEkQKCm9iamVjdGl2ZXMYAyADKAsyJC5vcHRpbWl6YXRpb24udjEuT2JqZWN0aXZlRG'
    'VmaW5pdGlvblIKb2JqZWN0aXZlcxJHCgtjb25zdHJhaW50cxgEIAMoCzIlLm9wdGltaXphdGlv'
    'bi52MS5Db25zdHJhaW50RGVmaW5pdGlvblILY29uc3RyYWludHMSHwoLcmFuZG9tX3NlZWQYBS'
    'ABKANSCnJhbmRvbVNlZWQSJQoObWF4X2l0ZXJhdGlvbnMYBiABKAVSDW1heEl0ZXJhdGlvbnMS'
    'NwoIY29udHJhY3QYByABKAsyGy5jb21tb24udjEuQ29udHJhY3RNZXRhZGF0YVIIY29udHJhY3'
    'Q=');

@$core.Deprecated('Use distributionDefinitionDescriptor instead')
const DistributionDefinition$json = {
  '1': 'DistributionDefinition',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'distribution', '3': 2, '4': 1, '5': 11, '6': '.optimization.v1.DistributionModel', '10': 'distribution'},
  ],
};

/// Descriptor for `DistributionDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List distributionDefinitionDescriptor = $convert.base64Decode(
    'ChZEaXN0cmlidXRpb25EZWZpbml0aW9uEhIKBG5hbWUYASABKAlSBG5hbWUSRgoMZGlzdHJpYn'
    'V0aW9uGAIgASgLMiIub3B0aW1pemF0aW9uLnYxLkRpc3RyaWJ1dGlvbk1vZGVsUgxkaXN0cmli'
    'dXRpb24=');

@$core.Deprecated('Use uncertaintyModelDescriptor instead')
const UncertaintyModel$json = {
  '1': 'UncertaintyModel',
  '2': [
    {'1': 'distributions', '3': 1, '4': 3, '5': 11, '6': '.optimization.v1.DistributionDefinition', '10': 'distributions'},
    {'1': 'sample_count', '3': 2, '4': 1, '5': 5, '10': 'sampleCount'},
    {'1': 'random_seed', '3': 3, '4': 1, '5': 3, '10': 'randomSeed'},
    {'1': 'contract', '3': 4, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `UncertaintyModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uncertaintyModelDescriptor = $convert.base64Decode(
    'ChBVbmNlcnRhaW50eU1vZGVsEk0KDWRpc3RyaWJ1dGlvbnMYASADKAsyJy5vcHRpbWl6YXRpb2'
    '4udjEuRGlzdHJpYnV0aW9uRGVmaW5pdGlvblINZGlzdHJpYnV0aW9ucxIhCgxzYW1wbGVfY291'
    'bnQYAiABKAVSC3NhbXBsZUNvdW50Eh8KC3JhbmRvbV9zZWVkGAMgASgDUgpyYW5kb21TZWVkEj'
    'cKCGNvbnRyYWN0GAQgASgLMhsuY29tbW9uLnYxLkNvbnRyYWN0TWV0YWRhdGFSCGNvbnRyYWN0');

@$core.Deprecated('Use candidateSolutionDescriptor instead')
const CandidateSolution$json = {
  '1': 'CandidateSolution',
  '2': [
    {'1': 'candidate_id', '3': 1, '4': 1, '5': 9, '10': 'candidateId'},
    {'1': 'assignments', '3': 2, '4': 3, '5': 11, '6': '.optimization.v1.CandidateSolution.AssignmentsEntry', '10': 'assignments'},
    {'1': 'objective_values', '3': 3, '4': 3, '5': 11, '6': '.optimization.v1.CandidateSolution.ObjectiveValuesEntry', '10': 'objectiveValues'},
    {'1': 'constraint_violations', '3': 4, '4': 3, '5': 11, '6': '.optimization.v1.CandidateSolution.ConstraintViolationsEntry', '10': 'constraintViolations'},
  ],
  '3': [CandidateSolution_AssignmentsEntry$json, CandidateSolution_ObjectiveValuesEntry$json, CandidateSolution_ConstraintViolationsEntry$json],
};

@$core.Deprecated('Use candidateSolutionDescriptor instead')
const CandidateSolution_AssignmentsEntry$json = {
  '1': 'AssignmentsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use candidateSolutionDescriptor instead')
const CandidateSolution_ObjectiveValuesEntry$json = {
  '1': 'ObjectiveValuesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use candidateSolutionDescriptor instead')
const CandidateSolution_ConstraintViolationsEntry$json = {
  '1': 'ConstraintViolationsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CandidateSolution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List candidateSolutionDescriptor = $convert.base64Decode(
    'ChFDYW5kaWRhdGVTb2x1dGlvbhIhCgxjYW5kaWRhdGVfaWQYASABKAlSC2NhbmRpZGF0ZUlkEl'
    'UKC2Fzc2lnbm1lbnRzGAIgAygLMjMub3B0aW1pemF0aW9uLnYxLkNhbmRpZGF0ZVNvbHV0aW9u'
    'LkFzc2lnbm1lbnRzRW50cnlSC2Fzc2lnbm1lbnRzEmIKEG9iamVjdGl2ZV92YWx1ZXMYAyADKA'
    'syNy5vcHRpbWl6YXRpb24udjEuQ2FuZGlkYXRlU29sdXRpb24uT2JqZWN0aXZlVmFsdWVzRW50'
    'cnlSD29iamVjdGl2ZVZhbHVlcxJxChVjb25zdHJhaW50X3Zpb2xhdGlvbnMYBCADKAsyPC5vcH'
    'RpbWl6YXRpb24udjEuQ2FuZGlkYXRlU29sdXRpb24uQ29uc3RyYWludFZpb2xhdGlvbnNFbnRy'
    'eVIUY29uc3RyYWludFZpb2xhdGlvbnMaPgoQQXNzaWdubWVudHNFbnRyeRIQCgNrZXkYASABKA'
    'lSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgBGkIKFE9iamVjdGl2ZVZhbHVlc0VudHJ5'
    'EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgBUgV2YWx1ZToCOAEaRwoZQ29uc3RyYW'
    'ludFZpb2xhdGlvbnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFs'
    'dWU6AjgB');

@$core.Deprecated('Use multiObjectiveOptimizationInputDescriptor instead')
const MultiObjectiveOptimizationInput$json = {
  '1': 'MultiObjectiveOptimizationInput',
  '2': [
    {'1': 'problem', '3': 1, '4': 1, '5': 11, '6': '.optimization.v1.OptimizationProblem', '10': 'problem'},
    {'1': 'initial_candidates', '3': 2, '4': 3, '5': 11, '6': '.optimization.v1.CandidateSolution', '10': 'initialCandidates'},
  ],
};

/// Descriptor for `MultiObjectiveOptimizationInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiObjectiveOptimizationInputDescriptor = $convert.base64Decode(
    'Ch9NdWx0aU9iamVjdGl2ZU9wdGltaXphdGlvbklucHV0Ej4KB3Byb2JsZW0YASABKAsyJC5vcH'
    'RpbWl6YXRpb24udjEuT3B0aW1pemF0aW9uUHJvYmxlbVIHcHJvYmxlbRJRChJpbml0aWFsX2Nh'
    'bmRpZGF0ZXMYAiADKAsyIi5vcHRpbWl6YXRpb24udjEuQ2FuZGlkYXRlU29sdXRpb25SEWluaX'
    'RpYWxDYW5kaWRhdGVz');

