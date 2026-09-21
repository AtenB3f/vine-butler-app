import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.title,
    this.placeholder,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? title;
  final String? placeholder;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onChange);
    widget.controller.addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onChange);
      widget.controller.addListener(_onChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _clear() {
    widget.controller.clear();
    widget.onChanged?.call('');
  }

  // MARK: - Widget
  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final hasError = widget.errorText != null;
    final underlineColor = hasError ? BaseColor.light : (_focusNode.hasFocus ? MainColor.medium : BaseColor.medium);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(widget.title!, style: AppFontStyle.bold1.style(TextColor.medium)),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Row(
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
                    hintText: widget.placeholder,
                    hintStyle: AppFontStyle.body2.style(TextColor.light),
                  ),
                ),
              ),
              if (hasText) ...[
                const SizedBox(width: 8),
                GestureDetector(onTap: _clear, child: AppIcons.closeSM(GrayColor.dark)),
              ],
            ],
          ),
        ),
        Container(height: 1, color: underlineColor),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(widget.errorText!, style: AppFontStyle.body1.style(StateColor.error)),
          ),
        ],
      ],
    );
  }
}