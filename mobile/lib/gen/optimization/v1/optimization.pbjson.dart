//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../common/v1/primitives.pbjson.dart' as $0;
import '../../google/protobuf/timestamp.pbjson.dart' as $2;
import 'optimization_domain.pbjson.dart' as $1;

@$core.Deprecated('Use objectiveDescriptor instead')
const Objective$json = {
  '1': 'Objective',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'kind', '3': 2, '4': 1, '5': 14, '6': '.optimization.v1.Objective.ObjectiveKind', '10': 'kind'},
    {'1': 'weight', '3': 3, '4': 1, '5': 1, '10': 'weight'},
  ],
  '4': [Objective_ObjectiveKind$json],
};

@$core.Deprecated('Use objectiveDescriptor instead')
const Objective_ObjectiveKind$json = {
  '1': 'ObjectiveKind',
  '2': [
    {'1': 'MINIMIZE', '2': 0},
    {'1': 'MAXIMIZE', '2': 1},
  ],
};

/// Descriptor for `Objective`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List objectiveDescriptor = $convert.base64Decode(
    'CglPYmplY3RpdmUSEgoEbmFtZRgBIAEoCVIEbmFtZRI8CgRraW5kGAIgASgOMigub3B0aW1pem'
    'F0aW9uLnYxLk9iamVjdGl2ZS5PYmplY3RpdmVLaW5kUgRraW5kEhYKBndlaWdodBgDIAEoAVIG'
    'd2VpZ2h0IisKDU9iamVjdGl2ZUtpbmQSDAoITUlOSU1JWkUQABIMCghNQVhJTUlaRRAB');

@$core.Deprecated('Use solutionDescriptor instead')
const Solution$json = {
  '1': 'Solution',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'variables', '3': 2, '4': 3, '5': 1, '10': 'variables'},
    {'1': 'objectives', '3': 3, '4': 3, '5': 1, '10': 'objectives'},
    {'1': 'rank', '3': 4, '4': 1, '5': 1, '10': 'rank'},
    {'1': 'crowding_distance', '3': 5, '4': 1, '5': 1, '10': 'crowdingDistance'},
  ],
};

/// Descriptor for `Solution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solutionDescriptor = $convert.base64Decode(
    'CghTb2x1dGlvbhIOCgJpZBgBIAEoBVICaWQSHAoJdmFyaWFibGVzGAIgAygBUgl2YXJpYWJsZX'
    'MSHgoKb2JqZWN0aXZlcxgDIAMoAVIKb2JqZWN0aXZlcxISCgRyYW5rGAQgASgBUgRyYW5rEisK'
    'EWNyb3dkaW5nX2Rpc3RhbmNlGAUgASgBUhBjcm93ZGluZ0Rpc3RhbmNl');

@$core.Deprecated('Use paretoFrontierResponseDescriptor instead')
const ParetoFrontierResponse$json = {
  '1': 'ParetoFrontierResponse',
  '2': [
    {'1': 'solutions', '3': 1, '4': 3, '5': 11, '6': '.optimization.v1.Solution', '10': 'solutions'},
    {'1': 'frontier_size', '3': 2, '4': 1, '5': 5, '10': 'frontierSize'},
    {'1': 'solution_ids', '3': 3, '4': 3, '5': 5, '10': 'solutionIds'},
  ],
};

/// Descriptor for `ParetoFrontierResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paretoFrontierResponseDescriptor = $convert.base64Decode(
    'ChZQYXJldG9Gcm9udGllclJlc3BvbnNlEjcKCXNvbHV0aW9ucxgBIAMoCzIZLm9wdGltaXphdG'
    'lvbi52MS5Tb2x1dGlvblIJc29sdXRpb25zEiMKDWZyb250aWVyX3NpemUYAiABKAVSDGZyb250'
    'aWVyU2l6ZRIhCgxzb2x1dGlvbl9pZHMYAyADKAVSC3NvbHV0aW9uSWRz');

@$core.Deprecated('Use addToFrontierRequestDescriptor instead')
const AddToFrontierRequest$json = {
  '1': 'AddToFrontierRequest',
  '2': [
    {'1': 'objectives', '3': 1, '4': 3, '5': 11, '6': '.optimization.v1.Objective', '10': 'objectives'},
    {'1': 'new_solution', '3': 2, '4': 1, '5': 11, '6': '.optimization.v1.Solution', '10': 'newSolution'},
    {'1': 'input', '3': 10, '4': 1, '5': 11, '6': '.optimization.v1.MultiObjectiveOptimizationInput', '10': 'input'},
  ],
};

/// Descriptor for `AddToFrontierRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addToFrontierRequestDescriptor = $convert.base64Decode(
    'ChRBZGRUb0Zyb250aWVyUmVxdWVzdBI6CgpvYmplY3RpdmVzGAEgAygLMhoub3B0aW1pemF0aW'
    '9uLnYxLk9iamVjdGl2ZVIKb2JqZWN0aXZlcxI8CgxuZXdfc29sdXRpb24YAiABKAsyGS5vcHRp'
    'bWl6YXRpb24udjEuU29sdXRpb25SC25ld1NvbHV0aW9uEkYKBWlucHV0GAogASgLMjAub3B0aW'
    '1pemF0aW9uLnYxLk11bHRpT2JqZWN0aXZlT3B0aW1pemF0aW9uSW5wdXRSBWlucHV0');

@$core.Deprecated('Use distributionDescriptor instead')
const Distribution$json = {
  '1': 'Distribution',
  '2': [
    {'1': 'mean', '3': 1, '4': 1, '5': 1, '10': 'mean'},
    {'1': 'std_dev', '3': 2, '4': 1, '5': 1, '10': 'stdDev'},
  ],
};

/// Descriptor for `Distribution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List distributionDescriptor = $convert.base64Decode(
    'CgxEaXN0cmlidXRpb24SEgoEbWVhbhgBIAEoAVIEbWVhbhIXCgdzdGRfZGV2GAIgASgBUgZzdG'
    'REZXY=');

@$core.Deprecated('Use monteCarloRequestDescriptor instead')
const MonteCarloRequest$json = {
  '1': 'MonteCarloRequest',
  '2': [
    {'1': 'distributions', '3': 1, '4': 3, '5': 11, '6': '.optimization.v1.Distribution', '10': 'distributions'},
    {'1': 'num_samples', '3': 2, '4': 1, '5': 5, '10': 'numSamples'},
    {'1': 'seed', '3': 3, '4': 1, '5': 3, '10': 'seed'},
    {'1': 'uncertainty_model', '3': 10, '4': 1, '5': 11, '6': '.optimization.v1.UncertaintyModel', '10': 'uncertaintyModel'},
  ],
};

/// Descriptor for `MonteCarloRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monteCarloRequestDescriptor = $convert.base64Decode(
    'ChFNb250ZUNhcmxvUmVxdWVzdBJDCg1kaXN0cmlidXRpb25zGAEgAygLMh0ub3B0aW1pemF0aW'
    '9uLnYxLkRpc3RyaWJ1dGlvblINZGlzdHJpYnV0aW9ucxIfCgtudW1fc2FtcGxlcxgCIAEoBVIK'
    'bnVtU2FtcGxlcxISCgRzZWVkGAMgASgDUgRzZWVkEk4KEXVuY2VydGFpbnR5X21vZGVsGAogAS'
    'gLMiEub3B0aW1pemF0aW9uLnYxLlVuY2VydGFpbnR5TW9kZWxSEHVuY2VydGFpbnR5TW9kZWw=');

@$core.Deprecated('Use monteCarloResponseDescriptor instead')
const MonteCarloResponse$json = {
  '1': 'MonteCarloResponse',
  '2': [
    {'1': 'mean', '3': 1, '4': 1, '5': 1, '10': 'mean'},
    {'1': 'std_dev', '3': 2, '4': 1, '5': 1, '10': 'stdDev'},
    {'1': 'p10', '3': 3, '4': 1, '5': 1, '10': 'p10'},
    {'1': 'p50', '3': 4, '4': 1, '5': 1, '10': 'p50'},
    {'1': 'p90', '3': 5, '4': 1, '5': 1, '10': 'p90'},
    {'1': 'min_value', '3': 6, '4': 1, '5': 1, '10': 'minValue'},
    {'1': 'max_value', '3': 7, '4': 1, '5': 1, '10': 'maxValue'},
  ],
};

/// Descriptor for `MonteCarloResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monteCarloResponseDescriptor = $convert.base64Decode(
    'ChJNb250ZUNhcmxvUmVzcG9uc2USEgoEbWVhbhgBIAEoAVIEbWVhbhIXCgdzdGRfZGV2GAIgAS'
    'gBUgZzdGREZXYSEAoDcDEwGAMgASgBUgNwMTASEAoDcDUwGAQgASgBUgNwNTASEAoDcDkwGAUg'
    'ASgBUgNwOTASGwoJbWluX3ZhbHVlGAYgASgBUghtaW5WYWx1ZRIbCgltYXhfdmFsdWUYByABKA'
    'FSCG1heFZhbHVl');

@$core.Deprecated('Use gARequestDescriptor instead')
const GARequest$json = {
  '1': 'GARequest',
  '2': [
    {'1': 'population_size', '3': 1, '4': 1, '5': 5, '10': 'populationSize'},
    {'1': 'generations', '3': 2, '4': 1, '5': 5, '10': 'generations'},
    {'1': 'crossover_rate', '3': 3, '4': 1, '5': 1, '10': 'crossoverRate'},
    {'1': 'mutation_rate', '3': 4, '4': 1, '5': 1, '10': 'mutationRate'},
    {'1': 'elite_count', '3': 5, '4': 1, '5': 5, '10': 'eliteCount'},
    {'1': 'seed', '3': 6, '4': 1, '5': 3, '10': 'seed'},
    {'1': 'initial_population', '3': 7, '4': 3, '5': 1, '10': 'initialPopulation'},
    {'1': 'problem', '3': 10, '4': 1, '5': 11, '6': '.optimization.v1.OptimizationProblem', '10': 'problem'},
  ],
};

/// Descriptor for `GARequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gARequestDescriptor = $convert.base64Decode(
    'CglHQVJlcXVlc3QSJwoPcG9wdWxhdGlvbl9zaXplGAEgASgFUg5wb3B1bGF0aW9uU2l6ZRIgCg'
    'tnZW5lcmF0aW9ucxgCIAEoBVILZ2VuZXJhdGlvbnMSJQoOY3Jvc3NvdmVyX3JhdGUYAyABKAFS'
    'DWNyb3Nzb3ZlclJhdGUSIwoNbXV0YXRpb25fcmF0ZRgEIAEoAVIMbXV0YXRpb25SYXRlEh8KC2'
    'VsaXRlX2NvdW50GAUgASgFUgplbGl0ZUNvdW50EhIKBHNlZWQYBiABKANSBHNlZWQSLQoSaW5p'
    'dGlhbF9wb3B1bGF0aW9uGAcgAygBUhFpbml0aWFsUG9wdWxhdGlvbhI+Cgdwcm9ibGVtGAogAS'
    'gLMiQub3B0aW1pemF0aW9uLnYxLk9wdGltaXphdGlvblByb2JsZW1SB3Byb2JsZW0=');

@$core.Deprecated('Use gAResponseDescriptor instead')
const GAResponse$json = {
  '1': 'GAResponse',
  '2': [
    {'1': 'best_fitness', '3': 1, '4': 1, '5': 1, '10': 'bestFitness'},
    {'1': 'best_genes', '3': 2, '4': 3, '5': 1, '10': 'bestGenes'},
    {'1': 'generations_completed', '3': 3, '4': 1, '5': 5, '10': 'generationsCompleted'},
  ],
};

/// Descriptor for `GAResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gAResponseDescriptor = $convert.base64Decode(
    'CgpHQVJlc3BvbnNlEiEKDGJlc3RfZml0bmVzcxgBIAEoAVILYmVzdEZpdG5lc3MSHQoKYmVzdF'
    '9nZW5lcxgCIAMoAVIJYmVzdEdlbmVzEjMKFWdlbmVyYXRpb25zX2NvbXBsZXRlZBgDIAEoBVIU'
    'Z2VuZXJhdGlvbnNDb21wbGV0ZWQ=');

@$core.Deprecated('Use sARequestDescriptor instead')
const SARequest$json = {
  '1': 'SARequest',
  '2': [
    {'1': 'initial_temperature', '3': 1, '4': 1, '5': 1, '10': 'initialTemperature'},
    {'1': 'cooling_rate', '3': 2, '4': 1, '5': 1, '10': 'coolingRate'},
    {'1': 'iterations', '3': 3, '4': 1, '5': 5, '10': 'iterations'},
    {'1': 'perturbation_scale', '3': 4, '4': 1, '5': 1, '10': 'perturbationScale'},
    {'1': 'seed', '3': 5, '4': 1, '5': 3, '10': 'seed'},
    {'1': 'initial_solution', '3': 6, '4': 3, '5': 1, '10': 'initialSolution'},
    {'1': 'problem', '3': 10, '4': 1, '5': 11, '6': '.optimization.v1.OptimizationProblem', '10': 'problem'},
  ],
};

/// Descriptor for `SARequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sARequestDescriptor = $convert.base64Decode(
    'CglTQVJlcXVlc3QSLwoTaW5pdGlhbF90ZW1wZXJhdHVyZRgBIAEoAVISaW5pdGlhbFRlbXBlcm'
    'F0dXJlEiEKDGNvb2xpbmdfcmF0ZRgCIAEoAVILY29vbGluZ1JhdGUSHgoKaXRlcmF0aW9ucxgD'
    'IAEoBVIKaXRlcmF0aW9ucxItChJwZXJ0dXJiYXRpb25fc2NhbGUYBCABKAFSEXBlcnR1cmJhdG'
    'lvblNjYWxlEhIKBHNlZWQYBSABKANSBHNlZWQSKQoQaW5pdGlhbF9zb2x1dGlvbhgGIAMoAVIP'
    'aW5pdGlhbFNvbHV0aW9uEj4KB3Byb2JsZW0YCiABKAsyJC5vcHRpbWl6YXRpb24udjEuT3B0aW'
    '1pemF0aW9uUHJvYmxlbVIHcHJvYmxlbQ==');

@$core.Deprecated('Use sAResponseDescriptor instead')
const SAResponse$json = {
  '1': 'SAResponse',
  '2': [
    {'1': 'best_energy', '3': 1, '4': 1, '5': 1, '10': 'bestEnergy'},
    {'1': 'best_solution', '3': 2, '4': 3, '5': 1, '10': 'bestSolution'},
    {'1': 'final_temperature', '3': 3, '4': 1, '5': 1, '10': 'finalTemperature'},
  ],
};

/// Descriptor for `SAResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sAResponseDescriptor = $convert.base64Decode(
    'CgpTQVJlc3BvbnNlEh8KC2Jlc3RfZW5lcmd5GAEgASgBUgpiZXN0RW5lcmd5EiMKDWJlc3Rfc2'
    '9sdXRpb24YAiADKAFSDGJlc3RTb2x1dGlvbhIrChFmaW5hbF90ZW1wZXJhdHVyZRgDIAEoAVIQ'
    'ZmluYWxUZW1wZXJhdHVyZQ==');

@$core.Deprecated('Use pSORequestDescriptor instead')
const PSORequest$json = {
  '1': 'PSORequest',
  '2': [
    {'1': 'num_particles', '3': 1, '4': 1, '5': 5, '10': 'numParticles'},
    {'1': 'iterations', '3': 2, '4': 1, '5': 5, '10': 'iterations'},
    {'1': 'c1', '3': 3, '4': 1, '5': 1, '10': 'c1'},
    {'1': 'c2', '3': 4, '4': 1, '5': 1, '10': 'c2'},
    {'1': 'w', '3': 5, '4': 1, '5': 1, '10': 'w'},
    {'1': 'boundary_min', '3': 6, '4': 1, '5': 1, '10': 'boundaryMin'},
    {'1': 'boundary_max', '3': 7, '4': 1, '5': 1, '10': 'boundaryMax'},
    {'1': 'seed', '3': 8, '4': 1, '5': 3, '10': 'seed'},
    {'1': 'problem', '3': 10, '4': 1, '5': 11, '6': '.optimization.v1.OptimizationProblem', '10': 'problem'},
  ],
};

/// Descriptor for `PSORequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pSORequestDescriptor = $convert.base64Decode(
    'CgpQU09SZXF1ZXN0EiMKDW51bV9wYXJ0aWNsZXMYASABKAVSDG51bVBhcnRpY2xlcxIeCgppdG'
    'VyYXRpb25zGAIgASgFUgppdGVyYXRpb25zEg4KAmMxGAMgASgBUgJjMRIOCgJjMhgEIAEoAVIC'
    'YzISDAoBdxgFIAEoAVIBdxIhCgxib3VuZGFyeV9taW4YBiABKAFSC2JvdW5kYXJ5TWluEiEKDG'
    'JvdW5kYXJ5X21heBgHIAEoAVILYm91bmRhcnlNYXgSEgoEc2VlZBgIIAEoA1IEc2VlZBI+Cgdw'
    'cm9ibGVtGAogASgLMiQub3B0aW1pemF0aW9uLnYxLk9wdGltaXphdGlvblByb2JsZW1SB3Byb2'
    'JsZW0=');

@$core.Deprecated('Use pSOResponseDescriptor instead')
const PSOResponse$json = {
  '1': 'PSOResponse',
  '2': [
    {'1': 'best_position', '3': 1, '4': 1, '5': 1, '10': 'bestPosition'},
    {'1': 'best_value', '3': 2, '4': 1, '5': 1, '10': 'bestValue'},
    {'1': 'iterations_completed', '3': 3, '4': 1, '5': 5, '10': 'iterationsCompleted'},
  ],
};

/// Descriptor for `PSOResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pSOResponseDescriptor = $convert.base64Decode(
    'CgtQU09SZXNwb25zZRIjCg1iZXN0X3Bvc2l0aW9uGAEgASgBUgxiZXN0UG9zaXRpb24SHQoKYm'
    'VzdF92YWx1ZRgCIAEoAVIJYmVzdFZhbHVlEjEKFGl0ZXJhdGlvbnNfY29tcGxldGVkGAMgASgF'
    'UhNpdGVyYXRpb25zQ29tcGxldGVk');

const $core.Map<$core.String, $core.dynamic> OptimizationServiceBase$json = {
  '1': 'OptimizationService',
  '2': [
    {'1': 'ParetoFrontier', '2': '.optimization.v1.AddToFrontierRequest', '3': '.optimization.v1.ParetoFrontierResponse'},
    {'1': 'MonteCarloSampling', '2': '.optimization.v1.MonteCarloRequest', '3': '.optimization.v1.MonteCarloResponse'},
    {'1': 'GeneticAlgorithm', '2': '.optimization.v1.GARequest', '3': '.optimization.v1.GAResponse'},
    {'1': 'SimulatedAnnealing', '2': '.optimization.v1.SARequest', '3': '.optimization.v1.SAResponse'},
    {'1': 'ParticleSwarmOptimization', '2': '.optimization.v1.PSORequest', '3': '.optimization.v1.PSOResponse'},
  ],
};

@$core.Deprecated('Use optimizationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> OptimizationServiceBase$messageJson = {
  '.optimization.v1.AddToFrontierRequest': AddToFrontierRequest$json,
  '.optimization.v1.Objective': Objective$json,
  '.optimization.v1.Solution': Solution$json,
  '.optimization.v1.MultiObjectiveOptimizationInput': $1.MultiObjectiveOptimizationInput$json,
  '.optimization.v1.OptimizationProblem': $1.OptimizationProblem$json,
  '.optimization.v1.DecisionVariable': $1.DecisionVariable$json,
  '.common.v1.NumericRange': $0.NumericRange$json,
  '.optimization.v1.ObjectiveDefinition': $1.ObjectiveDefinition$json,
  '.optimization.v1.ConstraintDefinition': $1.ConstraintDefinition$json,
  '.common.v1.ContractMetadata': $0.ContractMetadata$json,
  '.common.v1.ApiVersion': $0.ApiVersion$json,
  '.google.protobuf.Timestamp': $2.Timestamp$json,
  '.optimization.v1.CandidateSolution': $1.CandidateSolution$json,
  '.optimization.v1.CandidateSolution.AssignmentsEntry': $1.CandidateSolution_AssignmentsEntry$json,
  '.optimization.v1.CandidateSolution.ObjectiveValuesEntry': $1.CandidateSolution_ObjectiveValuesEntry$json,
  '.optimization.v1.CandidateSolution.ConstraintViolationsEntry': $1.CandidateSolution_ConstraintViolationsEntry$json,
  '.optimization.v1.ParetoFrontierResponse': ParetoFrontierResponse$json,
  '.optimization.v1.MonteCarloRequest': MonteCarloRequest$json,
  '.optimization.v1.Distribution': Distribution$json,
  '.optimization.v1.UncertaintyModel': $1.UncertaintyModel$json,
  '.optimization.v1.DistributionDefinition': $1.DistributionDefinition$json,
  '.optimization.v1.DistributionModel': $1.DistributionModel$json,
  '.optimization.v1.MonteCarloResponse': MonteCarloResponse$json,
  '.optimization.v1.GARequest': GARequest$json,
  '.optimization.v1.GAResponse': GAResponse$json,
  '.optimization.v1.SARequest': SARequest$json,
  '.optimization.v1.SAResponse': SAResponse$json,
  '.optimization.v1.PSORequest': PSORequest$json,
  '.optimization.v1.PSOResponse': PSOResponse$json,
};

/// Descriptor for `OptimizationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List optimizationServiceDescriptor = $convert.base64Decode(
    'ChNPcHRpbWl6YXRpb25TZXJ2aWNlEmAKDlBhcmV0b0Zyb250aWVyEiUub3B0aW1pemF0aW9uLn'
    'YxLkFkZFRvRnJvbnRpZXJSZXF1ZXN0Gicub3B0aW1pemF0aW9uLnYxLlBhcmV0b0Zyb250aWVy'
    'UmVzcG9uc2USXQoSTW9udGVDYXJsb1NhbXBsaW5nEiIub3B0aW1pemF0aW9uLnYxLk1vbnRlQ2'
    'FybG9SZXF1ZXN0GiMub3B0aW1pemF0aW9uLnYxLk1vbnRlQ2FybG9SZXNwb25zZRJLChBHZW5l'
    'dGljQWxnb3JpdGhtEhoub3B0aW1pemF0aW9uLnYxLkdBUmVxdWVzdBobLm9wdGltaXphdGlvbi'
    '52MS5HQVJlc3BvbnNlEk0KElNpbXVsYXRlZEFubmVhbGluZxIaLm9wdGltaXphdGlvbi52MS5T'
    'QVJlcXVlc3QaGy5vcHRpbWl6YXRpb24udjEuU0FSZXNwb25zZRJWChlQYXJ0aWNsZVN3YXJtT3'
    'B0aW1pemF0aW9uEhsub3B0aW1pemF0aW9uLnYxLlBTT1JlcXVlc3QaHC5vcHRpbWl6YXRpb24u'
    'djEuUFNPUmVzcG9uc2U=');

