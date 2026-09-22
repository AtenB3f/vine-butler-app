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
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 9, bottom: 9),
          child: _homeBanner(),
        ),
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
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 9, bottom: 9),
          child: _homeBanner(),
        ),
        _desktopHomeContents(ref),
      ],
    );
  }

  Widget _homeBanner() {
    return Row(
      children: [
        AppImages.tabHome(true),
        Expanded(
          child: AppTextField(
            controller: TextEditingController(),
            onChanged: (value) {
              // Handle text change
            },
          ),
        ),
      ],
    );
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