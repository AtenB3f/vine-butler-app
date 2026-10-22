import 'dart:convert';
import 'dart:io';

/// env.json에 값이 반드시 있어야 하는 키
///
/// - `JUSO_CONFM_KEY`: 도로명주소 API 승인키
/// - `NAVER_MAPS_CLIENT_ID`: 네이버 지도·Geocoding 클라이언트 ID
/// - `NAVER_MAPS_CLIENT_SECRET`: 네이버 Geocoding 클라이언트 시크릿
const requiredKeys = ['JUSO_CONFM_KEY', 'NAVER_MAPS_CLIENT_ID', 'NAVER_MAPS_CLIENT_SECRET'];
const envFile = 'env.json';

Future<void> main(List<String> args) async {
  final command = args.isEmpty ? null : args.first;
  final extraArgs = args.skip(1).toList();
  final flutterArgs = switch (command) {
    'ipa' => ['build', 'ipa', '--release', ...extraArgs],
    'aab' => ['build', 'appbundle', '--release', ...extraArgs],
    'apk' => ['build', 'apk', '--release', ...extraArgs],
    _ => null,
  };

  if (flutterArgs == null) { _exitWithUsage(); }

  Directory.current = File.fromUri(Platform.script).parent.parent;
  _checkEnvFile();

  if (command == 'aab' || command == 'apk') { _checkAndroidSigning(); }

  final process = await Process.start(
    'flutter',
    [...flutterArgs, '--dart-define-from-file=$envFile'],
    mode: ProcessStartMode.inheritStdio,
    runInShell: true,
  );

  exit(await process.exitCode);
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
}

void _checkAndroidSigning() {
  if (!File('android/key.properties').existsSync()) { _fail('android/key.properties가 없어 debug 키로 서명됩니다. 업로드 키 설정 후 다시 실행해 주세요.'); }
}

Never _exitWithUsage() {
  stderr.writeln('''
사용법: dart run tool/build.dart <명령> [flutter 옵션]

  ipa   iOS 스토어 업로드용 .ipa 빌드
  aab   Android 스토어 업로드용 .aab 빌드
  apk   Android 직접 설치·테스트용 .apk 빌드''');
  exit(64);
}

Never _fail(String message) {
  stderr.writeln('[build] $message');
  exit(1);
}
