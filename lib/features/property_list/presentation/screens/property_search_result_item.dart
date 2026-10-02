import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_item_view_state.dart';

class PropertySearchResultItem extends StatelessWidget {
  final PropertyListItemViewState viewState;
  final String query;
  final VoidCallback onTap;

  const PropertySearchResultItem({
    super.key,
    required this.viewState,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        color: StateColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          spacing: 6,
          children: [
            LineTag(
              text: _transactionLabel(viewState.transactionType),
              type: _transactionTagType(viewState.transactionType),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(children: _highlightedSpans()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _highlightedSpans() {
    final text = viewState.roadAddress;
    final normalStyle = AppFontStyle.body2.style(TextColor.dark);
    final matchIndex = query.isEmpty ? -1 : text.indexOf(query);

    if (matchIndex < 0) {
      return [TextSpan(text: text, style: normalStyle)];
    }

    final matchEnd = matchIndex + query.length;
    return [
      TextSpan(text: text.substring(0, matchIndex), style: normalStyle),
      TextSpan(text: text.substring(matchIndex, matchEnd), style: normalStyle.copyWith(fontWeight: FontWeight.w700)),
      TextSpan(text: text.substring(matchEnd), style: normalStyle),
    ];
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
}
