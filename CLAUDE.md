# Vine Butler — Claude Code 가이드

## 프로젝트 개요

- **앱 설명**
공인중개사를 위한 부동산 매물을 저장하고 원하는 조건대로 필터를 걸어 검색할 수 있는 어플리케이션.
전세 / 월세 / 매매 타입으로 구분하여 관리함.
지도 SDK를 연동하여 매물 주소와 연동되어 지도로 표시 가능하도록 함.
추후 백엔드를 연동할 경우 네이버 부동산에서 검색한 내용을 크롤링한 데이터도 표기 가능하도록 할 예정.

- **타겟 플랫폼**: iOS / macOS / Windows / Android
- **최소 지원 버전**: iOS 15.0 / macOS 12.0 / Windows 10 / Android 6.0 (API 23)
- **현재 버전**: 1.0.0

## 기술 스택

| 역할 | 라이브러리 | 버전 |
|---|---|---|
| 상태관리 | flutter_riverpod | ^3.2.1 |
| 라우터 | go_router + go_router_builder (typed route) | ^18.0.1 |
| 로컬 DB | drift + drift_flutter (SQLite), drift_dev (dev) | ^2.35.2 / ^0.3.1 / ^2.35.1 |
| UUID 생성 | uuid | ^4.6.0 |
| 백엔드 | [추후 연동] | — |

Dart SDK: `^3.9.2`

## 아키텍처 전략

클린 아키텍처를 단계적으로 도입합니다:

- **1단계 (현재)**: 구현체와 프로토콜 분리, Repository / UseCase 레이어 도입 (모듈화, 중앙제어 X)
- **2단계**: 중앙 제어 로직 추가
- **3단계**: 모듈화 및 의존성 관리 고도화

## 개발 순서 (순차적 진행)

**1단계: UI 컴포넌트 개발 (완료)**
- 재사용 가능한 기본 위젯 구축 (버튼, 입력창, 카드, 바텀시트 등) — `lib/components/widgets/` 하위에 버튼, 태그, 텍스트필드, 체크박스, 라디오, 토글, 슬라이더, 툴팁, 토스트, 얼럿 다이얼로그, 바텀시트, 인디케이터, 스피너, 탭바, BND 등 구현
- 디자인 시스템 기초 작성 — `lib/components/color.dart`(컬러), `font.dart`(타이포), `image.dart`(아이콘)에 Figma 변수/이펙트와 동기화된 토큰 정의

**2단계: 뼈대 레이아웃 작성 (완료)**
- 네비게이션 구조 구현 (go_router 설정) — `lib/core/router/app_router.dart`에 `StatefulShellRoute`(매물/홈/지도 3탭) + `TypedGoRoute` 기반 하위 라우트(찾기/등록/상세) 구성
- 화면 전환 / 팝업 표시 로직 — ViewModel의 `navigateTo` 이벤트 필드 + View의 `ref.listen` 패턴(`home_vm.dart`/`home_screen.dart` 예시) 적용, `showAppAlertDialog`/`showAppBottomSheet`/`showAppToast` 팝업 표시 함수 구현
- 주요 탭/페이지 뼈대 — `MainShell` + `Tabbar`로 매물/홈/지도 탭 전환 구현, 찾기·등록·상세 페이지는 뼈대만 존재 (세부 레이아웃은 3단계에서 진행)

**3단계: 세부 페이지 UI 레이아웃** (API 없이 선 작업 가능)
- 매물 리스트 페이지 (검색/필터 UI)
- 매물 상세 페이지
- 매물 수정 페이지
- 매물 삭제 기능 UI

**4단계: 로컬 저장 기능 추가**
- Drift DB 연동 — `lib/data/local/` (구현 완료: `PropertyTable`, `AppDatabase`)
- Property 모델 정의 — 도메인 모델은 Freezed, 저장용 테이블은 Drift로 분리하고 Repository 구현체에서 매핑
- 동기화 대비 식별자·필드 포함: 기본키는 앱에서 생성한 UUID(`id`), `updatedAt`, `deletedAt`(소프트 삭제, 삭제 시 행을 지우지 않고 표시), `syncedAt`(nullable, 마지막으로 동기화된 시점의 `updatedAt` 값. `syncedAt == null || updatedAt > syncedAt`이면 동기화 필요)
- 서버 DB 기본키는 숫자 `id`를 유지하고 앱 UUID는 `uuid` 컬럼(UNIQUE)으로 매핑됨 (백엔드 설계 기준)
- Repository / UseCase 구현
- Riverpod Notifier로 상태 관리

**5단계: 지도 SDK 연결**
- 지도 라이브러리 통합
- 지도 탭 추가
- 매물 위치 표시

**6단계: 플레이스토어 배포 (1차 릴리즈)**
- 1~5단계 완료 후 배포 진행

**7단계: 백엔드 연동 (2차 릴리즈 준비)**
- vine-butler-backend API/클라우드 세팅 완료 후 매물 정보 서버 업로드 연동
- 기존 로컬 데이터 동기화: 동기화 필요(`syncedAt == null || updatedAt > syncedAt`)한 매물을 UUID 기준 upsert로 일괄 업로드(재시도 안전) → 성공 시 업로드한 시점의 `updatedAt` 값을 `syncedAt`에 기록, 이후 `updatedSince` 기준으로 서버 변경분(크롤링 데이터 포함)을 받아 로컬에 반영
- 충돌 처리는 1차에서 마지막 수정(`updatedAt`) 우선
- 로그인 기능 추가
- 백엔드에서 크롤링한 부동산 정보(네이버 부동산 등) 반영을 위한 UI 수정
- 완료 후 앱 업데이트 배포

## 프로젝트 구조

Repository Pattern + MVVM 기반. 1단계에서는 모듈화 없이 단순한 구조로 유지.

```
lib/
  main.dart
  core/
    router/              # go_router 설정
    di/                  # Riverpod provider (DB, Repository 구현체를 인터페이스 타입으로 노출)
    theme/               # 앱 테마, 색상, 텍스트 스타일
    constants/           # 전역 상수
    network/             # dio 인스턴스, 인터셉터
  domain/                # 순수 Dart (Drift/Flutter 의존 금지)
    model/               # 도메인 모델(Freezed)
    repository/          # Repository 인터페이스
    usecase/             # UseCase
  data/
    local/
      app_database.dart  # Drift DB
      tables/            # Drift 테이블 정의
    mapper/              # Drift Row <-> 도메인 모델
    repository/          # Repository 구현체
  features/
    apply_property/ property_list/ property_detail/ map/ ...
      presentation/      # 화면, ViewState, VM (domain 인터페이스만 참조)
  components/
    widgets/             # 공통 재사용 위젯
  shared/
    utils/               # 유틸 함수
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

### 파일 / 네이밍
- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- 변수·함수명: `camelCase`
- 상수: `camelCase` (Dart 관례 따름, `SCREAMING_SNAKE` 사용 안 함)

### 상수·변수 위치
- 클래스 안 **두 곳 이상의 메서드에서 함께 쓰는 값만** 클래스 필드(`static const`/`static final` 등)로 꺼냄
- 한 메서드에서만 쓰는 값(정규식, 코드 집합, 메시지 등)은 그 메서드의 지역변수로 작성
  - 예: `_filterKeyword`에서만 쓰는 `RegExp` → 함수 안 `final blockedCharacters`, `search()`·`_handleError()`가 함께 쓰는 `_emptyPage` → 클래스 필드

### if문
- 본문이 문장 하나면 한 줄로 쓰고 중괄호는 유지 (`if (x) return;`처럼 중괄호 생략 금지)
  - 줄이 길어져도 한 줄 유지
- 본문이 두 문장 이상이면 여러 줄로 작성
- 한 줄 if 앞뒤에는 빈 줄을 둬서 다른 로직과 구분
  - 연속된 guard는 빈 줄 없이 묶음, 블록 마지막 줄이면 뒤 빈 줄 생략
- `dart format`은 한 줄 블록을 여러 줄로 펼치므로 파일 전체에 실행하지 않음

```dart
final keyword = _filterKeyword(query);

if (keyword.isEmpty) { return _emptyPage; }

final response = await _jusoApi.search(keyword: keyword, page: page);

if (!response.isOk) { throw ApiException.badRequest(response.errorMessage); }
if (response.addresses.isEmpty) { return null; }

return ...;
```

### 개행
- switch문(`case X:` 형태)은 case 블록 사이마다 빈 줄을 둠
  - `case A:` 바로 아래 `case B:`가 붙는 fall-through 묶음, `switch (...) {` 바로 다음 첫 case는 예외
  - switch 식(`=>` 화살표 형태)은 해당 없음
- 지역 변수 선언 뒤 다른 코드가 오기 전에 빈 줄을 둠
  - 연속된 선언은 빈 줄 없이 한 묶음 (`final address` / `final latitude` / `final longitude`)
  - 블록 마지막(`}` 바로 앞)이면 생략

```dart
switch (action) {
  case _ToggleFurniture(:final option):
    final options = {...state.furnitureOptions};

    if (!options.remove(option)) { options.add(option); }

    state = state.copyWith(furnitureOptions: options);

  case _Save():
    final mockPropertyId = ref.read(propertyListVMProvider).items.length;

    ref.read(propertyListEventVMProvider.notifier).action(PropertyListEventAction.register(mockPropertyId));
    state = state.copyWith(navigateTo: () => const PropertyListRoute().location);

  case _PopNavigation():
    state = state.copyWith(navigateTo: () => null);
}
```

### 위젯
- 기본은 `StatelessWidget`, 상태가 필요하면 `ConsumerWidget` 사용
- `StatefulWidget` + `setState`는 순수 UI 로컬 상태(애니메이션, 포커스)에만 허용
- 위젯 파일 하나에 public 위젯 하나를 원칙으로 함

### 상태관리 (Riverpod)
- 비즈니스 로직은 반드시 Provider 안에 둠 (위젯에 직접 쓰지 않음)
- `ref.watch`는 빌드에, `ref.read`는 이벤트 핸들러에 사용
- 전역 상태는 `NotifierProvider` / `AsyncNotifierProvider` 우선

### 네비게이션
- 네비게이션 실행(`context.push`/`pop`/`go`)은 항상 View(위젯)에서 함 — ViewModel이 라우터를
  직접 호출하지 않음
- API 응답 등 비즈니스 로직 결과에 따라 이동해야 할 때: ViewState에 일회성 이벤트 필드(예:
  `navigateTo`)를 두고, View의 `build()`에서 `ref.listen`으로 감지해 이동 실행
  ("UI State vs UI Event" 패턴)
- `ref.watch`는 렌더링용, `ref.listen`은 네비게이션/스낵바/다이얼로그 같은 1회성
  부수효과(side effect)용으로 구분해서 사용
- 이벤트 필드는 소비 후 반드시 리셋할 것 (특히 Freezed 등 값 동등성을 쓰는 상태에서 동일
  이벤트가 연달아 발생해도 다시 감지되게 하기 위함)
- 탭 전환/탭 루트 복귀처럼 화면 구조 자체에 종속된 네비게이션은 View 레이어에 남기고, 이
  패턴은 비즈니스 로직이 결정하는 네비게이션에만 적용

### 라우팅 전략 (go_router)
- id 같은 리소스 식별자는 path parameter로 전달 (`extra`는 이미 메모리에 있는 객체를 재직렬화
  없이 그대로 넘길 때만 사용)
- `build_runner` + `go_router_builder`(`GoRouteData`/`@TypedGoRoute`) 기반 typed route로
  전체 라우트를 통일해서 사용 중 (`lib/core/router/app_router.dart` + 생성된
  `app_router.g.dart`) — 문자열 기반 `GoRoute`/`context.push('/path')`는 사용하지 않음
- 새 라우트 추가 시에도 `GoRouteData` 서브클래스 + `@TypedGoRoute`로 정의하고
  `dart run build_runner build --delete-conflicting-outputs`로 코드 생성할 것
- ViewModel에서 네비게이션 이벤트로 경로를 넘길 때도(`navigateTo` 필드) 리터럴 문자열 대신
  해당 라우트의 `.location`을 사용 (예: `FindPropertyRoute().location`)

### 주석
- 함수 안에서 코드 한 줄 한 줄이 무엇을 하는지 설명하는 주석은 쓰지 않음 (이름으로 충분함)
- 코드만 봐서는 의미를 알 수 없는 값(외부 API 오류 코드, 매직 넘버, 외부 규격·제약 등)은 함수/클래스 위에 `///` 문서 주석으로 설명
- 작성 형식
  - 첫 줄: 대상을 명사형 한 줄로 (마침표 없음). 예: `/// 도로명주소 API의 errorCode 처리 함수`
  - 다음 줄은 빈 `///`
  - 값 목록은 `` /// - `값`: 짧은 의미 `` 형태, 값 순서대로 정렬, 마침표 없음
  - 출처·조건 같은 보충은 같은 줄 괄호 안에 씀. 예: `(좌표제공 API 문서 기준)`
  - 코드로 읽을 수 있는 처리 방식(어떤 예외를 던지는지 등)은 주석에 반복하지 않음

```dart
/// 도로명주소 API의 errorCode 처리 함수
///
/// - `E0001`: 승인되지 않은 키
/// - `E0005`: 검색어가 입력되지 않음
/// - `E0007`: 짧은 시간에 요청이 몰림 (좌표제공 API 문서 기준)
/// - `-999`: 시스템 에러
```

### 기타
- UI 작업 패턴(레이아웃, 컴포넌트, VM Action, 네비게이션 등)은 `.claude/ui_patterns.md` 참고

## Claude에게 주는 지침

### 작업 전 확인 사항
- 새 패키지 추가 전에 반드시 먼저 나에게 물어볼 것
- 기존 파일 구조를 크게 바꾸는 리팩터링은 먼저 제안 후 승인받고 진행
- `flutter analyze` 통과 여부를 작업 완료 기준으로 삼을 것

### 하지 말아야 할 것
- 요청하지 않은 기능 추가 / 리팩터링 금지
- 함수 안 코드 한 줄씩 설명하는 주석 금지 (작성 기준은 "코딩 규칙 > 주석" 참고)
- `// TODO`, `// FIXME` 남기고 작업 마무리 금지

### 응답 스타일
- 한국어로 응답
- 코드 변경 후 변경된 내용을 간결하게 요약
- 여러 파일을 수정할 경우 어떤 파일을 왜 수정했는지 알려줄 것

### .claude/TODO.md 파일 작성
- 사용자가 추후 작업해야하는 일을 투두리스트에 추가해달라고 하면 .claude/TODO.md경로에 작성할 것.
- 작업을 진행 중에 .claude/TODO.md에 적혀있는 내용이 현재 진행하는 것과 유사하다면 사용자에게 함께 수정할 것인지 물어보고 허락을 받은 뒤 진행

### 사용자의 질문에 답할 때
- 아래와 같이 비교하거나 비유하여 설명할 경우 비교하는 코드를 좌우로 배치하여 한 눈에 비교할 수 있도록 보여줘야함
- 사용자가 하는 기술적인 질문 중 dart언어 규칙이 swift에 동일한 개념이 있다면 swift에 비유하여 설명할 것   
- 동시성 처리에 대한 개념을 사용자가 물어볼 경우 답변이 swift concurency와 비슷한 개념이라면 비유하여 설명할 것
- 반응형 프로그래밍에 대한 질문 중 Combine과 유사한 기능을 하는 개념이라면 이를 비유하여 설명할 것
- SwiftUI에서 처리하는 데이터 바인딩 방식과 Riverpod의 방식이 다른 경우 차이점을 코드로 비교하여 설명할 것
