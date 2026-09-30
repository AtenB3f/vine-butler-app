import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppToggleSwitch extends StatelessWidget {
  final AppToggleSwitchViewState viewState;
  final VoidCallback onTap;

  const AppToggleSwitch({
    super.key,
    required this.viewState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOn = viewState.status == AppToggleSwitchStatus.on;

    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 20,
        padding: const EdgeInsets.all(2),
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: isOn ? MainColor.medium : BaseColor.medium,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: StateColor.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
