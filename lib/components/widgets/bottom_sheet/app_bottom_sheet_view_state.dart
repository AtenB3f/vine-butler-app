import 'package:flutter/material.dart';

class AppBottomSheetViewState {
  final List<AppSheetItemViewState> items;
  final int selectedIndex;

  const AppBottomSheetViewState({
    required this.items,
    required this.selectedIndex,
  });
}
class AppSheetItemViewState {
  final String text;
  final Widget Function(Color color)? image;

  const AppSheetItemViewState({
    required this.text,
    this.image,
  });
}
