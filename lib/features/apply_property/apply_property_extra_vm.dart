import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_extra_view_state.dart';
import 'package:vine_butler/features/property_list/property_list_event_vm.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';

final applyPropertyExtraVMProvider =
    NotifierProvider<ApplyPropertyExtraVM, ApplyPropertyExtraViewState>(ApplyPropertyExtraVM.new);

sealed class ApplyPropertyExtraAction {
  const ApplyPropertyExtraAction();

  const factory ApplyPropertyExtraAction.selectSuretyInsurance(bool isAvailable) = _SelectSuretyInsurance;
  const factory ApplyPropertyExtraAction.selectLoan(bool hasLoan) = _SelectLoan;
  const factory ApplyPropertyExtraAction.selectParking(bool isAvailable) = _SelectParking;
  const factory ApplyPropertyExtraAction.changeMoveInDate(DateTime date) = _ChangeMoveInDate;
  const factory ApplyPropertyExtraAction.toggleNegotiable() = _ToggleNegotiable;
  const factory ApplyPropertyExtraAction.selectRoomCount(int count) = _SelectRoomCount;
  const factory ApplyPropertyExtraAction.toggleFurniture(String option) = _ToggleFurniture;
  const factory ApplyPropertyExtraAction.changeMemo(String memo) = _ChangeMemo;
  const factory ApplyPropertyExtraAction.save() = _Save;
  const factory ApplyPropertyExtraAction.popNavigation() = _PopNavigation;
}

class _SelectSuretyInsurance extends ApplyPropertyExtraAction {
  final bool isAvailable;

  const _SelectSuretyInsurance(this.isAvailable);
}

class _SelectLoan extends ApplyPropertyExtraAction {
  final bool hasLoan;

  const _SelectLoan(this.hasLoan);
}

class _SelectParking extends ApplyPropertyExtraAction {
  final bool isAvailable;

  const _SelectParking(this.isAvailable);
}

class _ChangeMoveInDate extends ApplyPropertyExtraAction {
  final DateTime date;

  const _ChangeMoveInDate(this.date);
}

class _ToggleNegotiable extends ApplyPropertyExtraAction {
  const _ToggleNegotiable();
}

class _SelectRoomCount extends ApplyPropertyExtraAction {
  final int count;

  const _SelectRoomCount(this.count);
}

class _ToggleFurniture extends ApplyPropertyExtraAction {
  final String option;

  const _ToggleFurniture(this.option);
}

class _ChangeMemo extends ApplyPropertyExtraAction {
  final String memo;

  const _ChangeMemo(this.memo);
}

class _Save extends ApplyPropertyExtraAction {
  const _Save();
}

class _PopNavigation extends ApplyPropertyExtraAction {
  const _PopNavigation();
}

class ApplyPropertyExtraVM extends Notifier<ApplyPropertyExtraViewState> {
  static const List<int> roomCountOptions = [1, 2, 3, 4];

  static const List<String> furnitureOptions = [
    '냉장고',
    '세탁기',
    '옷장',
    '식탁',
    '건조기',
    '에어컨',
    '선풍기',
    '엘리베이터',
    '가스레인지',
    '인덕션',
    '싱크대',
    '책상',
  ];

  @override
  ApplyPropertyExtraViewState build() => const ApplyPropertyExtraViewState();

  void action(ApplyPropertyExtraAction action) {
    switch (action) {
      case _SelectSuretyInsurance(:final isAvailable):
        state = state.copyWith(
          isAvailableSuretyInsurance: () => state.isAvailableSuretyInsurance == isAvailable ? null : isAvailable,
        );
      case _SelectLoan(:final hasLoan):
        state = state.copyWith(hasLoan: () => state.hasLoan == hasLoan ? null : hasLoan);
      case _SelectParking(:final isAvailable):
        state = state.copyWith(isAvailableParking: () => state.isAvailableParking == isAvailable ? null : isAvailable);
      case _ChangeMoveInDate(:final date):
        state = state.copyWith(moveInDate: date);
      case _ToggleNegotiable():
        state = state.copyWith(isMoveInDateNegotiable: !state.isMoveInDateNegotiable);
      case _SelectRoomCount(:final count):
        state = state.copyWith(roomCount: () => state.roomCount == count ? null : count);
      case _ToggleFurniture(:final option):
        final options = {...state.furnitureOptions};
        if (!options.remove(option)) {
          options.add(option);
        }
        state = state.copyWith(furnitureOptions: options);
      case _ChangeMemo(:final memo):
        state = state.copyWith(memo: memo);
      case _Save():
        final mockPropertyId = ref.read(propertyListVMProvider).items.length;
        ref.read(propertyListEventVMProvider.notifier).action(PropertyListEventAction.register(mockPropertyId));
        state = state.copyWith(navigateTo: () => const PropertyListRoute().location);
      case _PopNavigation():
        state = state.copyWith(navigateTo: () => null);
    }
  }
}
