import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class PropertyWriteContentLoading extends StatelessWidget {
  const PropertyWriteContentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header('블로그 포스트를\n생성 중입니다.', '최대 3분정도 소요될 수 있습니다.'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  const AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.large)),
                  _guide('포스트 생성 중 앱을 닫지 마세요.\n포스트가 생성되지 않을 수 있습니다.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        AppFontStyle.header1.text(title, TextColor.dark),
        AppFontStyle.sub1.text(subtitle, TextColor.dark),
      ],
    );
  }

  Widget _guide(String text) {
    return Text(text, style: AppFontStyle.body2.style(TextColor.medium), textAlign: TextAlign.center);
  }
}
