# UI 작업 패턴

find_property, apply_property(type/address/owner), property_detail, property_list 작업에서 정리한 UI 규칙입니다. 새 화면을 만들 때 이 문서를 먼저 확인합니다. 색은 hex가 아니라 `lib/components/color.dart`의 토큰 이름으로 적습니다.

## 1. 화면 파일 구성

```
lib/features/<기능>/
  <기능>_vm.dart                          # Notifier + Action
  presentation/
    <기능>_view_state.dart                # 화면이 그리는 값
    screens/<기능>_screen.dart            # 화면 (public 위젯 하나)
```

- 여러 단계로 나뉜 흐름은 단계 이름을 붙여 같은 폴더에 둡니다. 예: `apply_property/apply_property_type_*`, `apply_property_address_*`, `apply_property_owner_*`
- 새 화면을 추가할 때 체크리스트
  1. view_state / vm / screen 3개 파일 생성
  2. `lib/core/router/app_router.dart`에 `@TypedGoRoute` + `GoRouteData` 서브클래스 추가
  3. `dart run build_runner build --delete-conflicting-outputs`
  4. 이전 화면 VM에서 `XxxRoute().location`을 `navigateTo`로 세팅 (6장 참고)
  5. `flutter analyze` + `flutter build bundle --debug`

## 2. 레이아웃 규칙

| 항목 | 값 |
|---|---|
| 뼈대 | `AppScaffold(title:, leftIcon: AppIcons.chevronLeftMD, onLeftTap: () => context.pop(), body:)` |
| 본문 좌우 여백 | 20 |
| 제목 | `AppFontStyle.header1`, `TextColor.dark`, 위 100 / 아래 16 |
| 제목 ↔ 입력 영역 | 40 |
| 섹션 사이 | 40 |
| 입력창 사이 | 16 |
| 스크롤 콘텐츠 하단 | 40 (`EdgeInsets.fromLTRB(20, 0, 20, 40)`) |
| 하단 버튼 영역 | `Container` 배경 `StateColor.white`, `boxShadow: [AppShadow.top]`, 패딩 `fromLTRB(20, 10, 20, 20)` |
| 하단 버튼 | `FillButton(size: BoxButtonSize.large)`. 버튼이 2개면 `Column(spacing: 6)` |
| 비활성 / 활성 | `FillButtonType.gray` / `FillButtonType.medium` |

```dart
AppScaffold(
  title: '매물 등록',
  leftIcon: AppIcons.chevronLeftMD,
  onLeftTap: () => context.pop(),
  body: Column(
    children: [
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 40), child: ...)),
      _nextButton(state),   // 하단 버튼 영역
    ],
  ),
);
```

## 3. 컴포넌트 사용 규칙

- **새 공용 위젯을 만들기 전에 `lib/components/widgets`의 기존 컴포넌트를 먼저 찾는다.** 패딩·색이 조금 달라도 새 컴포넌트를 만들지 않는다.
- 공용 컴포넌트는 `XxxViewState`(표시값) + 콜백으로 만든다. 라벨 이름은 `text`.
- 공용 컴포넌트는 디자인만 알고 도메인(전화번호 규칙 등)을 모른다. 포맷 같은 규칙은 컴포넌트 밖에 둔다.

| 용도 | 컴포넌트 | 메모 |
|---|---|---|
| 선택 버튼(거래 유형) | `OutlineButton(size: large)` | 높이 46. 선택 시 `primary`(월세) / `secondary`(전세) / `tertiary`(매매), 미선택 `gray`. 타입은 `type.buttonType` |
| 선택 버튼(건물 유형) | `FillButton(size: medium)` | 높이 46. 선택 `light`, 미선택 `gray` |
| 하단 버튼 | `FillButton(size: large)` | 높이 50 |
| 보조 작은 버튼 | `OutlineButton(type: gray, size: small)` | 높이 30. 가로로 늘어나지 않게 `IntrinsicWidth`로 감쌈 |
| 거래 유형 표시 | `LineTag` | 타입은 `type.tagType` |
| 텍스트 입력 | `AppTextField` | viewState에 `title`, `placeholder`, `keyboardType` |
| 금액 입력 | `PriceField` + `PriceKeypad` | 7장 참고. 시스템 키보드·슬라이더 대신 사용 |
| 금액 슬라이더 | `AppSlider` | 필터 패널에서만 사용. 7장의 동기화 주의 참고 |
| 탭 가능한 영역 | `Pressable` | 눌림 효과 포함 |

## 4. 화면 내부 위젯 작성법

- 하위 UI는 별도 위젯 클래스를 만들지 않고 화면 클래스 안의 `Widget _xxx()` 메서드로 쪼갠다 (`PropertyDetailScreen`의 `_address()`, `_priceInfo()` 스타일).
- 메서드에 필요한 값은 **파라미터로 넘긴다**: `_address(context, ref, data, isMapVisible)`. `ConsumerWidget`은 불변 객체이고 `context`·`ref`는 그 `build()` 동안만 유효해서 인스턴스에 저장하지 않는다. 오래 붙잡은 `BuildContext`는 메모리 누수와 오래된 참조 버그의 원인이다.
- `StatefulWidget`/`setState`는 순수 UI 로컬 객체(컨트롤러, 포커스)에만 쓴다. 컨트롤러는 `initState`/`late final`로 만들고 `dispose()`에서 정리한다.

```
SwiftUI                               Flutter
var body: some View {                 Widget build(BuildContext context, WidgetRef ref) {
  header(title)  // 값을 전달            return _header(context, ref, data);
}                                     }
func header(_ t: String) -> some View Widget _header(BuildContext c, WidgetRef ref, Data data)
```

## 5. 상태·VM 패턴

### ViewState

- `presentation/*_view_state.dart`에 수기로 작성한 불변 클래스 + `copyWith` (freezed 사용 안 함)
- 리셋이 필요한 nullable 필드는 `T? Function()?`로 받는다: `copyWith(selected: () => null)`
- 초기값은 `factory ViewState.initial()`, 파생값은 getter (`isCompleted`, `midPrice`, `isMapVisible`)
- 화면 안에서 `ref.watch`는 렌더링, `ref.read`/`ref.listen`은 이벤트·부수효과(네비게이션, 컨트롤러 동기화)

### VM Action 작성 규칙

1. 상태를 바꾸는 진입점은 `void action(XxxAction action)` 하나이고 `switch`로 분기한다.
2. Action 하위 클래스는 **private**(`_Search`, `_Select` …)로 VM 파일 안에 둔다.
3. `sealed` 기반 클래스의 **`const factory` 생성자로 노출**한다. 다른 파일에서 하위 클래스를 직접 만들 수 없다.
4. **factory 이름은 최대한 간결한 동사원형**을 쓴다 (`search`, `select`, `next`, `reset`). 필요하면 **동사원형 + 명사**를 쓴다 (`changePrice`, `selectTransactionType`, `togglePropertyType`).
5. **Screen에서 ViewModel을 호출할 때는 무조건 `~Action`을 통해 호출한다.** VM의 개별 public 메서드(`changeName()` 등)를 화면이 직접 호출하지 않는다. `popNavigation()`도 예외 없이 Action으로 호출하는 것이 규칙이다.
6. 값이 없는 액션은 `const XxxAction.next()`로 호출한다.

```dart
// VM 파일
sealed class ApplyPropertyAddressAction {
  const ApplyPropertyAddressAction();

  const factory ApplyPropertyAddressAction.search(String query) = _Search;
  const factory ApplyPropertyAddressAction.select(AddressResultViewState address) = _Select;
  const factory ApplyPropertyAddressAction.next() = _Next;
}

class _Search extends ApplyPropertyAddressAction {
  final String query;

  const _Search(this.query);
}

class ApplyPropertyAddressVM extends Notifier<ApplyPropertyAddressViewState> {
  void action(ApplyPropertyAddressAction action) {
    switch (action) {
      case _Search(:final query):
        state = ...;
      case _Select(:final address):
        state = ...;
      case _Next():
        ...
    }
  }
}

// 화면 파일
onChanged: (query) => viewModel.action(ApplyPropertyAddressAction.search(query)),
onTap: () => viewModel.action(const ApplyPropertyAddressAction.next()),
```

```
Swift                                          Dart
enum AddressAction {                           sealed class AddressAction {
  case search(String)                            const factory AddressAction.search(String query) = _Search;
  case select(AddressResult)                     const factory AddressAction.select(AddressResult a) = _Select;
  case next                                      const factory AddressAction.next() = _Next;
}                                              }
vm.action(.search(query))                      vm.action(AddressAction.search(query))
// Dart 3.10 dot shorthand(.search(query))는 pubspec이 sdk ^3.9.2 라서 사용하지 않음
```

나쁜 예 → 좋은 예

```dart
viewModel.changeName(name);                                  // ✗ 개별 메서드 직접 호출
viewModel.action(ChangeName(name));                          // ✗ 전역 public 하위 클래스
viewModel.action(ApplyPropertyOwnerAction.changeName(name)); // ✓
```

## 6. 네비게이션 · 일회성 이벤트

- 화면 이동 실행(`context.push`/`pop`/`go`)은 항상 View에서 한다. VM은 라우터를 호출하지 않는다.
- 비즈니스 결과로 이동할 때: VM이 ViewState의 `navigateTo`에 `XxxRoute().location`을 세팅 → 화면이 `ref.handleEvent`로 감지해 이동 → 소비(`popNavigation`)로 리셋.
- 경로 문자열 리터럴은 쓰지 않는다 (`const ApplyPropertyOwnerRoute().location`).
- 토스트처럼 **다른 화면에서 온 일회성 이벤트**는 ViewState에 섞지 않고 이벤트 전용 VM(`PropertyListEventVM`)에 둔다.
- 감지·소비·처리 보일러플레이트는 `lib/shared/extensions/widget_ref_extension.dart`의 `ref.handleEvent`를 쓴다. `build()` 안에서 호출하고, 처음부터 세팅돼 있던 이벤트도 처리하며 처리는 한 프레임 뒤에 일어난다.

```dart
ref.handleEvent(
  applyPropertyOwnerVMProvider.select((state) => state.navigateTo),
  consume: () => viewModel.action(const ApplyPropertyOwnerAction.popNavigation()),
  onEvent: (location) => context.push(location),
);

ref.handleEvent(
  propertyListEventVMProvider.select((state) => state.registerId),
  consume: () => eventVM.action(const PropertyListEventAction.clearRegistration()),
  onEvent: (registerId) => showAppToast(context, const AppToastViewState(...), onTap: () => ...),
);
```

## 7. 입력 필드 · 금액 입력 · 슬라이더

- `TextEditingController`는 화면 State가 만들고 `dispose()`한다. **초기 텍스트는 VM 상태에서 읽는다** (`TextEditingController(text: ref.read(...).name)`). provider는 화면을 나가도 유지되므로, 안 그러면 재진입 시 입력창과 상태가 어긋난다.
- 전화번호는 `PhoneNumberEditingController`(`lib/shared/utils/`)를 `AppTextField`의 `controller`로 넘긴다. 입력이 반영되는 순간 `010-1234-5678` 형식으로 포맷된다. 숫자 키보드는 viewState의 `keyboardType: AppTextFieldKeyboardType.number`.
- 컨트롤러 값을 VM이 바꿔야 하면(예: `selected`가 null이 되면 입력창 비움) `ref.listen`에서 `controller.clear()`/`controller.value = ...`로 동기화한다.
- 금액은 `PriceField`(금액 칸) + `PriceKeypad`(키패드)로 입력한다. 모든 플랫폼 공통이고 제목(`금액`·`관리비` 등)은 화면이 `bold1`로 따로 그린다
  - 입력 중인 칸은 각 view_state의 칸 enum(`ApplyPropertyPriceField` 등) + `editingField`로 둔다. VM Action은 `edit(field?)`, `nextField()`(`>` 키, 다음 칸 → 마지막이면 닫기)
  - 칸마다 `FocusNode`를 `Focus`로 감싸고, 포커스를 얻으면 `edit(field)`, 모든 금액 칸이 포커스를 잃으면 `edit(null)`. VM → 포커스는 `ref.listen`으로 맞춘다. 바깥 탭(`AppScaffold`)이나 다른 입력란으로 포커스가 빠지면 키패드가 닫힌다
  - 키패드는 하단 버튼 자리에 `editingField == null ? 하단 버튼 : PriceKeypad`로 그린다
  - 표시: 금액 있으면 `text` 함축형 `formattedKRW` + `subText` 숫자형 `'${formattedNumber}원'`, 0이면 `0원`(관리비는 `관리비 없음`)이고 `subText` 없음
- **`AppSlider`(필터 패널)는 `ValueNotifier` 컨트롤러를 받는다.** 그래서 슬라이더 → VM(`addListener`)과 VM → 슬라이더(`ref.listen`) 두 길을 직접 이어야 한다. 한쪽을 빼먹으면 슬라이더 위치와 금액 표시가 어긋난다. 개선 후보는 12장 참고.
- 슬라이더 초기값은 `min ~ max`의 중간값(단위에 안 맞으면 내림)이고, 거래 유형이 바뀌면 새 범위의 중간값으로 재설정한다.

## 8. 공용 확장·유틸

`lib/shared/extensions/extensions.dart`(배럴)로 import 한다.

| 확장 | 대상 | 용도 |
|---|---|---|
| `label` | `PropertyTransactionType`, `PropertyTypeFilterOption` | 한글 라벨 |
| `buttonType` | `PropertyTransactionType` | `OutlineButtonType` 매핑 |
| `tagType` | `PropertyTransactionType` | `LineTagType` 매핑 |
| `formattedKRW` | `num` | `2880000000` → `28억 8000만원` |
| `formattedPhoneNumber` | `String` | 숫자만 남겨 `010-1234-5678` |

- 화면에 보이는 항목과 도메인 enum이 1:1이 아니면 `lib/domain`을 수정하지 않고 presentation에서 매핑한다. 예: 필터의 '단독/다가구' 버튼 하나 → `PropertyTypeFilterOption.singleMulti` → `{PropertyType.single, PropertyType.multi}`
- 파일명은 `snake_case`이고 `+` 같은 문자는 `file_names` 린트 때문에 쓸 수 없다 (`property_type_extension.dart`).

## 9. 디자인(Figma CSS) → 코드 변환

| Figma | 코드 |
|---|---|
| App/H1 (28/40, 700) | `AppFontStyle.header1` |
| App/Sub1~3 (18/20/22, 500) | `sub1` ~ `sub3` |
| App/Bold1~3 (13/15/16, 600) | `bold1` ~ `bold3` |
| App/Body1~3 (13/15/16, 400) | `body1` ~ `body3` |
| 글자색 진한 / 중간 / 연한 회색 | `TextColor.dark` / `medium` / `light` |
| 배경 연한 회색 | `BaseColor.light` |
| 상단 그림자 | `AppShadow.top` |
| 모서리 | 4 |

- 색은 hex를 읽은 뒤 `color.dart` 토큰에 대응시켜 이름으로 쓴다. 대응 토큰이 없을 때만 hex를 쓰고 따로 알린다.
- 디자인 안에서 같은 요소의 값이 서로 다르면(예: 회색 `#767676` / `#7A7A7A`) 토큰 하나로 통일하고 사용자에게 알린다.

## 10. 작업·검증 체크리스트

- 구현 전에 계획을 세우고 승인받는다. 새 패키지, 기존 파일 구조를 크게 바꾸는 리팩터링은 먼저 묻는다.
- 요청하지 않은 기능 추가·리팩터링 금지. `// TODO`로 마무리하지 않는다.
- 검증: `flutter analyze`(필수) + `flutter build bundle --debug`(Dart 컴파일 확인). 화면 동작 확인은 사용자가 한다.
- 일괄 치환에는 macOS `sed`가 `\b`(단어 경계)를 지원하지 않으므로 Python이나 `grep -E`를 쓰고, 치환 뒤에는 `grep`으로 잔여 여부를 확인한다.
- 라우트 수정 후에는 build_runner를 실행한다.

## 11. 알려진 문서-코드 불일치 (정리 후보)

5장의 규칙과 현재 코드가 다른 곳입니다. 코드는 아직 바꾸지 않았습니다.

- `popNavigation()`을 화면이 직접 호출: `HomeVM`, `PropertyListVM`, `PropertyDetailVM`, `ApplyPropertyTypeVM`, `ApplyPropertyAddressVM` → Action으로 전환 필요
- `PropertyListAction.filtering(data)` → 동사원형 규칙상 `filter(data)` 후보
- `HomeViewAction`, `PropertyDetailAction`은 `enum` 방식 → sealed + private 하위 클래스 + factory로 통일할지 결정 필요

## 12. 개선 후보

- `AppSlider`를 `ValueNotifier` 컨트롤러 대신 `value` + `onChanged(double)` 방식으로 바꾸면 필터 패널의 이중 동기화(`ValueNotifier`, 리스너, `ref.listen`)가 사라진다. 컴포넌트는 viewState + 콜백 방식이라는 규칙과도 맞는다.
