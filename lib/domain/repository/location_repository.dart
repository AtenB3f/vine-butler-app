abstract class LocationRepository {
  /// 현재 위치 (권한이 없거나 위치 서비스가 꺼져 있거나 조회에 실패하면 null)
  Future<({double latitude, double longitude})?> current();

  /// 다시 묻지 않음으로 거부되어 권한 창을 띄울 수 없는 상태인지
  Future<bool> isPermanentlyDenied();

  Future<void> openSettings();
}
