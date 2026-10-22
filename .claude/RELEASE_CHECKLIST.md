# 출시 체크리스트 (1차 릴리즈)

## 0. 공통
- [x] 앱 이름 확정: **넝쿨집사** (스토어 노출명 / 홈화면명)
- [x] iOS `CFBundleDisplayName`(현재 "Vine Butler") → 넝쿨집사
- [x] 버전 확정: **1.0.0(1)** (`version: 1.0.0+1`), 이후 업로드마다 빌드번호 증가
- [x] 앱 아이콘 교체 (1024×1024, 투명 배경 X) — iOS AppIcon / Android mipmap·adaptive icon
- [x] 스플래시(LaunchScreen / launch_background) 교체
- [ ] 개인정보처리방침 URL 준비 (양 스토어 필수, 웹페이지 호스팅)
- [ ] 고객 지원 URL·이메일
- [ ] 릴리즈 빌드에서 env.json 주입 확인 (`--dart-define-from-file=env.json`)
- [ ] 네이버 지도 콘솔(NCP)에 릴리즈 번들ID/패키지명 등록
- [ ] 도로명주소 API 키 운영용인지 확인
- [ ] `flutter analyze` 통과, 실기기 릴리즈 빌드 동작 확인 (지도·주소검색·사진첨부·DB 저장)
- [ ] 디버그 로그/테스트 데이터 제거 (`kDebugMode` 가드 확인)
- [ ] `pubspec.yaml` description 수정

## 1. iOS / App Store
- [x] Apple Developer Program 가입
- [x] App Store Connect에서 앱 생성 (번들 ID `com.atenb.vinebutler`)
- [ ] 배포 인증서·프로비저닝 (Xcode Automatic signing)
- [x] `PrivacyInfo.xcprivacy` 추가 (사용 API 사유: UserDefaults, 파일 타임스탬프 등 — 플러그인 포함)
- [ ] Info.plist 권한 문구 점검 (사진 ✅, 카메라·위치 사용 시 추가)
- [ ] 수출 규정: `ITSAppUsesNonExemptEncryption = NO`
- [ ] 스크린샷: 6.9"(또는 6.7") iPhone 필수, iPad 지원 시 13" iPad 필수 (지원 안 하면 iPhone 전용 설정)
- [ ] 앱 설명·키워드·부제·카테고리(비즈니스/생산성)·연령등급 설문
- [ ] 앱 개인정보 라벨(App Privacy) 작성 — 수집 데이터 없음 (도로명주소·Geocode는 실시간 처리, NMapsMap 3.23.0 manifest 수집 항목 없음 확인)
- [ ] 심사용 메모 (로그인 없음 명시, 기능 설명)
- [ ] `flutter build ipa --release --dart-define-from-file=env.json` → Transporter/Xcode 업로드
- [ ] TestFlight 내부 테스트 → 심사 제출

## 2. Android / Play Store
- [x] Google Play Console 개발자 계정
- [ ] **신규 개인 계정이면 비공개 테스트 12명 이상 × 14일 연속** 후 프로덕션 신청 가능
- [ ] 업로드 키스토어 생성 (`keytool`) + `android/key.properties` (gitignore) + `build.gradle.kts` release signingConfig 연결
- [ ] 키스토어·비밀번호 백업 (분실 시 업데이트 불가)
- [ ] Play App Signing 사용
- [ ] **main AndroidManifest에 `INTERNET` 권한 추가**
- [x] `android:label`을 "넝쿨집사"로 변경
- [ ] targetSdk가 Play 요구치(현재 API 35) 이상인지 확인
- [ ] R8 난독화 시 drift/naver map 동작 확인
- [ ] `flutter build appbundle --release --dart-define-from-file=env.json` (.aab)
- [ ] 스토어 등록정보: 앱 이름(30자), 간단 설명(80자), 자세한 설명, 아이콘 512×512, 그래픽 이미지 1024×500, 휴대전화 스크린샷 2장 이상
- [ ] 앱 콘텐츠: 개인정보처리방침, 데이터 보안 양식, 콘텐츠 등급, 타겟 연령, 광고 포함 여부
- [ ] 내부 테스트 → 비공개 테스트 → 프로덕션

## 3. 출시 후
- [ ] 크래시 수집 도구 도입 여부 결정 (Crashlytics/Sentry — 패키지 추가는 별도 승인)
- [ ] 리뷰·문의 대응 채널
