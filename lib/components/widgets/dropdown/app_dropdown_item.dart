import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppDropdownItem extends StatefulWidget {
  final AppDropdownItemViewState viewState;
  final bool isSelected;
  final VoidCallback onTap;

  const AppDropdownItem({
    super.key,
    required this.viewState,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AppDropdownItem> createState() => _AppDropdownItemState();
}

class _AppDropdownItemState extends State<AppDropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final image = widget.viewState.image;
    final color = widget.isSelected ? TextColor.dark : TextColor.medium;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
          decoration: BoxDecoration(
            color: _isHovered ? BaseColor.light : StateColor.white,
            borderRadius: BorderRadius.circular(_isHovered ? 2 : 6),
          ),
          child: Row(
            spacing: 8,
            children: [
              if (image != null) image(color),
              Expanded(
                child: widget.isSelected
                    ? AppFontStyle.bold2.text(widget.viewState.text, color)
                    : AppFontStyle.body2.text(widget.viewState.text, color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
