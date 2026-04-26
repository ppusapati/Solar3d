//
//  Generated code. Do not modify.
//  source: weather/v1/weather.proto
//

import "package:connectrpc/connect.dart" as connect;
import "weather.pb.dart" as weatherv1weather;
import "weather.connect.spec.dart" as specs;

/// WeatherService provides solar irradiance data from multiple upstream sources
/// (PVGIS, NASA POWER, NSRDB, ERA5) and offers TMY file ingestion, hourly
/// timeseries retrieval, and probabilistic yield exceedance calculations.
extension type WeatherServiceClient (connect.Transport _transport) {
  /// FetchIrradiance retrieves hourly irradiance data for a location from the
  /// specified upstream source. Returns a timeseries of GHI/DNI/DHI plus
  /// ambient temperature. Results are cached server-side after the first fetch.
  Future<weatherv1weather.FetchIrradianceResponse> fetchIrradiance(
    weatherv1weather.FetchIrradianceRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WeatherService.fetchIrradiance,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ImportTMY ingests an uploaded TMY file (EPW, TM2, TM3, or CSV) and stores
  /// the parsed hourly records for the site.
  Future<weatherv1weather.ImportTMYResponse> importTMY(
    weatherv1weather.ImportTMYRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WeatherService.importTMY,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetHourlyTimeseries returns previously-fetched or imported hourly
  /// irradiance data for a site.
  Future<weatherv1weather.GetHourlyTimeseriesResponse> getHourlyTimeseries(
    weatherv1weather.GetHourlyTimeseriesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WeatherService.getHourlyTimeseries,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListSiteWeather returns all weather datasets available for a project.
  Future<weatherv1weather.ListSiteWeatherResponse> listSiteWeather(
    weatherv1weather.ListSiteWeatherRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WeatherService.listSiteWeather,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// CalculateYieldExceedance computes P50/P90/P99 exceedance probabilities
  /// for annual energy yield based on the GHI timeseries of a site.
  Future<weatherv1weather.CalculateYieldExceedanceResponse> calculateYieldExceedance(
    weatherv1weather.CalculateYieldExceedanceRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WeatherService.calculateYieldExceedance,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteSiteWeather removes a weather dataset for a site.
  Future<weatherv1weather.DeleteSiteWeatherResponse> deleteSiteWeather(
    weatherv1weather.DeleteSiteWeatherRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WeatherService.deleteSiteWeather,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
