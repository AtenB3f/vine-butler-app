import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppCheckbox extends StatelessWidget {
  final AppCheckboxViewState viewState;
  final VoidCallback onTap;

  const AppCheckbox({
    super.key,
    required this.viewState,
    required this.onTap,
  });

  bool get _isDisabled => viewState.status == AppCheckboxStatus.disabled;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        _box(),
        AppFontStyle.body2.text(
          viewState.text,
          _isDisabled ? TextColor.light : TextColor.dark,
        ),
      ],
    );

    if (_isDisabled) {
      return content;
    }

    return Pressable(onTap: onTap, child: content);
  }

  Widget _box() {
    final isChecked = viewState.status == AppCheckboxStatus.checked;

    return Opacity(
      opacity: _isDisabled ? 0.5 : 1,
      child: Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(4),
          border: isChecked ? null : Border.all(color: BaseColor.medium),
        ),
        child: isChecked ? AppIcons.checkSM(StateColor.white) : null,
      ),
    );
  }

  Color _backgroundColor() {
    switch (viewState.status) {
      case AppCheckboxStatus.unchecked:
        return StateColor.white;
      case AppCheckboxStatus.checked:
        return MainColor.medium;
      case AppCheckboxStatus.disabled:
        return BaseColor.light;
    }
  }
}
