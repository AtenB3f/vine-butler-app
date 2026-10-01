import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppBottomSheet extends StatelessWidget {
  final AppBottomSheetViewState viewState;
  final ValueChanged<int> onSelect;

  const AppBottomSheet({
    super.key,
    required this.viewState,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        decoration: const BoxDecoration(
          color: StateColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          boxShadow: [AppShadow.top],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: BaseColor.light,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 40),
                itemCount: viewState.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 2),
                itemBuilder: (context, index) => _item(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(int index) {
    final isSelected = index == viewState.selectedIndex;

    return Pressable(
      onTap: () => onSelect(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isSelected)
              AppFontStyle.bold2.text(viewState.items[index], StateColor.black)
            else
              AppFontStyle.body2.text(viewState.items[index], TextColor.light),
            if (isSelected) AppIcons.checkMD(StateColor.black),
          ],
        ),
      ),
    );
  }
}

Future<int?> showAppBottomSheet(BuildContext context, AppBottomSheetViewState viewState) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: StateColor.overlay,
    elevation: 0,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: double.infinity),
    builder: (sheetContext) => AppBottomSheet(
      viewState: viewState,
      onSelect: (index) => Navigator.of(sheetContext).pop(index),
    ),
  );
}
