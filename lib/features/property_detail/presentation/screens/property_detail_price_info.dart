import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class PropertyDetailPriceInfo extends StatelessWidget {
  final PropertyDetailData data;

  const PropertyDetailPriceInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
}
