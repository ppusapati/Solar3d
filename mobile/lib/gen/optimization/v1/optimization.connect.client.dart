//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization.proto
//

import "package:connectrpc/connect.dart" as connect;
import "optimization.pb.dart" as optimizationv1optimization;
import "optimization.connect.spec.dart" as specs;

extension type OptimizationServiceClient (connect.Transport _transport) {
  Future<optimizationv1optimization.ParetoFrontierResponse> paretoFrontier(
    optimizationv1optimization.AddToFrontierRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OptimizationService.paretoFrontier,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<optimizationv1optimization.MonteCarloResponse> monteCarloSampling(
    optimizationv1optimization.MonteCarloRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OptimizationService.monteCarloSampling,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<optimizationv1optimization.GAResponse> geneticAlgorithm(
    optimizationv1optimization.GARequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OptimizationService.geneticAlgorithm,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<optimizationv1optimization.SAResponse> simulatedAnnealing(
    optimizationv1optimization.SARequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OptimizationService.simulatedAnnealing,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<optimizationv1optimization.PSOResponse> particleSwarmOptimization(
    optimizationv1optimization.PSORequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.OptimizationService.particleSwarmOptimization,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
