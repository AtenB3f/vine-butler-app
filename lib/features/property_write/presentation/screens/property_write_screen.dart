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

  const PropertyWriteScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(propertyWriteVMProvider(id).notifier);

    ref.handleEvent(
      propertyWriteVMProvider(id).select((state) => state.copyType),
      consume: () => viewModel.action(const PropertyWriteAction.clearCopy()),
      onEvent: (event) => showAppToast(context, AppToastViewState(type: AppToastType.check, text: _copyText(event), hasLink: false)),
    );

    final status = ref.watch(propertyWriteVMProvider(id).select((state) => state.status));

    return AppScaffold(
      title: 'AI 글쓰기',
      leftIcon: AppIcons.chevronLeftMD,
      onLeftTap: () => context.pop(),
      body: switch (status) {
        PropertyWriteStatus.loading => const PropertyWriteContentLoading(),
        PropertyWriteStatus.fail => PropertyWriteContentFail(id: id),
        PropertyWriteStatus.complete => PropertyWriteContentComplete(id: id),
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
