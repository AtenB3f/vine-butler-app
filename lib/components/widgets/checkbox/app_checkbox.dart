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

  static const Duration _duration = Duration(milliseconds: 200);
  static const Curve _curve = Curves.easeInOut;

  bool get _isDisabled => viewState.status == AppCheckboxStatus.disabled;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        _box(),
        AnimatedDefaultTextStyle(
          duration: _duration,
          curve: _curve,
          style: AppFontStyle.body2.style(_isDisabled ? TextColor.light : TextColor.dark),
          child: Text(viewState.text),
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

    return AnimatedOpacity(
      duration: _duration,
      curve: _curve,
      opacity: _isDisabled ? 0.5 : 1,
      child: SizedBox(
        width: 18,
        height: 18,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: _duration,
                curve: _curve,
                decoration: BoxDecoration(
                  color: _isDisabled ? BaseColor.light : StateColor.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: BaseColor.medium),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                duration: _duration,
                curve: _curve,
                opacity: isChecked ? 1 : 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MainColor.medium,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(child: AppIcons.checkSM(StateColor.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
