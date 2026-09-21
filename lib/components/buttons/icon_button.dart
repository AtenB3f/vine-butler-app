import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vine_butler/components/components.dart';

class IconButton extends StatelessWidget {
  final String icon;
  final Size size;
  final ContentAlignment alignment;
  final double spacing;
  final AppFontStyle font;
  final Color fontColor;
  final Color iconColor;
  final String text;
  final VoidCallback onTap;

  const IconButton({
    super.key,
    required this.icon,
    required this.size,
    required this.alignment,
    required this.spacing,
    required this.font,
    required this.fontColor,
    required this.iconColor,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = SizedBox(
      width: size.width,
      height: size.height,
      child: SvgPicture.asset(
        'assets/icons/$icon.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
    final textWidget = font.text(text, fontColor);

    return Pressable(
      onTap: onTap,
      child: switch (alignment) {
        ContentAlignment.left => Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [textWidget, iconWidget],
        ),
        ContentAlignment.right => Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [iconWidget, textWidget],
        ),
        ContentAlignment.top => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [textWidget, iconWidget],
        ),
        ContentAlignment.bottom => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [iconWidget, textWidget],
        ),
      },
    );
  }
}
