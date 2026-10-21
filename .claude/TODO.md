# TODO

## 출시 준비 코드 수정 (`.claude/RELEASE_CHECKLIST.md` 참고)
- [ ] main `AndroidManifest.xml`에 `INTERNET` 권한 추가
- [x] Android `android:label` → 넝쿨집사
- [x] iOS `CFBundleDisplayName` → 넝쿨집사
- [ ] Android 릴리즈 서명: 키스토어 생성 + `key.properties`(gitignore) + `build.gradle.kts` release signingConfig 연결
- [x] iOS `PrivacyInfo.xcprivacy` 추가
- [ ] Info.plist에 `ITSAppUsesNonExemptEncryption = NO` 추가
- [ ] `pubspec.yaml` description 수정
- [ ] 앱 아이콘·스플래시 교체
