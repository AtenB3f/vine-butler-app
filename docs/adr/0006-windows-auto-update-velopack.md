---
status: proposed
date: 2026-11-17
decision-makers: AtenB
version: 1.2.0
---

# Windows 자동 업데이트에 Velopack(velopack_flutter)을 사용

## 배경과 문제

Windows는 스토어 없이 Setup.exe를 특정 몇몇 사용자에게 직접 전달한다. <br>
코드 서명 인증서는 비용 때문에 쓰지 않는다. 첫 설치 때 SmartScreen 경고가 한 번 뜨는 것은 감수한다. <br>
새 버전이 나올 때마다 사용자가 파일을 다시 받아 설치하지 않도록 자동 업데이트가 필요하다.

## 결정 요인

* 업데이트를 백그라운드로 받아 두고, 앱 팝업의 버튼으로 적용할 것
* 유료 인증서·서비스 없이 운영할 것
* 실무에서 많이 쓰는 기술일 것
* 개발 공수가 적을 것
* CI(GitHub Actions)로 배포를 자동화하기 쉬울 것

## 검토한 옵션

* `velopack_flutter` (Velopack)
* `auto_updater` (WinSparkle)
* `msix` + App Installer
* Microsoft Store

## 결정 결과

선택: "`velopack_flutter` (Velopack)" <br>
사유: 원하는 흐름(백그라운드 다운로드 → 앱 팝업 → 재시작)을 만들 수 있는 유일한 옵션이다. <br>
배포가 `vpk download` → `vpk pack` → `vpk upload` 명령 3개라 CI에 넣기 쉽다. 서버는 정적 파일 호스팅만 있으면 된다.

* 배포 흐름: `dart run tool/build.dart windows --upload`
  1. `_syncWindowsReleases('download')`: `vpk download s3`로 이전 버전을 `build/windows/releases`에 받는다 (차이분 패키지 생성용)
  2. `flutter build windows --release --dart-define-from-file=env.json`
  3. `_packWindows`: `vpk pack` → Setup.exe, 전체·차이분 패키지(`.nupkg`), 버전 목록 `releases.win.json` 생성, 배포용으로 `build/windows/VineButler_v<버전>.exe` 복사
  4. `_syncWindowsReleases('upload')`: `vpk upload s3`로 올린다 (오래된 버전은 지우지 않음)
  - `--upload` 없이 실행하면 2·3만 한다 (로컬 확인용)
* `vpk pack` 주요 옵션
  - `--packId VineButler`: 설치 폴더 `%LocalAppData%\VineButler`
  - `--packTitle VineButler`: 영문만 쓴다. 한글(`넝쿨집사`)이면 `<title>_ExecutionStub.exe`의 차이분(zstd delta) 생성이 실패한다 (vpk 1.2.161 기준)
  - `--runtime win-x64`, `--packVersion`은 `pubspec.yaml` `version`의 build-name
* 호스팅: AWS S3
  - 사유: 2.0.0 백엔드를 AWS로 할 예정이라 계정·결제·권한(IAM)을 한곳에서 관리한다. `vpk upload s3`가 기본 지원한다.
  - 위치: 리전 `ap-northeast-2`, prefix `windows`. 버킷 이름은 환경 변수 `VPK_BUCKET`
  - 권한: 버킷은 읽기만 공개, 업로드는 업로드 전용 IAM 키(`VPK_KEY_ID`·`VPK_SECRET`)
  - 앱이 보는 주소: env.json `WINDOWS_UPDATE_URL` (버킷 주소 + `/windows`)
  - 비교한 대안: Cloudflare R2. 무료 용량 10GB·전송 무료로 비용은 더 낮지만 AWS와 별도 계정을 관리해야 한다.
* CI: `.github/workflows/windows_release.yml`
  - `windows/*` 태그 push 때만 실행 (예: `git tag windows/v1.2.5 && git push origin windows/v1.2.5`)
  - `windows-latest`에서 vpk 설치 → Secrets로 env.json 생성 → `dart run tool/build.dart windows --upload`
  - Setup.exe(`VineButler_v*.exe`)는 Actions 산출물로 1일 보관
  - 키(`VPK_*`, env.json 값)는 Repository secrets에 보관
* 앱 흐름
  - `lib/main.dart` `_setUpWindowsUpdate`: Velopack 설치·제거 훅 인자(`--veloapp-*`)로 실행되면 바로 종료한다. release이고 `WINDOWS_UPDATE_URL`이 있을 때만 `initializeVelopack`을 호출한다.
  - `WindowsAppUpdateRepositoryImpl` (`AppUpdateRepository` 구현, `appUpdateRepositoryProvider`에서 Windows일 때 주입)
    - `isUpdateAvailable`: 5초 제한으로 확인하고, 새 버전이 있으면 바로 백그라운드로 받기 시작한다
    - `update`: 받아 둔 다운로드를 기다리고(실패하면 한 번 다시 받음) `updateAndRestart`로 재시작한다
  - `SplashVM`: 스플래시에서 업데이트를 확인하고, 있으면 팝업([업데이트]/[닫기])을 띄운다. [업데이트]는 `update()`로 재시작, [닫기]는 앱을 종료한다. 업데이트가 없거나 실패하면 매물 목록으로 이동한다.
* 빌드 PC에만 Rust(`velopack_flutter` 네이티브 컴파일)와 .NET SDK(`vpk` 실행)가 필요하다. 사용자 PC에는 Setup.exe 외에 설치할 것이 없다.

### 영향

* 장점: 차이분 업데이트로 받는 크기가 작다. 팝업을 앱 디자인에 맞춰 만들 수 있다. 사용자 PC에 런타임 설치가 필요 없다. 태그 push만으로 빌드·업로드가 끝난다.
* 단점: 빌드 PC(CI 포함)에 Rust·.NET SDK·`vpk`가 필요하다. `flutter build windows`는 Windows에서만 동작해 Mac에서 빌드할 수 없다.
  - 코드 서명이 없어 첫 설치 때 SmartScreen 경고가 뜬다.
  - 채널을 나누지 않아 테스트용 태그도 같은 `releases.win.json`에 올라간다. 테스트 빌드를 올리면 모든 사용자에게 업데이트로 뜬다.
  - 2025-07-15 이후 만든 AWS 계정은 Free 플랜(크레딧, 6개월) 뒤 유료 플랜으로 전환해야 한다. 사용자 5명 이내·파일 수백 MB 규모라 S3 비용은 매우 적다.
* 위험: Flutter 래퍼(`velopack_flutter`)가 0.3.x 초기 버전이다. vpk로 패킹한 release 빌드에서만 동작해 debug 실행으로는 확인할 수 없다.
  - `--packTitle` 한글 제한은 vpk 1.2.161 기준이다. vpk를 올리면 다시 확인해야 한다.
  - `windows/CMakeLists.txt`에 `_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS`를 임시로 넣었다. `webview_windows`가 `<experimental/coroutine>`을 써서 VS 2026부터 STL1011 오류로 빌드가 막히기 때문이다. 패키지가 고쳐지면 뺀다.

### 검증

#### velopack_flutter
- 환경: Windows 실기기, vpk로 패킹한 release 빌드, S3 업로드
- 방법: 이전 버전 Setup.exe 설치 → 새 버전 업로드 → 이전 버전 실행 → 팝업 → [업데이트]
- 결과
  - 1.2.0 → 1.2.1 업데이트 적용 확인
  - 이전 버전을 받은 뒤 pack한 차이분 업데이트 적용 확인
  - packId를 `VineButler`로 바꾼 빌드의 설치·업데이트 확인

## 옵션별 장단점

### `velopack_flutter` (Velopack)

* 장점: 백그라운드 다운로드와 재시작 적용을 API로 제공한다. Setup.exe·패키지·버전 목록을 `vpk pack`이 만들고, 업로드도 `vpk upload`로 S3·R2·GitHub Releases·Azure를 지원한다. Squirrel.Windows의 후속으로 데스크톱 앱에서 널리 쓴다.
* 단점: 빌드 PC에 Rust와 .NET SDK가 필요하다. Flutter 래퍼가 아직 초기 버전이다.

### `auto_updater` (WinSparkle)

* 장점: macOS의 Sparkle과 같은 계열이라 널리 쓴다. 업데이트 파일 서명은 무료 키로 할 수 있다.
* 단점: 새 버전이 있으면 WinSparkle 기본 창이 떠서 사용자가 진행해야 하고, 앱 디자인과 맞출 수 없다. 백그라운드로 받아 두고 앱 팝업으로 적용하는 흐름을 만들 수 없다.
  - 설치 파일(Inno Setup 스크립트), `appcast.xml` 갱신, 서명, 업로드를 직접 스크립트로 관리해야 해 CI 실패 지점이 많다.

### `msix` + App Installer

* 장점: 공수가 가장 적다. 업데이트를 OS가 처리해 앱 코드가 필요 없다.
* 단점: 코드 서명 인증서가 사실상 필수다. 무료로 하려면 사용자 PC마다 인증서를 직접 신뢰 등록해야 한다. 업데이트 알림이 OS 방식이라 원하는 팝업 흐름과 맞지 않는다.

### Microsoft Store

* 장점: 개인 개발자 등록이 무료이고, 서명과 업데이트를 Store가 처리한다.
* 단점: 심사가 필요하다. Store 배포는 나중으로 정했다. 업데이트를 Store가 처리해 원하는 팝업 흐름과 맞지 않는다.

## 추가 정보

- 코드 위치
  - `tool/build.dart`의 `_packWindows`, `_syncWindowsReleases`
  - `.github/workflows/windows_release.yml`
  - `lib/main.dart`의 `_setUpWindowsUpdate`
  - `lib/data/repository/windows_app_update_repository_impl.dart`의 `WindowsAppUpdateRepositoryImpl`
  - `lib/features/splash/splash_vm.dart`의 `SplashVM`
- 규칙
  - 릴리스마다 `pubspec.yaml` `version`의 build-name을 올려야 업데이트로 인식한다 (예: 1.2.0 → 1.2.1).
  - `--packId`를 바꾸면 기존 설치본이 새 버전을 업데이트로 받지 못해 재설치해야 한다. `VineButler`로 고정한다.
  - 업데이트 주소가 앱에 들어가므로 호스팅을 옮기면 새 주소를 넣은 버전을 기존 주소로 한 번 배포해야 한다.
  - 공개 저장소라 버킷 이름·계정 ID·키는 문서·코드에 쓰지 않고 환경 변수와 Secrets로만 넘긴다.
- 참고: [Velopack 문서](https://docs.velopack.io), [velopack_flutter (pub.dev)](https://pub.dev/packages/velopack_flutter)
