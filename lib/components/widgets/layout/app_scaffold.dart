import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.leftIcon,
    this.rightIcon,
    this.onLeftTap,
    this.onRightTap,
  });

  final Widget body;
  final String? title;
  final Widget Function(Color color)? leftIcon;
  final Widget Function(Color color)? rightIcon;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildSideButton(icon: leftIcon, onTap: onLeftTap),
                  Expanded(
                    child: Center(
                      child: Text(
                        title ?? '',
                        style: TextStyleHelper.sub1(TextColor.dark),
                      ),
                    ),
                  ),
                  _buildSideButton(icon: rightIcon, onTap: onRightTap),
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildSideButton({
    required Widget Function(Color color)? icon,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 24,
      height: 24,
      child: (icon != null && onTap != null)
          ? GestureDetector(onTap: onTap, child: icon(TextColor.dark))
          : null,
    );
  }
}
