import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_owner_view_state.dart';

final applyPropertyOwnerVMProvider =
    NotifierProvider<ApplyPropertyOwnerVM, ApplyPropertyOwnerViewState>(ApplyPropertyOwnerVM.new);

sealed class ApplyPropertyOwnerAction {
  const ApplyPropertyOwnerAction();

  const factory ApplyPropertyOwnerAction.changeName(String name) = _ChangeName;
  const factory ApplyPropertyOwnerAction.changePhone(String phone) = _ChangePhone;
}

class _ChangeName extends ApplyPropertyOwnerAction {
  final String name;

  const _ChangeName(this.name);
}

class _ChangePhone extends ApplyPropertyOwnerAction {
  final String phone;

  const _ChangePhone(this.phone);
}

class ApplyPropertyOwnerVM extends Notifier<ApplyPropertyOwnerViewState> {
  @override
  ApplyPropertyOwnerViewState build() => const ApplyPropertyOwnerViewState();

  void action(ApplyPropertyOwnerAction action) {
    switch (action) {
      case _ChangeName(:final name):
        state = state.copyWith(name: name);
      case _ChangePhone(:final phone):
        state = state.copyWith(phone: phone);
    }
  }
}
