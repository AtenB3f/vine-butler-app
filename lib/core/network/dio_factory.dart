import 'package:dio/dio.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/core/network/interceptors/clova_studio_auth_interceptor.dart';
import 'package:vine_butler/core/network/interceptors/juso_auth_interceptor.dart';
import 'package:vine_butler/core/network/interceptors/naver_maps_auth_interceptor.dart';

const _timeout = Duration(seconds: 10);

Dio createNaverMapsDio({
  String clientId = ApiEnv.naverMapsClientId,
  String clientSecret = ApiEnv.naverMapsClientSecret,
}) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://maps.apigw.ntruss.com',
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(NaverMapsAuthInterceptor(clientId: clientId, clientSecret: clientSecret));
}

Dio createJusoDio({String confmKey = ApiEnv.jusoConfmKey}) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://business.juso.go.kr',
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(JusoAuthInterceptor(confmKey: confmKey));
}

/// CLOVA Studio용 Dio 생성 함수
///
/// - `generationTimeout`: 생성형 응답 대기 시간 (블로그 글 생성에 수십 초가 걸릴 수 있음)
Dio createClovaStudioDio({String apiKey = ApiEnv.clovaStudioApiKey}) {
  const generationTimeout = Duration(seconds: 180);

  return Dio(
    BaseOptions(
      baseUrl: 'https://clovastudio.stream.ntruss.com',
      connectTimeout: _timeout,
      receiveTimeout: generationTimeout,
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(ClovaStudioAuthInterceptor(apiKey: apiKey));
}
