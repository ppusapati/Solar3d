//
//  Generated code. Do not modify.
//  source: simulation/v1/simulation.proto
//

import "package:connectrpc/connect.dart" as connect;
import "simulation.pb.dart" as simulationv1simulation;

abstract final class SimulationService {
  /// Fully-qualified name of the SimulationService service.
  static const name = 'simulation.v1.SimulationService';

  static const createSimulation = connect.Spec(
    '/$name/CreateSimulation',
    connect.StreamType.unary,
    simulationv1simulation.CreateSimulationRequest.new,
    simulationv1simulation.CreateSimulationResponse.new,
  );

  static const getSimulation = connect.Spec(
    '/$name/GetSimulation',
    connect.StreamType.unary,
    simulationv1simulation.GetSimulationRequest.new,
    simulationv1simulation.GetSimulationResponse.new,
  );

  static const listSimulations = connect.Spec(
    '/$name/ListSimulations',
    connect.StreamType.unary,
    simulationv1simulation.ListSimulationsRequest.new,
    simulationv1simulation.ListSimulationsResponse.new,
  );

  static const runSimulation = connect.Spec(
    '/$name/RunSimulation',
    connect.StreamType.unary,
    simulationv1simulation.RunSimulationRequest.new,
    simulationv1simulation.RunSimulationResponse.new,
  );

  static const getSunPosition = connect.Spec(
    '/$name/GetSunPosition',
    connect.StreamType.unary,
    simulationv1simulation.GetSunPositionRequest.new,
    simulationv1simulation.GetSunPositionResponse.new,
  );

  static const getShadowMap = connect.Spec(
    '/$name/GetShadowMap',
    connect.StreamType.unary,
    simulationv1simulation.GetShadowMapRequest.new,
    simulationv1simulation.GetShadowMapResponse.new,
  );

  static const deleteSimulation = connect.Spec(
    '/$name/DeleteSimulation',
    connect.StreamType.unary,
    simulationv1simulation.DeleteSimulationRequest.new,
    simulationv1simulation.DeleteSimulationResponse.new,
  );
}
/// SimulationComputeService exposes only stateless compute-style simulation operations.
/// Lifecycle/storage operations remain in SimulationService.
abstract final class SimulationComputeService {
  /// Fully-qualified name of the SimulationComputeService service.
  static const name = 'simulation.v1.SimulationComputeService';

  static const getSunPosition = connect.Spec(
    '/$name/GetSunPosition',
    connect.StreamType.unary,
    simulationv1simulation.GetSunPositionRequest.new,
    simulationv1simulation.GetSunPositionResponse.new,
  );

  static const getShadowMap = connect.Spec(
    '/$name/GetShadowMap',
    connect.StreamType.unary,
    simulationv1simulation.GetShadowMapRequest.new,
    simulationv1simulation.GetShadowMapResponse.new,
  );
}
