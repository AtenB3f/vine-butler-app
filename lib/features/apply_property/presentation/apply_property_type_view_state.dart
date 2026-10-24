import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

enum ApplyPropertyPriceField {
  price,
  monthlyRent,
  maintenanceCost
}

class ApplyPropertyTypeViewState {
  static const double priceDistance = 1000000;
  static const double minMonthlyRent = 10000;
  static const double maxMonthlyRent = 1500000;
  static const double monthlyRentDistance = 10000;
  static const double minMaintenanceCost = 0;
  static const double maxMaintenanceCost = 500000;
  static const double maintenanceCostDistance = 10000;
  static const double defaultMaintenanceCost = 100000;

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
    required this.price,
    required this.monthlyRent,
    this.maintenanceCost = defaultMaintenanceCost,
    this.editingField,
    this.navigateTo,
  });

  factory ApplyPropertyTypeViewState.initial() {
    const empty = ApplyPropertyTypeViewState(price: 0, monthlyRent: 0);

    return empty.copyWith(
      price: empty.midPrice,
      monthlyRent: minMonthlyRent +
          ((maxMonthlyRent - minMonthlyRent) / 2 / monthlyRentDistance).floor() * monthlyRentDistance,
    );
  }

  double get midPrice => minPrice + ((maxPrice - minPrice) / 2 / priceDistance).floor() * priceDistance;

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

  double get minPrice => transactionType?.minPrice ?? 0;

  double get maxPrice => transactionType?.maxPrice ?? PropertyTransactionType.buy.maxPrice;

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
