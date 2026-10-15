import 'dart:async';

import 'package:flutter/material.dart';

class AppKeyboardScrollView extends StatefulWidget {
  const AppKeyboardScrollView({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.focusedKey,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final GlobalKey? focusedKey;

  @override
  State<AppKeyboardScrollView> createState() => _AppKeyboardScrollViewState();
}

class _AppKeyboardScrollViewState extends State<AppKeyboardScrollView> with WidgetsBindingObserver {
  static const Duration _scrollDuration = Duration(milliseconds: 500);
  static const Curve _scrollCurve = Curves.easeOutCubic;
  static const Duration _spaceDuration = Duration(milliseconds: 250);
  static const Duration _keyboardSettleDelay = Duration(milliseconds: 200);

  Timer? _keyboardSettleTimer;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant AppKeyboardScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusedKey != oldWidget.focusedKey && _isKeyboardVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFocused());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _keyboardSettleTimer?.cancel();
    super.dispose();
  }

  /// 키보드 높이 변화 감지
  @override
  void didChangeMetrics() {
    final isKeyboardVisible = View.of(context).viewInsets.bottom > 0;

    if (isKeyboardVisible != _isKeyboardVisible) { setState(() => _isKeyboardVisible = isKeyboardVisible); }

    _keyboardSettleTimer?.cancel();
    _keyboardSettleTimer = Timer(_keyboardSettleDelay, _scrollToFocused);
  }

  void _scrollToFocused() {
    final focusedContext = widget.focusedKey?.currentContext;

    if (!mounted || !_isKeyboardVisible || focusedContext == null) { return; }

    Scrollable.ensureVisible(focusedContext, alignment: 0, duration: _scrollDuration, curve: _scrollCurve);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.child,
            AnimatedContainer(
              duration: _spaceDuration,
              curve: _scrollCurve,
              height: _isKeyboardVisible ? constraints.maxHeight : 0,
            ),
          ],
        ),
      ),
    );
  }
}
