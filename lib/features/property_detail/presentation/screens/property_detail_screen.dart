import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final String id;

  const PropertyDetailScreen({super.key, required this.id});

  static final List<({String text, Widget Function(Color color) image})> _menuItems = [
    (text: '수정', image: AppIcons.editMD),
    (text: '삭제', image: AppIcons.trashMD),
    (text: '내보내기', image: AppIcons.linkMD),
    (text: '동기화', image: AppIcons.reloadMD),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.handleEvent(
      propertyDetailVMProvider(id).select((state) => state.navigateTo),
      consume: ref.read(propertyDetailVMProvider(id).notifier).popNavigation,
      onEvent: (location) => context.push(location),
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
      onRightTap: () => showAppBottomSheet(
        context,
        AppBottomSheetViewState(
          items: [for (final item in _menuItems) AppSheetItemViewState(text: item.text, image: item.image)],
          selectedIndex: -1,
        ),
      ),
      body: _body(context, ref, state),
    );
  }

  AppScaffold _desktopScreen(BuildContext context, WidgetRef ref, PropertyDetailViewState state) {
    return AppScaffold(
      title: '매물 찾기',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.moreMD,
      onLeftTap: () => context.pop(),
      onRightTap: () => showAppDropdown(
        context,
        AppDropdownViewState(
          items: [for (final item in _menuItems) AppDropdownItemViewState(text: item.text, image: item.image)],
          selectedIndex: -1,
        ),
        topRight: Offset(context.screenWidth - 16, MediaQuery.paddingOf(context).top + 58),
      ),
      body: _body(context, ref, state),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, PropertyDetailViewState state) {
    final data = state.data;

    if (state.isLoading) {
      return const Center(
        child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.large)),
      );
    }

    if (data == null) { return Center(child: AppFontStyle.body3.text('매물을 찾을 수 없습니다.', TextColor.medium)); }

    return _contents(context, ref, data, state.isMapVisible);
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
      spacing: context.isMobile ? 8 : 14,
      children: [
        SizedBox(
          height: context.isMobile ? 246 : 240,
          width: double.infinity,
          child: !data.hasImages
              ? _map(data)
              : context.isMobile
                  ? _imageMap(data, isMapVisible)
                  : AppImagePage(viewState: AppImagePageViewState.urls(data.imageUrls)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 44,
          children: [
            _address(context, ref, data, isMapVisible),
            _priceInfo(data),
          ],
        ),
      ],
    );
  }

  Widget _address(BuildContext context, WidgetRef ref, PropertyDetailData data, bool isMapVisible) {
    final isToggleable = context.isMobile && data.hasImages;
    final address = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (data.unitAddress.isNotEmpty)
          Text(
            data.unitAddress,
            style: AppFontStyle.header1.style(TextColor.dark),
          ),
        if (isToggleable)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Flexible(
                child: Text(
                  data.address,
                  style: AppFontStyle.sub1.style(TextColor.dark),
                ),
              ),
              isMapVisible ? AppIcons.imageMD(TextColor.dark) : AppIcons.mapMD(TextColor.dark),
            ],
          )
        else
          Text(
            data.address,
            style: AppFontStyle.sub1.style(TextColor.dark),
          ),
      ],
    );

    if (!isToggleable) { return address; }

    return Pressable(
      onTap: () => ref.read(propertyDetailVMProvider(id).notifier).action(PropertyDetailAction.toggleMap),
      child: address,
    );
  }

  Widget _priceInfo(PropertyDetailData data) {
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
              AppFontStyle.header3.text(maintenanceCost.formattedKRW, TextColor.dark),
            ],
          ),
        if (data.areaExclusive case final areaExclusive?)
          Row(
            spacing: 6,
            children: [
              AppFontStyle.sub1.text('${calculatePyeong(areaExclusive)}평', TextColor.medium),
              const Circle(size: 2, color: BaseColor.medium),
              AppFontStyle.sub1.text('${areaExclusive}m²', TextColor.medium),
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
    final valueText = data.moveInDate == null ? '즉시 입주' : '${formatDate(data.moveInDate!)} 이후';

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
            if (data.isAvailableMoveInDate) AppFontStyle.body1.text('협의 가능', TextColor.light),
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

  Widget _imageMap(PropertyDetailData data, bool isMapVisible) {
    return isMapVisible ? _map(data) : AppImagePage(viewState: AppImagePageViewState.urls(data.imageUrls));
  }

  Widget _map(PropertyDetailData data) {
    return AppMapView(
      viewState: AppMapViewViewState(
        latitude: data.latitude,
        longitude: data.longitude,
        clientId: ApiEnv.naverMapsClientId,
        webServiceUrl: ApiEnv.naverMapsWebServiceUrl,
      ),
    );
  }
}
