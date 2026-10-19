import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class MapPropertyCard extends StatelessWidget {
  final MapPropertyCardViewState viewState;
  final VoidCallback onTap;

  const MapPropertyCard({
    super.key,
    required this.viewState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: StateColor.white,
          boxShadow: [AppShadow.top],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                LineTag(text: viewState.transactionType.label, type: viewState.transactionType.tagType),
                _price(),
              ],
            ),
            AppFontStyle.body2.text(viewState.address, TextColor.dark),
          ],
        ),
      ),
    );
  }

  Widget _price() {
    return Row(
      spacing: 6,
      children: [
        AppFontStyle.header2.text(viewState.amount.formattedKRW, TextColor.dark),
        if (viewState.monthlyAmount case final monthlyAmount?) ...[
          const Circle(size: 3, color: TextColor.medium),
          AppFontStyle.header2.text(monthlyAmount.formattedKRW, TextColor.dark),
        ],
      ],
    );
  }
}
