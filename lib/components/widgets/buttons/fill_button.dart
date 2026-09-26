import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

enum FillButtonType {
  gray,
  light,
  medium
}

class FillButton extends StatelessWidget {
  final FillButtonType type;
  final BoxButtonSize size;
  final String text;
  final VoidCallback onTap;

  const FillButton({
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
        width: double.infinity,
        height: height(size),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor(type),
          borderRadius: BorderRadius.circular(4),
        ),
        child: AppFontStyle.bold2.text(text, textColor(type)),
      ),
    );
  }

  Color backgroundColor(FillButtonType type) {
    switch (type) {
      case FillButtonType.gray:
        return BaseColor.light;
      case FillButtonType.light:
        return MainColor.light;
      case FillButtonType.medium:
        return MainColor.medium;
    }
  }

  Color textColor(FillButtonType type) {
    switch (type) {
      case FillButtonType.gray:
        return TextColor.medium;
      case FillButtonType.light:
        return TextColor.dark;
      case FillButtonType.medium:
        return Colors.white;
    }
  }

  double height(BoxButtonSize size) {
    switch (size) {
      case BoxButtonSize.small:
        return 40;
      case BoxButtonSize.medium:
        return 46;
      case BoxButtonSize.large:
        return 50;
    }
  }
}