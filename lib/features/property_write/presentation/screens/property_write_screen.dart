import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_write/presentation/property_write_view_state.dart';
import 'package:vine_butler/features/property_write/presentation/screens/property_write_content_complete.dart';
import 'package:vine_butler/features/property_write/presentation/screens/property_write_content_fail.dart';
import 'package:vine_butler/features/property_write/presentation/screens/property_write_content_loading.dart';
import 'package:vine_butler/features/property_write/property_write_vm.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class PropertyWriteScreen extends ConsumerWidget {
  final String id;
  final PostSource source;

  const PropertyWriteScreen({super.key, required this.id, required this.source});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (id: id, source: source);

    final viewModel = ref.read(propertyWriteVMProvider(args).notifier);

    ref.handleEvent(
      propertyWriteVMProvider(args).select((state) => state.copyType),
      consume: () => viewModel.action(const PropertyWriteAction.clearCopy()),
      onEvent: (event) => showAppToast(context, AppToastViewState(type: AppToastType.check, text: _copyText(event), hasLink: false)),
    );

    final status = ref.watch(propertyWriteVMProvider(args).select((state) => state.status));

    return AppScaffold(
      title: source == PostSource.generate ? 'AI 글쓰기' : '포스트',
      leftIcon: AppIcons.chevronLeftMD,
      onLeftTap: () => context.pop(),
      body: switch (status) {
        PropertyWriteStatus.loading => const PropertyWriteContentLoading(),
        PropertyWriteStatus.fail => PropertyWriteContentFail(args: args),
        PropertyWriteStatus.complete => PropertyWriteContentComplete(args: args),
      },
    );
  }

  String _copyText(PropertyWriteEvent event) {
    return switch (event) {
      PropertyWriteEvent.copyTitle => '제목이 복사되었습니다.',
      PropertyWriteEvent.copyBody => '본문이 복사되었습니다.',
      PropertyWriteEvent.copyAll => '제목과 본문이 복사되었습니다.',
      PropertyWriteEvent.copyImage => '사진을 복사했습니다.',
      PropertyWriteEvent.copyImages => '사진을 모두 복사했습니다.',
    };
  }
}
