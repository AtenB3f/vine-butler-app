import 'package:flutter/foundation.dart';
import 'package:velopack_flutter/velopack_flutter.dart' as velopack;
import 'package:vine_butler/domain/repository/app_update_repository.dart';
import 'package:vine_butler/shared/utils/config.dart';

/// Windows 업데이트 구현체
///
/// - vpk로 패킹한 release에서만 동작
/// - 업데이트 주소가 없거나 release가 아니면 업데이트 없음
/// - 확인 시간 제한 5초
/// - 업데이트가 있으면 바로 백그라운드로 내려받아 두고, `update()`에서 받아 둔 버전으로 재시작
class WindowsAppUpdateRepositoryImpl implements AppUpdateRepository {
  WindowsAppUpdateRepositoryImpl();

  Future<void>? _download;

  @override
  Future<bool> isUpdateAvailable() async {
    if (!kReleaseMode || AppConfig.windowsUpdateUrl.isEmpty) { return false; }

    try {
      final isAvailable = await velopack.isUpdateAvailable().timeout(const Duration(seconds: 5));

      if (isAvailable) { _download = _downloadUpdate()..ignore(); }

      return isAvailable;
    } catch (error) {
      debugPrint('[UPDATE] check failed $error');

      return false;
    }
  }

  @override
  Future<void> update() async {
    final download = _download ?? _downloadUpdate();

    _download = null;

    try {
      await download;
    } catch (error) {
      debugPrint('[UPDATE] download failed, retry $error');

      await _downloadUpdate();
    }

    await velopack.updateAndRestart();
  }

  Future<void> _downloadUpdate() => velopack.checkAndDownloadUpdatesWithProgress().drain<void>();
}
