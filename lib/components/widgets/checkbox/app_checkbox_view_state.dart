enum AppCheckboxStatus {
  unchecked,
  checked,
  disabled
}

class AppCheckboxViewState {
  final AppCheckboxStatus status;
  final String text;

  const AppCheckboxViewState({
    required this.status,
    required this.text,
  });
}
