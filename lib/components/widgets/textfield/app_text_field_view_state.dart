enum AppTextFieldStatus {
  normal,
  error
}

enum AppTextFieldKeyboardType {
  text,
  number
}

class AppTextFieldViewState {
  final AppTextFieldStatus status;
  final String? title;
  final String? placeholder;
  final String? errorText;
  final AppTextFieldKeyboardType keyboardType;

  const AppTextFieldViewState({
    required this.status,
    this.title,
    this.placeholder,
    this.errorText,
    this.keyboardType = AppTextFieldKeyboardType.text,
  });
}
