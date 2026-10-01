import 'package:flutter/foundation.dart';

class AppIndicatorViewState {
  final int total;
  final ValueNotifier<int> index;

  const AppIndicatorViewState({
    required this.total,
    required this.index,
  }) : assert(total > 0);
}
