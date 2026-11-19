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
const envFile = 'env.json';
const macosArchivePath = 'build/macos/VineButler.xcarchive';

Future<void> main(List<String> args) async {
  final command = args.isEmpty ? null : args.first;
  final extraArgs = args.skip(1).toList();
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

  Directory.current = File.fromUri(Platform.script).parent.parent;
  _checkEnvFile();

  if (command == 'aab' || command == 'apk') { _checkAndroidSigning(); }

  final exitCode = await _run('flutter', [...flutterArgs, '--dart-define-from-file=$envFile']);

  if (exitCode != 0) { exit(exitCode); }

  switch (command) {
    case 'macos':
      exit(await _uploadMacos());

    case 'windows':
      exit(await _packWindows());

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
/// - 결과: `build/windows/releases`에 `*-Setup.exe`, `.nupkg`, `releases.win.json`
Future<int> _packWindows() {
  final versionLine = File('pubspec.yaml').readAsLinesSync().firstWhere((line) => line.startsWith('version:'));
  final buildName = versionLine.substring('version:'.length).trim().split('+').first;

  return _run('vpk', [
    'pack',
    '--packId', 'com.atenb.vinebutler',
    '--packVersion', buildName,
    '--packDir', 'build/windows/x64/runner/Release',
    '--mainExe', 'vine_butler.exe',
    '--packTitle', '넝쿨집사',
    '--icon', 'windows/runner/resources/app_icon.ico',
    '--outputDir', 'build/windows/releases',
  ]);
}

Future<int> _run(String executable, List<String> arguments) async {
  final process = await Process.start(executable, arguments, mode: ProcessStartMode.inheritStdio, runInShell: true);

  return process.exitCode;
}

void _checkEnvFile() {
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
    for (final key in requiredKeys)
      if (json[key] is! String || (json[key] as String).trim().isEmpty) key,
  ];

  if (missingKeys.isNotEmpty) { _fail('$envFile에 값이 없는 키가 있습니다: ${missingKeys.join(', ')}'); }

  final includedForbiddenKeys = [
    for (final key in forbiddenKeys)
      if (json[key] is String && (json[key] as String).trim().isNotEmpty) key,
  ];

  if (includedForbiddenKeys.isNotEmpty) { _fail('$envFile에 릴리즈 빌드에 넣을 수 없는 개발용 키가 있습니다: ${includedForbiddenKeys.join(', ')}. 값을 비우고 다시 실행해 주세요.'); }
}

void _checkAndroidSigning() {
  if (!File('android/key.properties').existsSync()) { _fail('android/key.properties가 없어 debug 키로 서명됩니다. 업로드 키 설정 후 다시 실행해 주세요.'); }
}

Never _exitWithUsage() {
  stderr.writeln('''
사용법: dart run tool/build.dart <명령> [flutter 옵션]

  ipa   iOS 스토어 업로드용 .ipa 빌드
  aab   Android 스토어 업로드용 .aab 빌드
  apk   Android 직접 설치·테스트용 .apk 빌드
  macos macOS 빌드 후 아카이브해서 App Store Connect 업로드
  windows Windows 빌드 후 vpk로 Setup.exe·업데이트 파일 생성 (Windows에서만)''');
  exit(64);
}

Never _fail(String message) {
  stderr.writeln('[build] $message');
  exit(1);
}
