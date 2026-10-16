import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_event_view_state.dart';

final propertyListEventVMProvider =
    NotifierProvider<PropertyListEventVM, PropertyListEventViewState>(PropertyListEventVM.new);

sealed class PropertyListEventAction {
  const PropertyListEventAction();

  const factory PropertyListEventAction.register(String id) = _Register;
  const factory PropertyListEventAction.clearRegistration() = _ClearRegistration;
}

class _Register extends PropertyListEventAction {
  final String id;

  const _Register(this.id);
}

class _ClearRegistration extends PropertyListEventAction {
  const _ClearRegistration();
}

class PropertyListEventVM extends Notifier<PropertyListEventViewState> {
  @override
  PropertyListEventViewState build() => const PropertyListEventViewState();

  void action(PropertyListEventAction action) {
    switch (action) {
      case _Register(:final id):
        state = state.copyWith(registerId: () => id);

      case _ClearRegistration():
        state = state.copyWith(registerId: () => null);
    }
  }
}
