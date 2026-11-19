import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/router/app_router.dart';
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
    final display = Future<void>.delayed(_duration());
    final isUpdateAvailable = await _isUpdateAvailable();

    await display;

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

  Future<bool> _isUpdateAvailable() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return false;

      case TargetPlatform.macOS:
        return false;

      case TargetPlatform.iOS:
        return false;

      case TargetPlatform.android:
        return false;

      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
        return false;
    }
  }

  Future<void> _update() async {
    state = state.copyWith(status: SplashStatus.update);

    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        break;

      case TargetPlatform.macOS:
        break;

      case TargetPlatform.iOS:
        break;

      case TargetPlatform.android:
        break;

      default:
        break;
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
