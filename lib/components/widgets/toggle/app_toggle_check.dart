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

  static const Duration _duration = Duration(milliseconds: 200);
  static const Curve _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final isOn = viewState.status == AppToggleCheckStatus.on;

    return Pressable(
      onTap: onTap,
      child: Stack(
        children: [
          _chip(isOn: false),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: _duration,
              curve: _curve,
              opacity: isOn ? 1 : 0,
              child: _chip(isOn: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({required bool isOn}) {
    final contentColor = isOn ? TextColor.dark : TextColor.light;

    return Container(
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
    );
  }
}
