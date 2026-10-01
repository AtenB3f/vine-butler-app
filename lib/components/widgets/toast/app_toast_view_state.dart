enum AppToastType {
  check,
  warning
}

class AppToastViewState {
  final AppToastType type;
  final String text;
  final bool hasLink;

  const AppToastViewState({
    required this.type,
    required this.text,
    this.hasLink = true,
  });
}
