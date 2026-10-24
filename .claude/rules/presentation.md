---
paths:
  - "lib/features/**"
  - "lib/components/**"
  - "lib/core/router/**"
---

# 화면·상태관리·네비게이션 규칙

## 위젯
- 기본은 `StatelessWidget`, 상태가 필요하면 `ConsumerWidget` 사용
- `StatefulWidget` + `setState`는 순수 UI 로컬 상태(애니메이션, 포커스)에만 허용
- 위젯 파일 하나에 public 위젯 하나를 원칙으로 함

## 상태관리 (Riverpod)
- 비즈니스 로직은 반드시 Provider 안에 둠 (위젯에 직접 쓰지 않음)
- `ref.watch`는 빌드에, `ref.read`는 이벤트 핸들러에 사용
- 전역 상태는 `NotifierProvider` / `AsyncNotifierProvider` 우선

## 네비게이션
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

## 라우팅 전략 (go_router)
- id 같은 리소스 식별자는 path parameter로 전달 (`extra`는 이미 메모리에 있는 객체를 재직렬화
  없이 그대로 넘길 때만 사용)
- `build_runner` + `go_router_builder`(`GoRouteData`/`@TypedGoRoute`) 기반 typed route로
  전체 라우트를 통일해서 사용 중 (`lib/core/router/app_router.dart` + 생성된
  `app_router.g.dart`) — 문자열 기반 `GoRoute`/`context.push('/path')`는 사용하지 않음
- 새 라우트 추가 시에도 `GoRouteData` 서브클래스 + `@TypedGoRoute`로 정의하고
  `dart run build_runner build --delete-conflicting-outputs`로 코드 생성할 것
- ViewModel에서 네비게이션 이벤트로 경로를 넘길 때도(`navigateTo` 필드) 리터럴 문자열 대신
  해당 라우트의 `.location`을 사용 (예: `FindPropertyRoute().location`)

## 기타
- UI 작업 패턴(레이아웃, 컴포넌트, VM Action, 네비게이션 등)은 `.claude/ui_patterns.md` 참고
