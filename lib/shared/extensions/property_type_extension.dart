import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

extension PropertyTransactionTypeExtension on PropertyTransactionType {
  String get label {
    switch (this) {
      case PropertyTransactionType.buy:
        return '매매';
      case PropertyTransactionType.depositOnly:
        return '전세';
      case PropertyTransactionType.rent:
        return '월세';
    }
  }

  OutlineButtonType get buttonType {
    switch (this) {
      case PropertyTransactionType.rent:
        return OutlineButtonType.primary;
      case PropertyTransactionType.depositOnly:
        return OutlineButtonType.secondary;
      case PropertyTransactionType.buy:
        return OutlineButtonType.tertiary;
    }
  }

  LineTagType get tagType {
    switch (this) {
      case PropertyTransactionType.buy:
        return LineTagType.tertiary;
      case PropertyTransactionType.depositOnly:
        return LineTagType.secondary;
      case PropertyTransactionType.rent:
        return LineTagType.primary;
    }
  }
}

extension PropertyTypeFilterOptionExtension on PropertyTypeFilterOption {
  String get label {
    switch (this) {
      case PropertyTypeFilterOption.oneRoom:
        return '원룸';
      case PropertyTypeFilterOption.twoRoom:
        return '투룸';
      case PropertyTypeFilterOption.villa:
        return '빌라';
      case PropertyTypeFilterOption.apartment:
        return '아파트';
      case PropertyTypeFilterOption.singleMulti:
        return '단독/다가구';
      case PropertyTypeFilterOption.commercialBuilding:
        return '상가';
    }
  }
}
