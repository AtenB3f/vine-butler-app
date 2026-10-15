class ApplyPropertyOwnerViewState {
  static const defaultPhone = '010';
  static final RegExp _phonePattern = RegExp(r'^010-\d{4}-\d{4}$');

  final String name;
  final String phone;
  final String? navigateTo;

  const ApplyPropertyOwnerViewState({
    this.name = '',
    this.phone = defaultPhone,
    this.navigateTo,
  });

  bool get isPhoneValid => _phonePattern.hasMatch(phone);

  bool get hasPhoneError => phone.isNotEmpty && phone != defaultPhone && !isPhoneValid;

  bool get isCompleted => name.trim().isNotEmpty && isPhoneValid;

  ApplyPropertyOwnerViewState copyWith({
    String? name,
    String? phone,
    String? Function()? navigateTo,
  }) {
    return ApplyPropertyOwnerViewState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}
