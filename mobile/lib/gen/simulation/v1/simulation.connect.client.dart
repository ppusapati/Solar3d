//
//  Generated code. Do not modify.
//  source: simulation/v1/simulation.proto
//

import "package:connectrpc/connect.dart" as connect;
import "simulation.pb.dart" as simulationv1simulation;
import "simulation.connect.spec.dart" as specs;

extension type SimulationServiceClient (connect.Transport _transport) {
  Future<simulationv1simulation.CreateSimulationResponse> createSimulation(
    simulationv1simulation.CreateSimulationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationService.createSimulation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<simulationv1simulation.GetSimulationResponse> getSimulation(
    simulationv1simulation.GetSimulationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationService.getSimulation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<simulationv1simulation.ListSimulationsResponse> listSimulations(
    simulationv1simulation.ListSimulationsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationService.listSimulations,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<simulationv1simulation.RunSimulationResponse> runSimulation(
    simulationv1simulation.RunSimulationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationService.runSimulation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<simulationv1simulation.GetSunPositionResponse> getSunPosition(
    simulationv1simulation.GetSunPositionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationService.getSunPosition,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<simulationv1simulation.GetShadowMapResponse> getShadowMap(
    simulationv1simulation.GetShadowMapRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationService.getShadowMap,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<simulationv1simulation.DeleteSimulationResponse> deleteSimulation(
    simulationv1simulation.DeleteSimulationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationService.deleteSimulation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// SimulationComputeService exposes only stateless compute-style simulation operations.
/// Lifecycle/storage operations remain in SimulationService.
extension type SimulationComputeServiceClient (connect.Transport _transport) {
  Future<simulationv1simulation.GetSunPositionResponse> getSunPosition(
    simulationv1simulation.GetSunPositionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationComputeService.getSunPosition,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<simulationv1simulation.GetShadowMapResponse> getShadowMap(
    simulationv1simulation.GetShadowMapRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SimulationComputeService.getShadowMap,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
