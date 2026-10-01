class AppAlertDialogViewState {
  final String? title;
  final String message;
  final String primaryText;
  final String? secondaryText;

  const AppAlertDialogViewState({
    this.title,
    required this.message,
    required this.primaryText,
    this.secondaryText,
  });
}
