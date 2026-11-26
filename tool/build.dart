import 'dart:convert';
import 'dart:io';

/// env.json에 값이 반드시 있어야 하는 키
///
/// - `JUSO_CONFM_KEY`: 도로명주소 API 승인키
/// - `NAVER_MAPS_CLIENT_ID`: 네이버 지도·Geocoding 클라이언트 ID
/// - `NAVER_MAPS_CLIENT_SECRET`: 네이버 Geocoding 클라이언트 시크릿
const requiredKeys = ['JUSO_CONFM_KEY', 'NAVER_MAPS_CLIENT_ID', 'NAVER_MAPS_CLIENT_SECRET'];

/// 릴리즈 빌드에 들어가면 안 되는 키 (앱 바이너리에서 추출될 수 있는 개발용 키)
///
/// - `CLOVA_STUDIO_API_KEY`: CLOVA Studio 테스트 API 키
const forbiddenKeys = ['CLOVA_STUDIO_API_KEY'];

/// windows 빌드에서만 env.json에 값이 반드시 있어야 하는 키
///
/// - `WINDOWS_UPDATE_URL`: Windows 업데이트 파일 주소 (S3 버킷 주소 + `/windows`)
const windowsRequiredKeys = ['WINDOWS_UPDATE_URL'];
const envFile = 'env.json';
const macosArchivePath = 'build/macos/VineButler.xcarchive';

/// Windows 업데이트 파일을 올리는 S3 위치 (버킷 이름은 환경 변수 `VPK_BUCKET`)
const windowsRegion = 'ap-northeast-2';
const windowsPrefix = 'windows';
const windowsReleaseDir = 'build/windows/releases';

/// `windows --upload`에 필요한 환경 변수 (vpk가 직접 읽는 S3 버킷 이름·업로드 전용 IAM 키)
const windowsUploadKeys = ['VPK_BUCKET', 'VPK_KEY_ID', 'VPK_SECRET'];
const uploadFlag = '--upload';

Future<void> main(List<String> args) async {
  final command = args.isEmpty ? null : args.first;
  final isUpload = args.contains(uploadFlag);
  final extraArgs = args.skip(1).where((arg) => arg != uploadFlag).toList();
  final flutterArgs = switch (command) {
    'ipa' => ['build', 'ipa', '--release', ...extraArgs],
    'aab' => ['build', 'appbundle', '--release', ...extraArgs],
    'apk' => ['build', 'apk', '--release', ...extraArgs],
    'macos' => ['build', 'macos', '--release', ...extraArgs],
    'windows' => ['build', 'windows', '--release', ...extraArgs],
    _ => null,
  };

  if (flutterArgs == null) { _exitWithUsage(); }
  if (command == 'windows' && !Platform.isWindows) { _fail('windows 명령은 Windows에서만 실행할 수 있습니다.'); }
  if (isUpload && command != 'windows') { _fail('$uploadFlag는 windows 명령에서만 쓸 수 있습니다.'); }
  if (isUpload) { _checkWindowsUploadKeys(); }

  Directory.current = File.fromUri(Platform.script).parent.parent;
  _checkEnvFile(command == 'windows' ? [...requiredKeys, ...windowsRequiredKeys] : requiredKeys);

  if (command == 'aab' || command == 'apk') { _checkAndroidSigning(); }

  if (isUpload) {
    final downloadExitCode = await _syncWindowsReleases('download');

    if (downloadExitCode != 0) { exit(downloadExitCode); }
  }

  final exitCode = await _run('flutter', [...flutterArgs, '--dart-define-from-file=$envFile']);

  if (exitCode != 0) { exit(exitCode); }

  switch (command) {
    case 'macos':
      exit(await _uploadMacos());

    case 'windows':
      final packExitCode = await _packWindows();

      if (packExitCode != 0 || !isUpload) { exit(packExitCode); }

      exit(await _syncWindowsReleases('upload'));

    default:
      exit(exitCode);
  }
}

/// macOS 아카이브 후 App Store Connect 업로드 함수
///
/// - 아카이브는 직전 `flutter build macos`의 dart-define 값을 그대로 사용
/// - 업로드 설정은 `macos/ExportOptions.plist` (Xcode에 Apple 계정 로그인 필요)
Future<int> _uploadMacos() async {
  final archiveExitCode = await _run('xcodebuild', [
    '-workspace', 'macos/Runner.xcworkspace',
    '-scheme', 'Runner',
    '-configuration', 'Release',
    '-archivePath', macosArchivePath,
    '-allowProvisioningUpdates',
    'archive',
  ]);

  if (archiveExitCode != 0) { return archiveExitCode; }

  return _run('xcodebuild', [
    '-exportArchive',
    '-archivePath', macosArchivePath,
    '-exportOptionsPlist', 'macos/ExportOptions.plist',
    '-exportPath', 'build/macos/export',
    '-allowProvisioningUpdates',
  ]);
}

/// Windows 빌드 결과를 vpk로 Setup.exe·업데이트 파일로 묶는 함수
///
/// - 버전은 `pubspec.yaml` `version`의 build-name (Velopack이 새 버전 판단에 사용하므로 릴리스마다 올려야 함)
/// - `--mainExe`: `windows/CMakeLists.txt`의 `BINARY_NAME`
/// - `--packTitle`: 영문만 사용 (한글이면 차이분 패키지 생성 실패, vpk 1.2.161 기준)
/// - 결과: `windowsReleaseDir`에 `*-Setup.exe`, `.nupkg`, `releases.win.json`, 배포용 `build/windows/VineButler_v<버전>.exe`
Future<int> _packWindows() async {
  final versionLine = File('pubspec.yaml').readAsLinesSync().firstWhere((line) => line.startsWith('version:'));
  final buildName = versionLine.substring('version:'.length).trim().split('+').first;

  final exitCode = await _run('vpk', [
    'pack',
    '--packId', 'VineButler',
    '--packVersion', buildName,
    '--packDir', 'build/windows/x64/runner/Release',
    '--mainExe', 'vine_butler.exe',
    '--packTitle', 'VineButler',
    '--runtime', 'win-x64',
    '--icon', 'windows/runner/resources/app_icon.ico',
    '--outputDir', windowsReleaseDir,
  ]);

  if (exitCode != 0) { return exitCode; }

  File('$windowsReleaseDir/VineButler-win-Setup.exe').copySync('build/windows/VineButler_v$buildName.exe');

  return exitCode;
}

/// S3와 `windowsReleaseDir` 사이 Windows 릴리스 내려받기·올리기 함수
///
/// - `download`: pack 전에 이전 버전을 받아 차이분 패키지 생성에 사용
/// - `upload`: pack 결과를 S3에 올림 (오래된 버전은 지우지 않음)
Future<int> _syncWindowsReleases(String action) {
  return _run('vpk', [
    action, 's3',
    '--region', windowsRegion,
    '--prefix', windowsPrefix,
    '--outputDir', windowsReleaseDir,
  ]);
}

Future<int> _run(String executable, List<String> arguments) async {
  final process = await Process.start(executable, arguments, mode: ProcessStartMode.inheritStdio, runInShell: true);

  return process.exitCode;
}

void _checkEnvFile(List<String> keys) {
  final file = File(envFile);

  if (!file.existsSync()) { _fail('$envFile 파일이 없습니다. 프로젝트 루트에 만들어 주세요.'); }

  final Object? json;

  try {
    json = jsonDecode(file.readAsStringSync());
  } on FormatException {
    _fail('$envFile 파일이 올바른 JSON 형식이 아닙니다.');
  }

  if (json is! Map<String, dynamic>) { _fail('$envFile 파일은 {"키": "값"} 형태여야 합니다.'); }

  final missingKeys = [
    for (final key in keys)
      if (json[key] is! String || (json[key] as String).trim().isEmpty) key,
  ];

  if (missingKeys.isNotEmpty) { _fail('$envFile에 값이 없는 키가 있습니다: ${missingKeys.join(', ')}'); }

  final includedForbiddenKeys = [
    for (final key in forbiddenKeys)
      if (json[key] is String && (json[key] as String).trim().isNotEmpty) key,
  ];

  if (includedForbiddenKeys.isNotEmpty) { _fail('$envFile에 릴리즈 빌드에 넣을 수 없는 개발용 키가 있습니다: ${includedForbiddenKeys.join(', ')}. 값을 비우고 다시 실행해 주세요.'); }
}

void _checkWindowsUploadKeys() {
  final missingKeys = [
    for (final key in windowsUploadKeys)
      if ((Platform.environment[key] ?? '').trim().isEmpty) key,
  ];

  if (missingKeys.isNotEmpty) { _fail('환경 변수가 없습니다: ${missingKeys.join(', ')}. S3 버킷 이름·업로드용 IAM 키를 설정해 주세요.'); }
}

void _checkAndroidSigning() {
  if (!File('android/key.properties').existsSync()) { _fail('android/key.properties가 없어 debug 키로 서명됩니다. 업로드 키 설정 후 다시 실행해 주세요.'); }
}

Never _exitWithUsage() {
  stderr.writeln('''
사용법: dart run tool/build.dart <명령> [--upload] [flutter 옵션]

  ipa   iOS 스토어 업로드용 .ipa 빌드
  aab   Android 스토어 업로드용 .aab 빌드
  apk   Android 직접 설치·테스트용 .apk 빌드
  macos macOS 빌드 후 아카이브해서 App Store Connect 업로드
  windows Windows 빌드 후 vpk로 Setup.exe·업데이트 파일 생성 (Windows에서만)
          --upload: 이전 버전을 S3에서 받은 뒤 pack하고 S3에 업로드 (VPK_BUCKET·VPK_KEY_ID·VPK_SECRET 필요)''');
  exit(64);
}

Never _fail(String message) {
  stderr.writeln('[build] $message');
  exit(1);
}
