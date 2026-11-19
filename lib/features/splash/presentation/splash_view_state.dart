class SplashViewState {
  final SplashStatus status;
  final String? navigateTo;

  const SplashViewState({
    this.status = SplashStatus.check,
    this.navigateTo,
  });

  SplashViewState copyWith({
    SplashStatus? status,
    String? Function()? navigateTo,
  }) {
    return SplashViewState(
      status: status ?? this.status,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}

enum SplashStatus {
  check,
  idle,
  update,
}
