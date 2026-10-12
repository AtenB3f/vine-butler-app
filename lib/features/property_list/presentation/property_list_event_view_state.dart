class PropertyListEventViewState {
  final int? registerId;

  const PropertyListEventViewState({this.registerId});

  PropertyListEventViewState copyWith({
    int? Function()? registerId,
  }) {
    return PropertyListEventViewState(
      registerId: registerId != null ? registerId() : this.registerId,
    );
  }
}
