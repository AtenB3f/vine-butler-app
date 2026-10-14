import 'package:dio/dio.dart';

sealed class ApiException implements Exception {
  const ApiException([this.message]);

  final String? message;

  const factory ApiException.network([String? message]) = NetworkApiException;
  const factory ApiException.unauthorized([String? message]) = UnauthorizedApiException;
  const factory ApiException.quotaExceeded([String? message]) = QuotaExceededApiException;
  const factory ApiException.badRequest([String? message]) = BadRequestApiException;
  const factory ApiException.server([String? message]) = ServerApiException;
  const factory ApiException.unknown([String? message]) = UnknownApiException;

  factory ApiException.fromDio(DioException exception) {
    final message = exception.message;
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return ApiException.network(message);
      case DioExceptionType.badResponse:
        return switch (exception.response?.statusCode) {
          400 || 404 || 413 => ApiException.badRequest(message),
          401 => ApiException.unauthorized(message),
          429 => ApiException.quotaExceeded(message),
          final int code when code >= 500 => ApiException.server(message),
          _ => ApiException.unknown(message),
        };
      case DioExceptionType.transformTimeout:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ApiException.unknown(message);
    }
  }

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkApiException extends ApiException {
  const NetworkApiException([super.message]);
}

class UnauthorizedApiException extends ApiException {
  const UnauthorizedApiException([super.message]);
}

class QuotaExceededApiException extends ApiException {
  const QuotaExceededApiException([super.message]);
}

class BadRequestApiException extends ApiException {
  const BadRequestApiException([super.message]);
}

class ServerApiException extends ApiException {
  const ServerApiException([super.message]);
}

class UnknownApiException extends ApiException {
  const UnknownApiException([super.message]);
}
