import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

class ApplyPropertyTypeViewState {
  static const double priceDistance = 1000000;
  static const double minMonthlyRent = 10000;
  static const double maxMonthlyRent = 1500000;
  static const double monthlyRentDistance = 10000;

  final PropertyTransactionType? transactionType;
  final PropertyTypeFilterOption? propertyType;
  final double price;
  final double monthlyRent;
  final String? navigateTo;

  const ApplyPropertyTypeViewState({
    this.transactionType,
    this.propertyType,
    required this.price,
    required this.monthlyRent,
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

  ApplyPropertyTypeViewState copyWith({
    PropertyTransactionType? Function()? transactionType,
    PropertyTypeFilterOption? Function()? propertyType,
    double? price,
    double? monthlyRent,
    String? Function()? navigateTo,
  }) {
    return ApplyPropertyTypeViewState(
      transactionType: transactionType != null ? transactionType() : this.transactionType,
      propertyType: propertyType != null ? propertyType() : this.propertyType,
      price: price ?? this.price,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}
