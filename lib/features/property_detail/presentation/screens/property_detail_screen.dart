import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_body.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_map.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

enum _DetailMenu {
  edit,
  delete,
  aiWrite,
  // export,
  // sync,
}

class PropertyDetailScreen extends ConsumerWidget {
  final String id;

  const PropertyDetailScreen({super.key, required this.id});

  static final List<({_DetailMenu menu, String text, Widget Function(Color color) image})> _menuItems = [
    (menu: _DetailMenu.edit, text: '수정', image: AppIcons.editMD),
    (menu: _DetailMenu.delete, text: '삭제', image: AppIcons.trashMD),
    (menu: _DetailMenu.aiWrite, text: 'AI 글쓰기', image: (color) => AppIcons.iconMD('Text_MD', color)),
    // (menu: _DetailMenu.export, text: '내보내기', image: AppIcons.linkMD),
    // (menu: _DetailMenu.sync, text: '동기화', image: AppIcons.reloadMD),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.handleEvent(
      propertyDetailVMProvider(id).select((state) => state.navigateTo),
      consume: ref.read(propertyDetailVMProvider(id).notifier).navigate,
      onEvent: (location) => context.push(location),
    );

    ref.handleEvent(
      propertyDetailVMProvider(id).select((state) => state.event),
      consume: ref.read(propertyDetailVMProvider(id).notifier).sendEvent,
      onEvent: (event) => _onEvent(context, event),
    );

    final state = ref.watch(propertyDetailVMProvider(id));

    if (context.isMobile) {
      return _mobileScreen(context, ref, state);
    } else {
      return _desktopScreen(context, ref, state);
    }
  }

  AppScaffold _mobileScreen(BuildContext context, WidgetRef ref, PropertyDetailViewState state) {
    return AppScaffold(
      title: '매물 정보',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.moreMD,
      onLeftTap: () => context.pop(),
      onRightTap: () async {
        final index = await showAppBottomSheet(
          context,
          AppBottomSheetViewState(
            items: [for (final item in _visibleMenuItems(state)) AppSheetItemViewState(text: item.text, image: item.image)],
            selectedIndex: -1,
          ),
        );

        if (index != null && context.mounted) { _onMenuSelect(context, ref, _visibleMenuItems(state)[index].menu); }
      },
      body: PropertyDetailBody(id: id),
    );
  }

  /// 데스크톱 상세 화면
  Widget _desktopScreen(BuildContext context, WidgetRef ref, PropertyDetailViewState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapWidth = constraints.maxWidth - 360;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 360,
              child: AppScaffold(
                title: '매물 정보',
                leftIcon: AppIcons.chevronLeftMD,
                rightIcon: AppIcons.moreMD,
                onLeftTap: () => context.pop(),
                onRightTap: () async {
                  final index = await showAppDropdown(
                    context,
                    AppDropdownViewState(
                      items: [for (final item in _visibleMenuItems(state)) AppDropdownItemViewState(text: item.text, image: item.image)],
                      selectedIndex: -1,
                    ),
                    topRight: Offset(context.screenWidth - mapWidth - 16, MediaQuery.paddingOf(context).top + 58),
                  );

                  if (index != null && context.mounted) { _onMenuSelect(context, ref, _visibleMenuItems(state)[index].menu); }
                },
                body: PropertyDetailBody(id: id),
              ),
            ),
            Expanded(child: PropertyDetailMap(data: state.data)),
          ],
        );
      },
    );
  }

  List<({_DetailMenu menu, String text, Widget Function(Color color) image})> _visibleMenuItems(PropertyDetailViewState state) {
    return [
      for (final item in _menuItems)
        if (item.menu != _DetailMenu.aiWrite || state.canWrite) item,
    ];
  }

  Future<void> _onMenuSelect(BuildContext context, WidgetRef ref, _DetailMenu menu) async {
    if (menu == _DetailMenu.aiWrite) {
      await PropertyDetailBody.openPost(context, ref, id, PropertyWriteRoute(id: id));
      return;
    }
    if (menu == _DetailMenu.edit) {
      EditPropertyRoute(id: id).push(context);
      return;
    }
    if (menu != _DetailMenu.delete) { return; }

    final isConfirmed = await showAppAlertDialog(
      context,
      const AppAlertDialogViewState(
        title: '매물을 삭제하시겠습니까?',
        message: '삭제된 매물은 복구할 수 없습니다.',
        primaryText: '삭제',
        secondaryText: '취소',
      ),
    );

    if (isConfirmed != true || !context.mounted) { return; }

    ref.read(propertyDetailVMProvider(id).notifier).action(PropertyDetailAction.delete);
  }

  void _onEvent(BuildContext context, PropertyDetailEvent event) {
    switch (event) {
      case PropertyDetailEvent.delete:
        showAppToast(context, const AppToastViewState(type: AppToastType.check, text: '매물이 삭제되었습니다.', hasLink: false));
        context.pop();

      case PropertyDetailEvent.failDelete:
        showAppToast(
          context,
          const AppToastViewState(type: AppToastType.warning, text: '매물을 삭제하지 못했습니다. 다시 시도해주세요.', hasLink: false),
        );
    }
  }
}
