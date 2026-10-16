class PropertyListEventViewState {
  final String? registerId;

  const PropertyListEventViewState({this.registerId});

  PropertyListEventViewState copyWith({
    String? Function()? registerId,
  }) {
    return PropertyListEventViewState(
      registerId: registerId != null ? registerId() : this.registerId,
    );
  }
}
