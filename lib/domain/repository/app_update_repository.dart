abstract class AppUpdateRepository {
  Future<bool> isUpdateAvailable();

  /// 새 버전 적용
  /// - Windows: 다운받아 둔 버전으로 재시작
  /// - 이 외: 스토어 이동
  Future<void> update();
}
