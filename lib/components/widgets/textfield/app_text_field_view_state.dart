enum AppTextFieldStatus {
  normal,
  error
}

class AppTextFieldViewState {
  final AppTextFieldStatus status;
  final String? title;
  final String? placeholder;
  final String? errorText;

  const AppTextFieldViewState({
    required this.status,
    this.title,
    this.placeholder,
    this.errorText,
  });
}
