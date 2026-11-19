/// Base exception for all app-level errors.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => '$runtimeType: $message';
}

/// No network connectivity or connection failed.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No network connection',
    dynamic originalError,
  ]) : super(originalError: originalError);
}

/// Request timed out.
class TimeoutException extends AppException {
  const TimeoutException([
    super.message = 'Request timed out',
    dynamic originalError,
  ]) : super(originalError: originalError);
}

/// Server returned 5xx.
class ServerException extends AppException {
  const ServerException(
    super.message, {
    super.statusCode,
    super.originalError,
  });
}

/// Server returned 422 — validation error.
class ValidationException extends AppException {
  final String? errorCode;

  const ValidationException(
    super.message, {
    this.errorCode,
    super.statusCode = 422,
    super.originalError,
  });
}

/// Server returned 409 — conflict / duplicate.
class ConflictException extends AppException {
  const ConflictException(
    super.message, {
    super.statusCode = 409,
    super.originalError,
  });
}
