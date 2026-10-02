import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final int id;

  const PropertyDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PropertyDetailViewState>(propertyDetailVMProvider(id), (previous, next) {
      final navigateTo = next.navigateTo;
      if (navigateTo != null) {
        context.push(navigateTo);
        ref.read(propertyDetailVMProvider(id).notifier).popNavigation();
      }
    });

    final data = ref.watch(propertyDetailVMProvider(id)).data;

    if (context.isMobile) {
      return _mobileScreen(context, ref, data);
    } else {
      return _desktopScreen(context, ref, data);
    }
  }

  AppScaffold _mobileScreen(BuildContext context, WidgetRef ref, PropertyDetailData? data) {
    return AppScaffold(
      title: '매물 찾기',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.editMD,
      onLeftTap: () => context.pop(),
      onRightTap: () => context.pop(),
      body: data == null ? const Center(child: CircularProgressIndicator()) : _contents(context, data),
    );
  }

  AppScaffold _desktopScreen(BuildContext context, WidgetRef ref, PropertyDetailData? data) {
    return AppScaffold(
      title: '매물 찾기',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.editMD,
      onLeftTap: () => context.pop(),
      onRightTap: () => context.pop(),
      body: data == null ? const Center(child: CircularProgressIndicator()) : _contents(context, data),
    );
  }

  Widget _contents(BuildContext context, PropertyDetailData data) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 16, right: 16, top: 20, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 44,
          children: [
            _basicInfo(context, data),
            _call(data),
            _options(data),
            _furnitures(data),
            if (data.memo != null) _memo(data),
          ],
        ),
      ),
    );
  }

  Widget _basicInfo(BuildContext context, PropertyDetailData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: context.isMobile
              ? _ImageMapToggle(imageUrls: data.imageUrls)
              : AppImagePage(viewState: AppImagePageViewState.urls(data.imageUrls)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 44,
          children: [
            _address(data),
            _priceInfo(data),
          ],
        ),
      ],
    );
  }

  Widget _address(PropertyDetailData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          data.unitAddress,
          style: AppFontStyle.header3.style(TextColor.dark),
        ),
        Text(
          data.address,
          style: AppFontStyle.sub1.style(TextColor.dark),
        ),
      ],
    );
  }

  Widget _priceInfo(PropertyDetailData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        LineTag(
          text: _transactionLabel(data.transactionType),
          type: _transactionTagType(data.transactionType)
        ),
        Row(
          spacing: 6,
          children: [
            AppFontStyle.header3.text(formatKRW(data.amount), TextColor.dark),
            if (data.monthlyAmount case final monthlyAmount?) ... [
              const Circle(size: 3, color: TextColor.medium),
              AppFontStyle.header3.text(formatKRW(monthlyAmount), TextColor.dark),
            ],
          ],
        ),
        if (data.maintenanceCost case final maintenanceCost?)
          Row(
            spacing: 6,
            children: [
              AppFontStyle.sub1.text('관리비', TextColor.light),
              AppFontStyle.header1.text(formatKRW(maintenanceCost), TextColor.dark),
            ],
          ),
        Row(
          spacing: 6,
          children: [
            AppFontStyle.sub1.text('${calculatePyeong(data.areaExclusive)}평', TextColor.medium),
            const Circle(size: 2, color: BaseColor.medium),
            AppFontStyle.sub1.text('${data.areaExclusive}m²', TextColor.medium),
          ],
        ),
      ],
    );
  }

  String _transactionLabel(PropertyTransactionType type) {
    switch (type) {
      case PropertyTransactionType.buy:
        return '매매';
      case PropertyTransactionType.depositOnly:
        return '전세';
      case PropertyTransactionType.rent:
        return '월세';
    }
  }

  LineTagType _transactionTagType(PropertyTransactionType type) {
    switch (type) {
      case PropertyTransactionType.buy:
        return LineTagType.tertiary;
      case PropertyTransactionType.depositOnly:
        return LineTagType.secondary;
      case PropertyTransactionType.rent:
        return LineTagType.primary;
    }
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
        _optionItem('융자', data.isAvailableLoan ? '융자 있음' : '융자 없음'),
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
    if (data.furnitureOptions.isEmpty) {
      return const SizedBox.shrink();
    }

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
}

class _ImageMapToggle extends StatefulWidget {
  final List<String> imageUrls;

  const _ImageMapToggle({required this.imageUrls});

  @override
  State<_ImageMapToggle> createState() => _ImageMapToggleState();
}

class _ImageMapToggleState extends State<_ImageMapToggle> {
  bool _isMapVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _isMapVisible ? Container(color: BaseColor.light) : AppImagePage(viewState: AppImagePageViewState.urls(widget.imageUrls)),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: Pressable(
            onTap: () => setState(() => _isMapVisible = !_isMapVisible),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: _isMapVisible ? AppIcons.imageMD() : AppIcons.mapMD(),
            ),
          ),
        ),
      ],
    );
  }
}
