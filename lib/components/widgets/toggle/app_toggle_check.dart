import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppToggleCheck extends StatelessWidget {
  final AppToggleCheckViewState viewState;
  final VoidCallback onTap;

  const AppToggleCheck({
    super.key,
    required this.viewState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOn = viewState.status == AppToggleCheckStatus.on;
    final contentColor = isOn ? TextColor.dark : TextColor.light;

    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: isOn ? MainColor.disable : StateColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOn ? MainColor.medium : BaseColor.medium,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            AppFontStyle.body2.text(viewState.text, contentColor),
            AppIcons.checkSM(contentColor),
          ],
        ),
      ),
    );
  }
}
