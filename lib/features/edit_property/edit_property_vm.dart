import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';

final editPropertyVMProvider =
    NotifierProvider.family<EditPropertyVM, EditPropertyViewState, String>(EditPropertyVM.new);

sealed class EditPropertyAction {
  const EditPropertyAction();

  const factory EditPropertyAction.selectTransactionType(PropertyTransactionType type) = _SelectTransactionType;
  const factory EditPropertyAction.changePrice(double price) = _ChangePrice;
  const factory EditPropertyAction.changeMonthlyRent(double monthlyRent) = _ChangeMonthlyRent;
  const factory EditPropertyAction.changeMaintenanceCost(double maintenanceCost) = _ChangeMaintenanceCost;
  const factory EditPropertyAction.changeOwnerName(String name) = _ChangeOwnerName;
  const factory EditPropertyAction.changeOwnerPhone(String phone) = _ChangeOwnerPhone;
  const factory EditPropertyAction.changeMoveInDate(DateTime date) = _ChangeMoveInDate;
  const factory EditPropertyAction.toggleFlexibleMoveInDate() = _ToggleFlexibleMoveInDate;
  const factory EditPropertyAction.selectLoan(bool hasLoan) = _SelectLoan;
  const factory EditPropertyAction.selectParking(bool isAvailable) = _SelectParking;
  const factory EditPropertyAction.selectSuretyInsurance(bool isAvailable) = _SelectSuretyInsurance;
  const factory EditPropertyAction.selectRoomCount(int count) = _SelectRoomCount;
  const factory EditPropertyAction.toggleFurniture(String option) = _ToggleFurniture;
  const factory EditPropertyAction.changeMemo(String memo) = _ChangeMemo;
  const factory EditPropertyAction.save() = _Save;
}

class _SelectTransactionType extends EditPropertyAction {
  final PropertyTransactionType type;

  const _SelectTransactionType(this.type);
}

class _ChangePrice extends EditPropertyAction {
  final double price;

  const _ChangePrice(this.price);
}

class _ChangeMonthlyRent extends EditPropertyAction {
  final double monthlyRent;

  const _ChangeMonthlyRent(this.monthlyRent);
}

class _ChangeMaintenanceCost extends EditPropertyAction {
  final double maintenanceCost;

  const _ChangeMaintenanceCost(this.maintenanceCost);
}

class _ChangeOwnerName extends EditPropertyAction {
  final String name;

  const _ChangeOwnerName(this.name);
}

class _ChangeOwnerPhone extends EditPropertyAction {
  final String phone;

  const _ChangeOwnerPhone(this.phone);
}

class _ChangeMoveInDate extends EditPropertyAction {
  final DateTime date;

  const _ChangeMoveInDate(this.date);
}

class _ToggleFlexibleMoveInDate extends EditPropertyAction {
  const _ToggleFlexibleMoveInDate();
}

class _SelectLoan extends EditPropertyAction {
  final bool hasLoan;

  const _SelectLoan(this.hasLoan);
}

class _SelectParking extends EditPropertyAction {
  final bool isAvailable;

  const _SelectParking(this.isAvailable);
}

class _SelectSuretyInsurance extends EditPropertyAction {
  final bool isAvailable;

  const _SelectSuretyInsurance(this.isAvailable);
}

class _SelectRoomCount extends EditPropertyAction {
  final int count;

  const _SelectRoomCount(this.count);
}

class _ToggleFurniture extends EditPropertyAction {
  final String option;

  const _ToggleFurniture(this.option);
}

class _ChangeMemo extends EditPropertyAction {
  final String memo;

  const _ChangeMemo(this.memo);
}

class _Save extends EditPropertyAction {
  const _Save();
}

class EditPropertyVM extends Notifier<EditPropertyViewState> {
  EditPropertyVM(this.id);

  final String id;

  @override
  EditPropertyViewState build() {
    _fetch();
    return const EditPropertyViewState();
  }

  void action(EditPropertyAction action) {
    switch (action) {
      case _SelectTransactionType(:final type):
        final selected = state.copyWith(transactionType: type);
        final isInRange = selected.price >= selected.minPrice && selected.price <= selected.maxPrice;

        state = isInRange ? selected : selected.copyWith(price: selected.midPrice);

      case _ChangePrice(:final price):
        state = state.copyWith(price: price);

      case _ChangeMonthlyRent(:final monthlyRent):
        state = state.copyWith(monthlyRent: monthlyRent);

      case _ChangeMaintenanceCost(:final maintenanceCost):
        state = state.copyWith(maintenanceCost: maintenanceCost);

      case _ChangeOwnerName(:final name):
        state = state.copyWith(ownerName: name);

      case _ChangeOwnerPhone(:final phone):
        state = state.copyWith(ownerPhone: phone);

      case _ChangeMoveInDate(:final date):
        state = state.copyWith(moveInDate: date);

      case _ToggleFlexibleMoveInDate():
        state = state.copyWith(isFlexibleMoveInDate: !state.isFlexibleMoveInDate);

      case _SelectLoan(:final hasLoan):
        state = state.copyWith(hasLoan: () => state.hasLoan == hasLoan ? null : hasLoan);

      case _SelectParking(:final isAvailable):
        state = state.copyWith(isParkingAvailable: () => state.isParkingAvailable == isAvailable ? null : isAvailable);

      case _SelectSuretyInsurance(:final isAvailable):
        state = state.copyWith(
          isSuretyInsuranceAvailable: () => state.isSuretyInsuranceAvailable == isAvailable ? null : isAvailable,
        );

      case _SelectRoomCount(:final count):
        state = state.copyWith(roomCount: () => state.roomCount == count ? null : count);

      case _ToggleFurniture(:final option):
        final options = {...state.furnitureOptions};

        if (!options.remove(option)) { options.add(option); }

        state = state.copyWith(furnitureOptions: options);

      case _ChangeMemo(:final memo):
        state = state.copyWith(memo: memo);

      case _Save():
        _save();
    }
  }

  /// 주소 화면에서 바꾼 주소를 바로 저장하는 함수
  ///
  /// - return: 저장 성공 여부
  Future<bool> saveAddress(Address address) async {
    final property = state.property;

    if (property == null) { return false; }

    final updated = property.copyWith(address: address);

    try {
      await ref.read(propertyUseCaseProvider).update(updated);
    } catch (_) {
      return false;
    }

    if (!ref.mounted) { return true; }

    state = state.copyWith(property: updated, address: address);
    ref.invalidate(propertyDetailVMProvider(id));
    return true;
  }

  void sendEvent([EditPropertyEvent? event]) {
    state = state.copyWith(event: () => event);
  }

  Future<void> _fetch() async {
    final property = await ref.read(propertyUseCaseProvider).get(id);

    if (!ref.mounted) { return; }

    state = property == null
        ? state.copyWith(status: EditPropertyStatus.notFound)
        : EditPropertyViewState.fromDomain(property);
  }

  Future<void> _save() async {
    final property = state.property;
    final address = state.address;

    if (property == null || address == null) { return; }

    if (!state.isOwnerValid) {
      sendEvent(EditPropertyEvent.invalidOwner);
      return;
    }

    try {
      await ref.read(propertyUseCaseProvider).update(
            property.copyWith(
              owner: Owner(name: state.ownerName.trim(), phone: state.ownerPhone),
              deal: PropertyDeal(
                transactionType: state.transactionType,
                price: state.price.round(),
                monthlyRent: state.isMonthlyRentVisible ? state.monthlyRent.round() : null,
              ),
              address: address,
              maintenanceCost: state.maintenanceCost.round(),
              moveInDate: state.moveInDate,
              isFlexibleMoveInDate: state.isFlexibleMoveInDate,
              hasLoan: state.hasLoan,
              isParkingAvailable: state.isParkingAvailable,
              isSuretyInsuranceAvailable: state.isSuretyInsuranceAvailable,
              roomCount: state.roomCount,
              furnitureOptions: state.furnitureOptions.toList(),
              memo: state.memo.trim(),
            ),
          );

      if (!ref.mounted) { return; }

      ref.invalidate(propertyDetailVMProvider(id));
      sendEvent(EditPropertyEvent.save);
    } catch (_) {
      if (!ref.mounted) { return; }

      sendEvent(EditPropertyEvent.failSave);
    }
  }
}
