import 'package:flutter/material.dart';

enum AppFontStyle {
  body1,
  body2,
  body3,
  bold1,
  bold2,
  bold3,
  sub1,
  sub2,
  sub3,
  header1,
  header2,
  header3,
}

extension AppFontStyleX on AppFontStyle {
  TextStyle style(Color color) {
    switch (this) {
      case AppFontStyle.body1:
        return const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ).copyWith(color: color);
      case AppFontStyle.body2:
        return const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ).copyWith(color: color);
      case AppFontStyle.body3:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ).copyWith(color: color);
      case AppFontStyle.bold1:
        return const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ).copyWith(color: color);
      case AppFontStyle.bold2:
        return const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ).copyWith(color: color);
      case AppFontStyle.bold3:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ).copyWith(color: color);
      case AppFontStyle.sub1:
        return const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ).copyWith(color: color);
      case AppFontStyle.sub2:
        return const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ).copyWith(color: color);
      case AppFontStyle.sub3:
        return const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ).copyWith(color: color);
      case AppFontStyle.header1:
        return const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ).copyWith(color: color);
      case AppFontStyle.header2:
        return const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ).copyWith(color: color);
      case AppFontStyle.header3:
        return const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ).copyWith(color: color);
    }
  }

  Text text(String data, Color color) {
    return Text(data, style: style(color));
  }
}
