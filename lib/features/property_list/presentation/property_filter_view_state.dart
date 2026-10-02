import 'package:vine_butler/domain/property_type.dart';

class PropertyFilterViewState {
  final bool isFilterOpen;
  final PropertyFilterData data;

  const PropertyFilterViewState({
    this.isFilterOpen = false,
    this.data = const PropertyFilterData(),
  });

  PropertyFilterViewState copyWith({
    bool? isFilterOpen,
    PropertyFilterData? data,
  }) {
    return PropertyFilterViewState(
      isFilterOpen: isFilterOpen ?? this.isFilterOpen,
      data: data ?? this.data,
    );
  }
}

class PropertyFilterData {
  static const double minPrice = 0;
  static const double maxPrice = 3000000000;
  static const double priceDistance = 1000000;

  final PropertyTransactionType? transactionType;
  final Set<PropertyType> propertyTypes;
  final double price;

  const PropertyFilterData({
    this.transactionType,
    this.propertyTypes = const {},
    this.price = maxPrice,
  });

  bool get isApplied => transactionType != null || propertyTypes.isNotEmpty || price != maxPrice;

  PropertyFilterData copyWith({
    PropertyTransactionType? Function()? transactionType,
    Set<PropertyType>? propertyTypes,
    double? price,
  }) {
    return PropertyFilterData(
      transactionType: transactionType != null ? transactionType() : this.transactionType,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      price: price ?? this.price,
    );
  }
}

enum PropertyTypeFilterOption {
  oneRoom({PropertyType.oneRoom}),
  twoRoom({PropertyType.twoRoom}),
  villa({PropertyType.villa}),
  apartment({PropertyType.apartment}),
  singleMulti({PropertyType.single, PropertyType.multi}),
  commercialBuilding({PropertyType.commercialBuilding});

  const PropertyTypeFilterOption(this.types);

  final Set<PropertyType> types;
}
