import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppBndNormal extends StatelessWidget {
  const AppBndNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 62,
      padding: const EdgeInsets.all(8),
      color: StateColor.white,
      foregroundDecoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BaseColor.light)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppImages.tabHome(true),
      ),
    );
  }
}
