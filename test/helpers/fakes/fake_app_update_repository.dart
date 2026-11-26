import 'package:vine_butler/domain/repository/app_update_repository.dart';

class FakeAppUpdateRepository implements AppUpdateRepository {
  FakeAppUpdateRepository({this.isAvailable = false});

  bool isAvailable;
  Object? updateError;
  int updateCount = 0;

  @override
  Future<bool> isUpdateAvailable() async => isAvailable;

  @override
  Future<void> update() async {
    updateCount++;

    if (updateError case final error?) { throw error; }
  }
}
