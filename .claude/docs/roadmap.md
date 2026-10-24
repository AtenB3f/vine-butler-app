# 로드맵

## 1.0.0 (1차 릴리즈)

**1단계: UI 컴포넌트 개발 (완료)**
- 재사용 가능한 기본 위젯 구축 (버튼, 입력창, 카드, 바텀시트 등) — `lib/components/widgets/` 하위에 버튼, 태그, 텍스트필드, 체크박스, 라디오, 토글, 슬라이더, 툴팁, 토스트, 얼럿 다이얼로그, 바텀시트, 인디케이터, 스피너, 탭바, BND 등 구현
- 디자인 시스템 기초 작성 — `lib/components/color.dart`(컬러), `font.dart`(타이포), `image.dart`(아이콘)에 Figma 변수/이펙트와 동기화된 토큰 정의

**2단계: 뼈대 레이아웃 작성 (완료)**
- 네비게이션 구조 구현 (go_router 설정) — `lib/core/router/app_router.dart`에 `StatefulShellRoute`(매물/홈/지도 3탭) + `TypedGoRoute` 기반 하위 라우트(찾기/등록/상세) 구성
- 화면 전환 / 팝업 표시 로직 — ViewModel의 `navigateTo` 이벤트 필드 + View의 `ref.listen` 패턴(`home_vm.dart`/`home_screen.dart` 예시) 적용, `showAppAlertDialog`/`showAppBottomSheet`/`showAppToast` 팝업 표시 함수 구현
- 주요 탭/페이지 뼈대 — `MainShell` + `Tabbar`로 매물/홈/지도 탭 전환 구현, 찾기·등록·상세 페이지는 뼈대만 존재 (세부 레이아웃은 3단계에서 진행)

**3단계: 세부 페이지 UI 레이아웃 (완료)**
- 매물 리스트 페이지 (검색 오버레이, 필터 패널, 필터 태그로 조건 제외)
- 매물 찾기 / 등록(유형 → 주소 → 집주인 → 추가 정보) 페이지
- 매물 상세 페이지 (지도·이미지 전환)
- 매물 수정 페이지 (주소 수정, 이미지 추가·삭제 포함)
- 매물 삭제 기능 UI

**4단계: 로컬 저장 기능 추가 (완료)**
- Drift DB 연동 — `lib/data/local/` (`PropertyTable`, `PropertyImageTable`, `AppDatabase`, 현재 `schemaVersion` 1)
- 출시 후에는 사용자 기기에 DB가 있으므로 테이블 변경 시 `schemaVersion` 증가 + 마이그레이션 작성 필수 (누락 시 기존 데이터 손실)
- 매물 사진은 `lib/data/storage/`(`ImageStorage` 구현체)에서 파일로 저장하고 DB에는 파일명만 보관
- Property 모델 정의 — 도메인 모델은 Freezed, 저장용 테이블은 Drift로 분리하고 Repository 구현체에서 매핑
- 동기화 대비 식별자·필드 포함: 기본키는 앱에서 생성한 UUID(`id`), `updatedAt`, `deletedAt`(소프트 삭제, 삭제 시 행을 지우지 않고 표시), `syncedAt`(nullable, 마지막으로 동기화된 시점의 `updatedAt` 값. `syncedAt == null || updatedAt > syncedAt`이면 동기화 필요)
- 서버 DB 기본키는 숫자 `id`를 유지하고 앱 UUID는 `uuid` 컬럼(UNIQUE)으로 매핑됨 (백엔드 설계 기준)
- Repository / UseCase 구현
- Riverpod Notifier로 상태 관리

**5단계: 지도 SDK 연결 (완료)**
- 지도 라이브러리 통합 — `lib/components/widgets/map/`에 플랫폼별 분리 (`native_map`: 네이버 지도 SDK, `mac_map`/`windows_map`: 웹뷰)
- 지도 탭 추가 — 검색 BND·필터 패널, 필터 조건에 따른 마커 필터링
- 매물 위치 표시 — 가격 마커, 마커 선택 시 매물 카드

**6단계: 스토어 배포 (1차 릴리즈, 진행 중)**
- iOS: App Store 심사 중
- Android: 비공개 테스트 중 → 12명 이상 × 14일 연속 테스트 충족 후 프로덕션 신청
- 세부 항목·출시 후 할 일(크래시 수집 도구 결정, 리뷰 대응)은 `.claude/RELEASE_CHECKLIST.md` 참고

## 1.1.0

- 금액 변경 시 슬라이더 대신 커스텀 금액 입력 컴포넌트로 변경 (현재 `AppSlider` 사용처 교체)
- 금액 입력용 키보드 UI 컴포넌트 추가
- (모바일) 상세 페이지에서 사진을 탭하면 크게 보기
- 지도 탭 첫 화면을 현재 위치 기준으로 표시, 현재 위치에서 가까운 순으로 정렬해 10개씩 페이지네이션
  - 현재 위치 조회 패키지 필요 (새 패키지 → 추가 전 승인), iOS 위치 권한 문구는 이미 있음
  - SQLite에 삼각함수가 없어 거리 정렬은 Dart 계산 또는 위경도 범위 근사로 처리

## 1.2.0

- 데스크톱 UI 적용 (범위는 별도 기획)
- Windows 자동 업데이트 (업데이트 패키지 + 업데이트 파일 호스팅 필요, 새 패키지 → 추가 전 승인)
- Windows 배포 (설치 파일 또는 Microsoft Store, 코드 서명 인증서 검토)
- macOS 배포 (Mac App Store 또는 Developer ID 서명·공증)
- 확인 필요: macOS 자동 업데이트 (Mac App Store 배포면 불필요, 스토어 밖 배포면 필요)

## 1.3.0 (데스크톱만 업데이트)

- 이미지 텍스트 인식(OCR) AI로 매물 등록 — Claude 이미지 입력으로 글자 인식 가능하므로 별도 OCR 없이 시작, 정확도가 부족하면 CLOVA OCR 검토
- 녹음 파일 분석 AI로 매물 등록 — 데스크톱은 파일 선택·끌어다 놓기로 입력, STT는 CLOVA Speech
  - 확인 필요: 데스크톱 앱 안 마이크 녹음도 넣을지
- 블로그 글 AI 작성 — 매물 상세 정보 + 사진(Claude 이미지 입력, 전송 전 리사이즈)으로 장점을 뽑아 글 생성
  - 네이버 블로그 글쓰기 API 종료로 자동 업로드 불가 → 본문 텍스트 복사 + 사진 폴더 열기 (HTML·사진 동시 복사는 PoC 후 결정)
- 매물 등록 공통 흐름: 추출(Claude structured outputs) → 확인 화면(`EditPropertyVM`에 새 매물 초안 모드 추가) → 저장
  - 추출한 주소는 `AddressUseCase`(도로명주소 검색 + Geocode)로 후보를 고르게 함
  - 대화·이미지에 없는 집주인 전화번호는 빈 칸으로 두고 필수 입력
  - 녹음 파일은 분석 직후 삭제
- API 키 처리: 서버리스 프록시 + 초대 코드
  - 앱 → 프록시(Cloudflare Workers·AWS Lambda 등) → CLOVA·Claude 순으로 호출, API 키는 프록시에만 둠
  - 사람별 초대 코드를 앱 설정에 입력해야 AI 기능이 보임 (코드 없는 사용자에게는 숨김), 사람별로 끊을 수 있음
  - Anthropic 콘솔 워크스페이스 지출 한도 + 프록시 호출 횟수 제한으로 비용 상한
  - 2.0.0 배포 시 프록시를 내려 1.3.0의 AI 기능 중단 (앱에는 "업데이트 필요" 안내)
- STT·AI 호출은 domain 인터페이스 뒤에 둠 → 2.0.0에서 백엔드 프록시 구현체로 교체 시 presentation 수정 없음
- 개발용 AI·STT 키가 배포 빌드에 들어가지 않도록 `tool/build.dart`에서 해당 키가 있으면 릴리즈 빌드 중단
- AI 데이터 전송 동의 화면 (Mac App Store 배포 시 Apple 가이드라인 5.1.2(i) 해당)

## 2.0.0

- 백엔드 API 연동 (vine-butler-backend API/클라우드 세팅 완료 후)
- 회원가입 및 로그인 기능 추가
- 서버 데이터 저장 기능 추가 (매물 정보 서버 업로드)
- 인앱결제 기능 추가 (iOS·Android는 스토어 결제 필수, Windows·스토어 밖 macOS는 별도 결제 수단 필요)
- AI 기능 정식 전환
  - STT·AI 호출을 백엔드 프록시 구현체로 교체 (API 키는 서버에만, 로그인 사용자만 호출 + 사용량 제한)
  - 1.3.0 초대 코드 프록시 종료
  - 개인정보처리방침에 개인정보 국외 이전(이전받는 곳·국가·항목) 고지
  - App Store 개인정보 라벨·Play 데이터 보안 양식 갱신 ("수집 데이터 없음" → 변경)

## 2.1.0

- 로컬 데이터 동기화
  - 동기화 필요(`syncedAt == null || updatedAt > syncedAt`)한 매물을 UUID 기준 upsert로 일괄 업로드(재시도 안전) → 성공 시 업로드한 시점의 `updatedAt` 값을 `syncedAt`에 기록
  - 이후 `updatedSince` 기준으로 서버 변경분(크롤링 데이터 포함)을 받아 로컬에 반영
  - 충돌 처리는 1차에서 마지막 수정(`updatedAt`) 우선

## 2.2.0

- 1.3.0 버전에 추가한 AI 기능 모바일 적용
  - 앱 안 녹음: 매물 등록 화면 버튼으로 마이크 녹음 (대면 상담·스피커폰 통화용, 통화 회선 음성 직접 녹음은 OS가 막음)
  - 통화 녹음 파일 공유 받기: Android `SEND` + `audio/*` intent-filter → iOS Share Extension(Swift 타깃 + App Group)
  - 마이크 권한(iOS `NSMicrophoneUsageDescription`, Android `RECORD_AUDIO`), 스토어 개인정보 라벨에 "오디오 데이터" 추가
  - 녹음 화면에 녹음 적법성 안내 문구 (본인이 참여하지 않은 대화 녹음은 불법)
  - 첫 분석 전 AI 데이터 전송 동의 화면 (Apple 가이드라인 5.1.2(i))

## 2.3.0

- 마스터 권한용 크롤링 데이터 표기 기능 추가 (백엔드에서 크롤링한 네이버 부동산 등 정보 반영 UI, 2.0.0 계정 체계에 마스터 역할 추가 필요)

## 공통 메모

- 새 패키지는 추가 전 승인 (후보: 위치 조회, Windows 자동 업데이트, `record`, `receive_sharing_intent`/`share_handler`, `super_clipboard`)
- 브랜치는 각 버전 작업 시작 시 `main`에서 생성
- 모바일 스토어는 데스크톱 전용 버전(1.2.0·1.3.0)에서 업데이트 없음 → 모바일 다음 버전 번호는 그때 결정
