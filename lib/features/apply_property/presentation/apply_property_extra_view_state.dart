class ApplyPropertyExtraViewState {
  final bool? isAvailableSuretyInsurance;
  final bool? hasLoan;
  final bool? isAvailableParking;
  final DateTime? moveInDate;
  final bool isMoveInDateNegotiable;
  final int? roomCount;
  final Set<String> furnitureOptions;
  final String memo;

  const ApplyPropertyExtraViewState({
    this.isAvailableSuretyInsurance,
    this.hasLoan,
    this.isAvailableParking,
    this.moveInDate,
    this.isMoveInDateNegotiable = false,
    this.roomCount,
    this.furnitureOptions = const {},
    this.memo = '',
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
    );
  }
}
