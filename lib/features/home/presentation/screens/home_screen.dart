import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isMobile) {
      return _mobileScreen();
    } else {
      return _desktopScreen();
    }
  }

  Column _mobileScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 9, bottom: 9),
          child: _HomeBanner(),
        ),
        _mobileHomeContents(),
      ],
    );
  }

  Column _desktopScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 9, bottom: 9),
          child: _HomeBanner(),
        ),
        _desktopHomeContents(),
      ],
    );
  }

  Widget _HomeBanner() {
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

  Widget _mobileHomeContents() {
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
          onTap: () {
            // Handle search button press
          },
        ),
        ImageButton(
          image: 'Tab_Home_Enable',
          size: const Size(240, 120),
          alignment: ContentAlignment.top,
          spacing: 10,
          font: AppFontStyle.sub3,
          fontColor: TextColor.dark,
          text: '맡겨요',
          onTap: () {
            // Handle search button press
          },
        ),
      ],
    );
  }

  Widget _desktopHomeContents() {
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
          onTap: () {
            // Handle search button press
          },
        ),
        ImageButton(
          image: 'Tab_Home_Enable',
          size: const Size(120, 75),
          alignment: ContentAlignment.top,
          spacing: 10,
          font: AppFontStyle.sub3,
          fontColor: TextColor.dark,
          text: '맡겨요',
          onTap: () {
            // Handle search button press
          },
        ),
      ],
    );
  }
}