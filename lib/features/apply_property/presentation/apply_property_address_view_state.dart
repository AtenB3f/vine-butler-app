class ApplyPropertyAddressViewState {
  final String query;
  final List<AddressResultViewState> results;
  final AddressResultViewState? selected;

  const ApplyPropertyAddressViewState({
    this.query = '',
    this.results = const [],
    this.selected,
  });

  bool get isNotFound => query.isNotEmpty && selected == null && results.isEmpty;

  bool get isMapVisible => selected != null;

  ApplyPropertyAddressViewState copyWith({
    String? query,
    List<AddressResultViewState>? results,
    AddressResultViewState? Function()? selected,
  }) {
    return ApplyPropertyAddressViewState(
      query: query ?? this.query,
      results: results ?? this.results,
      selected: selected != null ? selected() : this.selected,
    );
  }
}

class AddressResultViewState {
  final String zipCode;
  final String address;
  final String lotAddress;

  const AddressResultViewState({
    required this.zipCode,
    required this.address,
    required this.lotAddress,
  });
}
