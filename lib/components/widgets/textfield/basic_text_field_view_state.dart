import 'package:flutter/widgets.dart';
import 'package:vine_butler/components/widgets/textfield/app_text_field_view_state.dart';

class BasicTextFieldViewState {
  final TextStyle style;
  final TextAlign textAlign;
  final AppTextFieldKeyboardType keyboardType;

  const BasicTextFieldViewState({
    required this.style,
    this.textAlign = TextAlign.start,
    this.keyboardType = AppTextFieldKeyboardType.text,
  });
}
