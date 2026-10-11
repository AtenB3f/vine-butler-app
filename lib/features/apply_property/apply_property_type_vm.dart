import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_type_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

final applyPropertyTypeVMProvider = NotifierProvider<ApplyPropertyTypeVM, ApplyPropertyTypeViewState>(ApplyPropertyTypeVM.new);

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

  void selectTransactionType(PropertyTransactionType type) {
    final selected = state.copyWith(
      transactionType: () => state.transactionType == type ? null : type,
    );
    state = selected.copyWith(price: selected.midPrice);
  }

  void selectPropertyType(PropertyTypeFilterOption option) {
    state = state.copyWith(
      propertyType: () => state.propertyType == option ? null : option,
    );
  }

  void changePrice(double price) {
    state = state.copyWith(price: price);
  }

  void changeMonthlyRent(double monthlyRent) {
    state = state.copyWith(monthlyRent: monthlyRent);
  }

  void next() {
    if (!state.isCompleted) {
      return;
    }
    state = state.copyWith(navigateTo: () => const ApplyPropertyAddressRoute().location);
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: () => null);
  }
}
