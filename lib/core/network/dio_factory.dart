import 'package:dio/dio.dart';
import 'package:vine_butler/core/network/api_env.dart';
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
