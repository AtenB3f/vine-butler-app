import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_write/presentation/property_write_view_state.dart';
import 'package:vine_butler/features/property_write/property_write_vm.dart';

class PropertyWriteContentComplete extends ConsumerWidget {
  final String id;

  const PropertyWriteContentComplete({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(propertyWriteVMProvider(id).notifier);
    final state = ref.watch(propertyWriteVMProvider(id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 40,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    AppFontStyle.header1.text('포스트가 생성되었습니다.', TextColor.dark),
                    AppFontStyle.body2.text(
                      '생성된 포스트는 기기에 저장되어 페이지를\n나가도 다시 확인하실 수 있습니다.\n앱 삭제 시 저장된 포스트는 지워집니다.',
                      TextColor.medium,
                    ),
                  ],
                ),
                const AppDivider(type: AppDividerType.medium),
                _section(
                  label: '제목',
                  copyText: '제목 복사',
                  onCopy: () => viewModel.action(const PropertyWriteAction.copy(PostContentType.title)),
                  children: [AppFontStyle.sub3.text(state.title, TextColor.dark)],
                ),
                if (state.imagePaths.isNotEmpty) _images(context, state.imagePaths, viewModel),
                _section(
                  label: '본문',
                  copyText: '본문 복사',
                  onCopy: () => viewModel.action(const PropertyWriteAction.copy(PostContentType.body)),
                  children: [MarkdownBody(data: state.body, styleSheet: _markdownStyle())],
                ),
              ],
            ),
          ),
        ),
        _bottomButtons([
          FillButton(
            type: FillButtonType.gray,
            size: BoxButtonSize.large,
            text: '모두 복사',
            onTap: () => viewModel.action(const PropertyWriteAction.copy(PostContentType.all)),
          ),
          FillButton(
            type: FillButtonType.medium,
            size: BoxButtonSize.large,
            text: '공유',
            onTap: () => viewModel.action(const PropertyWriteAction.share()),
          ),
        ]),
      ],
    );
  }

  MarkdownStyleSheet _markdownStyle() {
    return MarkdownStyleSheet(
      p: AppFontStyle.body2.style(TextColor.dark),
      h1: AppFontStyle.header2.style(TextColor.dark),
      h2: AppFontStyle.header3.style(TextColor.dark),
      h3: AppFontStyle.bold3.style(TextColor.dark),
      strong: const TextStyle(fontWeight: FontWeight.w700),
      listBullet: AppFontStyle.body2.style(TextColor.dark),
      blockSpacing: 10,
    );
  }

  Widget _section({
    required String label,
    required String copyText,
    required VoidCallback onCopy,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20,
      children: [
        Row(
          children: [
            Expanded(child: AppFontStyle.bold1.text(label, TextColor.medium)),
            _grayTagButton(copyText, onCopy),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: children,
        ),
      ],
    );
  }

  Widget _images(BuildContext context, List<String> imagePaths, PropertyWriteVM viewModel) {
    final slider = SizedBox(
      height: 214,
      child: AppImagePage(
        viewState: AppImagePageViewState(images: [for (final path in imagePaths) FileImage(File(path))]),
        onTap: (index) => viewModel.action(PropertyWriteAction.copyImage(index)),
      ),
    );

    if (!context.isDesktop) { return slider; }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 8,
      children: [
        _grayTagButton('사진 복사', () => viewModel.action(const PropertyWriteAction.copyImage(null))),
        slider,
      ],
    );
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
