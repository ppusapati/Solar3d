import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../config/app_config.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

class ConnectRpcException implements Exception {
  final String code;
  final String message;
  final int? httpStatus;

  ConnectRpcException(this.code, this.message, {this.httpStatus});

  @override
  String toString() => 'ConnectRpcException($code): $message';
}

/// Maps service package prefixes to their backend ports.
/// In production, a reverse proxy typically routes all services
/// through a single endpoint; this map supports direct connections
/// during development.
const _servicePortMap = {
  'solar.project': 8080,
  'solar.terrain': 8081,
  'solar.layout': 8082,
  'solar.simulation': 8083,
  'solar.electrical': 8084,
  'solar.routing': 8085,
  'solar.report': 8086,
  'solar.asset': 8087,
};

class ConnectRpcTransport {
  final http.Client _httpClient;
  final String baseUrl;

  /// When true, routes each service to its own port (dev mode).
  /// When false, sends all requests to [baseUrl] (reverse proxy mode).
  final bool useServicePorts;

  ConnectRpcTransport({
    http.Client? httpClient,
    String? baseUrl,
    this.useServicePorts = false,
  })  : _httpClient = httpClient ?? http.Client(),
        baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  String _resolveBaseUrl(String service) {
    if (!useServicePorts) return baseUrl;

    final uri = Uri.parse(baseUrl);
    for (final entry in _servicePortMap.entries) {
      if (service.startsWith(entry.key)) {
        return uri.replace(port: entry.value).toString();
      }
    }
    return baseUrl;
  }

  Future<Map<String, dynamic>> unary({
    required String service,
    required String method,
    required Map<String, dynamic> request,
  }) async {
    final resolvedBase = _resolveBaseUrl(service);
    final url = Uri.parse('$resolvedBase/$service/$method');

    _logger.d('ConnectRPC -> $service/$method');

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Connect-Protocol-Version': '1',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    final error = _parseError(response);
    _logger.e('ConnectRPC error: ${error.code} - ${error.message}');
    throw error;
  }

  ConnectRpcException _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ConnectRpcException(
        body['code'] as String? ?? 'unknown',
        body['message'] as String? ?? 'Unknown error',
        httpStatus: response.statusCode,
      );
    } catch (_) {
      return ConnectRpcException(
        'unknown',
        'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        httpStatus: response.statusCode,
      );
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
