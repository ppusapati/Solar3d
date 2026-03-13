import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static late SharedPreferences _prefs;

  static const String defaultApiBaseUrl = 'http://localhost:8080';
  static const String defaultWsUrl = 'ws://localhost:8090';

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get apiBaseUrl =>
      _prefs.getString('api_base_url') ?? defaultApiBaseUrl;

  static set apiBaseUrl(String url) =>
      _prefs.setString('api_base_url', url);

  static String get wsUrl =>
      _prefs.getString('ws_url') ?? defaultWsUrl;

  static set wsUrl(String url) =>
      _prefs.setString('ws_url', url);

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
