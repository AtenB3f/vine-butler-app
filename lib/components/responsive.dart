import 'dart:io';

import 'package:flutter/material.dart';

extension ResponsiveX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isDesktop => Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  bool get isMobile => Platform.isIOS || Platform.isAndroid;
}
