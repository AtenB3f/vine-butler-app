import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';

final propertyDetailVMProvider =
    NotifierProvider.family<PropertyDetailVM, PropertyDetailViewState, String>(PropertyDetailVM.new);

class PropertyDetailVM extends Notifier<PropertyDetailViewState> {
  PropertyDetailVM(this.id);

  final String id;

  @override
  PropertyDetailViewState build() {
    _fetch();
    return const PropertyDetailViewState();
  }

  void action(PropertyDetailAction action) {
    switch (action) {
      case PropertyDetailAction.fetch:
        _fetch();

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

  Future<void> _fetch() async {
    final property = await ref.read(propertyUseCaseProvider).get(id);

    if (!ref.mounted) { return; }

    state = property == null
        ? state.copyWith(isLoading: false, isNotFound: true)
        : state.copyWith(data: PropertyDetailData.fromDomain(property), isLoading: false, isNotFound: false);
  }
}
