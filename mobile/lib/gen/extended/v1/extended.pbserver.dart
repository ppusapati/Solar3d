//
//  Generated code. Do not modify.
//  source: extended/v1/extended.proto
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

import 'extended.pb.dart' as $0;
import 'extended.pbjson.dart';

export 'extended.pb.dart';

abstract class ExtendedServiceBase extends $pb.GeneratedService {
  $async.Future<$0.SolarTranspositionResponse> solarTransposition($pb.ServerContext ctx, $0.SolarTranspositionRequest request);
  $async.Future<$0.FinancialMetricsResponse> financialMetrics($pb.ServerContext ctx, $0.FinancialMetricsRequest request);
  $async.Future<$0.CompareFinancialScenariosResponse> compareFinancialScenarios($pb.ServerContext ctx, $0.CompareFinancialScenariosRequest request);
  $async.Future<$0.ClimateImpactResponse> climateImpact($pb.ServerContext ctx, $0.ClimateImpactRequest request);
  $async.Future<$0.SaveFinancialScenarioSetResponse> saveFinancialScenarioSet($pb.ServerContext ctx, $0.SaveFinancialScenarioSetRequest request);
  $async.Future<$0.GetFinancialScenarioSetResponse> getFinancialScenarioSet($pb.ServerContext ctx, $0.GetFinancialScenarioSetRequest request);
  $async.Future<$0.ListFinancialScenarioSetsResponse> listFinancialScenarioSets($pb.ServerContext ctx, $0.ListFinancialScenarioSetsRequest request);
  $async.Future<$0.GetFinancialScenarioSetVersionsResponse> getFinancialScenarioSetVersions($pb.ServerContext ctx, $0.GetFinancialScenarioSetVersionsRequest request);
  $async.Future<$0.CalculateInterRowShadingResponse> calculateInterRowShading($pb.ServerContext ctx, $0.CalculateInterRowShadingRequest request);
  $async.Future<$0.CalculateYieldUncertaintyResponse> calculateYieldUncertainty($pb.ServerContext ctx, $0.CalculateYieldUncertaintyRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SolarTransposition': return $0.SolarTranspositionRequest();
      case 'FinancialMetrics': return $0.FinancialMetricsRequest();
      case 'CompareFinancialScenarios': return $0.CompareFinancialScenariosRequest();
      case 'ClimateImpact': return $0.ClimateImpactRequest();
      case 'SaveFinancialScenarioSet': return $0.SaveFinancialScenarioSetRequest();
      case 'GetFinancialScenarioSet': return $0.GetFinancialScenarioSetRequest();
      case 'ListFinancialScenarioSets': return $0.ListFinancialScenarioSetsRequest();
      case 'GetFinancialScenarioSetVersions': return $0.GetFinancialScenarioSetVersionsRequest();
      case 'CalculateInterRowShading': return $0.CalculateInterRowShadingRequest();
      case 'CalculateYieldUncertainty': return $0.CalculateYieldUncertaintyRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SolarTransposition': return this.solarTransposition(ctx, request as $0.SolarTranspositionRequest);
      case 'FinancialMetrics': return this.financialMetrics(ctx, request as $0.FinancialMetricsRequest);
      case 'CompareFinancialScenarios': return this.compareFinancialScenarios(ctx, request as $0.CompareFinancialScenariosRequest);
      case 'ClimateImpact': return this.climateImpact(ctx, request as $0.ClimateImpactRequest);
      case 'SaveFinancialScenarioSet': return this.saveFinancialScenarioSet(ctx, request as $0.SaveFinancialScenarioSetRequest);
      case 'GetFinancialScenarioSet': return this.getFinancialScenarioSet(ctx, request as $0.GetFinancialScenarioSetRequest);
      case 'ListFinancialScenarioSets': return this.listFinancialScenarioSets(ctx, request as $0.ListFinancialScenarioSetsRequest);
      case 'GetFinancialScenarioSetVersions': return this.getFinancialScenarioSetVersions(ctx, request as $0.GetFinancialScenarioSetVersionsRequest);
      case 'CalculateInterRowShading': return this.calculateInterRowShading(ctx, request as $0.CalculateInterRowShadingRequest);
      case 'CalculateYieldUncertainty': return this.calculateYieldUncertainty(ctx, request as $0.CalculateYieldUncertaintyRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ExtendedServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ExtendedServiceBase$messageJson;
}

