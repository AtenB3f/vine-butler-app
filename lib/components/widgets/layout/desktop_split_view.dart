import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vine_butler/components/widgets/layout/desktop_split_view_state.dart';

/// 경계선을 드래그 앤 드롭하여 너비를 조절하는 데스크톱 2열 레이아웃
///
/// - 사이드·콘텐츠 모두 `minWidth` 이상 유지
class DesktopSplitView extends StatefulWidget {
  final DesktopSplitViewState viewState;
  final Widget side;
  final Widget content;
  final ValueChanged<double> onResize;
  final VoidCallback onResizeEnd;

  const DesktopSplitView({
    super.key,
    required this.viewState,
    required this.side,
    required this.content,
    required this.onResize,
    required this.onResizeEnd,
  });

  @override
  State<DesktopSplitView> createState() => _DesktopSplitViewState();
}

class _DesktopSplitViewState extends State<DesktopSplitView> {
  static const Duration _duration = Duration(milliseconds: 250);
  static const double _handleWidth = 8;

  double _dragWidth = 0;
  Widget? _lastSide;

  double _clampedWidth(double width, double totalWidth) {
    final minWidth = widget.viewState.minWidth;

    return width.clamp(minWidth, math.max(minWidth, totalWidth - minWidth));
  }

  @override
  Widget build(BuildContext context) {
    final viewState = widget.viewState;

    if (viewState.type == DesktopSplitType.two) { _lastSide = widget.side; }

    final lastSide = _lastSide ?? widget.side;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final sideWidth = _clampedWidth(viewState.sideWidth, totalWidth);

        return TweenAnimationBuilder<double>(
          tween: Tween(end: viewState.type == DesktopSplitType.two ? 1 : 0),
          duration: _duration,
          curve: Curves.easeInOut,
          builder: (context, progress, _) {
            final contentWidth = totalWidth - sideWidth * progress;
            final isResizable = progress == 1 && totalWidth > viewState.minWidth * 2;

            return Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: contentWidth, child: widget.content),
                    if (contentWidth < totalWidth)
                      Expanded(
                        child: ClipRect(
                          child: OverflowBox(
                            alignment: Alignment.centerLeft,
                            minWidth: sideWidth,
                            maxWidth: sideWidth,
                            child: lastSide,
                          ),
                        ),
                      ),
                  ],
                ),
                if (isResizable)
                  Positioned(
                    left: contentWidth - _handleWidth / 2,
                    top: 0,
                    bottom: 0,
                    width: _handleWidth,
                    child: _handle(sideWidth, totalWidth),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _handle(double sideWidth, double totalWidth) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (_) => _dragWidth = sideWidth,
        onHorizontalDragUpdate: (details) {
          _dragWidth -= details.delta.dx;
          widget.onResize(_clampedWidth(_dragWidth, totalWidth));
        },
        onHorizontalDragEnd: (_) => widget.onResizeEnd(),
      ),
    );
  }
}
