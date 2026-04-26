//
//  Generated code. Do not modify.
//  source: extended/v1/extended.proto
//

import "package:connectrpc/connect.dart" as connect;
import "extended.pb.dart" as extendedv1extended;
import "extended.connect.spec.dart" as specs;

/// ExtendedService exposes advanced compute modules built on extended-compute.
extension type ExtendedServiceClient (connect.Transport _transport) {
  /// SolarTransposition computes plane-of-array irradiance and incidence terms.
  Future<extendedv1extended.SolarTranspositionResponse> solarTransposition(
    extendedv1extended.SolarTranspositionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.solarTransposition,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// FinancialMetrics computes investment performance indicators for a project.
  Future<extendedv1extended.FinancialMetricsResponse> financialMetrics(
    extendedv1extended.FinancialMetricsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.financialMetrics,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CompareFinancialScenarios evaluates a full scenario set against engineering and finance assumptions.
  Future<extendedv1extended.CompareFinancialScenariosResponse> compareFinancialScenarios(
    extendedv1extended.CompareFinancialScenariosRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.compareFinancialScenarios,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ClimateImpact aggregates climate uncertainty factors into a unified impact view.
  Future<extendedv1extended.ClimateImpactResponse> climateImpact(
    extendedv1extended.ClimateImpactRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.climateImpact,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// SaveFinancialScenarioSet stores scenario assumptions for a specific project/layout.
  Future<extendedv1extended.SaveFinancialScenarioSetResponse> saveFinancialScenarioSet(
    extendedv1extended.SaveFinancialScenarioSetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.saveFinancialScenarioSet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetFinancialScenarioSet retrieves saved scenario assumptions for a specific project/layout.
  Future<extendedv1extended.GetFinancialScenarioSetResponse> getFinancialScenarioSet(
    extendedv1extended.GetFinancialScenarioSetRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.getFinancialScenarioSet,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListFinancialScenarioSets lists all saved scenario sets for a project.
  Future<extendedv1extended.ListFinancialScenarioSetsResponse> listFinancialScenarioSets(
    extendedv1extended.ListFinancialScenarioSetsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.listFinancialScenarioSets,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetFinancialScenarioSetVersions returns the version history of scenario assumptions for a layout.
  Future<extendedv1extended.GetFinancialScenarioSetVersionsResponse> getFinancialScenarioSetVersions(
    extendedv1extended.GetFinancialScenarioSetVersionsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.getFinancialScenarioSetVersions,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CalculateInterRowShading computes inter-row shading loss for a fixed-tilt or single-axis tracker array.
  Future<extendedv1extended.CalculateInterRowShadingResponse> calculateInterRowShading(
    extendedv1extended.CalculateInterRowShadingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.calculateInterRowShading,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CalculateYieldUncertainty estimates P50/P90/P99 annual yield from a base energy estimate and uncertainty inputs.
  Future<extendedv1extended.CalculateYieldUncertaintyResponse> calculateYieldUncertainty(
    extendedv1extended.CalculateYieldUncertaintyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtendedService.calculateYieldUncertainty,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
