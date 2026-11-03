import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class PropertyDetailOptions extends StatelessWidget {
  final PropertyDetailData data;

  const PropertyDetailOptions({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
        _options(),
        _furnitures(),
        if (data.memo != null) _memo(),
      ],
    );
  }

  Widget _options() {
    return Column(
      spacing: 14,
      children: [
        if (data.vicinity.isNotEmpty) _optionItem('교통', data.vicinity.join(', ')),
        if (data.isAvailableParking) _optionItem('주차', '주차 가능'),
        if (data.isAvailableLoan case final isAvailableLoan?) _optionItem('융자', isAvailableLoan ? '융자 있음' : '융자 없음'),
        if (data.isAvailableSuretyInsurance) _optionItem('보증보험', '보증보험 가입 가능'),
        _moveInRow(),
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

  Widget _moveInRow() {
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

  Widget _furnitures() {
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

  Widget _memo() {
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
