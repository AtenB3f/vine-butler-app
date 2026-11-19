import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/splash/presentation/splash_view_state.dart';
import 'package:vine_butler/features/splash/splash_vm.dart';

void main() {
  const desktopDuration = Duration(seconds: 3);

  late ProviderContainer container;

  SplashViewState state() => container.read(splashVMProvider);
  void action(SplashAction action) => container.read(splashVMProvider.notifier).action(action);

  void start(TargetPlatform platform) {
    debugDefaultTargetPlatformOverride = platform;
    container = ProviderContainer();
    container.listen(splashVMProvider, (_, _) {});
  }

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    container.dispose();
  });

  test('데스크톱은 3초 동안 Splash를 보여 준 뒤 매물 목록으로 이동한다', () async {
    start(TargetPlatform.windows);
    await Future<void>.delayed(const Duration(seconds: 2));

    expect(state().navigateTo, isNull);

    await Future<void>.delayed(const Duration(milliseconds: 1100));

    expect(state().status, SplashStatus.check);
    expect(state().navigateTo, const PropertyListRoute().location);
  });

  test('macOS도 3초 뒤 매물 목록으로 이동한다', () async {
    start(TargetPlatform.macOS);
    await Future<void>.delayed(desktopDuration + const Duration(milliseconds: 100));

    expect(state().navigateTo, const PropertyListRoute().location);
  });

  test('iOS는 기다리지 않고 홈으로 이동한다', () async {
    start(TargetPlatform.iOS);
    await Future<void>.delayed(Duration.zero);

    expect(state().navigateTo, const HomeRoute().location);
  });

  test('Android는 기다리지 않고 홈으로 이동한다', () async {
    start(TargetPlatform.android);
    await Future<void>.delayed(Duration.zero);

    expect(state().navigateTo, const HomeRoute().location);
  });

  test('이동 이벤트를 소비하면 비운다', () async {
    start(TargetPlatform.iOS);
    await Future<void>.delayed(Duration.zero);

    action(const SplashAction.popNavigation());

    expect(state().navigateTo, isNull);
  });

  test('업데이트를 누르면 업데이트 중 상태가 된다', () async {
    start(TargetPlatform.iOS);
    await Future<void>.delayed(Duration.zero);

    action(const SplashAction.update());

    expect(state().status, SplashStatus.update);
  });
}
