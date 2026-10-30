# Vine Butler — Claude Code 가이드

## 프로젝트 개요

- **앱 설명**
공인중개사를 위한 부동산 매물을 저장하고 원하는 조건대로 필터를 걸어 검색할 수 있는 어플리케이션.
전세 / 월세 / 매매 타입으로 구분하여 관리함.
지도 SDK를 연동하여 매물 주소와 연동되어 지도로 표시 가능하도록 함.
추후 백엔드를 연동할 경우 네이버 부동산에서 검색한 내용을 크롤링한 데이터도 표기 가능하도록 할 예정.

- **앱 이름**: 넝쿨집사 (번들 ID / 패키지명 `com.atenb.vinebutler`)
- **타겟 플랫폼**: iOS(iPhone 전용) / macOS / Windows / Android
- **최소 지원 버전**: iOS 15.0 / macOS 12.0 / Windows 10 / Android 7.0 (API 24, Flutter 기본값)
- **현재 버전**: 1.1.0+4 (스토어 업로드마다 빌드번호 증가)
- **현재 상태**: 1.0.0 1차 릴리즈 — iOS 심사 중 / Android 비공개 테스트 중, 다음 버전 1.1.0

## 기술 스택

| 역할 | 라이브러리 | 버전 |
|---|---|---|
| 상태관리 | flutter_riverpod | ^3.2.1 |
| 라우터 | go_router + go_router_builder (typed route) | ^18.0.1 |
| 로컬 DB | drift + drift_flutter (SQLite), drift_dev (dev) | ^2.35.2 / ^0.3.1 / ^2.35.1 |
| UUID 생성 | uuid | ^4.6.0 |
| 도메인 모델 | freezed_annotation, freezed (dev) | ^3.1.0 / ^4.0.2 |
| 네트워크 | dio | ^5.11.1 |
| 지도 | flutter_naver_map (iOS/Android), webview_flutter (macOS), webview_windows (Windows) | ^1.4.4 / ^4.14.1 / ^0.4.0 |
| 사진 첨부·저장 | image_picker, path_provider | ^1.2.4 / ^2.1.6 |
| 아이콘 | flutter_svg | ^2.3.0 |
| 외부 API | 도로명주소 API(주소 검색), 네이버 Geocode API(좌표 변환) | — |
| 백엔드 | [추후 연동] | — |

Dart SDK: `^3.9.2`

## 아키텍처 전략

클린 아키텍처를 단계적으로 도입합니다:

- **1단계 (현재)**: 구현체와 프로토콜 분리, Repository / UseCase 레이어 도입 (모듈화, 중앙제어 X)
- **2단계**: 중앙 제어 로직 추가
- **3단계**: 모듈화 및 의존성 관리 고도화

## 로드맵

- 1.0.0: 1~5단계(UI 컴포넌트, 뼈대 레이아웃, 세부 페이지, 로컬 저장, 지도 SDK) 완료, 6단계(스토어 배포) 진행 중 — 세부는 `.claude/RELEASE_CHECKLIST.md`
- 1.1.0: 금액 입력 컴포넌트·키보드, 사진 크게 보기, 지도 현재 위치 기준 표시·화면 범위 안 매물만 zoom별 최대 개수로 표시
- 1.2.0: 데스크톱 UI, Windows 자동 업데이트, Windows·macOS 배포
- 1.3.0 (데스크톱만): OCR·녹음 파일 분석으로 매물 등록, 블로그 글 AI 작성 (서버리스 프록시 + 초대 코드)
- 2.0.0: 백엔드 연동, 회원가입·로그인, 서버 저장, 인앱결제
- 2.1.0: 로컬 데이터 동기화
- 2.2.0: 1.3.0 AI 기능 모바일 적용
- 2.3.0: 마스터 권한용 크롤링 데이터 표기
- 버전별 상세와 동기화 설계(`syncedAt`, UUID upsert, 충돌 처리)는 `.claude/docs/roadmap.md` 참고

## 프로젝트 구조

Repository Pattern + MVVM 기반. 1단계에서는 모듈화 없이 단순한 구조로 유지.

```
lib/
  main.dart
  core/
    router/              # go_router 설정
    di/                  # Riverpod provider (DB, Repository 구현체를 인터페이스 타입으로 노출)
    network/             # dio 인스턴스, 인터셉터, API 키(api_env)
    shared/              # 앱 전체 싱글톤 상태 (AppManager)
  domain/                # 순수 Dart (Drift/Flutter 의존 금지)
    model/               # 도메인 모델(Freezed)
    exception/           # 도메인 예외 (ApiException, 권한 거부 등)
    repository/          # Repository 인터페이스
    usecase/             # UseCase
  data/
    local/
      app_database.dart  # Drift DB
      tables/            # Drift 테이블 정의
    remote/              # 외부 API (juso: 도로명주소, naver: Geocode) + dto
    storage/             # 이미지 파일 저장 구현체
    mapper/              # Drift Row / DTO / DioException <-> 도메인 모델
    repository/          # Repository 구현체
  features/
    apply_property/ edit_property/ find_property/ home/ map/ property_detail/ property_list/
      <기능>_vm.dart     # Notifier + Action
      presentation/      # ViewState, screens/ (domain 인터페이스만 참조)
  components/            # 디자인 토큰(color/font/image), MainShell, 반응형 유틸
    widgets/             # 공통 재사용 위젯
  shared/
    extensions/          # 가격·전화번호·매물 유형 등 확장
    utils/               # 유틸 함수 (주소·면적·날짜 포맷터 등)
tool/
  build.dart             # 스토어 업로드용 빌드 스크립트
docs/
  adr/                   # 결정 기록 (MADR 형식, 작성 규칙은 docs/adr/README.md)
```

### 레이어 의존성 규칙
- `presentation` → `domain` (인터페이스만 참조, 구현체 직접 참조 금지)
- `data` → `domain` (인터페이스를 구현)
- `presentation`이 `data`를 직접 참조하는 것 금지

### Repository 전환 전략
현재는 로컬 DB만 구현. 백엔드 연동 시 구현체만 수정하여 로컬/원격 전환 또는 동기화 로직 추가.

## 주요 명령어

```bash
# 앱 실행
flutter run

# 특정 디바이스 지정 실행
flutter run -d [device-id]

# API 키 주입 실행 (env.json에 NAVER_MAPS_CLIENT_ID / NAVER_MAPS_CLIENT_SECRET / JUSO_CONFM_KEY 작성, env.json은 gitignore)
flutter run --dart-define-from-file=env.json

# 개발 실행은 VS Code 실행(F5) 사용 — .vscode/launch.json에 --dart-define-from-file=env.json 포함

# 스토어 업로드용 빌드 스크립트 (env.json 필수 키 검사 후 --dart-define-from-file 자동 추가, Windows 포함)
dart run tool/build.dart ipa   # iOS .ipa
dart run tool/build.dart aab   # Android .aab (key.properties 없으면 중단)
dart run tool/build.dart apk   # Android 직접 설치용 .apk (key.properties 없으면 중단)

# 릴리즈 빌드 확인
flutter build apk --release
flutter build ios --release

# 테스트
flutter test
flutter test test/features/[기능명]/

# 정적 분석 (커밋 전 필수)
flutter analyze

# 의존성
flutter pub get
flutter pub upgrade

# 라우트 코드 생성 (app_router.dart 수정 후 실행)
dart run build_runner build --delete-conflicting-outputs
```

## 코딩 규칙

Dart 코드를 작성·수정하기 전에 아래 문서를 확인할 것 (해당 경로 파일을 다룰 때 자동 로드되지만, 새 파일만 만들 때는 직접 읽기)
- `.claude/rules/dart-style.md`: 파일/네이밍, 상수·변수 위치, if문, 개행, 주석
- `.claude/rules/presentation.md`: 위젯, 상태관리(Riverpod), 네비게이션, 라우팅(go_router)
- `.claude/ui_patterns.md`: UI 작업 패턴 (레이아웃, 컴포넌트, VM Action, 네비게이션)
- `.claude/rules/git.md`: PR 머지 커밋 메시지

## Claude에게 주는 지침

### 작업 전 확인 사항
- 새 패키지 추가 전에 반드시 먼저 나에게 물어볼 것
- 기존 파일 구조를 크게 바꾸는 리팩터링은 먼저 제안 후 승인받고 진행
- `flutter analyze` 통과 여부를 작업 완료 기준으로 삼을 것

### 하지 말아야 할 것
- 요청하지 않은 기능 추가 / 리팩터링 금지
- 함수 안 코드 한 줄씩 설명하는 주석 금지 (작성 기준은 `.claude/rules/dart-style.md`의 "주석" 참고)
- `// TODO`, `// FIXME` 남기고 작업 마무리 금지

### 응답 스타일
- 한국어로 응답
- 코드 변경 후 변경된 내용을 간결하게 요약
- 여러 파일을 수정할 경우 어떤 파일을 왜 수정했는지 알려줄 것

### .claude/TODO.md 파일 작성
- 사용자가 추후 작업해야하는 일을 투두리스트에 추가해달라고 하면 .claude/TODO.md경로에 작성할 것.
- 작업을 진행 중에 .claude/TODO.md에 적혀있는 내용이 현재 진행하는 것과 유사하다면 사용자에게 함께 수정할 것인지 물어보고 허락을 받은 뒤 진행

### 결정 기록 (ADR) 작성
- 성능·구조 개선처럼 이유와 근거를 남길 결정이 생기면 먼저 사용자에게 ADR 작성 여부를 물어보고, 허락받은 경우에만 작성할 것
- `docs/adr/adr-template.md`(MADR 형식)를 복사해 다음 번호로 작성하고 `docs/adr/README.md` 목록에 추가
- 채택(`accepted`)된 ADR은 본문을 고치지 않고, 결정이 바뀌면 새 ADR을 써서 대체할 것

### 사용자의 질문에 답할 때
- 아래와 같이 비교하거나 비유하여 설명할 경우 비교하는 코드를 좌우로 배치하여 한 눈에 비교할 수 있도록 보여줘야함
- 사용자가 하는 기술적인 질문 중 dart언어 규칙이 swift에 동일한 개념이 있다면 swift에 비유하여 설명할 것   
- 동시성 처리에 대한 개념을 사용자가 물어볼 경우 답변이 swift concurency와 비슷한 개념이라면 비유하여 설명할 것
- 반응형 프로그래밍에 대한 질문 중 Combine과 유사한 기능을 하는 개념이라면 이를 비유하여 설명할 것
- SwiftUI에서 처리하는 데이터 바인딩 방식과 Riverpod의 방식이 다른 경우 차이점을 코드로 비교하여 설명할 것
