import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppIndicator extends StatelessWidget {
  final AppIndicatorViewState viewState;

  const AppIndicator({
    super.key,
    required this.viewState,
  });

  static const double _height = 4;
  static const Duration _duration = Duration(milliseconds: 400);
  static const Curve _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: viewState.index,
      builder: (context, index, child) {
        final activeIndex = index.clamp(0, viewState.total - 1);

        return SizedBox(
          width: double.infinity,
          height: _height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / viewState.total;

              return Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: BaseColor.light),
                  ),
                  AnimatedPositioned(
                    duration: _duration,
                    curve: _curve,
                    left: activeIndex * segmentWidth,
                    top: 0,
                    bottom: 0,
                    width: segmentWidth,
                    child: const ColoredBox(color: MainColor.medium),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
