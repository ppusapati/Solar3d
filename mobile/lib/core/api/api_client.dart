import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectionTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _retryInterceptor(),
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
      ),
    ]);
  }

  Dio get dio => _dio;

  InterceptorsWrapper _retryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (_shouldRetry(error)) {
          try {
            final response = await _retry(error.requestOptions);
            handler.resolve(response);
            return;
          } catch (_) {
            // Fall through to reject
          }
        }
        handler.next(error);
      },
    );
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        (error.response?.statusCode ?? 0) >= 500;
  }

  Future<Response> _retry(RequestOptions options) async {
    for (int i = 0; i < AppConfig.maxRetries; i++) {
      await Future.delayed(AppConfig.retryDelay * (i + 1));
      try {
        return await _dio.fetch(options);
      } catch (e) {
        if (i == AppConfig.maxRetries - 1) rethrow;
      }
    }
    throw ApiException('Max retries exceeded');
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return parser(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return parser(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      return parser(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data?['message'] as String? ??
        error.response?.data?['error'] as String? ??
        error.message ??
        'Unknown error';

    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 409:
        return ConflictException(message);
      case 422:
        return ValidationException(message);
      case 500:
        return ServerException(message);
      default:
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          return TimeoutException(message);
        }
        if (error.type == DioExceptionType.connectionError) {
          return NetworkException(
              'Unable to connect to server. Check your network connection.');
        }
        return ApiException(message, statusCode: statusCode);
    }
  }
}
