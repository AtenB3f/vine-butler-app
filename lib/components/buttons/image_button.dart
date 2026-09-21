import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vine_butler/components/components.dart';

class ImageButton extends StatelessWidget {
  final String image;
  final Size size;
  final ContentAlignment alignment;
  final double spacing;
  final AppFontStyle font;
  final Color fontColor;
  final String text;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.image,
    required this.size,
    required this.alignment,
    required this.spacing,
    required this.font,
    required this.fontColor,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = SizedBox(
      width: size.width,
      height: size.height,
      child: SvgPicture.asset('assets/icons/$image.svg', fit: BoxFit.contain),
    );
    final textWidget = font.text(text, fontColor);

    return Pressable(
      onTap: onTap,
      child: switch (alignment) {
        ContentAlignment.left => Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [textWidget, imageWidget],
        ),
        ContentAlignment.right => Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [imageWidget, textWidget],
        ),
        ContentAlignment.top => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [textWidget, imageWidget],
        ),
        ContentAlignment.bottom => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [imageWidget, textWidget],
        ),
      },
    );
  }
}
