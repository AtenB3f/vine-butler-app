import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppTooltip extends StatelessWidget {
  final AppTooltipViewState viewState;

  const AppTooltip({
    super.key,
    required this.viewState,
  });

  static const double _arrowWidth = 10;
  static const double _arrowHeight = 8;
  static const double _arrowOverlap = 1;
  static const double _arrowEdgeCenter = 16.5;

  bool get _isTop {
    switch (viewState.direction) {
      case AppTooltipDirection.topCenter:
      case AppTooltipDirection.topLeft:
      case AppTooltipDirection.topRight:
        return true;
      case AppTooltipDirection.bottomLeft:
      case AppTooltipDirection.bottomCenter:
      case AppTooltipDirection.bottomRight:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: GrayColor.dark,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [AppShadow.bottom],
      ),
      child: AppFontStyle.body2.text(viewState.text, StateColor.white),
    );

    final arrow = Positioned(
      left: 0,
      right: 0,
      top: _isTop ? null : 0,
      bottom: _isTop ? 0 : null,
      child: Align(
        alignment: arrowAlignment(viewState.direction),
        heightFactor: 1,
        child: Padding(
          padding: arrowPadding(viewState.direction),
          child: CustomPaint(
            size: const Size(_arrowWidth, _arrowHeight + _arrowOverlap),
            painter: _ArrowPainter(
              pointsDown: _isTop,
              arrowHeight: _arrowHeight,
              overlap: _arrowOverlap,
            ),
          ),
        ),
      ),
    );

    return IntrinsicWidth(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: _isTop ? 0 : _arrowHeight,
              bottom: _isTop ? _arrowHeight : 0,
            ),
            child: bubble,
          ),
          arrow,
        ],
      ),
    );
  }

  Alignment arrowAlignment(AppTooltipDirection direction) {
    switch (direction) {
      case AppTooltipDirection.topCenter:
      case AppTooltipDirection.bottomCenter:
        return Alignment.center;
      case AppTooltipDirection.topLeft:
      case AppTooltipDirection.bottomLeft:
        return Alignment.centerLeft;
      case AppTooltipDirection.topRight:
      case AppTooltipDirection.bottomRight:
        return Alignment.centerRight;
    }
  }

  EdgeInsets arrowPadding(AppTooltipDirection direction) {
    const edge = _arrowEdgeCenter - _arrowWidth / 2;

    switch (direction) {
      case AppTooltipDirection.topCenter:
      case AppTooltipDirection.bottomCenter:
        return EdgeInsets.zero;
      case AppTooltipDirection.topLeft:
      case AppTooltipDirection.bottomLeft:
        return const EdgeInsets.only(left: edge);
      case AppTooltipDirection.topRight:
      case AppTooltipDirection.bottomRight:
        return const EdgeInsets.only(right: edge);
    }
  }
}

class _ArrowPainter extends CustomPainter {
  final bool pointsDown;
  final double arrowHeight;
  final double overlap;

  const _ArrowPainter({
    required this.pointsDown,
    required this.arrowHeight,
    required this.overlap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointsDown) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, overlap)
        ..lineTo(size.width / 2, overlap + arrowHeight)
        ..lineTo(0, overlap);
    } else {
      path
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width, arrowHeight)
        ..lineTo(size.width, arrowHeight + overlap)
        ..lineTo(0, arrowHeight + overlap)
        ..lineTo(0, arrowHeight);
    }
    path.close();

    canvas.drawPath(path, Paint()..color = GrayColor.dark);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return pointsDown != oldDelegate.pointsDown ||
        arrowHeight != oldDelegate.arrowHeight ||
        overlap != oldDelegate.overlap;
  }
}
