import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppPickerTheme {
  static final DatePickerThemeData date = DatePickerThemeData(
    backgroundColor: StateColor.white,
    surfaceTintColor: StateColor.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    headerBackgroundColor: MainColor.medium,
    headerForegroundColor: StateColor.white,
    dayStyle: AppFontStyle.body2.style(TextColor.dark),
    weekdayStyle: AppFontStyle.bold1.style(TextColor.medium),
    yearStyle: AppFontStyle.body2.style(TextColor.dark),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return StateColor.white;
      }
      if (states.contains(WidgetState.disabled)) {
        return TextColor.light;
      }
      return TextColor.dark;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? MainColor.medium : null;
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? MainColor.medium : null;
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? StateColor.white : MainColor.medium;
    }),
    todayBorder: const BorderSide(color: MainColor.medium),
    dayOverlayColor: _overlayColor,
    yearForegroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? StateColor.white : TextColor.dark;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? MainColor.medium : null;
    }),
    yearOverlayColor: _overlayColor,
    confirmButtonStyle: TextButton.styleFrom(
      foregroundColor: MainColor.medium,
      textStyle: AppFontStyle.bold2.style(MainColor.medium),
    ),
    cancelButtonStyle: TextButton.styleFrom(
      foregroundColor: TextColor.medium,
      textStyle: AppFontStyle.bold2.style(TextColor.medium),
    ),
  );

  static final WidgetStateProperty<Color?> _overlayColor = WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused)) {
      return MainColor.disable;
    }
    return null;
  });
}
