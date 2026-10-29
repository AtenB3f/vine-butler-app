import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class ClovaStudioAuthInterceptor extends Interceptor {
  ClovaStudioAuthInterceptor({required this.apiKey});

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $apiKey';
    options.headers['X-NCP-CLOVASTUDIO-REQUEST-ID'] = const Uuid().v4();
    handler.next(options);
  }
}
