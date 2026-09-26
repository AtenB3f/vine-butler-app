import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

enum OutlineButtonType {
  gray,
  main,
  primary,
  secondary,
  tertiary
}

class OutlineButton extends StatelessWidget {
  final OutlineButtonType type;
  final BoxButtonSize size;
  final String text;
  final VoidCallback onTap;

  const OutlineButton({
    super.key,
    required this.type,
    required this.size,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: padding(),
        decoration: BoxDecoration(
          color: background(),
          border: border(),
          borderRadius: BorderRadius.circular(4),
        ),
        child: font().text(text, fontColor()),
      ),
    );
  }

  EdgeInsets padding() {
    switch (size) {
      case BoxButtonSize.small:
        return EdgeInsets.symmetric(vertical: 6, horizontal: 12);
      case BoxButtonSize.medium:
        return EdgeInsets.symmetric(vertical: 11, horizontal: 12);
      case BoxButtonSize.large:
        return EdgeInsets.symmetric(vertical: 14, horizontal: 20);
    }
  }

  BoxBorder border() {
    switch (type) {
      case OutlineButtonType.gray:
        return BoxBorder.all(color: BaseColor.light);
      case OutlineButtonType.main:
        return BoxBorder.all(color: MainColor.medium);
      case OutlineButtonType.primary:
        return BoxBorder.all(color: PrimaryColor.medium);
      case OutlineButtonType.secondary:
        return BoxBorder.all(color: SecondaryColor.medium);
      case OutlineButtonType.tertiary:
        return BoxBorder.all(color: TertiaryColor.medium);
    }
  }

  AppFontStyle font() {
    switch (size) {
      case BoxButtonSize.small:
        return AppFontStyle.body2;
      case BoxButtonSize.medium:
      case BoxButtonSize.large:
        return AppFontStyle.bold2;
    }
  }

  Color fontColor() {
    switch (type) {
      case OutlineButtonType.gray:
        return TextColor.medium;
      default:
        return TextColor.dark;
    }
  }

  Color background() {
    switch (type) {
      case OutlineButtonType.gray:
        return BaseColor.light;
      case OutlineButtonType.main:
        switch (size) {
          case BoxButtonSize.large:
            return MainColor.light;
          default:
            return MainColor.disable;
        }
      case OutlineButtonType.primary:
        switch (size) {
          case BoxButtonSize.large:
            return PrimaryColor.light;
          default:
            return PrimaryColor.disable;
        }
      case OutlineButtonType.secondary:
        switch (size) {
          case BoxButtonSize.large:
            return SecondaryColor.light;
          default:
            return SecondaryColor.disable;
        }
      case OutlineButtonType.tertiary:
        switch (size) {
          case BoxButtonSize.large:
            return TertiaryColor.light;
          default:
            return TertiaryColor.disable;
        }
    }
  }
}