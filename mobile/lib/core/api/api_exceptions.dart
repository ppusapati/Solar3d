class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class BadRequestException extends ApiException {
  BadRequestException(super.message) : super(statusCode: 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message) : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message) : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message) : super(statusCode: 404);
}

class ConflictException extends ApiException {
  ConflictException(super.message) : super(statusCode: 409);
}

class ValidationException extends ApiException {
  ValidationException(super.message) : super(statusCode: 422);
}

class ServerException extends ApiException {
  ServerException(super.message) : super(statusCode: 500);
}

class TimeoutException extends ApiException {
  TimeoutException(super.message) : super(statusCode: 408);
}

class NetworkException extends ApiException {
  NetworkException(super.message) : super(statusCode: null);
}
