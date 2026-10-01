import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/home/home_vm.dart';
import 'package:vine_butler/features/home/presentation/home_view_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<HomeViewState>(homeVMProvider, (previous, next) {
      final navigateTo = next.navigateTo;
      if (navigateTo != null) {
        context.push(navigateTo);
        ref.read(homeVMProvider.notifier).popNavigation();
      }
    });

    if (context.isMobile) {
      return _mobileScreen(ref);
    } else {
      return _desktopScreen(ref);
    }
  }

  Column _mobileScreen(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        _homeBanner(),
        _mobileHomeContents(ref),
      ],
    );
  }

  Column _desktopScreen(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        _homeBanner(),
        _desktopHomeContents(ref),
      ],
    );
  }

  Widget _homeBanner() {
    return const _HomeBanner();
  }

  Widget _mobileHomeContents(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        AppFontStyle.header3.text('어떻게 찾아 오셨나요?', TextColor.dark),
        ImageButton(
          image: 'Tab_Home_Enable',
          size: const Size(240, 120),
          alignment: ContentAlignment.top,
          spacing: 10,
          font: AppFontStyle.sub3,
          fontColor: TextColor.dark,
          text: '찾아요',
          onTap: () => ref.read(homeVMProvider.notifier).action(HomeViewAction.find),
        ),
        ImageButton(
          image: 'Tab_Home_Enable',
          size: const Size(240, 120),
          alignment: ContentAlignment.top,
          spacing: 10,
          font: AppFontStyle.sub3,
          fontColor: TextColor.dark,
          text: '맡겨요',
          onTap: () => ref.read(homeVMProvider.notifier).action(HomeViewAction.apply),
        ),
      ],
    );
  }

  Widget _desktopHomeContents(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        AppFontStyle.header3.text('어떻게 찾아 오셨나요?', TextColor.dark),
        ImageButton(
          image: 'Tab_Home_Enable',
          size: const Size(120, 75),
          alignment: ContentAlignment.top,
          spacing: 10,
          font: AppFontStyle.sub3,
          fontColor: TextColor.dark,
          text: '찾아요',
          onTap: () => ref.read(homeVMProvider.notifier).action(HomeViewAction.find),
        ),
        ImageButton(
          image: 'Tab_Home_Enable',
          size: const Size(120, 75),
          alignment: ContentAlignment.top,
          spacing: 10,
          font: AppFontStyle.sub3,
          fontColor: TextColor.dark,
          text: '맡겨요',
          onTap: () => ref.read(homeVMProvider.notifier).action(HomeViewAction.apply),
        ),
      ],
    );
  }
}
class _HomeBanner extends StatefulWidget {
  const _HomeBanner();

  @override
  State<_HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<_HomeBanner> {
  final TextEditingController _controller = TextEditingController();
  AppBndSearchStatus _status = AppBndSearchStatus.disable;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBndSearch(
      viewState: AppBndSearchViewState(status: _status, placeholder: '매물 찾기'),
      controller: _controller,
      onFocusChanged: (hasFocus) => setState(() {
        _status = hasFocus ? AppBndSearchStatus.enable : AppBndSearchStatus.disable;
      }),
      onSearchTap: () {},
      onFilterTap: () {},
    );
  }
}
