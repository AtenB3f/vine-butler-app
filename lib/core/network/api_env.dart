import 'package:flutter/foundation.dart';

abstract final class ApiEnv {
  static const naverMapsClientId = String.fromEnvironment('NAVER_MAPS_CLIENT_ID');
  static const naverMapsClientSecret = String.fromEnvironment('NAVER_MAPS_CLIENT_SECRET');
  static const jusoConfmKey = String.fromEnvironment('JUSO_CONFM_KEY');
  static const clovaStudioApiKey = String.fromEnvironment('CLOVA_STUDIO_API_KEY');

  static const naverMapsWebServiceUrl = 'https://vinebutler.atenb.com';

  /// AI 기능 사용 가능 여부 (개발용 키라 debug 빌드에서만 허용)
  static bool get isAiEnabled => kDebugMode && clovaStudioApiKey.isNotEmpty;
}
