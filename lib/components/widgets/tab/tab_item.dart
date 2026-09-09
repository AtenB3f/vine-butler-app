import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/tab/tab_type.dart';

class TabItem extends ConsumerWidget {
  final TabItemType type;
  final bool isSelected;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 68,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            _getIcon(type),
            _getLabel(type),
          ],
        ),
      ),
    );
  }

  Widget _getIcon(TabItemType type) {
    switch (type) {
      case TabItemType.property:
        return AppImages.tabHouse(isSelected);
      case TabItemType.home:
        return AppImages.tabHome(isSelected);
      case TabItemType.map:
        return AppImages.tabMap(isSelected);
    }
  }

  Widget _getLabel(TabItemType type) {
    final color = TextColor.dark;
    switch (type) {
      case TabItemType.property:
        return Text('매물', style: isSelected ? TextStyleHelper.bold1(color) : TextStyleHelper.body1(color));
      case TabItemType.home:
        return Text('홈', style: isSelected ? TextStyleHelper.bold1(color) : TextStyleHelper.body1(color));
      case TabItemType.map:
        return Text('지도', style: isSelected ? TextStyleHelper.bold1(color) : TextStyleHelper.body1(color));
    }
  }
}
