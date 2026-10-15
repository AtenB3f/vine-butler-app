import 'package:flutter/widgets.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class PhoneNumberEditingController extends TextEditingController {
  PhoneNumberEditingController({super.text});

  @override
  set value(TextEditingValue newValue) {
    final text = newValue.text.formattedPhoneNumber;

    super.value = newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: TextRange.empty,
    );
  }
}
