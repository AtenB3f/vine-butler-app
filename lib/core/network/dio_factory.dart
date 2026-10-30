import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vine_butler/core/network/adapters/background_transfer_adapter.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/core/network/interceptors/clova_studio_auth_interceptor.dart';
import 'package:vine_butler/core/network/interceptors/in_flight_request_interceptor.dart';
import 'package:vine_butler/core/network/interceptors/juso_auth_interceptor.dart';
import 'package:vine_butler/core/network/interceptors/naver_maps_auth_interceptor.dart';

/// API별 Dio 설정 (인증 키 기본값은 `ApiEnv`, 테스트에서는 가짜 키 전달)
///
/// - `clovaStudio`: 생성형 응답 대기 180초
sealed class DioType {
  const DioType();

  static const timeout = Duration(seconds: 10);

  const factory DioType.juso({String confmKey}) = _Juso;
  const factory DioType.naverMaps({String clientId, String clientSecret}) = _NaverMaps;
  const factory DioType.clovaStudio({String apiKey}) = _ClovaStudio;

  String get baseUrl => switch (this) {
    _Juso() => 'https://business.juso.go.kr',
    _NaverMaps() => 'https://maps.apigw.ntruss.com',
    _ClovaStudio() => 'https://clovastudio.stream.ntruss.com',
  };

  Duration get receiveTimeout => switch (this) {
    _ClovaStudio() => const Duration(seconds: 180),
    _Juso() || _NaverMaps() => timeout,
  };

  /// 백그라운드 동작 지원 여부
  bool get keepsAliveInBackground => switch (this) {
    _ClovaStudio() => true,
    _Juso() || _NaverMaps() => false,
  };

  Interceptor get authInterceptor => switch (this) {
    _Juso(:final confmKey) => JusoAuthInterceptor(confmKey: confmKey),
    _NaverMaps(:final clientId, :final clientSecret) => NaverMapsAuthInterceptor(clientId: clientId, clientSecret: clientSecret),
    _ClovaStudio(:final apiKey) => ClovaStudioAuthInterceptor(apiKey: apiKey),
  };
}

class _Juso extends DioType {
  const _Juso({this.confmKey = ApiEnv.jusoConfmKey});

  final String confmKey;
}

class _NaverMaps extends DioType {
  const _NaverMaps({this.clientId = ApiEnv.naverMapsClientId, this.clientSecret = ApiEnv.naverMapsClientSecret});

  final String clientId;
  final String clientSecret;
}

class _ClovaStudio extends DioType {
  const _ClovaStudio({this.apiKey = ApiEnv.clovaStudioApiKey});

  final String apiKey;
}

/// API 종류별 Dio 생성 함수
Dio createDio(DioType type) {
  final dio = Dio(
    BaseOptions(
      baseUrl: type.baseUrl,
      connectTimeout: DioType.timeout,
      receiveTimeout: type.receiveTimeout,
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.addAll([InFlightRequestInterceptor(), type.authInterceptor]);

  if (type.keepsAliveInBackground && (Platform.isAndroid || Platform.isIOS)) { dio.httpClientAdapter = BackgroundTransferAdapter(); }

  return dio;
}
