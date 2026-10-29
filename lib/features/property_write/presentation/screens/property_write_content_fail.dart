import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_write/property_write_vm.dart';

class PropertyWriteContentFail extends ConsumerWidget {
  final String id;

  const PropertyWriteContentFail({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(propertyWriteVMProvider(id).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header('블로그 포스트를\n생성을 실패하였습니다.', '다시 시도해주세요.'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 24,
                      children: [
                        _guide('오류가 지속된다면\n이메일 제보를 통해 문의 바랍니다.'),
                        _grayTagButton('이메일 문의하기', () => viewModel.action(const PropertyWriteAction.sendEmail())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _bottomButtons([
          FillButton(
            type: FillButtonType.medium,
            size: BoxButtonSize.large,
            text: '다시 시도',
            onTap: () => viewModel.action(const PropertyWriteAction.retry()),
          ),
        ]),
      ],
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

  Widget _grayTagButton(String text, VoidCallback onTap) {
    return Pressable(
      onTap: onTap,
      child: GrayTag(text: text, size: GrayTagSize.medium),
    );
  }

  Widget _bottomButtons(List<Widget> buttons) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.top],
      ),
      child: Column(spacing: 6, children: buttons),
    );
  }
}
