import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/usecase/app_update_usecase.dart';
import 'package:vine_butler/features/splash/presentation/splash_view_state.dart';

final splashVMProvider = NotifierProvider.autoDispose<SplashVM, SplashViewState>(SplashVM.new);

sealed class SplashAction {
  const SplashAction();

  const factory SplashAction.update() = _Update;
  const factory SplashAction.close() = _Close;
  const factory SplashAction.popNavigation() = _PopNavigation;
}

class _Update extends SplashAction {
  const _Update();
}

class _Close extends SplashAction {
  const _Close();
}

class _PopNavigation extends SplashAction {
  const _PopNavigation();
}

class SplashVM extends Notifier<SplashViewState> {
  late final AppUpdateUseCase _updateUseCase = ref.read(appUpdateUseCaseProvider);

  @override
  SplashViewState build() {
    _check();
    return const SplashViewState();
  }

  void action(SplashAction action) {
    switch (action) {
      case _Update():
        _update();

      case _Close():
        _exit();

      case _PopNavigation():
        state = state.copyWith(navigateTo: () => null);
    }
  }

  Future<void> _check() async {
    final (_, isUpdateAvailable) = await (
      Future<void>.delayed(_duration()),
      _updateUseCase.isUpdateAvailable(),
    ).wait;

    if (!ref.mounted) { return; }

    if (isUpdateAvailable) {
      state = state.copyWith(status: SplashStatus.idle);
      return;
    }

    _navigateToHome();
  }

  /// Splash 최소 표시 시간
  Duration _duration() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
        return const Duration(seconds: 3);

      default:
        return Duration.zero;
    }
  }

  /// 업데이트 적용 함수
  ///
  /// - Windows는 재시작되어 돌아오지 않음, 스토어 이동 뒤 앱으로 돌아오면 팝업을 다시 띄움
  Future<void> _update() async {
    state = state.copyWith(status: SplashStatus.update);

    try {
      await _updateUseCase.update();

      if (!ref.mounted) { return; }

      state = state.copyWith(status: SplashStatus.idle);
    } catch (error) {
      debugPrint('[UPDATE] update failed $error');

      if (!ref.mounted) { return; }

      _navigateToHome();
    }
  }

  void _exit() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        SystemNavigator.pop();

      default:
        exit(0);
    }
  }

  void _navigateToHome() {
    final isDesktop = defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows;
    final location = isDesktop ? const PropertyListRoute().location : const HomeRoute().location;

    state = state.copyWith(navigateTo: () => location);
  }
}
