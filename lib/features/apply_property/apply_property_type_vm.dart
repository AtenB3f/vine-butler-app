import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_type_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

final applyPropertyTypeVMProvider = NotifierProvider<ApplyPropertyTypeVM, ApplyPropertyTypeViewState>(ApplyPropertyTypeVM.new);

sealed class ApplyPropertyTypeAction {
  const ApplyPropertyTypeAction();

  const factory ApplyPropertyTypeAction.selectTransactionType(PropertyTransactionType type) = _SelectTransactionType;
  const factory ApplyPropertyTypeAction.selectPropertyType(PropertyTypeFilterOption option) = _SelectPropertyType;
  const factory ApplyPropertyTypeAction.changePrice(double price) = _ChangePrice;
  const factory ApplyPropertyTypeAction.changeMonthlyRent(double monthlyRent) = _ChangeMonthlyRent;
  const factory ApplyPropertyTypeAction.next() = _Next;
}

class _SelectTransactionType extends ApplyPropertyTypeAction {
  final PropertyTransactionType type;

  const _SelectTransactionType(this.type);
}

class _SelectPropertyType extends ApplyPropertyTypeAction {
  final PropertyTypeFilterOption option;

  const _SelectPropertyType(this.option);
}

class _ChangePrice extends ApplyPropertyTypeAction {
  final double price;

  const _ChangePrice(this.price);
}

class _ChangeMonthlyRent extends ApplyPropertyTypeAction {
  final double monthlyRent;

  const _ChangeMonthlyRent(this.monthlyRent);
}

class _Next extends ApplyPropertyTypeAction {
  const _Next();
}

class ApplyPropertyTypeVM extends Notifier<ApplyPropertyTypeViewState> {
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
  ApplyPropertyTypeViewState build() => ApplyPropertyTypeViewState.initial();

  void action(ApplyPropertyTypeAction action) {
    switch (action) {
      case _SelectTransactionType(:final type):
        final selected = state.copyWith(
          transactionType: () => state.transactionType == type ? null : type,
        );

        final isInRange = selected.price >= selected.minPrice && selected.price <= selected.maxPrice;

        state = isInRange ? selected : selected.copyWith(price: selected.midPrice);

      case _SelectPropertyType(:final option):
        state = state.copyWith(
          propertyType: () => state.propertyType == option ? null : option,
        );

      case _ChangePrice(:final price):
        state = state.copyWith(price: price);

      case _ChangeMonthlyRent(:final monthlyRent):
        state = state.copyWith(monthlyRent: monthlyRent);

      case _Next():
        if (!state.isCompleted) { return; }

        state = state.copyWith(navigateTo: () => const ApplyPropertyAddressRoute().location);
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: () => null);
  }
}
