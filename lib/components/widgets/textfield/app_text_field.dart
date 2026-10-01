import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.viewState,
    required this.controller,
    this.onChanged,
  });

  final AppTextFieldViewState viewState;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  static const Duration _underlineDuration = Duration(milliseconds: 300);
  static const Curve _underlineCurve = Curves.easeInOut;

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
    final viewState = widget.viewState;
    final hasError = viewState.status == AppTextFieldStatus.error;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewState.title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(viewState.title!, style: AppFontStyle.bold1.style(TextColor.medium)),
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
                    hintText: viewState.placeholder,
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
        SizedBox(
          height: 1,
          child: Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(color: BaseColor.medium),
              ),
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: _underlineDuration,
                  curve: _underlineCurve,
                  opacity: _focusNode.hasFocus ? 1 : 0,
                  child: const ColoredBox(color: MainColor.medium),
                ),
              ),
            ],
          ),
        ),
        if (hasError && viewState.errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(viewState.errorText!, style: AppFontStyle.body1.style(StateColor.error)),
          ),
        ],
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _focusNode.requestFocus,
      child: content,
    );
  }
}