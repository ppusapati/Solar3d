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

class ConnectRpcTransport {
  final http.Client _httpClient;
  final String baseUrl;

  ConnectRpcTransport({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  Future<Map<String, dynamic>> unary({
    required String service,
    required String method,
    required Map<String, dynamic> request,
  }) async {
    final url = Uri.parse('$baseUrl/$service/$method');

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
