import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

enum ApplyPropertyPriceField {
  price,
  monthlyRent,
  maintenanceCost
}

class ApplyPropertyTypeViewState {
  final PropertyTransactionType? transactionType;
  final PropertyTypeFilterOption? propertyType;
  final double price;
  final double monthlyRent;
  final double maintenanceCost;
  final ApplyPropertyPriceField? editingField;
  final String? navigateTo;

  const ApplyPropertyTypeViewState({
    this.transactionType,
    this.propertyType,
    this.price = 0,
    this.monthlyRent = 0,
    this.maintenanceCost = 0,
    this.editingField,
    this.navigateTo,
  });

  factory ApplyPropertyTypeViewState.initial() => const ApplyPropertyTypeViewState();

  bool get isMonthlyRentVisible => transactionType == PropertyTransactionType.rent;

  ApplyPropertyPriceField? get nextField {
    switch (editingField) {
      case ApplyPropertyPriceField.price:
        return isMonthlyRentVisible ? ApplyPropertyPriceField.monthlyRent : ApplyPropertyPriceField.maintenanceCost;

      case ApplyPropertyPriceField.monthlyRent:
        return ApplyPropertyPriceField.maintenanceCost;

      case ApplyPropertyPriceField.maintenanceCost:
      case null:
        return null;
    }
  }

  bool get isCompleted => transactionType != null && propertyType != null;

  String get priceLabel {
    switch (transactionType) {
      case PropertyTransactionType.rent:
      case PropertyTransactionType.depositOnly:
        return '보증금';

      case PropertyTransactionType.buy:
      case null:
        return '금액';
    }
  }

  ApplyPropertyTypeViewState copyWith({
    PropertyTransactionType? Function()? transactionType,
    PropertyTypeFilterOption? Function()? propertyType,
    double? price,
    double? monthlyRent,
    double? maintenanceCost,
    ApplyPropertyPriceField? Function()? editingField,
    String? Function()? navigateTo,
  }) {
    return ApplyPropertyTypeViewState(
      transactionType: transactionType != null ? transactionType() : this.transactionType,
      propertyType: propertyType != null ? propertyType() : this.propertyType,
      price: price ?? this.price,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      maintenanceCost: maintenanceCost ?? this.maintenanceCost,
      editingField: editingField != null ? editingField() : this.editingField,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}
