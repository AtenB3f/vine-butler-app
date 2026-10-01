import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppBndSearch extends StatefulWidget {
  const AppBndSearch({
    super.key,
    required this.viewState,
    required this.controller,
    required this.onSearchTap,
    required this.onFilterTap,
    this.onChanged,
    this.onFocusChanged,
  });

  final AppBndSearchViewState viewState;
  final TextEditingController controller;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChanged;

  @override
  State<AppBndSearch> createState() => _AppBndSearchState();
}

class _AppBndSearchState extends State<AppBndSearch> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => widget.onFocusChanged?.call(_focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final status = widget.viewState.status;

    return Container(
      width: double.infinity,
      height: 62,
      padding: const EdgeInsets.all(8),
      color: StateColor.white,
      foregroundDecoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BaseColor.light)),
      ),
      child: Row(
        spacing: 10,
        children: [
          AppImages.tabHome(true),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _focusNode.requestFocus,
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: lineColor(status), width: 2)),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        style: AppFontStyle.body2.style(TextColor.dark),
                        onChanged: widget.onChanged,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: widget.viewState.placeholder,
                          hintStyle: AppFontStyle.body2.style(TextColor.light),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onSearchTap,
                      child: AppIcons.searchLG(searchIconColor(status)),
                    ),
                    GestureDetector(
                      onTap: widget.onFilterTap,
                      child: AppIcons.filterLG(filterIconColor(status)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color lineColor(AppBndSearchStatus status) {
    switch (status) {
      case AppBndSearchStatus.enable:
        return MainColor.medium;
      case AppBndSearchStatus.disable:
      case AppBndSearchStatus.disableFilter:
        return MainColor.light;
    }
  }

  Color searchIconColor(AppBndSearchStatus status) {
    switch (status) {
      case AppBndSearchStatus.disable:
        return GrayColor.light;
      case AppBndSearchStatus.enable:
        return MainColor.medium;
      case AppBndSearchStatus.disableFilter:
        return BaseColor.dark;
    }
  }

  Color filterIconColor(AppBndSearchStatus status) {
    switch (status) {
      case AppBndSearchStatus.disable:
        return GrayColor.light;
      case AppBndSearchStatus.enable:
      case AppBndSearchStatus.disableFilter:
        return MainColor.medium;
    }
  }
}
