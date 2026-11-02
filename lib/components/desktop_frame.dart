import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/tab/desktop_tab_type.dart';
import 'package:vine_butler/components/widgets/tab/desktop_tabbar.dart';

/// 데스크톱 창
class DesktopFrame extends StatelessWidget {
  const DesktopFrame({
    super.key,
    required this.currentTab,
    required this.onTabTap,
    required this.child,
  });

  final DesktopTabType? currentTab;
  final ValueChanged<DesktopTabType> onTabTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: StateColor.white,
      child: Column(
        children: [
          const _DesktopAppBar(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DesktopTabbar(currentTab: currentTab, onTap: onTabTap),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopAppBar extends StatelessWidget {
  const _DesktopAppBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Stack(
        children: [
          if (Platform.isWindows) const WindowCaption(backgroundColor: StateColor.white, brightness: Brightness.light),
          const Positioned(
            left: 79,
            top: 0,
            bottom: 0,
            child: SizedBox(width: 1, child: ColoredBox(color: BaseColor.medium)),
          ),
        ],
      ),
    );
  }
}
