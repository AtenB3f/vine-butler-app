enum AppToggleCheckStatus {
  off,
  on
}

class AppToggleCheckViewState {
  final AppToggleCheckStatus status;
  final String text;

  const AppToggleCheckViewState({
    required this.status,
    required this.text,
  });
}
