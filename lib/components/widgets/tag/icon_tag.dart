import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

enum IconTagStatus {
  off,
  on
}

class IconTag extends StatelessWidget {
  final String text;
  final IconTagStatus status;
  final VoidCallback onTap;

  const IconTag({
    super.key,
    required this.text,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOn = status == IconTagStatus.on;
    final contentColor = isOn ? TextColor.dark : TextColor.light;

    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: isOn ? MainColor.disable : StateColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isOn ? MainColor.medium : BaseColor.medium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            AppFontStyle.body2.text(text, contentColor),
            AppIcons.closeSM(contentColor),
          ],
        ),
      ),
    );
  }
}
