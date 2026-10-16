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

      case PropertyDetailAction.delete:
        _delete();
    }
  }

  void sendEvent([PropertyDetailEvent? event]) {
    state = state.copyWith(event: () => event);
  }

  void navigate([String? path]) {
    state = state.copyWith(navigateTo: () => path);
  }

  Future<void> _fetch() async {
    final property = await ref.read(propertyUseCaseProvider).get(id);

    if (!ref.mounted) { return; }

    state = property == null
        ? state.copyWith(status: PropertyDetailStatus.notFound)
        : state.copyWith(data: PropertyDetailData.fromDomain(property), status: PropertyDetailStatus.loaded);
  }

  Future<void> _delete() async {
    try {
      await ref.read(propertyUseCaseProvider).delete(id);

      if (!ref.mounted) { return; }

      sendEvent(PropertyDetailEvent.delete);
    } catch (_) {
      if (!ref.mounted) { return; }

      sendEvent(PropertyDetailEvent.failDelete);
    }
  }
}
