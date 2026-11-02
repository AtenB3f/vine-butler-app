---
status: accepted
date: 2026-11-02
decision-makers: AtenB
version: 1.3.0
---

# 백그라운드 전환 중 AI 생성 요청 유지를 위해 OS 전송 API를 Dio 어댑터로 연결

## 배경과 문제

AI 블로그 글쓰기는 매물 정보와 사진(최대 5장)을 CLOVA Studio(HCX-005)에 보내고 생성된 글을 받는다. <br>
포그라운드 응답 시간은 macOS 18.5초, iOS 21.0초였고, 사진 5장이나 토큰 조정을 고려해도 1분 이내로 예상한다. <br>
생성 중 사용자가 홈으로 나가면 요청이 끊긴다.
- iOS: 몇 초 뒤 앱이 suspend되면서 Dio(`dart:io` 소켓) 연결이 끊긴다.
- Android: Doze나 메모리 부족으로 프로세스가 멈추거나 종료된다.

2.0.0에서는 서버가 비동기 작업으로 생성할 예정이다(작업 ID를 바로 받고 결과는 나중에 조회). 그 전까지 앱이 직접 호출하는 구조에서 학습을 겸해 먼저 적용한다. 모바일은 아직 출시하지 않는다.

## 결정 요인

* 스토어 정책에 맞을 것 (Play Console 포그라운드 서비스 신고·심사 부담)
* 백그라운드로 가도 응답까지 받아 DB에 저장될 것
* 기존 API 클래스·인증·저장소·화면 코드를 바꾸지 않을 것
* 재시도 때문에 AI 생성을 두 번 해 토큰 비용이 늘지 않을 것
* iOS·Android 구조가 같을 것
* 새 패키지를 추가하지 않을 것

## 검토한 옵션

* 공통
  - 아무 처리 안 함 (실패하면 "다시 시도")
  - 서버 비동기 작업 (2.0.0)
* Android
  - dataSync 포그라운드 서비스
  - `shortService` 포그라운드 서비스
  - WorkManager
  - UIDT Job (사용자 시작 데이터 전송)
* iOS
  - `beginBackgroundTask`
  - `BGTaskScheduler` (`BGAppRefreshTask`, `BGProcessingTask`)
  - `BGContinuedProcessingTask` (iOS 26)
  - background URLSession

## 결정 결과

선택: "Android UIDT Job" + "iOS background URLSession"을 Dio 어댑터 하나로 연결 <br>
사유: 두 API 모두 OS가 "사용자가 시작한 네트워크 전송"용으로 제공하는 방식이라 정책에 맞는다. <br>
Dio의 `HttpClientAdapter`만 바꾸므로 인터셉터·API 클래스·저장소·화면은 그대로 둔다. <br>
두 플랫폼 모두 같은 채널 계약을 쓴다. 그래서 Dart 쪽 코드는 하나다.

* 구조: `ClovaStudioApi` → Dio(인터셉터 그대로) → `BackgroundTransferAdapter` → 채널 `vine_butler/background_transfer`
  - Android 14 이상: `BackgroundTransferJobService`(UIDT Job)가 `HttpURLConnection`으로 전송
  - iOS: `BackgroundTransfer`(background URLSession)가 `uploadTask(fromFile:)`로 전송
  - 그 밖(Android 14 미만, 예약 실패, 본문 없는 요청, 데스크톱): `UNAVAILABLE` → 기본 어댑터로 그대로 전송
* 적용 대상: `DioType.keepsAliveInBackground`가 true인 API(CLOVA)만, 모바일에서만 사용
* 시스템이 전송을 중지하면(`onStopJob`) 재예약하지 않고 실패로 돌려준다. 사용자가 "다시 시도"를 누르게 해서 생성이 두 번 되지 않게 한다.

### 영향

* 장점: 백그라운드로 가도 응답을 받아 저장한다. 앱 코드는 `dio_factory.dart`에서 어댑터만 바꾼다. 포그라운드 서비스가 아니라서 Play Console 신고서와 영상이 필요 없다.
* 단점: Android 14 미만(갤럭시 S20·Note20 등)은 보호 없이 전송한다. 플랫폼마다 HTTP 전송을 네이티브로 직접 구현해야 한다.
* 위험: 앱 프로세스가 종료되면 Dart의 Future가 사라져 결과가 저장되지 않는다.
  - Android: 메모리 부족, 작업 관리자의 "중지", 스와이프로 닫는 경우(미확인)
  - iOS: suspend 중 시스템이 종료한 경우, 사용자가 강제 종료한 경우(전송도 취소됨)

### 검증

#### iOS background URLSession
- 환경: iPhone 실기기, release 빌드, 디버거 없이 홈 화면에서 실행 (테스트를 위해 AI 메뉴 조건과 권한을 임시로 바꿈)
- 방법: AI 글쓰기 → 홈으로 나감 → 복귀
- 결과: 백그라운드에서 응답을 받아 Complete 화면이 보임

#### Android UIDT Job
- 환경: Android 14 이상 실기기
- 방법: AI 글쓰기 → 홈으로 나감 → 복귀
- 결과: 백그라운드에서 응답을 받아 Complete 화면이 보임
- 기록하지 않은 경우: `adb shell cmd jobscheduler timeout`로 시스템 중지를 흉내 냈을 때, 스와이프로 닫았을 때, 알림 권한을 거부했을 때

#### 응답 시간 (참고, 포그라운드 1회 측정)

| 환경 | 응답 시간 |
|---|---|
| macOS | 18,537ms |
| iOS | 21,042ms |

## 옵션별 장단점

### 공통: 아무 처리 안 함

* 장점: 코드가 없다.
* 단점: 홈으로 나가면 iOS에서는 거의 항상 실패한다.

### 공통: 서버 비동기 작업 (2.0.0)

* 장점: 앱이 종료돼도 서버가 끝까지 처리한다. 앱에 백그라운드 처리 코드가 필요 없다.
* 단점: 서버 구축 전이라 지금은 쓸 수 없다.

### Android: dataSync 포그라운드 서비스

* 장점: 구현이 간단하다(Dart 요청을 그대로 두고 프로세스만 살림). 모든 Android 버전에서 쓸 수 있다.
* 단점: Play Console에 포그라운드 서비스 신고서와 시연 영상이 필요하다. Android 15부터 24시간 중 6시간 제한이 있고, Google은 이 용도에 UIDT를 권장한다.
  - 실제로 구현까지 했다가 정책 문제로 되돌렸다.

### Android: `shortService` 포그라운드 서비스

* 장점: 타입 전용 권한이 없고 Play Console 신고 대상 표에 없다.
* 단점: Android 14 이상에서만 쓸 수 있다. 약 3분이 지나면 시스템이 타임아웃시킨다.

### Android: WorkManager

* 장점: 프로세스가 종료돼도 재시도하고, 재부팅 뒤에도 이어서 실행한다.
* 단점: 별도 isolate에서 DB·Dio·사진 리사이즈를 다시 초기화해야 한다. 결과를 Future가 아니라 DB로 화면에 전달해야 한다. 재시도하면 생성을 처음부터 다시 해서 토큰 비용이 다시 든다. `workmanager` 패키지가 필요하다.

### Android: UIDT Job

* 장점: Google이 "사용자가 시작한 네트워크 전송"에 권장하는 API다. 즉시 실행되고, 앱 대기 버킷 할당량의 영향을 받지 않는다. 포그라운드 서비스 신고가 필요 없다.
* 단점: Android 14 이상에서만 동작한다. Job 안에서 HTTP를 네이티브로 직접 보내야 한다. 요청 본문(수 MB)은 Job extras로 넘길 수 없어 메모리에 보관한다.

### iOS: `beginBackgroundTask`

* 장점: 권한이나 Info.plist 설정이 필요 없고, Dart 요청을 그대로 둘 수 있다.
* 단점: 추가 시간이 약 30초뿐이고 보장되지 않는다. 사진 5장 요청은 30초를 넘길 수 있다.

### iOS: `BGTaskScheduler` (`BGAppRefreshTask`, `BGProcessingTask`)

* 장점: 앱이 종료된 뒤에도 실행 기회를 받는다.
* 단점: 실행 시점을 OS가 정해서 "지금 바로"를 보장하지 않는다. 사용자가 결과를 기다리는 작업과 맞지 않는다.

### iOS: `BGContinuedProcessingTask` (iOS 26)

* 장점: 사용자가 시작한 작업을 백그라운드에서 이어서 처리하는 용도다.
* 단점: 진행률을 계속 보고해야 하는데, 응답 한 번을 기다리는 요청은 진행률을 낼 수 없다. iOS 26 이상에서만 동작한다(최소 지원은 iOS 15).

### iOS: background URLSession

* 장점: OS가 앱 프로세스 밖에서 전송을 이어 간다. suspend되거나 시스템이 앱을 종료해도 계속된다. iOS 7부터 있어서 지원 범위 전체에서 쓸 수 있고, Background Modes 설정도 필요 없다.
* 단점: upload·download task만 지원해 본문을 파일로 써서 보내야 한다. Dio로는 못 쓰고 네이티브로 구현해야 한다. 사용자가 강제 종료하면 전송이 취소된다.

## 추가 정보

- 코드 위치
  - `lib/core/network/adapters/background_transfer_adapter.dart`
  - `lib/core/network/dio_factory.dart`의 `DioType.keepsAliveInBackground`, `createDio`
  - `android/.../BackgroundTransfer.kt`, `BackgroundTransferJobService.kt`, `MainActivity.kt`
  - `ios/Runner/BackgroundTransfer.swift`, `AppDelegate.swift`
- 규칙
  - 네이티브는 `content-length` 헤더를 빼고 보낸다(본문 크기로 직접 계산).
  - iOS background 세션은 앱에 하나만 둔다(같은 identifier로 두 번 만들지 않음).
- 주의
  - iOS는 요청 타임아웃 180초와 별개로 전체 전송 제한 300초를 둔다(연결이 끊기면 OS가 다시 시도함).
  - iOS 실기기 테스트는 디버거가 붙어 있으면 suspend되지 않아 release 빌드로 해야 한다.
- 2.0.0 서버가 비동기 작업 방식이면 `keepsAliveInBackground`를 false로 두거나 이 어댑터를 제거한다. 그때 새 ADR로 이 결정을 대체한다.
- 참고: [사용자 시작 데이터 전송 (Android)](https://developer.android.com/develop/background-work/background-tasks/uidt), [포그라운드 서비스 요구사항 (Play Console)](https://support.google.com/googleplay/android-developer/answer/13392821)
