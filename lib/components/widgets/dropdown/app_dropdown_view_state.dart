import 'package:flutter/material.dart';

class AppDropdownViewState {
  final List<AppDropdownItemViewState> items;
  final int selectedIndex;

  const AppDropdownViewState({
    required this.items,
    required this.selectedIndex,
  });
}

class AppDropdownItemViewState {
  final String text;
  final Widget Function(Color color)? image;

  const AppDropdownItemViewState({
    required this.text,
    this.image,
  });
}
