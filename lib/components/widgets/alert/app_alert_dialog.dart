import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppAlertDialog extends StatelessWidget {
  final AppAlertDialogViewState viewState;
  final ValueChanged<bool> onSelect;

  const AppAlertDialog({
    super.key,
    required this.viewState,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 44, 20, 24),
        decoration: BoxDecoration(
          color: StateColor.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [AppShadow.bottom],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 32,
          children: [
            _texts(),
            _buttons(),
          ],
        ),
      ),
    );
  }

  Widget _texts() {
    final title = viewState.title;

    return Column(
      spacing: 16,
      children: [
        if (title != null)
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppFontStyle.header1.style(TextColor.dark),
          ),
        Text(
          viewState.message,
          textAlign: TextAlign.center,
          style: AppFontStyle.body2.style(title != null ? TextColor.medium : TextColor.dark),
        ),
      ],
    );
  }

  Widget _buttons() {
    final secondaryText = viewState.secondaryText;
    final primary = FillButton(
      type: FillButtonType.medium,
      size: BoxButtonSize.small,
      text: viewState.primaryText,
      onTap: () => onSelect(true),
    );

    if (secondaryText == null) {
      return primary;
    }

    return Row(
      spacing: 6,
      children: [
        Expanded(
          child: FillButton(
            type: FillButtonType.gray,
            size: BoxButtonSize.small,
            text: secondaryText,
            onTap: () => onSelect(false),
          ),
        ),
        Expanded(child: primary),
      ],
    );
  }
}

const Duration _alertDuration = Duration(milliseconds: 200);
const Offset _alertSlideOffset = Offset(0, 0.02);

Future<bool?> showAppAlertDialog(BuildContext context, AppAlertDialogViewState viewState) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: StateColor.overlay,
    transitionDuration: _alertDuration,
    pageBuilder: (dialogContext, animation, secondaryAnimation) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppAlertDialog(
        viewState: viewState,
        onSelect: (value) => Navigator.of(dialogContext).pop(value),
      ),
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: _alertSlideOffset, end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}
