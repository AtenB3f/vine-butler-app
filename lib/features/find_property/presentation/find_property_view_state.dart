import 'package:vine_butler/domain/property_type.dart';

class FindPropertyViewState {
  static const double priceDistance = 1000000;

  final PropertyTransactionType? transactionType;
  final Set<PropertyType> propertyTypes;
  final double price;
  final String? navigateTo;

  const FindPropertyViewState({
    this.transactionType,
    this.propertyTypes = const {},
    required this.price,
    this.navigateTo,
  });

  factory FindPropertyViewState.initial() {
    const empty = FindPropertyViewState(price: 0);

    return empty.copyWith(price: empty.midPrice);
  }

  double get midPrice => minPrice + ((maxPrice - minPrice) / 2 / priceDistance).floor() * priceDistance;

  double get minPrice {
    switch (transactionType) {
      case PropertyTransactionType.buy:
        return 100000000;

      case PropertyTransactionType.rent:
      case PropertyTransactionType.depositOnly:
      case null:
        return 0;
    }
  }

  double get maxPrice {
    switch (transactionType) {
      case PropertyTransactionType.rent:
        return 500000000;

      case PropertyTransactionType.depositOnly:
        return 1500000000;

      case PropertyTransactionType.buy:
      case null:
        return 3000000000;
    }
  }

  FindPropertyViewState copyWith({
    PropertyTransactionType? Function()? transactionType,
    Set<PropertyType>? propertyTypes,
    double? price,
    String? Function()? navigateTo,
  }) {
    return FindPropertyViewState(
      transactionType: transactionType != null ? transactionType() : this.transactionType,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      price: price ?? this.price,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}
