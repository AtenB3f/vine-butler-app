import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_item_view_state.dart';

final propertyListVMProvider = NotifierProvider<PropertyListVM, PropertyListViewState>(PropertyListVM.new);

class PropertyListViewState {
  static const int maxSearchResultCount = 5;

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

    return items
        .where((item) => item.roadAddress.contains(query) || item.jibunAddress.contains(query))
        .take(maxSearchResultCount)
        .toList();
  }

  AppBndSearchStatus get bndStatus {
    if (query.isNotEmpty) { return isSearchCommitted ? AppBndSearchStatus.search : AppBndSearchStatus.enable; }

    return filter.data.isApplied ? AppBndSearchStatus.filter : AppBndSearchStatus.disable;
  }

  PropertyListViewState copyWith({
    String? query,
    bool? isSearchFocused,
    bool? isSearchCommitted,
    PropertyFilterViewState? filter,
    String? navigateTo,
  }) {
    return PropertyListViewState(
      items: items,
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
  const factory PropertyListAction.changeFocus(bool hasFocus) = _ChangeFocus;
  const factory PropertyListAction.selectSearchResult(int id) = _SelectSearchResult;
  const factory PropertyListAction.pushFilter(bool isPresented) = _PushFilter;
  const factory PropertyListAction.filtering(PropertyFilterData data) = _Filtering;
}

class _Search extends PropertyListAction {
  final String query;

  const _Search(this.query);
}

class _ChangeFocus extends PropertyListAction {
  final bool hasFocus;

  const _ChangeFocus(this.hasFocus);
}

class _SelectSearchResult extends PropertyListAction {
  final int id;

  const _SelectSearchResult(this.id);
}

class _PushFilter extends PropertyListAction {
  final bool isPresented;

  const _PushFilter(this.isPresented);
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

  @override
  PropertyListViewState build() => const PropertyListViewState(items: []);

  void action(PropertyListAction action) {
    switch (action) {
      case _Search(:final query):
        state = state.copyWith(query: query, isSearchCommitted: false);

      case _ChangeFocus(:final hasFocus):
        state = state.copyWith(
          isSearchFocused: hasFocus,
          filter: hasFocus ? state.filter.copyWith(isFilterOpen: true) : null,
        );

      case _SelectSearchResult(:final id):
        state = state.copyWith(
          isSearchCommitted: true,
          isSearchFocused: false,
          filter: state.filter.copyWith(isFilterOpen: false),
          navigateTo: PropertyDetailRoute(id: id).location,
        );

      case _PushFilter(:final isPresented):
        state = state.copyWith(filter: state.filter.copyWith(isFilterOpen: isPresented));

      case _Filtering(:final data):
        state = state.copyWith(filter: state.filter.copyWith(data: data));
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: null);
  }
}
