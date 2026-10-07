import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppDropdown extends StatelessWidget {
  final AppDropdownViewState viewState;
  final ValueChanged<int> onSelect;

  const AppDropdown({
    super.key,
    required this.viewState,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: StateColor.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [AppShadow.bottom],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          for (var index = 0; index < viewState.items.length; index++)
            AppDropdownItem(
              viewState: viewState.items[index],
              isSelected: index == viewState.selectedIndex,
              onTap: () => onSelect(index),
            ),
        ],
      ),
    );
  }
}

Future<int?> showAppDropdown(
  BuildContext context,
  AppDropdownViewState viewState, {
  required Offset topRight,
}) {
  return showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'dropdown',
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (dialogContext, _, _) => Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned(
            top: topRight.dy,
            right: MediaQuery.sizeOf(dialogContext).width - topRight.dx,
            child: AppDropdown(
              viewState: viewState,
              onSelect: (index) => Navigator.of(dialogContext).pop(index),
            ),
          ),
        ],
      ),
    ),
  );
}
