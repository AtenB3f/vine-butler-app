class ApplyPropertyExtraViewState {
  final bool? isAvailableSuretyInsurance;
  final bool? hasLoan;
  final bool? isAvailableParking;
  final DateTime? moveInDate;
  final bool isMoveInDateNegotiable;
  final int? roomCount;
  final Set<String> furnitureOptions;
  final String memo;
  final bool isSaving;
  final String? errorMessage;
  final String? navigateTo;

  const ApplyPropertyExtraViewState({
    this.isAvailableSuretyInsurance,
    this.hasLoan,
    this.isAvailableParking,
    this.moveInDate,
    this.isMoveInDateNegotiable = false,
    this.roomCount,
    this.furnitureOptions = const {},
    this.memo = '',
    this.isSaving = false,
    this.errorMessage,
    this.navigateTo,
  });

  ApplyPropertyExtraViewState copyWith({
    bool? Function()? isAvailableSuretyInsurance,
    bool? Function()? hasLoan,
    bool? Function()? isAvailableParking,
    DateTime? moveInDate,
    bool? isMoveInDateNegotiable,
    int? Function()? roomCount,
    Set<String>? furnitureOptions,
    String? memo,
    bool? isSaving,
    String? Function()? errorMessage,
    String? Function()? navigateTo,
  }) {
    return ApplyPropertyExtraViewState(
      isAvailableSuretyInsurance:
          isAvailableSuretyInsurance != null ? isAvailableSuretyInsurance() : this.isAvailableSuretyInsurance,
      hasLoan: hasLoan != null ? hasLoan() : this.hasLoan,
      isAvailableParking: isAvailableParking != null ? isAvailableParking() : this.isAvailableParking,
      moveInDate: moveInDate ?? this.moveInDate,
      isMoveInDateNegotiable: isMoveInDateNegotiable ?? this.isMoveInDateNegotiable,
      roomCount: roomCount != null ? roomCount() : this.roomCount,
      furnitureOptions: furnitureOptions ?? this.furnitureOptions,
      memo: memo ?? this.memo,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}
