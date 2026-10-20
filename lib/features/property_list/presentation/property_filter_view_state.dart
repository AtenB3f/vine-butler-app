import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';

/// 검색 BND 아래 패널 상태
///
/// - `close`: 패널 닫힘
/// - `open`: 패널 열림
/// - `select`: 검색 결과 선택/마커 선택
enum PropertySearchStatus {
  close,
  open,
  select;

  AppBndSearchStatus bndStatus({required String query, required bool isFilterApplied}) {
    if (query.isNotEmpty) { return this == select ? AppBndSearchStatus.search : AppBndSearchStatus.enable; }

    return isFilterApplied ? AppBndSearchStatus.filter : AppBndSearchStatus.disable;
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

  PropertySearchCondition toCondition(String query) {
    return PropertySearchCondition(
      transactionType: transactionType,
      propertyTypes: propertyTypes,
      price: price == maxPrice ? null : price.round(),
      keyword: query.trim(),
    );
  }

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
  singleMulti({PropertyType.detachedHouse}),
  commercialBuilding({PropertyType.commercialBuilding});

  const PropertyTypeFilterOption(this.types);

  final Set<PropertyType> types;
}
