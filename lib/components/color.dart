import 'package:flutter/material.dart';

class MainColor {
  static const Color dark = Color(0xFF3A4539);
  static const Color medium = Color(0xFF60735E);
  static const Color light = Color(0xFFC2CBC1);
  static const Color disable = Color(0x4D92A390);
}

class PrimaryColor {
  static const Color dark = Color(0xFF7446FF);
  static const Color medium = Color(0xFF868CFF);
  static const Color light = Color(0xFFCBCEFF);
  static const Color disable = Color(0x33868CFF);
}

class SecondaryColor {
  static const Color dark = Color(0xFF69CE1C);
  static const Color medium = Color(0xFFA5EE39);
  static const Color light = Color(0xFFE7FFC5);
  static const Color disable = Color(0x33A5EE39);
}

class TertiaryColor {
  static const Color dark = Color(0xFF14CBF4);
  static const Color medium = Color(0xFF6DDBFF);
  static const Color light = Color(0xFFBDEFFF);
  static const Color disable = Color(0x336DDBFF);
}

class TextColor {
  static const Color dark = Color(0xFF111111);
  static const Color medium = Color(0xFF5B5B5B);
  static const Color light = Color(0xFF767676);
}

class GrayColor {
  static const Color dark = Color(0xFF3D3D3D);
  static const Color medium = Color(0xFF7A7A7A);
  static const Color light = Color(0xFFA6A6A6);
}

class BaseColor {
  static const Color dark = Color(0xFFBABABA);
  static const Color medium = Color(0xFFD8D8D8);
  static const Color light = Color(0xFFEFEFEF);
}

class StateColor {
  static const Color error = Color(0xFFED003C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111111);
  static const Color overlay = Color(0x1A000000);
}

class AppShadow {
  static const BoxShadow top = BoxShadow(
    color: Color(0x14000000),
    offset: Offset(0, -2),
    blurRadius: 16,
    spreadRadius: 0,
  );

  static const BoxShadow bottom = BoxShadow(
    color: Color(0x29000000),
    offset: Offset(0, 4),
    blurRadius: 8,
    spreadRadius: 0,
  );
}
