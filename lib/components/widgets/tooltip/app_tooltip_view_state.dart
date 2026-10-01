enum AppTooltipDirection {
  topCenter,
  topLeft,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight
}

class AppTooltipViewState {
  final AppTooltipDirection direction;
  final String text;

  const AppTooltipViewState({
    required this.direction,
    required this.text,
  });
}
