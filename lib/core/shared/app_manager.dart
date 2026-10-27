/// 앱 전역 상태 관리 클래스
class AppManager {
  static final AppManager shared = AppManager._();

  AppManager._();

  /// 지도 오버레이 이미지 준비 작업 인스턴스
  ///
  /// - `main()`에서 `NativeMap.prepareImages`의 Future를 담고, `NativeMap`의 `onInit`으로 넘겨 기다림
  Future<void> mapImagesReady = Future.value();
}
