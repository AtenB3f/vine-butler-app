sealed class ApiException implements Exception {
  const ApiException([this.message]);

  final String? message;

  const factory ApiException.network([String? message]) = NetworkApiException;
  const factory ApiException.unauthorized([String? message]) = UnauthorizedApiException;
  const factory ApiException.quotaExceeded([String? message]) = QuotaExceededApiException;
  const factory ApiException.badRequest([String? message]) = BadRequestApiException;
  const factory ApiException.server([String? message]) = ServerApiException;
  const factory ApiException.unknown([String? message]) = UnknownApiException;

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
