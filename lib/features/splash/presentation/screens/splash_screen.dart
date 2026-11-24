import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/splash/presentation/launch_screen.dart';
import 'package:vine_butler/features/splash/presentation/splash_view_state.dart';
import 'package:vine_butler/features/splash/splash_vm.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(splashVMProvider.notifier);
    final status = ref.watch(splashVMProvider.select((state) => state.status));

    ref.handleEvent(
      splashVMProvider.select((state) => state.navigateTo),
      consume: () => viewModel.action(const SplashAction.popNavigation()),
      onEvent: (location) {
        context.go(location);
        LaunchScreen.release();
      },
    );

    ref.listen(splashVMProvider.select((state) => state.status), (_, next) {
      if (next != SplashStatus.idle) { return; }

      _showPopup(context, viewModel);
      LaunchScreen.release();
    });

    return ColoredBox(
      color: MainColor.medium,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: _logo(context)),
          if (status == SplashStatus.update) _loading(),
        ],
      ),
    );
  }

  /// 로고 (데스크톱은 0.5초 동안 나타남)
  Widget _logo(BuildContext context) {
    if (!context.isDesktop) { return AppImages.splashLogo(); }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
      child: AppImages.splashLogo(),
    );
  }

  Widget _loading() {
    return const ColoredBox(
      color: StateColor.dimmed,
      child: Center(
        child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.large)),
      ),
    );
  }

  Future<void> _showPopup(BuildContext context, SplashVM viewModel) async {
    const viewState = AppAlertDialogViewState(
      title: '업데이트를 해주세요.',
      message: '원활한 서비스 이용을 위해\n업데이트가 필요합니다.',
      primaryText: '업데이트',
      secondaryText: '닫기',
    );

    final isOkay = await showAppAlertDialog(context, viewState);

    if (isOkay == null) { return; }

    viewModel.action(isOkay ? const SplashAction.update() : const SplashAction.close());
  }
}
