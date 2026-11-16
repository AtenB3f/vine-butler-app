import 'package:flutter/foundation.dart';
import 'package:vine_butler/domain/repository/app_settings_repository.dart';

/// 앱 전역 상태 관리 클래스
class AppManager {
  static final AppManager shared = AppManager._();

  /// 데스크톱 사이드 영역 최소 너비
  static const double minWindowSideWidth = 360;

  AppManager._();

  /// 지도 오버레이 이미지 준비 작업 인스턴스
  ///
  /// - `main()`에서 `NativeMap.prepareImages`의 Future를 담고, `NativeMap`의 `onInit`으로 넘겨 기다림
  Future<void> mapImagesReady = Future.value();

  /// 앱 설정 저장소 (`main()`에서 연결)
  AppSettingsRepository? settings;

  /// 데스크톱 사이드 영역 너비
  final ValueNotifier<double> windowSideWidth = ValueNotifier(minWindowSideWidth);
}

/// 앱 설정 불러오기·저장 함수
extension AppSetting on AppManager {
  /// 앱 시작 시 저장된 설정 불러오기 함수
  Future<void> loadSettings(AppSettingsRepository settings) async {
    this.settings = settings;
    windowSideWidth.value = await settings.windowSideWidth() ?? AppManager.minWindowSideWidth;
  }

  /// 현재 사이드 너비 저장 함수 (드래그가 끝났을 때 한 번 호출)
  Future<void> saveWindowSideWidth() async => settings?.saveWindowSideWidth(windowSideWidth.value);
}
