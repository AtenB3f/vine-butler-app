import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/find_property/presentation/find_property_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

final findPropertyVMProvider = NotifierProvider<FindPropertyVM, FindPropertyViewState>(FindPropertyVM.new);

class FindPropertyVM extends Notifier<FindPropertyViewState> {
  static const transactionTypeOptions = [
    PropertyTransactionType.rent,
    PropertyTransactionType.depositOnly,
    PropertyTransactionType.buy,
  ];

  static const propertyTypeOptions = [
    [
      PropertyTypeFilterOption.oneRoom,
      PropertyTypeFilterOption.twoRoom,
      PropertyTypeFilterOption.villa,
    ],
    [
      PropertyTypeFilterOption.apartment,
      PropertyTypeFilterOption.singleMulti,
      PropertyTypeFilterOption.commercialBuilding,
    ],
  ];

  @override
  FindPropertyViewState build() => FindPropertyViewState.initial();

  void selectTransactionType(PropertyTransactionType type) {
    final selected = state.copyWith(
      transactionType: () => state.transactionType == type ? null : type,
    );
    state = selected.copyWith(price: selected.midPrice);
  }

  void togglePropertyType(PropertyTypeFilterOption option) {
    final isSelected = state.propertyTypes.containsAll(option.types);
    state = state.copyWith(
      propertyTypes: isSelected
          ? state.propertyTypes.difference(option.types)
          : state.propertyTypes.union(option.types),
    );
  }

  void changePrice(double price) {
    state = state.copyWith(price: price);
  }
}
