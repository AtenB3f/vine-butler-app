---
paths:
  - "lib/**/*.dart"
  - "test/**/*.dart"
  - "tool/**/*.dart"
---

# Dart 코딩 규칙

## 파일 / 네이밍
- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- 변수·함수명: `camelCase`
- 상수: `camelCase` (Dart 관례 따름, `SCREAMING_SNAKE` 사용 안 함)

## 상수·변수 위치
- 클래스 안 **두 곳 이상의 메서드에서 함께 쓰는 값만** 클래스 필드(`static const`/`static final` 등)로 꺼냄
- 한 메서드에서만 쓰는 값(정규식, 코드 집합, 메시지 등)은 그 메서드의 지역변수로 작성
  - 예: `_filterKeyword`에서만 쓰는 `RegExp` → 함수 안 `final blockedCharacters`, `search()`·`_handleError()`가 함께 쓰는 `_emptyPage` → 클래스 필드

## if문
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

## 개행
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

## 주석
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

