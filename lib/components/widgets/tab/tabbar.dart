import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/widgets/tab/tab_type.dart';
import 'package:vine_butler/components/widgets/tab/tab_item.dart';

class Tabbar extends ConsumerWidget {
  const Tabbar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final type in TabItemType.values)
            Expanded(
              child: TabItem(
                type: type,
                isSelected: currentIndex == type.index,
                onTap: () => onTap(type.index),
              ),
            ),
        ],
      ),
    );
  }
}
