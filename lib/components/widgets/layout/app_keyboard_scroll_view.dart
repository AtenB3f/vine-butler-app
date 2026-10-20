import 'package:flutter/material.dart';
import 'package:vine_butler/components/responsive.dart';

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

class _AppKeyboardScrollViewState extends State<AppKeyboardScrollView> {
  static const Duration _scrollDuration = Duration(milliseconds: 500);
  static const Curve _scrollCurve = Curves.easeOutCubic;
  static const Duration _spaceDuration = Duration(milliseconds: 250);

  /// 화면 위로 올릴 입력란의 키
  ///
  /// - 모바일에서만 `focusedKey`를 사용 (데스크톱은 키보드가 화면을 가리지 않아 이동하지 않음)
  GlobalKey? get _focusedKey => context.isMobile ? widget.focusedKey : null;

  @override
  void didUpdateWidget(covariant AppKeyboardScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_focusedKey != null && widget.focusedKey != oldWidget.focusedKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFocused());
    }
  }

  void _scrollToFocused() {
    final focusedContext = _focusedKey?.currentContext;

    if (!mounted || focusedContext == null) { return; }

    Scrollable.ensureVisible(focusedContext, alignment: 0, duration: _scrollDuration, curve: _scrollCurve);
  }

  /// 포커스된 입력란을 맨 위로 올릴 수 있게 콘텐츠 끝에 붙이는 여유 공간
  ///
  /// - 포커스 순간에는 애니메이션 없이 바로 붙임 (스크롤 시작 시점에 스크롤 가능 거리가 있어야 끝까지 올라감)
  /// - 포커스가 풀리면 `_spaceDuration` 동안 줄어듦
  Widget _focusSpace(double viewportHeight) {
    final hasFocus = _focusedKey != null;

    return AnimatedContainer(
      duration: hasFocus ? Duration.zero : _spaceDuration,
      curve: _scrollCurve,
      height: hasFocus ? viewportHeight : 0,
    );
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
            _focusSpace(constraints.maxHeight),
          ],
        ),
      ),
    );
  }
}
