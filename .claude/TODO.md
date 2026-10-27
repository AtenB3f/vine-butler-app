# TODO

## 출시 준비 코드 수정 (`.claude/RELEASE_CHECKLIST.md` 참고)
- [x] main `AndroidManifest.xml`에 `INTERNET` 권한 추가
- [x] Android `android:label` → 넝쿨집사
- [x] iOS `CFBundleDisplayName` → 넝쿨집사
- [x] Android 릴리즈 서명: 키스토어 생성 + `key.properties`(gitignore) + `build.gradle.kts` release signingConfig 연결
- [x] iOS `PrivacyInfo.xcprivacy` 추가
- [x] Info.plist에 `ITSAppUsesNonExemptEncryption = NO` 추가
- [x] `pubspec.yaml` description 수정
- [x] 앱 아이콘 교체

## PR 리뷰 리팩터링 (#1, #3 코멘트)
- [ ] 매물 등록 금액 액션 이름 정리: `ApplyPropertyTypeAction.nextField()` → `next()`, `next()` → `confirm()` (#1, 코멘트는 `find_property_vm.dart`에 달림)
- [ ] 금액 변경 액션 통일: `changePrice`/`changeMonthlyRent`/`changeMaintenanceCost`를 하나로 합치고 분기는 VM에서 처리, 화면의 `switch (field)` 제거 — `apply_property_type_screen.dart`, 매물 수정(`EditPropertyAction`)도 같은 구조면 함께 (#1)
- [ ] 지도 카메라 변경 비교 값(`userLocation`·`cameraLocation`·`zoom`·`isLoaded`·`cameraRequestId`)을 클래스 하나로 묶기 — `native_map.dart` (#3)
- [ ] 지도 로딩 상태 `_isPropertyLoaded`·`_isLocationLoaded`를 하나로 묶기 — `map_vm.dart` (#3)
