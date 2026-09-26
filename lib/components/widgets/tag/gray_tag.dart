import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

enum GrayTagSize {
  small,
  medium
}

class GrayTag extends StatelessWidget {
  final String text;
  final GrayTagSize size;

  const GrayTag({
    super.key,
    required this.text,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(size),
      decoration: BoxDecoration(
        color: BaseColor.light,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AppFontStyle.body2.text(text, TextColor.medium),
    );
  }

  EdgeInsets padding(GrayTagSize size) {
    switch (size) {
      case GrayTagSize.small:
        return EdgeInsets.symmetric(vertical: 4, horizontal: 8);
      case GrayTagSize.medium:
        return EdgeInsets.symmetric(vertical: 6, horizontal: 12);
    }
  }
}