import 'package:shared_preferences/shared_preferences.dart';
import 'package:vine_butler/domain/repository/app_settings_repository.dart';

/// 앱 설정 저장 구현체
class AppSettingsRepositoryImpl implements AppSettingsRepository {
  static const String _windowSideWidthKey = 'windowSideWidth';

  final SharedPreferencesAsync _preferences;

  const AppSettingsRepositoryImpl(this._preferences);

  @override
  Future<double?> windowSideWidth() => _preferences.getDouble(_windowSideWidthKey);

  @override
  Future<void> saveWindowSideWidth(double width) => _preferences.setDouble(_windowSideWidthKey, width);
}
