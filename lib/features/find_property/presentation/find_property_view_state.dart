import 'package:vine_butler/domain/property_type.dart';

enum FindPropertyPriceField {
  price
}

class FindPropertyViewState {
  final PropertyTransactionType? transactionType;
  final Set<PropertyType> propertyTypes;
  final double price;
  final FindPropertyPriceField? editingField;
  final String? navigateTo;

  const FindPropertyViewState({
    this.transactionType,
    this.propertyTypes = const {},
    this.price = 0,
    this.editingField,
    this.navigateTo,
  });

  factory FindPropertyViewState.initial() => const FindPropertyViewState();

  FindPropertyViewState copyWith({
    PropertyTransactionType? Function()? transactionType,
    Set<PropertyType>? propertyTypes,
    double? price,
    FindPropertyPriceField? Function()? editingField,
    String? Function()? navigateTo,
  }) {
    return FindPropertyViewState(
      transactionType: transactionType != null ? transactionType() : this.transactionType,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      price: price ?? this.price,
      editingField: editingField != null ? editingField() : this.editingField,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}
