---
status: accepted
date: 2026-10-30
decision-makers: AtenB
version: 1.3.0
---

# 진행 중인 같은 API 요청을 Dio 인터셉터에서 하나로 합침

## 배경과 문제

AI 글쓰기 화면의 VM(`propertyWriteVMProvider`)은 autoDispose다. 생성 중에 화면을 나갔다가 다시 들어오면 VM이 새로 만들어지고, CLOVA 생성 요청이 한 번 더 나간다. 같은 글을 두 번 생성해 토큰 비용과 시간이 낭비된다. <br>
같은 문제는 도로명주소·Geocode 같은 다른 API에서도 생길 수 있다.

## 결정 요인

* 화면 상태(VM)의 수명과 상관없이 동작할 것
* CLOVA뿐 아니라 모든 외부 API에 적용될 것
* domain(UseCase)을 상태 없는 순수 로직으로 유지할 것
* 인증 키가 다른 호스트로 새지 않을 것 (API별 Dio 분리 유지)

## 검토한 옵션

* VM을 keepAlive로 변경
* UseCase에 진행 중인 Future 보관
* Repository 구현체에 진행 중인 Future 보관
* Dio 인터셉터에서 같은 요청 합치기

## 결정 결과

선택: "Dio 인터셉터에서 같은 요청 합치기" <br>
사유: 진행 중인 요청을 합치는 것은 비즈니스 규칙이 아니라 네트워크 동시성 문제다. 그래서 network 레이어에 두면 모든 API에 한 번에 적용되고, UseCase는 상태를 갖지 않는다.

* `InFlightRequestInterceptor`
  - 같은 요청의 기준: `method + uri(쿼리 포함) + body(JSON)`. 헤더는 요청마다 새로 만드는 요청 ID가 있어서 기준에서 뺀다.
  - 같은 요청이 진행 중이면 전송하지 않고, 앞선 요청의 응답이나 오류를 함께 받는다.
  - 끝나면 목록에서 지운다. 응답 캐시가 아니다.
* `createDio`가 항상 맨 앞에 붙인다. 합쳐진 요청이 인증·백그라운드 전송까지 가지 않게 하기 위해서다.
* 함께 정리: Dio 생성을 `DioType` sealed class(API별 baseUrl·타임아웃·인증 키)와 `createDio` 하나로 통합했다.

### 영향

* 장점: 세 API(CLOVA, 도로명주소, Geocode)에 모두 적용된다. domain과 화면 코드는 바뀌지 않는다.
* 단점: 합쳐지는 것은 HTTP 전송뿐이다. 요청 전에 하는 작업(사진 리사이즈)과 `ClovaStudioApi` 로그는 호출마다 실행된다. 결과 저장도 두 번 되지만 upsert라서 결과는 같다.
* 위험: 호출할 때마다 새 데이터가 생겨야 하는 POST(예: 2.0.0 서버의 등록 API)에 붙이면, 두 번째 요청이 무시된다.

### 검증

- 단위 테스트 4개(`test/core/network/interceptors/in_flight_request_interceptor_test.dart`)
  - 같은 요청을 동시에 2번 → 전송 1번
  - 끝난 뒤 다시 보냄 → 전송 2번
  - body나 쿼리가 다름 → 각각 전송
  - 실패 → 기다리던 요청 모두 같은 오류
- 화면을 나갔다 다시 들어왔을 때 요청이 한 번만 나가는지 실기기 로그로는 확인하지 않았다.

## 옵션별 장단점

### VM을 keepAlive로 변경

* 장점: 수정이 간단함
* 단점: 실패 화면이나 수정 전 매물의 글이 다시 들어왔을 때도 남는다. 열어 본 매물마다 VM이 메모리에 쌓인다. 남겨야 할 것(진행 중인 요청)과 버려야 할 것(화면 상태)을 구분할 수 없다.

### UseCase에 진행 중인 Future 보관

* 장점: 화면 수명과 무관하고 순수 Dart라 테스트가 쉬움
* 단점: UseCase가 상태를 갖게되어 비즈니스 규칙이 아닌 기술적 처리가 domain에 포함되어 클린아키텍처 관점에서 적절하지 않음

### Repository 구현체에 진행 중인 Future 보관

* 장점: data 레이어라 위치가 UseCase에 적용하는 것 보다는 위치가 나음
* 단점: Repository마다 같은 코드를 반복해야 함

### Dio 인터셉터에서 같은 요청 합치기

* 장점: 위 "결정 결과" 참고
* 단점: 위 "영향" 참고

## 추가 정보

- 코드 위치
  - `lib/core/network/interceptors/in_flight_request_interceptor.dart`
  - `lib/core/network/dio_factory.dart`의 `DioType`, `createDio`
- 규칙: 결과가 같아도 되는 요청(조회, 생성형 AI)의 Dio에만 붙인다.
- 같은 매물의 글을 다시 생성하지 않는 것(매물이 바뀌지 않았으면 저장된 글 사용)은 `BlogUseCase.fetch`의 비즈니스 규칙으로, 이 결정과는 별개다.
