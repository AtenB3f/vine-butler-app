import 'package:flutter/material.dart';

extension ResponsiveX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isDesktop => screenWidth >= 600;
  bool get isMobile => screenWidth < 600;
}
