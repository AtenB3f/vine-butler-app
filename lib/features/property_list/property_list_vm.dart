import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_item_view_state.dart';

final propertyListVMProvider = NotifierProvider<PropertyListVM, PropertyListViewState>(PropertyListVM.new);

class PropertyListViewState {
  static const int maxPanelResultCount = 5;

  final List<PropertyListItemViewState> items;
  final String query;
  final bool isSearchFocused;
  final bool isSearchCommitted;
  final PropertyFilterViewState filter;
  final String? navigateTo;

  const PropertyListViewState({
    required this.items,
    this.query = '',
    this.isSearchFocused = false,
    this.isSearchCommitted = false,
    this.filter = const PropertyFilterViewState(),
    this.navigateTo,
  });

  bool get isSearchResultVisible =>
      query.isNotEmpty && searchResults.isNotEmpty && (isSearchFocused || filter.isFilterOpen);

  bool get isOverlayVisible => filter.isFilterOpen || isSearchResultVisible;

  List<PropertyListItemViewState> get searchResults {
    if (query.isEmpty) { return const []; }

    return items.take(maxPanelResultCount).toList();
  }

  AppBndSearchStatus get bndStatus {
    if (query.isNotEmpty) { return isSearchCommitted ? AppBndSearchStatus.search : AppBndSearchStatus.enable; }

    return filter.data.isApplied ? AppBndSearchStatus.filter : AppBndSearchStatus.disable;
  }

  PropertyListViewState copyWith({
    List<PropertyListItemViewState>? items,
    String? query,
    bool? isSearchFocused,
    bool? isSearchCommitted,
    PropertyFilterViewState? filter,
    String? navigateTo,
  }) {
    return PropertyListViewState(
      items: items ?? this.items,
      query: query ?? this.query,
      isSearchFocused: isSearchFocused ?? this.isSearchFocused,
      isSearchCommitted: isSearchCommitted ?? this.isSearchCommitted,
      filter: filter ?? this.filter,
      navigateTo: navigateTo,
    );
  }
}

sealed class PropertyListAction {
  const PropertyListAction();

  const factory PropertyListAction.search(String query) = _Search;
  const factory PropertyListAction.focus(bool hasFocus) = _Focus;
  const factory PropertyListAction.select(String id) = _Select;
  const factory PropertyListAction.panel(bool isPresented) = _Panel;
  const factory PropertyListAction.filtering(PropertyFilterData data) = _Filtering;
}

class _Search extends PropertyListAction {
  final String query;

  const _Search(this.query);
}

class _Focus extends PropertyListAction {
  final bool hasFocus;

  const _Focus(this.hasFocus);
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
        state = state.copyWith(query: query, isSearchCommitted: false);
        _filtering(state);

      case _Focus(:final hasFocus):
        state = state.copyWith(
          isSearchFocused: hasFocus,
          filter: hasFocus ? state.filter.copyWith(isFilterOpen: true) : null,
        );

      case _Select(:final id):
        state = state.copyWith(
          isSearchCommitted: true,
          isSearchFocused: false,
          filter: state.filter.copyWith(isFilterOpen: false),
          navigateTo: PropertyDetailRoute(id: id).location,
        );

      case _Panel(:final isPresented):
        state = state.copyWith(filter: state.filter.copyWith(isFilterOpen: isPresented));

      case _Filtering(:final data):
        state = state.copyWith(filter: state.filter.copyWith(data: data));
        _filtering(state);
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: null);
  }

  void _filtering(PropertyListViewState target) {
    final filter = target.filter.data;
    final condition = PropertySearchCondition(
      transactionType: filter.transactionType,
      propertyTypes: filter.propertyTypes,
      price: filter.price == PropertyFilterData.maxPrice ? null : filter.price.round(),
      keyword: target.query.trim(),
    );

    _subscription?.cancel();
    _subscription = ref.read(propertyUseCaseProvider).watchFilter(condition).listen((properties) {
      state = state.copyWith(
        items: properties.map(PropertyListItemViewState.fromDomain).toList(),
        navigateTo: state.navigateTo,
      );
    });
  }
}
