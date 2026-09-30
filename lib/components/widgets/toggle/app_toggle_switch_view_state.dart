enum AppToggleSwitchStatus {
  off,
  on
}

class AppToggleSwitchViewState {
  final AppToggleSwitchStatus status;

  const AppToggleSwitchViewState({
    required this.status,
  });
}
