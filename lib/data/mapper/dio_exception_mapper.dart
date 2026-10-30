import 'package:dio/dio.dart';
import 'package:vine_butler/domain/exception/api_exception.dart';

extension DioExceptionMapper on DioException {
  ApiException toDomain() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return ApiException.network(message);

      case DioExceptionType.badResponse:
        return switch (response?.statusCode) {
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
}
