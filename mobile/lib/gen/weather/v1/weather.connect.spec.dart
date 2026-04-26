//
//  Generated code. Do not modify.
//  source: weather/v1/weather.proto
//

import "package:connectrpc/connect.dart" as connect;
import "weather.pb.dart" as weatherv1weather;

/// WeatherService provides solar irradiance data from multiple upstream sources
/// (PVGIS, NASA POWER, NSRDB, ERA5) and offers TMY file ingestion, hourly
/// timeseries retrieval, and probabilistic yield exceedance calculations.
abstract final class WeatherService {
  /// Fully-qualified name of the WeatherService service.
  static const name = 'weather.v1.WeatherService';

  /// FetchIrradiance retrieves hourly irradiance data for a location from the
  /// specified upstream source. Returns a timeseries of GHI/DNI/DHI plus
  /// ambient temperature. Results are cached server-side after the first fetch.
  static const fetchIrradiance = connect.Spec(
    '/$name/FetchIrradiance',
    connect.StreamType.unary,
    weatherv1weather.FetchIrradianceRequest.new,
    weatherv1weather.FetchIrradianceResponse.new,
  );

  /// ImportTMY ingests an uploaded TMY file (EPW, TM2, TM3, or CSV) and stores
  /// the parsed hourly records for the site.
  static const importTMY = connect.Spec(
    '/$name/ImportTMY',
    connect.StreamType.unary,
    weatherv1weather.ImportTMYRequest.new,
    weatherv1weather.ImportTMYResponse.new,
  );

  /// GetHourlyTimeseries returns previously-fetched or imported hourly
  /// irradiance data for a site.
  static const getHourlyTimeseries = connect.Spec(
    '/$name/GetHourlyTimeseries',
    connect.StreamType.unary,
    weatherv1weather.GetHourlyTimeseriesRequest.new,
    weatherv1weather.GetHourlyTimeseriesResponse.new,
  );

  /// ListSiteWeather returns all weather datasets available for a project.
  static const listSiteWeather = connect.Spec(
    '/$name/ListSiteWeather',
    connect.StreamType.unary,
    weatherv1weather.ListSiteWeatherRequest.new,
    weatherv1weather.ListSiteWeatherResponse.new,
  );

  /// CalculateYieldExceedance computes P50/P90/P99 exceedance probabilities
  /// for annual energy yield based on the GHI timeseries of a site.
  static const calculateYieldExceedance = connect.Spec(
    '/$name/CalculateYieldExceedance',
    connect.StreamType.unary,
    weatherv1weather.CalculateYieldExceedanceRequest.new,
    weatherv1weather.CalculateYieldExceedanceResponse.new,
  );

  /// DeleteSiteWeather removes a weather dataset for a site.
  static const deleteSiteWeather = connect.Spec(
    '/$name/DeleteSiteWeather',
    connect.StreamType.unary,
    weatherv1weather.DeleteSiteWeatherRequest.new,
    weatherv1weather.DeleteSiteWeatherResponse.new,
  );
}
