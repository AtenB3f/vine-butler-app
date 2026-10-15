import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vine_butler/components/components.dart';

class BasicTextField extends StatefulWidget {
  const BasicTextField({
    super.key,
    required this.viewState,
    required this.controller,
    this.onChange,
    this.onFocus,
    this.onSubmit,
  });

  final BasicTextFieldViewState viewState;
  final TextEditingController controller;
  final ValueChanged<String>? onChange;
  final ValueChanged<bool>? onFocus;
  final ValueChanged<String>? onSubmit;

  @override
  State<BasicTextField> createState() => _BasicTextFieldState();
}

class _BasicTextFieldState extends State<BasicTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
  }

  void _onFocus() => widget.onFocus?.call(_focusNode.hasFocus);

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewState = widget.viewState;
    final isNumber = viewState.keyboardType == AppTextFieldKeyboardType.number;

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      style: viewState.style,
      textAlign: viewState.textAlign,
      keyboardType: isNumber ? TextInputType.number : null,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChange,
      onSubmitted: widget.onSubmit,
      decoration: const InputDecoration.collapsed(hintText: null),
    );
  }
}
