extension PhoneNumberExtension on String {
  String get formattedPhoneNumber {
    final digits = replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 11 ? digits.substring(0, 11) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (i == 3 || i == 7) buffer.write('-');
      buffer.write(limited[i]);
    }
    return buffer.toString();
  }
}
