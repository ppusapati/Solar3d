//
//  Generated code. Do not modify.
//  source: extended/v1/extended.proto
//

import "package:connectrpc/connect.dart" as connect;
import "extended.pb.dart" as extendedv1extended;

/// ExtendedService exposes advanced compute modules built on extended-compute.
abstract final class ExtendedService {
  /// Fully-qualified name of the ExtendedService service.
  static const name = 'extended.v1.ExtendedService';

  /// SolarTransposition computes plane-of-array irradiance and incidence terms.
  static const solarTransposition = connect.Spec(
    '/$name/SolarTransposition',
    connect.StreamType.unary,
    extendedv1extended.SolarTranspositionRequest.new,
    extendedv1extended.SolarTranspositionResponse.new,
  );

  /// FinancialMetrics computes investment performance indicators for a project.
  static const financialMetrics = connect.Spec(
    '/$name/FinancialMetrics',
    connect.StreamType.unary,
    extendedv1extended.FinancialMetricsRequest.new,
    extendedv1extended.FinancialMetricsResponse.new,
  );

  /// CompareFinancialScenarios evaluates a full scenario set against engineering and finance assumptions.
  static const compareFinancialScenarios = connect.Spec(
    '/$name/CompareFinancialScenarios',
    connect.StreamType.unary,
    extendedv1extended.CompareFinancialScenariosRequest.new,
    extendedv1extended.CompareFinancialScenariosResponse.new,
  );

  /// ClimateImpact aggregates climate uncertainty factors into a unified impact view.
  static const climateImpact = connect.Spec(
    '/$name/ClimateImpact',
    connect.StreamType.unary,
    extendedv1extended.ClimateImpactRequest.new,
    extendedv1extended.ClimateImpactResponse.new,
  );

  /// SaveFinancialScenarioSet stores scenario assumptions for a specific project/layout.
  static const saveFinancialScenarioSet = connect.Spec(
    '/$name/SaveFinancialScenarioSet',
    connect.StreamType.unary,
    extendedv1extended.SaveFinancialScenarioSetRequest.new,
    extendedv1extended.SaveFinancialScenarioSetResponse.new,
  );

  /// GetFinancialScenarioSet retrieves saved scenario assumptions for a specific project/layout.
  static const getFinancialScenarioSet = connect.Spec(
    '/$name/GetFinancialScenarioSet',
    connect.StreamType.unary,
    extendedv1extended.GetFinancialScenarioSetRequest.new,
    extendedv1extended.GetFinancialScenarioSetResponse.new,
  );

  /// ListFinancialScenarioSets lists all saved scenario sets for a project.
  static const listFinancialScenarioSets = connect.Spec(
    '/$name/ListFinancialScenarioSets',
    connect.StreamType.unary,
    extendedv1extended.ListFinancialScenarioSetsRequest.new,
    extendedv1extended.ListFinancialScenarioSetsResponse.new,
  );

  /// GetFinancialScenarioSetVersions returns the version history of scenario assumptions for a layout.
  static const getFinancialScenarioSetVersions = connect.Spec(
    '/$name/GetFinancialScenarioSetVersions',
    connect.StreamType.unary,
    extendedv1extended.GetFinancialScenarioSetVersionsRequest.new,
    extendedv1extended.GetFinancialScenarioSetVersionsResponse.new,
  );

  /// CalculateInterRowShading computes inter-row shading loss for a fixed-tilt or single-axis tracker array.
  static const calculateInterRowShading = connect.Spec(
    '/$name/CalculateInterRowShading',
    connect.StreamType.unary,
    extendedv1extended.CalculateInterRowShadingRequest.new,
    extendedv1extended.CalculateInterRowShadingResponse.new,
  );

  /// CalculateYieldUncertainty estimates P50/P90/P99 annual yield from a base energy estimate and uncertainty inputs.
  static const calculateYieldUncertainty = connect.Spec(
    '/$name/CalculateYieldUncertainty',
    connect.StreamType.unary,
    extendedv1extended.CalculateYieldUncertaintyRequest.new,
    extendedv1extended.CalculateYieldUncertaintyResponse.new,
  );
}
