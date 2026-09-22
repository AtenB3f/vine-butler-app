import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class GrayTag extends StatelessWidget {
  final String text;

  const GrayTag({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: BaseColor.light,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AppFontStyle.body2.text(text, TextColor.medium),
    );
  }
}