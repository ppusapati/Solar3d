/// Typed exception hierarchy for Solar3D mobile service layer.
///
/// These exceptions are thrown by service clients and caught by Blocs to
/// produce user-friendly error messages. Each exception carries a machine-
/// readable [code] for programmatic handling and a human-readable [message]
/// for display.
library exceptions;

/// Base exception for all Solar3D service errors.
class Solar3DException implements Exception {
  final String code;
  final String message;
  final dynamic cause;

  const Solar3DException({
    required this.code,
    required this.message,
    this.cause,
  });

  @override
  String toString() => 'Solar3DException($code): $message';
}

/// Thrown when the server returns a 400-class error (invalid input).
class InvalidInputException extends Solar3DException {
  final String? field;

  const InvalidInputException({
    required String message,
    this.field,
    dynamic cause,
  }) : super(code: 'INVALID_INPUT', message: message, cause: cause);

  @override
  String toString() =>
      field != null ? 'InvalidInputException($field): $message' : 'InvalidInputException: $message';
}

/// Thrown when a resource is not found (404 / NOT_FOUND).
class NotFoundException extends Solar3DException {
  final String resourceType;
  final String? resourceId;

  const NotFoundException({
    required this.resourceType,
    this.resourceId,
  }) : super(
          code: 'NOT_FOUND',
          message: resourceId != null
              ? '$resourceType $resourceId not found'
              : '$resourceType not found',
        );
}

/// Thrown when the user is not authenticated (401 / UNAUTHENTICATED).
class UnauthenticatedException extends Solar3DException {
  const UnauthenticatedException()
      : super(code: 'UNAUTHENTICATED', message: 'Please sign in to continue');
}

/// Thrown when the user lacks permission (403 / PERMISSION_DENIED).
class PermissionDeniedException extends Solar3DException {
  const PermissionDeniedException({String? action})
      : super(
          code: 'PERMISSION_DENIED',
          message: action != null
              ? 'You do not have permission to $action'
              : 'Permission denied',
        );
}

/// Thrown when a precondition fails (412 / FAILED_PRECONDITION).
class PreconditionFailedException extends Solar3DException {
  const PreconditionFailedException({required String message})
      : super(code: 'FAILED_PRECONDITION', message: message);
}

/// Thrown when the server is unavailable or the device is offline.
class NetworkException extends Solar3DException {
  final bool isOffline;

  const NetworkException({
    this.isOffline = false,
    String message = 'Network error',
    dynamic cause,
  }) : super(code: 'NETWORK_ERROR', message: message, cause: cause);
}

/// Thrown when the server returns a 500-class error.
class ServerException extends Solar3DException {
  final int? statusCode;

  const ServerException({
    this.statusCode,
    String message = 'Server error — please try again',
    dynamic cause,
  }) : super(code: 'SERVER_ERROR', message: message, cause: cause);
}

/// Thrown when the request times out.
class TimeoutException extends Solar3DException {
  const TimeoutException({
    String message = 'Request timed out — check your connection',
  }) : super(code: 'TIMEOUT', message: message);
}

/// Maps a ConnectRPC error code to the appropriate typed exception.
Solar3DException mapConnectError(String connectCode, String message) {
  switch (connectCode) {
    case 'invalid_argument':
      return InvalidInputException(message: message);
    case 'not_found':
      return NotFoundException(resourceType: 'Resource');
    case 'unauthenticated':
      return const UnauthenticatedException();
    case 'permission_denied':
      return const PermissionDeniedException();
    case 'failed_precondition':
      return PreconditionFailedException(message: message);
    case 'unavailable':
      return NetworkException(message: message);
    case 'deadline_exceeded':
      return const TimeoutException();
    default:
      return ServerException(message: message);
  }
}

/// Returns a user-friendly error message suitable for display in a toast
/// or error dialog.
String userFriendlyMessage(Solar3DException e) {
  switch (e.code) {
    case 'INVALID_INPUT':
      return e.message;
    case 'NOT_FOUND':
      return e.message;
    case 'UNAUTHENTICATED':
      return 'Please sign in to continue';
    case 'PERMISSION_DENIED':
      return 'You don\'t have access to this feature';
    case 'FAILED_PRECONDITION':
      return e.message;
    case 'NETWORK_ERROR':
      return 'Unable to connect — check your internet';
    case 'SERVER_ERROR':
      return 'Something went wrong — please try again';
    case 'TIMEOUT':
      return 'Request timed out — please try again';
    default:
      return 'An unexpected error occurred';
  }
}
