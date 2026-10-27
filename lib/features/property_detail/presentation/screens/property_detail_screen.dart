import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/core/shared/app_manager.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

enum _DetailMenu {
  edit,
  delete,
  // export,
  // sync,
}

class PropertyDetailScreen extends ConsumerWidget {
  final String id;

  const PropertyDetailScreen({super.key, required this.id});

  static final List<({_DetailMenu menu, String text, Widget Function(Color color) image})> _menuItems = [
    (menu: _DetailMenu.edit, text: '수정', image: AppIcons.editMD),
    (menu: _DetailMenu.delete, text: '삭제', image: AppIcons.trashMD),
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
      title: '매물 찾기',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.moreMD,
      onLeftTap: () => context.pop(),
      onRightTap: () async {
        final index = await showAppBottomSheet(
          context,
          AppBottomSheetViewState(
            items: [for (final item in _menuItems) AppSheetItemViewState(text: item.text, image: item.image)],
            selectedIndex: -1,
          ),
        );

        if (index != null && context.mounted) { _onMenuSelect(context, ref, index); }
      },
      body: _body(context, ref, state),
    );
  }

  AppScaffold _desktopScreen(BuildContext context, WidgetRef ref, PropertyDetailViewState state) {
    return AppScaffold(
      title: '매물 찾기',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.moreMD,
      onLeftTap: () => context.pop(),
      onRightTap: () async {
        final index = await showAppDropdown(
          context,
          AppDropdownViewState(
            items: [for (final item in _menuItems) AppDropdownItemViewState(text: item.text, image: item.image)],
            selectedIndex: -1,
          ),
          topRight: Offset(context.screenWidth - 16, MediaQuery.paddingOf(context).top + 58),
        );

        if (index != null && context.mounted) { _onMenuSelect(context, ref, index); }
      },
      body: _body(context, ref, state),
    );
  }

  Future<void> _onMenuSelect(BuildContext context, WidgetRef ref, int index) async {
    final menu = _menuItems[index].menu;

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

  Widget _body(BuildContext context, WidgetRef ref, PropertyDetailViewState state) {
    switch (state.status) {
      case PropertyDetailStatus.loading:
        return const Center(
          child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.large)),
        );

      case PropertyDetailStatus.notFound:
        return Center(child: AppFontStyle.body3.text('매물을 찾을 수 없습니다.', TextColor.medium));

      case PropertyDetailStatus.loaded:
        return _contents(context, ref, state.data!, state.isMapVisible);
    }
  }

  Widget _contents(BuildContext context, WidgetRef ref, PropertyDetailData data, bool isMapVisible) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 16, right: 16, top: 20, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 44,
          children: [
            _basicInfo(context, ref, data, isMapVisible),
            _call(data),
            _options(data),
            _furnitures(data),
            if (data.memo != null) _memo(data),
          ],
        ),
      ),
    );
  }

  Widget _basicInfo(BuildContext context, WidgetRef ref, PropertyDetailData data, bool isMapVisible) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        _media(context, ref, data, isMapVisible),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.isMobile ? 40 : 44,
          children: [
            _address(data),
            _priceInfo(data),
          ],
        ),
      ],
    );
  }

  Widget _media(BuildContext context, WidgetRef ref, PropertyDetailData data, bool isMapVisible) {
    final height = context.isMobile ? 246.0 : 240.0;

    if (!data.hasImages) { return SizedBox(height: height, width: double.infinity, child: _map(data)); }

    if (!context.isMobile) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: AppImagePage(
          viewState: _imagePageViewState(data),
          onTap: (index) => _showImages(context, data, index),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 4,
      children: [
        _mediaButtons(ref, isMapVisible),
        SizedBox(height: height, width: double.infinity, child: _imageMap(context, data, isMapVisible)),
      ],
    );
  }

  Widget _mediaButtons(WidgetRef ref, bool isMapVisible) {
    void toggle() => ref.read(propertyDetailVMProvider(id).notifier).action(PropertyDetailAction.toggleMap);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _mediaButton(icon: AppIcons.mapSM, text: '지도', isSelected: isMapVisible, onTap: toggle),
        _mediaButton(icon: AppIcons.imageSM, text: '이미지', isSelected: !isMapVisible, onTap: toggle),
      ],
    );
  }

  Widget _mediaButton({
    required Widget Function(Color color) icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? TextColor.dark : GrayColor.light;
    final button = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: StateColor.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          icon(color),
          (isSelected ? AppFontStyle.bold2 : AppFontStyle.body2).text(text, color),
        ],
      ),
    );

    if (isSelected) { return button; }

    return Pressable(onTap: onTap, child: button);
  }

  Widget _address(PropertyDetailData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (data.unitAddress.isNotEmpty)
          Text(
            data.unitAddress,
            style: AppFontStyle.header1.style(TextColor.dark),
          ),
        Text(
          data.address,
          style: AppFontStyle.sub1.style(TextColor.dark),
        ),
      ],
    );
  }

  Widget _priceInfo(PropertyDetailData data) {
    final areaExclusive = data.areaExclusive;
    final roomCount = data.roomCount;
    final spaceInfo = [
      if (areaExclusive != null) ...['${calculatePyeong(areaExclusive)}평', '${areaExclusive}m²'],
      if (roomCount != null) '방 $roomCount개',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        LineTag(
          text: data.transactionType.label,
          type: data.transactionType.tagType
        ),
        Row(
          spacing: 6,
          children: [
            AppFontStyle.header1.text(data.amount.formattedKRW, TextColor.dark),
            if (data.monthlyAmount case final monthlyAmount?) ... [
              const Circle(size: 3, color: TextColor.medium),
              AppFontStyle.header1.text(monthlyAmount.formattedKRW, TextColor.dark),
            ],
          ],
        ),
        if (data.maintenanceCost case final maintenanceCost?)
          Row(
            spacing: 6,
            children: [
              AppFontStyle.sub1.text('관리비', TextColor.light),
              AppFontStyle.header3.text(maintenanceCost == 0 ? '없음' : maintenanceCost.formattedKRW, TextColor.dark),
            ],
          ),
        if (spaceInfo.isNotEmpty)
          Row(
            spacing: 6,
            children: [
              for (final (index, text) in spaceInfo.indexed) ...[
                if (index > 0) const Circle(size: 3, color: BaseColor.medium),
                AppFontStyle.sub1.text(text, TextColor.medium),
              ],
            ],
          ),
      ],
    );
  }

  Widget _call(PropertyDetailData data) {
    return Column(
      spacing: 14,
      children: [
        Row(
          spacing: 8,
          children: [
            _optionTitle('집주인'),
            const Spacer(),
            AppIcons.callSM(BaseColor.dark),
            AppFontStyle.body3.text(data.ownerPhone, TextColor.dark),
          ],
        ),
        if (data.agentPhone != null) ... [
          Row(
            spacing: 8,
            children: [
              _optionTitle('공인중개'),
              const Spacer(),
              if (data.agentCompany case final agentCompany?) ... [
                AppFontStyle.body2.text(agentCompany, TextColor.medium),
              ],
              AppIcons.callSM(),
              if (data.agentPhone case final agentPhone?) ... [
                AppFontStyle.body3.text(agentPhone, TextColor.dark),
              ]
            ],
          )
        ]
      ],
    );
  }

  Widget _options(PropertyDetailData data) {
    return Column(
      spacing: 14,
      children: [
        if (data.vicinity.isNotEmpty) _optionItem('교통', data.vicinity.join(', ')),
        if (data.isAvailableParking) _optionItem('주차', '주차 가능'),
        if (data.isAvailableLoan case final isAvailableLoan?) _optionItem('융자', isAvailableLoan ? '융자 있음' : '융자 없음'),
        if (data.isAvailableSuretyInsurance) _optionItem('보증보험', '보증보험 가입 가능'),
        _moveInRow(data),
      ],
    );
  }

  Widget _optionItem(String title, String description) {
    return Row(
      spacing: 8,
      children: [
        _optionTitle(title),
        const Spacer(),
        _optionDescription(description)
      ],
    );
  }

  Text _optionTitle(String title) {
    return AppFontStyle.body1.text(title, TextColor.light);
  }

  Text _optionDescription(String description) {
    return AppFontStyle.sub2.text(description, TextColor.dark);
  }

  Widget _moveInRow(PropertyDetailData data) {
    final valueText = formatMoveInDate(data.moveInDate);

    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFontStyle.body1.text('입주 가능일', TextColor.light),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 2,
          children: [
            _optionDescription(valueText),
            if (data.isFlexibleMoveInDate) AppFontStyle.body1.text('협의 가능', TextColor.light),
          ],
        ),
      ],
    );
  }

  Widget _furnitures(PropertyDetailData data) {
    if (data.furnitureOptions.isEmpty) { return const SizedBox.shrink(); }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        AppFontStyle.body1.text('가구 옵션', TextColor.light),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in data.furnitureOptions) GrayTag(text: option, size: GrayTagSize.medium),
          ],
        ),
      ],
    );
  }

  Widget _memo(PropertyDetailData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        AppFontStyle.body1.text('메모', TextColor.light),
        AppFontStyle.body3.text(data.memo!, TextColor.dark),
      ],
    );
  }

  AppImagePageViewState _imagePageViewState(PropertyDetailData data, {BoxFit fit = BoxFit.cover, int index = 0}) {
    return AppImagePageViewState(
      images: [for (final path in data.imagePaths) FileImage(File(path))],
      fit: fit,
      index: index,
    );
  }

  Widget _imageMap(BuildContext context, PropertyDetailData data, bool isMapVisible) {
    if (isMapVisible) { return _map(data); }

    return AppImagePage(
      viewState: _imagePageViewState(data),
      onTap: (index) => _showImages(context, data, index),
    );
  }

  void _showImages(BuildContext context, PropertyDetailData data, int index) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '사진 닫기',
      barrierColor: StateColor.dimmed,
      pageBuilder: (dialogContext, animation, secondaryAnimation) => _imageViewer(dialogContext, data, index),
    );
  }

  Widget _imageViewer(BuildContext dialogContext, PropertyDetailData data, int index) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            Pressable(
              onTap: () => Navigator.of(dialogContext).pop(),
              child: AppIcons.closeLG(StateColor.white),
            ),
            Expanded(
              child: AppImagePage(viewState: _imagePageViewState(data, fit: BoxFit.contain, index: index)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _map(PropertyDetailData data) {
    final viewState = NaverMapViewState(
      cameraLocation: (latitude: data.latitude, longitude: data.longitude),
      markers: [NaverMarkerViewState(id: 'position', latitude: data.latitude, longitude: data.longitude)],
      selectedMarkerId: 'position',
      clientId: ApiEnv.naverMapsClientId,
      webServiceUrl: ApiEnv.naverMapsWebServiceUrl,
    );

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => NativeMap(viewState: viewState, onInit: () => AppManager.shared.mapImagesReady),
      TargetPlatform.macOS => MacMap(viewState: viewState),
      TargetPlatform.windows => WindowsMap(viewState: viewState),
      _ => const ColoredBox(color: BaseColor.light),
    };
  }
}
