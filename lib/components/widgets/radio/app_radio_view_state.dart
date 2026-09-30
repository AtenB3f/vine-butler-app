enum AppRadioStatus {
  unchecked,
  checked,
  disabled
}

class AppRadioViewState {
  final AppRadioStatus status;
  final String text;

  const AppRadioViewState({
    required this.status,
    required this.text,
  });
}
