import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_owner_view_state.dart';

final applyPropertyOwnerVMProvider =
    NotifierProvider<ApplyPropertyOwnerVM, ApplyPropertyOwnerViewState>(ApplyPropertyOwnerVM.new);

sealed class ApplyPropertyOwnerAction {
  const ApplyPropertyOwnerAction();
}

class ChangeName extends ApplyPropertyOwnerAction {
  final String name;

  const ChangeName(this.name);
}

class ChangePhone extends ApplyPropertyOwnerAction {
  final String phone;

  const ChangePhone(this.phone);
}

class ApplyPropertyOwnerVM extends Notifier<ApplyPropertyOwnerViewState> {
  @override
  ApplyPropertyOwnerViewState build() => const ApplyPropertyOwnerViewState();

  void action(ApplyPropertyOwnerAction action) {
    switch (action) {
      case ChangeName(:final name):
        state = state.copyWith(name: name);
      case ChangePhone(:final phone):
        state = state.copyWith(phone: phone);
    }
  }
}
