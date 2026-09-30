import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppSlider extends StatelessWidget {
  final AppSliderViewState viewState;
  final ValueNotifier<double> controller;

  const AppSlider({
    super.key,
    required this.viewState,
    required this.controller,
  });

  static const double _trackHeight = 4;

  @override
  Widget build(BuildContext context) {
    final thumb = thumbSize(viewState.size);

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth - thumb;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => _update(details.localPosition.dx, thumb, trackWidth),
          onHorizontalDragUpdate: (details) => _update(details.localPosition.dx, thumb, trackWidth),
          child: ValueListenableBuilder<double>(
            valueListenable: controller,
            builder: (context, value, child) {
              final fraction = ((_snap(value) - viewState.min) / (viewState.max - viewState.min)).clamp(0.0, 1.0);
              final thumbLeft = trackWidth * fraction;

              return SizedBox(
                width: double.infinity,
                height: height(viewState.size),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    _track(BaseColor.medium, double.infinity),
                    _track(MainColor.medium, thumbLeft + thumb / 2),
                    Positioned(
                      left: thumbLeft,
                      child: Container(
                        width: thumb,
                        height: thumb,
                        decoration: BoxDecoration(
                          color: StateColor.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: MainColor.medium, width: borderWidth(viewState.size)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _track(Color color, double width) {
    return Container(
      width: width,
      height: _trackHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_trackHeight / 2),
      ),
    );
  }

  void _update(double dx, double thumb, double trackWidth) {
    if (trackWidth <= 0) {
      return;
    }

    final raw = viewState.min + (dx - thumb / 2) / trackWidth * (viewState.max - viewState.min);
    controller.value = _snap(raw);
  }

  double _snap(double raw) {
    final index = ((raw - viewState.min) / viewState.distance).round();
    final stepped = (viewState.min + index * viewState.distance).clamp(viewState.min, viewState.max);
    return double.parse(stepped.toStringAsFixed(10));
  }

  double thumbSize(AppSliderSize size) {
    switch (size) {
      case AppSliderSize.small:
        return 14;
      case AppSliderSize.medium:
        return 18;
    }
  }

  double borderWidth(AppSliderSize size) {
    switch (size) {
      case AppSliderSize.small:
        return 3;
      case AppSliderSize.medium:
        return 4;
    }
  }

  double height(AppSliderSize size) {
    switch (size) {
      case AppSliderSize.small:
        return 26;
      case AppSliderSize.medium:
        return 30;
    }
  }
}
