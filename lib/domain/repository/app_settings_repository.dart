abstract class AppSettingsRepository {
  Future<double?> windowSideWidth();

  Future<void> saveWindowSideWidth(double width);
}
