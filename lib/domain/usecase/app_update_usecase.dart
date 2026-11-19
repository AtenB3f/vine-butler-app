import 'package:vine_butler/domain/repository/app_update_repository.dart';

class AppUpdateUseCase {
  const AppUpdateUseCase(this._repository);

  final AppUpdateRepository _repository;

  Future<bool> isUpdateAvailable() => _repository.isUpdateAvailable();

  Future<void> update() => _repository.update();
}
