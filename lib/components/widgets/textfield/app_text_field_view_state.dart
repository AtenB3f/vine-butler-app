enum AppTextFieldStatus {
  normal,
  error
}

enum AppTextFieldKeyboardType {
  text,
  number
}

enum AppTextFieldInputAction {
  done,
  next
}

class AppTextFieldViewState {
  final AppTextFieldStatus status;
  final String? title;
  final String? placeholder;
  final String? errorText;
  final AppTextFieldKeyboardType keyboardType;
  final AppTextFieldInputAction inputAction;

  const AppTextFieldViewState({
    required this.status,
    this.title,
    this.placeholder,
    this.errorText,
    this.keyboardType = AppTextFieldKeyboardType.text,
    this.inputAction = AppTextFieldInputAction.done,
  });
}
