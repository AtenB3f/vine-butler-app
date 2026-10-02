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
    if (query.isEmpty) {
      return const [];
    }

    return items
        .where((item) => item.roadAddress.contains(query) || item.jibunAddress.contains(query))
        .take(maxSearchResultCount)
        .toList();
  }

  AppBndSearchStatus get bndStatus {
    if (query.isNotEmpty) {
      return isSearchCommitted ? AppBndSearchStatus.search : AppBndSearchStatus.enable;
    }
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
}

class Search extends PropertyListAction {
  final String query;

  const Search(this.query);
}

class ChangeFocus extends PropertyListAction {
  final bool hasFocus;

  const ChangeFocus(this.hasFocus);
}

class SelectSearchResult extends PropertyListAction {
  final int id;

  const SelectSearchResult(this.id);
}

class PushFilter extends PropertyListAction {
  final bool isPresented;

  const PushFilter(this.isPresented);
}

class Filtering extends PropertyListAction {
  final PropertyFilterData data;

  const Filtering(this.data);
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
  static final List<PropertyListItemViewState> _mockItems = [
    PropertyListItemViewState(
      id: 0,
      amount: 480000000,
      roadAddress: '대방2동 푸르지움 아파트 A102동 1202호',
      jibunAddress: '동작구 대방동 501',
      transactionType: PropertyTransactionType.depositOnly,
      propertyType: PropertyType.apartment,
      tag: const ['24평', '방 2개', '주차가능'],
    ),
    PropertyListItemViewState(
      id: 1,
      amount: 48200000,
      monthlyAmount: 800000,
      roadAddress: '보라매 푸르지움빌리지 402호',
      jibunAddress: '동작구 신대방동 395-12',
      transactionType: PropertyTransactionType.rent,
      propertyType: PropertyType.villa,
      tag: const ['9평', '방 1개', '반려동물O'],
    ),
    PropertyListItemViewState(
      id: 2,
      amount: 948000000,
      roadAddress: '대방2동 푸르지움 아파트 B203동 203호',
      jibunAddress: '동작구 대방동 502',
      transactionType: PropertyTransactionType.buy,
      propertyType: PropertyType.apartment,
      tag: const ['30평', '방 3개', '신축'],
    ),
    PropertyListItemViewState(
      id: 3,
      amount: 520000000,
      roadAddress: '상도4동 푸르지움 아파트 A502동 904호',
      jibunAddress: '동작구 상도동 172-358',
      transactionType: PropertyTransactionType.depositOnly,
      propertyType: PropertyType.apartment,
      tag: const ['24평', '방 2개', '주차가능'],
    ),
    PropertyListItemViewState(
      id: 4,
      amount: 540000000,
      roadAddress: '상도4동 푸르지움 아파트 A502동 1103호',
      jibunAddress: '동작구 상도동 172-358',
      transactionType: PropertyTransactionType.depositOnly,
      propertyType: PropertyType.apartment,
      tag: const ['24평', '방 2개', '반려동물 O'],
    ),
    PropertyListItemViewState(
      id: 5,
      amount: 190000000,
      roadAddress: '상도2동 244-176, B동 302호',
      jibunAddress: '동작구 상도동 244-176',
      transactionType: PropertyTransactionType.depositOnly,
      propertyType: PropertyType.twoRoom,
      tag: const ['24평', '방 2개', '주차가능', '반려동물 O'],
    ),
    PropertyListItemViewState(
      id: 6,
      amount: 48200000,
      monthlyAmount: 800000,
      roadAddress: '상도2동 244-176, B동 102호',
      jibunAddress: '동작구 상도동 244-176',
      transactionType: PropertyTransactionType.rent,
      propertyType: PropertyType.oneRoom,
      tag: const ['9평', '방 1개', '반려동물O'],
    ),
    PropertyListItemViewState(
      id: 7,
      amount: 1648000000,
      roadAddress: '상도2동 244-176, 1층',
      jibunAddress: '동작구 상도동 244-176',
      transactionType: PropertyTransactionType.buy,
      propertyType: PropertyType.commercialBuilding,
      tag: const ['30평', '방 3개', '신축', '반려동물 O'],
    ),
    PropertyListItemViewState(
      id: 8,
      amount: 2680000000,
      roadAddress: '신대방동 숲속마을신동아파밀리에 103동 704호',
      jibunAddress: '동작구 신대방동 717',
      transactionType: PropertyTransactionType.buy,
      propertyType: PropertyType.apartment,
      tag: const ['32평', '방 3개', '주차가능'],
    ),
    PropertyListItemViewState(
      id: 9,
      amount: 680000000,
      roadAddress: '신대방동 숲속마을신동아파밀리에 105동 1502호',
      jibunAddress: '동작구 신대방동 717',
      transactionType: PropertyTransactionType.depositOnly,
      propertyType: PropertyType.apartment,
      tag: const ['32평', '방 3개'],
    ),
    PropertyListItemViewState(
      id: 10,
      amount: 10000000,
      monthlyAmount: 550000,
      roadAddress: '신림동 1532-8, 2층',
      jibunAddress: '관악구 신림동 1532-8',
      transactionType: PropertyTransactionType.rent,
      propertyType: PropertyType.oneRoom,
      tag: const ['7평', '방 1개'],
    ),
    PropertyListItemViewState(
      id: 11,
      amount: 20000000,
      monthlyAmount: 600000,
      roadAddress: '신림동 1532-8, 3층',
      jibunAddress: '관악구 신림동 1532-8',
      transactionType: PropertyTransactionType.rent,
      propertyType: PropertyType.twoRoom,
      tag: const ['12평', '방 2개', '반려동물O'],
    ),
    PropertyListItemViewState(
      id: 12,
      amount: 890000000,
      roadAddress: '봉천동 관악드림타운 112동 803호',
      jibunAddress: '관악구 봉천동 1720',
      transactionType: PropertyTransactionType.buy,
      propertyType: PropertyType.apartment,
      tag: const ['25평', '방 3개', '주차가능'],
    ),
    PropertyListItemViewState(
      id: 13,
      amount: 450000000,
      roadAddress: '봉천동 관악드림타운 120동 1201호',
      jibunAddress: '관악구 봉천동 1720',
      transactionType: PropertyTransactionType.depositOnly,
      propertyType: PropertyType.apartment,
      tag: const ['25평', '방 3개'],
    ),
    PropertyListItemViewState(
      id: 14,
      amount: 1580000000,
      roadAddress: '흑석동 한강센트레빌 101동 1004호',
      jibunAddress: '동작구 흑석동 336',
      transactionType: PropertyTransactionType.buy,
      propertyType: PropertyType.apartment,
      tag: const ['34평', '방 3개', '신축'],
    ),
    PropertyListItemViewState(
      id: 15,
      amount: 1250000000,
      roadAddress: '흑석동 186-3 단독주택',
      jibunAddress: '동작구 흑석동 186-3',
      transactionType: PropertyTransactionType.buy,
      propertyType: PropertyType.single,
      tag: const ['40평', '방 4개', '마당'],
    ),
    PropertyListItemViewState(
      id: 16,
      amount: 250000000,
      roadAddress: '사당동 1029-14, 다세대 201호',
      jibunAddress: '동작구 사당동 1029-14',
      transactionType: PropertyTransactionType.depositOnly,
      propertyType: PropertyType.multi,
      tag: const ['15평', '방 2개'],
    ),
    PropertyListItemViewState(
      id: 17,
      amount: 30000000,
      monthlyAmount: 700000,
      roadAddress: '사당동 1029-14, 다세대 302호',
      jibunAddress: '동작구 사당동 1029-14',
      transactionType: PropertyTransactionType.rent,
      propertyType: PropertyType.multi,
      tag: const ['15평', '방 2개', '반려동물 O'],
    ),
    PropertyListItemViewState(
      id: 18,
      amount: 50000000,
      monthlyAmount: 2500000,
      roadAddress: '노량진동 노량진역 앞 상가 1층',
      jibunAddress: '동작구 노량진동 117-2',
      transactionType: PropertyTransactionType.rent,
      propertyType: PropertyType.commercialBuilding,
      tag: const ['20평', '주차가능'],
    ),
    PropertyListItemViewState(
      id: 19,
      amount: 5000000,
      monthlyAmount: 400000,
      roadAddress: '대방동 대방빌라 B01호',
      jibunAddress: '동작구 대방동 13-7',
      transactionType: PropertyTransactionType.rent,
      propertyType: PropertyType.villa,
      tag: const ['8평', '방 1개'],
    ),
  ];

  @override
  PropertyListViewState build() => PropertyListViewState(items: _mockItems);

  void action(PropertyListAction action) {
    switch (action) {
      case Search(:final query):
        state = state.copyWith(query: query, isSearchCommitted: false);
      case ChangeFocus(:final hasFocus):
        state = state.copyWith(
          isSearchFocused: hasFocus,
          filter: hasFocus ? state.filter.copyWith(isFilterOpen: true) : null,
        );
      case SelectSearchResult(:final id):
        state = state.copyWith(
          isSearchCommitted: true,
          isSearchFocused: false,
          filter: state.filter.copyWith(isFilterOpen: false),
          navigateTo: PropertyDetailRoute(id: id).location,
        );
      case PushFilter(:final isPresented):
        state = state.copyWith(filter: state.filter.copyWith(isFilterOpen: isPresented));
      case Filtering(:final data):
        state = state.copyWith(filter: state.filter.copyWith(data: data));
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: null);
  }
}
