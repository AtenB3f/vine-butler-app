class ApplyPropertyOwnerViewState {
  static final RegExp _phonePattern = RegExp(r'^010-\d{4}-\d{4}$');

  final String name;
  final String phone;

  const ApplyPropertyOwnerViewState({
    this.name = '',
    this.phone = '',
  });

  bool get isPhoneValid => _phonePattern.hasMatch(phone);

  bool get isCompleted => name.trim().isNotEmpty && isPhoneValid;

  ApplyPropertyOwnerViewState copyWith({
    String? name,
    String? phone,
  }) {
    return ApplyPropertyOwnerViewState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}
