import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';

final propertyDetailVMProvider =
    NotifierProvider.family<PropertyDetailVM, PropertyDetailViewState, String>(PropertyDetailVM.new);

class PropertyDetailVM extends Notifier<PropertyDetailViewState> {
  PropertyDetailVM(this.id);

  final String id;

  @override
  PropertyDetailViewState build() => const PropertyDetailViewState();

  void action(PropertyDetailAction action) {
    switch (action) {
      case PropertyDetailAction.fetch:
        break;

      case PropertyDetailAction.toggleMap:
        state = state.copyWith(isMapVisible: !state.isMapVisible);
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: () => null);
  }

  void pushNavigation(String path) {
    state = state.copyWith(navigateTo: () => path);
  }
}