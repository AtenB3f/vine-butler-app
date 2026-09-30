enum AppSliderSize {
  small,
  medium
}

class AppSliderViewState {
  final AppSliderSize size;
  final double min;
  final double max;
  final double distance;

  const AppSliderViewState({
    required this.size,
    required this.min,
    required this.max,
    required this.distance,
  })  : assert(min < max),
        assert(distance > 0 && distance <= max - min);
}
