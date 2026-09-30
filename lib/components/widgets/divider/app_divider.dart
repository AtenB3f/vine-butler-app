import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

enum AppDividerType {
  overlay,
  medium
}

class AppDivider extends StatelessWidget {
  final AppDividerType type;

  const AppDivider({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: color(type),
    );
  }

  Color color(AppDividerType type) {
    switch (type) {
      case AppDividerType.overlay:
        return StateColor.overlay;
      case AppDividerType.medium:
        return BaseColor.medium;
    }
  }
}
