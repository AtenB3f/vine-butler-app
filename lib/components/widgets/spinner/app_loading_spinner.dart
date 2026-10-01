import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppLoadingSpinner extends StatefulWidget {
  final AppLoadingSpinnerViewState viewState;

  const AppLoadingSpinner({
    super.key,
    required this.viewState,
  });

  @override
  State<AppLoadingSpinner> createState() => _AppLoadingSpinnerState();
}

class _AppLoadingSpinnerState extends State<AppLoadingSpinner> with SingleTickerProviderStateMixin {
  static const Curve _curve = Curves.linear;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  late final Animation<double> _turns = CurvedAnimation(
    parent: _controller,
    curve: _curve,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.viewState.size;

    return RotationTransition(
      turns: _turns,
      child: CustomPaint(
        size: Size.square(dimension(size)),
        painter: _SpinnerPainter(
          trackStroke: trackStroke(size),
          trackRadius: trackRadius(size),
          arcStroke: arcStroke(size),
          arcRadius: arcRadius(size),
        ),
      ),
    );
  }

  double dimension(AppLoadingSpinnerSize size) {
    switch (size) {
      case AppLoadingSpinnerSize.small:
        return 24;
      case AppLoadingSpinnerSize.large:
        return 40;
    }
  }

  double trackStroke(AppLoadingSpinnerSize size) {
    switch (size) {
      case AppLoadingSpinnerSize.small:
        return 3;
      case AppLoadingSpinnerSize.large:
        return 4;
    }
  }

  double trackRadius(AppLoadingSpinnerSize size) {
    switch (size) {
      case AppLoadingSpinnerSize.small:
        return 10.5;
      case AppLoadingSpinnerSize.large:
        return 18;
    }
  }

  double arcStroke(AppLoadingSpinnerSize size) {
    switch (size) {
      case AppLoadingSpinnerSize.small:
        return 2.4;
      case AppLoadingSpinnerSize.large:
        return 4;
    }
  }

  double arcRadius(AppLoadingSpinnerSize size) {
    switch (size) {
      case AppLoadingSpinnerSize.small:
        return 10.8;
      case AppLoadingSpinnerSize.large:
        return 18;
    }
  }
}

class _SpinnerPainter extends CustomPainter {
  final double trackStroke;
  final double trackRadius;
  final double arcStroke;
  final double arcRadius;

  const _SpinnerPainter({
    required this.trackStroke,
    required this.trackRadius,
    required this.arcStroke,
    required this.arcRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    canvas.drawCircle(
      center,
      trackRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackStroke
        ..color = BaseColor.light,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      0,
      math.pi / 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcStroke
        ..color = MainColor.medium,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return trackStroke != oldDelegate.trackStroke ||
        trackRadius != oldDelegate.trackRadius ||
        arcStroke != oldDelegate.arcStroke ||
        arcRadius != oldDelegate.arcRadius;
  }
}
