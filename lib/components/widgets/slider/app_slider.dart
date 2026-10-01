import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppSlider extends StatefulWidget {
  final AppSliderViewState viewState;
  final ValueNotifier<double> controller;

  const AppSlider({
    super.key,
    required this.viewState,
    required this.controller,
  });

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  static const double _trackHeight = 4;
  static const Duration _duration = Duration(milliseconds: 250);
  static const Curve _curve = Curves.easeInOut;

  bool _isDragging = false;

  AppSliderViewState get _viewState => widget.viewState;

  @override
  Widget build(BuildContext context) {
    final thumb = thumbSize(_viewState.size);

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth - thumb;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => _update(details.localPosition.dx, thumb, trackWidth),
          onHorizontalDragStart: (details) => setState(() => _isDragging = true),
          onHorizontalDragUpdate: (details) => _update(details.localPosition.dx, thumb, trackWidth),
          onHorizontalDragEnd: (details) => setState(() => _isDragging = false),
          onHorizontalDragCancel: () => setState(() => _isDragging = false),
          child: ValueListenableBuilder<double>(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              final fraction = ((_snap(value) - _viewState.min) / (_viewState.max - _viewState.min)).clamp(0.0, 1.0);
              final thumbLeft = trackWidth * fraction;
              final duration = _isDragging ? Duration.zero : _duration;

              return SizedBox(
                width: double.infinity,
                height: height(_viewState.size),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    _track(BaseColor.medium, double.infinity),
                    AnimatedContainer(
                      duration: duration,
                      curve: _curve,
                      width: thumbLeft + thumb / 2,
                      height: _trackHeight,
                      decoration: BoxDecoration(
                        color: MainColor.medium,
                        borderRadius: BorderRadius.circular(_trackHeight / 2),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: duration,
                      curve: _curve,
                      left: thumbLeft,
                      child: Container(
                        width: thumb,
                        height: thumb,
                        decoration: BoxDecoration(
                          color: StateColor.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: MainColor.medium, width: borderWidth(_viewState.size)),
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

    final raw = _viewState.min + (dx - thumb / 2) / trackWidth * (_viewState.max - _viewState.min);
    widget.controller.value = _snap(raw);
  }

  double _snap(double raw) {
    final index = ((raw - _viewState.min) / _viewState.distance).round();
    final stepped = (_viewState.min + index * _viewState.distance).clamp(_viewState.min, _viewState.max);
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
