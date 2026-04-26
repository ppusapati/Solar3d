//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization.proto
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

import 'optimization.pb.dart' as $3;
import 'optimization.pbjson.dart';

export 'optimization.pb.dart';

abstract class OptimizationServiceBase extends $pb.GeneratedService {
  $async.Future<$3.ParetoFrontierResponse> paretoFrontier($pb.ServerContext ctx, $3.AddToFrontierRequest request);
  $async.Future<$3.MonteCarloResponse> monteCarloSampling($pb.ServerContext ctx, $3.MonteCarloRequest request);
  $async.Future<$3.GAResponse> geneticAlgorithm($pb.ServerContext ctx, $3.GARequest request);
  $async.Future<$3.SAResponse> simulatedAnnealing($pb.ServerContext ctx, $3.SARequest request);
  $async.Future<$3.PSOResponse> particleSwarmOptimization($pb.ServerContext ctx, $3.PSORequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ParetoFrontier': return $3.AddToFrontierRequest();
      case 'MonteCarloSampling': return $3.MonteCarloRequest();
      case 'GeneticAlgorithm': return $3.GARequest();
      case 'SimulatedAnnealing': return $3.SARequest();
      case 'ParticleSwarmOptimization': return $3.PSORequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ParetoFrontier': return this.paretoFrontier(ctx, request as $3.AddToFrontierRequest);
      case 'MonteCarloSampling': return this.monteCarloSampling(ctx, request as $3.MonteCarloRequest);
      case 'GeneticAlgorithm': return this.geneticAlgorithm(ctx, request as $3.GARequest);
      case 'SimulatedAnnealing': return this.simulatedAnnealing(ctx, request as $3.SARequest);
      case 'ParticleSwarmOptimization': return this.particleSwarmOptimization(ctx, request as $3.PSORequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OptimizationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => OptimizationServiceBase$messageJson;
}

