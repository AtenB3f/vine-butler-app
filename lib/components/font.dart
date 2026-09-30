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
        return _style(color, 13, FontWeight.w400, 16);
      case AppFontStyle.body2:
        return _style(color, 15, FontWeight.w400, 18);
      case AppFontStyle.body3:
        return _style(color, 16, FontWeight.w400, 20);
      case AppFontStyle.bold1:
        return _style(color, 13, FontWeight.w600, 16);
      case AppFontStyle.bold2:
        return _style(color, 15, FontWeight.w600, 18);
      case AppFontStyle.bold3:
        return _style(color, 16, FontWeight.w600, 20);
      case AppFontStyle.sub1:
        return _style(color, 18, FontWeight.w500, 26);
      case AppFontStyle.sub2:
        return _style(color, 20, FontWeight.w500, 30);
      case AppFontStyle.sub3:
        return _style(color, 22, FontWeight.w500, 30);
      case AppFontStyle.header1:
        return _style(color, 18, FontWeight.w600, 26);
      case AppFontStyle.header2:
        return _style(color, 22, FontWeight.w600, 30);
      case AppFontStyle.header3:
        return _style(color, 28, FontWeight.w600, 40);
    }
  }

  TextStyle _style(
    Color color,
    double fontSize,
    FontWeight fontWeight,
    double lineHeight,
  ) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
      letterSpacing: fontSize * -0.0025,
    );
  }

  Text text(String data, Color color) {
    return Text(data, style: style(color));
  }
}
