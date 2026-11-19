/// 앱 전체에서 쓰는 고정 설정 값
///
/// - `supportEmail`: 오류 문의 메일 수신 주소
/// - `windowsUpdateUrl`: Windows 업데이트 파일 주소 (env.json `WINDOWS_UPDATE_URL`, 비어 있으면 업데이트 확인 안 함)
abstract final class AppConfig {
  static const supportEmail = 'atenb3f@gmail.com';
  static const windowsUpdateUrl = String.fromEnvironment('WINDOWS_UPDATE_URL');
}
