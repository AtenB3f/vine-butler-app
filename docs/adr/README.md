# 결정 기록 (ADR)

성능·구조 개선처럼 이유와 근거를 남겨야 하는 결정을 기록한다. 진행 방식은 AWS ADR 가이드를, 문서 형식은 MADR 템플릿을 따른다.

- [AWS ADR 진행 가이드](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html)
- [MADR 템플릿 설명](https://www.ozimmer.ch/practices/2022/11/22/MADRTemplatePrimer.html)

## 진행 규칙

- 상태(front matter의 `status`)
  - `proposed`: 제안, 검토 중
  - `accepted`: 채택
  - `rejected`: 기각 (이유를 본문에 남김)
  - `deprecated`: 더 이상 쓰지 않음
  - `superseded by NNNN`: 다른 결정으로 대체됨
- `accepted`·`rejected`가 된 ADR은 본문을 고치지 않는다. 결정이 바뀌면 새 ADR을 쓰고, 이전 ADR은 `status`만 바꾼다
- 파일 이름: `NNNN-영문-kebab-제목.md` (4자리, 1씩 증가, 번호는 재사용하지 않음)
- 본문은 한국어로 쓰고, 섹션 제목은 MADR 원문(영어)을 그대로 쓴다
- 새 ADR은 [adr-template.md](adr-template.md)를 복사해 작성하고 아래 목록에 추가한다
- 성능 작업은 `Confirmation`에 측정 환경·방법·전/후 표를 꼭 쓴다

## 목록

| 번호 | 제목 | 상태 | 날짜 |
|---|---|---|---|
| [0001](0001-preload-property-list.md) | 앱 시작 직후 로컬 DB에 저장된 매물 목록을 뒷단에서 미리 로딩하도록 구조 변경 | accepted | 2026-10-27 |
| [0002](0002-map-marker-limit-by-zoom.md) | 지도 탭 마커를 화면 범위 안에서 zoom별 최대 개수만큼만 그리도록 변경 | accepted | 2026-10-27 |
