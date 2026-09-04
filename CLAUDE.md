# Vine Butler — Claude Code 가이드

## 프로젝트 개요

- **앱 설명**
공인중개사를 위한 부동산 매물을 저장하고 원하는 조건대로 필터를 걸어 검색할 수 있는 어플리케이션.
전세 / 월세 / 매매 타입으로 구분하여 관리함.
지도 SDK를 연동하여 매물 주소와 연동되어 지도로 표시 가능하도록 함.
추후 백엔드를 연동할 경우 네이버 부동산에서 검색한 내용을 크롤링한 데이터도 표기 가능하도록 할 예정.

- **타겟 플랫폼**: Android / iOS / Windows
- **최소 지원 버전**: Android 6.0 (API 23) / iOS 16.0 / Windows 10
- **현재 버전**: 1.0.0

## 기술 스택

| 역할 | 라이브러리 | 버전 |
|---|---|---|
| 상태관리 | flutter_riverpod | ^3.2.1 |
| 라우터 | go_router | — |
| 로컬 DB | Isar (예정) | — |
| 백엔드 | [추후 연동] | — |

Dart SDK: `^3.9.2`

## 아키텍처 전략

클린 아키텍처를 단계적으로 도입합니다:

- **1단계 (현재)**: 구현체와 프로토콜 분리, Repository / UseCase 레이어 도입 (모듈화, 중앙제어 X)
- **2단계**: 중앙 제어 로직 추가
- **3단계**: 모듈화 및 의존성 관리 고도화

## 개발 순서 (순차적 진행)

**1단계: UI 컴포넌트 개발**
- 재사용 가능한 기본 위젯 구축 (버튼, 입력창, 카드, 바텀시트 등)
- 디자인 시스템 기초 작성

**2단계: 뼈대 레이아웃 작성**
- 네비게이션 구조 구현 (go_router 설정)
- 화면 전환 / 팝업 표시 로직
- 주요 탭/페이지 뼈대

**3단계: 세부 페이지 UI 레이아웃** (API 없이 선 작업 가능)
- 매물 리스트 페이지 (검색/필터 UI)
- 매물 상세 페이지
- 매물 수정 페이지
- 매물 삭제 기능 UI

**4단계: 로컬 저장 기능 추가**
- Isar DB 연동
- Property 모델 정의 (Freezed + Isar)
- Repository / UseCase 구현
- Riverpod Notifier로 상태 관리

**5단계: 지도 SDK 연결**
- 지도 라이브러리 통합
- 지도 탭 추가
- 매물 위치 표시

## 프로젝트 구조

Repository Pattern + MVVM 기반. 1단계에서는 모듈화 없이 단순한 구조로 유지.

```
lib/
  main.dart
  core/
    router/              # go_router 설정
    theme/               # 앱 테마, 색상, 텍스트 스타일
    constants/           # 전역 상수
    network/             # dio 인스턴스, 인터셉터
  features/
    property/            # 매물
      domain/            # 모델(Freezed), Repository 인터페이스
      data/
        local/           # 로컬 DB 접근 (Isar 등)
        remote/          # 백엔드 API (추후)
      presentation/
        screens/         # 화면 위젯
        widgets/         # 매물 전용 위젯
        providers/       # Notifier (ViewModel)
    auth/                # 로그인
      domain/
      data/
      presentation/
    map/                 # 지도 SDK 연동
      presentation/
        screens/
        widgets/
        providers/
  shared/
    widgets/             # 공통 재사용 위젯
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
```

## 코딩 규칙

### 파일 / 네이밍
- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- 변수·함수명: `camelCase`
- 상수: `camelCase` (Dart 관례 따름, `SCREAMING_SNAKE` 사용 안 함)

### 위젯
- 기본은 `StatelessWidget`, 상태가 필요하면 `ConsumerWidget` 사용
- `StatefulWidget` + `setState`는 순수 UI 로컬 상태(애니메이션, 포커스)에만 허용
- 위젯 파일 하나에 public 위젯 하나를 원칙으로 함

### 상태관리 (Riverpod)
- 비즈니스 로직은 반드시 Provider 안에 둠 (위젯에 직접 쓰지 않음)
- `ref.watch`는 빌드에, `ref.read`는 이벤트 핸들러에 사용
- 전역 상태는 `NotifierProvider` / `AsyncNotifierProvider` 우선

### 기타

## Claude에게 주는 지침

### 작업 전 확인 사항
- 새 패키지 추가 전에 반드시 먼저 나에게 물어볼 것
- 기존 파일 구조를 크게 바꾸는 리팩터링은 먼저 제안 후 승인받고 진행
- `flutter analyze` 통과 여부를 작업 완료 기준으로 삼을 것

### 하지 말아야 할 것
- 요청하지 않은 기능 추가 / 리팩터링 금지
- 주석으로 "무엇을 하는 코드인지" 설명하는 것 금지 (이름으로 충분함)
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
