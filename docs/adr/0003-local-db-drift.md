---
status: accepted
date: 2026-10-12
decision-makers: AtenB
version: 1.0.0
---

# 로컬 DB Drift(SQLite) 사용

## 배경과 문제

앱은 매물을 로컬에 저장하고 거래유형·가격·면적·지역을 조합해 필터 검색해야 함 <br>
추후 백엔드(Kotlin + Spring Boot + MySQL)와 서버 동기화를 붙이고, 그 전에 로컬에 쌓인 데이터도 서버로 올려야 함 <br>
타겟 플랫폼은 iOS / macOS / Windows / Android 4개 <br>

## 결정 요인

* 1차 릴리즈 이후에도 스키마를 안전하게 바꿀 수 있어야 함 (마이그레이션)
* 다중 조건 필터 쿼리 표현력
* 4개 플랫폼 지원과 장기 유지보수
* 동기화용 필드(UUID, `deletedAt`, 동기화 시각)를 나중에 추가하기 쉬울 것
* 서버 동기화는 어느 DB도 무료로 제공하지 않으므로 직접 구현하는 전제이며, 유료 동기화 기능에 의존하지 않을 것
* 서버 DB(MySQL)와 구조 매핑이 쉬울 것

## 검토한 옵션

* Drift (SQLite)
* Isar (원본 / `isar_community` 포크)
* sqflite
* ObjectBox
* Hive (`hive_ce`)
* Realm

## 결정 결과

선택: `Drift (SQLite)`
사유: 빠르게 개발하고 검증하는 현재 프로젝트에 유연성이 필요하여, <br>
마이그레이션 도구가 있어 유지보수 상태를 종합했을 때 이 앱의 "배포 후 스키마 변경 + 서버 동기화" 시나리오에 가장 맞는다. <br>
또한 구현하고자 하는 필터링과 정렬 방식이 관계형 쿼리 표현력이 알맞아 선택함. 서버 MySQL과의 구조 대응 <br>

* 마이그레이션 도구가 있어 배포 후 컬럼 추가(동기화 필드)가 안전하다. Isar는 수동 처리다.
* SQL 기반이라 복합 필터·범위 조건·JOIN이 자연스럽고, 서버 관계형 DB와 테이블·컬럼이 거의 1:1로 대응한다.
* 활발히 유지보수되고 4개 플랫폼을 지원한다.
* Stream `watch`로 Riverpod과 바로 연결된다.
* 동기화는 직접 구현(UUID upsert, 소프트 삭제, 변경분 조회)이라 DB 종류와 무관하게 무료

코드 위치: `lib/data/local/app_database.dart`, `lib/data/local/tables/property_table.dart`. 도메인 모델(Freezed)과 Drift 테이블은 분리하고 `lib/data/mapper/`에서 매핑한다.

### 영향

* 장점: 위의 사유와 더불어 빠르게 MVP를 배포하고 검증해야하는 현재 프로젝트의 방식에 마이그레이션 도구가 있어 편리
* 단점: 코드 생성(`build_runner`)과 테이블 정의 보일러플레이트가 필요하고, 도메인 ↔ 테이블 매핑 코드를 직접 써야 한다. SQLite에는 UUID·DECIMAL 타입이 없어 `String`, `double`로 저장한다.
* 위험: `drift_flutter`가 함께 설치하는 `sqlite3_flutter_libs`, `sqlcipher_flutter_libs`가 `+eol` 표기 버전이다. 플랫폼별 빌드 이슈가 생길 수 있다.

## 옵션별 장단점

### Drift (SQLite)

* 장점: *마이그레이션 도구*, 복합 쿼리·JOIN, 4개 플랫폼, *활발한 유지보수*
* 단점: 코드 생성 의존, 보일러플레이트, 학습 곡선

### Isar (원본 / `isar_community` 포크)

* 장점: 간결한 문법, 인덱스 지원, Stream watch
* 단점: 원본 패키지는 *유지보수가 멈춘 상태*라 포크에 의존해야 함
  - 마이그레이션이 수동이라 배포 후 필드 변경 부담이 큼
  - 컬렉션이 가변 클래스여야 해서 Freezed 도메인 모델과 분리가 필요함

### sqflite

* 장점: 가장 널리 쓰임
* 단점: 타입 안전 없음. Windows는 `sqflite_common_ffi`가 추가로 필요하고, 매핑·마이그레이션을 전부 손으로 작성해야 함

### ObjectBox

* 장점: 성능이 좋고 4개 플랫폼 지원
* 단점: 자체 Sync 기능은 *유료*이고, 생태계가 작음
  - 동기화를 직접 구현한다면 Sync 유료 여부는 영향이 없어 후보에서 완전히 배제할 이유는 아님

### Hive (`hive_ce`)

* 장점: 설정이 쉽고 가벼움
* 단점: 복합 쿼리·인덱스가 없어 *필터 검색 요구와 맞지 않음*. 원본은 유지보수가 멈춤

### Realm

* 장점: 객체 + 반응형
* 단점: MongoDB가 Device SDK *지원 종료*를 발표해 장기 지원이 불확실함

## 추가 정보

* 식별자: 앱이 UUID를 생성해 기본키로 쓰고(`uuid` 패키지), 서버는 숫자 `id` + `uuid`(UNIQUE) 컬럼으로 매핑한다. 무작위 UUID를 MySQL InnoDB 기본키로 쓰면 삽입 성능이 떨어지기 때문이다.
* 결정 당시 계획한 동기화 필드는 `updatedAt`, `deletedAt`, `syncStatus`였으나 구현은 `deletedAt`, `syncedAt`이다(`property_table.dart`). 동기화 설계 상세는 `.claude/docs/roadmap.md` 참고.
* 주의: Isar 유지보수 상태, `+eol` 패키지, 각 서비스 요금은 2026-10 조사 시점의 서드파티 자료와 기존 지식 기준이다. 패키지 추가·버전 변경 때 재확인이 필요하다.
* 주의: 성능 비교 측정은 하지 않았다.
