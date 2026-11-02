import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/tab/desktop_tab_type.dart';

class DesktopTabbar extends StatelessWidget {
  const DesktopTabbar({super.key, required this.currentTab, required this.onTap});

  final DesktopTabType? currentTab;
  final ValueChanged<DesktopTabType> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: StateColor.white,
        border: Border(right: BorderSide(color: BaseColor.medium)),
      ),
      child: Column(
        spacing: 10,
        children: [
          AppImages.tabHome(true),
          for (final type in DesktopTabType.values)
            _DesktopTabItem(
              type: type,
              isSelected: currentTab == type,
              onTap: () => onTap(type),
            ),
        ],
      ),
    );
  }
}

class _DesktopTabItem extends StatelessWidget {
  const _DesktopTabItem({required this.type, required this.isSelected, required this.onTap});

  final DesktopTabType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final font = isSelected ? AppFontStyle.bold1 : AppFontStyle.body1;

    return Pressable(
      onTap: onTap,
      child: Container(
        height: 54,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          spacing: 4,
          children: [
            _getIcon(),
            font.text(_getLabel(), TextColor.dark),
          ],
        ),
      ),
    );
  }

  Widget _getIcon() {
    switch (type) {
      case DesktopTabType.property:
        return AppImages.tabHouse(isSelected);

      case DesktopTabType.map:
        return AppImages.tabMap(isSelected);

      case DesktopTabType.register:
        return AppImages.tabHouseAdd(isSelected);
    }
  }

  String _getLabel() {
    switch (type) {
      case DesktopTabType.property:
        return '매물';

      case DesktopTabType.map:
        return '지도';

      case DesktopTabType.register:
        return '등록';
    }
  }
}
