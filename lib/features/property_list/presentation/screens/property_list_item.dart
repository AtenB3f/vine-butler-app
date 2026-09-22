import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_view_state.dart';
import 'package:vine_butler/shared/utils/krw_formatter.dart';

class PropertyListItem extends StatelessWidget {
  final PropertyListViewState viewState;
  final VoidCallback onTap;

  const PropertyListItem({
    super.key,
    required this.viewState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Row(
          spacing: 14,
          children: [
            _transaction(viewState.transactionType),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  _basicInfo(),
                  _chips()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _transaction(PropertyTransactionType type) {
    return Container(
      width: 6,
      height: 122,
      color: switch (type) {
        PropertyTransactionType.buy => PrimaryColor.medium,
        PropertyTransactionType.depositOnly => SecondaryColor.medium,
        PropertyTransactionType.rent => TertiaryColor.medium,
      },
    );
  }

  Widget _basicInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          viewState.roadAddress,
          style: AppFontStyle.sub3.style(TextColor.dark),
          textAlign: TextAlign.right,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.clip,
        ),
        Row(
          spacing: 4,
          children: [
            AppFontStyle.sub1.text(formatKRW(viewState.amount), TextColor.medium),
            if (viewState.monthlyAmount case final monthlyAmount?) ...[
              const Circle(size: 2, color: BaseColor.medium),
              AppFontStyle.sub1.text(formatKRW(monthlyAmount), TextColor.medium),
            ],
          ],
        ),
      ],
    );
  }

  Widget _chips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        for (final tag in viewState.tag) GrayTag(text: tag),
      ],
    );
  }
}