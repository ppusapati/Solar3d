//
//  Generated code. Do not modify.
//  source: optimization/v1/optimization.proto
//

import "package:connectrpc/connect.dart" as connect;
import "optimization.pb.dart" as optimizationv1optimization;

abstract final class OptimizationService {
  /// Fully-qualified name of the OptimizationService service.
  static const name = 'optimization.v1.OptimizationService';

  static const paretoFrontier = connect.Spec(
    '/$name/ParetoFrontier',
    connect.StreamType.unary,
    optimizationv1optimization.AddToFrontierRequest.new,
    optimizationv1optimization.ParetoFrontierResponse.new,
  );

  static const monteCarloSampling = connect.Spec(
    '/$name/MonteCarloSampling',
    connect.StreamType.unary,
    optimizationv1optimization.MonteCarloRequest.new,
    optimizationv1optimization.MonteCarloResponse.new,
  );

  static const geneticAlgorithm = connect.Spec(
    '/$name/GeneticAlgorithm',
    connect.StreamType.unary,
    optimizationv1optimization.GARequest.new,
    optimizationv1optimization.GAResponse.new,
  );

  static const simulatedAnnealing = connect.Spec(
    '/$name/SimulatedAnnealing',
    connect.StreamType.unary,
    optimizationv1optimization.SARequest.new,
    optimizationv1optimization.SAResponse.new,
  );

  static const particleSwarmOptimization = connect.Spec(
    '/$name/ParticleSwarmOptimization',
    connect.StreamType.unary,
    optimizationv1optimization.PSORequest.new,
    optimizationv1optimization.PSOResponse.new,
  );
}
