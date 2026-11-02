import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_item_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_preview_view_state.dart';

final propertyListVMProvider = NotifierProvider<PropertyListVM, PropertyListViewState>(PropertyListVM.new);

class PropertyListViewState {
  static const int maxPanelResultCount = 5;

  final List<PropertyListItemViewState> items;
  final String query;
  final PropertySearchStatus status;
  final PropertyFilterData filter;
  final String? navigateTo;

  // Desktop Only
  final String? selectId;
  final PropertyPreviewViewState? preview;
  final PropertyPreviewMedia media;

  const PropertyListViewState({
    required this.items,
    this.query = '',
    this.status = PropertySearchStatus.close,
    this.filter = const PropertyFilterData(),
    this.navigateTo,
    this.selectId,
    this.preview,
    this.media = PropertyPreviewMedia.image,
  });

  List<PropertyListItemViewState> get searchResults {
    if (query.isEmpty) { return const []; }

    return items.take(maxPanelResultCount).toList();
  }

  AppBndSearchStatus get bndStatus => status.bndStatus(query: query, isFilterApplied: filter.isApplied);

  PropertyListViewState copyWith({
    List<PropertyListItemViewState>? items,
    String? query,
    PropertySearchStatus? status,
    PropertyFilterData? filter,
    String? navigateTo,
    String? Function()? selectId,
    PropertyPreviewViewState? Function()? preview,
    PropertyPreviewMedia? media,
  }) {
    return PropertyListViewState(
      items: items ?? this.items,
      query: query ?? this.query,
      status: status ?? this.status,
      filter: filter ?? this.filter,
      navigateTo: navigateTo,
      selectId: selectId != null ? selectId() : this.selectId,
      preview: preview != null ? preview() : this.preview,
      media: media ?? this.media,
    );
  }
}

sealed class PropertyListAction {
  const PropertyListAction();

  const factory PropertyListAction.search(String query) = _Search;
  const factory PropertyListAction.select(String id) = _Select;
  const factory PropertyListAction.panel(bool isPresented) = _Panel;
  const factory PropertyListAction.filtering(PropertyFilterData data) = _Filtering;
  const factory PropertyListAction.selectItem(String id) = _SelectItem;
  const factory PropertyListAction.changeMedia(PropertyPreviewMedia media) = _ChangeMedia;
}

class _Search extends PropertyListAction {
  final String query;

  const _Search(this.query);
}

class _Select extends PropertyListAction {
  final String id;

  const _Select(this.id);
}

class _Panel extends PropertyListAction {
  final bool isPresented;

  const _Panel(this.isPresented);
}

class _Filtering extends PropertyListAction {
  final PropertyFilterData data;

  const _Filtering(this.data);
}

// Desktop Only
class _SelectItem extends PropertyListAction {
  final String id;

  const _SelectItem(this.id);
}

// Desktop Only
class _ChangeMedia extends PropertyListAction {
  final PropertyPreviewMedia media;

  const _ChangeMedia(this.media);
}

class PropertyListVM extends Notifier<PropertyListViewState> {
  static const List<PropertyTransactionType> transactionTypeOptions = [
    PropertyTransactionType.rent,
    PropertyTransactionType.depositOnly,
    PropertyTransactionType.buy,
  ];

  static const List<List<PropertyTypeFilterOption>> propertyTypeOptions = [
    [PropertyTypeFilterOption.oneRoom, PropertyTypeFilterOption.twoRoom, PropertyTypeFilterOption.villa],
    [PropertyTypeFilterOption.apartment, PropertyTypeFilterOption.singleMulti, PropertyTypeFilterOption.commercialBuilding],
  ];

  StreamSubscription<List<Property>>? _subscription;

  @override
  PropertyListViewState build() {
    const initial = PropertyListViewState(items: []);

    ref.onDispose(() => _subscription?.cancel());
    _filtering(initial);
    return initial;
  }

  void action(PropertyListAction action) {
    switch (action) {
      case _Search(:final query):
        state = state.copyWith(
          query: query,
          status: state.status == PropertySearchStatus.select ? PropertySearchStatus.close : null,
        );
        _filtering(state);

      case _Select(:final id):
        state = state.copyWith(
          status: PropertySearchStatus.select,
          navigateTo: PropertyDetailRoute(id: id).location,
        );

      case _Panel(:final isPresented):
        state = state.copyWith(status: isPresented ? PropertySearchStatus.open : PropertySearchStatus.close);

      case _Filtering(:final data):
        state = state.copyWith(filter: data);
        _filtering(state);

      case _SelectItem(:final id):
        _selectItem(id);

      case _ChangeMedia(:final media):
        state = state.copyWith(media: media);
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: null);
  }

  void _filtering(PropertyListViewState target) {
    final condition = target.filter.toCondition(target.query);

    _subscription?.cancel();
    _subscription = ref.read(propertyUseCaseProvider).watchFilter(condition).listen((properties) {
      final isSelectRemoved = state.selectId != null && properties.every((property) => property.id != state.selectId);

      state = state.copyWith(
        items: properties.map(PropertyListItemViewState.fromDomain).toList(),
        navigateTo: state.navigateTo,
        selectId: isSelectRemoved ? () => null : null,
        preview: isSelectRemoved ? () => null : null,
      );
    });
  }

  // Desktop Only
  void _selectItem(String id) {
    if (state.selectId == id) {
      state = state.copyWith(selectId: () => null, preview: () => null);
      return;
    }

    state = state.copyWith(selectId: () => id, preview: () => null);
    _fetchPreview(id);
  }
  
  // Desktop Only
  Future<void> _fetchPreview(String id) async {
    final property = await ref.read(propertyUseCaseProvider).get(id);

    if (!ref.mounted || state.selectId != id) { return; }

    state = property == null
        ? state.copyWith(selectId: () => null, preview: () => null)
        : state.copyWith(preview: () => PropertyPreviewViewState.fromDomain(property, imagePath: ref.read(imageStorageProvider).path));
  }
}
