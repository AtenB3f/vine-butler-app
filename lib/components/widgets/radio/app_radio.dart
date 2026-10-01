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

  static const Duration _duration = Duration(milliseconds: 200);
  static const Curve _curve = Curves.easeInOut;

  bool get _isDisabled => viewState.status == AppRadioStatus.disabled;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        _circle(),
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

  Widget _circle() {
    final isChecked = viewState.status == AppRadioStatus.checked;

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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: StateColor.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: BaseColor.medium),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                duration: _duration,
                curve: _curve,
                opacity: isChecked ? 1 : 0,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: MainColor.medium,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: StateColor.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
