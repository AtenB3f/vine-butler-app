import 'package:dio/dio.dart';

class JusoAuthInterceptor extends Interceptor {
  JusoAuthInterceptor({required this.confmKey});

  final String confmKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['confmKey'] = confmKey;
    options.queryParameters['resultType'] = 'json';
    handler.next(options);
  }
}
