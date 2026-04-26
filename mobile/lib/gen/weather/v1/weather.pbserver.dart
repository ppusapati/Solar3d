//
//  Generated code. Do not modify.
//  source: weather/v1/weather.proto
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

import 'weather.pb.dart' as $1;
import 'weather.pbjson.dart';

export 'weather.pb.dart';

abstract class WeatherServiceBase extends $pb.GeneratedService {
  $async.Future<$1.FetchIrradianceResponse> fetchIrradiance($pb.ServerContext ctx, $1.FetchIrradianceRequest request);
  $async.Future<$1.ImportTMYResponse> importTMY($pb.ServerContext ctx, $1.ImportTMYRequest request);
  $async.Future<$1.GetHourlyTimeseriesResponse> getHourlyTimeseries($pb.ServerContext ctx, $1.GetHourlyTimeseriesRequest request);
  $async.Future<$1.ListSiteWeatherResponse> listSiteWeather($pb.ServerContext ctx, $1.ListSiteWeatherRequest request);
  $async.Future<$1.CalculateYieldExceedanceResponse> calculateYieldExceedance($pb.ServerContext ctx, $1.CalculateYieldExceedanceRequest request);
  $async.Future<$1.DeleteSiteWeatherResponse> deleteSiteWeather($pb.ServerContext ctx, $1.DeleteSiteWeatherRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'FetchIrradiance': return $1.FetchIrradianceRequest();
      case 'ImportTMY': return $1.ImportTMYRequest();
      case 'GetHourlyTimeseries': return $1.GetHourlyTimeseriesRequest();
      case 'ListSiteWeather': return $1.ListSiteWeatherRequest();
      case 'CalculateYieldExceedance': return $1.CalculateYieldExceedanceRequest();
      case 'DeleteSiteWeather': return $1.DeleteSiteWeatherRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'FetchIrradiance': return this.fetchIrradiance(ctx, request as $1.FetchIrradianceRequest);
      case 'ImportTMY': return this.importTMY(ctx, request as $1.ImportTMYRequest);
      case 'GetHourlyTimeseries': return this.getHourlyTimeseries(ctx, request as $1.GetHourlyTimeseriesRequest);
      case 'ListSiteWeather': return this.listSiteWeather(ctx, request as $1.ListSiteWeatherRequest);
      case 'CalculateYieldExceedance': return this.calculateYieldExceedance(ctx, request as $1.CalculateYieldExceedanceRequest);
      case 'DeleteSiteWeather': return this.deleteSiteWeather(ctx, request as $1.DeleteSiteWeatherRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => WeatherServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => WeatherServiceBase$messageJson;
}

