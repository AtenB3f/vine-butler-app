# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app (choose a target device)
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Lint / static analysis
flutter analyze

# Get/update dependencies
flutter pub get
flutter pub upgrade
```

## Architecture

This is a Flutter application using **Riverpod** (`flutter_riverpod ^3.2.1`) for state management. Dart SDK constraint is `^3.9.2`.

- `lib/main.dart` — app entry point and root widget. All feature code lives under `lib/`.
- State should be managed via Riverpod providers rather than `StatefulWidget`/`setState` except for purely local, ephemeral UI state.
- Linting is enforced via `flutter_lints`; run `flutter analyze` before committing.


# 프로젝트명

## 프로젝트 개요
- 목적: [앱 설명]
- 타겟 플랫폼: Android / iOS / Web
- 최소 지원 버전: Android X, iOS X

## 기술 스택
- Flutter 3.x / Dart 3.x
- 상태관리: Riverpod (또는 Bloc, Provider)
- 라우터: go_router
- 백엔드: Firebase / Supabase / 자체 API

## 프로젝트 구조
lib/
  features/      # 기능별 폴더 (feature-first)
  shared/        # 공통 위젯, 유틸
  core/          # 라우터, 테마, DI

## 주요 명령어
- 실행: flutter run
- 빌드 확인: flutter analyze && flutter test
- 패키지 설치 후: flutter pub get

## 코딩 규칙
- 파일명은 snake_case
- 위젯은 StatelessWidget 우선, 필요시 ConsumerWidget
- 비즈니스 로직은 위젯에 직접 쓰지 않음