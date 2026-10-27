import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class PriceField extends StatelessWidget {
  final PriceFieldViewState viewState;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const PriceField({
    super.key,
    required this.viewState,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final subText = viewState.subText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: viewState.isFocused ? MainColor.medium : BaseColor.medium),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: AppFontStyle.sub3.text(viewState.text, TextColor.dark)),
                if (viewState.isFocused) _clearButton(),
              ],
            ),
          ),
        ),
        if (subText != null) AppFontStyle.body2.text(subText, TextColor.medium),
      ],
    );
  }

  Widget _clearButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClear,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AppIcons.closeSM(GrayColor.dark),
      ),
    );
  }
}
