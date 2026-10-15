import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/find_property/presentation/find_property_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

final findPropertyVMProvider = NotifierProvider<FindPropertyVM, FindPropertyViewState>(FindPropertyVM.new);

sealed class FindPropertyAction {
  const FindPropertyAction();

  const factory FindPropertyAction.selectTransactionType(PropertyTransactionType type) = _SelectTransactionType;
  const factory FindPropertyAction.togglePropertyType(PropertyTypeFilterOption option) = _TogglePropertyType;
  const factory FindPropertyAction.changePrice(double price) = _ChangePrice;
}

class _SelectTransactionType extends FindPropertyAction {
  final PropertyTransactionType type;

  const _SelectTransactionType(this.type);
}

class _TogglePropertyType extends FindPropertyAction {
  final PropertyTypeFilterOption option;

  const _TogglePropertyType(this.option);
}

class _ChangePrice extends FindPropertyAction {
  final double price;

  const _ChangePrice(this.price);
}

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

  void action(FindPropertyAction action) {
    switch (action) {
      case _SelectTransactionType(:final type):
        final selected = state.copyWith(
          transactionType: () => state.transactionType == type ? null : type,
        );

        state = selected.copyWith(price: selected.midPrice);

      case _TogglePropertyType(:final option):
        final isSelected = state.propertyTypes.containsAll(option.types);

        state = state.copyWith(
          propertyTypes: isSelected
              ? state.propertyTypes.difference(option.types)
              : state.propertyTypes.union(option.types),
        );

      case _ChangePrice(:final price):
        state = state.copyWith(price: price);
    }
  }
}
