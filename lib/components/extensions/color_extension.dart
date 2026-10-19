import 'package:flutter/painting.dart';

extension ColorExtension on Color {
  String get hexCode => '#${(toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}
