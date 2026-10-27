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
      primary: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: Row(
                children: [
                  _buildSideButton(icon: leftIcon, onTap: onLeftTap),
                  Expanded(
                    child: Center(
                      child: Text(
                        title ?? '',
                        style: AppFontStyle.sub1.style(TextColor.dark),
                      ),
                    ),
                  ),
                  _buildSideButton(icon: rightIcon, onTap: onRightTap),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: body,
              ),
            ),
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
      width: 40,
      height: 40,
      child: (icon != null && onTap != null)
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Center(child: icon(TextColor.dark)),
            )
          : null,
    );
  }
}
