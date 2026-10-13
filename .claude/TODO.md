# TODO

- [ ] DB 파일 위치를 Application Support로 변경 (macOS/Windows 대응)
  - 배경: `drift_flutter` 기본 위치가 `getApplicationDocumentsDirectory()`라 데스크톱에서는 사용자의 Documents 폴더에 DB 파일이 놓임
  - 대상: `lib/data/local/app_database.dart`
  - 방법: `driftDatabase(name: 'vine_butler', native: DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory))`
  - 선행: `path_provider` 직접 의존성 추가 승인 필요 (이미지 단계에서 `image_picker`와 함께 처리)
  - 주의: 1차 릴리즈(6단계) 전에 처리할 것. 배포 후에 바꾸면 기존 DB 파일을 새 위치로 옮기는 작업이 필요함
