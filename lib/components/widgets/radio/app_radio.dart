import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppRadio extends StatelessWidget {
  final AppRadioViewState viewState;
  final VoidCallback onTap;

  const AppRadio({
    super.key,
    required this.viewState,
    required this.onTap,
  });

  bool get _isDisabled => viewState.status == AppRadioStatus.disabled;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        _circle(),
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

  Widget _circle() {
    final isChecked = viewState.status == AppRadioStatus.checked;

    return Opacity(
      opacity: _isDisabled ? 0.5 : 1,
      child: Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isChecked ? MainColor.medium : StateColor.white,
          shape: BoxShape.circle,
          border: isChecked ? null : Border.all(color: BaseColor.medium),
        ),
        child: isChecked
            ? const SizedBox(
                width: 8,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: StateColor.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
