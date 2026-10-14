import 'package:dio/dio.dart';

class NaverMapsAuthInterceptor extends Interceptor {
  NaverMapsAuthInterceptor({required this.clientId, required this.clientSecret});

  final String clientId;
  final String clientSecret;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-ncp-apigw-api-key-id'] = clientId;
    options.headers['x-ncp-apigw-api-key'] = clientSecret;
    handler.next(options);
  }
}
