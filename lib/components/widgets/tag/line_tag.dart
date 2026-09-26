import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

enum LineTagType {
  disable,
  primary,
  secondary,
  tertiary
}

class LineTag extends StatelessWidget {
  final String text;
  final LineTagType type;

  const LineTag({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: background(),
        borderRadius: BorderRadius.circular(4),
        border: border(),
      ),
      child: label(),
    );
  }

  Text label() {
    switch (type) {
      case LineTagType.disable:
        return AppFontStyle.body2.text(text, TextColor.medium);
      default:
        return AppFontStyle.body2.text(text, TextColor.dark);
    }
  }

  BoxBorder border() {
    switch (type) {
      case LineTagType.disable:
        return BoxBorder.all(color: BaseColor.light);
      case LineTagType.primary:
      return BoxBorder.all(color: PrimaryColor.medium);
      case LineTagType.secondary:
      return BoxBorder.all(color: SecondaryColor.medium);
      case LineTagType.tertiary:
      return BoxBorder.all(color: TertiaryColor.medium);
    }
  }

  Color background() {
    switch (type) {
      case LineTagType.disable:
        return BaseColor.light;
      case LineTagType.primary:
        return PrimaryColor.disable;
      case LineTagType.secondary:
        return SecondaryColor.disable;
      case LineTagType.tertiary:
        return TertiaryColor.disable;
    }
  }
}