import 'package:vine_butler/domain/repository/app_update_repository.dart';

/// 스토어 업데이트 구현체 (macOS·iOS·Android)
///
/// - 스토어 버전 확인·스토어 이동
class StoreAppUpdateRepositoryImpl implements AppUpdateRepository {
  const StoreAppUpdateRepositoryImpl();

  @override
  Future<bool> isUpdateAvailable() async => false;

  @override
  Future<void> update() async {}
}
